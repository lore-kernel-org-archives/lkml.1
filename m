Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbZGCODf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbZGCODf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757673AbZGCOBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:01:07 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62728 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbZGCOBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:01:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BwCRsgOdjdN8lLeHvR261QECPhccNkM19n84Eb67VSb6SJtXp+XIUAJVXOK9hWqYuR
         oS6B9wRHXztUICeuCuI7QEO8bxvzeFdCH48JEHggwuUo6am71Yjljk7ge+7O7VVpDApe
         8nRCpF4OubUVm0lPZQBxdlFiuKv2MTVeqE72w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:07:40 +0200
Message-Id: <20090703140740.7303.30952.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/22] Staging: rtl8192su: remove RTL8192SU_USB_PHY_TEST ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove RTL8192SU_USB_PHY_TEST ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile      |    2 --
 drivers/staging/rtl8192su/r8192U_core.c |   17 -----------------
 2 files changed, 19 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -12,8 +12,6 @@ EXTRA_CFLAGS += -DRTL8190_Download_Firmw
 EXTRA_CFLAGS += -DRTL8192S_PREPARE_FOR_NORMAL_RELEASE
 EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
-EXTRA_CFLAGS += -DRTL8192SU_USB_PHY_TEST=0
-
 #EXTRA_CFLAGS += -DMUTIPLE_BULK_OUT
 
 r8192s_usb-objs :=		\
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -6683,23 +6683,6 @@ static void rtl8192SU_MacConfigAfterFwDo
 	tmpU1b = read_nic_byte_E(dev, 0x5C);
 	write_nic_byte_E(dev, 0x5C, tmpU1b|BIT7);
 
-	//
-	// Revise USB PHY to solve the issue of Rx payload error, Rivesed by Roger,  2008-04-10
-	// Suggest by SD1 Alex.
-	//
-	// <Roger_Notes> The following operation are ONLY for USB PHY test chip.
-	// 2008.10.07.
-	//
-#if RTL8192SU_USB_PHY_TEST
-	write_nic_byte(dev, 0x41,0xf4);
-	write_nic_byte(dev, 0x40,0x00);
-	write_nic_byte(dev, 0x42,0x00);
-	write_nic_byte(dev, 0x42,0x01);
-	write_nic_byte(dev, 0x40,0x0f);
-	write_nic_byte(dev, 0x42,0x00);
-	write_nic_byte(dev, 0x42,0x01);
-#endif
-
 #if 0 //LZM 090219
 	//
 	// Suggested by SD1 Alex, 2008-06-14.
