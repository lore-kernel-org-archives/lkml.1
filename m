Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbYCBWxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbYCBWxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760026AbYCBWx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:53:28 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:18011 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759769AbYCBWxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:53:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RrG0N8y1OrAXXThTq7Z5M4rG5UM8PBPj8bhv+3XoVHJoBybwBZqHfKlGzgCf10NnbarO9da43KzWvUeUzcMKamHAZPlLBEnVqr/uH0J5MBl7Okviprh+3CeHlbtZ4q0RSNftNGsRkqmjlyFruUIVLd1qbSD54IYUAY0QYhHRUE4=
Subject: [PATCH 2/3] saa7146: move EXPORT_SYMBOLS next to symbols they
	export
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 14:53:03 -0800
Message-Id: <1204498383.23005.15.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/common/saa7146_core.c |   30 ++++++++++++------------------
 drivers/media/common/saa7146_i2c.c  |    1 +
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 92d51d3..7c03819 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -21,11 +21,15 @@
 #include <media/saa7146.h>
 
 LIST_HEAD(saa7146_devices);
+EXPORT_SYMBOL_GPL(saa7146_devices);
+
 DEFINE_MUTEX(saa7146_devices_lock);
+EXPORT_SYMBOL_GPL(saa7146_devices_lock);
 
 static int saa7146_num;
 
 unsigned int saa7146_debug;
+EXPORT_SYMBOL_GPL(saa7146_debug);
 
 module_param(saa7146_debug, uint, 0644);
 MODULE_PARM_DESC(saa7146_debug, "debug level (default: 0)");
@@ -57,6 +61,7 @@ void saa7146_setgpio(struct saa7146_dev *dev, int port, u32 data)
 	value |= (data << (8*port));
 	saa7146_write(dev, GPIO_CTRL, value);
 }
+EXPORT_SYMBOL_GPL(saa7146_setgpio);
 
 /* This DEBI code is based on the saa7146 Stradis driver by Nathan Laredo */
 static inline int saa7146_wait_for_debi_done_sleep(struct saa7146_dev *dev,
@@ -141,6 +146,7 @@ int saa7146_wait_for_debi_done(struct saa7146_dev *dev, int nobusyloop)
 	else
 		return saa7146_wait_for_debi_done_busyloop(dev, 50000, 250000);
 }
+EXPORT_SYMBOL_GPL(saa7146_wait_for_debi_done);
 
 /****************************************************************************
  * general helper functions
@@ -213,6 +219,7 @@ err_free_mem:
 err_null:
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(saa7146_vmalloc_build_pgtable);
 
 void saa7146_vfree_destroy_pgtable(struct pci_dev *pci, void *mem, struct saa7146_pgtable *pt)
 {
@@ -222,6 +229,7 @@ void saa7146_vfree_destroy_pgtable(struct pci_dev *pci, void *mem, struct saa714
 	pt->slist = NULL;
 	vfree(mem);
 }
+EXPORT_SYMBOL_GPL(saa7146_vfree_destroy_pgtable);
 
 void saa7146_pgtable_free(struct pci_dev *pci, struct saa7146_pgtable *pt)
 {
@@ -230,6 +238,7 @@ void saa7146_pgtable_free(struct pci_dev *pci, struct saa7146_pgtable *pt)
 	pci_free_consistent(pci, pt->size, pt->cpu, pt->dma);
 	pt->cpu = NULL;
 }
+EXPORT_SYMBOL_GPL(saa7146_pgtable_free);
 
 int saa7146_pgtable_alloc(struct pci_dev *pci, struct saa7146_pgtable *pt)
 {
@@ -246,6 +255,7 @@ int saa7146_pgtable_alloc(struct pci_dev *pci, struct saa7146_pgtable *pt)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7146_pgtable_alloc);
 
 int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt,
 	struct scatterlist *list, int sglen  )
@@ -288,6 +298,7 @@ int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt
 */
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7146_pgtable_build_single);
 
 /********************************************************************************/
 /* interrupt handler */
@@ -567,6 +578,7 @@ int saa7146_register_extension(struct saa7146_extension* ext)
 	printk("saa7146: register extension '%s'.\n",ext->name);
 	return pci_register_driver(&ext->driver);
 }
+EXPORT_SYMBOL_GPL(saa7146_register_extension);
 
 int saa7146_unregister_extension(struct saa7146_extension* ext)
 {
@@ -575,26 +587,8 @@ int saa7146_unregister_extension(struct saa7146_extension* ext)
 	pci_unregister_driver(&ext->driver);
 	return 0;
 }
-
-EXPORT_SYMBOL_GPL(saa7146_register_extension);
 EXPORT_SYMBOL_GPL(saa7146_unregister_extension);
 
-/* misc functions used by extension modules */
-EXPORT_SYMBOL_GPL(saa7146_pgtable_alloc);
-EXPORT_SYMBOL_GPL(saa7146_pgtable_free);
-EXPORT_SYMBOL_GPL(saa7146_pgtable_build_single);
-EXPORT_SYMBOL_GPL(saa7146_vmalloc_build_pgtable);
-EXPORT_SYMBOL_GPL(saa7146_vfree_destroy_pgtable);
-EXPORT_SYMBOL_GPL(saa7146_wait_for_debi_done);
-
-EXPORT_SYMBOL_GPL(saa7146_setgpio);
-
-EXPORT_SYMBOL_GPL(saa7146_i2c_adapter_prepare);
-
-EXPORT_SYMBOL_GPL(saa7146_debug);
-EXPORT_SYMBOL_GPL(saa7146_devices);
-EXPORT_SYMBOL_GPL(saa7146_devices_lock);
-
 MODULE_AUTHOR("Michael Hunold <michael@mihu.de>");
 MODULE_DESCRIPTION("driver for generic saa7146-based hardware");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/common/saa7146_i2c.c b/drivers/media/common/saa7146_i2c.c
index 7e7689a..990e023 100644
--- a/drivers/media/common/saa7146_i2c.c
+++ b/drivers/media/common/saa7146_i2c.c
@@ -430,3 +430,4 @@ int saa7146_i2c_adapter_prepare(struct saa7146_dev *dev, struct i2c_adapter *i2c
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7146_i2c_adapter_prepare);
-- 
1.5.4.3.409.g8811


