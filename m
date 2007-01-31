Return-Path: <linux-kernel-owner+w=401wt.eu-S1030331AbXAaRZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030331AbXAaRZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030377AbXAaRZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:25:37 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51420 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030331AbXAaRZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:25:36 -0500
Date: Wed, 31 Jan 2007 17:37:46 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: [PATCH]: SiS warning fixes
Message-ID: <20070131173746.4285ec68@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow the sis_info133 external definition ended up in libata.h and that
was included by both drivers. However libata.h contains libata-* specific
internals and clashing defines like DRV_NAME so this makes a mess. Move
the extern into the C file and remove the warnings

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/ata/libata.h linux-2.6.20-rc6-mm3/drivers/ata/libata.h
--- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/libata.h	2007-01-31 14:20:39.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/ata/libata.h	2007-01-31 15:04:24.000000000 +0000
@@ -151,7 +151,5 @@
 /* libata-sff.c */
 extern u8 ata_irq_on(struct ata_port *ap);
 
-/* pata_sis.c */
-extern struct ata_port_info sis_info133;
 
 #endif /* __LIBATA_H__ */
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/ata/pata_sis.c linux-2.6.20-rc6-mm3/drivers/ata/pata_sis.c
--- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/pata_sis.c	2007-01-31 14:20:39.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/ata/pata_sis.c	2007-01-31 15:05:42.000000000 +0000
@@ -32,7 +32,6 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <linux/ata.h>
-#include "libata.h"
 
 #define DRV_NAME	"pata_sis"
 #define DRV_VERSION	"0.4.5"
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/ata/sata_sis.c linux-2.6.20-rc6-mm3/drivers/ata/sata_sis.c
--- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/sata_sis.c	2007-01-31 14:20:39.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/ata/sata_sis.c	2007-01-31 15:04:23.000000000 +0000
@@ -40,11 +40,13 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include "libata.h"
 
 #define DRV_NAME	"sata_sis"
 #define DRV_VERSION	"0.7"
 
+/* pata_sis.c */
+extern struct ata_port_info sis_info133;
+
 enum {
 	sis_180			= 0,
 	SIS_SCR_PCI_BAR		= 5,
