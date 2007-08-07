Return-Path: <linux-kernel-owner+w=401wt.eu-S936898AbXHGVOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936898AbXHGVOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935779AbXHGUyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:54:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59639 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935582AbXHGUyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:54:45 -0400
Date: Tue, 7 Aug 2007 13:47:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: [2.6.22.2 review 54/84] forcedeth bug fix: cicada phy
Message-ID: <20070807204746.GD23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="forcedeth-bug-fix-cicada-phy.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ayaz Abdulla <aabdulla@nvidia.com>

This patch contains errata fixes for the cicada phy. It only renamed the
defines to be phy specific.


Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/forcedeth.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -557,12 +557,12 @@ union ring_type {
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
@@ -1141,14 +1141,14 @@ static int phy_init(struct net_device *d
 	/* phy vendor specific configuration */
 	if ((np->phy_oui == PHY_OUI_CICADA) && (phyinterface & PHY_RGMII) ) {
 		phy_reserved = mii_rw(dev, np->phyaddr, MII_RESV1, MII_READ);
-		phy_reserved &= ~(PHY_INIT1 | PHY_INIT2);
-		phy_reserved |= (PHY_INIT3 | PHY_INIT4);
+		phy_reserved &= ~(PHY_CICADA_INIT1 | PHY_CICADA_INIT2);
+		phy_reserved |= (PHY_CICADA_INIT3 | PHY_CICADA_INIT4);
 		if (mii_rw(dev, np->phyaddr, MII_RESV1, phy_reserved)) {
 			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
 			return PHY_ERROR;
 		}
 		phy_reserved = mii_rw(dev, np->phyaddr, MII_NCONFIG, MII_READ);
-		phy_reserved |= PHY_INIT5;
+		phy_reserved |= PHY_CICADA_INIT5;
 		if (mii_rw(dev, np->phyaddr, MII_NCONFIG, phy_reserved)) {
 			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
 			return PHY_ERROR;
@@ -1156,7 +1156,7 @@ static int phy_init(struct net_device *d
 	}
 	if (np->phy_oui == PHY_OUI_CICADA) {
 		phy_reserved = mii_rw(dev, np->phyaddr, MII_SREVISION, MII_READ);
-		phy_reserved |= PHY_INIT6;
+		phy_reserved |= PHY_CICADA_INIT6;
 		if (mii_rw(dev, np->phyaddr, MII_SREVISION, phy_reserved)) {
 			printk(KERN_INFO "%s: phy init failed.\n", pci_name(np->pci_dev));
 			return PHY_ERROR;

-- 
