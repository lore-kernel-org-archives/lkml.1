Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZLNXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZLNXFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758727AbZLNXFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:05:07 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:56436 "EHLO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689AbZLNXFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:05:05 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] pxa27x_udc.c: use resource_size()
Date: Mon, 14 Dec 2009 18:05:02 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA9E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] pxa27x_udc.c: use resource_size()
Thread-Index: Acp9Ed4JGLJAbd9FR1CgygshhBbaHw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       "Robert Jarzmik" <robert.jarzmik@free.fr>
X-OriginalArrivalTime: 14 Dec 2009 23:05:00.0482 (UTC) FILETIME=[DCBDC220:01CA7D11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>

---

diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index adda120..72c89d9 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -2439,7 +2439,7 @@ static int __init pxa_udc_probe(struct platform_device *pdev)
 	}
 
 	retval = -ENOMEM;
-	udc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	udc->regs = ioremap(regs->start, resource_size(regs));
 	if (!udc->regs) {
 		dev_err(&pdev->dev, "Unable to map UDC I/O memory\n");
 		goto err_map; 
