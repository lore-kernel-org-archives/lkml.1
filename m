Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbXGDAeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbXGDAeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 20:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbXGDAdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 20:33:50 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49244 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXGDAdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 20:33:49 -0400
Date: Tue, 03 Jul 2007 17:30:51 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/4] net: use numa_node in net_devcice->dev instead of parent
In-reply-to: <20070703143407.7e4232f8@freepuppy.localdomain.hemminger.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707031730.51677.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200706291330.37070.yinghai.lu@sun.com> <468ABF92.5030800@sun.com>
 <20070703143407.7e4232f8@freepuppy.localdomain.hemminger.net>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/4] net: use numa_node in net_devcice->dev instead of parent

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
