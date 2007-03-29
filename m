Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbXC2LgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbXC2LgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 07:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXC2LgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 07:36:01 -0400
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:53000 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753332AbXC2LgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 07:36:00 -0400
Message-ID: <460BA48E.4060407@blueyonder.co.uk>
Date: Thu, 29 Mar 2007 12:35:42 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45EFBC73.2030005@blueyonder.co.uk> <46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de> <m17itabbbv.fsf@ebiederm.dsl.xmission.com> <4601DCB4.4060804@blueyonder.co.uk> <20070321184258.758a5a29.randy.dunlap@oracle.com> <20070322105908.GS752@stusta.de> <4608919C.4050007@blueyonder.co.uk> <m1y7liyeyt.fsf@ebiederm.dsl.xmission.com> <4609E04D.408@blueyonder.co.uk> <20070328041407.GM16477@stusta.de>
In-Reply-To: <20070328041407.GM16477@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Mar 28, 2007 at 04:26:05AM +0100, Sid Boyce wrote:
>   
>> Eric W. Biederman wrote:
>>     
>>> Sid Boyce <g3vbv@blueyonder.co.uk> writes:
>>>
>>>  
>>>       
>>>> This is what I've got so far on the first boot, I shall have to check the
>>>> manpage for git-bisect again to see if there is anything else to be added,
>>>> nothing enlightening seen so far - further reboots to be done.
>>>>    
>>>>         
>>> I'm a little confused at what I am seeing below.
>>> Normally what happens is that after a kernel compile and test.  You call
>>> "git-bisect bad" or "git-bisect good" and then git-bisect picks the next
>>> kernel to test.  Then you compile and test that one.  It looks like
>>> you called git-bisect bad several times in a row without testing....
>>>
>>>
>>> Eric
>>>
>>>  
>>>       
>> This is the procedure I followed.
>> <--  snip  -->
>>
>> # install git and cogito on your computer
>>
>> # clone Linus' tree:
>> cg-clone  
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>>
>> # start bisecting:
>> cd linux-2.6
>> git bisect start
>> git bisect bad 86a71dbd3e81e8870d0f0e56b87875f57e58222b
>> git bisect good ac98695d6c1508b724f246f38ce57fb4e3cec356
>>
>> # start round
>> cp /path/to/.config .
>> make oldconfig
>> make
>> # install kernel, check whether it's good or bad, then:
>> git bisect [bad|good]
>> ========================================================
>> I built and installed the kernel downloaded using "cg-clone", booted it 
>> up  and ran "git bisect bad".  I'm also somewhat confused as the first 
>> failing kernel is 2.6.20-git11, the Makefile says the kernel got with 
>> cg-clone is actually 2.6.21-rc4 and it built as  2.6.20-g208367ee.
>> Regards
>> Sid.
>>
>>     
>>>> barrabas:/usr/src/GIT/linux-2.6 # git bisect bad
>>>> Bisecting: 22 revisions left to test after this
>>>> [3fc605a2aa38899c12180ca311f1eeb61a6d867e] knfsd: allow the server to 
>>>> provide a
>>>> gid list when using AUTH_UNIX authentication
>>>> rrabas:/usr/src/GIT/linux-2.6 # git bisect bad
>>>>         
>> ...
>>     
>
> I think I got your problem:
>
> After rebooting, you do "git bisect [bad|good]"  *once*.
>
> Then recompile the kernel from the current tree, reboot, and again
> *once* "git bisect [bad|good]".
>
> etc.
>
> cu
> Adrian
>
>   
If I boot up on 2.6.20-git10 and run "git bisect bad", "git bisect good 
v2.6.20-git10" or "git bisect bad v2.6.20-git11", it says it's not a git 
repo.

I am still no clearer what's required.  If I do "cg-clone" I get 
2.6.21-rc5. The previous one got me 2.6.21-rc4.
The manpages and the tutorials I've looked at are quite cryptic and the 
commands do not produce the expected results.
As indicated above, I followed the instructions bullet by bullet without 
any clear understanding of the tools.
1) Ran the commands as above,cg-clone; git start; git bisect bad 
<checksum>;git bisect good <checksum of 2.6.20-git10 > I presume.
2) 2.6.20-git10 is the last good kernel.
3) 2.6.20-git11 and later are all bad.
4) I do cg-clone which gives a kernel whose Makefile is 2.6.21-rc4 (or 
whatever is current).
5) I get a kernel named 2.6.20-g208367e after make - rebooted and it 
fails the same way as 2.6.20-git11.
6) ran "git bisect bad".
Looking through the directories after cg-clone
barrabas:/ftp/mar07/GIT/linux-2.6 # ls .git/refs/tags/
v2.6.11       v2.6.12-rc5  v2.6.13-rc4  v2.6.14-rc2  v2.6.15-rc2  
v2.6.16      v2.6.16-rc6  v2.6.17-rc5  v2.6.18-rc4  v2.6.19-rc2  
v2.6.20-rc1  v2.6.20-rc7
v2.6.11-tree  v2.6.12-rc6  v2.6.13-rc5  v2.6.14-rc3  v2.6.15-rc3  
v2.6.16-rc1  v2.6.17      v2.6.17-rc6  v2.6.18-rc5  v2.6.19-rc3  
v2.6.20-rc2  v2.6.21-rc1
v2.6.12       v2.6.13      v2.6.13-rc6  v2.6.14-rc4  v2.6.15-rc4  
v2.6.16-rc2  v2.6.17-rc1  v2.6.18      v2.6.18-rc6  v2.6.19-rc4  
v2.6.20-rc3  v2.6.21-rc2
v2.6.12-rc2   v2.6.13-rc1  v2.6.13-rc7  v2.6.14-rc5  v2.6.15-rc5  
v2.6.16-rc3  v2.6.17-rc2  v2.6.18-rc1  v2.6.18-rc7  v2.6.19-rc5  
v2.6.20-rc4  v2.6.21-rc3
v2.6.12-rc3   v2.6.13-rc2  v2.6.14      v2.6.15      v2.6.15-rc6  
v2.6.16-rc4  v2.6.17-rc3  v2.6.18-rc2  v2.6.19      v2.6.19-rc6  
v2.6.20-rc5  v2.6.21-rc4
v2.6.12-rc4   v2.6.13-rc3  v2.6.14-rc1  v2.6.15-rc1  v2.6.15-rc7  
v2.6.16-rc5  v2.6.17-rc4  v2.6.18-rc3  v2.6.19-rc1  v2.6.20      
v2.6.20-rc6  v2.6.21-rc5
barrabas:/ftp/mar07/GIT/linux-2.6 # ls .git/refs/bisect/
bad  good-ac98695d6c1508b724f246f38ce57fb4e3cec356
barrabas:/ftp/mar07/GIT/linux-2.6 # ls .git/refs/heads/
bisect  master  origin
barrabas:/ftp/mar07/GIT/linux-2.6 # less .git/refs/heads/bisect
208367eeec8d6f6fcee1a0672af2149aeee7b658

barrabas:/ftp/mar07/GIT/linux-2.6 # ls .git/branches/

barrabas:/ftp/mar07/GIT/linux-2.6 # ls
arch   COPYING  crypto         drivers  .git        include  ipc     
kernel  .mailmap     Makefile  net     REPORTING-BUGS  security  usr
block  CREDITS  Documentation  fs       .gitignore  init     Kbuild  
lib     MAINTAINERS  mm        README  scripts         sound

# less BISECT_LOG
git-bisect start
# bad: [86a71dbd3e81e8870d0f0e56b87875f57e58222b] sysctl: hide the 
sysctl proc inodes from selinux
git-bisect bad 86a71dbd3e81e8870d0f0e56b87875f57e58222b
# good: [ac98695d6c1508b724f246f38ce57fb4e3cec356] Merge branch 'master' 
of /home/trondmy/kernel/linux-2.6/
git-bisect good ac98695d6c1508b724f246f38ce57fb4e3cec356

Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


