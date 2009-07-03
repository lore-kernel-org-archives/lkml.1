Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbZGCOED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbZGCOED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbZGCOBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:01:20 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62728 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692AbZGCOBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:01:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BMjAV1xRCwTB31QRiqJxkbkLLQdRRoWJbOIj+kaGgtZFwGVtyFP7ce9sDMeix7osXP
         OGAw26iJQQLBdvrjNAQdrVDCqDqBZ6ePi1pAazYKcjpHPQFRYAzCeL/yAcZU4qIvk0j+
         DLWlT1cSMfqsM0umVf9TTrKzgY74ikrcb6Ghw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:07:54 +0200
Message-Id: <20090703140754.7303.71193.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/22] Staging: rtl8192su: remove RTL8192S_PREPARE_FOR_NORMAL_RELEASE ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove RTL8192S_PREPARE_FOR_NORMAL_RELEASE ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile      |    1 -
 drivers/staging/rtl8192su/r8192U_core.c |    8 --------
 2 files changed, 9 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -8,7 +8,6 @@ EXTRA_CFLAGS += -DJACKSON_NEW_RX
 EXTRA_CFLAGS += -DTHOMAS_BEACON
 
 EXTRA_CFLAGS += -DRTL8192SU
-EXTRA_CFLAGS += -DRTL8192S_PREPARE_FOR_NORMAL_RELEASE
 EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
 #EXTRA_CFLAGS += -DMUTIPLE_BULK_OUT
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -6572,7 +6572,6 @@ static void rtl8192SU_SetHwRegAmpduMinSp
 	u8	MinSpacingToSet;
 	u8	SecMinSpace;
 
-#ifdef RTL8192S_PREPARE_FOR_NORMAL_RELEASE
 	MinSpacingToSet = MinSpaceCfg;
 	if(MinSpacingToSet <= 7)
 	{
@@ -6593,13 +6592,6 @@ static void rtl8192SU_SetHwRegAmpduMinSp
 		write_nic_byte(dev, AMPDU_MIN_SPACE, priv->MinSpaceCfg);
 	}
 
-#else
-	MinSpacingToSet = MinSpaceCfg;
-	MinSpacingToSet &= 0x07; // We only care about bit[2:0]
-	priv->MinSpaceCfg |= MinSpacingToSet;
-	RT_TRACE(COMP_SEC, "Set AMPDU_MIN_SPACE: %x\n", priv->MinSpaceCfg);
-	write_nic_byte(dev, AMPDU_MIN_SPACE, priv->MinSpaceCfg);//FIXLZM
-#endif
 }
 #endif
 
