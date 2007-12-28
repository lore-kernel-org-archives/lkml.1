Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbXL1Uno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbXL1Uno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXL1Un3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:43:29 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37040 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbXL1Un2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:28 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 00/30 Unionfs+fsstack updates/fixes/cleanups
Date: Fri, 28 Dec 2007 15:42:34 -0500
Message-Id: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patchsets related to Unionfs.  This is the
second set of patchsets resulting from an lkml review of the entire unionfs
code base (many thanks go to all of those who sent their comments).  The
most significant changes in this set are bug fixes and an overhaul of the
locking in unionfs (many of these fixes are applicable to stacking in
general).

The first two patches in the series are small generic VFS fsstack patches.

These patches were tested (where appropriate) on Linus's 2.6.24 latest code
(as of v2.6.24-rc6-125-g5356f66), MM, as well as the backports to
2.6.{23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs2/3/4, jffs2,
ramfs, tmpfs, cramfs, and squashfs (where available).  Also tested with
LTP-full.  See http://unionfs.filesystems.org/ to download back-ported
unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (27):
      VFS/fs_stack: drop cast on inode passed to i_size_read
      Unionfs: use locking around i_size_write in 32-bit systems
      Unionfs: clarify usage.txt read/write behavior
      Unionfs: interpose cleanup and fix for spliced dentries
      Unionfs: initialize inode times for reused inodes
      Unionfs: create new special files only in first branch
      Unionfs: create new symlinks only in first branch
      Unionfs: release special files on copyup
      Unionfs: remove custom read/write methods
      Unionfs: prevent deadlock in cache coherency
      Unionfs: remove unnecessary conditional inode lock
      Unionfs: remove unnecessary lock when deleting whiteouts
      Unionfs: remove unnecessary lock in read_inode
      Unionfs: remove unnecessary locking in follow-link
      Unionfs: remove unnecessary parent lock in create
      Unionfs: prevent false lockdep warnings in stacking
      Unionfs: implement lockdep classes
      Unionfs: minor code rearrangement in rename
      Unionfs: handle on lower inodes in lookup
      Unionfs: set our superblock a/m/ctime granularity
      Unionfs: update inode times after a successful open
      Unionfs: minor cleanup in check_empty
      Unionfs: initialize namelist variable in rename
      Unionfs: cleanup lower inodes after successful unlink
      Unionfs: don't check dentry on error
      Unionfs: implement d_iput method
      Unionfs: don't check parent dentries

Hugh Dickins (3):
      VFS/fs_stack: use locking around i_size_write in 32-bit systems
      Unionfs: mmap fixes
      Unionfs: restructure unionfs_setattr and fix truncation order

 Documentation/filesystems/unionfs/concepts.txt |   20 
 Documentation/filesystems/unionfs/issues.txt   |   12 
 Documentation/filesystems/unionfs/usage.txt    |   13 
 fs/stack.c                                     |    8 
 fs/unionfs/commonfops.c                        |   22 
 fs/unionfs/copyup.c                            |   16 
 fs/unionfs/dentry.c                            |  101 ++--
 fs/unionfs/dirfops.c                           |    4 
 fs/unionfs/dirhelper.c                         |   11 
 fs/unionfs/fanout.h                            |   14 
 fs/unionfs/file.c                              |   53 --
 fs/unionfs/inode.c                             |  579 ++++++++++++-------------
 fs/unionfs/lookup.c                            |   20 
 fs/unionfs/main.c                              |   19 
 fs/unionfs/mmap.c                              |   33 -
 fs/unionfs/rename.c                            |  114 ++--
 fs/unionfs/subr.c                              |    4 
 fs/unionfs/super.c                             |   31 -
 fs/unionfs/union.h                             |   38 +
 fs/unionfs/unlink.c                            |   31 -
 fs/unionfs/xattr.c                             |   16 
 21 files changed, 608 insertions(+), 551 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
