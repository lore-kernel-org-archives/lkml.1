Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYAYT2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYAYT2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYAYT2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:28:35 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:39211 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYAYT2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:28:34 -0500
To: torvalds@linux-foundation.org
Subject: [git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20080125192758.53A134C9B73@norville.austin.ibm.com>
Date: Fri, 25 Jan 2008 13:27:58 -0600 (CST)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/jfs_dtree.c    |   27 +++++++++++--------------
 fs/jfs/jfs_dtree.h    |    4 +--
 fs/jfs/jfs_imap.c     |    4 +--
 fs/jfs/jfs_logmgr.c   |   34 ++++++++++++++-----------------
 fs/jfs/jfs_metapage.c |   43 ++++++++++++++++++++++------------------
 fs/jfs/jfs_mount.c    |    2 -
 fs/jfs/jfs_umount.c   |    4 +--
 fs/jfs/namei.c        |    4 +--
 fs/jfs/resize.c       |    2 -
 fs/jfs/super.c        |    6 +++++
 10 files changed, 68 insertions(+), 62 deletions(-)

through these ChangeSets:

Commit: 5c5e32ceeb6b64496a1842d5d99e4ac8d20166c4 
Author: Miklos Szeredi <mszeredi@suse.cz> Thu, 24 Jan 2008 16:13:21 -0600 

    mount options: fix jfs
    
    Add iocharset= and errors= options to /proc/mounts for jfs
    filesystems.
    
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: 967c9ec4ec6178bee42f4231c49a3d7f77627978 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Thu, 10 Jan 2008 16:04:25 -0600 

    JFS: simplify types to get rid of sparse warning
    
    jfs_metapage.c was using uints and unsigned ints inconsistently when
    regular ints suffice.
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: da8a41d19233c2bdcc59447aedc808fcdaabf5b7 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Tue, 13 Nov 2007 22:25:41 -0600 

    JFS: FIx one more plain integer as NULL pointer warning
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: 09aaa749f637b19c308464c2b65a001e67c2a16c 
Author: Joe Perches <joe@perches.com> Tue, 13 Nov 2007 22:16:08 -0600 

    JFS: Remove defconfig ptr comparison to 0
    
    Remove sparse warning: Using plain integer as NULL pointer
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: a7fe0ba7eee4f7c53077ff2bed2b581db17d00df 
Author: Shaun Zinck <shaun.zinck@gmail.com> Fri, 31 Aug 2007 12:57:28 -0500 

    JFS: use DIV_ROUND_UP where appropriate
    
    This replaces some macros and code, which do the same thing as DIV_ROUND_UP
    defined in kernel.h, to use the DIV_ROUND_UP macro.
    
    Signed-off-by: Shaun Zinck <shaun.zinck@gmail.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: 1eb3a711d6a1c8a4697a2e89d09048353b8aefd3 
Author: Jack Stone <jack@hawkeye.stone.uk.eu.org> Tue, 31 Jul 2007 09:36:53 -0500 

    Remove unnecessary kmalloc casts in the jfs filesystem
    
    Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: 54af6233d1cb84cdfaa6ea44ea0db0bcf518baac 
Author: Nick Piggin <npiggin@suse.de> Mon, 26 Nov 2007 14:58:10 -0600 

    JFS is missing a memory barrier
    
    JFS is missing a memory barrier needed to close the critical section before
    clearing the lock bit. Use lock bitops for this.
    
    unlock_page() has a second barrier after clearing the lock, which is
    required because it checks whether the waitqueue is active without locks.
    Such a barrier is not required here because the waitqueue spinlock is
    always taken (something to think about if performance is an issue).
    
    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: 67e6682f18b3bf812a994ae027ff87174a297ae8 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Wed, 10 Oct 2007 11:11:24 -0500 

    JFS: Make sure special inode data is written after journal is flushed
    
    This patch makes sure that data that we tried to flush before the journal
    was completely written actually gets pushed to disk.
    
    To avoid duplicating code, moved common code to write_special_inodes().
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: 29a424f28390752a4ca2349633aaacc6be494db5 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Thu, 03 Jan 2008 13:09:33 -0600 

    JFS: clear PAGECACHE_TAG_DIRTY for no-write pages
    
    When JFS decides to drop a dirty metapage, it simply clears the META_dirty
    bit and leave alone the PG_dirty and PAGECACHE_TAG_DIRTY bits.
    
    When such no-write page goes to metapage_writepage(), the `relic'
    PAGECACHE_TAG_DIRTY tag should be cleared, to prevent pdflush from
    repeatedly trying to sync them.  This is done through
    set_page_writeback(), so call it should be called in all cases.  If
    no I/O is initiated, end_page_writeback() should be called immediately.
    
    This is how __block_write_full_page() does things.
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    CC: Fengguang Wu <wfg@mail.ustc.edu.cn>

