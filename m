Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0CAPOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:14:14 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60557 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0CAPOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:10 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 23/26] w35und: Convert T02_DESCRIPTOR typedef to struct wb35_T02_descriptor
Date: Mon,  1 Mar 2010 17:04:25 +0200
Message-Id: <1267455868-4533-23-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mds.c     |    2 +-
 drivers/staging/winbond/mds_f.h   |    2 +-
 drivers/staging/winbond/wb35tx.c  |    2 +-
 drivers/staging/winbond/wbhal_s.h |    7 +++----
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index b9dbb2c..403149f 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -550,7 +550,7 @@ Mds_Tx(struct wbsoft_priv * adapter)
 }
 
 void
-Mds_SendComplete(struct wbsoft_priv * adapter, PT02_DESCRIPTOR pT02)
+Mds_SendComplete(struct wbsoft_priv * adapter, struct wb35_T02_descriptor * pT02)
 {
 	struct wb35_mds *pMds = &adapter->Mds;
 	struct hw_data *	pHwData = &adapter->sHwData;
diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
index e09dd4b..e5e3b4e 100644
--- a/drivers/staging/winbond/mds_f.h
+++ b/drivers/staging/winbond/mds_f.h
@@ -7,7 +7,7 @@
 unsigned char Mds_initial(  struct wbsoft_priv *adapter );
 void Mds_Destroy(  struct wbsoft_priv *adapter );
 void Mds_Tx(  struct wbsoft_priv *adapter );
-void Mds_SendComplete(  struct wbsoft_priv *adapter,  PT02_DESCRIPTOR pT02 );
+void Mds_SendComplete(  struct wbsoft_priv *adapter,  struct wb35_T02_descriptor * pT02 );
 void Mds_MpduProcess(  struct wbsoft_priv *adapter,  struct wb35_descriptor *pRxDes );
 extern void DataDmp(u8 *pdata, u32 len, u32 offset);
 
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 5869ef4..615e20e 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -209,7 +209,7 @@ static void Wb35Tx_EP2VM_complete(struct urb * pUrb)
 {
 	struct wbsoft_priv *adapter = pUrb->context;
 	struct hw_data *	pHwData = &adapter->sHwData;
-	T02_DESCRIPTOR	T02, TSTATUS;
+	struct wb35_T02_descriptor	T02, TSTATUS;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	u32 *		pltmp = (u32 *)pWb35Tx->EP2_buf;
 	u32		i;
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index 00329df..d8c32c0 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -261,8 +261,7 @@ struct wb35_T01_descriptor {
 	};
 };
 
-typedef struct _T02_DESCRIPTOR
-{
+struct wb35_T02_descriptor {
 	union
 	{
 		u32	value;
@@ -308,7 +307,7 @@ typedef struct _T02_DESCRIPTOR
 		};
 		#endif
 	};
-} T02_DESCRIPTOR, *PT02_DESCRIPTOR;
+};
 
 struct wb35_descriptor {		// Skip length = 8 DWORD
 	// ID for descriptor ---, The field doesn't be cleard in the operation of Descriptor definition
@@ -343,7 +342,7 @@ struct wb35_descriptor {		// Skip length = 8 DWORD
 	union
 	{
 		u32			R02;
-		T02_DESCRIPTOR	T02;
+		struct wb35_T02_descriptor	T02;
 	};
 
 	// For R03 and T03 ----------------------------------------------
-- 
1.6.3.3

