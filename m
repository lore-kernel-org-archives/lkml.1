Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYBSLPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYBSLPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbYBSLNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:13:39 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55053 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827AbYBSLNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:13:32 -0500
Date: Tue, 19 Feb 2008 03:20:58 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 6/8] net: use numa_node in net_devcice->dev instead of parent
In-reply-to: <200802190311.44404.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802190320.58561.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802190311.44404.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/net/core/skbuff.c
===================================================================
--- linux-2.6.orig/net/core/skbuff.c
+++ linux-2.6/net/core/skbuff.c
@@ -252,7 +252,7 @@ nodata:
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
 		unsigned int length, gfp_t gfp_mask)
 {
-	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
+	int node = dev_to_node(&dev->dev);
 	struct sk_buff *skb;
 
 	skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask | __GFP_NOTRACK,
