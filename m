Return-Path: <linux-kernel-owner+w=401wt.eu-S938515AbXHNAAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938515AbXHNAAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 20:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXHMX74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:59:56 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:56755 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbXHMX7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:59:54 -0400
Date: Tue, 14 Aug 2007 01:59:30 +0200 (MEST)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: chessman@tux.org
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       tlan-devel@lists.sourceforge.net,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070813235804.13307.2178.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] drivers/net/tlan: Convert to generic boolean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to generic boolean

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with all(yes|mod|no)config on x86(|_64) & sparc(|64)
Diffed against Linus' git-tree.
Sent 2007-05-01, no replys


diff --git a/drivers/net/tlan.c b/drivers/net/tlan.c
index 106dc1e..db630c4 100644
--- a/drivers/net/tlan.c
+++ b/drivers/net/tlan.c
@@ -337,7 +337,7 @@ static int	TLan_PhyInternalService( struct net_device * );
 static int	TLan_PhyDp83840aCheck( struct net_device * );
 */
 
-static int	TLan_MiiReadReg( struct net_device *, u16, u16, u16 * );
+static bool	TLan_MiiReadReg( struct net_device *, u16, u16, u16 * );
 static void	TLan_MiiSendData( u16, u32, unsigned );
 static void	TLan_MiiSync( u16 );
 static void	TLan_MiiWriteReg( struct net_device *, u16, u16, u16 );
@@ -2240,7 +2240,7 @@ TLan_ResetAdapter( struct net_device *dev )
 	u32		data;
 	u8		data8;
 
-	priv->tlanFullDuplex = FALSE;
+	priv->tlanFullDuplex = false;
 	priv->phyOnline=0;
 	netif_carrier_off(dev);
 
@@ -2295,7 +2295,7 @@ TLan_ResetAdapter( struct net_device *dev )
 			TLan_DioWrite8( dev->base_addr, TLAN_ACOMMIT, 0x0a );
 		} else if ( priv->duplex == TLAN_DUPLEX_FULL ) {
 			TLan_DioWrite8( dev->base_addr, TLAN_ACOMMIT, 0x00 );
-			priv->tlanFullDuplex = TRUE;
+			priv->tlanFullDuplex = true;
 		} else {
 			TLan_DioWrite8( dev->base_addr, TLAN_ACOMMIT, 0x08 );
 		}
@@ -2676,14 +2676,14 @@ void TLan_PhyStartLink( struct net_device *dev )
 			TLan_MiiWriteReg( dev, phy, MII_GEN_CTL, 0x0000);
 		} else if ( priv->speed == TLAN_SPEED_10 &&
 			    priv->duplex == TLAN_DUPLEX_FULL) {
-			priv->tlanFullDuplex = TRUE;
+			priv->tlanFullDuplex = true;
 			TLan_MiiWriteReg( dev, phy, MII_GEN_CTL, 0x0100);
 		} else if ( priv->speed == TLAN_SPEED_100 &&
 			    priv->duplex == TLAN_DUPLEX_HALF) {
 			TLan_MiiWriteReg( dev, phy, MII_GEN_CTL, 0x2000);
 		} else if ( priv->speed == TLAN_SPEED_100 &&
 			    priv->duplex == TLAN_DUPLEX_FULL) {
-			priv->tlanFullDuplex = TRUE;
+			priv->tlanFullDuplex = true;
 			TLan_MiiWriteReg( dev, phy, MII_GEN_CTL, 0x2100);
 		} else {
 
@@ -2720,7 +2720,7 @@ void TLan_PhyStartLink( struct net_device *dev )
                 	tctl &= ~TLAN_TC_AUISEL;
 			if ( priv->duplex == TLAN_DUPLEX_FULL ) {
 				control |= MII_GC_DUPLEX;
-				priv->tlanFullDuplex = TRUE;
+				priv->tlanFullDuplex = true;
 			}
 			if ( priv->speed == TLAN_SPEED_100 ) {
 				control |= MII_GC_SPEEDSEL;
@@ -2775,9 +2775,9 @@ void TLan_PhyFinishAutoNeg( struct net_device *dev )
 	TLan_MiiReadReg( dev, phy, MII_AN_LPA, &an_lpa );
 	mode = an_adv & an_lpa & 0x03E0;
 	if ( mode & 0x0100 ) {
-		priv->tlanFullDuplex = TRUE;
+		priv->tlanFullDuplex = true;
 	} else if ( ! ( mode & 0x0080 ) && ( mode & 0x0040 ) ) {
-		priv->tlanFullDuplex = TRUE;
+		priv->tlanFullDuplex = true;
 	}
 
 	if ( ( ! ( mode & 0x0180 ) ) && ( priv->adapter->flags & TLAN_ADAPTER_USE_INTERN_10 ) && ( priv->phyNum != 0 ) ) {
@@ -2896,17 +2896,17 @@ void TLan_PhyMonitor( struct net_device *dev )
 	 *
 	 **************************************************************/
 
-int TLan_MiiReadReg( struct net_device *dev, u16 phy, u16 reg, u16 *val )
+bool TLan_MiiReadReg( struct net_device *dev, u16 phy, u16 reg, u16 *val )
 {
 	u8	nack;
 	u16	sio, tmp;
  	u32	i;
-	int	err;
+	bool	err;
 	int	minten;
 	TLanPrivateInfo *priv = netdev_priv(dev);
 	unsigned long flags = 0;
 
-	err = FALSE;
+	err = false;
 	outw(TLAN_NET_SIO, dev->base_addr + TLAN_DIO_ADR);
 	sio = dev->base_addr + TLAN_DIO_DATA + TLAN_NET_SIO;
 
@@ -2939,7 +2939,7 @@ int TLan_MiiReadReg( struct net_device *dev, u16 phy, u16 reg, u16 *val )
 			TLan_SetBit(TLAN_NET_SIO_MCLK, sio);
 		}
 		tmp = 0xffff;
-		err = TRUE;
+		err = true;
 	} else {					/* ACK, so read data */
 		for (tmp = 0, i = 0x8000; i; i >>= 1) {
 			TLan_ClearBit(TLAN_NET_SIO_MCLK, sio);
diff --git a/drivers/net/tlan.h b/drivers/net/tlan.h
index 41ce0b6..e0791aa 100644
--- a/drivers/net/tlan.h
+++ b/drivers/net/tlan.h
@@ -33,9 +33,6 @@
 	 *
 	 ****************************************************************/
 
-#define FALSE			0
-#define TRUE			1
-
 #define TLAN_MIN_FRAME_SIZE	64
 #define TLAN_MAX_FRAME_SIZE	1600
 
@@ -204,7 +201,7 @@ typedef struct tlan_private_tag {
 	u32			phyNum;
 	u32			speed;
 	u8			tlanRev;
-	u8			tlanFullDuplex;
+	bool			tlanFullDuplex : 8;
 	char                    devName[8];
 	spinlock_t		lock;
 	u8			link;
