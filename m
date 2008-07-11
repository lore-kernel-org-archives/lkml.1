Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbYGKOKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbYGKOKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYGKOJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:09:53 -0400
Received: from havoc.gtf.org ([69.61.125.42]:36701 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbYGKOJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:09:53 -0400
Date: Fri, 11 Jul 2008 10:09:52 -0400
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] net driver fix for .26
Message-ID: <20080711140952.GA17593@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'davem-fixes' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git davem-fixes

to receive the following updates:

 drivers/net/arm/ixp4xx_eth.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

Krzysztof Halasa (1):
      ARM: IXP4xx Ethernet NAPI fix

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
