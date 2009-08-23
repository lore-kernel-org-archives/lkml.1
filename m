Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbZHWNa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbZHWNa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933994AbZHWNaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:30:55 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934030AbZHWNaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YefP0/CQof7aTp1kbwwyWa84ycjrmrEZZd7RBM+oGmup0potCBh031rCXzMbXM26XC
         sLbCQnxUSA5vi64h8K2K9BsPb9fgBPQjQ0KVhda4PIA6qXVbOdLnVYWJD6s9Uh/5xUXt
         MuiNMY2siCh2PzEoIaBQFu3YU/J1R1fljIjAo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:31:22 +0200
Message-Id: <20090823133122.17784.53207.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 24/33] Staging: rt28x0: LinkUp() fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: LinkUp() fixes

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/sta/connect.c |    6 ------
 1 file changed, 6 deletions(-)

Index: b/drivers/staging/rt2860/sta/connect.c
===================================================================
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -1171,7 +1171,6 @@ VOID LinkUp(
 		OPSTATUS_SET_FLAG(pAd, fOP_STATUS_ADHOC_ON);
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_INFRA_ON);
 
-#ifdef RT30xx
 		if ((pAd->CommonCfg.HtCapability.HtCapInfo.ChannelWidth  == BW_40) &&
 			(pAd->CommonCfg.AddHTInfo.AddHtInfo.ExtChanOffset == EXTCHA_ABOVE))
 		{
@@ -1183,7 +1182,6 @@ VOID LinkUp(
 		{
 			pAd->CommonCfg.CentralChannel = pAd->CommonCfg.Channel - 2;
 		}
-#endif
 #ifdef RT2870
 		if (pAd->CommonCfg.PhyMode >= PHY_11ABGN_MIXED)
 			AdhocTurnOnQos(pAd);
@@ -1585,9 +1583,7 @@ VOID LinkUp(
 		pAd->MacTab.Size = 1;	// infra mode always set MACtab size =1.
 		pAd->MacTab.Content[BSSID_WCID].Sst = SST_ASSOC;
 		pAd->MacTab.Content[BSSID_WCID].AuthState = SST_ASSOC;
-#ifdef RT30xx
 		pAd->MacTab.Content[BSSID_WCID].AuthMode = pAd->StaCfg.AuthMode;
-#endif
 		pAd->MacTab.Content[BSSID_WCID].WepStatus = pAd->StaCfg.WepStatus;
         NdisReleaseSpinLock(&pAd->MacTabLock);
 
@@ -1712,9 +1708,7 @@ VOID LinkUp(
 	//
 	// if 1. Legacy AP WMM on,  or 2. 11n AP, AMPDU disable.  Force turn off burst no matter what bEnableTxBurst is.
 	if (
-#ifdef RT30xx
 		!(pAd->CommonCfg.RxStream == 1 && pAd->CommonCfg.TxStream == 1) &&
-#endif
 		(((pAd->StaActive.SupportedPhyInfo.bHtEnable == FALSE) && OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_WMM_INUSED))
 		|| ((pAd->StaActive.SupportedPhyInfo.bHtEnable == TRUE) && (pAd->CommonCfg.BACapability.field.Policy == BA_NOTUSE))))
 	{
