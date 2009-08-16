Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZHPTbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZHPTbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbZHPTbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:31:16 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:55539 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbZHPTbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:31:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BEPgtjoi9+mZkmDftbqidKi37XQ31lCJvnipplNPWbI0tQeZRrv1sM6qeFaFoI7CtI
         S/w6hd1GP3z5OVO4CFDzAZJp+MT+7PvVroit0X8aRduwZkOl52uGMy9TRjEDLAXlR7R5
         ZMp+B8xWZIiafwK8bRnsyslT8y9IjmMn+2o8g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:31:24 +0200
Message-Id: <20090816193124.3789.18962.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/22] Staging: rtxxx0: remove dead DBG_DIAGNOSE code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: remove dead DBG_DIAGNOSE code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/cmm_data.c  |   40 -----------------
 drivers/staging/rt2860/common/rtmp_init.c |   67 ------------------------------
 drivers/staging/rt2860/rtmp.h             |   32 --------------
 3 files changed, 139 deletions(-)

Index: b/drivers/staging/rt2860/common/cmm_data.c
===================================================================
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -1096,10 +1096,6 @@ VOID RTMPDeQueuePacket(
 	TX_BLK			TxBlk;
 	TX_BLK			*pTxBlk;
 
-#ifdef DBG_DIAGNOSE
-	BOOLEAN			firstRound;
-	RtmpDiagStruct	*pDiagStruct = &pAd->DiagStruct;
-#endif
 
 
 	if (QIdx == NUM_OF_TX_RING)
@@ -1119,9 +1115,6 @@ VOID RTMPDeQueuePacket(
 
 		RT28XX_START_DEQUEUE(pAd, QueIdx, IrqFlags);
 
-#ifdef DBG_DIAGNOSE
-		firstRound = ((QueIdx == 0) ? TRUE : FALSE);
-#endif // DBG_DIAGNOSE //
 
 		while (1)
 		{
@@ -1141,31 +1134,12 @@ VOID RTMPDeQueuePacket(
 			DEQUEUE_LOCK(&pAd->irq_lock, bIntContext, IrqFlags);
 			if (&pAd->TxSwQueue[QueIdx] == NULL)
 			{
-#ifdef DBG_DIAGNOSE
-				if (firstRound == TRUE)
-					pDiagStruct->TxSWQueCnt[pDiagStruct->ArrayCurIdx][0]++;
-#endif // DBG_DIAGNOSE //
 				DEQUEUE_UNLOCK(&pAd->irq_lock, bIntContext, IrqFlags);
 				break;
 			}
 #ifdef RT2860
 			FreeNumber[QueIdx] = GET_TXRING_FREENO(pAd, QueIdx);
 
-#ifdef DBG_DIAGNOSE
-			if (firstRound == TRUE)
-			{
-				UCHAR	txDescNumLevel, txSwQNumLevel;
-
-				txDescNumLevel = (TX_RING_SIZE - FreeNumber[QueIdx]); // Number of occupied hw desc.
-				txDescNumLevel = ((txDescNumLevel <=15) ? txDescNumLevel : 15);
-				pDiagStruct->TxDescCnt[pDiagStruct->ArrayCurIdx][txDescNumLevel]++;
-
-				txSwQNumLevel = ((pAd->TxSwQueue[QueIdx].Number <=7) ? pAd->TxSwQueue[QueIdx].Number : 8);
-				pDiagStruct->TxSWQueCnt[pDiagStruct->ArrayCurIdx][txSwQNumLevel]++;
-
-				firstRound = FALSE;
-			}
-#endif // DBG_DIAGNOSE //
 
 			if (FreeNumber[QueIdx] <= 5)
 			{
@@ -1533,13 +1507,6 @@ VOID RTMPWriteTxWI_Data(
 		}
 	}
 
-#ifdef DBG_DIAGNOSE
-		if (pTxBlk->QueIdx== 0)
-		{
-			pAd->DiagStruct.TxDataCnt[pAd->DiagStruct.ArrayCurIdx]++;
-			pAd->DiagStruct.TxMcsCnt[pAd->DiagStruct.ArrayCurIdx][pTxWI->MCS]++;
-		}
-#endif // DBG_DIAGNOSE //
 
 	// for rate adapation
 	pTxWI->PacketId = pTxWI->MCS;
@@ -1598,13 +1565,6 @@ VOID RTMPWriteTxWI_Cache(
 		}
 	}
 
-#ifdef DBG_DIAGNOSE
-	if (pTxBlk->QueIdx== 0)
-	{
-		pAd->DiagStruct.TxDataCnt[pAd->DiagStruct.ArrayCurIdx]++;
-		pAd->DiagStruct.TxMcsCnt[pAd->DiagStruct.ArrayCurIdx][pTxWI->MCS]++;
-	}
-#endif // DBG_DIAGNOSE //
 
 	pTxWI->MPDUtotalByteCount = pTxBlk->MpduHeaderLen + pTxBlk->SrcBufLen;
 
Index: b/drivers/staging/rt2860/common/rtmp_init.c
===================================================================
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -3022,73 +3022,6 @@ VOID NICUpdateRawCounters(
 		pAd->RalinkCounters.TransmittedAMPDUCount.u.LowPart += (TxAggCnt7.field.AggSize16Count / 16);
 	}
 
-#ifdef DBG_DIAGNOSE
-	{
-		RtmpDiagStruct	*pDiag;
-		COUNTER_RALINK	*pRalinkCounters;
-		UCHAR			ArrayCurIdx, i;
-
-		pDiag = &pAd->DiagStruct;
-		pRalinkCounters = &pAd->RalinkCounters;
-		ArrayCurIdx = pDiag->ArrayCurIdx;
-
-		if (pDiag->inited == 0)
-		{
-			NdisZeroMemory(pDiag, sizeof(struct _RtmpDiagStrcut_));
-			pDiag->ArrayStartIdx = pDiag->ArrayCurIdx = 0;
-			pDiag->inited = 1;
-		}
-		else
-		{
-			// Tx
-			pDiag->TxFailCnt[ArrayCurIdx] = TxStaCnt0.field.TxFailCount;
-			pDiag->TxAggCnt[ArrayCurIdx] = TxAggCnt.field.AggTxCount;
-			pDiag->TxNonAggCnt[ArrayCurIdx] = TxAggCnt.field.NonAggTxCount;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][0] = TxAggCnt0.field.AggSize1Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][1] = TxAggCnt0.field.AggSize2Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][2] = TxAggCnt1.field.AggSize3Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][3] = TxAggCnt1.field.AggSize4Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][4] = TxAggCnt2.field.AggSize5Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][5] = TxAggCnt2.field.AggSize6Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][6] = TxAggCnt3.field.AggSize7Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][7] = TxAggCnt3.field.AggSize8Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][8] = TxAggCnt4.field.AggSize9Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][9] = TxAggCnt4.field.AggSize10Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][10] = TxAggCnt5.field.AggSize11Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][11] = TxAggCnt5.field.AggSize12Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][12] = TxAggCnt6.field.AggSize13Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][13] = TxAggCnt6.field.AggSize14Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][14] = TxAggCnt7.field.AggSize15Count;
-			pDiag->TxAMPDUCnt[ArrayCurIdx][15] = TxAggCnt7.field.AggSize16Count;
-
-			pDiag->RxCrcErrCnt[ArrayCurIdx] = RxStaCnt0.field.CrcErr;
-
-			INC_RING_INDEX(pDiag->ArrayCurIdx,  DIAGNOSE_TIME);
-			ArrayCurIdx = pDiag->ArrayCurIdx;
-			for (i =0; i < 9; i++)
-			{
-				pDiag->TxDescCnt[ArrayCurIdx][i]= 0;
-				pDiag->TxSWQueCnt[ArrayCurIdx][i] =0;
-				pDiag->TxMcsCnt[ArrayCurIdx][i] = 0;
-				pDiag->RxMcsCnt[ArrayCurIdx][i] = 0;
-			}
-			pDiag->TxDataCnt[ArrayCurIdx] = 0;
-			pDiag->TxFailCnt[ArrayCurIdx] = 0;
-			pDiag->RxDataCnt[ArrayCurIdx] = 0;
-			pDiag->RxCrcErrCnt[ArrayCurIdx]  = 0;
-			for (i = 9; i < 24; i++) // 3*3
-			{
-				pDiag->TxDescCnt[ArrayCurIdx][i] = 0;
-				pDiag->TxMcsCnt[ArrayCurIdx][i] = 0;
-				pDiag->RxMcsCnt[ArrayCurIdx][i] = 0;
-}
-
-			if (pDiag->ArrayCurIdx == pDiag->ArrayStartIdx)
-				INC_RING_INDEX(pDiag->ArrayStartIdx,  DIAGNOSE_TIME);
-		}
-
-	}
-#endif // DBG_DIAGNOSE //
 
 
 }
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -45,8 +45,6 @@
 
 #include "aironet.h"
 
-//#define DBG_DIAGNOSE		1
-
 #define VIRTUAL_IF_INC(__pAd) ((__pAd)->VirtualIfCnt++)
 #define VIRTUAL_IF_DEC(__pAd) ((__pAd)->VirtualIfCnt--)
 #define VIRTUAL_IF_NUM(__pAd) ((__pAd)->VirtualIfCnt)
@@ -2518,33 +2516,6 @@ typedef struct _INF_USB_CONFIG
 
 }INF_USB_CONFIG;
 
-#ifdef DBG_DIAGNOSE
-#define DIAGNOSE_TIME	10   // 10 sec
-typedef struct _RtmpDiagStrcut_
-{	// Diagnosis Related element
-	unsigned char		inited;
-	unsigned char 	qIdx;
-	unsigned char 	ArrayStartIdx;
-	unsigned char		ArrayCurIdx;
-	// Tx Related Count
-	USHORT			TxDataCnt[DIAGNOSE_TIME];
-	USHORT			TxFailCnt[DIAGNOSE_TIME];
-	USHORT			TxDescCnt[DIAGNOSE_TIME][24]; // 3*3	// TxDesc queue length in scale of 0~14, >=15
-	USHORT			TxMcsCnt[DIAGNOSE_TIME][24]; // 3*3
-	USHORT			TxSWQueCnt[DIAGNOSE_TIME][9];		// TxSwQueue length in scale of 0, 1, 2, 3, 4, 5, 6, 7, >=8
-
-	USHORT			TxAggCnt[DIAGNOSE_TIME];
-	USHORT			TxNonAggCnt[DIAGNOSE_TIME];
-	USHORT			TxAMPDUCnt[DIAGNOSE_TIME][24]; // 3*3 // 10 sec, TxDMA APMDU Aggregation count in range from 0 to 15, in setp of 1.
-	USHORT			TxRalinkCnt[DIAGNOSE_TIME];			// TxRalink Aggregation Count in 1 sec scale.
-	USHORT			TxAMSDUCnt[DIAGNOSE_TIME];			// TxAMSUD Aggregation Count in 1 sec scale.
-
-	// Rx Related Count
-	USHORT			RxDataCnt[DIAGNOSE_TIME];			// Rx Total Data count.
-	USHORT			RxCrcErrCnt[DIAGNOSE_TIME];
-	USHORT			RxMcsCnt[DIAGNOSE_TIME][24]; // 3*3
-}RtmpDiagStruct;
-#endif // DBG_DIAGNOSE //
 
 
 //
@@ -2965,9 +2936,6 @@ typedef struct _RTMP_ADAPTER
 	UCHAR					flg_be_adjust;
 	ULONG					be_adjust_last_time;
 
-#ifdef DBG_DIAGNOSE
-	RtmpDiagStruct	DiagStruct;
-#endif // DBG_DIAGNOSE //
 
 
 	UINT8					PM_FlgSuspend;
