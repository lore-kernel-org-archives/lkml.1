Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZHLIE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZHLIE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZHLIDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:03:43 -0400
Received: from smtp6.welho.com ([213.243.153.40]:57008 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbZHLIDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:03:39 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 1/7] w35und: Commit MDS typedef to struct w35_mds
Date: Wed, 12 Aug 2009 11:03:33 +0300
Message-Id: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/core.h   |    2 +-
 drivers/staging/winbond/mds.c    |   10 +++++-----
 drivers/staging/winbond/mds_s.h  |    5 ++---
 drivers/staging/winbond/wb35tx.c |    4 ++--
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index eb4c090..42c9868 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -20,7 +20,7 @@ struct wbsoft_priv {
 
 	MTO_PARAMETERS sMtoPara;	// MTO_struct ...
 	struct hw_data sHwData;	//For HAL
-	MDS Mds;
+	struct wb35_mds Mds;
 
 	spinlock_t SpinLock;
 
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 59d6d67..9550e1a 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -8,7 +8,7 @@
 unsigned char
 Mds_initial(struct wbsoft_priv * adapter)
 {
-	PMDS pMds = &adapter->Mds;
+	struct wb35_mds *pMds = &adapter->Mds;
 
 	pMds->TxPause = false;
 	pMds->TxRTSThreshold = DEFAULT_RTSThreshold;
@@ -220,7 +220,7 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  PDESCRIPTOR pDes,  u8
 static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, PDESCRIPTOR pDes, u8 *TargetBuffer)
 {
 	PT00_DESCRIPTOR	pT00;
-	PMDS	pMds = &adapter->Mds;
+	struct wb35_mds *pMds = &adapter->Mds;
 	u8	*buffer;
 	u8	*src_buffer;
 	u8	*pctmp;
@@ -320,7 +320,7 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, PDESCRIPTOR pDes, u8 *Targe
 
 static void Mds_HeaderCopy(struct wbsoft_priv * adapter, PDESCRIPTOR pDes, u8 *TargetBuffer)
 {
-	PMDS	pMds = &adapter->Mds;
+	struct wb35_mds *pMds = &adapter->Mds;
 	u8	*src_buffer = pDes->buffer_address[0];//931130.5.g
 	PT00_DESCRIPTOR	pT00;
 	PT01_DESCRIPTOR	pT01;
@@ -417,7 +417,7 @@ void
 Mds_Tx(struct wbsoft_priv * adapter)
 {
 	struct hw_data *	pHwData = &adapter->sHwData;
-	PMDS		pMds = &adapter->Mds;
+	struct wb35_mds *pMds = &adapter->Mds;
 	DESCRIPTOR	TxDes;
 	PDESCRIPTOR	pTxDes = &TxDes;
 	u8		*XmitBufAddress;
@@ -552,7 +552,7 @@ Mds_Tx(struct wbsoft_priv * adapter)
 void
 Mds_SendComplete(struct wbsoft_priv * adapter, PT02_DESCRIPTOR pT02)
 {
-	PMDS	pMds = &adapter->Mds;
+	struct wb35_mds *pMds = &adapter->Mds;
 	struct hw_data *	pHwData = &adapter->sHwData;
 	u8	PacketId = (u8)pT02->T02_Tx_PktID;
 	unsigned char	SendOK = true;
diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index 9ffec17..d9ac2ec 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -79,8 +79,7 @@ enum {
 #define PACKET_COME_FROM_MLME					0x80
 #define PACKET_SEND_COMPLETE					0xff
 
-typedef struct _MDS
-{
+struct wb35_mds {
 	// For Tx usage
 	u8	TxOwner[ ((MAX_USB_TX_BUFFER_NUMBER + 3) & ~0x03) ];
 	u8	*pTxBuffer;
@@ -133,7 +132,7 @@ typedef struct _MDS
 	u32	TxTsc; // 20060214
 	u32	TxTsc_2; // 20060214
 
-} MDS, *PMDS;
+};
 
 
 typedef struct _RxBuffer
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 1e4169d..5869ef4 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -30,7 +30,7 @@ static void Wb35Tx_complete(struct urb * pUrb)
 	struct wbsoft_priv *adapter = pUrb->context;
 	struct hw_data *	pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
-	PMDS		pMds = &adapter->Mds;
+	struct wb35_mds *pMds = &adapter->Mds;
 
 	printk("wb35: tx complete\n");
 	// Variable setting
@@ -67,7 +67,7 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 	struct hw_data *	pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	u8		*pTxBufferAddress;
-	PMDS		pMds = &adapter->Mds;
+	struct wb35_mds *pMds = &adapter->Mds;
 	struct urb *	pUrb = (struct urb *)pWb35Tx->Tx4Urb;
 	int         	retv;
 	u32		SendIndex;
-- 
1.5.6.3

