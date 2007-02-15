Return-Path: <linux-kernel-owner+w=401wt.eu-S965562AbXBOOtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965562AbXBOOtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965522AbXBOOtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:49:06 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:37899 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965562AbXBOOtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:49:04 -0500
Subject: [PATCH] 2.6.21 iw_cxgb3 Fail posts synchronously when in TERMINATE
	state.
From: Steve Wise <swise@opengridcomputing.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: openib-general <openib-general@openib.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain
Date: Thu, 15 Feb 2007 08:49:02 -0600
Message-Id: <1171550942.13282.5.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

Fail posts synchronously when in TERMINATE state.

For T3B devices, mark user qp in error once we transition
to TERMINATE.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_qp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index e066727..da13a38 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -846,6 +846,8 @@ int iwch_modify_qp(struct iwch_dev *rhp,
 			break;
 		case IWCH_QP_STATE_TERMINATE:
 			qhp->attr.state = IWCH_QP_STATE_TERMINATE;
+			if (t3b_device(qhp->rhp))
+				cxio_set_wq_in_error(&qhp->wq);
 			if (!internal)
 				terminate = 1;
 			break;

