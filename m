Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbYAHQHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbYAHQHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760722AbYAHQHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:07:43 -0500
Received: from main.gmane.org ([80.91.229.2]:35504 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbYAHQHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:07:41 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: The ext3 way of journalling
Date: Tue, 8 Jan 2008 16:07:27 +0000 (UTC)
Message-ID: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The ext3 journalling code can be summarised as:

    superblock->last_checked = random();
    sync(superblock)

I hate it: every time Linux crashes, e.g. due to power failure, it takes
almost an hour to boot, because the kernel has decided to corrupt the 
superblock to indicate that it's been years since last file system 
check. And obviously the crappy init system provides no simple way to 
stop the checking, to put it in the background, or whatever. The FOSS 
herd is totally concentrated on creating a WIMP idiot box -- a cheap 
plastic clone of Windows -- instead of fixing such fundamental problems.
Windows, by the way, boots like a blaze compared to woeful Linux crap
(even without the very definition of pure shit: udev, which the crap
known as Linux practically requires these days).

A partial contributor to the slow fsck process is:

    hde: ST3160023AS, ATA DISK drive
    hde: applying pessimistic Seagate errata fix

    # hdparm -t /dev/hde
    /dev/hde:
     Timing buffered disk reads:   48 MB in  3.01 seconds =  15.96 MB/sec

Thank you very much. The disk worked perfectly well without that "fix"
in earlier (2.2 or was it some 2.4?) kernels and, in Windows too. That
raw timing is worse than the _encrypted_ transfer rate I get from other
disks.

One should always indicate the version of software when complaining. Well,

    $ uname -a
    Linux noi 2.6.14 #1 PREEMPT Sun Oct 30 20:18:48 EET 2005 i686 GNU/Linux

I've tried upgrading, and failed: the megatonne monolith with a gazillion
hidden options (and totally worthless make oldconfig) is impossible to
compile these days, and the distros' stock kernel are utter and total crap
that load drivers in wrong order etc., and are difficult to configure
(demanding crap that demands udev to edit their initrds). Not to even
speak of the udev-demanding scsi-mapping insanity of SATA etc. devices
these days.

I've had it with Linux. It's no longer for power users. It's so complex
that it's only for idiot users that are content with the shoddy defaults,
and (paid) developers.

-- 
Tuomo

