Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbYFFQgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbYFFQgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757151AbYFFQgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:36:42 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:9571 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYFFQgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:36:41 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: IB/ehca: Reject send WRs only for RESET, INIT and RTR state
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Fri, 6 Jun 2008 18:35:43 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806061835.43802.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_reqs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index bbe0436..f093b00 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -421,8 +421,10 @@ int ehca_post_send(struct ib_qp *qp,
 	int ret = 0;
 	unsigned long flags;
 
-	if (unlikely(my_qp->state != IB_QPS_RTS)) {
-		ehca_err(qp->device, "QP not in RTS state  qpn=%x", qp->qp_num);
+	/* Reject WR if QP is in RESET, INIT or RTR state */
+	if (unlikely(my_qp->state < IB_QPS_RTS)) {
+		ehca_err(qp->device, "Invalid QP state  qp_state=%d qpn=%x",
+			 my_qp->state, qp->qp_num);
 		return -EINVAL;
 	}
 
-- 
1.5.5


