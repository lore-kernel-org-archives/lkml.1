Return-Path: <linux-kernel-owner+w=401wt.eu-S937536AbZFPGJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937536AbZFPGJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936042AbZFPFw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:52:27 -0400
Received: from kroah.org ([198.145.64.141]:48365 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934744AbZFPFvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/64] driver core: fix gcc 4.3.3 warnings about string literals
Date: Mon, 15 Jun 2009 22:46:13 -0700
Message-Id: <1245131213-24168-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the
	warning: format not a string literal and no format arguments
warnings in the driver core that gcc 4.3.3 complains about.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c           |    4 ++--
 drivers/base/firmware_class.c |    2 +-
 drivers/base/platform.c       |    2 +-
 drivers/base/sys.c            |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7e8576d..4d59975 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -875,7 +875,7 @@ int device_add(struct device *dev)
 	 * the name, and force the use of dev_name()
 	 */
 	if (dev->init_name) {
-		dev_set_name(dev, dev->init_name);
+		dev_set_name(dev, "%s", dev->init_name);
 		dev->init_name = NULL;
 	}
 
@@ -1272,7 +1272,7 @@ struct device *__root_device_register(const char *name, struct module *owner)
 	if (!root)
 		return ERR_PTR(err);
 
-	err = dev_set_name(&root->dev, name);
+	err = dev_set_name(&root->dev, "%s", name);
 	if (err) {
 		kfree(root);
 		return ERR_PTR(err);
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 3591ba7..ddeb819 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -399,7 +399,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	fw_priv->timeout.data = (u_long) fw_priv;
 	init_timer(&fw_priv->timeout);
 
-	dev_set_name(f_dev, dev_name(device));
+	dev_set_name(f_dev, "%s", dev_name(device));
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 59df629..81cb01b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -245,7 +245,7 @@ int platform_device_add(struct platform_device *pdev)
 	if (pdev->id != -1)
 		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
 	else
-		dev_set_name(&pdev->dev, pdev->name);
+		dev_set_name(&pdev->dev, "%s", pdev->name);
 
 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 162355c..79a9ae5 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -141,7 +141,7 @@ int sysdev_class_register(struct sysdev_class *cls)
 	cls->kset.kobj.ktype = &ktype_sysdev_class;
 	cls->kset.kobj.kset = system_kset;
 
-	retval = kobject_set_name(&cls->kset.kobj, cls->name);
+	retval = kobject_set_name(&cls->kset.kobj, "%s", cls->name);
 	if (retval)
 		return retval;
 
-- 
1.6.3.2

