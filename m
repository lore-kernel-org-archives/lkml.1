Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZHPTbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZHPTbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZHPTb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:31:29 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:55539 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbZHPTbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mWcc3AVZs0q6P3OLW0oNQI7a3vCCwlvxV9zm/19I1lQu0OBuibL3GhTSVWusZFv9QB
         Y37U4ea52wb36VnflWkmPwPfRgw99UWCDChP5pSk6Qamuh7EOASaDSF9fxChAA99sWBN
         27CFBTRL8s0PoN2A39nusBagP7yg4GK0IZBbQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:31:36 +0200
Message-Id: <20090816193136.3789.19766.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/22] Staging: rtxxx0: debug messages fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: debug messages fixes

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/ba_action.c      |    7 -------
 drivers/staging/rt2860/common/mlme.c           |   14 +-------------
 drivers/staging/rt2860/common/spectrum.c       |    5 -----
 drivers/staging/rt2860/rt_linux.c              |    5 -----
 drivers/staging/rt2860/sta/sync.c              |    2 --
 drivers/staging/rt2870/common/2870_rtmp_init.c |    5 -----
 6 files changed, 1 insertion(+), 37 deletions(-)

Index: b/drivers/staging/rt2860/common/ba_action.c
===================================================================
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -531,12 +531,10 @@ VOID BAOriSessionSetUp(
 	pBAEntry->TimeOutValue = TimeOut;
 	pBAEntry->pAdapter = pAd;
 
-#ifdef RT30xx
 	DBGPRINT(RT_DEBUG_TRACE,("Send AddBA to %02x:%02x:%02x:%02x:%02x:%02x Tid:%d isForced:%d Wcid:%d\n"
 		,pEntry->Addr[0],pEntry->Addr[1],pEntry->Addr[2]
 		,pEntry->Addr[3],pEntry->Addr[4],pEntry->Addr[5]
 		,TID,isForced,pEntry->Aid));
-#endif
 
 	if (!(pEntry->TXBAbitmap & (1<<TID)))
 	{
@@ -1078,16 +1076,11 @@ VOID BAOriSessionSetupTimeout(
 		AddbaReq.Token = pBAEntry->Token;
 		MlmeEnqueue(pAd, ACTION_STATE_MACHINE, MT2_MLME_ADD_BA_CATE, sizeof(MLME_ADDBA_REQ_STRUCT), (PVOID)&AddbaReq);
 		RT28XX_MLME_HANDLER(pAd);
-#ifndef RT30xx
-		DBGPRINT(RT_DEBUG_TRACE,("BA Ori Session Timeout(%d) : Send ADD BA again\n", pBAEntry->Token));
-#endif
-#ifdef RT30xx
 		DBGPRINT(RT_DEBUG_TRACE,("BA Ori Session Timeout(%d) to %02x:%02x:%02x:%02x:%02x:%02x Tid:%d Wcid:%d\n"
 		,pBAEntry->Token
 		,pEntry->Addr[0],pEntry->Addr[1],pEntry->Addr[2]
 		,pEntry->Addr[3],pEntry->Addr[4],pEntry->Addr[5]
 		,pBAEntry->TID,pEntry->Aid));
-#endif
 		pBAEntry->Token++;
 		RTMPSetTimer(&pBAEntry->ORIBATimer, ORI_BA_SESSION_TIMEOUT);
 	}
Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -2845,9 +2845,8 @@ VOID MlmeSetPsmBit(
 	RTMP_IO_READ32(pAd, AUTO_RSP_CFG, &csr4.word);
 	csr4.field.AckCtsPsmBit = (psm == PWR_SAVE)? 1:0;
 	RTMP_IO_WRITE32(pAd, AUTO_RSP_CFG, csr4.word);
-#ifndef RT30xx
+
 	DBGPRINT(RT_DEBUG_TRACE, ("MlmeSetPsmBit = %d\n", psm));
-#endif
 }
 
 // IRQL = DISPATCH_LEVEL
@@ -5842,14 +5841,7 @@ VOID AsicSwitchChannel(
 #endif
 
 	if (index == MAX_NUM_OF_CHANNELS)
-	{
-#ifndef RT30xx
-		DBGPRINT(RT_DEBUG_ERROR, ("AsicSwitchChannel: Cant find the Channel#%d \n", Channel));
-#endif
-#ifdef RT30xx
 		DBGPRINT(RT_DEBUG_ERROR, ("AsicSwitchChannel: Can't find the Channel#%d \n", Channel));
-#endif
-	}
 
 #ifdef RT2870
 	// The RF programming sequence is difference between 3xxx and 2xxx
@@ -5971,7 +5963,6 @@ VOID AsicSwitchChannel(
 			}
 		}
 
-#ifndef RT30xx
 		DBGPRINT(RT_DEBUG_TRACE, ("SwitchChannel#%d(RF=%d, Pwr0=%d, Pwr1=%d, %dT), N=0x%02X, K=0x%02X, R=0x%02X\n",
 			Channel,
 			pAd->RfIcType,
@@ -5981,7 +5972,6 @@ VOID AsicSwitchChannel(
 			FreqItems3020[index].N,
 			FreqItems3020[index].K,
 			FreqItems3020[index].R));
-#endif
 	}
 	else
 #endif // RT2870 //
@@ -9164,11 +9154,9 @@ VOID AsicTurnOnRFClk(
 			break;
 	}
 
-#ifndef RT30xx
 	DBGPRINT(RT_DEBUG_TRACE, ("AsicTurnOnRFClk#%d(RF=%d, ) , R2=0x%08x\n",
 		Channel,
 		pAd->RfIcType,
 		R2));
-#endif
 }
 
Index: b/drivers/staging/rt2860/common/spectrum.c
===================================================================
--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -1570,12 +1570,7 @@ static VOID PeerMeasureReportAction(
 
 	if ((pMeasureReportInfo = kmalloc(sizeof(MEASURE_RPI_REPORT), GFP_ATOMIC)) == NULL)
 	{
-#ifndef RT30xx
 		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%zu).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
-#endif
-#ifdef RT30xx
-		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
-#endif
 		return;
 	}
 
Index: b/drivers/staging/rt2860/rt_linux.c
===================================================================
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -826,12 +826,7 @@ void send_monitor_packets(
 
     if (pRxBlk->DataSize + sizeof(wlan_ng_prism2_header) > RX_BUFFER_AGGRESIZE)
     {
-#ifndef RT30xx
         DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%zu)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
-#endif
-#ifdef RT30xx
-        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
-#endif
 		goto err_free_sk_buff;
     }
 
Index: b/drivers/staging/rt2860/sta/sync.c
===================================================================
--- a/drivers/staging/rt2860/sta/sync.c
+++ b/drivers/staging/rt2860/sta/sync.c
@@ -1116,10 +1116,8 @@ VOID PeerBeacon(
 			// Add the safeguard against the mismatch of adhoc wep status
 			if (pAd->StaCfg.WepStatus != pAd->ScanTab.BssEntry[Bssidx].WepStatus)
 			{
-#ifdef RT30xx
 				DBGPRINT(RT_DEBUG_TRACE, ("SYNC - Not matched wep status %d %d\n", pAd->StaCfg.WepStatus, pAd->ScanTab.BssEntry[Bssidx].WepStatus));
 				DBGPRINT(RT_DEBUG_TRACE, ("bssid=%s\n", pAd->ScanTab.BssEntry[Bssidx].Bssid));
-#endif
 				return;
 			}
 
Index: b/drivers/staging/rt2870/common/2870_rtmp_init.c
===================================================================
--- a/drivers/staging/rt2870/common/2870_rtmp_init.c
+++ b/drivers/staging/rt2870/common/2870_rtmp_init.c
@@ -1263,9 +1263,7 @@ static void rt2870_hcca_dma_done_tasklet
 	UCHAR				BulkOutPipeId = 4;
 	purbb_t				pUrb;
 
-#ifndef RT30xx
 	DBGPRINT_RAW(RT_DEBUG_ERROR, ("--->hcca_dma_done_tasklet\n"));
-#endif
 
 	pUrb			= (purbb_t)data;
 	pHTTXContext	= (PHT_TX_CONTEXT)pUrb->context;
@@ -1305,10 +1303,7 @@ static void rt2870_hcca_dma_done_tasklet
 		}
 	}
 
-#ifndef RT30xx
 	DBGPRINT_RAW(RT_DEBUG_ERROR, ("<---hcca_dma_done_tasklet\n"));
-#endif
-		return;
 }
 
 
