Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbXHVJAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbXHVJAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbXHVIxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:19 -0400
Received: from 1wt.eu ([62.212.114.60]:2032 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758389AbXHVIxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:16 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084024.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:17 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Ayaz Abdulla <aabdulla@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 33/58] forcedeth bug fix: cicada phy
Content-Disposition: inline; filename=0033-forcedeth-bug-fix-cicada-phy.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains errata fixes for the cicada phy. It only renamed the
defines to be phy specific.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/forcedeth.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 952a6bd..63f4c58 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -560,12 +560,12 @@ union ring_type {
 #define PHYID2_MODEL_MASK		0x03f0
 #define PHY_MODEL_MARVELL_E3016		0x220
 #define PHY_MARVELL_E3016_INITMASK	0x0300
-#define PHY_INIT1	0x0f000
-#define PHY_INIT2	0x0e00
-#define PHY_INIT3	0x01000
-#define PHY_INIT4	0x0200
-#define PHY_INIT5	0x0004
-#define PHY_INIT6	0x02000
+#define PHY_CICADA_INIT1	0x0f000
+#define PHY_CICADA_INIT2	0x0e00
+#define PHY_CICADA_INIT3	0x01000
+#define PHY_CICADA_INIT4	0x0200
+#define PHY_CICADA_INIT5	0x0004
+#define PHY_CICADA_INIT6	0x02000
 #define PHY_GIGABIT	0x0100
 
 #define PHY_TIMEOUT	0x1
@@ -1133,14 +1133,14 @@ static int phy_init(struct net_device *dev)
 	/* phy vendor specific configuration */
 	if ((np->phy_oui == PHY_OUI_CICADA) && (phyinterface & PHY_RGMII) ) {
 		phy_reserved = mii_rw(dev, np->phyaddr, MII_RESV1, MII_READ);
-		phy_reserved &= ~(PHY_INIT1 | PHY_INIT2);
-		phy_reserved |= (PHY_INIT3 | PHY_INIT4);
+		phy_reserved &= ~(PHY_CICADA_INIT1 | PHY_CICADA_INIT2);
+		phy_reserved |= (PHY_CICADA_INIT3 | PHY_CICADA_INIT4);
 		if (mii_rw(dev, np->phyaddr, MII_RESV1, phy_reserved)) {
 			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
 			return PHY_ERROR;
 		}
 		phy_reserved = mii_rw(dev, np->phyaddr, MII_NCONFIG, MII_READ);
-		phy_reserved |= PHY_INIT5;
+		phy_reserved |= PHY_CICADA_INIT5;
 		if (mii_rw(dev, np->phyaddr, MII_NCONFIG, phy_reserved)) {
 			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
 			return PHY_ERROR;
@@ -1148,7 +1148,7 @@ static int phy_init(struct net_device *dev)
 	}
 	if (np->phy_oui == PHY_OUI_CICADA) {
 		phy_reserved = mii_rw(dev, np->phyaddr, MII_SREVISION, MII_READ);
-		phy_reserved |= PHY_INIT6;
+		phy_reserved |= PHY_CICADA_INIT6;
 		if (mii_rw(dev, np->phyaddr, MII_SREVISION, phy_reserved)) {
 			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
 			return PHY_ERROR;
-- 
1.5.2.5

-- 
