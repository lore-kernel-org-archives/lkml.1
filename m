Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbYD3WEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbYD3WEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932364AbYD3WDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:03:30 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:1024 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765914AbYD3WD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:03:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DKml2UmfuGeG9MzPRWQRpnQ09vEcKmJofsK3aAoTmcIIHWwL2DQ6eSwWyg2ErxHb5fc+/SDbY9Wik9wF04CsrAKZu7qwUdTpvnQwg8j+b9/0PqwamB7Tn3EAK7HDHiAeBL2K/Z4xE7V0W3h+6e0w1yuWoNyd810f5cAmGaA76NI=
Subject: [PATCH 03/10] usb: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 15:03:41 -0700
Message-Id: <1209593021.24729.113.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/host/ohci-sm501.c:93:24: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3254:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3267:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3277:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3285:9: warning: Using plain integer as NULL pointer
drivers/usb/gadget/amd5536udc.c:3293:9: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/usb/gadget/amd5536udc.c |   10 +++++-----
 drivers/usb/host/ohci-sm501.c   |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index ce337cb..f261d2a 100644
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
diff --git a/drivers/usb/host/ohci-sm501.c b/drivers/usb/host/ohci-sm501.c
index 77204f0..e899a77 100644
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -90,7 +90,7 @@ static int ohci_hcd_sm501_drv_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct resource	*res, *mem;
 	int retval, irq;
-	struct usb_hcd *hcd = 0;
+	struct usb_hcd *hcd = NULL;
 
 	irq = retval = platform_get_irq(pdev, 0);
 	if (retval < 0)
-- 
1.5.5.1.305.g7c84


