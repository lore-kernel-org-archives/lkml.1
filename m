Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbZDWOcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbZDWOcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZDWOcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:32:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:11398 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZDWOb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eNMsj1TB0nt6mzY+Vya1xPrA04WJKtATwwIQ1BC9cbOcWYF9EZdYXmIkG3PnMAHvkr
         CDmLoQwS7AkJFJABJM39YxJ0K3vrqGOcypUQtPoVDvcnkCuVIF48Duj0UT0OJQfrb+gG
         szvVFuAvbuyri3u0GCdWiPg2Cj95+JxIagsVM=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core:firmware_class:replace kfree(dev) with put_device(dev)
Date: Thu, 23 Apr 2009 22:31:52 +0800
Message-Id: <1240497112-4667-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

against v2.6.30-rc3-next tree.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/firmware_class.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index f19afa8..d186149 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -356,7 +356,7 @@ static void fw_dev_release(struct device *dev)
 		__free_page(fw_priv->pages[i]);
 	kfree(fw_priv->pages);
 	kfree(fw_priv);
-	kfree(dev);
+	put_device(dev);
 
 	module_put(THIS_MODULE);
 }
@@ -400,14 +400,16 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	retval = device_register(f_dev);
 	if (retval) {
 		dev_err(device, "%s: device_register failed\n", __func__);
-		goto error_kfree;
+		put_device(f_dev);
+		goto error_kfree1;
 	}
 	*dev_p = f_dev;
 	return 0;
 
 error_kfree:
-	kfree(fw_priv);
 	kfree(f_dev);
+error_kfree1:
+	kfree(fw_priv);
 	return retval;
 }
 
-- 
1.6.0.GIT

