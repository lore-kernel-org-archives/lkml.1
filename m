Return-Path: <linux-kernel-owner+w=401wt.eu-S932350AbXGKSEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbXGKSEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765756AbXGKSEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:04:37 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:38051 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbXGKSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:04:36 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.23] iw_cxgb3: remove the cm_id reference on listen failures.
Date: Wed, 11 Jul 2007 13:04:35 -0500
To: rdreier@cisco.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Message-Id: <20070711180435.11665.71117.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


iw_cxgb3: remove the cm_id reference on listen failures.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 3b41dc0..5dc68cd 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1914,6 +1914,7 @@ int iwch_create_listen(struct iw_cm_id *
 fail3:
 	cxgb3_free_stid(ep->com.tdev, ep->stid);
 fail2:
+	cm_id->rem_ref(cm_id);
 	put_ep(&ep->com);
 fail1:
 out:
