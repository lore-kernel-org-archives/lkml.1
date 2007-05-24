Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285AbXEXOv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbXEXOv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbXEXOvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:51:14 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:44502 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXEXOvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:51:12 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH] IB/ehca: fix wrong number of send WRs returned
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6092
Date: Thu, 24 May 2007 16:51:08 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705241651.09411.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Roscher <stefan.roscher@de.ibm.com>

Due to a typo, the driver was reporting the wrong number of "actual send
WRs" after ehca_create_qp(). Fixed.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/hcp_if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 7f0beec..5766ae3 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -331,7 +331,7 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 				0);
 	qp->ipz_qp_handle.handle = outs[0];
 	qp->real_qp_num = (u32)outs[1];
-	parms->act_nr_send_sges =
+	parms->act_nr_send_wqes =
 		(u16)EHCA_BMASK_GET(H_ALL_RES_QP_ACT_OUTST_SEND_WR, outs[2]);
 	parms->act_nr_recv_wqes =
 		(u16)EHCA_BMASK_GET(H_ALL_RES_QP_ACT_OUTST_RECV_WR, outs[2]);
-- 
1.5.2


