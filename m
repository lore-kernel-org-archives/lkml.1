Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbXDZUVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbXDZUVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbXDZUVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:21:35 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:52548 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755005AbXDZUVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:21:16 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.22 3/5] iw_cxgb3: Initialize cpu_idx field in cpl_close_listserv_req message.
Date: Thu, 26 Apr 2007 15:21:15 -0500
To: rdreier@cisco.com, jeff@garzik.org
Cc: divy@chelsio.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20070426202114.24234.18730.stgit@dell3.ogc.int>
In-Reply-To: <20070426202057.24234.56383.stgit@dell3.ogc.int>
References: <20070426202057.24234.56383.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Initialize cpu_idx field in cpl_close_listserv_req message.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 2d2de9b..a990423 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1187,6 +1187,7 @@ static int listen_stop(struct iwch_liste
 	}
 	req = (struct cpl_close_listserv_req *) skb_put(skb, sizeof(*req));
 	req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
+	req->cpu_idx = 0;
 	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_CLOSE_LISTSRV_REQ, ep->stid));
 	skb->priority = 1;
 	ep->com.tdev->send(ep->com.tdev, skb);
