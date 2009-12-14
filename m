Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbZLNW7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbZLNW7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbZLNW7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:59:23 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:51049 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757960AbZLNW7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:59:22 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] at91_udc.c: use resource_size()
Date: Mon, 14 Dec 2009 17:59:22 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA9B@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] at91_udc.c: use resource_size()
Thread-Index: Acp9ERMIWIIpbTr+Q+Oj7TdvaIvEMg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 14 Dec 2009 22:59:19.0920 (UTC) FILETIME=[11C01F00:01CA7D11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 043e04d..12ac9cd 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1656,9 +1656,7 @@ static int __init at91udc_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENXIO;
 
-	if (!request_mem_region(res->start,
-			res->end - res->start + 1,
-			driver_name)) {
+	if (!request_mem_region(res->start, resource_size(res), driver_name)) {
 		DBG("someone's using UDC memory\n");
 		return -EBUSY;
 	}
@@ -1699,7 +1697,7 @@ static int __init at91udc_probe(struct platform_device *pdev)
 		udc->ep[3].maxpacket = 64;
 	}
 
-	udc->udp_baseaddr = ioremap(res->start, res->end - res->start + 1);
+	udc->udp_baseaddr = ioremap(res->start, resource_size(res));
 	if (!udc->udp_baseaddr) {
 		retval = -ENOMEM;
 		goto fail0a;
@@ -1781,7 +1779,7 @@ fail0a:
 	if (cpu_is_at91rm9200())
 		gpio_free(udc->board.pullup_pin);
 fail0:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	DBG("%s probe failed, %d\n", driver_name, retval);
 	return retval;
 }
@@ -1813,7 +1811,7 @@ static int __exit at91udc_remove(struct platform_device *pdev)
 		gpio_free(udc->board.pullup_pin);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	clk_put(udc->iclk);
 	clk_put(udc->fclk); 
