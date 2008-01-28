Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYA1WKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYA1WKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604AbYA1WJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:09:25 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52175 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202AbYA1WJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:09:24 -0500
Date: Tue, 29 Jan 2008 00:09:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] small ide-scan-pci.c cleanup
Message-ID: <20080128220950.GJ8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- ide_scan_pcibus() can become static
- instead of ide_scan_pci() we can use ide_scan_pcibus() directly
  in module_init()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ide/ide-scan-pci.c |    9 ++-------
 include/linux/ide.h        |    1 -
 2 files changed, 2 insertions(+), 8 deletions(-)

03f221931265eda3ae7dfad9eaa8191e171d2c0c 
diff --git a/drivers/ide/ide-scan-pci.c b/drivers/ide/ide-scan-pci.c
index 7ffa332..93d2e41 100644
--- a/drivers/ide/ide-scan-pci.c
+++ b/drivers/ide/ide-scan-pci.c
@@ -81,7 +81,7 @@ static int __init ide_scan_pcidev(struct pci_dev *dev)
  *	module ordering not traditionally ordered.
  */
 
-int __init ide_scan_pcibus(void)
+static int __init ide_scan_pcibus(void)
 {
 	struct pci_dev *dev = NULL;
 	struct pci_driver *d;
@@ -113,9 +113,4 @@ int __init ide_scan_pcibus(void)
 	return 0;
 }
 
-static int __init ide_scan_pci(void)
-{
-	return ide_scan_pcibus();
-}
-
-module_init(ide_scan_pci);
+module_init(ide_scan_pcibus);
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 5d3d88e..7072c53 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1015,7 +1015,6 @@ void ide_init_disk(struct gendisk *, ide_drive_t *);
 
 #ifdef CONFIG_IDEPCI_PCIBUS_ORDER
 extern int ide_scan_direction;
-int __init ide_scan_pcibus(void);
 extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *owner, const char *mod_name);
 #define ide_pci_register_driver(d) __ide_pci_register_driver(d, THIS_MODULE, KBUILD_MODNAME)
 #else

