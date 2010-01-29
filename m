Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894Ab0A2QEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0A2QEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738Ab0A2QEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:04:43 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0A2QEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:04:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=I5b8wZYoK5r4pfHksUdDyJKGTPDXl5IDwpOVDAJPDFJdvWpPL/AD4HkPPdJD3qksHX
         A1s64vvioyfSPFplffQMZa8m1xZ6qHpzAwjPj+AFrhqCYSh5C3pFPGuFy/piYU4uZcOd
         BHhxko1lkNcScboRhyPt9qirs+yd3M2TXIHxU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:04:34 +0100
Message-Id: <20100129160434.21495.56474.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 13/68] alim15x3: use pata_ali.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: use pata_ali.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |   42 +-----------------------------------------
 1 file changed, 1 insertion(+), 41 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -33,7 +33,6 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 #include <linux/init.h>
-#include <linux/dmi.h>
 
 #include <asm/io.h>
 
@@ -308,46 +307,7 @@ out:
 	return 0;
 }
 
-/*
- *	Cable special cases
- */
-
-static const struct dmi_system_id cable_dmi_table[] = {
-	{
-		.ident = "HP Pavilion N5430",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
-		},
-	},
-	{
-		.ident = "Toshiba Satellite S1800-814",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "S1800-814"),
-		},
-	},
-	{ }
-};
-
-static int ali_cable_override(struct pci_dev *pdev)
-{
-	/* Fujitsu P2000 */
-	if (pdev->subsystem_vendor == 0x10CF &&
-	    pdev->subsystem_device == 0x10AF)
-		return 1;
-
-	/* Mitac 8317 (Winbook-A) and relatives */
-	if (pdev->subsystem_vendor == 0x1071 &&
-	    pdev->subsystem_device == 0x8317)
-		return 1;
-
-	/* Systems by DMI */
-	if (dmi_check_system(cable_dmi_table))
-		return 1;
-
-	return 0;
-}
+#include "../ata/pata_ali.h"
 
 /**
  *	ali_cable_detect	-	cable detection
