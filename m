Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab0CAPQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:16:20 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60578 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab0CAPOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:17 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 13/26] w35und: Remove unused struct _MLMECALLBACK
Date: Mon,  1 Mar 2010 17:04:15 +0200
Message-Id: <1267455868-4533-13-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mlme_s.h   |    7 -------
 drivers/staging/winbond/mlmetxrx.c |    5 -----
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
index cab3b38..2126d13 100644
--- a/drivers/staging/winbond/mlme_s.h
+++ b/drivers/staging/winbond/mlme_s.h
@@ -158,13 +158,6 @@ typedef struct _MLME_FRAME
                     	            //  excluding the discarded
 } MLME_FRAME, *psMLME_FRAME;
 
-typedef struct _MLMECALLBACK {
-
-  u8 	*psFramePtr;
-  u8		bResult;
-
-} MLME_TXCALLBACK, *psMLME_TXCALLBACK;
-
 typedef struct _RXDATA
 {
 	s32		FrameLength;
diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
index f856b94..4f16121 100644
--- a/drivers/staging/winbond/mlmetxrx.c
+++ b/drivers/staging/winbond/mlmetxrx.c
@@ -76,15 +76,10 @@ static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *pData)
 void
 MLME_SendComplete(struct wbsoft_priv * adapter, u8 PacketID, unsigned char SendOK)
 {
-	MLME_TXCALLBACK	TxCallback;
-
     // Reclaim the data buffer
 	adapter->sMlmeFrame.len = 0;
 	MLMEfreeMMPDUBuffer( adapter, adapter->sMlmeFrame.pMMPDU );
 
-
-	TxCallback.bResult = MLME_SUCCESS;
-
 	// Return resource
 	adapter->sMlmeFrame.IsInUsed = PACKET_FREE_TO_USE;
 }
-- 
1.6.3.3

