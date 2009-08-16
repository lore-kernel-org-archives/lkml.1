Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbZHPT3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbZHPT3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbZHPT33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:29:29 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:49711 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbZHPT32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wwsUK0KfdTzU85kUBXXfeQxyleOBEAggs4Pn2o+FhTRQFtysajRc5IzBk1xEAcwka2
         Bxcjadd2SPTK6UMkdoaKY7As+bCvevUUDmyYy1ORhfdZko+8GtH9a4jTKLy6SVG9ZfBK
         +wjl546qbEnSGRr4CwraU92OthdpWrEjQ3y9M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:29:41 +0200
Message-Id: <20090816192941.3789.31932.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/22] Staging: rt2870: duplicated code is executed twice in AsicEvaluateRxAnt()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt2870: duplicated code is executed twice in AsicEvaluateRxAnt()

Fix it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |   20 --------------------
 1 file changed, 20 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -8433,26 +8433,6 @@ VOID AsicEvaluateRxAnt(
 #ifdef RT2860
     	pAd->StaCfg.BBPR3 = BBPR3;
 #endif
-#ifdef RT2870
-	if (OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_MEDIA_STATE_CONNECTED)
-		)
-	{
-		ULONG	TxTotalCnt = pAd->RalinkCounters.OneSecTxNoRetryOkCount +
-								pAd->RalinkCounters.OneSecTxRetryOkCount +
-								pAd->RalinkCounters.OneSecTxFailCount;
-
-		if (TxTotalCnt > 50)
-		{
-			RTMPSetTimer(&pAd->Mlme.RxAntEvalTimer, 20);
-			pAd->Mlme.bLowThroughput = FALSE;
-		}
-		else
-		{
-			RTMPSetTimer(&pAd->Mlme.RxAntEvalTimer, 300);
-			pAd->Mlme.bLowThroughput = TRUE;
-		}
-	}
-#endif
 #endif /* RT30xx */
 #ifdef RT30xx
 	if (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_RESET_IN_PROGRESS	|
