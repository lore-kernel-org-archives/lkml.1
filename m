Return-Path: <linux-kernel-owner+w=401wt.eu-S1030260AbXBTQmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030260AbXBTQmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030256AbXBTQmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:42:25 -0500
Received: from [81.2.110.250] ([81.2.110.250]:46859 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030260AbXBTQmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:42:24 -0500
Date: Tue, 20 Feb 2007 17:45:55 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_ixp4xx: Fix up set_mode() function and display
 Configured for PIO info
Message-ID: <20070220174555.39d9cbec@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_ixp4xx_cf.c linux-2.6.20-mm2/drivers/ata/pata_ixp4xx_cf.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/pata_ixp4xx_cf.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/pata_ixp4xx_cf.c	2007-02-20 13:52:56.000000000 +0000
@@ -23,15 +23,16 @@
 #include <scsi/scsi_host.h>
 
 #define DRV_NAME	"pata_ixp4xx_cf"
-#define DRV_VERSION	"0.1.1ac1"
+#define DRV_VERSION	"0.1.1ac3"
 
-static int ixp4xx_set_mode(struct ata_port *ap, struct ata_device *adev)
+static int ixp4xx_set_mode(struct ata_port *ap, struct ata_device **error)
 {
 	int i;
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
-		if (ata_dev_enabled(dev)) {
+		if (ata_dev_ready(dev)) {
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO0\n");
 			dev->pio_mode = XFER_PIO_0;
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
