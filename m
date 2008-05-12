Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYELRHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYELRHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYELRHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:07:10 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:60380 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbYELRHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:07:08 -0400
Date: Mon, 12 May 2008 18:44:21 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Julia Lawall <julia@diku.dk>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] au1000_eth: remove useless check
Message-ID: <20080512164421.GB22190@electric-eye.fr.zoreil.com>
References: <Pine.LNX.4.64.0805121537320.3694@ask.diku.dk> <20080512161734.GA22190@electric-eye.fr.zoreil.com> <Pine.LNX.4.64.0805121852510.16384@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805121852510.16384@ask.diku.dk>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lifespan of the device covers the request_irq .. free_irq interval.

The cast of a void * pointer is not needed either.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

diff --git a/drivers/net/au1000_eth.c b/drivers/net/au1000_eth.c
index 3634b5f..7023d77 100644
--- a/drivers/net/au1000_eth.c
+++ b/drivers/net/au1000_eth.c
@@ -1239,12 +1239,7 @@ static int au1000_rx(struct net_device *dev)
  */
 static irqreturn_t au1000_interrupt(int irq, void *dev_id)
 {
-	struct net_device *dev = (struct net_device *) dev_id;
-
-	if (dev == NULL) {
-		printk(KERN_ERR "%s: isr: null dev ptr\n", dev->name);
-		return IRQ_RETVAL(1);
-	}
+	struct net_device *dev = dev_id;
 
 	/* Handle RX interrupts first to minimize chance of overrun */
 
