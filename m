Return-Path: <linux-kernel-owner+w=401wt.eu-S933025AbXJPRK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbXJPRK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760126AbXJPRKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:10:07 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:24447 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759607AbXJPRKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:10:05 -0400
Date: Tue, 16 Oct 2007 11:08:08 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] gianfar: fix compile errors and warnings
To: jeff@garzik.org, Li Yang <leoli@freescale.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-id: <20071016170808.17883.39779.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Fixes compile error from commit 09f75cd7bf13720738e6a196cc0107ce9a5bd5a0.
Also eliminates an unused variable and eliminates an uninitialized variable
warning.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/net/gianfar.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 558440c..0a2f2b3 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -696,7 +696,7 @@ int startup_gfar(struct net_device *dev)
 {
 	struct txbd8 *txbdp;
 	struct rxbd8 *rxbdp;
-	dma_addr_t addr;
+	dma_addr_t addr = 0;
 	unsigned long vaddr;
 	int i;
 	struct gfar_private *priv = netdev_priv(dev);
@@ -1237,8 +1237,6 @@ static int gfar_change_mtu(struct net_device *dev, int new_mtu)
  * starting over will fix the problem. */
 static void gfar_timeout(struct net_device *dev)
 {
-	struct gfar_private *priv = netdev_priv(dev);
-
 	dev->stats.tx_errors++;
 
 	if (dev->flags & IFF_UP) {
@@ -1346,7 +1344,7 @@ struct sk_buff * gfar_new_skb(struct net_device *dev, struct rxbd8 *bdp)
 
 static inline void count_errors(unsigned short status, struct gfar_private *priv)
 {
-	struct net_device_stats *stats = &dev->stats;
+	struct net_device_stats *stats = &priv->dev->stats;
 	struct gfar_extra_stats *estats = &priv->extra_stats;
 
 	/* If the packet was truncated, none of the other errors

