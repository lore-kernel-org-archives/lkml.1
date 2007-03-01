Return-Path: <linux-kernel-owner+w=401wt.eu-S1161127AbXCAWvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161127AbXCAWvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161125AbXCAWvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:51:50 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:32832 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161097AbXCAWup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:50:45 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.21 4/6] iw_cxgb3: Squelch logging AE errors.
Date: Thu, 01 Mar 2007 16:50:44 -0600
To: rdreier@cisco.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20070301225044.2373.12275.stgit@dell3.ogc.int>
In-Reply-To: <20070301225036.2373.71668.stgit@dell3.ogc.int>
References: <20070301225036.2373.71668.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Squelch logging AE errors.

Only post one AE error for a given connection in the kernel log.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_ev.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_ev.c b/drivers/infiniband/hw/cxgb3/iwch_ev.c
index 54362af..b406766 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_ev.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_ev.c
@@ -47,12 +47,6 @@ static void post_qp_event(struct iwch_de
 	struct iwch_qp_attributes attrs;
 	struct iwch_qp *qhp;
 
-	printk(KERN_ERR "%s - AE qpid 0x%x opcode %d status 0x%x "
-	       "type %d wrid.hi 0x%x wrid.lo 0x%x \n", __FUNCTION__,
-	       CQE_QPID(rsp_msg->cqe), CQE_OPCODE(rsp_msg->cqe),
-	       CQE_STATUS(rsp_msg->cqe), CQE_TYPE(rsp_msg->cqe),
-	       CQE_WRID_HI(rsp_msg->cqe), CQE_WRID_LOW(rsp_msg->cqe));
-
 	spin_lock(&rnicp->lock);
 	qhp = get_qhp(rnicp, CQE_QPID(rsp_msg->cqe));
 
@@ -73,6 +67,12 @@ static void post_qp_event(struct iwch_de
 		return;
 	}
 
+	printk(KERN_ERR "%s - AE qpid 0x%x opcode %d status 0x%x "
+	       "type %d wrid.hi 0x%x wrid.lo 0x%x \n", __FUNCTION__,
+	       CQE_QPID(rsp_msg->cqe), CQE_OPCODE(rsp_msg->cqe),
+	       CQE_STATUS(rsp_msg->cqe), CQE_TYPE(rsp_msg->cqe),
+	       CQE_WRID_HI(rsp_msg->cqe), CQE_WRID_LOW(rsp_msg->cqe));
+
 	atomic_inc(&qhp->refcnt);
 	spin_unlock(&rnicp->lock);
 
