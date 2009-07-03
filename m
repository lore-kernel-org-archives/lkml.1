Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbZGCOEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbZGCOEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757819AbZGCOB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:01:27 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:59900 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884AbZGCOB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vy1u5Zmb9MatNoqRaCnX87m2VUlfLv0YnOC36NGD+b5lZzDYqEI47nuCDPt+DbwZav
         qxL++3B/CmtP+wukKxEDkuEIUWau7IBlg90rs/yecozs8Ma8DDVw9zJ6PC16bU+xc2H9
         WkCkaXcgEn480sjdTNPg7/V1ZB3IEil9KgWgo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:08:02 +0200
Message-Id: <20090703140802.7303.84189.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/22] Staging: rtl8192su: remove RTL8192SU_DISABLE_IQK ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove RTL8192SU_DISABLE_IQK ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile      |    1 -
 drivers/staging/rtl8192su/r8192U_core.c |   11 -----------
 2 files changed, 12 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -8,7 +8,6 @@ EXTRA_CFLAGS += -DJACKSON_NEW_RX
 EXTRA_CFLAGS += -DTHOMAS_BEACON
 
 EXTRA_CFLAGS += -DRTL8192SU
-EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
 #EXTRA_CFLAGS += -DMUTIPLE_BULK_OUT
 
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -7033,17 +7033,6 @@ start:
 		//PHY_SetBBReg(Adapter, rOFDM0_TRxPathEnable, bMaskByte0, 0x11);
 	}
 
-#if (RTL8192SU_DISABLE_IQK==0)
-		// For 1T2R IQK only currently.
-		if (priv->card_8192_version == VERSION_8192S_BCUT)
-		{
-			PHY_IQCalibrateBcut(dev);
-		}
-		else if (priv->card_8192_version == VERSION_8192S_ACUT)
-		{
-			PHY_IQCalibrate(dev);
-		}
-#endif
 
 	//LZM 090219
 	// Set CCK and OFDM Block "ON"
