Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbZFHTYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbZFHTYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZFHTXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:16 -0400
Received: from thunk.org ([69.25.196.29]:39522 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbZFHTXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:12 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 00/49] Ext4 patches currently queued for mainline
Date: Mon,  8 Jun 2009 15:22:18 -0400
Message-Id: <1244488987-32564-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the patches which I plan to be pushing to Linus as soon as the
merge window opens.  It doesn't include some patches which are blocked
behind Jan Kara's page_mkwrite() patch series to address some problems
across multiple filesystems for filesystems where the pagesize is less
than blocksize and there are races between mmap() and truncate() ---
which currently needs mm review --- and the markers->tracepoint
conversion, which is blocked behind tracing patches in Ingo's tree.

	    	    	     	     	    	    - Ted

Alberto Bertogli (1):
  jbd2: Fix minor typos in comments in fs/jbd2/journal.c

Andreas Dilger (1):
  ext4: super.c whitespace cleanup

Aneesh Kumar K.V (8):
  ext4: Properly initialize the buffer_head state
  vfs: Add BUG_ON for delayed and unwritten flags in submit_bh()
  ext4: Mark the unwritten buffer_head as mapped during write_begin
  ext4: hook fiemap operation for directories
  vfs: Enable FS_IOC_FIEMAP and FIGETBSZ for all filetypes
  ext4: Convert ext4_lock_group to use sb_bgl_lock
  ext4: Avoid leaking blocks after a block allocation failure
  ext4: truncate the file properly if we fail to copy data from
    userspace

Curt Wohlgemuth (1):
  ext4: Make the length of the mb_history file tunable

Eric Sandeen (2):
  ext4: fix for fiemap last-block test
  ext4: Change all super.c messages to print the device

Jan Kara (1):
  ext4: Get rid of EXTEND_DISKSIZE flag of ext4_get_blocks_handle()

Linus Torvalds (1):
  ext3: avoid unnecessary spinlock in critical POSIX ACL path

Manish Katiyar (3):
  ext4: Fix memory leak in ext4_fill_super() in case of a failed mount
  ext3: Fix memory leak in ext3_fill_super() in case of a failed mount
  ext2: Fix memory leak in ext2_fill_super() in case of a failed mount

Theodore Ts'o (29):
  ext4: Fallback to vmalloc if kmalloc can't allocate s_flex_groups
    array
  ext4: Use is_power_of_2() for clarity
  ext4: avoid unnecessary spinlock in critical POSIX ACL path
  ext4: Simplify ext4_commit_super()'s function signature
  ext4: Fix and simplify s_dirt handling
  ext4: Use separate super_operations structure for no_journal
    filesystems
  ext4: Avoid races caused by on-line resizing and SMP memory
    reordering
  ext4: Remove outdated comment about lock_super()
  ext4: ext4_mark_recovery_complete() doesn't need to use lock_super
  ext4: Replace lock/unlock_super() with an explicit lock for the
    orphan list
  ext4: Replace lock/unlock_super() with an explicit lock for resizing
  ext4: Don't avoid using BLOCK_UNINIT block groups in mballoc
  ext4: Move the ext4_i.h header file into ext4.h
  ext4: Move the ext4_sb.h header file into ext4.h
  ext4: Move fs/ext4/namei.h into ext4.h
  ext4: Move fs/ext4/group.h into ext4.h
  ext4: fix the length returned by fiemap for an unallocated extent
  ext4: Simplify function signature for ext4_da_get_block_write()
  ext4: Rename ext4_get_blocks_handle() to be ext4_ind_get_blocks()
  ext4: Rename ext4_get_blocks_wrap() to be ext4_get_blocks()
  ext4: Define a new set of flags for ext4_get_blocks()
  ext4: Add documentation to the ext4_*get_block* functions
  ext4: Add BUG_ON debugging checks to noalloc_get_block_write()
  ext4: Merge ext4_da_get_block_write() into mpage_da_map_blocks()
  ext4: Clean up ext4_get_blocks() so it does not depend on
    bh_result->b_state
  ext4: Add a comprehensive block validity check to ext4_get_blocks()
  ext4: down i_data_sem only for read when walking tree for fiemap
  ext4: remove unused function __ext4_write_dirty_metadata
  ext4: Clean up calls to ext4_get_group_desc()

Toshiyuki Okajima (1):
  ext4: fix dx_map_entry to support 256k directory blocks

Vincent Minet (1):
  ext4: Fix spinlock assertions on UP systems

 fs/buffer.c              |    2 +
 fs/ext2/super.c          |    1 +
 fs/ext3/acl.c            |   13 +-
 fs/ext3/super.c          |    1 +
 fs/ext4/Makefile         |    4 +-
 fs/ext4/acl.c            |   15 +-
 fs/ext4/balloc.c         |   28 +-
 fs/ext4/block_validity.c |  244 ++++++++++++++
 fs/ext4/dir.c            |    3 +-
 fs/ext4/ext4.h           |  354 ++++++++++++++++++--
 fs/ext4/ext4_i.h         |  140 --------
 fs/ext4/ext4_sb.h        |  161 ---------
 fs/ext4/extents.c        |   77 ++---
 fs/ext4/group.h          |   29 --
 fs/ext4/ialloc.c         |   73 ++---
 fs/ext4/inode.c          |  587 ++++++++++++++++++++-------------
 fs/ext4/mballoc.c        |  166 ++++------
 fs/ext4/mballoc.h        |    1 -
 fs/ext4/namei.c          |   27 +-
 fs/ext4/namei.h          |    8 -
 fs/ext4/resize.c         |   36 +-
 fs/ext4/super.c          |  831 ++++++++++++++++++++++++----------------------
 fs/ioctl.c               |   14 +-
 fs/jbd2/journal.c        |    8 +-
 fs/mpage.c               |    6 +-
 25 files changed, 1591 insertions(+), 1238 deletions(-)
 create mode 100644 fs/ext4/block_validity.c
 delete mode 100644 fs/ext4/ext4_i.h
 delete mode 100644 fs/ext4/ext4_sb.h
 delete mode 100644 fs/ext4/group.h
 delete mode 100644 fs/ext4/namei.h

