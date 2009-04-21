Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbZDUBLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbZDUBLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbZDUBLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:11:23 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:45818 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661AbZDUBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:11:21 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, gregkh@suse.de, kay.sievers@vrfy.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 2/4] driver core: use string format when name is given to an exported function
Date: Mon, 20 Apr 2009 21:17:14 -0300
Message-Id: <9027a3b74e49f79b7138880e2cffd9bc2947ca21.1240272929.git.cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <2289cd3dcbe25046472d90cd0b25e57fbef92dc1.1240272929.git.cascardo@holoscopio.com>
References: <1240273036-5995-1-git-send-email-cascardo@holoscopio.com>
 <2289cd3dcbe25046472d90cd0b25e57fbef92dc1.1240272929.git.cascardo@holoscopio.com>
In-Reply-To: <cover.1240272928.git.cascardo@holoscopio.com>
References: <cover.1240272928.git.cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many functions that are directly or indirectly exported use a given name
as parameter (or as a member of a struct parameter) as the format when
setting the device's name. Using the string specification format avoids
a possible NULL dereference in some cases and a invalid format
processing in other cases. These are easily done since the functions are
exported and some module or driver could give a NULL or a string format
as a name.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 arch/microblaze/kernel/of_device.c  |    2 +-
 arch/powerpc/kernel/of_device.c     |    2 +-
 drivers/base/core.c                 |    4 ++--
 drivers/base/platform.c             |    2 +-
 drivers/isdn/mISDN/dsp_pipeline.c   |    2 +-
 drivers/misc/enclosure.c            |    4 ++--
 drivers/video/backlight/backlight.c |    2 +-
 drivers/video/backlight/lcd.c       |    2 +-
 drivers/video/output.c              |    2 +-
 fs/partitions/check.c               |    2 +-
 10 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/microblaze/kernel/of_device.c b/arch/microblaze/kernel/of_device.c
index 9a0f763..deebaec 100644
--- a/arch/microblaze/kernel/of_device.c
+++ b/arch/microblaze/kernel/of_device.c
@@ -56,7 +56,7 @@ struct of_device *of_device_alloc(struct device_node *np,
 	dev->dev.archdata.of_node = np;
 
 	if (bus_id)
-		dev_set_name(&dev->dev, bus_id);
+		dev_set_name(&dev->dev, "%s", bus_id);
 	else
 		of_device_make_bus_id(dev);
 
diff --git a/arch/powerpc/kernel/of_device.c b/arch/powerpc/kernel/of_device.c
index fa983a5..a359cb0 100644
--- a/arch/powerpc/kernel/of_device.c
+++ b/arch/powerpc/kernel/of_device.c
@@ -76,7 +76,7 @@ struct of_device *of_device_alloc(struct device_node *np,
 	dev->dev.archdata.of_node = np;
 
 	if (bus_id)
-		dev_set_name(&dev->dev, bus_id);
+		dev_set_name(&dev->dev, "%s", bus_id);
 	else
 		of_device_make_bus_id(dev);
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index d230ff4..d54eef4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -874,7 +874,7 @@ int device_add(struct device *dev)
 	 * the name, and force the use of dev_name()
 	 */
 	if (dev->init_name) {
-		dev_set_name(dev, dev->init_name);
+		dev_set_name(dev, "%s", dev->init_name);
 		dev->init_name = NULL;
 	}
 
@@ -1267,7 +1267,7 @@ struct device *__root_device_register(const char *name, struct module *owner)
 	if (!root)
 		return ERR_PTR(err);
 
-	err = dev_set_name(&root->dev, name);
+	err = dev_set_name(&root->dev, "%s", name);
 	if (err) {
 		kfree(root);
 		return ERR_PTR(err);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index b5b6c97..ec0f436 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -245,7 +245,7 @@ int platform_device_add(struct platform_device *pdev)
 	if (pdev->id != -1)
 		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
 	else
-		dev_set_name(&pdev->dev, pdev->name);
+		dev_set_name(&pdev->dev, "%s", pdev->name);
 
 	/* We will remove platform_data field from struct device
 	* if all platform devices pass its platform specific data
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index 18cf87c..0b51eb0 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -101,7 +101,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	entry->dev.class = elements_class;
 	entry->dev.release = mISDN_dsp_dev_release;
 	dev_set_drvdata(&entry->dev, elem);
-	dev_set_name(&entry->dev, elem->name);
+	dev_set_name(&entry->dev, "%s", elem->name);
 	ret = device_register(&entry->dev);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to register %s\n",
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 3cf61ec..74a78d4 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -119,7 +119,7 @@ enclosure_register(struct device *dev, const char *name, int components,
 	edev->edev.class = &enclosure_class;
 	edev->edev.parent = get_device(dev);
 	edev->cb = cb;
-	dev_set_name(&edev->edev, name);
+	dev_set_name(&edev->edev, "%s", name);
 	err = device_register(&edev->edev);
 	if (err)
 		goto err;
@@ -256,7 +256,7 @@ enclosure_component_register(struct enclosure_device *edev,
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
 	if (name)
-		dev_set_name(cdev, name);
+		dev_set_name(cdev, "%s", name);
 	else
 		dev_set_name(cdev, "%u", number);
 
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 157057c..71d65fb 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -244,7 +244,7 @@ struct backlight_device *backlight_device_register(const char *name,
 	new_bd->dev.class = backlight_class;
 	new_bd->dev.parent = parent;
 	new_bd->dev.release = bl_device_release;
-	dev_set_name(&new_bd->dev, name);
+	dev_set_name(&new_bd->dev, "%s", name);
 	dev_set_drvdata(&new_bd->dev, devdata);
 
 	rc = device_register(&new_bd->dev);
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index b644947..306ba00 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -208,7 +208,7 @@ struct lcd_device *lcd_device_register(const char *name, struct device *parent,
 	new_ld->dev.class = lcd_class;
 	new_ld->dev.parent = parent;
 	new_ld->dev.release = lcd_device_release;
-	dev_set_name(&new_ld->dev, name);
+	dev_set_name(&new_ld->dev, "%s", name);
 	dev_set_drvdata(&new_ld->dev, devdata);
 
 	rc = device_register(&new_ld->dev);
diff --git a/drivers/video/output.c b/drivers/video/output.c
index 5e6439a..82a5bb5 100644
--- a/drivers/video/output.c
+++ b/drivers/video/output.c
@@ -96,7 +96,7 @@ struct output_device *video_output_register(const char *name,
 	new_dev->props = op;
 	new_dev->dev.class = &video_output_class;
 	new_dev->dev.parent = dev;
-	dev_set_name(&new_dev->dev, name);
+	dev_set_name(&new_dev->dev, "%s", name);
 	dev_set_drvdata(&new_dev->dev, devdata);
 	ret_code = device_register(&new_dev->dev);
 	if (ret_code) {
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 99e33ef..a89b37e 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -456,7 +456,7 @@ void register_disk(struct gendisk *disk)
 
 	ddev->parent = disk->driverfs_dev;
 
-	dev_set_name(ddev, disk->disk_name);
+	dev_set_name(ddev, "%s", disk->disk_name);
 
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
-- 
1.6.2.3

