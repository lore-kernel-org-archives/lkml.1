Return-Path: <linux-kernel-owner+w=401wt.eu-S966553AbXJSJGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966553AbXJSJGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933225AbXJSJGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:06:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55293 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbXJSJGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:06:15 -0400
Date: Fri, 19 Oct 2007 12:06:13 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: LKML <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Fix if (...) \n #if... cases missing semicolons when false
Message-ID: <Pine.LNX.4.64.0710191204410.11079@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696243703-1454705065-1192784773=:11079"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-1454705065-1192784773=:11079
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


A good candidate to checkpatch.pl's check list, btw.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/char/watchdog/wdt.c     |    3 ++-
 drivers/char/watchdog/wdt_pci.c |    3 ++-
 drivers/scsi/osst.c             |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/char/watchdog/wdt.c b/drivers/char/watchdog/wdt.c
index 0a3de6a..53d0bb4 100644
--- a/drivers/char/watchdog/wdt.c
+++ b/drivers/char/watchdog/wdt.c
@@ -253,7 +253,7 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 			printk(KERN_CRIT "Possible fan fault.\n");
 	}
 #endif /* CONFIG_WDT_501 */
-	if (!(status & WDC_SR_WCCR))
+	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
 		printk(KERN_CRIT "Would Reboot.\n");
@@ -264,6 +264,7 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 #else
 		printk(KERN_CRIT "Reset in 5ms.\n");
 #endif
+	}
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/char/watchdog/wdt_pci.c b/drivers/char/watchdog/wdt_pci.c
index 6baf4ae..6bfe0e2 100644
--- a/drivers/char/watchdog/wdt_pci.c
+++ b/drivers/char/watchdog/wdt_pci.c
@@ -298,7 +298,7 @@ static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
 			printk(KERN_CRIT PFX "Possible fan fault.\n");
 	}
 #endif /* CONFIG_WDT_501_PCI */
-	if (!(status&WDC_SR_WCCR))
+	if (!(status&WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
 		printk(KERN_CRIT PFX "Would Reboot.\n");
@@ -309,6 +309,7 @@ static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
 #else
 		printk(KERN_CRIT PFX "Reset in 5ms.\n");
 #endif
+	}
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 331b789..12710cf 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -593,10 +593,11 @@ static int osst_verify_frame(struct osst_tape * STp, int frame_seq_number, int q
 	if (aux->frame_type != OS_FRAME_TYPE_DATA &&
 	    aux->frame_type != OS_FRAME_TYPE_EOD &&
 	    aux->frame_type != OS_FRAME_TYPE_MARKER) {
-		if (!quiet)
+		if (!quiet) {
 #if DEBUG
 			printk(OSST_DEB_MSG "%s:D: Skipping frame, frame type %x\n", name, aux->frame_type);
 #endif
+		}
 		goto err_out;
 	}
 	if (aux->frame_type == OS_FRAME_TYPE_EOD &&
@@ -606,11 +607,12 @@ static int osst_verify_frame(struct osst_tape * STp, int frame_seq_number, int q
 		goto err_out;
 	}
         if (frame_seq_number != -1 && ntohl(aux->frame_seq_num) != frame_seq_number) {
-		if (!quiet)
+		if (!quiet) {
 #if DEBUG
 			printk(OSST_DEB_MSG "%s:D: Skipping frame, sequence number %u (expected %d)\n", 
 					    name, ntohl(aux->frame_seq_num), frame_seq_number);
 #endif
+		}
 		goto err_out;
 	}
 	if (aux->frame_type == OS_FRAME_TYPE_MARKER) {
-- 
1.5.0.6

---696243703-1454705065-1192784773=:11079--
