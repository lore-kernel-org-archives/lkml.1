Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbZGCODW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbZGCODW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZGCOA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:00:59 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62728 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555AbZGCOA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dy/eudKX/p6vtLNoIpU4wA+AhJCUolHi+7irLiOVE5W3gG11f+6vAIqXAfir/tSkpb
         LmHYsr1hVr4SIMVLFBxEE/otu27NPVpPejbdISvSxdKaNzdVS3cHlT+keVhpPvtv3x3L
         DXegn4dI55peuwrMA2M1Y0QJG2T8YJynZSeMM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:07:34 +0200
Message-Id: <20090703140734.7303.97550.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/22] Staging: rtl8192su: remove RTL8192SU_ASIC_VERIFICATION ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove RTL8192SU_ASIC_VERIFICATION ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile          |    1 -
 drivers/staging/rtl8192su/r8192S_firmware.c |    2 --
 drivers/staging/rtl8192su/r8192U_core.c     |   18 ------------------
 3 files changed, 21 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -12,7 +12,6 @@ EXTRA_CFLAGS += -DRTL8190_Download_Firmw
 EXTRA_CFLAGS += -DRTL8192S_PREPARE_FOR_NORMAL_RELEASE
 EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
-EXTRA_CFLAGS += -DRTL8192SU_ASIC_VERIFICATION
 EXTRA_CFLAGS += -DRTL8192SU_USB_PHY_TEST=0
 
 #EXTRA_CFLAGS += -DMUTIPLE_BULK_OUT
Index: b/drivers/staging/rtl8192su/r8192S_firmware.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192S_firmware.c
+++ b/drivers/staging/rtl8192su/r8192S_firmware.c
@@ -320,13 +320,11 @@ FirmwareCheckReady(struct net_device *de
 
 		RT_TRACE(COMP_FIRMWARE, "FirmwareCheckReady(): Current RCR settings(%#x)\n", tmpU4b);
 
-#if defined (RTL8192SU_ASIC_VERIFICATION)
 #ifdef NOT_YET   //YJ,TMP
 		priv->TransmitConfig = read_nic_dword(dev, TCR);
 		RT_TRACE(COMP_FIRMWARE, "FirmwareCheckReady(): Current TCR settings(%x)\n", priv->TransmitConfig);
 		pHalData->FwRsvdTxPageCfg = read_nic_byte(dev, FW_RSVD_PG_CRTL);
 #endif
-#endif
 
 		// Set to normal mode.
 		write_nic_byte(dev, LBKMD_SEL, LBK_NORMAL);
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -2957,9 +2957,7 @@ short rtl8192SU_tx(struct net_device *de
 	memset(tx_desc, 0, sizeof(tx_desc_819x_usb));
 
 
-#if defined (RTL8192SU_ASIC_VERIFICATION)
 		tx_desc->NonQos = (IsQoSDataFrame(skb->data)==TRUE)? 0:1;
-#endif
 
 	/* Fill Tx descriptor */
 	//memset(tx_fwinfo,0,sizeof(tx_fwinfo_819x_usb));
@@ -4029,9 +4027,7 @@ bool GetNmodeSupportBySecCfg8192(struct 
         int wpa_ie_len= ieee->wpa_ie_len;
         struct ieee80211_crypt_data* crypt;
         int encrypt;
-#if defined (RTL8192SU_ASIC_VERIFICATION)
 	return TRUE;
-#endif
 
         crypt = ieee->crypt[ieee->tx_keyidx];
 	//we use connecting AP's capability instead of only security config on our driver to distinguish whether it should use N mode or G mode
@@ -4883,13 +4879,9 @@ static void rtl8192SU_ReadAdapterInfo819
 	RT_TRACE(COMP_EPROM, "MAC addr:"MAC_FMT"\n", MAC_ARG(dev->dev_addr));
 
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE; //default 1T2R
-#if defined (RTL8192SU_ASIC_VERIFICATION)
 	priv->rf_chip = RF_6052;
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;
 	//priv->card_8192_version = VERSION_8192SU_A; //Over write for temporally experiment. 2008.10.16. By Roger.
-#else
-	priv->rf_chip = RF_8256;
-#endif
 
 	{
 #if 0
@@ -5215,12 +5207,8 @@ rtl8192SU_ReadAdapterInfo8192SEFuse(stru
 	// 2007/11/15 MH For RTL8192USB we assign as 1T2R now.
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;	// default : 1T2R
 
-#if defined (RTL8192SU_ASIC_VERIFICATION)
 	priv->rf_chip = RF_6052;
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;
-#else
-	priv->rf_chip = RF_8256;
-#endif
 
 	{
 		//
@@ -5660,11 +5648,7 @@ rtl8192SU_ReadAdapterInfo8192SUsb(struct
 	//	priv->rf_type = RF_1T2R;
 	//}
 
-#if defined (RTL8192SU_ASIC_VERIFICATION)
 	priv->rf_chip = RF_6052;
-#else
-	priv->rf_chip = RF_8256;
-#endif
 
 	priv->rf_chip = RF_6052;//lzm test
 	RT_TRACE(COMP_INIT, "BoardType = 0x%2x\n", priv->EEPROMBoardType);
@@ -7778,9 +7762,7 @@ rtl819x_ifcheck_resetornot(struct net_de
 	RESET_TYPE	RxResetType = RESET_TYPE_NORESET;
 	RT_RF_POWER_STATE 	rfState;
 
-#if defined (RTL8192SU_ASIC_VERIFICATION)
 	return RESET_TYPE_NORESET;
-#endif
 
 	rfState = priv->ieee80211->eRFPowerState;
 
