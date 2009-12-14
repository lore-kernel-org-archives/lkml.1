Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbZLNXNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbZLNXNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758754AbZLNXNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:13:02 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:55512 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758753AbZLNXNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:13:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] ehci-orion.c: use resource_size()
Date: Mon, 14 Dec 2009 18:13:00 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EAA5@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ehci-orion.c: use resource_size()
Thread-Index: Acp9EvqY0UQC8BBsQ+O14VwErFdFmQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 14 Dec 2009 23:12:58.0785 (UTC) FILETIME=[F9D50110:01CA7D12]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---

diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 1d283e1..0f87dc7 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -222,14 +222,14 @@ static int __devinit ehci_orion_drv_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	if (!request_mem_region(res->start, res->end - res->start + 1,
+	if (!request_mem_region(res->start, resource_size(res),
 				ehci_orion_hc_driver.description)) {
 		dev_dbg(&pdev->dev, "controller already in use\n");
 		err = -EBUSY;
 		goto err1;
 	}
 
-	regs = ioremap(res->start, res->end - res->start + 1);
+	regs = ioremap(res->start, resource_size(res));
 	if (regs == NULL) {
 		dev_dbg(&pdev->dev, "error mapping memory\n");
 		err = -EFAULT;
@@ -244,7 +244,7 @@ static int __devinit ehci_orion_drv_probe(struct platform_device *pdev)
 	}
 
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
 
 	ehci = hcd_to_ehci(hcd);
@@ -287,7 +287,7 @@ err4:
 err3:
 	iounmap(regs);
 err2:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 err1:
 	dev_err(&pdev->dev, "init %s fail, %d\n",
 		dev_name(&pdev->dev), err); 
