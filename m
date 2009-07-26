Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbZGZIYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbZGZIYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZGZIYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:24:31 -0400
Received: from www.tglx.de ([62.245.132.106]:34147 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbZGZIY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:24:29 -0400
Message-Id: <20090726081556.395690256@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:19:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Christoph Hellwig <hch@lst.de>
Subject: [Patch RFC 24/37] xfs: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=xfs-semaphore-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bp->b_sema claims to be a mutex, but it is a semaphore with non
obvious semantics. Make it a real semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc:  Christoph Hellwig <hch@lst.de>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6-tip.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6-tip/fs/xfs/linux-2.6/xfs_buf.c
@@ -263,7 +263,7 @@ _xfs_buf_initialize(
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_list);
 	INIT_LIST_HEAD(&bp->b_hash_list);
-	init_MUTEX_LOCKED(&bp->b_sema); /* held, no waiters */
+	semaphore_init_locked(&bp->b_sema); /* held, no waiters */
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
 	bp->b_file_offset = range_base;


