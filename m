Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZLKQwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZLKQwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZLKQwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:52:32 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:51763 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZLKQwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:52:31 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] mpc85xx_edac.c: use resource_size()
Date: Fri, 11 Dec 2009 11:52:36 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB1038@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mpc85xx_edac.c: use resource_size()
Thread-Index: Acp6glcq9VaWvFhSQ924lB5spiRPOw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <dougthompson@xmission.com>, <djiang@mvista.com>
X-OriginalArrivalTime: 11 Dec 2009 16:52:36.0768 (UTC) FILETIME=[579C5200:01CA7A82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Dave Jiang <djiang@mvista.com>

---

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index cf27402..adecf37 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -239,16 +239,15 @@ static int __devinit mpc85xx_pci_err_probe(struct of_device *op,
 	/* we only need the error registers */
 	r.start += 0xe00;
 
-	if (!devm_request_mem_region(&op->dev, r.start,
-					r.end - r.start + 1, pdata->name)) {
+	if (!devm_request_mem_region(&op->dev, r.start, resource_size(&r),
+					pdata->name)) {
 		printk(KERN_ERR "%s: Error while requesting mem region\n",
 		       __func__);
 		res = -EBUSY;
 		goto err;
 	}
 
-	pdata->pci_vbase = devm_ioremap(&op->dev, r.start,
-					r.end - r.start + 1);
+	pdata->pci_vbase = devm_ioremap(&op->dev, r.start, resource_size(&r));
 	if (!pdata->pci_vbase) {
 		printk(KERN_ERR "%s: Unable to setup PCI err regs\n", __func__);
 		res = -ENOMEM; 
