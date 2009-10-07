Return-Path: <linux-kernel-owner+w=401wt.eu-S934129AbZJGIEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbZJGIEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934063AbZJGIDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:03:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:1895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934062AbZJGIC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195972039"
Message-Id: <20091007074906.488628808@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:59 +0800
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
Subject: [PATCH 41/45] writeback: requeue_io_wait() on pages_skipped inode
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-more_io_wait-d.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use requeue_io_wait() if some pages were skipped due to locked buffers.

Cc: Dave Chinner <david@fromorbit.com> 
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/fs/fs-writeback.c	2009-10-07 14:32:52.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-07 14:32:52.000000000 +0800
@@ -727,7 +727,7 @@ static long writeback_inodes_wb(struct b
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
-			redirty_tail(inode);
+			requeue_io_wait(inode);
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);


