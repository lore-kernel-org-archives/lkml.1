Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab0CEMDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:03:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:63889 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab0CEMDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:03:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=ofRnzbYy0Kph0/AfNyWFpTjPJRxOST5qzm4rXsH9P0j919V0MzCtKCE6QP4WfuNr7H
         nSANtGcPyU/fqANNK+dRzjW1hYT85lGV6HV6A8exzGO/q6aRnG9r/IyqNWqdCBDfBZ7k
         2Umk2goB9c3GGCdzy2PblDZiyGDS8/PXfNJVQ=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] Staging: comedi: fix brace and printk() coding style issues in adl_pci9111.c
Date: Fri,  5 Mar 2010 12:03:02 +0000
Message-Id: <1267790582-11840-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to the adl_pci9111.c file that fixes brace warnings and, printk() should include Kern_facility level warnings, found by the checkpatch.pl tool

Signed-off-by Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   36 ++++++++++++-------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 340950d..e2092a8 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1085,9 +1085,8 @@ static int pci9111_ai_insn_read(struct comedi_device *dev,
 
 	pci9111_ai_channel_set(CR_CHAN((&insn->chanspec)[0]));
 
-	if ((pci9111_ai_range_get()) != CR_RANGE((&insn->chanspec)[0])) {
+	if ((pci9111_ai_range_get()) != CR_RANGE((&insn->chanspec)[0]))
 		pci9111_ai_range_set(CR_RANGE((&insn->chanspec)[0]));
-	}
 
 	pci9111_fifo_reset();
 
@@ -1108,11 +1107,10 @@ static int pci9111_ai_insn_read(struct comedi_device *dev,
 
 conversion_done:
 
-		if (resolution == PCI9111_HR_AI_RESOLUTION) {
+		if (resolution == PCI9111_HR_AI_RESOLUTION)
 			data[i] = pci9111_hr_ai_get_data();
-		} else {
+		else
 			data[i] = pci9111_ai_get_data();
-		}
 	}
 
 #ifdef AI_INSN_DEBUG
@@ -1149,9 +1147,8 @@ static int pci9111_ao_insn_read(struct comedi_device *dev,
 {
 	int i;
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = dev_private->ao_readback & PCI9111_AO_RESOLUTION_MASK;
-	}
 
 	return i;
 }
@@ -1240,12 +1237,13 @@ static int pci9111_attach(struct comedi_device *dev,
 	int error, i;
 	const struct pci9111_board *board;
 
-	if (alloc_private(dev, sizeof(struct pci9111_private_data)) < 0) {
+	if (alloc_private(dev, sizeof(struct pci9111_private_data)) < 0)
 		return -ENOMEM;
-	}
+
 	/*  Probe the device to determine what device in the series it is. */
 
-	printk("comedi%d: " PCI9111_DRIVER_NAME " driver\n", dev->minor);
+	printk(KERN_ERR "comedi%d: " PCI9111_DRIVER_NAME " driver\n",
+								dev->minor);
 
 	for (pci_device = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
 	     pci_device != NULL;
@@ -1278,13 +1276,14 @@ static int pci9111_attach(struct comedi_device *dev,
 		}
 	}
 
-	printk("comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
+	printk(KERN_ERR "comedi%d: no supported board found! "
+						"(req. bus/slot : %d/%d)\n",
 	       dev->minor, it->options[0], it->options[1]);
 	return -EIO;
 
 found:
 
-	printk("comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
+	printk(KERN_ERR "comedi%d: found %s (b:s:f=%d:%d:%d) , irq=%d\n",
 	       dev->minor,
 	       pci9111_boards[i].name,
 	       pci_device->bus->number,
@@ -1320,7 +1319,7 @@ found:
 	io_base = pci_resource_start(pci_device, 2);
 	io_range = pci_resource_len(pci_device, 2);
 
-	printk("comedi%d: 6503 registers at address 0x%4lx [0x%4lx]\n",
+	printk(KERN_ERR "comedi%d: 6503 registers at address 0x%4lx [0x%4lx]\n",
 	       dev->minor, io_base, io_range);
 
 	dev->iobase = io_base;
@@ -1338,7 +1337,8 @@ found:
 	if (pci_device->irq > 0) {
 		if (request_irq(pci_device->irq, pci9111_interrupt,
 				IRQF_SHARED, PCI9111_DRIVER_NAME, dev) != 0) {
-			printk("comedi%d: unable to allocate irq  %u\n",
+			printk(KERN_ERR "comedi%d: "
+						"unable to allocate irq  %u\n",
 			       dev->minor, pci_device->irq);
 			return -EINVAL;
 		}
@@ -1415,15 +1415,13 @@ static int pci9111_detach(struct comedi_device *dev)
 	}
 	/*  Release previously allocated irq */
 
-	if (dev->irq != 0) {
+	if (dev->irq != 0)
 		free_irq(dev->irq, dev);
-	}
 
 	if (dev_private != 0 && dev_private->pci_device != 0) {
-		if (dev->iobase) {
+		if (dev->iobase)
 			comedi_pci_disable(dev_private->pci_device);
-		}
-		pci_dev_put(dev_private->pci_device);
+			pci_dev_put(dev_private->pci_device);
 	}
 
 	return 0;
-- 
1.6.3.3

