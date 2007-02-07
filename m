Return-Path: <linux-kernel-owner+w=401wt.eu-S1030363AbXBGNfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030363AbXBGNfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 08:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030342AbXBGNfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 08:35:09 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:48813 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030363AbXBGNfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 08:35:07 -0500
To: torvalds@linux-foundation.org
Subject: [git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20070207133506.4E839837F3@kleikamp.austin.ibm.com>
Date: Wed,  7 Feb 2007 07:35:05 -0600 (CST)
From: shaggy@linux.vnet.ibm.com (Dave Kleikamp)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/inode.c        |    6 ++---
 fs/jfs/jfs_debug.h    |    5 ----
 fs/jfs/jfs_dmap.c     |   16 ++++++-------
 fs/jfs/jfs_imap.c     |   16 ++++++-------
 fs/jfs/jfs_incore.h   |   29 ++++++++++++++++++++++--
 fs/jfs/jfs_lock.h     |    2 -
 fs/jfs/jfs_metapage.c |    2 -
 fs/jfs/jfs_txnmgr.c   |    2 -
 fs/jfs/jfs_xtree.c    |   15 ++++++++++++
 fs/jfs/namei.c        |   48 +++++++++++++++++++++++-----------------
 10 files changed, 92 insertions(+), 49 deletions(-)

through these ChangeSets:

Commit: 7220c0177b45600eef2cfd3e5e57ab5b96f3222c 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Fri, 26 Jan 2007 10:14:36 -0600 

    JFS: Remove incorrect kgdb define
    
    jfs_debug.h uses an incorrect CONFIG_KERNEL_ASSERT ifdef to redefine the
    assert macro for kgdb use.  I believe the code worked a long time ago, but
    today it's not a valid config option.  Since I'm not aware of anybody
    interested in debugging jfs with kgdb, it should just be removed.
    
    Thanks to Robert P. J. Day for reporting this.
    
    Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>

Commit: 4aa0d230c2cfc1ac4bcf7c5466f9943cf14233a9 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Wed, 17 Jan 2007 21:18:35 -0600 

    JFS: call io_schedule() instead of schedule() to avoid deadlock
    
    The introduction of Jens Axboe's explicit i/o plugging patches introduced a
    deadlock in jfs.  This was caused by the process initiating I/O not
    unplugging the queue before waiting on the commit thread.  The commit
    thread itself was waiting for that I/O to complete.  Calling io_schedule()
    rather than schedule() unplugs the I/O queue avoiding the deadlock, and it
    appears to be the right function to call in any case.
    
    Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>

Commit: 82d5b9a7c63054a9a2cd838ffd177697f86e7e34 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Tue, 09 Jan 2007 14:14:48 -0600 

    JFS: Add lockdep annotations
    
    Yeah, it's about time.
    
    Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>

Commit: 17e6afc75ad0150d265a86a8f155b2871f9c07fe 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Tue, 09 Jan 2007 08:57:34 -0600 

    JFS: Avoid BUG() on a damaged file system
    
    On Mon, 2006-12-18 at 19:51 +0100, Eric Sesterhenn wrote:
    > hi,
    >
    > while playing around with fsfuzzer, i got the following oops with jfs:
    >
    > [  851.804875] BUG at fs/jfs/jfs_xtree.c:760
    > assert(!BT_STACK_FULL(btstack))
    > [  851.805179] ------------[ cut here ]------------
    > [  851.805238] kernel BUG at fs/jfs/jfs_xtree.c:760!
    
    JFS should mark the superblock dirty and return an error rather than
    calling BUG().
    
    Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>

