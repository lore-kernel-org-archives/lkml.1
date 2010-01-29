Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067Ab0A2QFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0A2QFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152Ab0A2QFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:05:13 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab0A2QFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:05:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vPH4g/p5PBfR2Usp7mwfGsd3+66gR+IUOehHgWZljnsHXTdYVdDls/nfZY1IpZxGeC
         XCtFF/kwBN8KiXJsBtUJhKjmZ6JDel9yehJ+yNytTeytzldjDx36fflrnfBz8I88A4hS
         SBdalq6NERu2pNWF3Wr0Vo1bk+TgisXmWQ/ro=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:04:59 +0100
Message-Id: <20100129160459.21495.85998.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 17/68] via82cxxx: use pata_via.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] via82cxxx: use pata_via.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/via82cxxx.c |   30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

Index: b/drivers/ide/via82cxxx.c
===================================================================
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -29,7 +29,6 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
-#include <linux/dmi.h>
 
 #ifdef CONFIG_PPC_CHRP
 #include <asm/processor.h>
@@ -351,34 +350,7 @@ static int init_chipset_via82cxxx(struct
 	return 0;
 }
 
-/*
- *	Cable special cases
- */
-
-static const struct dmi_system_id cable_dmi_table[] = {
-	{
-		.ident = "Acer Ferrari 3400",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Acer,Inc."),
-			DMI_MATCH(DMI_BOARD_NAME, "Ferrari 3400"),
-		},
-	},
-	{ }
-};
-
-static int via_cable_override(struct pci_dev *pdev)
-{
-	/* Systems by DMI */
-	if (dmi_check_system(cable_dmi_table))
-		return 1;
-
-	/* Arima W730-K8/Targa Visionary 811/... */
-	if (pdev->subsystem_vendor == 0x161F &&
-	    pdev->subsystem_device == 0x2032)
-		return 1;
-
-	return 0;
-}
+#include "../ata/pata_via.h"
 
 static u8 via82cxxx_cable_detect(ide_hwif_t *hwif)
 {
