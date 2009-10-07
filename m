Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbZJGIBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbZJGIBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933942AbZJGIBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:58309 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932898AbZJGIBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971290"
Message-Id: <20091007074906.740925056@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:39:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 43/45] writeback: requeue_io_wait() on fs redirtied inode
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-remove-redirty-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an inodes is redirtied by the filesystem, its
dirty time shall not be updated.

Cc: Jan Kara <jack@suse.cz> 
Cc: Dave Chinner <david@fromorbit.com> 
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/fs/fs-writeback.c	2009-10-07 14:32:53.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-07 14:32:54.000000000 +0800
@@ -598,7 +598,7 @@ writeback_single_inode(struct inode *ino
 			 * At least XFS will redirty the inode during the
 			 * writeback (delalloc) and on io completion (isize).
 			 */
-			redirty_tail(inode);
+			requeue_io_wait(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse


