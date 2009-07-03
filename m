Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbZGCOC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbZGCOC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbZGCOAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:00:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62728 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbZGCOAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=aPBxfTCoC/8cmcrYBEgi20ItoZzWlAbrjMN7YRuvSKIQAu1Ag+UhiMQy3n/Y9/Xu6F
         TtQjHXCeP0BRyACqx/mdrwfsK6XFWGbwuHYeoNTfrtfjs1LTS21pfN8i/8stwF2MnRlu
         O+vM6p4mk/R3HXQhhJpk/u/r2Vc7ZPc4lRcT4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:07:07 +0200
Message-Id: <20090703140707.7303.54946.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/22] Staging: rtl8192su: remove DISABLE_BB_RF ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove DISABLE_BB_RF ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile     |    1 -
 drivers/staging/rtl8192su/r8192S_phy.c |   12 ------------
 2 files changed, 13 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -12,7 +12,6 @@ EXTRA_CFLAGS += -DRTL8190_Download_Firmw
 EXTRA_CFLAGS += -DRTL8192S_PREPARE_FOR_NORMAL_RELEASE
 EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
-EXTRA_CFLAGS += -DDISABLE_BB_RF=0
 EXTRA_CFLAGS += -DRTL8192SU_USE_PARAM_TXPWR=0
 EXTRA_CFLAGS += -DRTL8192SU_FPGA_UNSPECIFIED_NETWORK=0
 #EXTRA_CFLAGS += -DRTL8192SU_FPGA_2MAC_VERIFICATION #=0
Index: b/drivers/staging/rtl8192su/r8192S_phy.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192S_phy.c
+++ b/drivers/staging/rtl8192su/r8192S_phy.c
@@ -418,9 +418,6 @@ u32 rtl8192_QueryBBReg(struct net_device
 
   	u32	ReturnValue = 0, OriginalValue, BitShift;
 
-#if (DISABLE_BB_RF == 1)
-	return 0;
-#endif
 
 	RT_TRACE(COMP_RF, "--->PHY_QueryBBReg(): RegAddr(%#x), BitMask(%#x)\n", RegAddr, BitMask);
 
@@ -481,9 +478,6 @@ void rtl8192_setBBreg(struct net_device*
 {
 	u32	OriginalValue, BitShift, NewValue;
 
-#if (DISABLE_BB_RF == 1)
-	return;
-#endif
 
 	RT_TRACE(COMP_RF, "--->PHY_SetBBReg(): RegAddr(%#x), BitMask(%#x), Data(%#x)\n", RegAddr, BitMask, Data);
 
@@ -557,9 +551,6 @@ u32 rtl8192_phy_QueryRFReg(struct net_de
 	u32 Original_Value, Readback_Value, BitShift;//, flags;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
-#if (DISABLE_BB_RF == 1)
-	return 0;
-#endif
 
 	RT_TRACE(COMP_RF, "--->PHY_QueryRFReg(): RegAddr(%#x), eRFPath(%#x), BitMask(%#x)\n", RegAddr, eRFPath,BitMask);
 
@@ -636,9 +627,6 @@ void rtl8192_phy_SetRFReg(struct net_dev
 
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u32 Original_Value, BitShift, New_Value;//, flags;
-#if (DISABLE_BB_RF == 1)
-	return;
-#endif
 
 	RT_TRACE(COMP_RF, "--->PHY_SetRFReg(): RegAddr(%#x), BitMask(%#x), Data(%#x), eRFPath(%#x)\n",
 		RegAddr, BitMask, Data, eRFPath);
