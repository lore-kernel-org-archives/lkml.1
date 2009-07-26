Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZGZIZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZGZIZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZGZIZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:25:12 -0400
Received: from www.tglx.de ([62.245.132.106]:41515 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZGZIZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:25:08 -0400
Message-Id: <20090726081556.837412825@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:19:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Pierre Ossman <drzeus@drzeus.cx>
Subject: [Patch RFC 27/37] mmc: Convert "mutex" to semaphore
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=drivers-mmc-card-queue-semaphore-init-instead-of-init-MUTEX.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completions in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>
---
 drivers/mmc/card/queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/mmc/card/queue.c
===================================================================
--- linux-2.6-tip.orig/drivers/mmc/card/queue.c
+++ linux-2.6-tip/drivers/mmc/card/queue.c
@@ -194,7 +194,7 @@ int mmc_init_queue(struct mmc_queue *mq,
 		sg_init_table(mq->sg, host->max_phys_segs);
 	}
 
-	init_MUTEX(&mq->thread_sem);
+	semaphore_init(&mq->thread_sem);
 
 	mq->thread = kthread_run(mmc_queue_thread, mq, "mmcqd");
 	if (IS_ERR(mq->thread)) {


