Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYJAMUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYJAMUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYJAMTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:19:50 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:35829 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbYJAMTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:19:49 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, general@lists.openfabrics.org
Subject: [PATCH 1/1] IB/ehca: Disallow creating UC QP with SRQ
Date: Wed, 1 Oct 2008 13:06:31 +0200
User-Agent: KMail/1.8.2
Cc: micfaath@de.ibm.com, raisch@de.ibm.com, stefan.roscher@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810011306.31544.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IB/ehca: Disallow creating QP for UC with SRQ

This patch prevents a UC QP to be created with SRQ, since current
firmware does not support this feature.

Signed-off-by: Michael Faath <micfaath@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index b6bcee0..46897cd 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -460,6 +460,12 @@ static struct ehca_qp *internal_create_qp(
 		struct ehca_qp *my_srq =
 			container_of(init_attr->srq, struct ehca_qp, ib_srq);
 
+		if (qp_type == IB_QPT_UC) {
+			ehca_err(pd->device, "UC with SRQ not supported");
+			atomic_dec(&shca->num_qps);
+			return ERR_PTR(-EINVAL);
+		}
+
 		has_srq = 1;
 		parms.ext_type = EQPT_SRQBASE;
 		parms.srq_qpn = my_srq->real_qp_num;
-- 
1.5.5


