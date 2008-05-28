Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYE1Vr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYE1Vr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYE1VpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:45:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:51381 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbYE1VpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=glTnr5O/T9pBZnVRBomuSSuEcRcCpQbSMnuwESIBmItT2b8bHUZdB7H1M+N3qmPq+C4/Lta8T+zGuCEpPWytgcIxRVIKsdiIWC9wm9UXuPYYF92ubFi0cd37Sqy2aXMoq9eMVsacsjEd/OG3nhzU1lLFVS+r8tplB2P7tvbqSSg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:42:37 +0200
Message-Id: <20080528214237.16327.7342.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/21] cmd64x: convert to use ide_timing_find_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig      |    1 +
 drivers/ide/pci/cmd64x.c |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -495,6 +495,7 @@ config BLK_DEV_ATIIXP
 
 config BLK_DEV_CMD64X
 	tristate "CMD64{3|6|8|9} chipset support"
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  Say Y here if you have an IDE controller which uses any of these
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -116,6 +116,7 @@ static void cmd64x_tune_pio(ide_drive_t 
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	struct pci_dev *dev	= to_pci_dev(hwif->dev);
+	struct ide_timing *t	= ide_timing_find_mode(XFER_PIO_0 + pio);
 	unsigned int cycle_time;
 	u8 setup_count, arttim = 0;
 
@@ -124,10 +125,9 @@ static void cmd64x_tune_pio(ide_drive_t 
 
 	cycle_time = ide_pio_cycle_time(drive, pio);
 
-	program_cycle_times(drive, cycle_time,
-			    ide_pio_timings[pio].active_time);
+	program_cycle_times(drive, cycle_time, t->active);
 
-	setup_count = quantize_timing(ide_pio_timings[pio].setup_time,
+	setup_count = quantize_timing(t->setup,
 			1000 / (ide_pci_clk ? ide_pci_clk : 33));
 
 	/*
