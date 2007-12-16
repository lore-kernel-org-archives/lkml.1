Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXLPVRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXLPVRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbXLPVQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:16:55 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:34591 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbXLPVQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:16:53 -0500
Date: Sun, 16 Dec 2007 13:15:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, David Chinner <dgc@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] umem nvram driver: clean up style
Message-Id: <20071216131558.8e3d57e1.randy.dunlap@oracle.com>
In-Reply-To: <20071204093716.GB4541@elte.hu>
References: <20071203213558.GP115527101@sgi.com>
	<18260.39892.215075.795664@notabene.brown>
	<20071204093716.GB4541@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 10:37:16 +0100 Ingo Molnar wrote:

> btw., if anyone feels so inclined, this file has quite a number of 
> coding style issues, as per scripts/checkpatch.pl output:
> 
>  total: 28 errors, 54 warnings, 1221 lines checked

From: Randy Dunlap <randy.dunlap@oracle.com>

Cleanup umem driver: fix all checkpatch warnings, conform to kernel
coding style.

  linux-2.6.24-rc5-git3> checkpatch.pl-next  patches/block-umem-ckpatch.patch
  total: 0 errors, 0 warnings, 546 lines checked

  patches/block-umem-ckpatch.patch has no obvious style problems and is ready for submission.

Only change in generated object file is due to not initializing a
static global variable to 0.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/block/umem.c |  249 ++++++++++++++++++-----------------------
 1 file changed, 112 insertions(+), 137 deletions(-)

--- linux-2.6.24-rc5-git3.orig/drivers/block/umem.c
+++ linux-2.6.24-rc5-git3/drivers/block/umem.c
@@ -34,7 +34,7 @@
  *			 - set initialised bit then.
  */
 
-//#define DEBUG /* uncomment if you want debugging info (pr_debug) */
+#undef DEBUG	/* #define DEBUG if you want debugging info (pr_debug) */
 #include <linux/fs.h>
 #include <linux/bio.h>
 #include <linux/kernel.h>
@@ -143,17 +143,15 @@ static struct cardinfo cards[MM_MAXCARDS
 static struct block_device_operations mm_fops;
 static struct timer_list battery_timer;
 
-static int num_cards = 0;
+static int num_cards;
 
 static struct gendisk *mm_gendisk[MM_MAXCARDS];
 
 static void check_batteries(struct cardinfo *card);
 
 /*
------------------------------------------------------------------------------------
---                           get_userbit
------------------------------------------------------------------------------------
-*/
+ *                           get_userbit
+ */
 static int get_userbit(struct cardinfo *card, int bit)
 {
 	unsigned char led;
@@ -162,10 +160,8 @@ static int get_userbit(struct cardinfo *
 	return led & bit;
 }
 /*
------------------------------------------------------------------------------------
---                            set_userbit
------------------------------------------------------------------------------------
-*/
+ *                            set_userbit
+ */
 static int set_userbit(struct cardinfo *card, int bit, unsigned char state)
 {
 	unsigned char led;
@@ -180,10 +176,8 @@ static int set_userbit(struct cardinfo *
 	return 0;
 }
 /*
------------------------------------------------------------------------------------
---                             set_led
------------------------------------------------------------------------------------
-*/
+ *                             set_led
+ */
 /*
  * NOTE: For the power LED, use the LED_POWER_* macros since they differ
  */
@@ -204,10 +198,8 @@ static void set_led(struct cardinfo *car
 
 #ifdef MM_DIAG
 /*
------------------------------------------------------------------------------------
---                              dump_regs
------------------------------------------------------------------------------------
-*/
+ *                              dump_regs
+ */
 static void dump_regs(struct cardinfo *card)
 {
 	unsigned char *p;
@@ -225,31 +217,29 @@ static void dump_regs(struct cardinfo *c
 }
 #endif
 /*
------------------------------------------------------------------------------------
---                            dump_dmastat
------------------------------------------------------------------------------------
-*/
+ *                            dump_dmastat
+ */
 static void dump_dmastat(struct cardinfo *card, unsigned int dmastat)
 {
 	dev_printk(KERN_DEBUG, &card->dev->dev, "DMAstat - ");
 	if (dmastat & DMASCR_ANY_ERR)
-		printk("ANY_ERR ");
+		printk(KERN_CONT "ANY_ERR ");
 	if (dmastat & DMASCR_MBE_ERR)
-		printk("MBE_ERR ");
+		printk(KERN_CONT "MBE_ERR ");
 	if (dmastat & DMASCR_PARITY_ERR_REP)
-		printk("PARITY_ERR_REP ");
+		printk(KERN_CONT "PARITY_ERR_REP ");
 	if (dmastat & DMASCR_PARITY_ERR_DET)
-		printk("PARITY_ERR_DET ");
+		printk(KERN_CONT "PARITY_ERR_DET ");
 	if (dmastat & DMASCR_SYSTEM_ERR_SIG)
-		printk("SYSTEM_ERR_SIG ");
+		printk(KERN_CONT "SYSTEM_ERR_SIG ");
 	if (dmastat & DMASCR_TARGET_ABT)
-		printk("TARGET_ABT ");
+		printk(KERN_CONT "TARGET_ABT ");
 	if (dmastat & DMASCR_MASTER_ABT)
-		printk("MASTER_ABT ");
+		printk(KERN_CONT "MASTER_ABT ");
 	if (dmastat & DMASCR_CHAIN_COMPLETE)
-		printk("CHAIN_COMPLETE ");
+		printk(KERN_CONT "CHAIN_COMPLETE ");
 	if (dmastat & DMASCR_DMA_COMPLETE)
-		printk("DMA_COMPLETE ");
+		printk(KERN_CONT "DMA_COMPLETE ");
 	printk("\n");
 }
 
@@ -286,7 +276,8 @@ static void mm_start_io(struct cardinfo 
 
 	/* make the last descriptor end the chain */
 	page = &card->mm_pages[card->Active];
-	pr_debug("start_io: %d %d->%d\n", card->Active, page->headcnt, page->cnt-1);
+	pr_debug("start_io: %d %d->%d\n",
+		card->Active, page->headcnt, page->cnt - 1);
 	desc = &page->desc[page->cnt-1];
 
 	desc->control_bits |= cpu_to_le32(DMASCR_CHAIN_COMP_EN);
@@ -310,8 +301,8 @@ static void mm_start_io(struct cardinfo 
 	writel(0, card->csr_remap + DMA_SEMAPHORE_ADDR);
 	writel(0, card->csr_remap + DMA_SEMAPHORE_ADDR + 4);
 
-	offset = ((char*)desc) - ((char*)page->desc);
-	writel(cpu_to_le32((page->page_dma+offset)&0xffffffff),
+	offset = ((char *)desc) - ((char *)page->desc);
+	writel(cpu_to_le32((page->page_dma+offset) & 0xffffffff),
 	       card->csr_remap + DMA_DESCRIPTOR_ADDR);
 	/* Force the value to u64 before shifting otherwise >> 32 is undefined C
 	 * and on some ports will do nothing ! */
@@ -352,7 +343,7 @@ static inline void reset_page(struct mm_
 	page->cnt = 0;
 	page->headcnt = 0;
 	page->bio = NULL;
-	page->biotail = & page->bio;
+	page->biotail = &page->bio;
 }
 
 static void mm_unplug_device(struct request_queue *q)
@@ -408,7 +399,7 @@ static int add_bio(struct cardinfo *card
 				  vec->bv_page,
 				  vec->bv_offset,
 				  len,
-				  (rw==READ) ?
+				  (rw == READ) ?
 				  PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
 
 	p = &card->mm_pages[card->Ready];
@@ -427,10 +418,10 @@ static int add_bio(struct cardinfo *card
 	desc->pci_addr = cpu_to_le64((u64)desc->data_dma_handle);
 	desc->local_addr = cpu_to_le64(card->current_sector << 9);
 	desc->transfer_size = cpu_to_le32(len);
-	offset = ( ((char*)&desc->sem_control_bits) - ((char*)p->desc));
+	offset = (((char *)&desc->sem_control_bits) - ((char *)p->desc));
 	desc->sem_addr = cpu_to_le64((u64)(p->page_dma+offset));
 	desc->zero1 = desc->zero2 = 0;
-	offset = ( ((char*)(desc+1)) - ((char*)p->desc));
+	offset = (((char *)(desc+1)) - ((char *)p->desc));
 	desc->next_desc_addr = cpu_to_le64(p->page_dma+offset);
 	desc->control_bits = cpu_to_le32(DMASCR_GO|DMASCR_ERR_INT_EN|
 					 DMASCR_PARITY_INT_EN|
@@ -455,11 +446,11 @@ static void process_page(unsigned long d
 	/* check if any of the requests in the page are DMA_COMPLETE,
 	 * and deal with them appropriately.
 	 * If we find a descriptor without DMA_COMPLETE in the semaphore, then
-	 * dma must have hit an error on that descriptor, so use dma_status instead
-	 * and assume that all following descriptors must be re-tried.
+	 * dma must have hit an error on that descriptor, so use dma_status
+	 * instead and assume that all following descriptors must be re-tried.
 	 */
 	struct mm_page *page;
-	struct bio *return_bio=NULL;
+	struct bio *return_bio = NULL;
 	struct cardinfo *card = (struct cardinfo *)data;
 	unsigned int dma_status = card->dma_status;
 
@@ -472,12 +463,12 @@ static void process_page(unsigned long d
 		struct bio *bio = page->bio;
 		struct mm_dma_desc *desc = &page->desc[page->headcnt];
 		int control = le32_to_cpu(desc->sem_control_bits);
-		int last=0;
+		int last = 0;
 		int idx;
 
 		if (!(control & DMASCR_DMA_COMPLETE)) {
 			control = dma_status;
-			last=1;
+			last = 1;
 		}
 		page->headcnt++;
 		idx = page->idx;
@@ -489,8 +480,8 @@ static void process_page(unsigned long d
 		}
 
 		pci_unmap_page(card->dev, desc->data_dma_handle,
-			       bio_iovec_idx(bio,idx)->bv_len,
-				 (control& DMASCR_TRANSFER_READ) ?
+			       bio_iovec_idx(bio, idx)->bv_len,
+				 (control & DMASCR_TRANSFER_READ) ?
 				PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
 		if (control & DMASCR_HARD_ERROR) {
 			/* error */
@@ -501,9 +492,11 @@ static void process_page(unsigned long d
 				le32_to_cpu(desc->transfer_size));
 			dump_dmastat(card, control);
 		} else if (test_bit(BIO_RW, &bio->bi_rw) &&
-			   le32_to_cpu(desc->local_addr)>>9 == card->init_size) {
-			card->init_size += le32_to_cpu(desc->transfer_size)>>9;
-			if (card->init_size>>1 >= card->mm_size) {
+			   le32_to_cpu(desc->local_addr) >> 9 ==
+				card->init_size) {
+			card->init_size += le32_to_cpu(desc->transfer_size)
+							>> 9;
+			if (card->init_size >> 1 >= card->mm_size) {
 				dev_printk(KERN_INFO, &card->dev->dev,
 					"memory now initialised\n");
 				set_userbit(card, MEMORY_INITIALIZED, 1);
@@ -514,7 +507,8 @@ static void process_page(unsigned long d
 			return_bio = bio;
 		}
 
-		if (last) break;
+		if (last)
+			break;
 	}
 
 	if (debug & DEBUG_LED_ON_TRANSFER)
@@ -536,7 +530,7 @@ static void process_page(unsigned long d
  out_unlock:
 	spin_unlock_bh(&card->lock);
 
-	while(return_bio) {
+	while (return_bio) {
 		struct bio *bio = return_bio;
 
 		return_bio = bio->bi_next;
@@ -546,10 +540,8 @@ static void process_page(unsigned long d
 }
 
 /*
------------------------------------------------------------------------------------
---                              mm_make_request
------------------------------------------------------------------------------------
-*/
+ *                              mm_make_request
+ */
 static int mm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct cardinfo *card = q->queuedata;
@@ -567,10 +559,8 @@ static int mm_make_request(struct reques
 }
 
 /*
------------------------------------------------------------------------------------
---                              mm_interrupt
------------------------------------------------------------------------------------
-*/
+ *                              mm_interrupt
+ */
 static irqreturn_t mm_interrupt(int irq, void *__card)
 {
 	struct cardinfo *card = (struct cardinfo *) __card;
@@ -584,15 +574,15 @@ HW_TRACE(0x30);
 	if (!(dma_status & (DMASCR_ERROR_MASK | DMASCR_CHAIN_COMPLETE))) {
 		/* interrupt wasn't for me ... */
 		return IRQ_NONE;
-        }
+	}
 
 	/* clear COMPLETION interrupts */
 	if (card->flags & UM_FLAG_NO_BYTE_STATUS)
 		writel(cpu_to_le32(DMASCR_DMA_COMPLETE|DMASCR_CHAIN_COMPLETE),
-		       card->csr_remap+ DMA_STATUS_CTRL);
+		       card->csr_remap + DMA_STATUS_CTRL);
 	else
 		writeb((DMASCR_DMA_COMPLETE|DMASCR_CHAIN_COMPLETE) >> 16,
-		       card->csr_remap+ DMA_STATUS_CTRL + 2);
+		       card->csr_remap + DMA_STATUS_CTRL + 2);
 
 	/* log errors and clear interrupt status */
 	if (dma_status & DMASCR_ANY_ERR) {
@@ -602,9 +592,12 @@ HW_TRACE(0x30);
 
 		stat = readb(card->csr_remap + MEMCTRLCMD_ERRSTATUS);
 
-		data_log1 = le32_to_cpu(readl(card->csr_remap + ERROR_DATA_LOG));
-		data_log2 = le32_to_cpu(readl(card->csr_remap + ERROR_DATA_LOG + 4));
-		addr_log1 = le32_to_cpu(readl(card->csr_remap + ERROR_ADDR_LOG));
+		data_log1 = le32_to_cpu(readl(card->csr_remap +
+						ERROR_DATA_LOG));
+		data_log2 = le32_to_cpu(readl(card->csr_remap +
+						ERROR_DATA_LOG + 4));
+		addr_log1 = le32_to_cpu(readl(card->csr_remap +
+						ERROR_ADDR_LOG));
 		addr_log2 = readb(card->csr_remap + ERROR_ADDR_LOG + 4);
 
 		count = readb(card->csr_remap + ERROR_COUNT);
@@ -672,10 +665,8 @@ HW_TRACE(0x36);
 	return IRQ_HANDLED;
 }
 /*
------------------------------------------------------------------------------------
---                         set_fault_to_battery_status
------------------------------------------------------------------------------------
-*/
+ *                         set_fault_to_battery_status
+ */
 /*
  * If both batteries are good, no LED
  * If either battery has been warned, solid LED
@@ -698,10 +689,8 @@ static void init_battery_timer(void);
 
 
 /*
------------------------------------------------------------------------------------
---                            check_battery
------------------------------------------------------------------------------------
-*/
+ *                            check_battery
+ */
 static int check_battery(struct cardinfo *card, int battery, int status)
 {
 	if (status != card->battery[battery].good) {
@@ -731,10 +720,8 @@ static int check_battery(struct cardinfo
 	return 0;
 }
 /*
------------------------------------------------------------------------------------
---                              check_batteries
------------------------------------------------------------------------------------
-*/
+ *                              check_batteries
+ */
 static void check_batteries(struct cardinfo *card)
 {
 	/* NOTE: this must *never* be called while the card
@@ -776,10 +763,8 @@ static void check_all_batteries(unsigned
 	init_battery_timer();
 }
 /*
------------------------------------------------------------------------------------
---                            init_battery_timer
------------------------------------------------------------------------------------
-*/
+ *                            init_battery_timer
+ */
 static void init_battery_timer(void)
 {
 	init_timer(&battery_timer);
@@ -788,19 +773,15 @@ static void init_battery_timer(void)
 	add_timer(&battery_timer);
 }
 /*
------------------------------------------------------------------------------------
---                              del_battery_timer
------------------------------------------------------------------------------------
-*/
+ *                              del_battery_timer
+ */
 static void del_battery_timer(void)
 {
 	del_timer(&battery_timer);
 }
 /*
------------------------------------------------------------------------------------
---                                mm_revalidate
------------------------------------------------------------------------------------
-*/
+ *                                mm_revalidate
+ */
 /*
  * Note no locks taken out here.  In a worst case scenario, we could drop
  * a chunk of system memory.  But that should never happen, since validation
@@ -833,33 +814,29 @@ static int mm_getgeo(struct block_device
 }
 
 /*
------------------------------------------------------------------------------------
---                                mm_check_change
------------------------------------------------------------------------------------
-  Future support for removable devices
-*/
+ *                                mm_check_change
+ *
+ * Future support for removable devices
+ */
 static int mm_check_change(struct gendisk *disk)
 {
 /*  struct cardinfo *dev = disk->private_data; */
 	return 0;
 }
 /*
------------------------------------------------------------------------------------
---                             mm_fops
------------------------------------------------------------------------------------
-*/
+ *                             mm_fops
+ */
 static struct block_device_operations mm_fops = {
 	.owner		= THIS_MODULE,
 	.getgeo		= mm_getgeo,
-	.revalidate_disk= mm_revalidate,
+	.revalidate_disk = mm_revalidate,
 	.media_changed	= mm_check_change,
 };
 /*
------------------------------------------------------------------------------------
---                                mm_pci_probe
------------------------------------------------------------------------------------
-*/
-static int __devinit mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
+ *                                mm_pci_probe
+ */
+static int __devinit mm_pci_probe(struct pci_dev *dev,
+				const struct pci_device_id *id)
 {
 	int ret = -ENODEV;
 	struct cardinfo *card = &cards[num_cards];
@@ -889,7 +866,8 @@ static int __devinit mm_pci_probe(struct
 		return -ENODEV;
 
 	dev_printk(KERN_INFO, &dev->dev,
-		"Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))\n");
+		"Micro Memory(tm) controller found "
+		"(PCI Mem Module (Battery Backup))\n");
 
 	if (pci_set_dma_mask(dev, DMA_64BIT_MASK) &&
 	    pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
@@ -917,7 +895,7 @@ static int __devinit mm_pci_probe(struct
 		"CSR 0x%08lx -> 0x%p (0x%lx)\n",
 	       csr_base, card->csr_remap, csr_len);
 
-	switch(card->dev->device) {
+	switch (card->dev->device) {
 	case 0x5415:
 		card->flags |= UM_FLAG_NO_BYTE_STATUS | UM_FLAG_NO_BATTREG;
 		magic_number = 0x59;
@@ -929,7 +907,8 @@ static int __devinit mm_pci_probe(struct
 		break;
 
 	case 0x6155:
-		card->flags |= UM_FLAG_NO_BYTE_STATUS | UM_FLAG_NO_BATTREG | UM_FLAG_NO_BATT;
+		card->flags |= UM_FLAG_NO_BYTE_STATUS |
+				UM_FLAG_NO_BATTREG | UM_FLAG_NO_BATT;
 		magic_number = 0x99;
 		break;
 
@@ -945,11 +924,11 @@ static int __devinit mm_pci_probe(struct
 	}
 
 	card->mm_pages[0].desc = pci_alloc_consistent(card->dev,
-						      PAGE_SIZE*2,
-						      &card->mm_pages[0].page_dma);
+						PAGE_SIZE * 2,
+						&card->mm_pages[0].page_dma);
 	card->mm_pages[1].desc = pci_alloc_consistent(card->dev,
-						      PAGE_SIZE*2,
-						      &card->mm_pages[1].page_dma);
+						PAGE_SIZE * 2,
+						&card->mm_pages[1].page_dma);
 	if (card->mm_pages[0].desc == NULL ||
 	    card->mm_pages[1].desc == NULL) {
 		dev_printk(KERN_ERR, &card->dev->dev, "alloc failed\n");
@@ -1013,9 +992,11 @@ static int __devinit mm_pci_probe(struct
 		dev_printk(KERN_INFO, &card->dev->dev,
 			"Size %d KB, Battery 1 %s (%s), Battery 2 %s (%s)\n",
 		       card->mm_size,
-		       (batt_status & BATTERY_1_DISABLED ? "Disabled" : "Enabled"),
+		       batt_status & BATTERY_1_DISABLED ? "Disabled"
+					: "Enabled",
 		       card->battery[0].good ? "OK" : "FAILURE",
-		       (batt_status & BATTERY_2_DISABLED ? "Disabled" : "Enabled"),
+		       batt_status & BATTERY_2_DISABLED ? "Disabled"
+					: "Enabled",
 		       card->battery[1].good ? "OK" : "FAILURE");
 
 		set_fault_to_battery_status(card);
@@ -1030,18 +1011,18 @@ static int __devinit mm_pci_probe(struct
 	data = ~data;
 	data += 1;
 
-	if (request_irq(dev->irq, mm_interrupt, IRQF_SHARED, DRIVER_NAME, card)) {
+	if (request_irq(dev->irq, mm_interrupt, IRQF_SHARED, DRIVER_NAME,
+			card)) {
 		dev_printk(KERN_ERR, &card->dev->dev,
 			"Unable to allocate IRQ\n");
 		ret = -ENODEV;
-
 		goto failed_req_irq;
 	}
 
 	dev_printk(KERN_INFO, &card->dev->dev,
 		"Window size %d bytes, IRQ %d\n", data, dev->irq);
 
-        spin_lock_init(&card->lock);
+	spin_lock_init(&card->lock);
 
 	pci_set_drvdata(dev, card);
 
@@ -1060,7 +1041,8 @@ static int __devinit mm_pci_probe(struct
 
 	if (!get_userbit(card, MEMORY_INITIALIZED)) {
 		dev_printk(KERN_INFO, &card->dev->dev,
-			"memory NOT initialized. Consider over-writing whole device.\n");
+			"memory NOT initialized. Consider "
+			"over-writing whole device.\n");
 		card->init_size = 0;
 	} else {
 		dev_printk(KERN_INFO, &card->dev->dev,
@@ -1092,10 +1074,8 @@ static int __devinit mm_pci_probe(struct
 	return ret;
 }
 /*
------------------------------------------------------------------------------------
---                              mm_pci_remove
------------------------------------------------------------------------------------
-*/
+ *                              mm_pci_remove
+ */
 static void mm_pci_remove(struct pci_dev *dev)
 {
 	struct cardinfo *card = pci_get_drvdata(dev);
@@ -1119,16 +1099,16 @@ static void mm_pci_remove(struct pci_dev
 }
 
 static const struct pci_device_id mm_pci_ids[] = {
-    {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY,PCI_DEVICE_ID_MICRO_MEMORY_5415CN)},
-    {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY,PCI_DEVICE_ID_MICRO_MEMORY_5425CN)},
-    {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY,PCI_DEVICE_ID_MICRO_MEMORY_6155)},
+    {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY, PCI_DEVICE_ID_MICRO_MEMORY_5415CN)},
+    {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY, PCI_DEVICE_ID_MICRO_MEMORY_5425CN)},
+    {PCI_DEVICE(PCI_VENDOR_ID_MICRO_MEMORY, PCI_DEVICE_ID_MICRO_MEMORY_6155)},
     {
 	.vendor	=	0x8086,
 	.device	=	0xB555,
-	.subvendor=	0x1332,
-	.subdevice=	0x5460,
-	.class	=	0x050000,
-	.class_mask=	0,
+	.subvendor =	0x1332,
+	.subdevice =	0x5460,
+	.class =	0x050000,
+	.class_mask =	0,
     }, { /* end: all zeroes */ }
 };
 
@@ -1142,11 +1122,8 @@ static struct pci_driver mm_pci_driver =
 };
 
 /*
------------------------------------------------------------------------------------
---                               mm_init
------------------------------------------------------------------------------------
-*/
-
+ *                               mm_init
+ */
 static int __init mm_init(void)
 {
 	int retval, i;
@@ -1194,17 +1171,15 @@ out:
 	return -ENOMEM;
 }
 /*
------------------------------------------------------------------------------------
---                             mm_cleanup
------------------------------------------------------------------------------------
-*/
+ *                             mm_cleanup
+ */
 static void __exit mm_cleanup(void)
 {
 	int i;
 
 	del_battery_timer();
 
-	for (i=0; i < num_cards ; i++) {
+	for (i = 0; i < num_cards ; i++) {
 		del_gendisk(mm_gendisk[i]);
 		put_disk(mm_gendisk[i]);
 	}
