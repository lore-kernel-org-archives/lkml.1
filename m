Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYJ3Llc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYJ3Llc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYJ3LlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:41:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58289 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbYJ3LlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:41:23 -0400
Date: Thu, 30 Oct 2008 13:39:43 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: rolandd@cisco.com
cc: general@lists.openfabrics.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/10] rdma/nes: reindent mis-indented spinlocks
In-Reply-To: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0810301336130.7072@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1652815435-1225366783=:7072"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1652815435-1225366783=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/infiniband/hw/nes/nes_verbs.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 932e56f..ffdd141 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -220,14 +220,14 @@ static int nes_bind_mw(struct ib_qp *ibqp, struct ib_mw *ibmw,
 	if (nesqp->ibqp_state > IB_QPS_RTS)
 		return -EINVAL;
 
-		spin_lock_irqsave(&nesqp->lock, flags);
+	spin_lock_irqsave(&nesqp->lock, flags);
 
 	head = nesqp->hwqp.sq_head;
 	qsize = nesqp->hwqp.sq_tail;
 
 	/* Check for SQ overflow */
 	if (((head + (2 * qsize) - nesqp->hwqp.sq_tail) % qsize) == (qsize - 1)) {
-			spin_unlock_irqrestore(&nesqp->lock, flags);
+		spin_unlock_irqrestore(&nesqp->lock, flags);
 		return -EINVAL;
 	}
 
@@ -269,7 +269,7 @@ static int nes_bind_mw(struct ib_qp *ibqp, struct ib_mw *ibmw,
 	nes_write32(nesdev->regs+NES_WQE_ALLOC,
 			(1 << 24) | 0x00800000 | nesqp->hwqp.qp_id);
 
-		spin_unlock_irqrestore(&nesqp->lock, flags);
+	spin_unlock_irqrestore(&nesqp->lock, flags);
 
 	return 0;
 }
@@ -3212,7 +3212,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 	if (nesqp->ibqp_state > IB_QPS_RTS)
 		return -EINVAL;
 
-		spin_lock_irqsave(&nesqp->lock, flags);
+	spin_lock_irqsave(&nesqp->lock, flags);
 
 	head = nesqp->hwqp.sq_head;
 
@@ -3337,7 +3337,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 				(counter << 24) | 0x00800000 | nesqp->hwqp.qp_id);
 	}
 
-		spin_unlock_irqrestore(&nesqp->lock, flags);
+	spin_unlock_irqrestore(&nesqp->lock, flags);
 
 	if (err)
 		*bad_wr = ib_wr;
@@ -3368,7 +3368,7 @@ static int nes_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *ib_wr,
 	if (nesqp->ibqp_state > IB_QPS_RTS)
 		return -EINVAL;
 
-		spin_lock_irqsave(&nesqp->lock, flags);
+	spin_lock_irqsave(&nesqp->lock, flags);
 
 	head = nesqp->hwqp.rq_head;
 
@@ -3421,7 +3421,7 @@ static int nes_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *ib_wr,
 		nes_write32(nesdev->regs+NES_WQE_ALLOC, (counter<<24) | nesqp->hwqp.qp_id);
 	}
 
-		spin_unlock_irqrestore(&nesqp->lock, flags);
+	spin_unlock_irqrestore(&nesqp->lock, flags);
 
 	if (err)
 		*bad_wr = ib_wr;
@@ -3453,7 +3453,7 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 
 	nes_debug(NES_DBG_CQ, "\n");
 
-		spin_lock_irqsave(&nescq->lock, flags);
+	spin_lock_irqsave(&nescq->lock, flags);
 
 	head = nescq->hw_cq.cq_head;
 	cq_size = nescq->hw_cq.cq_size;
@@ -3562,7 +3562,7 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 	nes_debug(NES_DBG_CQ, "Reporting %u completions for CQ%u.\n",
 			cqe_count, nescq->hw_cq.cq_number);
 
-		spin_unlock_irqrestore(&nescq->lock, flags);
+	spin_unlock_irqrestore(&nescq->lock, flags);
 
 	return cqe_count;
 }
-- 
1.5.2.2

---696208474-1652815435-1225366783=:7072--
