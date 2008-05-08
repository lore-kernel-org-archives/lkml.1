Return-Path: <linux-kernel-owner+w=401wt.eu-S933932AbYEHWlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbYEHWlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758981AbYEHWl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:41:26 -0400
Received: from mx1.suse.de ([195.135.220.2]:32827 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYEHWlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:41:25 -0400
Subject: patch usb-fix-integer-as-null-pointer-warnings-found-by-sparse.patch added to gregkh-2.6 tree
To: harvey.harrison@gmail.com, akpm@linux-foundation.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 08 May 2008 15:38:36 -0700
In-Reply-To: <1209593021.24729.113.camel@brick>
Message-ID: <12102863161565@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: usb: fix integer as NULL pointer warnings found by sparse

to my gregkh-2.6 tree.  Its filename is

     usb-fix-integer-as-null-pointer-warnings-found-by-sparse.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From harvey.harrison@gmail.com Wed Apr 30 15:03:34 2008
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Wed, 30 Apr 2008 15:03:41 -0700
Subject: usb: fix integer as NULL pointer warnings found by sparse
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <1209593021.24729.113.camel@brick>


drivers/usb/host/ohci-sm501.c:93:24: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3254:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3267:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3277:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3285:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3293:9: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/amd5536udc.c |   10 +++++-----
 drivers/usb/host/ohci-sm501.c   |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -3251,7 +3251,7 @@ static int udc_pci_probe(
 	/* pci setup */
 	if (pci_enable_device(pdev) < 0) {
 		kfree(dev);
-		dev = 0;
+		dev = NULL;
 		retval = -ENODEV;
 		goto finished;
 	}
@@ -3264,7 +3264,7 @@ static int udc_pci_probe(
 	if (!request_mem_region(resource, len, name)) {
 		dev_dbg(&pdev->dev, "pci device used already\n");
 		kfree(dev);
-		dev = 0;
+		dev = NULL;
 		retval = -EBUSY;
 		goto finished;
 	}
@@ -3274,7 +3274,7 @@ static int udc_pci_probe(
 	if (dev->virt_addr == NULL) {
 		dev_dbg(&pdev->dev, "start address cannot be mapped\n");
 		kfree(dev);
-		dev = 0;
+		dev = NULL;
 		retval = -EFAULT;
 		goto finished;
 	}
@@ -3282,7 +3282,7 @@ static int udc_pci_probe(
 	if (!pdev->irq) {
 		dev_err(&dev->pdev->dev, "irq not set\n");
 		kfree(dev);
-		dev = 0;
+		dev = NULL;
 		retval = -ENODEV;
 		goto finished;
 	}
@@ -3290,7 +3290,7 @@ static int udc_pci_probe(
 	if (request_irq(pdev->irq, udc_irq, IRQF_SHARED, name, dev) != 0) {
 		dev_dbg(&dev->pdev->dev, "request_irq(%d) fail\n", pdev->irq);
 		kfree(dev);
-		dev = 0;
+		dev = NULL;
 		retval = -EBUSY;
 		goto finished;
 	}
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -90,7 +90,7 @@ static int ohci_hcd_sm501_drv_probe(stru
 	struct device *dev = &pdev->dev;
 	struct resource	*res, *mem;
 	int retval, irq;
-	struct usb_hcd *hcd = 0;
+	struct usb_hcd *hcd = NULL;
 
 	irq = retval = platform_get_irq(pdev, 0);
 	if (retval < 0)


Patches currently in gregkh-2.6 which might be from harvey.harrison@gmail.com are

usb.next/usb-fix-integer-as-null-pointer-warnings-found-by-sparse.patch
usb.next/usb-use-get_unaligned_-helpers-for-kl5kusb105-driver.patch
