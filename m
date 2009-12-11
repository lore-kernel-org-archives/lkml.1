Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbZLKB4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbZLKB4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbZLKB4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:56:34 -0500
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:53900 "EHLO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbZLKB4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:56:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] iop-adma.c: use resource_size()
Date: Thu, 10 Dec 2009 20:56:38 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB0FD0@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] iop-adma.c: use resource_size()
Thread-Index: Acp6BS1tjGwjQRVjRh2l/fgq0x1XNw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <dan.j.williams@intel.com>
X-OriginalArrivalTime: 11 Dec 2009 01:56:39.0942 (UTC) FILETIME=[2E0BA260:01CA7A05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the requested and ioremaped memory is off by 1.
Use resource_size() to get the correct value.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Dan Williams <dan.j.williams@intel.com>

---

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 645ca8d..ca6e6a0 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -1470,7 +1470,7 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if (!devm_request_mem_region(&pdev->dev, res->start,
-				res->end - res->start, pdev->name))
+				resource_size(res), pdev->name))
 		return -EBUSY;
 
 	adev = kzalloc(sizeof(*adev), GFP_KERNEL);
@@ -1542,7 +1542,7 @@ static int __devinit iop_adma_probe(struct platform_device *pdev)
 	iop_chan->device = adev;
 
 	iop_chan->mmr_base = devm_ioremap(&pdev->dev, res->start,
-					res->end - res->start);
+					resource_size(res));
 	if (!iop_chan->mmr_base) {
 		ret = -ENOMEM;
 		goto err_free_iop_chan; 
