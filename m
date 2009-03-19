Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbZCSV5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbZCSV5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760615AbZCSV5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:57:17 -0400
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:44066 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759176AbZCSV5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:57:16 -0400
From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
To: greg@kroah.com
Cc: leon@sidebranch.com, linux-kernel@vger.kernel.org,
       =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [PATCH 1/1] Checkpatch.pl: Fixup altpciechdma.c
Date: Thu, 19 Mar 2009 21:47:12 +0100
Message-Id: <1237495632-5818-2-git-send-email-erik.andren@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1237495632-5818-1-git-send-email-erik.andren@gmail.com>
References: <1>
 <1237495632-5818-1-git-send-email-erik.andren@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
---
 drivers/staging/altpciechdma/altpciechdma.c |   64 +++++++++++++--------------
 1 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/altpciechdma/altpciechdma.c b/drivers/staging/altpciechdma/altpciechdma.c
index f516140..d1ef74c 100644
--- a/drivers/staging/altpciechdma/altpciechdma.c
+++ b/drivers/staging/altpciechdma/altpciechdma.c
@@ -313,15 +313,16 @@ static int __devinit map_bars(struct ape_dev *ape, struct pci_dev *dev)
 			continue;
 		/* do not map BARs with address 0 */
 		if (!bar_start || !bar_end) {
-            printk(KERN_DEBUG "BAR #%d is not present?!\n", i);
+			printk(KERN_DEBUG "BAR #%d is not present?!\n", i);
 			rc = -1;
 			goto fail;
 		}
 		bar_length = bar_end - bar_start + 1;
 		/* BAR length is less than driver requires? */
 		if (bar_length < bar_min_len[i]) {
-            printk(KERN_DEBUG "BAR #%d length = %lu bytes but driver "
-            "requires at least %lu bytes\n", i, bar_length, bar_min_len[i]);
+			printk(KERN_DEBUG "BAR #%d length = %lu bytes but driver "
+			"requires at least %lu bytes\n",
+			i, bar_length, bar_min_len[i]);
 			rc = -1;
 			goto fail;
 		}
@@ -333,8 +334,8 @@ static int __devinit map_bars(struct ape_dev *ape, struct pci_dev *dev)
 			rc = -1;
 			goto fail;
 		}
-        printk(KERN_DEBUG "BAR[%d] mapped at 0x%p with length %lu(/%lu).\n", i,
-			ape->bar[i], bar_min_len[i], bar_length);
+		printk(KERN_DEBUG "BAR[%d] mapped at 0x%p with length %lu(/%lu).\n", i,
+		ape->bar[i], bar_min_len[i], bar_length);
 	}
 	/* succesfully mapped all required BAR regions */
 	rc = 0;
@@ -467,15 +468,14 @@ static inline int compare(u32 *p, u32 *q, int len)
 		} else {
 			fail++;
 			/* show the first few miscompares */
-			if (fail < 10) {
-                printk(KERN_DEBUG "[%p] = 0x%08x != [%p] = 0x%08x ?!\n", p, *p, q, *q);
-            /* but stop after a while */
-            } else if (fail == 10) {
-                printk(KERN_DEBUG "---more errors follow! not printed---\n");
-		  	} else {
+			if (fail < 10)
+				printk(KERN_DEBUG "[%p] = 0x%08x != [%p] = 0x%08x ?!\n", p, *p, q, *q);
+				/* but stop after a while */
+			else if (fail == 10)
+				printk(KERN_DEBUG "---more errors follow! not printed---\n");
+			else
 				/* stop compare after this many errors */
-                break;
-            }
+			break;
 		}
 		p++;
 		q++;
@@ -528,7 +528,7 @@ static int __devinit dma_test(struct ape_dev *ape, struct pci_dev *dev)
 	printk(KERN_DEBUG "ape->table_virt = 0x%p.\n", ape->table_virt);
 
 	if (!write_header || !read_header || !ape->table_virt)
-        goto fail;
+		goto fail;
 
 	/* allocate and map coherently-cached memory for a DMA-able buffer */
 	/* @see Documentation/PCI/PCI-DMA-mapping.txt, near line 318 */
@@ -565,9 +565,8 @@ static int __devinit dma_test(struct ape_dev *ape, struct pci_dev *dev)
 	/* read 8192 bytes from RC buffer to EP address 4096 */
 	ape_chdma_desc_set(&ape->table_virt->desc[n], buffer_bus, 4096, 2 * PAGE_SIZE);
 #if 1
-	for (i = 0; i < 255; i++) {
+	for (i = 0; i < 255; i++)
 		ape_chdma_desc_set(&ape->table_virt->desc[i], buffer_bus, 4096, 2 * PAGE_SIZE);
-	}
 	/* index of last descriptor */
 	n = i - 1;
 #endif
@@ -647,7 +646,7 @@ static int __devinit dma_test(struct ape_dev *ape, struct pci_dev *dev)
 		printk(KERN_DEBUG "EPLAST = %u, n = %d\n", eplast, n);
 		if (eplast == n) {
 			printk(KERN_DEBUG "DONE\n");
-            /* print IRQ count before the transfer */
+			/* print IRQ count before the transfer */
 			printk(KERN_DEBUG "#IRQs during transfer: %d\n", ape->irq_count - irq_count);
 			break;
 		}
@@ -661,9 +660,9 @@ static int __devinit dma_test(struct ape_dev *ape, struct pci_dev *dev)
 	n = 0;
 	ape_chdma_desc_set(&ape->table_virt->desc[n], buffer_bus + 8192, 4096, 2 * PAGE_SIZE);
 #if 1
-	for (i = 0; i < 255; i++) {
+	for (i = 0; i < 255; i++)
 		ape_chdma_desc_set(&ape->table_virt->desc[i], buffer_bus + 8192, 4096, 2 * PAGE_SIZE);
-	}
+
 	/* index of last descriptor */
 	n = i - 1;
 #endif
@@ -691,7 +690,7 @@ static int __devinit dma_test(struct ape_dev *ape, struct pci_dev *dev)
 	w = (u32)(n + 1);
 	/* enable updates of eplast for each descriptor completion */
 	w |= (u32)(1UL << 18)/*global EPLAST_EN*/;
-#if 0 // test variable, make a module option later
+#if 0   /* test variable, make a module option later */
 	/* enable MSI for each descriptor completion */
 	if (ape->msi_enabled)
 		w |= (1UL << 17)/*global MSI*/;
@@ -715,7 +714,7 @@ static int __devinit dma_test(struct ape_dev *ape, struct pci_dev *dev)
 	/** memory write barrier */
 	wmb();
 	/** dummy read to flush posted writes */
-	//(void)ioread32();
+	/* (void) ioread32(); */
 
 	printk(KERN_DEBUG "POLL FOR WRITE:\n");
 	/* poll for completion, 1000 times 1 millisecond */
@@ -844,7 +843,7 @@ static int __devinit probe(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 	ape->got_regions = 1;
 
-#if 1 // @todo For now, disable 64-bit, because I do not understand the implications (DAC!)
+#if 1   /* @todo For now, disable 64-bit, because I do not understand the implications (DAC!) */
 	/* query for DMA transfer */
 	/* @see Documentation/PCI/PCI-DMA-mapping.txt */
 	if (!pci_set_dma_mask(dev, DMA_64BIT_MASK)) {
@@ -1048,10 +1047,9 @@ static ssize_t sg_write(struct file *file, const char __user *buf, size_t count,
 	printk(KERN_DEBUG DRV_NAME "_write(buf=0x%p, count=%lld, pos=%llu)\n",
 		buf, (s64)count, (u64)*pos);
 	/* TODO transfer boundaries at PAGE_SIZE granularity */
-	while (remaining > 0)
-	{
+	while (remaining > 0) {
 		/* limit DMA transfer size */
-		transfer_len = (remaining < APE_CHDMA_MAX_TRANSFER_LEN)? remaining:
+		transfer_len = (remaining < APE_CHDMA_MAX_TRANSFER_LEN) ? remaining :
 			APE_CHDMA_MAX_TRANSFER_LEN;
 		/* get all user space buffer pages and create a scattergather list */
 		sgm_map_user_pages(ape->sgm, transfer_addr, transfer_len, 0/*read from userspace*/);
@@ -1085,12 +1083,12 @@ static ssize_t sg_write(struct file *file, const char __user *buf, size_t count,
 /*
  * character device file operations
  */
-static struct file_operations sg_fops = {
-  .owner = THIS_MODULE,
-  .open = sg_open,
-  .release = sg_close,
-  .read = sg_read,
-  .write = sg_write,
+static const struct file_operations sg_fops = {
+	.owner = THIS_MODULE,
+	.open = sg_open,
+	.release = sg_close,
+	.read = sg_read,
+	.write = sg_write,
 };
 
 /* sg_init() - Initialize character device
@@ -1158,12 +1156,12 @@ static struct pci_driver pci_driver = {
  */
 static int __init alterapciechdma_init(void)
 {
-  int rc = 0;
+	int rc = 0;
 	printk(KERN_DEBUG DRV_NAME " init(), built at " __DATE__ " " __TIME__ "\n");
 	/* register this driver with the PCI bus driver */
 	rc = pci_register_driver(&pci_driver);
 	if (rc < 0)
-	  return rc;
+		return rc;
 	return 0;
 }
 
-- 
1.6.0.4

