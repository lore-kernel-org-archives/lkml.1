Return-Path: <linux-kernel-owner+w=401wt.eu-S933615AbZFPFwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbZFPFwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761097AbZFPFuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:50:54 -0400
Received: from kroah.org ([198.145.64.141]:48298 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbZFPFux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:53 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/64] driver core: firmware_class: replace kfree(dev) with put_device(dev)
Date: Mon, 15 Jun 2009 22:45:54 -0700
Message-Id: <1245131213-24168-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

against v2.6.30-rc3-next tree.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8a267c4..2d296b7 100644
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
1.6.3.2

