Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbXEILtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbXEILtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbXEILsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:48:37 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:24394 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbXEILsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:48:35 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 3/6] IB/ehca: Fix AQP0/1 QP number
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6092
Date: Wed, 9 May 2007 13:48:11 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705091348.12551.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

AQP0/1 should report qp_num={0|1} and the actual QP# should be stored in
struct ehca_qp, not the other way round.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index e21d796..b5bc787 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -523,6 +523,8 @@ struct ib_qp *ehca_create_qp(struct ib_p
 		goto create_qp_exit1;
 	}
 
+	my_qp->ib_qp.qp_num = my_qp->real_qp_num;
+
 	switch (init_attr->qp_type) {
 	case IB_QPT_RC:
 	        if (isdaqp == 0) {
@@ -568,7 +570,7 @@ struct ib_qp *ehca_create_qp(struct ib_p
 			parms.act_nr_recv_wqes = init_attr->cap.max_recv_wr;
 			parms.act_nr_send_sges = init_attr->cap.max_send_sge;
 			parms.act_nr_recv_sges = init_attr->cap.max_recv_sge;
-			my_qp->real_qp_num =
+			my_qp->ib_qp.qp_num =
 				(init_attr->qp_type == IB_QPT_SMI) ? 0 : 1;
 		}
 
@@ -595,7 +597,6 @@ struct ib_qp *ehca_create_qp(struct ib_p
 	my_qp->ib_qp.recv_cq = init_attr->recv_cq;
 	my_qp->ib_qp.send_cq = init_attr->send_cq;
 
-	my_qp->ib_qp.qp_num = my_qp->real_qp_num;
 	my_qp->ib_qp.qp_type = init_attr->qp_type;
 
 	my_qp->qp_type = init_attr->qp_type;
-- 
1.4.2.1


