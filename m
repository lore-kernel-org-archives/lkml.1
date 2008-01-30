Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYA3HB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYA3HB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYA3HBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:01:19 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42120 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbYA3HBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:01:18 -0500
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.24-git6-ext4-1 patchset released
From: "Theodore Ts'o" <tytso@MIT.EDU>
Phone: (781) 391-3464
Message-Id: <E1JK6ui-0006gI-OR@closure.thunk.org>
Date: Wed, 30 Jan 2008 01:59:16 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released 2.6.24-git6-ext4-1.  It removes the patches that have
been pulled into mainline by Linus, and adds the unlocked ioctl patches
from Andi Kleen, and Eric's patch to allow the root inode to use
in-inode EA's.

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.24-git6-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.24-git6-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.24-git6-ext4-1

                                                - Ted

What's now in the ext4 tree:

Akira Fujita (4):
      ext4: online defrad header file changes
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag -- Move the file data to the new blocks
      Free space fragmentation functions

Alex Tomas (2):
      vfs: add basic delayed allocation support
      ext4: Add basic delayed allocation support

Andi Kleen (7):
      Convert ext2 over to use unlocked_ioctl
      Remove incorrect BKL comment in ext2
      Convert ext3 to use unlocked_ioctl v2
      ext3: Remove incorrect BKL comment
      Remove incorrect comment refering to lock_kernel() from jbd/jbd2
      Convert ext4 to use unlocked_ioctl v2
      Remove incorrect BKL comments in ext4

Aneesh Kumar K.V (2):
      ext4: Enable delalloc and mballoc by default.
      ext4: Show delalloc options

Eric Sandeen (1):
      allow in-inode EAs on ext4 root inode

Mingming Cao (2):
      jbd: blocks reservation fix for large block support
      jbd2: blocks reservation fix for large block support

Theodore Ts'o (2):
      patch test-filesys-flag.patch
      ext4: New inode allocation for FLEX_BG meta-data groups.

 fs/buffer.c                     |    3 
 fs/ext2/dir.c                   |    2 
 fs/ext2/ext2.h                  |    3 
 fs/ext2/file.c                  |    4 
 fs/ext2/inode.c                 |    1 
 fs/ext2/ioctl.c                 |   12 
 fs/ext3/dir.c                   |    4 
 fs/ext3/file.c                  |    2 
 fs/ext3/ioctl.c                 |   12 
 fs/ext4/Makefile                |    2 
 fs/ext4/balloc.c                |   28 
 fs/ext4/defrag.c                | 2206 ++++++++++++++++++++++++++++++++++++++++
 fs/ext4/dir.c                   |    4 
 fs/ext4/extents.c               |   67 -
 fs/ext4/file.c                  |    2 
 fs/ext4/ialloc.c                |   96 +
 fs/ext4/inode.c                 |  174 ++-
 fs/ext4/ioctl.c                 |   25 
 fs/ext4/mballoc.c               |    7 
 fs/ext4/super.c                 |   91 +
 fs/jbd/journal.c                |    7 
 fs/jbd/recovery.c               |    2 
 fs/jbd2/journal.c               |    7 
 fs/jbd2/recovery.c              |    2 
 fs/mpage.c                      |  406 +++++++
 include/linux/ext3_fs.h         |    3 
 include/linux/ext4_fs.h         |  107 +
 include/linux/ext4_fs_extents.h |   22 
 include/linux/ext4_fs_sb.h      |    3 
 include/linux/mpage.h           |    2 
 30 files changed, 3220 insertions(+), 86 deletions(-)
