Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXCAQtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXCAQtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965376AbXCAQtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:49:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55289 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965360AbXCAQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:49:48 -0500
Date: Thu, 1 Mar 2007 17:53:56 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] pata_rz1000: remove lots of crap by using cable method
Message-ID: <20070301175356.21dac1e1@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_rz1000.c linux-2.6.21-rc2/drivers/ata/pata_rz1000.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_rz1000.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_rz1000.c	2007-03-01 15:05:56.540516648 +0000
@@ -21,35 +21,10 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_rz1000"
-#define DRV_VERSION	"0.2.3"
+#define DRV_VERSION	"0.2.4"
 
 
 /**
- *	rz1000_prereset		-	probe begin
- *	@ap: ATA port
- *
- *	Set up cable type and use generics
- */
-
-static int rz1000_prereset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap);
-}
-
-/**
- *	rz1000_error_handler		-	probe reset
- *	@ap: ATA port
- *
- *	Perform the ATA standard reset sequence
- */
-
-static void rz1000_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, rz1000_prereset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
-/**
  *	rz1000_set_mode		-	mode setting function
  *	@ap: ATA interface
  *	@unused: returned device on set_mode failure
@@ -120,8 +95,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= rz1000_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.irq_handler	= ata_interrupt,
 	.irq_clear	= ata_bmdma_irq_clear,
