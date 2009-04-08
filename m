Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZDHLbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZDHLbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763343AbZDHLXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:23:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56820 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763308AbZDHLXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:23:08 -0400
X-Sasl-enc: FGpk1iJvuem60Va1/nmIPHhpzwQRRSjXcnsJD/xx0Ipc 1239189785
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 17/56] infiniband: Remove void casts
Date: Wed,  8 Apr 2009 12:21:49 +0100
Message-Id: <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 drivers/infiniband/hw/amso1100/c2_cq.c |    4 ++--
 drivers/infiniband/hw/ehca/ehca_irq.c  |    9 ++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_cq.c b/drivers/infiniband/hw/amso1100/c2_cq.c
index bb17cce..f5c45b1 100644
--- a/drivers/infiniband/hw/amso1100/c2_cq.c
+++ b/drivers/infiniband/hw/amso1100/c2_cq.c
@@ -133,7 +133,7 @@ static inline int c2_poll_one(struct c2_dev *c2dev,
 	struct c2_qp *qp;
 	int is_recv = 0;
 
-	ce = (struct c2wr_ce *) c2_mq_consume(&cq->mq);
+	ce = c2_mq_consume(&cq->mq);
 	if (!ce) {
 		return -EAGAIN;
 	}
@@ -146,7 +146,7 @@ static inline int c2_poll_one(struct c2_dev *c2dev,
 	while ((qp =
 		(struct c2_qp *) (unsigned long) ce->qp_user_context) == NULL) {
 		c2_mq_free(&cq->mq);
-		ce = (struct c2wr_ce *) c2_mq_consume(&cq->mq);
+		ce = c2_mq_consume(&cq->mq);
 		if (!ce)
 			return -EAGAIN;
 	}
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 99bcbd7..4b89b79 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -479,13 +479,13 @@ void ehca_tasklet_neq(unsigned long data)
 	struct ehca_eqe *eqe;
 	u64 ret;
 
-	eqe = (struct ehca_eqe *)ehca_poll_eq(shca, &shca->neq);
+	eqe = ehca_poll_eq(shca, &shca->neq);
 
 	while (eqe) {
 		if (!EHCA_BMASK_GET(NEQE_COMPLETION_EVENT, eqe->entry))
 			parse_ec(shca, eqe->entry);
 
-		eqe = (struct ehca_eqe *)ehca_poll_eq(shca, &shca->neq);
+		eqe = ehca_poll_eq(shca, &shca->neq);
 	}
 
 	ret = hipz_h_reset_event(shca->ipz_hca_handle,
@@ -572,8 +572,7 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 	eqe_cnt = 0;
 	do {
 		u32 token;
-		eqe_cache[eqe_cnt].eqe =
-			(struct ehca_eqe *)ehca_poll_eq(shca, eq);
+		eqe_cache[eqe_cnt].eqe = ehca_poll_eq(shca, eq);
 		if (!eqe_cache[eqe_cnt].eqe)
 			break;
 		eqe_value = eqe_cache[eqe_cnt].eqe->entry;
@@ -637,7 +636,7 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 		goto unlock_irq_spinlock;
 	do {
 		struct ehca_eqe *eqe;
-		eqe = (struct ehca_eqe *)ehca_poll_eq(shca, &shca->eq);
+		eqe = ehca_poll_eq(shca, &shca->eq);
 		if (!eqe)
 			break;
 		process_eqe(shca, eqe);
-- 
1.5.4.3

