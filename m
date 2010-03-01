Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab0CAPRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:17:45 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60576 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0CAPOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:12 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 21/26] w35und: Convert T00_DESCRIPTOR typedef to struct wb35_T00_descriptor
Date: Mon,  1 Mar 2010 17:04:23 +0200
Message-Id: <1267455868-4533-21-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mds.c     |   22 +++++++++++-----------
 drivers/staging/winbond/wbhal_s.h |    7 +++----
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 37e0c18..de8cec9 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -24,12 +24,12 @@ Mds_Destroy(struct wbsoft_priv * adapter)
 
 static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes,  u8 *buffer)
 {
-	PT00_DESCRIPTOR	pT00;
+	struct wb35_T00_descriptor *	pT00;
 	PT01_DESCRIPTOR	pT01;
 	u16	Duration, NextBodyLen, OffsetSize;
 	u8	Rate, i;
 	unsigned char	CTS_on = false, RTS_on = false;
-	PT00_DESCRIPTOR pNextT00;
+	struct wb35_T00_descriptor * pNextT00;
 	u16 BodyLen = 0;
 	unsigned char boGroupAddr = false;
 
@@ -39,9 +39,9 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 	if (!Rate)
 		Rate = 1;
 
-	pT00 = (PT00_DESCRIPTOR)buffer;
+	pT00 = (struct wb35_T00_descriptor *)buffer;
 	pT01 = (PT01_DESCRIPTOR)(buffer+4);
-	pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
+	pNextT00 = (struct wb35_T00_descriptor *)(buffer+OffsetSize);
 
 	if( buffer[ DOT_11_DA_OFFSET+8 ] & 0x1 ) // +8 for USB hdr
 		boGroupAddr = true;
@@ -178,7 +178,7 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 			buffer += OffsetSize;
 			pT01 = (PT01_DESCRIPTOR)(buffer+4);
 			if (i != 1)	//The last fragment will not have the next fragment
-				pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
+				pNextT00 = (struct wb35_T00_descriptor *)(buffer+OffsetSize);
 		}
 
 		//=====================================
@@ -219,7 +219,7 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 // The function return the 4n size of usb pk
 static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes, u8 *TargetBuffer)
 {
-	PT00_DESCRIPTOR	pT00;
+	struct wb35_T00_descriptor *	pT00;
 	struct wb35_mds *pMds = &adapter->Mds;
 	u8	*buffer;
 	u8	*src_buffer;
@@ -234,9 +234,9 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 	SizeLeft = pDes->buffer_total_size;
 	buf_index = pDes->buffer_start_index;
 
-	pT00 = (PT00_DESCRIPTOR)buffer;
+	pT00 = (struct wb35_T00_descriptor *)buffer;
 	while (SizeLeft) {
-		pT00 = (PT00_DESCRIPTOR)buffer;
+		pT00 = (struct wb35_T00_descriptor *)buffer;
 		CopySize = SizeLeft;
 		if (SizeLeft > pDes->FragmentThreshold) {
 			CopySize = pDes->FragmentThreshold;
@@ -303,7 +303,7 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 		if (SizeLeft) {
 			buffer = TargetBuffer + Size; // Get the next 4n start address
 			memcpy( buffer, TargetBuffer, 32 );//Copy 8B USB +24B 802.11
-			pT00 = (PT00_DESCRIPTOR)buffer;
+			pT00 = (struct wb35_T00_descriptor *)buffer;
 			pT00->T00_first_mpdu = 0;
 		}
 
@@ -322,7 +322,7 @@ static void Mds_HeaderCopy(struct wbsoft_priv * adapter, struct wb35_descriptor
 {
 	struct wb35_mds *pMds = &adapter->Mds;
 	u8	*src_buffer = pDes->buffer_address[0];//931130.5.g
-	PT00_DESCRIPTOR	pT00;
+	struct wb35_T00_descriptor *	pT00;
 	PT01_DESCRIPTOR	pT01;
 	u16	stmp;
 	u8	i, ctmp1, ctmp2, ctmpf;
@@ -333,7 +333,7 @@ static void Mds_HeaderCopy(struct wbsoft_priv * adapter, struct wb35_descriptor
 	//
 	// Set USB header 8 byte
 	//
-	pT00 = (PT00_DESCRIPTOR)TargetBuffer;
+	pT00 = (struct wb35_T00_descriptor *)TargetBuffer;
 	TargetBuffer += 4;
 	pT01 = (PT01_DESCRIPTOR)TargetBuffer;
 	TargetBuffer += 4;
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index e772fad..1185205 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -133,8 +133,7 @@ struct wb35_R00_descriptor {
 	};
 };
 
-typedef struct _T00_DESCRIPTOR
-{
+struct wb35_T00_descriptor {
 	union
 	{
 		u32	value;
@@ -166,7 +165,7 @@ typedef struct _T00_DESCRIPTOR
 		};
 		#endif
 	};
-} T00_DESCRIPTOR, *PT00_DESCRIPTOR;
+};
 
 struct wb35_R01_descriptor {
 	union
@@ -331,7 +330,7 @@ struct wb35_descriptor {		// Skip length = 8 DWORD
 	union
 	{
 		struct wb35_R00_descriptor	R00;
-		T00_DESCRIPTOR	T00;
+		struct wb35_T00_descriptor	T00;
 	};
 
 	// For R01 and T01 ----------------------------------------------
-- 
1.6.3.3

