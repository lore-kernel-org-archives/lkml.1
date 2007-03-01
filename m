Return-Path: <linux-kernel-owner+w=401wt.eu-S1161120AbXCAWvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120AbXCAWvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161088AbXCAWur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:50:47 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:32828 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161095AbXCAWun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:50:43 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.21 3/6] iw_cxgb3: Stop the endpoint timer when the MPA exchange is aborted by the peer.
Date: Thu, 01 Mar 2007 16:50:42 -0600
To: rdreier@cisco.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20070301225042.2373.68022.stgit@dell3.ogc.int>
In-Reply-To: <20070301225036.2373.71668.stgit@dell3.ogc.int>
References: <20070301225036.2373.71668.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Stop the endpoint timer when the MPA exchange is aborted by the peer.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 1dcfedc..8e6f6df 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1487,8 +1487,10 @@ static int peer_abort(struct t3cdev *tde
 	case CONNECTING:
 		break;
 	case MPA_REQ_WAIT:
+		stop_ep_timer(ep);
 		break;
 	case MPA_REQ_SENT:
+		stop_ep_timer(ep);
 		connect_reply_upcall(ep, -ECONNRESET);
 		break;
 	case MPA_REP_SENT:
