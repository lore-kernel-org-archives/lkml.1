Return-Path: <linux-kernel-owner+w=401wt.eu-S933424AbZJGIOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424AbZJGIOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235AbZJGIOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:14:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:28327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932887AbZJGIAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971143"
Message-Id: <20091007074906.609815859@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:39:00 +0800
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
       <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 42/45] writeback: requeue_io_wait() on blocked inode
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-remove-redirty-blocked.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use requeue_io_wait() if inode is somehow blocked. This includes the
wrapped around range_cyclic case.

CC: Jan Kara <jack@suse.cz> 
CC: Dave Chinner <david@fromorbit.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/fs/fs-writeback.c	2009-10-07 14:32:52.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-07 14:32:53.000000000 +0800
@@ -591,7 +591,7 @@ writeback_single_inode(struct inode *ino
 				/*
 				 * somehow blocked: retry later
 				 */
-				redirty_tail(inode);
+				requeue_io_wait(inode);
 			}
 		} else if (inode->i_state & I_DIRTY) {
 			/*


