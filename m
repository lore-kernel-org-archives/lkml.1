Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZAJPaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZAJPaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZAJP3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:29:49 -0500
Received: from ns.konzeptpark.de ([195.226.66.162]:40755 "EHLO
	mail.konzeptpark.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZAJP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:29:48 -0500
X-Greylist: delayed 1397 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jan 2009 10:29:48 EST
Subject: [PATCH][ATA] Add ide-disk led-trigger to ATA subsystem
From: Carsten Schlote <c.schlote@konzeptpark.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: konzeptpark.de
Date: Sat, 10 Jan 2009 16:08:27 +0100
Message-Id: <1231600107.10065.4.camel@kplaws107lx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-AVK-Virus-Check: AVF 19.212;06.01.2009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Adds a call to ide-disk LED trigger to libata-sff.c
- Changed Kconfig to allow for ide-disk LED trigger when ATA drivers
  are enabled.

Open Issue:
- There might be more suitable place to call the trigger function.
  Only devices using libata-sff.c trigger LEDs right now.

Signed-off-by: Carsten Schlote <c.schlote@konzeptpark.de>
---
 drivers/ata/libata-sff.c |    3 +++
 drivers/leds/Kconfig     |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: .kernel/drivers/leds/Kconfig
===================================================================
--- .kernel.orig/drivers/leds/Kconfig	2009-01-07 22:13:40.000000000
+0100
+++ .kernel/drivers/leds/Kconfig	2009-01-07 22:14:46.000000000 +0100
@@ -185,7 +185,7 @@
 
 config LEDS_TRIGGER_IDE_DISK
 	bool "LED IDE Disk Trigger"
-	depends on LEDS_TRIGGERS && BLK_DEV_IDEDISK
+	depends on LEDS_TRIGGERS && BLK_DEV_IDEDISK || ATA
 	help
 	  This allows LEDs to be controlled by IDE disk activity.
 	  If unsure, say Y.
Index: .kernel/drivers/ata/libata-sff.c
===================================================================
--- .kernel.orig/drivers/ata/libata-sff.c	2009-01-07 22:14:09.000000000
+0100
+++ .kernel/drivers/ata/libata-sff.c	2009-01-07 22:14:46.000000000 +0100
@@ -36,6 +36,7 @@
 #include <linux/pci.h>
 #include <linux/libata.h>
 #include <linux/highmem.h>
+#include <linux/leds.h>
 
 #include "libata.h"
 
@@ -647,6 +648,8 @@
  */
 void ata_sff_exec_command(struct ata_port *ap, const struct
ata_taskfile *tf)
 {
+	ledtrig_ide_activity();
+
 	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
 
 	iowrite8(tf->command, ap->ioaddr.command_addr);

