Return-Path: <linux-kernel-owner+w=401wt.eu-S1762167AbZLKB3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762167AbZLKB3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762054AbZLKB3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:29:48 -0500
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:34563 "EHLO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761999AbZLKB3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:29:47 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] at_hdmac.c: use resource_size()
Date: Thu, 10 Dec 2009 20:29:52 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB0FC1@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] at_hdmac.c: use resource_size()
Thread-Index: Acp6AW/oPj5CFYEfTji0kyuh7cRvqA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <nicolas.ferre@atmel.com>
X-OriginalArrivalTime: 11 Dec 2009 01:29:53.0833 (UTC) FILETIME=[70BAD990:01CA7A01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
---

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index c52ac9e..e16057b 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1012,7 +1012,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	atdma->dma_common.cap_mask = pdata->cap_mask;
 	atdma->all_chan_mask = (1 << pdata->nr_channels) - 1;
 
-	size = io->end - io->start + 1;
+	size = resource_size(io);
 	if (!request_mem_region(io->start, size, pdev->dev.driver->name)) {
 		err = -EBUSY;
 		goto err_kfree; 
