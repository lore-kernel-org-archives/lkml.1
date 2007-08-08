Return-Path: <linux-kernel-owner+w=401wt.eu-S936807AbXHHBWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936807AbXHHBWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933431AbXHHBVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:21:03 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:46059 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758282AbXHHBU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:20:57 -0400
Date: Tue, 07 Aug 2007 18:24:10 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 4/5] net: use numa_node in net_devcice->dev instead of parent
In-reply-to: <200708072246.l77MkCLZ008757@imap1.linux-foundation.org>
To: akpm@linux-foundation.org, ak@suse.de
Cc: apw@shadowen.org, clameter@sgi.com, davem@davemloft.net, greg@kroah.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200708071824.10609.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200708072246.l77MkCLZ008757@imap1.linux-foundation.org>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 4/5] net: use numa_node in net_devcice->dev instead of parent

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 27cfe5f..005cc1c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -217,7 +217,7 @@ nodata:
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
 		unsigned int length, gfp_t gfp_mask)
 {
-	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
+	int node = dev_to_node(&dev->dev);
 	struct sk_buff *skb;
 
 	skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask, 0, node);
