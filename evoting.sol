pragma solidity >=0.4.22 <0.6.0;

contract Elections{
    
    struct Students{
        uint ssid;
        bool voted;
    }
    
    struct Candidates{
        uint csid;
        uint votes;
    }
    
    uint voterCount=0;
    uint candCount=0;
    address owner;
    address [] candAdds;
    address [] voterAdds;
    mapping (address=>Students) ValidVoters;
    mapping (address=>Candidates) Candidate;
    
    constructor() public{
        owner=msg.sender;
    }
    
    modifier Admin(){
        require(
            msg.sender==owner,
            'You are not authorized to add Voter'
        );
        _;
    }
    
    modifier ValidSid(uint _sid){
        require(
            _sid!=0,
            'Invalid Student ID'
        );
        _;
    }
    
    
    modifier hasVoted(address _sad){
        require(
            ValidVoters[_sad].voted!=true,
            'Your vote is already recorded, You cannot vote again'
        );
        _;
    }
    
    modifier Verification(address _cad){
        require(
            ValidVoters[_cad].ssid!=0,
            'Invalid Candidate'
        );
        _;
    }
    
    function addVoter(address _ad,uint _ssid) public Admin() ValidSid(_ssid){
        ValidVoters[_ad].ssid=_ssid;
        ValidVoters[_ad].voted=false;
        voterAdds.push(_ad);
        voterCount++;
        //function close
    }
    
    function addCandidate(address _add) public Verification(_add) Admin(){
        Candidate[_add].csid=ValidVoters[_add].ssid;
        Candidate[_add].votes=0;
        candAdds.push(_add);
        candCount++;
    }
    
    function Vote(address _cadd) public hasVoted(msg.sender) Verification(_cadd) Verification(msg.sender)  {
        address _sadd=msg.sender;
        ValidVoters[_sadd].voted=true;
        Candidate[_cadd].votes++;
    }
    
    function getVoterList() public view returns(address[] memory){
        return voterAdds;
    }
    
    function viewVotingStatus(address _cadd) public view Verification(_cadd) returns(uint){
        return Candidate[_cadd].votes;
    }
    
    function getCandidateCount() public view returns(uint){
        return candCount;
    }
    
    function getVoterCount() public view returns(uint){
        return voterCount;
    }
    
    function declareResult() public view returns(uint){
        if (candCount==0){
            return 0;
        }
        else{
            address a=candAdds[0];
            for(uint i=1;i<candAdds.length;i++){
                if (Candidate[candAdds[i]].votes>Candidate[a].votes){
                    a=candAdds[i];
                }
            }
            return Candidate[a].csid;
        }
    }
    
}
