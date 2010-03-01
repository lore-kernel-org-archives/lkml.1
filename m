Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab0CAPOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:14:19 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60558 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab0CAPOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:11 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 19/26] w35und: Convert R00_DESCRIPTOR typedef to struct wb35_R00_descriptor
Date: Mon,  1 Mar 2010 17:04:21 +0200
Message-Id: <1267455868-4533-19-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wb35rx.c  |    2 +-
 drivers/staging/winbond/wbhal_s.h |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index 4d41f6c..b7abee6 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -168,7 +168,7 @@ static void Wb35Rx_Complete(struct urb *urb)
 	u32		SizeCheck;
 	u16		BulkLength;
 	u32		RxBufferId;
-	R00_DESCRIPTOR 	R00;
+	struct wb35_R00_descriptor 	R00;
 
 	// Variable setting
 	pWb35Rx->EP3vm_state = VM_COMPLETED;
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index 372a05e..67cddb5 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -107,8 +107,7 @@ enum {
 
 #define FLAG_BAND_RX_MASK			0x10000000	//Bit 28
 
-typedef struct _R00_DESCRIPTOR
-{
+struct wb35_R00_descriptor {
 	union
 	{
 		u32	value;
@@ -132,7 +131,7 @@ typedef struct _R00_DESCRIPTOR
 		};
 		#endif
 	};
-} R00_DESCRIPTOR, *PR00_DESCRIPTOR;
+};
 
 typedef struct _T00_DESCRIPTOR
 {
@@ -332,7 +331,7 @@ struct wb35_descriptor {		// Skip length = 8 DWORD
 	// For R00 and T00 ----------------------------------------------
 	union
 	{
-		R00_DESCRIPTOR	R00;
+		struct wb35_R00_descriptor	R00;
 		T00_DESCRIPTOR	T00;
 	};
 
-- 
1.6.3.3

