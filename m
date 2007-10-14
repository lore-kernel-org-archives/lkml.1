Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbXJNEqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbXJNEqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXJNEqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:46:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40287 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbXJNEqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:46:13 -0400
Date: Sun, 14 Oct 2007 05:46:09 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] uevent environment changes fallout
Message-ID: <20071014044609.GR8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 0713a8c..233d0f9 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -96,30 +96,23 @@ static int sdio_bus_match(struct device *dev, struct device_driver *drv)
 }
 
 static int
-sdio_bus_uevent(struct device *dev, char **envp, int num_envp, char *buf,
-		int buf_size)
+sdio_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
-	int i = 0, length = 0;
 
-	if (add_uevent_var(envp, num_envp, &i,
-			buf, buf_size, &length,
+	if (add_uevent_var(env,
 			"SDIO_CLASS=%02X", func->class))
 		return -ENOMEM;
 
-	if (add_uevent_var(envp, num_envp, &i,
-			buf, buf_size, &length,
+	if (add_uevent_var(env, 
 			"SDIO_ID=%04X:%04X", func->vendor, func->device))
 		return -ENOMEM;
 
-	if (add_uevent_var(envp, num_envp, &i,
-			buf, buf_size, &length,
+	if (add_uevent_var(env,
 			"MODALIAS=sdio:c%02Xv%04Xd%04X",
 			func->class, func->vendor, func->device))
 		return -ENOMEM;
 
-	envp[i] = NULL;
-
 	return 0;
 }
 
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index cfd13eb..c12a741 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -321,23 +321,17 @@ static int ssb_bus_match(struct device *dev, struct device_driver *drv)
 	return 0;
 }
 
-static int ssb_device_uevent(struct device *dev, char **envp, int num_envp,
-			     char *buffer, int buffer_size)
+static int ssb_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
-	int ret, i = 0, length = 0;
 
 	if (!dev)
 		return -ENODEV;
 
-	ret = add_uevent_var(envp, num_envp, &i,
-			     buffer, buffer_size, &length,
+	return add_uevent_var(env,
 			     "MODALIAS=ssb:v%04Xid%04Xrev%02X",
 			     ssb_dev->id.vendor, ssb_dev->id.coreid,
 			     ssb_dev->id.revision);
-	envp[i] = NULL;
-
-	return ret;
 }
 
 static struct bus_type ssb_bustype = {
