Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbZJUQuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbZJUQuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZJUQuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:50:08 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50905 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbZJUQuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KRL7QQ3BwkZ4GtenqFfQAetsku1dypFoqL7orjYfJJSSzZH7BopsawPeekcHQnf8sC
         19YxQ21ts7/4AsFhqmZZ2Z/H3BIhp1JhZeNNJG/UYG6SZJdGzo/d74ugzbvWqlZ4vcMD
         xnQfoWe2CBKdfrOVgOIM3eA8ot92YYLK5HHLg=
From: "BRAGA, Bruno" <bruno.braga@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "BRAGA, Bruno" <bruno.braga@gmail.com>
Subject: [PATCH 1/1] Stating driver comedi adl_pci8164 coding style fix
Date: Thu, 22 Oct 2009 01:50:04 +0900
Message-Id: <1256143804-9842-1-git-send-email-bruno.braga@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected coding style:
- excessive curly braces
- printk without KERN_* logging
- 80+ chars per line of code

Signed-off-by: BRAGA, Bruno <bruno.braga@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci8164.c |   39 +++++++++++++------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c b/drivers/staging/comedi/drivers/adl_pci8164.c
index 43745ec..eb67195 100644
--- a/drivers/staging/comedi/drivers/adl_pci8164.c
+++ b/drivers/staging/comedi/drivers/adl_pci8164.c
@@ -25,7 +25,7 @@ Description: Driver for the Adlink PCI-8164 4 Axes Motion Control board
 Devices: [ADLink] PCI-8164 (adl_pci8164)
 Author: Michel Lachaine <mike@mikelachaine.ca>
 Status: experimental
-Updated: Mon, 14 Apr 2008 15:10:32 +0100
+Updated: Wed, 21 Oct 2009 22:47 +0900

 Configuration Options:
   [0] - PCI bus of device (optional)
@@ -35,6 +35,7 @@ Configuration Options:
 */

 #include "../comedidev.h"
+#include <linux/kernel.h>
 #include <linux/delay.h>
 #include "comedi_fc.h"
 #include "comedi_pci.h"
@@ -128,8 +129,8 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	int bus, slot;

-	printk("comedi: attempt to attach...\n");
-	printk("comedi%d: adl_pci8164\n", dev->minor);
+	printk(KERN_INFO "comedi: attempt to attach...\n");
+	printk(KERN_INFO "comedi%d: adl_pci8164\n", dev->minor);

 	dev->board_name = "pci8164";
 	bus = it->options[0];
@@ -150,19 +151,18 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 			if (bus || slot) {
 				/* requested particular bus/slot */
 				if (pcidev->bus->number != bus
-				    || PCI_SLOT(pcidev->devfn) != slot) {
+					|| PCI_SLOT(pcidev->devfn) != slot)
 					continue;
-				}
 			}
 			devpriv->pci_dev = pcidev;
 			if (comedi_pci_enable(pcidev, "adl_pci8164") < 0) {
-				printk
-				    ("comedi%d: Failed to enable PCI device and request regions\n",
-				     dev->minor);
+				printk(KERN_ERR "comedi%d: Failed to enable "
+				"PCI device and request regions\n", dev->minor);
 				return -EIO;
 			}
 			dev->iobase = pci_resource_start(pcidev, 2);
-			printk("comedi: base addr %4lx\n", dev->iobase);
+			printk(KERN_DEBUG "comedi: base addr %4lx\n",
+				   dev->iobase);

 			s = dev->subdevices + 0;
 			s->type = COMEDI_SUBD_PROC;
@@ -204,25 +204,24 @@ static int adl_pci8164_attach(struct comedi_device *dev,
 			s->insn_read = adl_pci8164_insn_read_buf1;
 			s->insn_write = adl_pci8164_insn_write_buf1;

-			printk("comedi: attached\n");
+			printk(KERN_INFO "comedi: attached\n");

 			return 1;
 		}
 	}

-	printk("comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
-	       dev->minor, bus, slot);
+	printk(KERN_ERR "comedi%d: no supported board found!"
+		   "(req. bus/slot : %d/%d)\n", dev->minor, bus, slot);
 	return -EIO;
 }

 static int adl_pci8164_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: pci8164: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: pci8164: remove\n", dev->minor);

 	if (devpriv && devpriv->pci_dev) {
-		if (dev->iobase) {
+		if (dev->iobase)
 			comedi_pci_disable(devpriv->pci_dev);
-		}
 		pci_dev_put(devpriv->pci_dev);
 	}

@@ -267,8 +266,9 @@ static void adl_pci8164_insn_read(struct comedi_device *dev,
 	}

 	data[0] = inw(dev->iobase + axis_reg + offset);
-	printk("comedi: pci8164 %s read -> %04X:%04X on axis %s\n", action,
-	       data[0], data[1], axisname);
+	printk(KERN_DEBUG "comedi: pci8164 %s read -> "
+						  "%04X:%04X on axis %s\n",
+				action, data[0], data[1], axisname);
 }

 static int adl_pci8164_insn_read_msts(struct comedi_device *dev,
@@ -347,8 +347,9 @@ static void adl_pci8164_insn_out(struct comedi_device *dev,

 	outw(data[0], dev->iobase + axis_reg + offset);

-	printk("comedi: pci8164 %s write -> %04X:%04X on axis %s\n", action,
-	       data[0], data[1], axisname);
+	printk(KERN_DEBUG "comedi: pci8164 %s write -> "
+						"%04X:%04X on axis %s\n",
+				action, data[0], data[1], axisname);

 }

--
1.6.0.4

