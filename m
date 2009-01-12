Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbZALQDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbZALQDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZALQDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:03:42 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41751 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZALQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:03:41 -0500
Date: Mon, 12 Jan 2009 18:03:39 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] w35und: remove macro obfuscation from mto.c
Message-ID: <Pine.LNX.4.64.0901121803140.16815@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mto.c |   14 +++++++-------
 drivers/staging/winbond/mto.h |    8 +++-----
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index d77e330..2598a7e 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -55,12 +55,12 @@ static int PeriodTotalTxPktRetry = 0;
 
 static u8 boSparseTxTraffic = false;
 
-void MTO_Init(MTO_FUNC_INPUT);
-void TxRateReductionCtrl(MTO_FUNC_INPUT);
+void MTO_Init(struct wbsoft_priv *adapter);
+void TxRateReductionCtrl(struct wbsoft_priv *adapter);
 /** 1.1.31.1000 Turbo modify */
-void MTO_SetTxCount(MTO_FUNC_INPUT, u8 t0, u8 index);
-void MTO_TxFailed(MTO_FUNC_INPUT);
-void hal_get_dto_para(MTO_FUNC_INPUT, char *buffer);
+void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 t0, u8 index);
+void MTO_TxFailed(struct wbsoft_priv *adapter);
+void hal_get_dto_para(struct wbsoft_priv *adapter, char *buffer);
 
 //===========================================================================
 //  MTO_Init --
@@ -76,7 +76,7 @@ void hal_get_dto_para(MTO_FUNC_INPUT, char *buffer);
 //  Return Value:
 //    None
 //============================================================================
-void MTO_Init(MTO_FUNC_INPUT)
+void MTO_Init(struct wbsoft_priv *adapter)
 {
     int i;
 	//[WKCHEN]pMTOcore_data = pcore_data;
@@ -191,7 +191,7 @@ void MTO_Init(MTO_FUNC_INPUT)
 //      If we enable DTO, we will ignore the tx count with different tx rate from
 //      DTO rate. This is because when we adjust DTO tx rate, there could be some
 //      packets in the tx queue with previous tx rate
-void MTO_SetTxCount(MTO_FUNC_INPUT, u8 tx_rate, u8 index)
+void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 tx_rate, u8 index)
 {
 	MTO_TXFLOWCOUNT()++;
 	if ((MTO_ENABLE==1) && (MTO_RATE_CHANGE_ENABLE()==1))
diff --git a/drivers/staging/winbond/mto.h b/drivers/staging/winbond/mto.h
index 925c987..248b710 100644
--- a/drivers/staging/winbond/mto.h
+++ b/drivers/staging/winbond/mto.h
@@ -133,8 +133,6 @@ typedef struct _MTO_PARAMETERS
 } MTO_PARAMETERS, *PMTO_PARAMETERS;
 
 
-#define MTO_FUNC_INPUT              struct wbsoft_priv *	adapter
-#define MTO_FUNC_INPUT_DATA         adapter
 #define MTO_DATA()                  (adapter->sMtoPara)
 #define MTO_HAL()                   (&adapter->sHwData)
 #define MTO_SET_PREAMBLE_TYPE(x)    // 20040511 Turbo mark LM_PREAMBLE_TYPE(&pcore_data->lm_data) = (x)
@@ -264,9 +262,9 @@ typedef struct _STATISTICS_INFO {
 extern void MTO_Init(struct wbsoft_priv *);
 extern void MTO_PeriodicTimerExpired(struct wbsoft_priv *);
 extern void MTO_SetDTORateRange(struct wbsoft_priv *, u8 *, u8);
-extern u8 MTO_GetTxRate(MTO_FUNC_INPUT, u32 fpdu_len);
-extern u8 MTO_GetTxFallbackRate(MTO_FUNC_INPUT);
-extern void MTO_SetTxCount(MTO_FUNC_INPUT, u8 t0, u8 index);
+extern u8 MTO_GetTxRate(struct wbsoft_priv *adapter, u32 fpdu_len);
+extern u8 MTO_GetTxFallbackRate(struct wbsoft_priv *adapter);
+extern void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 t0, u8 index);
 
 #endif //__MTO_H__
 
-- 
1.5.4.3

