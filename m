Return-Path: <linux-kernel-owner+w=401wt.eu-S937565AbXHHSkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937565AbXHHSkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761334AbXHHSjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:39:53 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40827 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbXHHSjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:39:52 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 2/7] IB/ehca: Ensure non-existing queues aren't made small queues
Date: Wed, 8 Aug 2007 20:39:49 +0200
User-Agent: KMail/1.8.2
Cc: "\"Hoang-Nam Nguyen\" @dyn-9-152-249-53" 
	<Hoang-Nam.Nguyen@d01av02.pok.ibm.com>,
       raisch@de.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082039.50878.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index cfa83fa..13b61c3 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -600,10 +600,12 @@ static struct ehca_qp *internal_create_qp(
 	parms.rqueue.max_sge = max_recv_sge;
 
 	if (EHCA_BMASK_GET(HCA_CAP_MINI_QP, shca->hca_cap)) {
-		ehca_determine_small_queue(
-			&parms.squeue, max_send_sge, is_llqp);
-		ehca_determine_small_queue(
-			&parms.rqueue, max_recv_sge, is_llqp);
+		if (HAS_SQ(my_qp))
+			ehca_determine_small_queue(
+				&parms.squeue, max_send_sge, is_llqp);
+		if (HAS_RQ(my_qp))
+			ehca_determine_small_queue(
+				&parms.rqueue, max_recv_sge, is_llqp);
 		parms.qp_storage =
 			(parms.squeue.is_small || parms.rqueue.is_small);
 	}
-- 
1.5.2


