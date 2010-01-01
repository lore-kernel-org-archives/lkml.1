Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055Ab0AAVmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab0AAVmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 16:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797Ab0AAVmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 16:42:50 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:37089 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0AAVmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 16:42:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZbLkM5R7o5WGgQw4nVXo4JtB3+MRZQe4/Rb8Hdcqs5GRc3xbrDKpQ+TTKT4lXp6wmM
         uvjXtB581W0IAkuq6GsU61U13GRSH/RjvaSVfmIjG0dgS0JA2nN3itKHDCw2utfCQoUO
         FdzUidCjq+hgmyC2ktHyC8J6kpmhUP3zgZa7I=
From: Thiago Farina <tfransosi@gmail.com>
To: linux@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Greg Kroah-Hartman <gregkh@suse.de>,
       Thiago Farina <tfransosi@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] usb: use resource_size().
Date: Fri,  1 Jan 2010 16:42:34 -0500
Message-Id: <1262382155-10534-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/usb/c67x00/c67x00-drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/c67x00/c67x00-drv.c b/drivers/usb/c67x00/c67x00-drv.c
index 5633bc5..029ee4a 100644
--- a/drivers/usb/c67x00/c67x00-drv.c
+++ b/drivers/usb/c67x00/c67x00-drv.c
@@ -137,13 +137,13 @@ static int __devinit c67x00_drv_probe(struct platform_device *pdev)
 	if (!c67x00)
 		return -ENOMEM;
 
-	if (!request_mem_region(res->start, res->end - res->start + 1,
+	if (!request_mem_region(res->start, resource_size(res),
 				pdev->name)) {
 		dev_err(&pdev->dev, "Memory region busy\n");
 		ret = -EBUSY;
 		goto request_mem_failed;
 	}
-	c67x00->hpi.base = ioremap(res->start, res->end - res->start + 1);
+	c67x00->hpi.base = ioremap(res->start, resource_size(res));
 	if (!c67x00->hpi.base) {
 		dev_err(&pdev->dev, "Unable to map HPI registers\n");
 		ret = -EIO;
@@ -182,7 +182,7 @@ static int __devinit c67x00_drv_probe(struct platform_device *pdev)
  request_irq_failed:
 	iounmap(c67x00->hpi.base);
  map_failed:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
  request_mem_failed:
 	kfree(c67x00);
 
@@ -208,7 +208,7 @@ static int __devexit c67x00_drv_remove(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res)
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 
 	kfree(c67x00);
 
-- 
1.6.6.rc3

