Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbZLNXPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbZLNXPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932925AbZLNXPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:15:38 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:59412 "EHLO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbZLNXPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:15:35 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] ehci-atmel.c: use resource_size()
Date: Mon, 14 Dec 2009 18:15:35 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EAA6@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ehci-atmel.c: use resource_size()
Thread-Index: Acp9E1cuOxGxMUp/QhCOq/Cll5z3Dw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 14 Dec 2009 23:15:33.0138 (UTC) FILETIME=[55D56720:01CA7D13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---

diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 87c1b7c..51bd0ed 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -149,7 +149,7 @@ static int __init ehci_atmel_drv_probe(struct platform_device *pdev)
 		goto fail_request_resource;
 	}
 	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = res->end - res->start + 1;
+	hcd->rsrc_len = resource_size(res);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
 				driver->description)) { 
