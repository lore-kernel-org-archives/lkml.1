Return-Path: <linux-kernel-owner+w=401wt.eu-S934010AbZHWNak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010AbZHWNak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933999AbZHWNah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:30:37 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975AbZHWNad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pIoTpHoAXC7IrtgDdwrZZFWI6QvZuO27gGxMmUCli2UIGEjtPytyJNWolLD+rN6oee
         40zfTEVANiKL1W5snm8hBSmh1H15D5T5nETGGIr6CI0bKeWVIX6Eow1X32SzC4C88DR8
         tTlp1fwt96+UunqzvverDv6XhqhW/c8meBJ0Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:31:03 +0200
Message-Id: <20090823133103.17784.88567.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 21/33] Staging: rt28x0: MlmeCheckPsmChange() fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: MlmeCheckPsmChange() fix

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -2766,7 +2766,6 @@ VOID MlmeCheckPsmChange(
 		(pAd->Mlme.CntlMachine.CurrState == CNTL_IDLE))
 #endif
 	{
-#ifdef RT30xx
 		// add by johnli, use Rx OK data count per second to calculate throughput
 		// If Ttraffic is too high ( > 400 Rx per second), don't go to sleep mode. If tx rate is low, use low criteria
 		// Mode=CCK/MCS=3 => 11 Mbps, Mode=OFDM/MCS=3 => 18 Mbps
@@ -2774,7 +2773,6 @@ VOID MlmeCheckPsmChange(
 				(pAd->RalinkCounters.OneSecRxOkDataCnt < (ULONG)100)) ||
 			((pAd->StaCfg.HTPhyMode.field.MCS > 3) &&
 			(pAd->RalinkCounters.OneSecRxOkDataCnt < (ULONG)400)))
-#endif
 		{
 				// Get this time
 			NdisGetSystemUpTime(&pAd->Mlme.LastSendNULLpsmTime);
