Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZI1V7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZI1V7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbZI1V7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:59:50 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:44219 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZI1V7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=stZnZX54IYbooW5DFI+5Hjq3Rtyw4o72g+1TfNAQOb4pPUO9mY1JbbAOiPHcjsk1xP
         SbFvnyGO0GKm/UnmhWMeZirN4/8sr1Qf+hp4CI4CnFyq2fzPDiu0/6p4WQrytV+5Ot0D
         K7/gs7FyaYdEjO05nXkBgPYU1IBFaKN2jKgQQ=
Message-ID: <4AC131E2.7030301@gmail.com>
Date: Mon, 28 Sep 2009 15:00:02 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: CodingStyle cleanups for drivers/adl_pci6208.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused and commented-out code.  Address basic coding
style issues.  Re-factor a deeply nested routine to conform to
line length restrictions.

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/adl_pci6208.c |  123 ++++++++------------------
 1 files changed, 38 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 8e1befc..1c25bc2 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -133,10 +133,6 @@ static int pci6208_ao_winsn(struct comedi_device *dev,
 static int pci6208_ao_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data);
-/* static int pci6208_dio_insn_bits(struct comedi_device *dev,struct comedi_subdevice *s, */
-/* struct comedi_insn *insn,unsigned int *data); */
-/* static int pci6208_dio_insn_config(struct comedi_device *dev,struct comedi_subdevice *s, */
-/* struct comedi_insn *insn,unsigned int *data); */
 
 /*
  * Attach is called by the Comedi core to configure the driver
@@ -151,7 +147,7 @@ static int pci6208_attach(struct comedi_device *dev,
 	int retval;
 	unsigned long io_base;
 
-	printk("comedi%d: pci6208: ", dev->minor);
+	printk(KERN_INFO "comedi%d: pci6208: ", dev->minor);
 
 	retval = alloc_private(dev, sizeof(struct pci6208_private));
 	if (retval < 0)
@@ -210,12 +206,11 @@ static int pci6208_attach(struct comedi_device *dev,
  */
 static int pci6208_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: pci6208: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: pci6208: remove\n", dev->minor);
 
 	if (devpriv && devpriv->pci_dev) {
-		if (dev->iobase) {
+		if (dev->iobase)
 			comedi_pci_disable(devpriv->pci_dev);
-		}
 		pci_dev_put(devpriv->pci_dev);
 	}
 
@@ -261,91 +256,50 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 	return i;
 }
 
-/* DIO devices are slightly special.  Although it is possible to
- * implement the insn_read/insn_write interface, it is much more
- * useful to applications if you implement the insn_bits interface.
- * This allows packed reading/writing of the DIO channels.  The
- * comedi core can convert between insn_bits and insn_read/write */
-/* static int pci6208_dio_insn_bits(struct comedi_device *dev,struct comedi_subdevice *s, */
-/* struct comedi_insn *insn,unsigned int *data) */
-/* { */
-/* if(insn->n!=2)return -EINVAL; */
-
-	/* The insn data is a mask in data[0] and the new data
-	 * in data[1], each channel cooresponding to a bit. */
-/* if(data[0]){ */
-/* s->state &= ~data[0]; */
-/* s->state |= data[0]&data[1]; */
-		/* Write out the new digital output lines */
-		/* outw(s->state,dev->iobase + SKEL_DIO); */
-/* } */
-
-	/* on return, data[1] contains the value of the digital
-	 * input and output lines. */
-	/* data[1]=inw(dev->iobase + SKEL_DIO); */
-	/* or we could just return the software copy of the output values if
-	 * it was a purely digital output subdevice */
-	/* data[1]=s->state; */
-
-/* return 2; */
-/* } */
-
-/* static int pci6208_dio_insn_config(struct comedi_device *dev,struct comedi_subdevice *s, */
-/* struct comedi_insn *insn,unsigned int *data) */
-/* { */
-/* int chan=CR_CHAN(insn->chanspec); */
-
-	/* The input or output configuration of each digital line is
-	 * configured by a special insn_config instruction.  chanspec
-	 * contains the channel to be changed, and data[0] contains the
-	 * value COMEDI_INPUT or COMEDI_OUTPUT. */
-
-/* if(data[0]==COMEDI_OUTPUT){ */
-/* s->io_bits |= 1<<chan; */
-/* }else{ */
-/* s->io_bits &= ~(1<<chan); */
-/* } */
-	/* outw(s->io_bits,dev->iobase + SKEL_DIO_CONFIG); */
-
-/* return 1; */
-/* } */
+
+static int pci6208_scan_board(struct pci_dev *pci_dev,
+			      struct comedi_device *dev, int bus, int slot)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(pci6208_boards); i++) {
+		if (pci6208_boards[i].dev_id == pci_dev->device) {
+			/*  was a particular bus/slot requested? */
+			if ((bus != 0) || (slot != 0)) {
+				/*  are we on the wrong bus/slot? */
+				if (pci_dev->bus->number != bus ||
+				    PCI_SLOT(pci_dev->devfn) != slot) {
+					continue;
+				}
+			}
+			return i;
+		}
+	}
+	return 0;
+}
 
 static int pci6208_find_device(struct comedi_device *dev, int bus, int slot)
 {
 	struct pci_dev *pci_dev;
-	int i;
+	int bnum;
 
 	for (pci_dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
 	     pci_dev != NULL;
 	     pci_dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pci_dev)) {
 		if (pci_dev->vendor == PCI_VENDOR_ID_ADLINK) {
-			for (i = 0; i < ARRAY_SIZE(pci6208_boards); i++) {
-				if (pci6208_boards[i].dev_id == pci_dev->device) {
-					/*  was a particular bus/slot requested? */
-					if ((bus != 0) || (slot != 0)) {
-						/*  are we on the wrong bus/slot? */
-						if (pci_dev->bus->number
-						    != bus ||
-						    PCI_SLOT(pci_dev->devfn)
-						    != slot) {
-							continue;
-						}
-					}
-					dev->board_ptr = pci6208_boards + i;
-					goto found;
-				}
+			bnum = pci6208_scan_board(pci_dev, dev, bus, slot);
+			if (bnum)
+				dev->board_ptr = pci6208_boards + bnum;
+			else {
+				printk(KERN_INFO "comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
+				       dev->minor, bus, slot);
+				return -EIO;
 			}
 		}
 	}
-
-	printk("comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
-	       dev->minor, bus, slot);
-	return -EIO;
-
-found:
-	printk("comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
+	printk(KERN_INFO "comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
 	       dev->minor,
-	       pci6208_boards[i].name,
+	       pci6208_boards[bnum].name,
 	       pci_dev->bus->number,
 	       PCI_SLOT(pci_dev->devfn),
 	       PCI_FUNC(pci_dev->devfn), pci_dev->irq);
@@ -368,23 +322,22 @@ pci6208_pci_setup(struct pci_dev *pci_dev, unsigned long *io_base_ptr,
 
 	/*  Enable PCI device and request regions */
 	if (comedi_pci_enable(pci_dev, PCI6208_DRIVER_NAME) < 0) {
-		printk
-		    ("comedi%d: Failed to enable PCI device and request regions\n",
+		printk(KERN_INFO "comedi%d: Failed to enable PCI device and request regions\n",
 		     dev_minor);
 		return -EIO;
 	}
-	/*  Read local configuration register base address [PCI_BASE_ADDRESS #1]. */
+	/*  Read local config register base address [PCI_BASE_ADDRESS #1]. */
 	lcr_io_base = pci_resource_start(pci_dev, 1);
 	lcr_io_range = pci_resource_len(pci_dev, 1);
 
-	printk("comedi%d: local config registers at address 0x%4lx [0x%4lx]\n",
+	printk(KERN_INFO "comedi%d: local config registers at address 0x%4lx [0x%4lx]\n",
 	       dev_minor, lcr_io_base, lcr_io_range);
 
 	/*  Read PCI6208 register base address [PCI_BASE_ADDRESS #2]. */
 	io_base = pci_resource_start(pci_dev, 2);
 	io_range = pci_resource_end(pci_dev, 2) - io_base + 1;
 
-	printk("comedi%d: 6208 registers at address 0x%4lx [0x%4lx]\n",
+	printk(KERN_INFO "comedi%d: 6208 registers at address 0x%4lx [0x%4lx]\n",
 	       dev_minor, io_base, io_range);
 
 	*io_base_ptr = io_base;
-- 
1.6.5.rc2
