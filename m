Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYHPLix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYHPLix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 07:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYHPLig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 07:38:36 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:32984 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYHPLie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 07:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o+nWHyLBa5dafwo4z42gAvfDspohQU43zbjCFy0C3iLv71fMziC+0MNyxidaRjwri9
         uj7kQFzGzUrXwTjw0LJDkQIo2dfRRHoBZUaW1NAue7TdTj7eZntWedOAv3VAkNy2aH7/
         wAEzTaOEuDU729BthQC3YtpjLU90CQVmaONPo=
Message-ID: <e7d8f83e0808160438y73c5b24cl306144f512ef6013@mail.gmail.com>
Date: Sat, 16 Aug 2008 21:38:30 +1000
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
In-Reply-To: <20080816093952.GF22395@mit.edu>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 7:39 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Sat, Aug 16, 2008 at 03:19:43PM +1000, Peter Dolding wrote:
>> Lets look at the general disk to memory path.
>>
>> [file system driver]
>> [file system drivers caches]
>> [inode's]  TALPA links in here and basically runs its own scan cache.
>>
>> Long term TALPA need to move from the inode layor down and the design
>> of the file system path needs to change.
>
> Huh?  What are you talking about?  In Linux just about all of the
> serious filesystems the only caching for file data happens in the page
> cache layer.  So what you're saying doesn't make much sense, unless
> you're talking about the user space samba daemon --- but even there,
> Samba doesn't do any shortcut routing of data; as far as I know
> everything goes from Samba, into the filesystem, before it gets served
> out to other clients via Samba back out from the filesystem.  So
> everything goes through the page cache.

These file system caches are internal permissions caching points where
the driver decides what you can and cannot see.  Before conversion to
normal inode structs.  Others have own internal buffers for transfers.
  Yes everything is stored on the page cache but it does not have to
be in any shape you would normally id as a file.  I have a bad habit
of putting buffers and caches in the same box.  Thinking that some
file system drivers are smart enough to use the same buffer if they
get the same request twice.  So even that a file may have been
rejected due to being a virus it can still be sitting around in memory
in a buffer not cleared.
>
>> Reasons
>> 1. That shape even if file system extra permissions are decided to be
>> kept hidden from the rest of Linux anti-virus can scanning can see it
>
> No one else is taking about checking permissions; I thought this was
> all about file *data* that we've been talking about.
>
> If your argument means that we have to take every single
> $Proprietary_OS's wacky permissions system, and push them into to core
> Linux system so the AV system can evaluate it, I'm pretty sure
> everyone is going to vomit all over such a proposal (and over you).
>
Thrown away data is not only Proprietary OS Ted.  There are permssions
on mac amiga and many others but there not the only issues of stuff
being made invisible by the driver.

There are fully documented file systems that have hidden streams you
cannot see without passing them correct flags.

UDF undelete and unhide options and ISO showassoc  makes more files
appear on those formats.  UDF and ISO hidden files are one of the
nasties.  AV scans the disk calls it clean.  Remount it with the other
options enabled nice little bit of magic hidden infected files could
turn up.   Black holed.

What is the worst bit about this knowing the luck of this world.
Some people will mount the disks/partitions with the option that
displays the virus with a OS without a anti-virus because another
computer said the disk was clean.

Ext2/3/4 nouser_xattr and noacl don't remove the permissions just
remove the map threw from the driver.

Now there is also the up coming issues of www.nilfs.org and other
continual snap shotting file systems.   If cannot see the permissions
the filesystem drivers are processing and the data those permissions
are causing to be hidden.  The best you can do at the moment see that
the flags to make the data invisible or visible is set and ask user to
remount drive just so you can scan it.  Continual snap shotting file
systems users are not going to take to being asked to stop what they
are doing so anti-virus can remount the filesystem a few million times
to make sure the disk is clean of viruses.  Virus scanning takes long
enough without doing that.

So either anti-virus companies will have to build custom interfaces
that bugs users to handle UDF ISO and any other continual snap
shotting file system that appears.  Or we improve the core so software
that needs to can see everything on a file system can to the level the
drivers support so when a drive is truly 100 percent scanned it is 100
percent scanned.   No missing files.  Root user really does not help
against hidden files that the driver is hiding due to obeying hidden
permissions.

I was not clear enough.   Some of the hidden permissions that don't
appear in the inode system cause files to disappear from existence on
the file system until that filesystem is mounted with the right
option.   Or in the case of a continual snap shotting filesystem virus
could be still there in a roll back just like windows.  So user
deleting the virus never got rid of it.  So months latter the same
virus can turn up again and again.  If it just happens to line up with
the user have the anti-virus down it gets a second chance that it
should have never got.  Surface scanning from the inode system is
kinda blind to a lot of hidden spots on quite a few file systems.

Some of the hidden permissions can be handy as well for HIDS to tell
if anyone has been on a file system since it was last there too.  If a
not used acl or user xattr been touched someone else has been on the
filesystem since it was last left.

There is a nice void space where viruses can nicely hide out at the
moment.  Issue is more void space is going to be made unless some
system is designed to handle file systems with these non translatable
permissions and options hidden permissions.  Yes currently hack around
issue of posix permissions not providing every option has been adding
a mount option.  More dynamic options for handling the issue of non
translatable permissions should be possible and less user disrupting.

Can you now see the sign of trouble I have been trying and trying to
put into words.   I can see the problem.   Putting it in the right
words has been a battle.

Peter Dolding
