Return-Path: <linux-kernel-owner+w=401wt.eu-S932636AbZLNXEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbZLNXEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbZLNXEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:04:51 -0500
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:45605 "EHLO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691AbZLNXEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:04:50 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2009 18:04:49 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] atmel_usba_udc.c: use resource_size()
Date: Mon, 14 Dec 2009 18:04:49 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA9D@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] atmel_usba_udc.c: use resource_size()
Thread-Index: Acp9EdZJE3ynzNfoR3yYW2sXDU+/Bw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Cc: <haavard.skinnemoen@atmel.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 14 Dec 2009 23:04:47.0731 (UTC) FILETIME=[D5241C30:01CA7D11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 4e970cf..976822f 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1914,14 +1914,14 @@ static int __init usba_udc_probe(struct platform_device *pdev)
 	udc->vbus_pin = -ENODEV;
 
 	ret = -ENOMEM;
-	udc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	udc->regs = ioremap(regs->start, resource_size(regs));
 	if (!udc->regs) {
 		dev_err(&pdev->dev, "Unable to map I/O memory, aborting.\n");
 		goto err_map_regs;
 	}
 	dev_info(&pdev->dev, "MMIO registers at 0x%08lx mapped at %p\n",
 		 (unsigned long)regs->start, udc->regs);
-	udc->fifo = ioremap(fifo->start, fifo->end - fifo->start + 1);
+	udc->fifo = ioremap(fifo->start, resource_size(fifo));
 	if (!udc->fifo) {
 		dev_err(&pdev->dev, "Unable to map FIFO, aborting.\n");
 		goto err_map_fifo; 
