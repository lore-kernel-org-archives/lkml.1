Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbZLNTKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbZLNTKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbZLNTK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:10:29 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:44551 "EHLO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbZLNTK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:10:28 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] at91_mci.c: use resource_size()
Date: Mon, 14 Dec 2009 14:10:26 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200E9E8@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] at91_mci.c: use resource_size()
Thread-Index: Acp88Rf0UvfrgxmlRju7bKbt6WJ7aA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
X-OriginalArrivalTime: 14 Dec 2009 19:10:26.0520 (UTC) FILETIME=[18019580:01CA7CF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 63924e0..05a3fb4 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -992,7 +992,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENXIO;
 
-	if (!request_mem_region(res->start, res->end - res->start + 1, DRIVER_NAME))
+	if (!request_mem_region(res->start, resource_size(res), DRIVER_NAME))
 		return -EBUSY;
 
 	mmc = mmc_alloc_host(sizeof(struct at91mci_host), &pdev->dev);
@@ -1063,7 +1063,7 @@ static int __init at91_mci_probe(struct platform_device *pdev)
 	/*
 	 * Map I/O region
 	 */
-	host->baseaddr = ioremap(res->start, res->end - res->start + 1);
+	host->baseaddr = ioremap(res->start, resource_size(res));
 	if (!host->baseaddr) {
 		ret = -ENOMEM;
 		goto fail1;
@@ -1135,7 +1135,7 @@ fail4:
 fail5:
 	mmc_free_host(mmc);
 fail6:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	dev_err(&pdev->dev, "probe failed, err %d\n", ret);
 	return ret;
 }
@@ -1176,7 +1176,7 @@ static int __exit at91_mci_remove(struct platform_device *pdev)
 
 	iounmap(host->baseaddr);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	mmc_free_host(mmc);
 	platform_set_drvdata(pdev, NULL); 
