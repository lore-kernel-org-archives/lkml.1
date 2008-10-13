Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbYJMRUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbYJMRUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 13:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbYJMRUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 13:20:06 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44246 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216AbYJMRUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 13:20:04 -0400
Date: Mon, 13 Oct 2008 20:19:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Lennert Buytenhek <buytenh@marvell.com>,
       Andy Fleming <afleming@freescale.com>, jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [2.6 patch] export genphy_restart_aneg
Message-ID: <20081013171900.GK29938@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error caused by
commit ed94493fb38a665cebcf750dfabe8a6dd13e136f
(mv643xx_eth: convert to phylib):

<--  snip  -->

...
  Building modules, stage 2.
  MODPOST 1280 modules
ERROR: "genphy_restart_aneg" [drivers/net/mv643xx_eth.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->


Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1716274..f11e900 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -557,6 +557,7 @@ int genphy_restart_aneg(struct phy_device *phydev)
 
 	return ctl;
 }
+EXPORT_SYMBOL(genphy_restart_aneg);
 
 
 /**

