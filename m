Return-Path: <linux-kernel-owner+w=401wt.eu-S965351AbXCAQie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbXCAQie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965350AbXCAQie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:38:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53649 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965347AbXCAQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:38:33 -0500
Date: Thu, 1 Mar 2007 17:42:43 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] pata_cs55x0: clean up by using the cable_detect method
Message-ID: <20070301174243.7d506175@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_cs5520.c linux-2.6.21-rc2/drivers/ata/pata_cs5520.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_cs5520.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_cs5520.c	2007-03-01 15:32:48.638440512 +0000
@@ -139,18 +139,6 @@
 	cs5520_set_timings(ap, adev, adev->pio_mode);
 }
 
-
-static int cs5520_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap);
-}
-
-static void cs5520_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, cs5520_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
 static struct scsi_host_template cs5520_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -184,8 +172,9 @@
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= cs5520_error_handler,
+	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_40wire,
 
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_cs5530.c linux-2.6.21-rc2/drivers/ata/pata_cs5530.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_cs5530.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_cs5530.c	2007-03-01 15:33:32.008847208 +0000
@@ -160,18 +160,6 @@
 	return ata_qc_issue_prot(qc);
 }
 
-static int cs5530_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap);
-}
-
-static void cs5530_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, cs5530_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
-
 static struct scsi_host_template cs5530_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -211,8 +199,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cs5530_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= cs5530_qc_issue_prot,
