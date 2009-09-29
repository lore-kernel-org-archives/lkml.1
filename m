Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZI2RnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZI2RnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZI2RnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:43:14 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:61422 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbZI2RnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CuB/Q6cixROW1hM7Mjq6R2vA2KmU+izJZ4x1/6n/SGW+HZcOxZz4NifYjWNv/QzTSD
         IUci39wMM2rd2QjjTXCsMFRMFvOepX+4Hw4DKBdHq+j5Z5MbTax5A24ChzNxBkAv/7Gj
         c2hwSNjfRFkjMszuGrl3N6AuZS5pihCtvlGy4=
Message-ID: <4AC24741.8050205@gmail.com>
Date: Tue, 29 Sep 2009 10:43:29 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: adl_pci7296 CodingStyle cleanup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up printk's and other simple coding style issues.

Signed-off-by: Bruce Jones <brucej@linux.com>
---
 drivers/staging/comedi/drivers/adl_pci7296.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7296.c b/drivers/staging/comedi/drivers/adl_pci7296.c
index 4de6fad..8602865 100644
--- a/drivers/staging/comedi/drivers/adl_pci7296.c
+++ b/drivers/staging/comedi/drivers/adl_pci7296.c
@@ -82,8 +82,7 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 	int bus, slot;
 	int ret;
 
-	printk("comedi: attempt to attach...\n");
-	printk("comedi%d: adl_pci7432\n", dev->minor);
+	printk(KERN_INFO "comedi%d: attach adl_pci7432\n", dev->minor);
 
 	dev->board_name = "pci7432";
 	bus = it->options[0];
@@ -110,14 +109,14 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 			}
 			devpriv->pci_dev = pcidev;
 			if (comedi_pci_enable(pcidev, "adl_pci7296") < 0) {
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
 
 			/*  four 8255 digital io subdevices */
 			s = dev->subdevices + 0;
@@ -145,25 +144,25 @@ static int adl_pci7296_attach(struct comedi_device *dev,
 			if (ret < 0)
 				return ret;
 
-			printk("attached\n");
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
 
 static int adl_pci7296_detach(struct comedi_device *dev)
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
 	/*  detach four 8255 digital io subdevices */
-- 
1.6.5.rc2
