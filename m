Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbYHQI7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbYHQI7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 04:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYHQI7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 04:59:05 -0400
Received: from mail.lang.hm ([64.81.33.126]:41017 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbYHQI7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 04:59:01 -0400
Date: Sun, 17 Aug 2008 01:58:31 -0700 (PDT)
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
In-Reply-To: <e7d8f83e0808170049md6f8141j98393be308f38ad3@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808170130270.12859@asgard.lang.hm>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>  <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>  <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>  <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com> 
 <20080815210942.4e342c6c@infradead.org>  <e7d8f83e0808152219j50827f49nb9dd48cf44e082d2@mail.gmail.com>  <20080816093952.GF22395@mit.edu>  <e7d8f83e0808160438y73c5b24cl306144f512ef6013@mail.gmail.com>  <20080816151714.GA8422@mit.edu>
 <e7d8f83e0808170049md6f8141j98393be308f38ad3@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008, Peter Dolding wrote:

> On Sun, Aug 17, 2008 at 1:17 AM, Theodore Tso <tytso@mit.edu> wrote:
>> On Sat, Aug 16, 2008 at 09:38:30PM +1000, Peter Dolding wrote:
>>>
> I am not saying in that it has to be displayed in the normal VFS.  I
> am saying provide way to see everything the driver can to the
> scanner/HIDS.   Desktop users could find it useful to see what the
> real permissions are on disk surface useful for when they are
> transferring disks between systems.  HIDS will find it useful for Max
> confirm that nothing has been touched since last scan.   White list
> scanning finds it useful because they can be sure nothing was missed.

unless you have a signed file of hashses of the filesystem, and you check 
that all the hashes are the same, you have no way of knowing if the 
filesystem was modified by any other system.

you may be able to detect if OS Y mounted and modified it via notmal 
rules of that OS, but you have no way to know that someone didn't plug the 
drive into an embeded system that spit raw writes out to the drive to just 
modify a single block of data.

> You mentioned the other reason why you want to be under the vfs.   As
> you just said every time you mount a file system you have to presume
> that its dirty.  What about remount?   Presume its all dirty just
> because user changed a option to the filesystem?  Or do we locate
> ourself in a location that remount don't equal starting over from
> scratch.   Location in the inodes wrong for max effectiveness.   Even
> on snapshoting file systems when you change snapshot displayed not
> every file has changed.

this is a policy decision that different people will answer differently. 
put the decision in userspace. if the user/tool thinks that these things 
require a re-scan then they can change the generation number and 
everything will get re-scanned. if not don't change it.

if you want to trust another system to do the scanning for you the 
userspace code needs to work out a way to use the same generation number 
of the different machines.

the underlying mechanism can work in all of these cases. which one you 
choose to use is up to you, and it doesn't matter what you choose, the 
mechanism allows other people to make different choices.

> Logic that scanning will always be needed again due to signatures
> needing updates every few hours is foolish.   Please note signatures
> updating massively only apply to black list scanning like
> anti-viruses.   If I am running white list scanning on those disks
> redoing it is not that required unless disk has changed or defect
> found in the white list scanning system.  The cases that a white list
> system needs updating is far more limited:  New file formats,   New
> software,  New approved parts or defect in scanner itself.
> Virus/Malware writer creating a new bit of malware really does not
> count if the malware fails the white list.  Far less chasing.  100
> percent coverage against unknown viruses is possible if you are
> prepared to live with the limitations of white list.   There are quite
> a few places where the limitations of white list is not a major
> problem.

the mechanism I outlined will work just fine for a whitelist scanner. the 
user can configure it as the first scanner in the stack and to trust it's 
approval completely, and due to the stackable design, you can have thigns 
that fall through the whitelist examined by other software (or blocked, or 
the scanning software can move/delete/change permissions/etc, whatever you 
configure it to do)

> Anti-Virus companies are going to have to lift there game stop just
> chasing viruses because soon or latter the black list is going to get
> that long that its going to be unable to be processed quickly.
> Particularly with Linux's still running on 1.5 ghz or smaller
> machines.

forget the speed of the machines, if you have a tens of TB array can will 
take several days to scan using the full IO bandwith of the system (so 
even longer as a background task), you already can't afford to scan 
everything every update on every system.

however, you may not need to. if a small enough set of files are accessed 
(and you are willing to pay the penalty on the first access of each file) 
you can configure your system to only do on-access scanning. or you can 
choose to do your updates less frequently (which may be appropriate for 
your environment)

> Instead swap across to the shorter white list to process and sort. 
> Quarantining for black list scanning so performance of machine is hit 
> with the least ammount.  Some areas like email, p2p for people using 
> formats that should not contain macros or executable code white list 
> scanning there is all that is needed before either blocking or asking 
> user if black list scanning should be preformed or the file just 
> deleted.  Lets close the door's on these malware writers without hurt 
> end users any more than we have to.  What is the point of running a full 
> black list across a file the user will delete because it was not what 
> they thought it was.

you are arguing with the wrong people here. we are not trying to define 
the future of anti-virus technologies, we are trying to figure out how to 
provide the hooks so that people and companies can go off and do the 
research and experimentation and try different approaches.

the threat model we have been trying to deal with has not included trying 
to scan a drive that will be accessed by another OS to make sure that the 
other OS won't have any problem with it. I'm not sure thats even possible 
(it's like network IDS where you can't just look at the packet fragments, 
you need to duplicate the logic of the destination OS for how those 
fragments are reassembled, when the source isn't available for the target, 
this is reduced to 'best effort')

if you think we should be trying to deal with a different threat model, 
say so and argue threat model vs threat model. you may be right that the 
threat model isn't appropriate and needs to change, but arguing that the 
proposed solutions don't satisfy your threat model without documenting 
what that is doesn't get us anywhere.

David Lang
