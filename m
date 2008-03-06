Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbYCFBYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbYCFBYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932361AbYCFBSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:18:52 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52554 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933144AbYCFBSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:18:49 -0500
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.25-rc4-ext4-1 released
From: "Theodore Ts'o" <tytso@MIT.EDU>
Phone: (781) 391-3464
Message-Id: <E1JX4kh-0008RT-Lj@closure.thunk.org>
Date: Wed, 05 Mar 2008 20:18:31 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released 2.6.25-rc4-ext4-1.  New/modified patches are marked
with an asterick below.  Use of the soon-to-disappear
generic_commit_write() has been removed.

						- Ted

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.25-rc4-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.25-rc4-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.25-rc4-ext4-1


Akinobu Mita (3):
      ext4: use ext4_group_first_block_no()
      ext4: use ext4_get_group_desc()
      ext4: check ext4_journal_get_write_access() errors

Akira Fujita (4):
      ext4: online defrad header file changes
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag -- Move the file data to the new blocks
      Free space fragmentation functions

Alex Tomas (2):
      vfs: add basic delayed allocation support
      ext4: Add basic delayed allocation support

Andi Kleen (1):
      Convert ext4 to use unlocked_ioctl v2

Aneesh Kumar K.V (9):
      ext4:  Convert list_for_each_rcu() to list_for_each_entry_rcu()
    * ext4: Fix fallocate error path
    * ext4: Enable extent format for symlink.
    * ext4: ENOSPC error handling for writing to an uninitialized extent
    * ext4: Use page_mkwrite vma_operations to get mmap write notification.
    * ext4: zero out small extents when writing to prealloc area.
    * ext4: undo the stable boundary patch changes
      ext4: Enable delalloc and mballoc by default.
      ext4: Show delalloc options

Eric Sandeen (1):
      ext4: reduce mballoc stack usage with noinline

Harvey Harrison (1):
      jbd2: sparse warnings in revoke.c, journal.c

Hisashi Hifumi (1):
      ext4: fdatasync should skip metadata writeout when overwriting

Jose R. Santos (1):
    * ext4: New inode allocation for FLEX_BG meta-data groups.

Josef Bacik (3):
    * ext4: fix mount option parsing
    * jbd2: fix the way the b_modified flag is cleared
    * jbd2: fix possible journal overflow issues

Marcin Slusarz (2):
      ext4: le*_add_cpu conversion
      ext4: convert byte order of constant instead of variable

Mingming Cao (5):
      ext4: remove extra define of ext4_new_blocks_old from mballoc.c
    * ext4: make ext4_xattr_list() static
    * ext4: Handling preallocated blocks in delayed allocation
      jbd: blocks reservation fix for large block support
      jbd2: blocks reservation fix for large block support

Theodore Ts'o (1):
      ext4: Stable/Unstable boundary

 fs/buffer.c                     |    3 +-
 fs/ext4/Makefile                |    2 +-
 fs/ext4/balloc.c                |   41 +-
 fs/ext4/defrag.c                | 2206 +++++++++++++++++++++++++++++++++++++++
 fs/ext4/dir.c                   |    2 +-
 fs/ext4/extents.c               |  266 +++++-
 fs/ext4/file.c                  |   21 +-
 fs/ext4/fsync.c                 |    3 +
 fs/ext4/ialloc.c                |  112 ++-
 fs/ext4/inode.c                 |  216 ++++-
 fs/ext4/ioctl.c                 |   25 +-
 fs/ext4/mballoc.c               |   70 +-
 fs/ext4/namei.c                 |   11 +-
 fs/ext4/resize.c                |    6 +-
 fs/ext4/super.c                 |   84 ++-
 fs/ext4/xattr.c                 |   16 +-
 fs/ext4/xattr.h                 |    7 -
 fs/jbd/journal.c                |    7 +-
 fs/jbd2/commit.c                |   19 +-
 fs/jbd2/journal.c               |   20 +-
 fs/jbd2/revoke.c                |    4 +-
 fs/jbd2/transaction.c           |   34 +-
 fs/mpage.c                      |  406 +++++++
 include/linux/ext4_fs.h         |  101 ++-
 include/linux/ext4_fs_extents.h |   23 +
 include/linux/ext4_fs_sb.h      |    3 +
 include/linux/mpage.h           |    2 +
 27 files changed, 3530 insertions(+), 180 deletions(-)
