Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbXI3TS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbXI3TS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 15:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbXI3TSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 15:18:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:16270 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXI3TSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 15:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=d/Zp/kRp8XJZyVXneGGOjc5a6W+a+ilEwGSVNSRNsZcm++xM2VrWH4ULixNIqePtFLot+DTEK24A3ZCPyFyEUj+9DfDRyZm1/DYPFKLlG8jKdy+QR5Nulukr6Fy7JWzGi12aB02yj6bQ0WkbuoE1Xq8L/KoAdxUkFrnUikWZk78=
Subject: Re: [git] CFS-devel, latest code
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 30 Sep 2007 21:18:16 +0200
Message-Id: <1191179896.6417.14.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


and this one,

make dequeue_entity() / enqueue_entity() and update_stats_dequeue() /
update_stats_enqueue() look similar, structure-wise.

zero effect, functionally-wise.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 2674e27..ed75a04 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -366,7 +366,6 @@ update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static inline void
 update_stats_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	update_curr(cfs_rq);
 	/*
 	 * Mark the end of the wait period if dequeueing a
 	 * waiting task:
@@ -493,7 +492,7 @@ static void
 enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 {
 	/*
-	 * Update the fair clock.
+	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
 
@@ -512,6 +511,11 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 {
+	/*
+	 * Update run-time statistics of the 'current'.
+	 */
+	update_curr(cfs_rq);
+
 	update_stats_dequeue(cfs_rq, se);
 	if (sleep) {
 #ifdef CONFIG_SCHEDSTATS
@@ -775,8 +779,7 @@ static void yield_task_fair(struct rq *rq)
 	if (likely(!sysctl_sched_compat_yield)) {
 		__update_rq_clock(rq);
 		/*
-		 * Dequeue and enqueue the task to update its
-		 * position within the tree:
+		 * Update run-time statistics of the 'current'.
 		 */
 		update_curr(cfs_rq);
 

---

