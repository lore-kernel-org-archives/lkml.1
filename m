Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbZGCOCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbZGCOCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbZGCOAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:00:46 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62728 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbZGCOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=OvDML5Z4mcT9m2DQi8ro8i/jX/GBPUZi1OWUd2wkSeStreH7TmCYPEqwctqn9JWgJZ
         huo9QnPSjwS92qiYxAXZyR/BhboR6Qt2ZTIfrpPNgWrmy0CNPYS6KwADBMNxsM7pvAvm
         B7j1V6OEJNQEHIavB1CiL4Ymr6akTTrdOdfVw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:07:20 +0200
Message-Id: <20090703140720.7303.70842.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/22] Staging: rtl8192su: remove RTL8192SU_FPGA_UNSPECIFIED_NETWORK ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove RTL8192SU_FPGA_UNSPECIFIED_NETWORK ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile      |    1 -
 drivers/staging/rtl8192su/r8192U_core.c |   22 ----------------------
 2 files changed, 23 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -12,7 +12,6 @@ EXTRA_CFLAGS += -DRTL8190_Download_Firmw
 EXTRA_CFLAGS += -DRTL8192S_PREPARE_FOR_NORMAL_RELEASE
 EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
-EXTRA_CFLAGS += -DRTL8192SU_FPGA_UNSPECIFIED_NETWORK=0
 #EXTRA_CFLAGS += -DRTL8192SU_FPGA_2MAC_VERIFICATION #=0
 EXTRA_CFLAGS += -DRTL8192SU_ASIC_VERIFICATION
 EXTRA_CFLAGS += -DRTL8192SU_USB_PHY_TEST=0
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -2957,19 +2957,6 @@ short rtl8192SU_tx(struct net_device *de
 	memset(tx_desc, 0, sizeof(tx_desc_819x_usb));
 
 
-#if RTL8192SU_FPGA_UNSPECIFIED_NETWORK
-		if(IsQoSDataFrame(skb->data))
-		{
-			tcb_desc->bAMPDUEnable = TRUE;
-			tx_desc->NonQos = 0;
-		}
-		else
-			tcb_desc->bAMPDUEnable = FALSE;
-
-		tcb_desc->bPacketBW = TRUE;
-		priv->CurrentChannelBW = HT_CHANNEL_WIDTH_20_40;
-#endif
-
 #if (defined (RTL8192SU_FPGA_2MAC_VERIFICATION)||defined (RTL8192SU_ASIC_VERIFICATION))
 		tx_desc->NonQos = (IsQoSDataFrame(skb->data)==TRUE)? 0:1;
 #endif
@@ -7280,15 +7267,6 @@ start:
 
 // <Roger_Notes> We return status here for temporal FPGA verification. 2008.05.12.
 //
-#if RTL8192SU_FPGA_UNSPECIFIED_NETWORK
-	//
-	// To send specific number of packets to verify MAC Lookback mode.
-	//
-	//SendRandomTxPkt(Adapter, 0); // Burst mode for verification.
-	//rtStatus = RT_STATUS_FAILURE;
-	rtStatus = true;
-        goto end;
-#endif
 
 // The following IO was for FPGA verification purpose. Added by Roger, 2008.09.11.
 #if 0
