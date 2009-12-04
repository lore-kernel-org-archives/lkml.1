Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZLDCtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZLDCtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZLDCsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:48:10 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:55378 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbZLDCrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:47:23 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com
Subject: [RFC][PATCH 07/10] fec: Add LAN8700 phy support
Date: Fri,  4 Dec 2009 04:47:07 +0200
Message-Id: <a34d2aac8d5282bfbdf09dddc2da57c4ad7da355.1259893118.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <7a49f4c0ea2f5030068729978c2cb173a6e15857.1259893118.git.amit.kucheria@canonical.com>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
 <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
 <6608c4dca645d87efce78ae0b7dbad265004f482.1259893118.git.amit.kucheria@canonical.com>
 <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com>
 <a079a0627e77f2df590840e4798fc067f4436160.1259893118.git.amit.kucheria@canonical.com>
 <0559d42bc9f32e30264fea6ca6fa679121f6a241.1259893118.git.amit.kucheria@canonical.com>
 <7a49f4c0ea2f5030068729978c2cb173a6e15857.1259893118.git.amit.kucheria@canonical.com>
In-Reply-To: <cover.1259893118.git.amit.kucheria@canonical.com>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i.MX51 babbage board has a FEC ethernet controller with this phy.

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/fec.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/fec.c b/drivers/net/fec.c
index 9a8743d..5d0d332 100644
--- a/drivers/net/fec.c
+++ b/drivers/net/fec.c
@@ -1128,6 +1128,26 @@ static phy_info_t phy_info_dp83848= {
 	},
 };
 
+static phy_info_t phy_info_lan8700 = {
+	0x0007C0C,
+	"LAN8700",
+	(const phy_cmd_t []) { /* config */
+		{ mk_mii_read(MII_REG_CR), mii_parse_cr },
+		{ mk_mii_read(MII_REG_ANAR), mii_parse_anar },
+		{ mk_mii_end, }
+	},
+	(const phy_cmd_t []) { /* startup */
+		{ mk_mii_write(MII_REG_CR, 0x1200), NULL }, /* autonegotiate */
+		{ mk_mii_read(MII_REG_SR), mii_parse_sr },
+		{ mk_mii_end, }
+	},
+	(const phy_cmd_t []) { /* act_int */
+		{ mk_mii_end, }
+	},
+	(const phy_cmd_t []) { /* shutdown */
+		{ mk_mii_end, }
+	},
+};
 /* ------------------------------------------------------------------------- */
 
 static phy_info_t const * const phy_info[] = {
@@ -1137,6 +1157,7 @@ static phy_info_t const * const phy_info[] = {
 	&phy_info_am79c874,
 	&phy_info_ks8721bl,
 	&phy_info_dp83848,
+	&phy_info_lan8700,
 	NULL
 };
 
-- 
1.6.3.3

