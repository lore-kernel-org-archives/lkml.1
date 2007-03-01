Return-Path: <linux-kernel-owner+w=401wt.eu-S965371AbXCAQqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965371AbXCAQqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965370AbXCAQqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:46:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34882 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965367AbXCAQqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:46:20 -0500
Date: Thu, 1 Mar 2007 17:50:28 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] pata_netcell: remove lots of crud by using the cable method
Message-ID: <20070301175028.6c603eab@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_netcell.c linux-2.6.21-rc2/drivers/ata/pata_netcell.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_netcell.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_netcell.c	2007-03-01 14:59:02.698430208 +0000
@@ -16,33 +16,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_netcell"
-#define DRV_VERSION	"0.1.6"
-
-/**
- *	netcell_probe_init	-	check for 40/80 pin
- *	@ap: Port
- *
- *	Cables are handled by the RAID controller. Report 80 pin.
- */
-
-static int netcell_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA80;
-	return ata_std_prereset(ap);
-}
-
-/**
- *	netcell_probe_reset - Probe specified port on PATA host controller
- *	@ap: Port to probe
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void netcell_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, netcell_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
+#define DRV_VERSION	"0.1.7"
 
 /* No PIO or DMA methods needed for this device */
 
@@ -79,8 +53,9 @@
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= netcell_error_handler,
+	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_80wire,
 
 	/* BMDMA handling is PCI ATA format, use helpers */
 	.bmdma_setup		= ata_bmdma_setup,
