Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbZI2R4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbZI2R4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZI2R4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:56:42 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:39111 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbZI2R4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=s/pPBP5JcGgX0YVxpUDk1ANoEStYljSF6h3TmHfnkOSWMxpi+6l/peaFlsG1IZbq9V
         e38JuQcij17wiwQlndpD5FyaxvTA2BTjlHpTCXVcwrQuBzVPZ7ZM7QjuSkuO3Pdml0ZK
         mHzD0bWpCgSIQcsUx3IdFhe5k4oFDt706BSt4=
Message-ID: <4AC24A69.7050702@gmail.com>
Date: Tue, 29 Sep 2009 10:56:57 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: adl_pci7432 coding style cleanup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct coding style problems in this file.

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/adl_pci7432.c |   32 ++++++++++++-------------
 1 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index e0844c6..b5a9499 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -90,8 +90,7 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	int bus, slot;
 
-	printk("comedi: attempt to attach...\n");
-	printk("comedi%d: adl_pci7432\n", dev->minor);
+	printk(KERN_INFO "comedi%d: attach adl_pci7432\n", dev->minor);
 
 	dev->board_name = "pci7432";
 	bus = it->options[0];
@@ -118,13 +117,13 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 			}
 			devpriv->pci_dev = pcidev;
 			if (comedi_pci_enable(pcidev, "adl_pci7432") < 0) {
-				printk
-				    ("comedi%d: Failed to enable PCI device and request regions\n",
+				printk(KERN_ERR "comedi%d: Failed to enable PCI device and request regions\n",
 				     dev->minor);
 				return -EIO;
 			}
 			dev->iobase = pci_resource_start(pcidev, 2);
-			printk("comedi: base addr %4lx\n", dev->iobase);
+			printk(KERN_INFO "comedi: base addr %4lx\n",
+				dev->iobase);
 
 			s = dev->subdevices + 0;
 			s->type = COMEDI_SUBD_DI;
@@ -148,25 +147,24 @@ static int adl_pci7432_attach(struct comedi_device *dev,
 			s->range_table = &range_digital;
 			s->insn_bits = adl_pci7432_do_insn_bits;
 
-			printk("comedi: attached\n");
-
+			printk(KERN_DEBUG "comedi%d: adl_pci7432 attached\n",
+				dev->minor);
 			return 1;
 		}
 	}
 
-	printk("comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
+	printk(KERN_ERR "comedi%d: no supported board found! (req. bus/slot : %d/%d)\n",
 	       dev->minor, bus, slot);
 	return -EIO;
 }
 
 static int adl_pci7432_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: pci7432: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: pci7432: remove\n", dev->minor);
 
 	if (devpriv && devpriv->pci_dev) {
-		if (dev->iobase) {
+		if (dev->iobase)
 			comedi_pci_disable(devpriv->pci_dev);
-		}
 		pci_dev_put(devpriv->pci_dev);
 	}
 
@@ -178,8 +176,8 @@ static int adl_pci7432_do_insn_bits(struct comedi_device *dev,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
 {
-	printk("comedi: pci7432_do_insn_bits called\n");
-	printk("comedi: data0: %8x data1: %8x\n", data[0], data[1]);
+	printk(KERN_DEBUG "comedi: pci7432_do_insn_bits called\n");
+	printk(KERN_DEBUG "comedi: data0: %8x data1: %8x\n", data[0], data[1]);
 
 	if (insn->n != 2)
 		return -EINVAL;
@@ -188,7 +186,7 @@ static int adl_pci7432_do_insn_bits(struct comedi_device *dev,
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
 
-		printk("comedi: out: %8x on iobase %4lx\n", s->state,
+		printk(KERN_DEBUG "comedi: out: %8x on iobase %4lx\n", s->state,
 		       dev->iobase + PCI7432_DO);
 		outl(s->state & 0xffffffff, dev->iobase + PCI7432_DO);
 	}
@@ -200,14 +198,14 @@ static int adl_pci7432_di_insn_bits(struct comedi_device *dev,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
 {
-	printk("comedi: pci7432_di_insn_bits called\n");
-	printk("comedi: data0: %8x data1: %8x\n", data[0], data[1]);
+	printk(KERN_DEBUG "comedi: pci7432_di_insn_bits called\n");
+	printk(KERN_DEBUG "comedi: data0: %8x data1: %8x\n", data[0], data[1]);
 
 	if (insn->n != 2)
 		return -EINVAL;
 
 	data[1] = inl(dev->iobase + PCI7432_DI) & 0xffffffff;
-	printk("comedi: data1 %8x\n", data[1]);
+	printk(KERN_DEBUG "comedi: data1 %8x\n", data[1]);
 
 	return 2;
 }
-- 
1.6.5.rc2
