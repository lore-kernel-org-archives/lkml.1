Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZIGK10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZIGK10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZIGK1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:27:25 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:53650 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZIGK1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:27:23 -0400
X-Greylist: delayed 1684 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 06:27:23 EDT
Date: Mon, 7 Sep 2009 11:59:16 +0200 (MEST)
Message-Id: <200909070959.n879xGui019854@pilspetsen.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: Lennert Buytenhek <buytenh@marvell.com>
Subject: [PATCH 2.6.31-rc9] mv643xx_eth.c: remove unused txq_set_wrr()
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The txq_set_wrr() function in drivers/net/mv643xx_eth.c is
unused, not even referenced under #if 0 or something like that,
which results in a compile-time warning:

drivers/net/mv643xx_eth.c:1070: warning: 'txq_set_wrr' defined but not used

Fix: remove it.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 drivers/net/mv643xx_eth.c |   34 ----------------------------------
 1 file changed, 34 deletions(-)

--- linux-2.6.31-rc9/drivers/net/mv643xx_eth.c.~1~	2009-09-06 12:20:57.000000000 +0200
+++ linux-2.6.31-rc9/drivers/net/mv643xx_eth.c	2009-09-07 11:36:32.000000000 +0200
@@ -1066,40 +1066,6 @@ static void txq_set_fixed_prio_mode(stru
 	}
 }
 
-static void txq_set_wrr(struct tx_queue *txq, int weight)
-{
-	struct mv643xx_eth_private *mp = txq_to_mp(txq);
-	int off;
-	u32 val;
-
-	/*
-	 * Turn off fixed priority mode.
-	 */
-	off = 0;
-	switch (mp->shared->tx_bw_control) {
-	case TX_BW_CONTROL_OLD_LAYOUT:
-		off = TXQ_FIX_PRIO_CONF;
-		break;
-	case TX_BW_CONTROL_NEW_LAYOUT:
-		off = TXQ_FIX_PRIO_CONF_MOVED;
-		break;
-	}
-
-	if (off) {
-		val = rdlp(mp, off);
-		val &= ~(1 << txq->index);
-		wrlp(mp, off, val);
-
-		/*
-		 * Configure WRR weight for this queue.
-		 */
-
-		val = rdlp(mp, off);
-		val = (val & ~0xff) | (weight & 0xff);
-		wrlp(mp, TXQ_BW_WRR_CONF(txq->index), val);
-	}
-}
-
 
 /* mii management interface *************************************************/
 static irqreturn_t mv643xx_eth_err_irq(int irq, void *dev_id)
