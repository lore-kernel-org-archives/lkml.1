Return-Path: <linux-kernel-owner+w=401wt.eu-S935213AbZLKXzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935213AbZLKXzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935191AbZLKXze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:55:34 -0500
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:57247 "EHLO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935181AbZLKXzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:55:33 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] sm501.c: use resource_size()
Date: Fri, 11 Dec 2009 18:55:41 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB1105@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sm501.c: use resource_size()
Thread-Index: Acp6vXHs0nURLWjpT6ysZkUtuCoM9Q==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: "Ben Dooks" <ben-linux@fluff.org>, <sameo@linux.intel.com>
X-OriginalArrivalTime: 11 Dec 2009 23:55:38.0853 (UTC) FILETIME=[70832150:01CA7ABD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The requested memory region is smaller than the actual ioremap().
Use resource_size() to get the correct size.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>

---

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 0cc5eef..dc9ea95 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1430,7 +1430,7 @@ static int __devinit sm501_plat_probe(struct platform_device *dev)
 	}
 
 	sm->regs_claim = request_mem_region(sm->io_res->start,
-					    0x100, "sm501");
+					    resource_size(sm->io_res), "sm501");
 
 	if (sm->regs_claim == NULL) {
 		dev_err(&dev->dev, "cannot claim registers\n");
@@ -1440,8 +1440,7 @@ static int __devinit sm501_plat_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, sm);
 
-	sm->regs = ioremap(sm->io_res->start,
-			   (sm->io_res->end - sm->io_res->start) - 1);
+	sm->regs = ioremap(sm->io_res->start, resource_size(sm->io_res));
 
 	if (sm->regs == NULL) {
 		dev_err(&dev->dev, "cannot remap registers\n");
@@ -1645,7 +1644,7 @@ static int __devinit sm501_pci_probe(struct pci_dev *dev,
 	sm->mem_res = &dev->resource[0];
 
 	sm->regs_claim = request_mem_region(sm->io_res->start,
-					    0x100, "sm501");
+					    resource_size(sm->io_res), "sm501");
 	if (sm->regs_claim == NULL) {
 		dev_err(&dev->dev, "cannot claim registers\n");
 		err= -EBUSY; 
