Return-Path: <linux-kernel-owner+w=401wt.eu-S1161161AbXBUUpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161161AbXBUUpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbXBUUpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:45:41 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:44574 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932606AbXBUUpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:45:40 -0500
Subject: [PATCH 2.6.21] iw_cxgb3: Stop the EP Timer on BAD CLOSE.
From: Steve Wise <swise@opengridcomputing.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       openib-general <openib-general@openib.org>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 14:45:39 -0600
Message-Id: <1172090739.27101.39.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the ep timer in ec_status() if the status indicates a
bad close.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index e5442e3..d00e5dd 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1635,6 +1635,7 @@ static int ec_status(struct t3cdev *tdev
 
 		printk(KERN_ERR MOD "%s BAD CLOSE - Aborting tid %u\n",
 		       __FUNCTION__, ep->hwtid);
+		stop_ep_timer(ep);
 		attrs.next_state = IWCH_QP_STATE_ERROR;
 		iwch_modify_qp(ep->com.qp->rhp,
 			       ep->com.qp, IWCH_QP_ATTR_NEXT_STATE,

