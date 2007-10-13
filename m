Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbXJMHaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbXJMHaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXJMHab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:30:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51041 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbXJMHaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:30:30 -0400
Date: Sat, 13 Oct 2007 08:30:26 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@davemloft.net, Jeff Garzik <jgarzik@pobox.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fallout from DECLARE_MAC_BUF patches
Message-ID: <20071013073026.GH8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
4804102d4d0db062dcc480bfbd4336066f6e879d
diff --git a/drivers/net/atarilance.c b/drivers/net/atarilance.c
index ebf1a3a..b74dbee 100644
--- a/drivers/net/atarilance.c
+++ b/drivers/net/atarilance.c
@@ -1023,7 +1023,7 @@ static int lance_rx( struct net_device *dev )
 					DECLARE_MAC_BUF(mac);
 					DECLARE_MAC_BUF(mac2);
 
-					printk(KERN_DEBUG "%s: RX pkt type 0x%04x from %s to %s ",
+					printk(KERN_DEBUG "%s: RX pkt type 0x%04x from %s to %s "
 						   "data %02x %02x %02x %02x %02x %02x %02x %02x "
 						   "len %d\n",
 						   dev->name, ((u_short *)data)[6],
diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index b33d21f..84f2d63 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -784,7 +784,6 @@ static int mv643xx_eth_open(struct net_device *dev)
 	unsigned int port_num = mp->port_num;
 	unsigned int size;
 	int err;
-	DECLARE_MAC_BUF(mac);
 
 	/* Clear any pending ethernet port interrupts */
 	mv_write(MV643XX_ETH_INTERRUPT_CAUSE_REG(port_num), 0);
@@ -1296,6 +1295,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	struct ethtool_cmd cmd;
 	int duplex = DUPLEX_HALF;
 	int speed = 0;			/* default to auto-negotiation */
+	DECLARE_MAC_BUF(mac);
 
 	pd = pdev->dev.platform_data;
 	if (pd == NULL) {
