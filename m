Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbXLJLVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbXLJLVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbXLJLVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:21:33 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:30316 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbXLJLVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:21:33 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Return correct #SGEs for SRQ
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Marcus Eder <meder@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Mon, 10 Dec 2007 12:20:57 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712101220.57876.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firmware would round up the number of SGEs to four, because the WQE
structure holds four SGEs. For SRQ, only three are supported, so return a
fixed value instead.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

The patch will apply cleanly on top of Roland's git. Please review and apply
for 2.6.24 -- Thanks!

 drivers/infiniband/hw/ehca/ehca_qp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index dd12668..eff5fb5 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -838,7 +838,7 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 
 	/* copy back return values */
 	srq_init_attr->attr.max_wr = qp_init_attr.cap.max_recv_wr;
-	srq_init_attr->attr.max_sge = qp_init_attr.cap.max_recv_sge;
+	srq_init_attr->attr.max_sge = 3;
 
 	/* drive SRQ into RTR state */
 	mqpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
@@ -1750,7 +1750,7 @@ int ehca_query_srq(struct ib_srq *srq, struct ib_srq_attr *srq_attr)
 	}
 
 	srq_attr->max_wr = qpcb->max_nr_outst_recv_wr - 1;
-	srq_attr->max_sge = qpcb->actual_nr_sges_in_rq_wqe;
+	srq_attr->max_sge = 3;
 	srq_attr->srq_limit = EHCA_BMASK_GET(
 		MQPCB_CURR_SRQ_LIMIT, qpcb->curr_srq_limit);
 
-- 
1.5.2


