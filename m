Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZHLIDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZHLIDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZHLIDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:03:41 -0400
Received: from smtp6.welho.com ([213.243.153.40]:57013 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbZHLIDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:03:39 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 2/7] w35und: Remove unused struct _RXBUFFER
Date: Wed, 12 Aug 2009 11:03:34 +0300
Message-Id: <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mds_s.h      |   12 ------------
 drivers/staging/winbond/mlmetxrx_f.h |    8 --------
 2 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/winbond/mds_s.h b/drivers/staging/winbond/mds_s.h
index d9ac2ec..e8e13bd 100644
--- a/drivers/staging/winbond/mds_s.h
+++ b/drivers/staging/winbond/mds_s.h
@@ -67,7 +67,6 @@ enum {
 
 #define RX_BUF_SIZE						2352        // 600 	// For 301 must be multiple of 8
 #define MAX_RX_DESCRIPTORS              18         // Rx Layer 2
-#define MAX_BUFFER_QUEUE	8 // The value is always equal 8 due to NDIS_PACKET's MiniportReserved field size
 
 
 // For brand-new rx system
@@ -134,15 +133,6 @@ struct wb35_mds {
 
 };
 
-
-typedef struct _RxBuffer
-{
-    u8 * pBufferAddress;     // Pointer the received data buffer.
-	u16	BufferSize;
-	u8	RESERVED;
-	u8	BufferIndex;// Only 1 byte
-} RXBUFFER, *PRXBUFFER;
-
 //
 // Reveive Layer 1 Format.
 //----------------------------
@@ -161,8 +151,6 @@ typedef struct _RXLAYER1
 
 	u32	FirstFrameArrivedTime;
 
-	RXBUFFER	BufferQueue[ MAX_BUFFER_QUEUE ];
-
 	u8		LastFrameType; // 20061004 for fix intel 3945 's bug
 	u8		RESERVED[3];  //@@ anson
 
diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
index 5f05a6e..26cf101 100644
--- a/drivers/staging/winbond/mlmetxrx_f.h
+++ b/drivers/staging/winbond/mlmetxrx_f.h
@@ -25,14 +25,6 @@ void
 MLME_SendComplete(  struct wbsoft_priv * adapter,  u8 PacketID,  unsigned char SendOK );
 
 void
-MLMERcvFrame(
-     struct wbsoft_priv *    adapter,
-     PRXBUFFER        pRxBufferArray,
-     u8            NumOfBuffer,
-     u8            ReturnSlotIndex
-	);
-
-void
 MLMEReturnPacket(
      struct wbsoft_priv *    adapter,
      u8 *          pRxBufer
-- 
1.5.6.3

