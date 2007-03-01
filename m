Return-Path: <linux-kernel-owner+w=401wt.eu-S1161111AbXCAWvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161111AbXCAWvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161104AbXCAWut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:50:49 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:32836 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161102AbXCAWur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:50:47 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.21 5/6] iw_cxgb3: Don't reuse skbuffs that are non-linear or cloned.
Date: Thu, 01 Mar 2007 16:50:46 -0600
To: rdreier@cisco.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20070301225046.2373.21370.stgit@dell3.ogc.int>
In-Reply-To: <20070301225036.2373.71668.stgit@dell3.ogc.int>
References: <20070301225036.2373.71668.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Don't reuse skbuffs that are non-linear or cloned.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 8e6f6df..fd2f3ca 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -305,8 +305,7 @@ static int status2errno(int status)
  */
 static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
 {
-	if (skb) {
-		BUG_ON(skb_cloned(skb));
+	if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
 		skb_trim(skb, 0);
 		skb_get(skb);
 	} else {
