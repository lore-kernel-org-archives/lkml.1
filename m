Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0CAPPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:15:37 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34579 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0CAPO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:56 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 22/26] w35und: Convert T01_DESCRIPTOR typedef to struct wb35_T01_descriptor
Date: Mon,  1 Mar 2010 17:04:24 +0200
Message-Id: <1267455868-4533-22-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mds.c     |   10 +++++-----
 drivers/staging/winbond/wbhal_s.h |    7 +++----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index de8cec9..b9dbb2c 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -25,7 +25,7 @@ Mds_Destroy(struct wbsoft_priv * adapter)
 static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes,  u8 *buffer)
 {
 	struct wb35_T00_descriptor *	pT00;
-	PT01_DESCRIPTOR	pT01;
+	struct wb35_T01_descriptor *	pT01;
 	u16	Duration, NextBodyLen, OffsetSize;
 	u8	Rate, i;
 	unsigned char	CTS_on = false, RTS_on = false;
@@ -40,7 +40,7 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 		Rate = 1;
 
 	pT00 = (struct wb35_T00_descriptor *)buffer;
-	pT01 = (PT01_DESCRIPTOR)(buffer+4);
+	pT01 = (struct wb35_T01_descriptor *)(buffer+4);
 	pNextT00 = (struct wb35_T00_descriptor *)(buffer+OffsetSize);
 
 	if( buffer[ DOT_11_DA_OFFSET+8 ] & 0x1 ) // +8 for USB hdr
@@ -176,7 +176,7 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 			//----end 20061009 add by anson's endian
 
 			buffer += OffsetSize;
-			pT01 = (PT01_DESCRIPTOR)(buffer+4);
+			pT01 = (struct wb35_T01_descriptor *)(buffer+4);
 			if (i != 1)	//The last fragment will not have the next fragment
 				pNextT00 = (struct wb35_T00_descriptor *)(buffer+OffsetSize);
 		}
@@ -323,7 +323,7 @@ static void Mds_HeaderCopy(struct wbsoft_priv * adapter, struct wb35_descriptor
 	struct wb35_mds *pMds = &adapter->Mds;
 	u8	*src_buffer = pDes->buffer_address[0];//931130.5.g
 	struct wb35_T00_descriptor *	pT00;
-	PT01_DESCRIPTOR	pT01;
+	struct wb35_T01_descriptor *	pT01;
 	u16	stmp;
 	u8	i, ctmp1, ctmp2, ctmpf;
 	u16	FragmentThreshold = CURRENT_FRAGMENT_THRESHOLD;
@@ -335,7 +335,7 @@ static void Mds_HeaderCopy(struct wbsoft_priv * adapter, struct wb35_descriptor
 	//
 	pT00 = (struct wb35_T00_descriptor *)TargetBuffer;
 	TargetBuffer += 4;
-	pT01 = (PT01_DESCRIPTOR)TargetBuffer;
+	pT01 = (struct wb35_T01_descriptor *)TargetBuffer;
 	TargetBuffer += 4;
 
 	pT00->value = 0;// Clear
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index 1185205..00329df 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -221,8 +221,7 @@ struct wb35_R01_descriptor {
 	};
 };
 
-typedef struct _T01_DESCRIPTOR
-{
+struct wb35_T01_descriptor {
 	union
 	{
 		u32	value;
@@ -260,7 +259,7 @@ typedef struct _T01_DESCRIPTOR
 		};
 		#endif
 	};
-} T01_DESCRIPTOR, *PT01_DESCRIPTOR;
+};
 
 typedef struct _T02_DESCRIPTOR
 {
@@ -337,7 +336,7 @@ struct wb35_descriptor {		// Skip length = 8 DWORD
 	union
 	{
 		struct wb35_R01_descriptor	R01;
-		T01_DESCRIPTOR	T01;
+		struct wb35_T01_descriptor	T01;
 	};
 
 	// For R02 and T02 ----------------------------------------------
-- 
1.6.3.3

