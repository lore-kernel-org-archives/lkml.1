Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYDIJzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYDIJzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 05:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYDIJzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 05:55:12 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:49542 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYDIJzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 05:55:11 -0400
Message-ID: <47FC922A.6030309@tiscali.nl>
Date: Wed, 09 Apr 2008 11:53:46 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: nico@cam.org
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] smc911x: test after postfix decrement fails in smc911x_{reset,drop_pkt}
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When timeout reaches 0 the postfix decrement still subtracts, so the test fails

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/smc911x.c b/drivers/net/smc911x.c
index 76cc1d3..2126d24 100644
--- a/drivers/net/smc911x.c
+++ b/drivers/net/smc911x.c
@@ -243,7 +243,7 @@ static void smc911x_reset(struct net_device *dev)
 		do {
 			udelay(10);
 			reg = SMC_GET_PMT_CTRL() & PMT_CTRL_READY_;
-		} while ( timeout-- && !reg);
+		} while ( --timeout && !reg);
 		if (timeout == 0) {
 			PRINTK("%s: smc911x_reset timeout waiting for PM restore\n", dev->name);
 			return;
@@ -267,7 +267,7 @@ static void smc911x_reset(struct net_device *dev)
 				resets++;
 				break;
 			}
-		} while ( timeout-- && (reg & HW_CFG_SRST_));
+		} while ( --timeout && (reg & HW_CFG_SRST_));
 	}
 	if (timeout == 0) {
 		PRINTK("%s: smc911x_reset timeout waiting for reset\n", dev->name);
@@ -413,7 +413,7 @@ static inline void smc911x_drop_pkt(struct net_device *dev)
 		do {
 			udelay(10);
 			reg = SMC_GET_RX_DP_CTRL() & RX_DP_CTRL_FFWD_BUSY_;
-		} while ( timeout-- && reg);
+		} while ( --timeout && reg);
 		if (timeout == 0) {
 			PRINTK("%s: timeout waiting for RX fast forward\n", dev->name);
 		}
