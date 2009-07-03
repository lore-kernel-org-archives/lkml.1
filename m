Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZGCODD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZGCODD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZGCOAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:00:53 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62728 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbZGCOAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HW7tCZriPxhTHTbUOFfx09rq9lPph3atPjUPKR2k2CHBa5q27nP/21rMVI3lf1TRaL
         +VhHZtsSp/KHME/wfM6QtcMxNTg1h+bD4z4098CUh/S+M7OePvePe85R9x76AubMqCJH
         X2FzgiB1Q2+bnujAamdkwKqhtksHyt/75l4qs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:07:27 +0200
Message-Id: <20090703140727.7303.64631.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/22] Staging: rtl8192su: remove RTL8192SU_FPGA_2MAC_VERIFICATION ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove RTL8192SU_FPGA_2MAC_VERIFICATION ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile          |    1 -
 drivers/staging/rtl8192su/r8192S_firmware.c |    2 +-
 drivers/staging/rtl8192su/r8192U_core.c     |   12 ++++++------
 3 files changed, 7 insertions(+), 8 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -12,7 +12,6 @@ EXTRA_CFLAGS += -DRTL8190_Download_Firmw
 EXTRA_CFLAGS += -DRTL8192S_PREPARE_FOR_NORMAL_RELEASE
 EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
-#EXTRA_CFLAGS += -DRTL8192SU_FPGA_2MAC_VERIFICATION #=0
 EXTRA_CFLAGS += -DRTL8192SU_ASIC_VERIFICATION
 EXTRA_CFLAGS += -DRTL8192SU_USB_PHY_TEST=0
 
Index: b/drivers/staging/rtl8192su/r8192S_firmware.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192S_firmware.c
+++ b/drivers/staging/rtl8192su/r8192S_firmware.c
@@ -320,7 +320,7 @@ FirmwareCheckReady(struct net_device *de
 
 		RT_TRACE(COMP_FIRMWARE, "FirmwareCheckReady(): Current RCR settings(%#x)\n", tmpU4b);
 
-#if (defined (RTL8192SU_FPGA_2MAC_VERIFICATION) ||defined (RTL8192SU_ASIC_VERIFICATION))
+#if defined (RTL8192SU_ASIC_VERIFICATION)
 #ifdef NOT_YET   //YJ,TMP
 		priv->TransmitConfig = read_nic_dword(dev, TCR);
 		RT_TRACE(COMP_FIRMWARE, "FirmwareCheckReady(): Current TCR settings(%x)\n", priv->TransmitConfig);
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -2957,7 +2957,7 @@ short rtl8192SU_tx(struct net_device *de
 	memset(tx_desc, 0, sizeof(tx_desc_819x_usb));
 
 
-#if (defined (RTL8192SU_FPGA_2MAC_VERIFICATION)||defined (RTL8192SU_ASIC_VERIFICATION))
+#if defined (RTL8192SU_ASIC_VERIFICATION)
 		tx_desc->NonQos = (IsQoSDataFrame(skb->data)==TRUE)? 0:1;
 #endif
 
@@ -4029,7 +4029,7 @@ bool GetNmodeSupportBySecCfg8192(struct 
         int wpa_ie_len= ieee->wpa_ie_len;
         struct ieee80211_crypt_data* crypt;
         int encrypt;
-#if (defined (RTL8192SU_FPGA_2MAC_VERIFICATION)||defined (RTL8192SU_ASIC_VERIFICATION))
+#if defined (RTL8192SU_ASIC_VERIFICATION)
 	return TRUE;
 #endif
 
@@ -4883,7 +4883,7 @@ static void rtl8192SU_ReadAdapterInfo819
 	RT_TRACE(COMP_EPROM, "MAC addr:"MAC_FMT"\n", MAC_ARG(dev->dev_addr));
 
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE; //default 1T2R
-#if (defined (RTL8192SU_FPGA_2MAC_VERIFICATION)||defined (RTL8192SU_ASIC_VERIFICATION))
+#if defined (RTL8192SU_ASIC_VERIFICATION)
 	priv->rf_chip = RF_6052;
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;
 	//priv->card_8192_version = VERSION_8192SU_A; //Over write for temporally experiment. 2008.10.16. By Roger.
@@ -5215,7 +5215,7 @@ rtl8192SU_ReadAdapterInfo8192SEFuse(stru
 	// 2007/11/15 MH For RTL8192USB we assign as 1T2R now.
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;	// default : 1T2R
 
-#if (defined (RTL8192SU_FPGA_2MAC_VERIFICATION)||defined (RTL8192SU_ASIC_VERIFICATION))
+#if defined (RTL8192SU_ASIC_VERIFICATION)
 	priv->rf_chip = RF_6052;
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;
 #else
@@ -5660,7 +5660,7 @@ rtl8192SU_ReadAdapterInfo8192SUsb(struct
 	//	priv->rf_type = RF_1T2R;
 	//}
 
-#if (defined (RTL8192SU_FPGA_2MAC_VERIFICATION)||defined (RTL8192SU_ASIC_VERIFICATION))
+#if defined (RTL8192SU_ASIC_VERIFICATION)
 	priv->rf_chip = RF_6052;
 #else
 	priv->rf_chip = RF_8256;
@@ -7778,7 +7778,7 @@ rtl819x_ifcheck_resetornot(struct net_de
 	RESET_TYPE	RxResetType = RESET_TYPE_NORESET;
 	RT_RF_POWER_STATE 	rfState;
 
-#if (defined (RTL8192SU_FPGA_2MAC_VERIFICATION)||defined (RTL8192SU_ASIC_VERIFICATION))
+#if defined (RTL8192SU_ASIC_VERIFICATION)
 	return RESET_TYPE_NORESET;
 #endif
 
