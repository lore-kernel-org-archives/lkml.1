Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZLMPfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZLMPfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 10:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZLMPft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 10:35:49 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:35399 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752495AbZLMPfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 10:35:48 -0500
Date: Sun, 13 Dec 2009 16:35:45 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: florian@openwrt.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/net/cpmac.c: Correct code taking the size of a
 pointer
Message-ID: <Pine.LNX.4.64.0912131635110.27767@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

sizeof(dev->dev_addr) is the size of a pointer.  On the other hand,
sizeof(pdata->dev_addr) is the size of an array, so use that instead.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/cpmac.c                 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cpmac.c b/drivers/net/cpmac.c
index 6782223..8d0be26 100644
--- a/drivers/net/cpmac.c
+++ b/drivers/net/cpmac.c
@@ -1163,7 +1163,7 @@ static int __devinit cpmac_probe(struct platform_device *pdev)
 	priv->dev = dev;
 	priv->ring_size = 64;
 	priv->msg_enable = netif_msg_init(debug_level, 0xff);
-	memcpy(dev->dev_addr, pdata->dev_addr, sizeof(dev->dev_addr));
+	memcpy(dev->dev_addr, pdata->dev_addr, sizeof(pdata->dev_addr));
 
 	snprintf(priv->phy_name, MII_BUS_ID_SIZE, PHY_ID_FMT, mdio_bus_id, phy_id);
 
