Return-Path: <linux-kernel-owner+w=401wt.eu-S965345AbXCAQgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345AbXCAQgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965347AbXCAQgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:36:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53465 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965341AbXCAQgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:36:49 -0500
Date: Thu, 1 Mar 2007 17:40:50 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] pata_ali: remove lots of code by using the cable_detect
 method
Message-ID: <20070301174050.071e6a06@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_ali.c linux-2.6.21-rc2/drivers/ata/pata_ali.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_ali.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_ali.c	2007-03-01 15:18:28.247239856 +0000
@@ -90,59 +90,6 @@
 }
 
 /**
- *	ali_early_error_handler	-	reset for eary chip
- *	@ap: ATA port
- *
- *	Handle the reset callback for the later chips with cable detect
- */
-
-static int ali_c2_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ali_c2_cable_detect(ap);
-	return ata_std_prereset(ap);
-}
-
-static void ali_c2_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, ali_c2_pre_reset,
-			       ata_std_softreset, NULL,
-			       ata_std_postreset);
-}
-
-/**
- *	ali_early_cable_detect	-	cable detection
- *	@ap: ATA port
- *
- *	Perform cable detection for older chipsets. This turns out to be
- *	rather easy to implement
- */
-
-static int ali_early_cable_detect(struct ata_port *ap)
-{
-	return ATA_CBL_PATA40;
-}
-
-/**
- *	ali_early_probe_init	-	reset for early chip
- *	@ap: ATA port
- *
- *	Handle the reset callback for the early (pre cable detect) chips.
- */
-
-static int ali_early_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ali_early_cable_detect(ap);
-	return ata_std_prereset(ap);
-}
-
-static void ali_early_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, ali_early_pre_reset,
-				     ata_std_softreset, NULL,
-				     ata_std_postreset);
-}
-
-/**
  *	ali_20_filter		-	filter for earlier ALI DMA
  *	@ap: ALi ATA port
  *	@adev: attached device
@@ -364,8 +311,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_early_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -400,8 +348,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_early_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -438,8 +387,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_c2_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ali_c2_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -475,8 +425,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= ali_c2_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ali_c2_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
