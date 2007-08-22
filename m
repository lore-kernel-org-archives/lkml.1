Return-Path: <linux-kernel-owner+w=401wt.eu-S1762737AbXHVJCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762737AbXHVJCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbXHVIxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:33 -0400
Received: from 1wt.eu ([62.212.114.60]:2089 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758613AbXHVIx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:29 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084026.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:19 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Ayaz Abdulla <aabdulla@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 35/58] forcedeth bug fix: realtek phy
Content-Disposition: inline; filename=0035-forcedeth-bug-fix-realtek-phy.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains errata fixes for the realtek phy. It only renamed the
defines to be phy specific.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/forcedeth.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index c383dc3..dbfdbed 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -554,6 +554,7 @@ union ring_type {
 #define PHY_OUI_MARVELL	0x5043
 #define PHY_OUI_CICADA	0x03f1
 #define PHY_OUI_VITESSE	0x01c1
+#define PHY_OUI_REALTEK	0x01c1
 #define PHYID1_OUI_MASK	0x03ff
 #define PHYID1_OUI_SHFT	6
 #define PHYID2_OUI_MASK	0xfc00
@@ -583,6 +584,13 @@ union ring_type {
 #define PHY_VITESSE_INIT8	0x0100
 #define PHY_VITESSE_INIT9	0x8f82
 #define PHY_VITESSE_INIT10	0x0
+#define PHY_REALTEK_INIT_REG1	0x1f
+#define PHY_REALTEK_INIT_REG2	0x19
+#define PHY_REALTEK_INIT_REG3	0x13
+#define PHY_REALTEK_INIT1	0x0000
+#define PHY_REALTEK_INIT2	0x8e00
+#define PHY_REALTEK_INIT3	0x0001
+#define PHY_REALTEK_INIT4	0xad17
 
 #define PHY_GIGABIT	0x0100
 
@@ -1106,6 +1114,28 @@ static int phy_init(struct net_device *dev)
 			return PHY_ERROR;
 		}
 	}
+	if (np->phy_oui == PHY_OUI_REALTEK) {
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG2, PHY_REALTEK_INIT2)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT3)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG3, PHY_REALTEK_INIT4)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+	}
 
 	/* set advertise register */
 	reg = mii_rw(dev, np->phyaddr, MII_ADVERTISE, MII_READ);
@@ -1242,6 +1272,30 @@ static int phy_init(struct net_device *dev)
 			return PHY_ERROR;
 		}
 	}
+	if (np->phy_oui == PHY_OUI_REALTEK) {
+		/* reset could have cleared these out, set them back */
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG2, PHY_REALTEK_INIT2)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT3)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG3, PHY_REALTEK_INIT4)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+		if (mii_rw(dev, np->phyaddr, PHY_REALTEK_INIT_REG1, PHY_REALTEK_INIT1)) {
+			printk(KERN_INFO "%s: phy init failed.
", pci_name(np->pci_dev));
+			return PHY_ERROR;
+		}
+	}
+
 	/* some phys clear out pause advertisment on reset, set it back */
 	mii_rw(dev, np->phyaddr, MII_ADVERTISE, reg);
 
-- 
1.5.2.5

-- 
