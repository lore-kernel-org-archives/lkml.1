Return-Path: <linux-kernel-owner+w=401wt.eu-S932970AbZLNXWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbZLNXWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932959AbZLNXWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:22:44 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:58933 "EHLO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbZLNXWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:22:42 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] ehci-au1xxx.c: use platform_get_resource() and resource_size()
Date: Mon, 14 Dec 2009 18:22:42 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EAAA@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ehci-au1xxx.c: use platform_get_resource() and resource_size()
Thread-Index: Acp9FFWuqLpx23XwQbiwZNmsQbEdCA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 23:22:40.0001 (UTC) FILETIME=[54438710:01CA7D14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use platform_get_resource() to fetch the memory resource and
resource_size() for calculate the length.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---

diff --git a/drivers/usb/host/ehci-au1xxx.c b/drivers/usb/host/ehci-au1xxx.c
index ed77be7..987e1ed 100644
--- a/drivers/usb/host/ehci-au1xxx.c
+++ b/drivers/usb/host/ehci-au1xxx.c
@@ -121,6 +121,7 @@ static int ehci_hcd_au1xxx_drv_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd;
 	struct ehci_hcd *ehci;
+	struct resource *res;
 	int ret;
 
 	if (usb_disabled())
@@ -144,8 +145,9 @@ static int ehci_hcd_au1xxx_drv_probe(struct platform_device *pdev)
 	if (!hcd)
 		return -ENOMEM;
 
-	hcd->rsrc_start = pdev->resource[0].start;
-	hcd->rsrc_len = pdev->resource[0].end - pdev->resource[0].start + 1;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		pr_debug("request_mem_region failed"); 
