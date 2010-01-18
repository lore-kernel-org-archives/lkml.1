Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195Ab0ARRTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0ARRTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050Ab0ARRTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:19:24 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab0ARRTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:19:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Pf5w13WI910AXasbaNj205pUQCTNMwiblARHFI6GCFz52RVBEvv2X7gIBlsodpS/Re
         GdM1lmU/zibYmatiJ40i+gvGK9e/qJyajT725iYiQXbVmdKYxiLwBhX22DNeyXCBAVpb
         Yo7q+lWFRBPe2km4x2SzFLDfA0G3Kld42FpqU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:17:59 +0100
Message-Id: <20100118171759.14623.53556.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 28/64] alim15x3: remove superfluous locking from ali_set_pio_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: remove superfluous locking from ali_set_pio_mode()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -73,7 +73,6 @@ static void ali_set_pio_mode(ide_drive_t
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	unsigned long flags;
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	unsigned long T =  1000000 / bus_speed; /* PCI clock based */
 	int port = hwif->channel ? 0x5c : 0x58;
@@ -86,8 +85,6 @@ static void ali_set_pio_mode(ide_drive_t
 	t.active = clamp_val(t.active, 1, 8) & 7;
 	t.recover = clamp_val(t.recover, 1, 16) & 15;
 
-	local_irq_save(flags);
-
 	/* 
 	 * PIO mode => ATA FIFO on, ATAPI FIFO off
 	 */
@@ -96,8 +93,6 @@ static void ali_set_pio_mode(ide_drive_t
 	pci_write_config_byte(dev, port, t.setup);
 	pci_write_config_byte(dev, port + unit + 2,
 			      (t.active << 4) | t.recover);
-
-	local_irq_restore(flags);
 }
 
 /**
