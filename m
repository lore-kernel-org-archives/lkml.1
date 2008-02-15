Return-Path: <linux-kernel-owner+w=401wt.eu-S934331AbYBOAnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbYBOAnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934260AbYBOAmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:22 -0500
Received: from ns2.suse.de ([195.135.220.15]:54040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764558AbYBOAmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:20 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 03/12] IDE: remove ide=reverse IDE core
Date: Thu, 14 Feb 2008 16:40:01 -0800
Message-Id: <1203036010-27988-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080215003909.GA27981@kroah.com>
References: <20080215003909.GA27981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option is obsolete and can be removed safely.

It allows us to remove the pci_get_device_reverse() function from the
PCI core.


Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/ide-scan-pci.c |    9 ++-------
 drivers/ide/ide.c          |   12 ------------
 include/linux/ide.h        |    1 -
 3 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/ide/ide-scan-pci.c b/drivers/ide/ide-scan-pci.c
index 93d2e41..98888da 100644
--- a/drivers/ide/ide-scan-pci.c
+++ b/drivers/ide/ide-scan-pci.c
@@ -88,13 +88,8 @@ static int __init ide_scan_pcibus(void)
 	struct list_head *l, *n;
 
 	pre_init = 0;
-	if (!ide_scan_direction)
-		while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)))
-			ide_scan_pcidev(dev);
-	else
-		while ((dev = pci_get_device_reverse(PCI_ANY_ID, PCI_ANY_ID,
-						     dev)))
-			ide_scan_pcidev(dev);
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)))
+		ide_scan_pcidev(dev);
 
 	/*
 	 *	Hand the drivers over to the PCI layer now we
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 4a8952a..eed7ead 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -90,10 +90,6 @@ static int system_bus_speed;	/* holds what we think is VESA/PCI bus speed */
 DEFINE_MUTEX(ide_cfg_mtx);
  __cacheline_aligned_in_smp DEFINE_SPINLOCK(ide_lock);
 
-#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
-int ide_scan_direction; /* THIS was formerly 2.2.x pci=reverse */
-#endif
-
 int noautodma = 0;
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
@@ -1225,14 +1221,6 @@ static int __init ide_setup(char *s)
 		goto obsolete_option;
 	}
 
-#ifdef CONFIG_IDEPCI_PCIBUS_ORDER
-	if (!strcmp(s, "ide=reverse")) {
-		ide_scan_direction = 1;
-		printk(" : Enabled support for IDE inverse scan order.\n");
-		return 1;
-	}
-#endif
-
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	if (!strcmp(s, "ide=noacpi")) {
 		//printk(" : Disable IDE ACPI support.\n");
diff --git a/include/linux/ide.h b/include/linux/ide.h
index a3b69c1..415adbb 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -990,7 +990,6 @@ extern void do_ide_request(struct request_queue *);
 void ide_init_disk(struct gendisk *, ide_drive_t *);
 
 #ifdef CONFIG_IDEPCI_PCIBUS_ORDER
-extern int ide_scan_direction;
 extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *owner, const char *mod_name);
 #define ide_pci_register_driver(d) __ide_pci_register_driver(d, THIS_MODULE, KBUILD_MODNAME)
 #else
-- 
1.5.4

