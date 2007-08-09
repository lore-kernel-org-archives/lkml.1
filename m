Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbXHIJbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbXHIJbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765789AbXHIJ3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:29:08 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:54060 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764714AbXHIJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:29:04 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH] IB/ehca: Properly report max #SRQs in query_device()
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Thu, 9 Aug 2007 11:28:46 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708091128.49165.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

This patch should apply cleanly on top of Stefan's recent patchset. Please
review and apply for 2.6.23. Thanks.

 drivers/infiniband/hw/ehca/ehca_hca.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index fc19ef9..cf22472 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -93,9 +93,13 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 	props->max_pd          = min_t(int, rblock->max_pd, INT_MAX);
 	props->max_ah          = min_t(int, rblock->max_ah, INT_MAX);
 	props->max_fmr         = min_t(int, rblock->max_mr, INT_MAX);
-	props->max_srq         = 0;
-	props->max_srq_wr      = 0;
-	props->max_srq_sge     = 0;
+
+	if (EHCA_BMASK_GET(HCA_CAP_SRQ, shca->hca_cap)) {
+		props->max_srq         = props->max_qp;
+		props->max_srq_wr      = props->max_qp_wr;
+		props->max_srq_sge     = 3;
+	}
+
 	props->max_pkeys       = 16;
 	props->local_ca_ack_delay
 		= rblock->local_ca_ack_delay;
-- 
1.5.2


