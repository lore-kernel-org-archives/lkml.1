Return-Path: <linux-kernel-owner+w=401wt.eu-S1946635AbXBIQmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946635AbXBIQmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946657AbXBIQk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:40:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51746 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946650AbXBIQkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:40:11 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] trivial cxgb3 annotations
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HFYnC-0006sF-PD@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:40:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/cxgb3/cxgb3_offload.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_offload.c b/drivers/net/cxgb3/cxgb3_offload.c
index c3a02d6..c6b7266 100644
--- a/drivers/net/cxgb3/cxgb3_offload.c
+++ b/drivers/net/cxgb3/cxgb3_offload.c
@@ -396,7 +396,7 @@ static int rx_offload_blackhole(struct t3cdev *dev, struct sk_buff **skbs,
 				int n)
 {
 	CH_ERR(tdev2adap(dev), "%d unexpected offload packets, first data %u\n",
-	       n, ntohl(*(u32 *)skbs[0]->data));
+	       n, ntohl(*(__be32 *)skbs[0]->data));
 	while (n--)
 		dev_kfree_skb_any(skbs[n]);
 	return 0;
@@ -755,7 +755,7 @@ static int do_trace(struct t3cdev *dev, struct sk_buff *skb)
 {
 	struct cpl_trace_pkt *p = cplhdr(skb);
 
-	skb->protocol = 0xffff;
+	skb->protocol = htons(0xffff);
 	skb->dev = dev->lldev;
 	skb_pull(skb, sizeof(*p));
 	skb->mac.raw = skb->data;
-- 
1.5.0-rc2.GIT


