Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab0CAPMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:12:55 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46342 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0CAPMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:12:52 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 01/26] w35und: Remove unused struct _RXLAYER1
Date: Mon,  1 Mar 2010 17:04:03 +0200
Message-Id: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mds_f.h |    3 ---
 drivers/staging/winbond/mds_s.h |   28 ----------------------------
 2 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index ab1ea53..e09dd4b 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -11,9 +11,6 @@ void Mds_SendComplete(  struct wbsoft_priv *adapter,  PT02_DESCRIPTOR pT02 );
 void Mds_MpduProcess(  struct wbsoft_priv *adapter,  struct wb35_descriptor *pRxDes );
 extern void DataDmp(u8 *pdata, u32 len, u32 offset);
 
-// For Asynchronous indicating. The routine collocates with USB.
-void Mds_MsduProcess(  struct wbsoft_priv *adapter,  PRXLAYER1 pRxLayer1,  u8 SlotIndex);
-
 // For data frame sending 20060802
 u16 MDS_GetPacketSize(  struct wbsoft_priv *adapter );
 void MDS_GetNextPacket(  struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes );
diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index e8e13bd..217ff08 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -133,32 +133,4 @@ struct wb35_mds {
 
 };
 
-//
-// Reveive Layer 1 Format.
-//----------------------------
-typedef struct _RXLAYER1
-{
-    u16  SequenceNumber;     // The sequence number of the last received packet.
-	u16	BufferTotalSize;
-
-	u32	InUsed;
-    u32   DecryptionMethod;   // The desired defragment number of the next incoming packet.
-
-	u8	DeFragmentNumber;
-	u8	FrameType;
-    u8	TypeEncapsulated;
-	u8	BufferNumber;
-
-	u32	FirstFrameArrivedTime;
-
-	u8		LastFrameType; // 20061004 for fix intel 3945 's bug
-	u8		RESERVED[3];  //@@ anson
-
-	/////////////////////////////////////////////////////////////////////////////////////////////
-	// For brand-new Rx system
-	u8	ReservedBuffer[ 2400 ];//If Buffer ID is reserved one, it must copy the data into this area
-	u8	*ReservedBufferPoint;// Point to the next availabe address of reserved buffer
-
-}RXLAYER1, * PRXLAYER1;
-
 #endif
-- 
1.6.3.3

