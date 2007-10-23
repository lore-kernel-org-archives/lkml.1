Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbXJWWk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbXJWWk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbXJWWgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:51 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49461 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbXJWWgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:49 -0400
To: LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 11/12] NET: fix subqueue bugs
Message-Id: <20071023223646.550241F81B7@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:46 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

net/sched/sch_prio.c: In function ‘prio_dequeue’:
net/sched/sch_prio.c:139: warning: passing argument 2 of ‘netif_subqueue_stopped’ makes pointer from integer without a cast
net/sched/sch_prio.c: In function ‘rr_dequeue’:
net/sched/sch_prio.c:169: warning: passing argument 2 of ‘netif_subqueue_stopped’ makes pointer from integer without a cast

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index abd82fc..de89409 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -136,7 +136,7 @@ prio_dequeue(struct Qdisc* sch)
 		 * pulling an skb.  This way we avoid excessive requeues
 		 * for slower queues.
 		 */
-		if (!netif_subqueue_stopped(sch->dev, (q->mq ? prio : 0))) {
+		if (!__netif_subqueue_stopped(sch->dev, (q->mq ? prio : 0))) {
 			qdisc = q->queues[prio];
 			skb = qdisc->dequeue(qdisc);
 			if (skb) {
@@ -165,7 +165,7 @@ static struct sk_buff *rr_dequeue(struct Qdisc* sch)
 		 * for slower queues.  If the queue is stopped, try the
 		 * next queue.
 		 */
-		if (!netif_subqueue_stopped(sch->dev,
+		if (!__netif_subqueue_stopped(sch->dev,
 					    (q->mq ? q->curband : 0))) {
 			qdisc = q->queues[q->curband];
 			skb = qdisc->dequeue(qdisc);
