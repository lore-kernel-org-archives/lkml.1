Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZGCOCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZGCOCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbZGCOA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:00:26 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62728 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538AbZGCOAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:00:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rG/jY8J22m3pSzmsIYgFtaT7lV//i8X6+h1y+Plrp6zC43K6pM9Ih8DmCFhX72fcih
         3jgIFsEw8mbflxkjBhtdxXlVYyNeL2kUXMbAhfME7+r4SwyEHMclnhjFWT4Am8sVzchh
         KUMEG7QZsDVdnlCkPsdDf7M5TF9Y+z0AGnpwE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:07:00 +0200
Message-Id: <20090703140700.7303.66461.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/22] Staging: rtl8192su: remove RTL8192S_DISABLE_FW_DM ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove RTL8192S_DISABLE_FW_DM ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile                         |    1 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c |    4 ----
 drivers/staging/rtl8192su/r8192S_phy.c                     |    2 --
 drivers/staging/rtl8192su/r8192U_core.c                    |    3 ---
 4 files changed, 10 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -12,7 +12,6 @@ EXTRA_CFLAGS += -DRTL8190_Download_Firmw
 EXTRA_CFLAGS += -DRTL8192S_PREPARE_FOR_NORMAL_RELEASE
 EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
-EXTRA_CFLAGS += -DRTL8192S_DISABLE_FW_DM=0
 EXTRA_CFLAGS += -DDISABLE_BB_RF=0
 EXTRA_CFLAGS += -DRTL8192SU_USE_PARAM_TXPWR=0
 EXTRA_CFLAGS += -DRTL8192SU_FPGA_UNSPECIFIED_NETWORK=0
Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
@@ -330,13 +330,11 @@ void ieee80211_wx_sync_scan_wq(struct wo
 #ifndef RTL8192SE
 	ieee->InitialGainHandler(ieee->dev,IG_Backup);
 #endif
-#if(RTL8192S_DISABLE_FW_DM == 0)
 	if (ieee->SetFwCmdHandler)
 	{
 		ieee->SetFwCmdHandler(ieee->dev, FW_CMD_DIG_HALT);
 		ieee->SetFwCmdHandler(ieee->dev, FW_CMD_HIGH_PWR_DISABLE);
 	}
-#endif
 	if (ieee->pHTInfo->bCurrentHTSupport && ieee->pHTInfo->bEnableHT && ieee->pHTInfo->bCurBW40MHz) {
 		b40M = 1;
 		chan_offset = ieee->pHTInfo->CurSTAExtChnlOffset;
@@ -361,13 +359,11 @@ void ieee80211_wx_sync_scan_wq(struct wo
 #ifndef RTL8192SE
 	ieee->InitialGainHandler(ieee->dev,IG_Restore);
 #endif
-#if(RTL8192S_DISABLE_FW_DM == 0)
 	if (ieee->SetFwCmdHandler)
 	{
 		ieee->SetFwCmdHandler(ieee->dev, FW_CMD_DIG_RESUME);
 		ieee->SetFwCmdHandler(ieee->dev, FW_CMD_HIGH_PWR_ENABLE);
 	}
-#endif
 	ieee->state = IEEE80211_LINKED;
 	ieee->link_change(ieee->dev);
 	// To prevent the immediately calling watch_dog after scan.
Index: b/drivers/staging/rtl8192su/r8192S_phy.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192S_phy.c
+++ b/drivers/staging/rtl8192su/r8192S_phy.c
@@ -3074,7 +3074,6 @@ PHY_ScanOperationBackup8192S(
 
 
 
-#if(RTL8192S_DISABLE_FW_DM == 0)
 
 	if(!Adapter->bDriverStopped)
 	{
@@ -3103,7 +3102,6 @@ PHY_ScanOperationBackup8192S(
 				break;
 		}
 	}
-#endif
 }
 #endif
 
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -7014,9 +7014,6 @@ start:
 	//
 	rtl8192SU_MacConfigAfterFwDownload(dev);
 
-#if (RTL8192S_DISABLE_FW_DM == 1)
-	write_nic_dword(dev, WFM5, FW_DM_DISABLE);
-#endif
 	//priv->bLbusEnable = TRUE;
 	//if(priv->RegRfOff == TRUE)
 	//	priv->eRFPowerState = eRfOff;
