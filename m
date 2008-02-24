Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbYBXVMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbYBXVMM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYBXVLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:11:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:6864 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbYBXVLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:11:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Cho9N+2jIKHK+/lmmCW7jRCW8hmNQpBOOeoV9rWqcBQ7qTxIwl3Uthr7OvZYNl7pS5uQSOn3E67U6PPHpaYvmIE8NUnZz4xh1uZ56DhXi6WUVFGZocw3z2lmnlU6cMO6dD1H2KRzBB8DlkPP99l4VsAAd1NUIwFGuwE417heSpU=
Date: Sun, 24 Feb 2008 22:11:44 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 3/3] IDE: Coding Style fixes to drivers/ide/pci/cy82c693.c
Message-ID: <20080224221144.1e9e7449@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 34 errors, 14 warnings, 456 lines checked

After:
total: 0 errors, 8 warnings, 456 lines checked



Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/pci/cy82c693.c |   74 ++++++++++++++++++++++----------------------
 1 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index 833fa4d..08eab7e 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -6,7 +6,7 @@
  *
  * The CY82C693 chipset is used on Digital's PC-Alpha 164SX boards.
  * Writing the driver was quite simple, since most of the job is
- * done by the generic pci-ide support. 
+ * done by the generic pci-ide support.
  * The hard part was finding the CY82C693's datasheet on Cypress's
  * web page :-(. But Altavista solved this problem :-).
  *
@@ -15,12 +15,12 @@
  * - I recently got a 16.8G IBM DTTA, so I was able to test it with
  *   a large and fast disk - the results look great, so I'd say the
  *   driver is working fine :-)
- *   hdparm -t reports 8.17 MB/sec at about 6% CPU usage for the DTTA 
- * - this is my first linux driver, so there's probably a lot  of room 
+ *   hdparm -t reports 8.17 MB/sec at about 6% CPU usage for the DTTA
+ * - this is my first linux driver, so there's probably a lot  of room
  *   for optimizations and bug fixing, so feel free to do it.
  * - use idebus=xx parameter to set PCI bus speed - needed to calc
  *   timings for PIO modes (default will be 40)
- * - if using PIO mode it's a good idea to set the PIO mode and 
+ * - if using PIO mode it's a good idea to set the PIO mode and
  *   32-bit I/O support (if possible), e.g. hdparm -p2 -c1 /dev/hda
  * - I had some problems with my IBM DHEA with PIO modes < 2
  *   (lost interrupts) ?????
@@ -110,11 +110,11 @@ typedef struct pio_clocks_s {
  * calc clocks using bus_speed
  * returns (rounded up) time in bus clocks for time in ns
  */
-static int calc_clk (int time, int bus_speed)
+static int calc_clk(int time, int bus_speed)
 {
 	int clocks;
 
-	clocks = (time*bus_speed+999)/1000 -1;
+	clocks = (time*bus_speed+999)/1000 - 1;
 
 	if (clocks < 0)
 		clocks = 0;
@@ -132,8 +132,8 @@ static int calc_clk (int time, int bus_speed)
  * NOTE: for mode 0,1 and 2 drives 8-bit IDE command control registers are used
  *       for mode 3 and 4 drives 8 and 16-bit timings are the same
  *
- */ 
-static void compute_clocks (u8 pio, pio_clocks_t *p_pclk)
+ */
+static void compute_clocks(u8 pio, pio_clocks_t *p_pclk)
 {
 	int clk1, clk2;
 	int bus_speed = system_bus_clock();	/* get speed of PCI bus */
@@ -158,7 +158,7 @@ static void compute_clocks (u8 pio, pio_clocks_t *p_pclk)
 	clk1 = (clk1<<4)|clk2;	/* combine active and recovery clocks */
 
 	/* note: we use the same values for 16bit IOR and IOW
-         *	those are all the same, since I don't have other
+	 *	those are all the same, since I don't have other
 	 *	timings than those from ide-lib.c
 	 */
 
@@ -186,7 +186,7 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 	outb(index, CY82_INDEX_PORT);
 	data = inb(CY82_DATA_PORT);
 
-	printk (KERN_INFO "%s (ch=%d, dev=%d): DMA mode is %d (single=%d)\n",
+	printk(KERN_INFO "%s (ch=%d, dev=%d): DMA mode is %d (single=%d)\n",
 		drive->name, HWIF(drive)->channel, drive->select.b.unit,
 		(data&0x3), ((data>>2)&1));
 #endif /* CY82C693_DEBUG_LOGS */
@@ -202,7 +202,7 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 		mode & 3, single);
 #endif /* CY82C693_DEBUG_INFO */
 
-	/* 
+	/*
 	 * note: below we set the value for Bus Master IDE TimeOut Register
 	 * I'm not absolutly sure what this does, but it solved my problem
 	 * with IDE DMA and sound, so I now can play sound and work with
@@ -216,8 +216,8 @@ static void cy82c693_set_dma_mode(ide_drive_t *drive, const u8 mode)
 	outb(CY82_INDEX_TIMEOUT, CY82_INDEX_PORT);
 	outb(data, CY82_DATA_PORT);
 
-#if CY82C693_DEBUG_INFO	
-	printk (KERN_INFO "%s: Set IDE Bus Master TimeOut Register to 0x%X\n",
+#if CY82C693_DEBUG_INFO
+	printk(KERN_INFO "%s: Set IDE Bus Master TimeOut Register to 0x%X\n",
 		drive->name, data);
 #endif /* CY82C693_DEBUG_INFO */
 }
@@ -242,14 +242,14 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 #if CY82C693_DEBUG_LOGS
 	/* for debug let's show the register values */
-	
-       	if (drive->select.b.unit == 0) {
+
+	if (drive->select.b.unit == 0) {
 		/*
-		 * get master drive registers               	
+		 * get master drive registers
 		 * address setup control register
 		 * is 32 bit !!!
-		 */ 
-	  	pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);                
+		 */
+		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
 		addrCtrl &= 0x0F;
 
 		/* now let's get the remaining registers */
@@ -261,7 +261,7 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		 * set slave drive registers
 		 * address setup control register
 		 * is 32 bit !!!
-		 */ 
+		 */
 		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
 
 		addrCtrl &= 0xF0;
@@ -288,9 +288,9 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		 * set master drive
 		 * address setup control register
 		 * is 32 bit !!!
-		 */ 
+		 */
 		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
-		
+
 		addrCtrl &= (~0xF);
 		addrCtrl |= (unsigned int)pclk.address_time;
 		pci_write_config_dword(dev, CY82_IDE_ADDRSETUP, addrCtrl);
@@ -299,14 +299,14 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 		pci_write_config_byte(dev, CY82_IDE_MASTER_IOR, pclk.time_16r);
 		pci_write_config_byte(dev, CY82_IDE_MASTER_IOW, pclk.time_16w);
 		pci_write_config_byte(dev, CY82_IDE_MASTER_8BIT, pclk.time_8);
-		
+
 		addrCtrl &= 0xF;
 	} else {
 		/*
 		 * set slave drive
 		 * address setup control register
 		 * is 32 bit !!!
-		 */ 
+		 */
 		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
 
 		addrCtrl &= (~0xF0);
@@ -320,7 +320,7 @@ static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
 
 		addrCtrl >>= 4;
 		addrCtrl &= 0xF;
-	}	
+	}
 
 #if CY82C693_DEBUG_INFO
 	printk(KERN_INFO "%s (ch=%d, dev=%d): set PIO timing to "
@@ -340,41 +340,41 @@ static unsigned int __devinit init_chipset_cy82c693(struct pci_dev *dev, const c
 
 #ifdef CY82C693_SETDMA_CLOCK
 	u8 data = 0;
-#endif /* CY82C693_SETDMA_CLOCK */ 
+#endif /* CY82C693_SETDMA_CLOCK */
 
 	/* write info about this verion of the driver */
 	printk(KERN_INFO CY82_VERSION "\n");
 
 #ifdef CY82C693_SETDMA_CLOCK
        /* okay let's set the DMA clock speed */
-        
-        outb(CY82_INDEX_CTRLREG1, CY82_INDEX_PORT);
-        data = inb(CY82_DATA_PORT);
+
+	outb(CY82_INDEX_CTRLREG1, CY82_INDEX_PORT);
+	data = inb(CY82_DATA_PORT);
 
 #if CY82C693_DEBUG_INFO
 	printk(KERN_INFO "%s: Peripheral Configuration Register: 0x%X\n",
 		name, data);
 #endif /* CY82C693_DEBUG_INFO */
 
-        /*
+	/*
 	 * for some reason sometimes the DMA controller
 	 * speed is set to ATCLK/2 ???? - we fix this here
-	 * 
+	 *
 	 * note: i don't know what causes this strange behaviour,
 	 *       but even changing the dma speed doesn't solve it :-(
-	 *       the ide performance is still only half the normal speed 
-	 * 
+	 *       the ide performance is still only half the normal speed
+	 *
 	 *       if anybody knows what goes wrong with my machine, please
 	 *       let me know - ASK
-         */
+	 */
 
 	data |= 0x03;
 
-        outb(CY82_INDEX_CTRLREG1, CY82_INDEX_PORT);
-        outb(data, CY82_DATA_PORT);
+	outb(CY82_INDEX_CTRLREG1, CY82_INDEX_PORT);
+	outb(data, CY82_DATA_PORT);
 
 #if CY82C693_DEBUG_INFO
-	printk (KERN_INFO "%s: New Peripheral Configuration Register: 0x%X\n",
+	printk(KERN_INFO "%s: New Peripheral Configuration Register: 0x%X\n",
 		name, data);
 #endif /* CY82C693_DEBUG_INFO */
 
@@ -423,7 +423,7 @@ static int __devinit cy82c693_init_one(struct pci_dev *dev, const struct pci_dev
 
 	/* CY82C693 is more than only a IDE controller.
 	   Function 1 is primary IDE channel, function 2 - secondary. */
-        if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
+	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE &&
 	    PCI_FUNC(dev->devfn) == 1) {
 		dev2 = pci_get_slot(dev->bus, dev->devfn + 1);
 		ret = ide_setup_pci_devices(dev, dev2, &cy82c693_chipset);
-- 
1.5.4.2.316.gf7a7

