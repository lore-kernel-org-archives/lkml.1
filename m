Return-Path: <linux-kernel-owner+w=401wt.eu-S1761841AbXF0Pwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841AbXF0Pwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761126AbXF0Pvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:51:41 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:39358 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756687AbXF0Pvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:51:40 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 4/6] iw_cxgb3: ctrl-qp init/clear shouldn't set the gen bit.
Date: Wed, 27 Jun 2007 10:51:40 -0500
To: rdreier@cisco.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, divy@chelsio.com
Message-Id: <20070627155140.24944.61647.stgit@dell3.ogc.int>
In-Reply-To: <20070627155119.24944.44172.stgit@dell3.ogc.int>
References: <20070627155119.24944.44172.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


iw_cxgb3: ctrl-qp init/clear shouldn't set the gen bit.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/cxio_hal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 215bbe5..1518b41 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -144,7 +144,7 @@ static int cxio_hal_clear_qp_ctx(struct 
 	}
 	wqe = (struct t3_modify_qp_wr *) skb_put(skb, sizeof(*wqe));
 	memset(wqe, 0, sizeof(*wqe));
-	build_fw_riwrh((struct fw_riwrh *) wqe, T3_WR_QP_MOD, 3, 1, qpid, 7);
+	build_fw_riwrh((struct fw_riwrh *) wqe, T3_WR_QP_MOD, 3, 0, qpid, 7);
 	wqe->flags = cpu_to_be32(MODQP_WRITE_EC);
 	sge_cmd = qpid << 8 | 3;
 	wqe->sge_cmd = cpu_to_be64(sge_cmd);
@@ -548,7 +548,7 @@ static int cxio_hal_init_ctrl_qp(struct 
 			V_EC_UP_TOKEN(T3_CTL_QP_TID) | F_EC_VALID)) << 32;
 	wqe = (struct t3_modify_qp_wr *) skb_put(skb, sizeof(*wqe));
 	memset(wqe, 0, sizeof(*wqe));
-	build_fw_riwrh((struct fw_riwrh *) wqe, T3_WR_QP_MOD, 0, 1,
+	build_fw_riwrh((struct fw_riwrh *) wqe, T3_WR_QP_MOD, 0, 0,
 		       T3_CTL_QP_TID, 7);
 	wqe->flags = cpu_to_be32(MODQP_WRITE_EC);
 	sge_cmd = (3ULL << 56) | FW_RI_SGEEC_START << 8 | 3;
