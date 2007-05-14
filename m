Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbXENTVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbXENTVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXENTVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:21:23 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40298 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446AbXENTVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:21:21 -0400
X-Originating-Ip: 72.143.66.196
Date: Mon, 14 May 2007 15:20:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: tglx@linutronix.de, oakad@yahoo.com, dbrownell@users.sourceforge.net
Subject: [PATCH] Remove the final usages of the "SA_" flags from the tree.
Message-ID: <Pine.LNX.4.64.0705141515200.15207@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the last two instances of the interrupt-related "SA_" flags
from the tree, but leave the support for out-of-tree modules until the
scheduled removal date of September 2007.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

 drivers/misc/tifm_7xx1.c          |    2 +-
 drivers/usb/gadget/fsl_usb2_udc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index c08ad8f..2d1b3df 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -343,7 +343,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
 	if (!fm->addr)
 		goto err_out_free;

-	rc = request_irq(dev->irq, tifm_7xx1_isr, SA_SHIRQ, DRIVER_NAME, fm);
+	rc = request_irq(dev->irq, tifm_7xx1_isr, IRQF_SHARED, DRIVER_NAME, fm);
 	if (rc)
 		goto err_out_unmap;

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 157054e..7f07a27 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -2332,7 +2332,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 		goto err2;
 	}

-	ret = request_irq(udc_controller->irq, fsl_udc_irq, SA_SHIRQ,
+	ret = request_irq(udc_controller->irq, fsl_udc_irq, IRQF_SHARED,
 			driver_name, udc_controller);
 	if (ret != 0) {
 		ERR("cannot request irq %d err %d \n",
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
