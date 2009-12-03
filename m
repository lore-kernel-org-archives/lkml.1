Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZLCTxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZLCTxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZLCTxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:53:05 -0500
Received: from mail-ew0-f210.google.com ([209.85.219.210]:57923 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbZLCTxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:53:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lnG8S39jqRQmwo1ek2RcYJIk//U2oAoto/Zgeva9GwJZEiC9/88dmcjhMfsHOaAmQ4
         avj3TYcVrVjH54GNOHjUDXnV/LHUOSv4yv37d3YBbsNl7vY1/qYOaZRDiYzq2qXTctEm
         xzuJ8XQi7iAfNfAB6s8MZwucQG35GfzQ0g7dc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 03 Dec 2009 20:52:19 +0100
Message-Id: <20091203195219.9093.45804.sendpatchset@localhost>
In-Reply-To: <20091203195145.9093.88261.sendpatchset@localhost>
References: <20091203195145.9093.88261.sendpatchset@localhost>
Subject: [PATCH 4/6] pdc202xx_old: remove no longer needed debugging code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pdc202xx_old: remove no longer needed debugging code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pdc202xx_old.c |   15 ---------------
 1 file changed, 15 deletions(-)

Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -21,8 +21,6 @@
 
 #define DRV_NAME "pdc202xx_old"
 
-#define PDC202XX_DEBUG_DRIVE_INFO	0
-
 static void pdc_old_disable_66MHz_clock(ide_hwif_t *);
 
 static void pdc202xx_set_mode(ide_drive_t *drive, const u8 speed)
@@ -34,11 +32,6 @@ static void pdc202xx_set_mode(ide_drive_
 	u8			AP = 0, BP = 0, CP = 0;
 	u8			TA = 0, TB = 0, TC = 0;
 
-#if PDC202XX_DEBUG_DRIVE_INFO
-	u32			drive_conf = 0;
-	pci_read_config_dword(dev, drive_pci, &drive_conf);
-#endif
-
 	/*
 	 * TODO: do this once per channel
 	 */
@@ -89,14 +82,6 @@ static void pdc202xx_set_mode(ide_drive_
 		pci_write_config_byte(dev, drive_pci + 1, BP | TB);
 		pci_write_config_byte(dev, drive_pci + 2, CP | TC);
 	}
-
-#if PDC202XX_DEBUG_DRIVE_INFO
-	printk(KERN_DEBUG "%s: %s drive%d 0x%08x ",
-		drive->name, ide_xfer_verbose(speed),
-		drive->dn, drive_conf);
-	pci_read_config_dword(dev, drive_pci, &drive_conf);
-	printk("0x%08x\n", drive_conf);
-#endif
 }
 
 static void pdc202xx_set_pio_mode(ide_drive_t *drive, const u8 pio)
