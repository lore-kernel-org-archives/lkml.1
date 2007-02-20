Return-Path: <linux-kernel-owner+w=401wt.eu-S1030199AbXBTQcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199AbXBTQcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030232AbXBTQcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:32:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34172 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030199AbXBTQcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:32:11 -0500
Date: Tue, 20 Feb 2007 17:35:43 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] pata: Display Configuring .. lines for devices with private
 set_mode methods
Message-ID: <20070220173543.096963d5@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We can't specify which mode in the cases below but we can at least say
PIO and look consistent with the default.

Signed-off-by: Alan Cox <alan@redhat.com>


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_platform.c linux-2.6.20-mm2/drivers/ata/pata_platform.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/pata_platform.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/pata_platform.c	2007-02-20 13:55:21.000000000 +0000
@@ -42,6 +42,7 @@
 			dev->pio_mode = dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
 			dev->flags |= ATA_DFLAG_PIO;
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 		}
 	}
 	return 0;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_rz1000.c linux-2.6.20-mm2/drivers/ata/pata_rz1000.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/pata_rz1000.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/pata_rz1000.c	2007-02-20 13:55:54.000000000 +0000
@@ -71,6 +71,7 @@
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
 			dev->flags |= ATA_DFLAG_PIO;
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
 		}
 	}
 	return 0;

