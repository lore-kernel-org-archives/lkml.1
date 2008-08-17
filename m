Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbYHQHuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbYHQHuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 03:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYHQHt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 03:49:57 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:52926 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYHQHtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 03:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Lr4nkHH5+VVPFPIwWyumZj1YCJOJ1zWEJqRhsxitEUuJYMk5aZR/zRLsm7tJF7bWXU
         o+w3z9ETYqAb1+8D6XWD3C15HfC1C9ca7HIOpI7SiZrLUljctrX+DaJiDrlVcuouwhRs
         Al2FRJflKGDUYK5UNJxfofpPdotNp775p8u+8=
Message-ID: <e7d8f83e0808170049md6f8141j98393be308f38ad3@mail.gmail.com>
Date: Sun, 17 Aug 2008 17:49:54 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>, "Peter Dolding" <oiaohm@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>, david@lang.hm,
       rmeijer@xs4all.nl, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, "Eric Paris" <eparis@redhat.com>,
       "Rik van Riel" <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, "Pavel Machek" <pavel@suse.cz>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
In-Reply-To: <20080816151714.GA8422@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
	 <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
	 <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>
	 <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
	 <20080815210942.4e342c6c@infradead.org>
	 <e7d8f83e0808152219j50827f49nb9dd48cf44e082d2@mail.gmail.com>
	 <20080816093952.GF22395@mit.edu>
	 <e7d8f83e0808160438y73c5b24cl306144f512ef6013@mail.gmail.com>
	 <20080816151714.GA8422@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 1:17 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Sat, Aug 16, 2008 at 09:38:30PM +1000, Peter Dolding wrote:
>>
>> UDF undelete and unhide options and ISO showassoc  makes more files
>> appear on those formats.  UDF and ISO hidden files are one of the
>> nasties.  AV scans the disk calls it clean.  Remount it with the other
>> options enabled nice little bit of magic hidden infected files could
>> turn up.   Black holed.
>>
>> What is the worst bit about this knowing the luck of this world.
>> Some people will mount the disks/partitions with the option that
>> displays the virus with a OS without a anti-virus because another
>> computer said the disk was clean.
>
> You have this problem anyway, given that AV database updates are
> coming every few hours; so if you scan the disk at noon, and an AV
> update comes at 1pm it may be that there were malware that wasn't
> detected by the noon DB, but will be detected by the 1pm DB.
>
> And for non read-only filesystems (i.e., anything other than UDF and
> ISO), anytime the filesystem is unmounted, the OS is going to have to
> assume that it might have been modified by some other system before it
> was remounted, so realistically you have to rescan after remounting
> anyway, regardless of whether different mount options were in use.
>
> So I draw a very different set of conclusions than yours given your
> obervations of all of the ways that an AV scanner might miss certain
> viruses, due to things like alternate streams that might not be
> visible at the time, snapshotting filesystems where the AV scanner
> might not know how to access past snapshots, and hence miss malware.
>
> I don't believe that this means we have to cram all possible
> filesystem semantics into the core VFS just for the benefit of AV
> scanners.  I believe this shows the ultimate fallacy that AV scanners
> can be foolproof.  It will catch some stuff, but it will never be
> foolproof.  The real right answer to malware are things like not
> encouraging users to run with the equivalent of Windows Administrator
> privileges all the time (or training them to say, "Yeah, Yeah" every
> time the Annoying Vista UAC dialog box comes up and clicking "ok"),
> and using mail user agents that don't auto-run contents as soon as you
> open a mail message in the name of "the user wants functionality, and
> we're going to let them have it" attitude of Microsoft.
>
I am not saying in that it has to be displayed in the normal VFS.  I
am saying provide way to see everything the driver can to the
scanner/HIDS.   Desktop users could find it useful to see what the
real permissions are on disk surface useful for when they are
transferring disks between systems.  HIDS will find it useful for Max
confirm that nothing has been touched since last scan.   White list
scanning finds it useful because they can be sure nothing was missed.

You mentioned the other reason why you want to be under the vfs.   As
you just said every time you mount a file system you have to presume
that its dirty.  What about remount?   Presume its all dirty just
because user changed a option to the filesystem?  Or do we locate
ourself in a location that remount don't equal starting over from
scratch.   Location in the inodes wrong for max effectiveness.   Even
on snapshoting file systems when you change snapshot displayed not
every file has changed.   The Linux File System Driver interface needs
to change.   Sorting out this section of the file system driver
section also would allow like a ISO or UDF to be multi mounted with
different filter options to the vfs.   Reason driver goes up to a
central point then to the vfs so filters that hide files and
permissions could be turned on and off at bind mounts.  The alteration
to make AV work perfectly opens up way more doors.  Including file
system neutral mount filters so that users and group id's on a file
system can be mapped to local user and group id's.  UUID on the
partition could be used to track remove able disks using it.  500 user
on current system might be acting as 1000 user on a remote/removable
disk since the users id on that system that disk owns to is 1000.

Also you are not thinking real world.   Most common reason to be
scanning read only disks on one machine then using it on another not
fully setup is the restoring stage from backups.   This is where you
all ready know what the virus is.   So that the signatures have been
update for viruses created in the last hour  really normally does not
matter for backups a week old.

It is critical for sorting out infected from non infected disks that
scanning for that is fool proof as possible.  Worst nightmare is to
complete a reinstall after a really destructive virus only to have it
do its destruction again.

Logic that scanning will always be needed again due to signatures
needing updates every few hours is foolish.   Please note signatures
updating massively only apply to black list scanning like
anti-viruses.   If I am running white list scanning on those disks
redoing it is not that required unless disk has changed or defect
found in the white list scanning system.  The cases that a white list
system needs updating is far more limited:  New file formats,   New
software,  New approved parts or defect in scanner itself.
Virus/Malware writer creating a new bit of malware really does not
count if the malware fails the white list.  Far less chasing.  100
percent coverage against unknown viruses is possible if you are
prepared to live with the limitations of white list.   There are quite
a few places where the limitations of white list is not a major
problem.

So don't use the idea of the black list flaw against me.   It does not
have to exist we should go after 100 percent scanning since we can go
after white list scanning that can provide 100 percent coverage with
its other issue of blocking some things it should not.  Viruses and
Malware that users themselfs don't install or approve don't even get a
chance against white list scanning.

UAC for Linux are like the selinux systems.  UAC fails against malware
too many windows users get use to clicking yes way too often.  Defect
on the LSM side we must not copy.

Anti-Virus companies are going to have to lift there game stop just
chasing viruses because soon or latter the black list is going to get
that long that its going to be unable to be processed quickly.
Particularly with Linux's still running on 1.5 ghz or smaller
machines.  Instead swap across to the shorter white list to process
and sort.   Quarantining for black list scanning so performance of
machine is hit with the least ammount.   Some areas like email, p2p
for people using formats that should not contain macros or executable
code white list scanning there is all that is needed before either
blocking or asking user if black list scanning should be preformed or
the file just deleted.   Lets close the door's on these malware
writers without hurt end users any more than we have to.  What is the
point of running a full black list across a file the user will delete
because it was not what they thought it was.

Peter Dolding
