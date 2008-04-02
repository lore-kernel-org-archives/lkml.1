Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbYDBQqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbYDBQqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYDBQqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:46:40 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:25989 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbYDBQqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:46:39 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org, bzolnier@gmail.com
Subject: [PATCH 2/2] ide: remove now unused ide_pci_create_host_proc()
Date: Wed, 2 Apr 2008 20:45:54 +0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804022045.54361.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It creates files in proc with obsoleted ->get_info interface.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
---

 drivers/ide/ide-proc.c |    8 --------
 include/linux/ide.h    |    4 ----
 2 files changed, 12 deletions(-)

--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -786,14 +786,6 @@ void ide_proc_register_port(ide_hwif_t *hwif)
 	}
 }
 
-#ifdef CONFIG_BLK_DEV_IDEPCI
-void ide_pci_create_host_proc(const char *name, get_info_t *get_info)
-{
-	create_proc_info_entry(name, 0, proc_ide_root, get_info);
-}
-EXPORT_SYMBOL_GPL(ide_pci_create_host_proc);
-#endif
-
 void ide_proc_unregister_port(ide_hwif_t *hwif)
 {
 	if (hwif->proc) {
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -695,10 +695,6 @@ void ide_add_generic_settings(ide_drive_t *);
 read_proc_t proc_ide_read_capacity;
 read_proc_t proc_ide_read_geometry;
 
-#ifdef CONFIG_BLK_DEV_IDEPCI
-void ide_pci_create_host_proc(const char *, get_info_t *);
-#endif
-
 /*
  * Standard exit stuff:
  */
