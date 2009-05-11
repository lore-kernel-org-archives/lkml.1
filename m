Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbZEKU0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbZEKU0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbZEKUZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:25:12 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:39493 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbZEKUZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=fwIANj6eV53ckjivhUhrJaywFxUVMHmFPanAyx5+KP4ae4iz2T1dlGxpVIkvabPFv0
         EXqGtmTpPqJ0GiQMz6V0bfKnhN0W/hnY2RWlos2vzDUH+Gix7nyl75z5F9Mqcr9viZiN
         udy/xLhkvhW4we297BCsomCvxSUbSPQMrEtDw=
Message-ID: <4A0889A3.8020803@gmail.com>
Date: Mon, 11 May 2009 22:25:07 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: hnguyen@de.ibm.com
CC: general@lists.openfabrics.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ehca: remove driver_data direct access of struct device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid direct access to the driver_data pointer in struct device, the
functions dev_get_drvdata() and dev_set_drvdata() should be used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 368311c..5acfb4c 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -749,7 +749,7 @@ static int __devinit ehca_probe(struct of_device *dev,
 
 	shca->ofdev = dev;
 	shca->ipz_hca_handle.handle = *handle;
-	dev->dev.driver_data = shca;
+	dev_set_drvdata(&dev->dev, shca);
 
 	ret = ehca_sense_attributes(shca);
 	if (ret < 0) {
@@ -878,7 +878,7 @@ probe1:
 
 static int __devexit ehca_remove(struct of_device *dev)
 {
-	struct ehca_shca *shca = dev->dev.driver_data;
+	struct ehca_shca *shca = dev_get_drvdata(&dev->dev);
 	unsigned long flags;
 	int ret;
 
