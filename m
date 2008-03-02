Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbYCBWxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbYCBWxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbYCBWx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:53:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:40221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960AbYCBWxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:53:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k2Cc/j1ovS2nqBiUFHDgIz/+NfF98/HuqKc2SVZo2c7k612Dz6ZtB3QPbCeN2eEv5i7dHZXSkzBOTHOfdOOiU+w9de0nDQISUWWH/vDX531UWX8QRn5UmwCaCRXH6bBMO5dpAu86DPKvU7RRAZN4rmgOMxfvqQACFVgNqqoS864=
Subject: [PATCH 3/3] saa7146: checkpatch/kernel style fixes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 14:53:19 -0800
Message-Id: <1204498399.23005.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

space after comma
change (NULL == foo) to !foo
unnecessary braces on single statement blocks
Fix some exceptionally long lines

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/common/saa7146_core.c |  171 +++++++++++++++++------------------
 1 files changed, 84 insertions(+), 87 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 7c03819..7d44bb3 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -1,22 +1,22 @@
 /*
-    saa7146.o - driver for generic saa7146-based hardware
-
-    Copyright (C) 1998-2003 Michael Hunold <michael@mihu.de>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
+ * saa7146.o - driver for generic saa7146-based hardware
+ *
+ * Copyright (C) 1998-2003 Michael Hunold <michael@mihu.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 
 #include <media/saa7146.h>
 
@@ -34,21 +34,9 @@ EXPORT_SYMBOL_GPL(saa7146_debug);
 module_param(saa7146_debug, uint, 0644);
 MODULE_PARM_DESC(saa7146_debug, "debug level (default: 0)");
 
-#if 0
-static void dump_registers(struct saa7146_dev* dev)
-{
-	int i = 0;
-
-	INFO((" @ %li jiffies:\n",jiffies));
-	for(i = 0; i <= 0x148; i+=4) {
-		printk("0x%03x: 0x%08x\n",i,saa7146_read(dev,i));
-	}
-}
-#endif
-
-/****************************************************************************
+/*
  * gpio and debi helper functions
- ****************************************************************************/
+ */
 
 void saa7146_setgpio(struct saa7146_dev *dev, int port, u32 data)
 {
@@ -63,7 +51,9 @@ void saa7146_setgpio(struct saa7146_dev *dev, int port, u32 data)
 }
 EXPORT_SYMBOL_GPL(saa7146_setgpio);
 
-/* This DEBI code is based on the saa7146 Stradis driver by Nathan Laredo */
+/*
+ * This DEBI code is based on the saa7146 Stradis driver by Nathan Laredo
+ */
 static inline int saa7146_wait_for_debi_done_sleep(struct saa7146_dev *dev,
 				unsigned long us1, unsigned long us2)
 {
@@ -162,12 +152,12 @@ static struct scatterlist* vmalloc_to_sg(unsigned char *virt, int nr_pages)
 	int i;
 
 	sglist = kcalloc(nr_pages, sizeof(struct scatterlist), GFP_KERNEL);
-	if (NULL == sglist)
+	if (!sglist)
 		return NULL;
 	sg_init_table(sglist, nr_pages);
 	for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
 		pg = vmalloc_to_page(virt);
-		if (NULL == pg)
+		if (!pg)
 			goto err;
 		BUG_ON(PageHighMem(pg));
 		sg_set_page(&sglist[i], pg, PAGE_SIZE, 0);
@@ -184,14 +174,15 @@ static struct scatterlist* vmalloc_to_sg(unsigned char *virt, int nr_pages)
 
 void *saa7146_vmalloc_build_pgtable(struct pci_dev *pci, long length, struct saa7146_pgtable *pt)
 {
-	int pages = (length+PAGE_SIZE-1)/PAGE_SIZE;
+	int pages = (length + PAGE_SIZE - 1) / PAGE_SIZE;
 	void *mem = vmalloc_32(length);
 	int slen = 0;
 
-	if (NULL == mem)
+	if (!mem)
 		goto err_null;
 
-	if (!(pt->slist = vmalloc_to_sg(mem, pages)))
+	pt->slist = vmalloc_to_sg(mem, pages);
+	if (!pt->slist)
 		goto err_free_mem;
 
 	if (saa7146_pgtable_alloc(pci, pt))
@@ -199,10 +190,10 @@ void *saa7146_vmalloc_build_pgtable(struct pci_dev *pci, long length, struct saa
 
 	pt->nents = pages;
 	slen = pci_map_sg(pci,pt->slist,pt->nents,PCI_DMA_FROMDEVICE);
-	if (0 == slen)
+	if (!slen)
 		goto err_free_pgtable;
 
-	if (0 != saa7146_pgtable_build_single(pci, pt, pt->slist, slen))
+	if (saa7146_pgtable_build_single(pci, pt, pt->slist, slen))
 		goto err_unmap_sg;
 
 	return mem;
@@ -233,7 +224,7 @@ EXPORT_SYMBOL_GPL(saa7146_vfree_destroy_pgtable);
 
 void saa7146_pgtable_free(struct pci_dev *pci, struct saa7146_pgtable *pt)
 {
-	if (NULL == pt->cpu)
+	if (!pt->cpu)
 		return;
 	pci_free_consistent(pci, pt->size, pt->cpu, pt->dma);
 	pt->cpu = NULL;
@@ -246,9 +237,9 @@ int saa7146_pgtable_alloc(struct pci_dev *pci, struct saa7146_pgtable *pt)
 	dma_addr_t   dma_addr;
 
 	cpu = pci_alloc_consistent(pci, PAGE_SIZE, &dma_addr);
-	if (NULL == cpu) {
+	if (!cpu)
 		return -ENOMEM;
-	}
+
 	pt->size = PAGE_SIZE;
 	pt->cpu  = cpu;
 	pt->dma  = dma_addr;
@@ -258,11 +249,11 @@ int saa7146_pgtable_alloc(struct pci_dev *pci, struct saa7146_pgtable *pt)
 EXPORT_SYMBOL_GPL(saa7146_pgtable_alloc);
 
 int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt,
-	struct scatterlist *list, int sglen  )
+	struct scatterlist *list, int sglen)
 {
 	u32 *ptr, fill;
 	int nr_pages = 0;
-	int i,p;
+	int i, p;
 
 	BUG_ON(0 == sglen);
 	BUG_ON(list->offset > PAGE_SIZE);
@@ -285,9 +276,8 @@ int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt
 
 	/* safety; fill the page table up with the last valid page */
 	fill = *(ptr-1);
-	for(i=nr_pages;i<1024;i++) {
+	for (i = nr_pages; i < 1024; i++)
 		*ptr++ = fill;
-	}
 
 /*
 	ptr = pt->cpu;
@@ -300,8 +290,9 @@ int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt
 }
 EXPORT_SYMBOL_GPL(saa7146_pgtable_build_single);
 
-/********************************************************************************/
-/* interrupt handler */
+/*
+ * interrupt handler
+ */
 static irqreturn_t interrupt_hw(int irq, void *dev_id)
 {
 	struct saa7146_dev *dev = dev_id;
@@ -312,36 +303,36 @@ static irqreturn_t interrupt_hw(int irq, void *dev_id)
 	ack_isr = isr = saa7146_read(dev, ISR);
 
 	/* is this our interrupt? */
-	if ( 0 == isr ) {
+	if (!isr) {
 		/* nope, some other device */
 		return IRQ_NONE;
 	}
 
-	if( NULL != (dev->ext)) {
-		if( 0 != (dev->ext->irq_mask & isr )) {
-			if( NULL != dev->ext->irq_func ) {
+	if (dev->ext) {
+		if (dev->ext->irq_mask & isr) {
+			if (dev->ext->irq_func)
 				dev->ext->irq_func(dev, &isr);
-			}
+
 			isr &= ~dev->ext->irq_mask;
 		}
 	}
-	if (0 != (isr & (MASK_27))) {
-		DEB_INT(("irq: RPS0 (0x%08x).\n",isr));
-		if( NULL != dev->vv_data && NULL != dev->vv_callback) {
-			dev->vv_callback(dev,isr);
-		}
+	if (isr & (MASK_27)) {
+		DEB_INT(("irq: RPS0 (0x%08x).\n", isr));
+		if (dev->vv_data && dev->vv_callback)
+			dev->vv_callback(dev, isr);
+
 		isr &= ~MASK_27;
 	}
-	if (0 != (isr & (MASK_28))) {
-		if( NULL != dev->vv_data && NULL != dev->vv_callback) {
-			dev->vv_callback(dev,isr);
-		}
+	if (isr & (MASK_28)) {
+		if (dev->vv_data && dev->vv_callback)
+			dev->vv_callback(dev, isr);
+
 		isr &= ~MASK_28;
 	}
-	if (0 != (isr & (MASK_16|MASK_17))) {
+	if (isr & (MASK_16|MASK_17)) {
 		SAA7146_IER_DISABLE(dev, MASK_16|MASK_17);
 		/* only wake up if we expect something */
-		if (0 != dev->i2c_op) {
+		if (dev->i2c_op) {
 			dev->i2c_op = 0;
 			wake_up(&dev->i2c_wq);
 		} else {
@@ -352,25 +343,29 @@ static irqreturn_t interrupt_hw(int irq, void *dev_id)
 		}
 		isr &= ~(MASK_16|MASK_17);
 	}
-	if( 0 != isr ) {
-		ERR(("warning: interrupt enabled, but not handled properly.(0x%08x)\n",isr));
+	if (isr) {
+		ERR(("warning: interrupt enabled, but not handled properly.(0x%08x)\n", isr));
 		ERR(("disabling interrupt source(s)!\n"));
-		SAA7146_IER_DISABLE(dev,isr);
+		SAA7146_IER_DISABLE(dev, isr);
 	}
 	saa7146_write(dev, ISR, ack_isr);
 	return IRQ_HANDLED;
 }
 
-/*********************************************************************************/
-/* configuration-functions                                                       */
+/*
+ * configuration-functions
+ */
 
 static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent)
 {
-	struct saa7146_pci_extension_data *pci_ext = (struct saa7146_pci_extension_data *)ent->driver_data;
-	struct saa7146_extension *ext = pci_ext->ext;
+	struct saa7146_pci_extension_data *pci_ext;
+	struct saa7146_extension *ext;
 	struct saa7146_dev *dev;
 	int err = -ENOMEM;
 
+	pci_ext = (struct saa7146_pci_extension_data *)ent->driver_data;
+	ext = pci_ext->ext;
+
 	/* clear out mem for sure */
 	dev = kzalloc(sizeof(struct saa7146_dev), GFP_KERNEL);
 	if (!dev) {
@@ -378,7 +373,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 		goto out;
 	}
 
-	DEB_EE(("pci:%p\n",pci));
+	DEB_EE(("pci:%p\n", pci));
 
 	err = pci_enable_device(pci);
 	if (err < 0) {
@@ -463,7 +458,8 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	/* create a nice device name */
 	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
 
-	INFO(("found saa7146 @ mem %p (revision %d, irq %d) (0x%04x,0x%04x).\n", dev->mem, dev->revision, pci->irq, pci->subsystem_vendor, pci->subsystem_device));
+	INFO(("found saa7146 @ mem %p (revision %d, irq %d) (0x%04x,0x%04x).\n",
+	      dev->mem, dev->revision, pci->irq, pci->subsystem_vendor, pci->subsystem_device));
 	dev->ext = ext;
 
 	pci_set_drvdata(pci, dev);
@@ -485,17 +481,17 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	err = -ENODEV;
 
 	if (ext->probe && ext->probe(dev)) {
-		DEB_D(("ext->probe() failed for %p. skipping device.\n",dev));
+		DEB_D(("ext->probe() failed for %p. skipping device.\n", dev));
 		goto err_free_i2c;
 	}
 
 	if (ext->attach(dev, pci_ext)) {
-		DEB_D(("ext->attach() failed for %p. skipping device.\n",dev));
+		DEB_D(("ext->attach() failed for %p. skipping device.\n", dev));
 		goto err_unprobe;
 	}
 
 	INIT_LIST_HEAD(&dev->item);
-	list_add_tail(&dev->item,&saa7146_devices);
+	list_add_tail(&dev->item, &saa7146_devices);
 	saa7146_num++;
 
 	err = 0;
@@ -528,7 +524,7 @@ err_free:
 
 static void saa7146_remove_one(struct pci_dev *pdev)
 {
-	struct saa7146_dev* dev = pci_get_drvdata(pdev);
+	struct saa7146_dev *dev = pci_get_drvdata(pdev);
 	struct {
 		void *addr;
 		dma_addr_t dma;
@@ -539,7 +535,7 @@ static void saa7146_remove_one(struct pci_dev *pdev)
 		{ NULL, 0 }
 	}, *p;
 
-	DEB_EE(("dev:%p\n",dev));
+	DEB_EE(("dev:%p\n", dev));
 
 	dev->ext->detach(dev);
 
@@ -563,27 +559,28 @@ static void saa7146_remove_one(struct pci_dev *pdev)
 	saa7146_num--;
 }
 
-/*********************************************************************************/
-/* extension handling functions                                                  */
+/*
+ * extension handling functions
+ */
 
-int saa7146_register_extension(struct saa7146_extension* ext)
+int saa7146_register_extension(struct saa7146_extension *ext)
 {
-	DEB_EE(("ext:%p\n",ext));
+	DEB_EE(("ext:%p\n", ext));
 
 	ext->driver.name = ext->name;
 	ext->driver.id_table = ext->pci_tbl;
 	ext->driver.probe = saa7146_init_one;
 	ext->driver.remove = saa7146_remove_one;
 
-	printk("saa7146: register extension '%s'.\n",ext->name);
+	printk("saa7146: register extension '%s'.\n", ext->name);
 	return pci_register_driver(&ext->driver);
 }
 EXPORT_SYMBOL_GPL(saa7146_register_extension);
 
-int saa7146_unregister_extension(struct saa7146_extension* ext)
+int saa7146_unregister_extension(struct saa7146_extension *ext)
 {
-	DEB_EE(("ext:%p\n",ext));
-	printk("saa7146: unregister extension '%s'.\n",ext->name);
+	DEB_EE(("ext:%p\n", ext));
+	printk("saa7146: unregister extension '%s'.\n", ext->name);
 	pci_unregister_driver(&ext->driver);
 	return 0;
 }
-- 
1.5.4.3.409.g8811

