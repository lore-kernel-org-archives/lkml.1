Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbYGILK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbYGILK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbYGILKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:10:36 -0400
Received: from khc.piap.pl ([195.187.100.11]:59411 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056AbYGILKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:10:34 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [FIX] ARM: IXP4xx Ethernet NAPI fix
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 09 Jul 2008 13:10:32 +0200
Message-ID: <m31w23ia8n.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some weirdness from IXP4xx Ethernet driver.
Ideally it should go in 2.6.26 though it's not that critical. Thanks.

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

diff --git a/drivers/net/arm/ixp4xx_eth.c b/drivers/net/arm/ixp4xx_eth.c
index c617b64..9b777d9 100644
--- a/drivers/net/arm/ixp4xx_eth.c
+++ b/drivers/net/arm/ixp4xx_eth.c
@@ -522,7 +522,6 @@ static int eth_poll(struct napi_struct *napi, int budget)
 #endif
 
 		if ((n = queue_get_desc(rxq, port, 0)) < 0) {
-			received = 0; /* No packet received */
 #if DEBUG_RX
 			printk(KERN_DEBUG "%s: eth_poll netif_rx_complete\n",
 			       dev->name);
@@ -543,7 +542,7 @@ static int eth_poll(struct napi_struct *napi, int budget)
 			printk(KERN_DEBUG "%s: eth_poll all done\n",
 			       dev->name);
 #endif
-			return 0; /* all work done */
+			return received; /* all work done */
 		}
 
 		desc = rx_desc_ptr(port, n);
