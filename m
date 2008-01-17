Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYAQOEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYAQOEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 09:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYAQOEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 09:04:40 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:54984 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbYAQOEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 09:04:39 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 2/4] IB/ehca: Define array to store SMI/GSI QPs
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200801171502.34287.fenkes@de.ibm.com>
In-Reply-To: <200801171502.34287.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1884
Date: Thu, 17 Jan 2008 15:04:32 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801171504.33426.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen at de.ibm.com>

Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c    |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 74d2b72..936580d 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -94,7 +94,7 @@ struct ehca_sma_attr {
 
 struct ehca_sport {
 	struct ib_cq *ibcq_aqp1;
-	struct ib_qp *ibqp_aqp1;
+	struct ib_qp *ibqp_sqp[2];
 	enum ib_port_state port_state;
 	struct ehca_sma_attr saved_attr;
 };
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 6a56d86..cde486c 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -511,7 +511,7 @@ static int ehca_create_aqp1(struct ehca_shca *shca, u32 port)
 	}
 	sport->ibcq_aqp1 = ibcq;
 
-	if (sport->ibqp_aqp1) {
+	if (sport->ibqp_sqp[IB_QPT_GSI]) {
 		ehca_err(&shca->ib_device, "AQP1 QP is already created.");
 		ret = -EPERM;
 		goto create_aqp1;
@@ -537,7 +537,7 @@ static int ehca_create_aqp1(struct ehca_shca *shca, u32 port)
 		ret = PTR_ERR(ibqp);
 		goto create_aqp1;
 	}
-	sport->ibqp_aqp1 = ibqp;
+	sport->ibqp_sqp[IB_QPT_GSI] = ibqp;
 
 	return 0;
 
@@ -550,7 +550,7 @@ static int ehca_destroy_aqp1(struct ehca_sport *sport)
 {
 	int ret;
 
-	ret = ib_destroy_qp(sport->ibqp_aqp1);
+	ret = ib_destroy_qp(sport->ibqp_sqp[IB_QPT_GSI]);
 	if (ret) {
 		ehca_gen_err("Cannot destroy AQP1 QP. ret=%i", ret);
 		return ret;
-- 
1.5.2


