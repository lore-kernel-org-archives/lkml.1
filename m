Return-Path: <linux-kernel-owner+w=401wt.eu-S934230AbXJPPYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbXJPPYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbXJPPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:24:46 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:63449 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033AbXJPPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:24:45 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 1/5] IB/ehca: Supply QP token for SRQ base QPs
Date: Tue, 16 Oct 2007 17:24:07 +0200
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rolandd@cisco.com>, "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200710161722.29144.fenkes@de.ibm.com>
In-Reply-To: <200710161722.29144.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161724.08286.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Because hardware reports the SRQ token in RWQEs of SRQ base QPs, supply the
base QP token as SRQ token, so we can properly find the SRQ base QP.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index e2bd62b..de18264 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -451,7 +451,6 @@ static struct ehca_qp *internal_create_qp(
 		has_srq = 1;
 		parms.ext_type = EQPT_SRQBASE;
 		parms.srq_qpn = my_srq->real_qp_num;
-		parms.srq_token = my_srq->token;
 	}
 
 	if (is_llqp && has_srq) {
@@ -583,6 +582,9 @@ static struct ehca_qp *internal_create_qp(
 		goto create_qp_exit1;
 	}
 
+	if (has_srq)
+		parms.srq_token = my_qp->token;
+
 	parms.servicetype = ibqptype2servicetype(qp_type);
 	if (parms.servicetype < 0) {
 		ret = -EINVAL;
-- 
1.5.2


