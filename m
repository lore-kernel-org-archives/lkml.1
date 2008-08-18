Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYHRAcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYHRAcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 20:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYHRAcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 20:32:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:38915 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbYHRAcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 20:32:35 -0400
Date: Sun, 17 Aug 2008 17:32:35 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Peter Dolding <oiaohm@gmail.com>
cc: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       rmeijer@xs4all.nl, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, Eric Paris <eparis@redhat.com>,
       Rik van Riel <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Pavel Machek <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
In-Reply-To: <e7d8f83e0808171711y3a60b0d2s4e4770bf4c362bc9@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808171718440.12859@asgard.lang.hm>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>  <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>  <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>  <20080815210942.4e342c6c@infradead.org> 
 <e7d8f83e0808152219j50827f49nb9dd48cf44e082d2@mail.gmail.com>  <20080816093952.GF22395@mit.edu>  <e7d8f83e0808160438y73c5b24cl306144f512ef6013@mail.gmail.com>  <20080816151714.GA8422@mit.edu>  <e7d8f83e0808170049md6f8141j98393be308f38ad3@mail.gmail.com> 
 <alpine.DEB.1.10.0808170130270.12859@asgard.lang.hm> <e7d8f83e0808171711y3a60b0d2s4e4770bf4c362bc9@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, Peter Dolding wrote:

> On Sun, Aug 17, 2008 at 6:58 PM,  <david@lang.hm> wrote:
>> On Sun, 17 Aug 2008, Peter Dolding wrote:
>>
>>> On Sun, Aug 17, 2008 at 1:17 AM, Theodore Tso <tytso@mit.edu> wrote:
>>>>
>>>> On Sat, Aug 16, 2008 at 09:38:30PM +1000, Peter Dolding wrote:
>>>>>
>>> I am not saying in that it has to be displayed in the normal VFS.  I
>>> am saying provide way to see everything the driver can to the
>>> scanner/HIDS.   Desktop users could find it useful to see what the
>>> real permissions are on disk surface useful for when they are
>>> transferring disks between systems.  HIDS will find it useful for Max
>>> confirm that nothing has been touched since last scan.   White list
>>> scanning finds it useful because they can be sure nothing was missed.
>>
>> unless you have a signed file of hashses of the filesystem, and you check
>> that all the hashes are the same, you have no way of knowing if the
>> filesystem was modified by any other system.
>
> That is called a HIDS.  Network form even has central databases of
> hashes of applications that should be on the machine.  Its tampering
> detection.

is this what you are asking for or not?

>> you may be able to detect if OS Y mounted and modified it via notmal rules
>> of that OS, but you have no way to know that someone didn't plug the drive
>> into an embeded system that spit raw writes out to the drive to just modify
>> a single block of data.
>
> Exactly why I am saying the lower level needs work.   Everything the
> file system driver can process needs to go to Hids for most effective
> detection of tampering.  Ok not 100 percent but the closest to 100
> percent you can get.   2 causes of failure are hash collisions that
> can happen either way and data hidden outside the drivers reach.   All
> execute data leading into the OS will be covered by a TPM chip in time
> so that will only leave non accessible data not a threat to current
> OS.

so are you advocating that every attempt to access the file should 
calculate the checksum of the file and compare it against a (possibly 
network hosted) list?

>>> You mentioned the other reason why you want to be under the vfs.   As
>>> you just said every time you mount a file system you have to presume
>>> that its dirty.  What about remount?   Presume its all dirty just
>>> because user changed a option to the filesystem?  Or do we locate
>>> ourself in a location that remount don't equal starting over from
>>> scratch.   Location in the inodes wrong for max effectiveness.   Even
>>> on snapshoting file systems when you change snapshot displayed not
>>> every file has changed.
>>
>> this is a policy decision that different people will answer differently. put
>> the decision in userspace. if the user/tool thinks that these things require
>> a re-scan then they can change the generation number and everything will get
>> re-scanned. if not don't change it.
>>
> With out a clear path were user space tools can tell that its the same
> files they have no option bar to mark the complete lot dirty.
>
> Hands are tied that is the issue while only in the inode and vfs
> system.   To untie hands and allow most effective scanning the black
> box of the file system driver has to be opened.

you are mixing solutions and problems. I think my proposal can be used to 
address your problem, even if the implementation is different.

>>> Logic that scanning will always be needed again due to signatures
>>> needing updates every few hours is foolish.   Please note signatures
>>> updating massively only apply to black list scanning like
>>> anti-viruses.   If I am running white list scanning on those disks
>>> redoing it is not that required unless disk has changed or defect
>>> found in the white list scanning system.  The cases that a white list
>>> system needs updating is far more limited:  New file formats,   New
>>> software,  New approved parts or defect in scanner itself.
>>> Virus/Malware writer creating a new bit of malware really does not
>>> count if the malware fails the white list.  Far less chasing.  100
>>> percent coverage against unknown viruses is possible if you are
>>> prepared to live with the limitations of white list.   There are quite
>>> a few places where the limitations of white list is not a major
>>> problem.
>>
>> the mechanism I outlined will work just fine for a whitelist scanner. the
>> user can configure it as the first scanner in the stack and to trust it's
>> approval completely, and due to the stackable design, you can have thigns
>> that fall through the whitelist examined by other software (or blocked, or
>> the scanning software can move/delete/change permissions/etc, whatever you
>> configure it to do)
>>
>>> Anti-Virus companies are going to have to lift there game stop just
>>> chasing viruses because soon or latter the black list is going to get
>>> that long that its going to be unable to be processed quickly.
>>> Particularly with Linux's still running on 1.5 ghz or smaller
>>> machines.
>>
>> forget the speed of the machines, if you have a tens of TB array can will
>> take several days to scan using the full IO bandwith of the system (so even
>> longer as a background task), you already can't afford to scan everything
>> every update on every system.
>>
>> however, you may not need to. if a small enough set of files are accessed
>> (and you are willing to pay the penalty on the first access of each file)
>> you can configure your system to only do on-access scanning. or you can
>> choose to do your updates less frequently (which may be appropriate for your
>> environment)
>>
>
> You missed it part of that was a answer to Ted saying that we should
> give up on a perfect system due to the fact current AV tech fails
> there is other tech out there that works.
>
> In answer to the small enough set of files idea.   The simple issue is
> that one time cost of black list scanning gets longer and longer and
> longer as the black list gets longer and longer and longer.   Sooner
> or latter its going to be longer than the amount of time people are
> prepared to wait for a file to be approved and longer than the time
> taken to white list scan the file by a large margin.  It is already
> longer by a large margin to white list scanning.    CPU sizes not
> expanding as fast on Linux kind brings the black list o heck problem
> sooner.   Lot of anti-virus black lists are embeding white lists
> methods so they can operate now inside the time window.   The wall is
> coming and its simply not avoidable all they are currently doing is
> just stopping themselves from going splat into it.  White list methods
> will have to become more dominate one day there is no other path
> forward for scanning content.
>
> Most common reason to need to be sure disks are clean on a different
> machine is after a mess.   Anti-Virus and protection tech has let you
> down.   Backups could be infected before restoring scanning those
> backups to sort out what files you can salvage and what backups
> predate the infection or breach.   These backups of course are
> normally not scanned on the destination machine.   Missing anything
> scanning those backups in not acceptable ever.
>
> By the way for people who don't know the differences.  TPM is a HIDS
> hardware support it must know the files its protecting exactly.
> White list scanning covers a lot more than just HIDS.   White List
> scanners that knows file formats themselves sorts the files by unknown
> format, damaged ie not to format like containing buffer oversize and
> the like, Containing executable parts unknown, Containing only
> executable parts known safe and 100 percent safe.  First 3 are blocked
> by while list scanners last 2 are approved.   Getting past a white
> list scanner is hard.   White list scanning is the major reason we
> need all formats to documents used in business so they can be scanned
> white list style.   White List format style does not fall pray to
> checksum collisions.  Also when you have TB's and PB of data you don't
> want to be storing damaged files or viruses.   Most black list
> scanners only point out viruses some viruses so are poor compared to
> what some forms of white list scanning offer of trust able clean and
> undamaged.

the scanning support mechanism would support a whitelist policy, it will 
also support a blacklist policy.

I will dispute your claim that a strict whitelist policy is even possible 
on a general machine. how can you know if a binary that was compiled is 
safe or not? how can you tell if a program downloaded from who knows where 
is safe or not? the answer is that you can't. you can know that the 
program isn't from a trusted source and take actions to limit what it can 
do (SELinux style), or you can block the access entirely (which will just 
cause people to disable your whitelist when it gets in their way)

there are times when a whitelist is reasonable, there are times when it 
isn't. you can't whitelist the contents of /var/log/apache/access.log, but 
that file needs to be scanned as it is currently being used as an attack 
vector.

the approach I documented (note: I didn't create it, I assembled it from 
pieces of different proposals on the list) uses kernel support to cache 
the results of the scan so that people _don't_ have to wait for all the 
scans to take place when they open a file each time. they don't even need 
to wait for a checksum pass to see if the file was modified or not.

I fail to see why it couldn't be used for your whitelist approach.

David Lang
