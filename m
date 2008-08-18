Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbYHRCdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbYHRCdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 22:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYHRCdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 22:33:32 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:56762 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYHRCda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 22:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZcqTpb9Z2jMIi6kHh9MTor0SItteZ8O6zo7tUOZCYPUSQcmCN584CNqqp9wAiUa2Re
         DjOhRQwxLslJ7660n7kySGZQinjrSg7HaQ9oc2ZSeH2uX15qouO1WISc+SDxZR09BwP6
         igYavD6b2PvxjOB9WNgq1jezHKmTt/NF69RgQ=
Message-ID: <e7d8f83e0808171933r25edc712pf656e09fbd387cf3@mail.gmail.com>
Date: Mon, 18 Aug 2008 12:33:28 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: david@lang.hm
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Cc: davecb@sun.com, rmeijer@xs4all.nl, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, "Eric Paris" <eparis@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>, "Rik van Riel" <riel@redhat.com>,
       linux-security-module@vger.kernel.org, "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, "Pavel Machek" <pavel@suse.cz>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0808171839380.12859@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
	 <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
	 <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>
	 <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
	 <48A89551.9050107@sun.com>
	 <e7d8f83e0808171833j3aeda564j43ea4262ec2cea57@mail.gmail.com>
	 <alpine.DEB.1.10.0808171839380.12859@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 11:44 AM,  <david@lang.hm> wrote:
> On Mon, 18 Aug 2008, Peter Dolding wrote:
>
>> On Mon, Aug 18, 2008 at 7:17 AM, David Collier-Brown <davecb@sun.com>
>> wrote:
>>>
>>> Peter Dolding wrote:
>>>>
>>>> Currently if we have a unknown infection on a  windows partition that
>>>> is been shared by linux the scanner on Linux cannot see that the
>>>> windows permissions has been screwed with.   OS with badly damaged
>>>> permissions is a sign of 1 of three things.  ...
>>>
>>> It's more likely that the files will reside on Linux/Unix under
>>> Samba, and so the permissions that Samba implements will be the ones
>>> that the virus is trying to mess up.  These are implemented in
>>> terms of the usual permission bits, plus extended attributes/ACLs.
>>> Linux systems mounting Windows filesystems are somewhat unusual (;-))
>>>
>> More desktop use of Linux more cases of ntfs and fat mounted under
>> Linux.  Funny enough linux mounting windows file systems is 100
>> percent normal for most Ubuntu users so there are a lot of them out
>> there doing it.   I am future looking there are other filesystems
>> coming with there own issues as well.
>
> but what you are missing is that when they are mounted under linux it
> doesn't matter what hidden things the other OS may access, all that matters
> is what Linux sees. If Linux doesn't see something it can't serve it out to
> those other OSs.
>
> those 'hidden things' would only matter if you were trying to use linux to
> scan a drive and bless it for another system to then mount locally. If we
> aren't trying to defend against that (and I don't hear anyone other then you
> saying we should) then we don't need to worry about such things.
>
> If we were trying to make the drive safe for all other OSs to mount
> directly, then mearly seeing everything isn't enough, you would have to be
> able to fully duplicate how the other OS interprets the things you are
> seeing, and know all vunerabilities that arise from all possible
> interpretations. I don't think that's possible (and I don't think it would
> be possible even if the source for all those other OSs were available)
>
Matters directly for 2 cases to the Linux system itself.

First case HIDS spotting alteration to something like if someone
places signature files on a NTFS partition for some reason when it was
placed there it was X permission now its Y better inform the user that
this has happened.     Without being able to see the disk permissions
this could be missed due to no translation of permissions to vfs.  We
have Ubuntu users in this mix they will put it on NTFS if they are low
of disk space.

Second case is file system mount options changing the files that are
displayed in vfs so a full partition scan by a scanner running in
Linux is a full disk scan not some files missed here or there due to
hidden permissions and processing in the file system driver.

Next bits I think is not understanding how some defence tech works and
lack of experience in forensics.

Full hids monitoring does not depend on known how the OS will
interpret it picking up that month after month something has never
been changed and then all of a sudden something is changed to alert
you to look deeper.   Its more of a warning bell so that works without
ever understanding 100 percent how the permissions work.  When
compared to other machines setup in the same kind of way more fine
defects can turn up.  Same software Same applications same profiles
sent from server should be a 99 percent match other than SID number
being different.  Most of that variation from each other should turn
up in the first week of usage.   HIDS is basically anything stepping
out side normal go off.

Doing forensic recoveries on things I have learnt yes you can
duplicate how a OS will interpret its disk permissions.   Complexity
is directly linked to how tidy the OS's permission system is.
Windows is surprisingly not that bad.  Linux and BSD are level 10
pricks due to the fact config file over here may completely provide
access where disk permissions say no then you have the LSM permissions
to over lay.   So its a pain in tail to duplicate how some OS's would
interpret it but 100 percent do able if you know the software on top
even how that reacts is predictable without running it.   Forensic
working out a attack you do it.  Since running the OS only makes the
threat active worse let the threat cover its trail.   Lot of white
listing is performed in the process to confirm that programs have not
been messed with.  So there configuration files processing can be
trusted.  Its simply another myth that it cannot be done.  Off-line
scanning can be done if the scanner is setup for it yes more complex
process having to read stuff like the windows registry that is poorly
documented.   For fully documented OS's 100 its nothing more than
processing time.  Complete work out of course need the applications on
top that is of course documentation of operation again.   So no
magical non understandable stuff here.

Peter Dolding.
