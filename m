Return-Path: <linux-kernel-owner+w=401wt.eu-S1763995AbXG2O4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763995AbXG2O4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763744AbXG2O4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:56:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47743 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763252AbXG2O4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:56:09 -0400
Date: Sun, 29 Jul 2007 16:55:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Divy Le Ray <divy@chelsio.com>, Jeff Garzik <jeff@garzik.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/net/cxgb3/xgmac.c: remove dead code
Message-ID: <20070729145544.GA16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code ("tx_xcnt" can never be != 0 at this place) 
spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/net/cxgb3/xgmac.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- linux-2.6.22-rc6-mm1/drivers/net/cxgb3/xgmac.c.old	2007-07-24 13:55:33.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/net/cxgb3/xgmac.c	2007-07-24 13:57:06.000000000 +0200
@@ -510,38 +510,35 @@ int t3b2_mac_watchdog_task(struct cmac *
 	if (tx_mcnt == mac->tx_mcnt) {
 		tx_xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
 						A_XGM_TX_SPI4_SOP_EOP_CNT +
 					       	mac->offset)));
 		if (tx_xcnt == 0) {
 			t3_write_reg(adap, A_TP_PIO_ADDR,
 				     A_TP_TX_DROP_CNT_CH0 + macidx(mac));
 			tx_tcnt = (G_TXDROPCNTCH0RCVD(t3_read_reg(adap,
 						      A_TP_PIO_DATA)));
 		} else {
 			goto rxcheck;
 		}
 	} else {
 		mac->toggle_cnt = 0;
 		goto rxcheck;
 	}
 
-	if (((tx_tcnt != mac->tx_tcnt) &&
-	     (tx_xcnt == 0) && (mac->tx_xcnt == 0)) ||
-	    ((mac->tx_mcnt == tx_mcnt) &&
-	     (tx_xcnt != 0) && (mac->tx_xcnt != 0))) {
+	if ((tx_tcnt != mac->tx_tcnt) && (mac->tx_xcnt == 0))  {
 		if (mac->toggle_cnt > 4) {
 			status = 2;
 			goto out;
 		} else {
 			status = 1;
 			goto out;
 		}
 	} else {
 		mac->toggle_cnt = 0;
 		goto rxcheck;
 	}
 
 rxcheck:
 	if (rx_mcnt != mac->rx_mcnt)
 		rx_xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
 						A_XGM_RX_SPI4_SOP_EOP_CNT +
 						mac->offset)));

