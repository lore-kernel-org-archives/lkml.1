Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbXERJM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbXERJM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbXERJMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:12:47 -0400
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:42726 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbXERJMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:12:46 -0400
Date: Fri, 18 May 2007 11:06:04 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
To: linux-kernel@vger.kernel.org, ext3-users@redhat.com
Subject: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted
Message-ID: <20070518090604.GA10841@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I just tried the 2.6.22-r1 candidate to test whether some bug I have 
hit in the past still exists. I did use 2.6.20.6 so far. So, I have 
cleanly rebooted to use the new kernel, after the machine came up I 
tried to mess with the bug, and had to reboot again to play with kernel 
commandline parameters. Unfortunately, on the next reboot fsck was 
schedules on my filesystem after 38 clean mounts. :( And the problem 
started. The fsck found some unused inodes, but probably did not know 
where do they belong to, but it deleted them automagically. Finally, the 
fsck died because it cannot fine some '..' entry.

  Here is retyped what happened as recorded by my camera. ;)


/dev/hda3 has been mounted 38 times without being checked, check forced
HTREE directory inode 1163319 has an invalid root node.
HTREE INDEX CLEARED
Entry '..' in .../??? (5570587) has deleted/unused inode 5570561. 
CLEARED.
/dev/hda3: Entry '..' in .../??? (5570620) has deleted/unused inode 
5570561. CLEARED.
/dev/hda3: Entry '..' in .../??? (5570625) has deleted/unused inode
5570561. CLEARED.
/dev/hda3: Entry '..' in .../??? (5570567) has deleted/unused inode
5570561. CLEARED.
/dev/hda3: Entry '..' in .../??? (5570614) has deleted/unused inode
5570561. CLEARED.
/dev/hda3: Entry '..' in .../??? (5570603) has deleted/unused inode
5570561. CLEARED.
/dev/hda3: Entry '..' in .../??? (5586948) has deleted/unused inode
5570561. CLEARED.
/dev/hda3: Entry '..' in .../??? (5586957) has deleted/unused inode
5570561. CLEARED.
/dev/hda3: Entry '..' in .../??? (5701636) has deleted/unused inode
5570561. CLEARED.
Unconnected directory inode 5570567 (...)

/dev/hda3: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
                  (i.e., without -a or -p options)




  Turning off the power and booting back with 2.6.20.6 and obviously 
running same fsck gives me:

/dev/hda3 contains a file system with errors, check forced.
Missing '..' in direcotry inode 5570587.

/dev/hda3: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
                  (i.e., without -a or -p options)


  What do you recommend me now?

  I cannot say what is the fsck version, but I can tell you this is a 
Gentoo linux box in the ~x86 tree, so whatever is in the "unstable" 
branch. :(

  I do use ext2/ext3 windows driver from http://www.fs-driver.org/ to 
access the filesystem. Even now, when the filesystem should be marked as 
dirty I can access it from windows and see the files. Does the extfs.sys 
ignore the mark? ;) Anyway, since that time there is a directory 
'Recycled' at the top level of the filesystem. ;-)

  I do remember recently that possibly one of the system packages in 
Gentoo installed some kind of a hash into the filesystem, or hashing 
support, something like that. Sorry, I do not remember the details.
Am just think what could have made the fsck think there is something 
wrong.

  I think IO would like to restore the filesystem to the previous stage 
before running the fsck. How can I do it? No, I do not have a backup of 
the filesystem. :(

I subscribed to the email lists but please send me Cc: anyway. Many thanks.
Martin
