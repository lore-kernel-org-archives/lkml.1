Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbZDRSxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbZDRSxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759279AbZDRSwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:52:31 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:59950 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZDRSw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:52:27 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC 02/16] m68k: amiga - Zorro bus modalias support
Date: Sat, 18 Apr 2009 20:52:10 +0200
Message-Id: <1240080744-14995-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240080744-14995-2-git-send-email-geert@linux-m68k.org>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-2-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/a2065.c             |    1 +
 drivers/net/ariadne.c           |    1 +
 drivers/net/hydra.c             |    1 +
 drivers/net/zorro8390.c         |    1 +
 drivers/scsi/zorro7xx.c         |    1 +
 drivers/video/cirrusfb.c        |    1 +
 drivers/video/fm2fb.c           |    1 +
 drivers/zorro/zorro-driver.c    |   24 ++++++++++++++++++++++++
 drivers/zorro/zorro-sysfs.c     |   11 +++++++++++
 include/linux/mod_devicetable.h |    9 +++++++++
 include/linux/zorro.h           |   13 +------------
 scripts/mod/file2alias.c        |   14 ++++++++++++++
 12 files changed, 66 insertions(+), 12 deletions(-)

diff --git a/drivers/net/a2065.c b/drivers/net/a2065.c
index 02f64d5..6619069 100644
--- a/drivers/net/a2065.c
+++ b/drivers/net/a2065.c
@@ -684,6 +684,7 @@ static struct zorro_device_id a2065_zorro_tbl[] __devinitdata = {
 	{ ZORRO_PROD_AMERISTAR_A2065 },
 	{ 0 }
 };
+MODULE_DEVICE_TABLE(zorro, a2065_zorro_tbl);
 
 static struct zorro_driver a2065_driver = {
 	.name		= "a2065",
diff --git a/drivers/net/ariadne.c b/drivers/net/ariadne.c
index 58e8d52..74ad89d 100644
--- a/drivers/net/ariadne.c
+++ b/drivers/net/ariadne.c
@@ -147,6 +147,7 @@ static struct zorro_device_id ariadne_zorro_tbl[] __devinitdata = {
     { ZORRO_PROD_VILLAGE_TRONIC_ARIADNE },
     { 0 }
 };
+MODULE_DEVICE_TABLE(zorro, ariadne_zorro_tbl);
 
 static struct zorro_driver ariadne_driver = {
     .name	= "ariadne",
diff --git a/drivers/net/hydra.c b/drivers/net/hydra.c
index 8ac0930..358d8ce 100644
--- a/drivers/net/hydra.c
+++ b/drivers/net/hydra.c
@@ -72,6 +72,7 @@ static struct zorro_device_id hydra_zorro_tbl[] __devinitdata = {
     { ZORRO_PROD_HYDRA_SYSTEMS_AMIGANET },
     { 0 }
 };
+MODULE_DEVICE_TABLE(zorro, hydra_zorro_tbl);
 
 static struct zorro_driver hydra_driver = {
     .name	= "hydra",
diff --git a/drivers/net/zorro8390.c b/drivers/net/zorro8390.c
index 37c84e3..d7755a9 100644
--- a/drivers/net/zorro8390.c
+++ b/drivers/net/zorro8390.c
@@ -102,6 +102,7 @@ static struct zorro_device_id zorro8390_zorro_tbl[] __devinitdata = {
     { ZORRO_PROD_INDIVIDUAL_COMPUTERS_X_SURF, },
     { 0 }
 };
+MODULE_DEVICE_TABLE(zorro, zorro8390_zorro_tbl);
 
 static struct zorro_driver zorro8390_driver = {
     .name	= "zorro8390",
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 64d40a2..b416fa4 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -68,6 +68,7 @@ static struct zorro_device_id zorro7xx_zorro_tbl[] __devinitdata = {
 	},
 	{ 0 }
 };
+MODULE_DEVICE_TABLE(zorro, zorro7xx_zorro_tbl);
 
 static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 				       const struct zorro_device_id *ent)
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 4c2bf92..dc5d201 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -300,6 +300,7 @@ static const struct zorro_device_id cirrusfb_zorro_table[] = {
 	},
 	{ 0 }
 };
+MODULE_DEVICE_TABLE(zorro, cirrusfb_zorro_table);
 
 static const struct {
 	zorro_id id2;
diff --git a/drivers/video/fm2fb.c b/drivers/video/fm2fb.c
index 6c91c61..1b0feb8 100644
--- a/drivers/video/fm2fb.c
+++ b/drivers/video/fm2fb.c
@@ -219,6 +219,7 @@ static struct zorro_device_id fm2fb_devices[] __devinitdata = {
 	{ ZORRO_PROD_HELFRICH_RAINBOW_II },
 	{ 0 }
 };
+MODULE_DEVICE_TABLE(zorro, fm2fb_devices);
 
 static struct zorro_driver fm2fb_driver = {
 	.name		= "fm2fb",
diff --git a/drivers/zorro/zorro-driver.c b/drivers/zorro/zorro-driver.c
index e6c4390..409244b 100644
--- a/drivers/zorro/zorro-driver.c
+++ b/drivers/zorro/zorro-driver.c
@@ -137,10 +137,34 @@ static int zorro_bus_match(struct device *dev, struct device_driver *drv)
 	return 0;
 }
 
+static int zorro_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+#ifdef CONFIG_HOTPLUG
+	struct zorro_dev *z;
+
+	if (!dev)
+		return -ENODEV;
+
+	z = to_zorro_dev(dev);
+	if (!z)
+		return -ENODEV;
+
+	if (add_uevent_var(env, "ZORRO_ID=%08X", z->id) ||
+	    add_uevent_var(env, "ZORRO_SLOT_NAME=%s", dev_name(dev)) ||
+	    add_uevent_var(env, "ZORRO_SLOT_ADDR=%04X", z->slotaddr) ||
+	    add_uevent_var(env, "MODALIAS=" ZORRO_DEVICE_MODALIAS_FMT, z->id))
+		return -ENOMEM;
+
+	return 0;
+#else /* !CONFIG_HOTPLUG */
+	return -ENODEV;
+#endif /* !CONFIG_HOTPLUG */
+}
 
 struct bus_type zorro_bus_type = {
 	.name	= "zorro",
 	.match	= zorro_bus_match,
+	.uevent	= zorro_uevent,
 	.probe	= zorro_device_probe,
 	.remove	= zorro_device_remove,
 };
diff --git a/drivers/zorro/zorro-sysfs.c b/drivers/zorro/zorro-sysfs.c
index 1d2a772..26dff20 100644
--- a/drivers/zorro/zorro-sysfs.c
+++ b/drivers/zorro/zorro-sysfs.c
@@ -49,6 +49,16 @@ static ssize_t zorro_show_resource(struct device *dev, struct device_attribute *
 
 static DEVICE_ATTR(resource, S_IRUGO, zorro_show_resource, NULL);
 
+static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct zorro_dev *z = to_zorro_dev(dev);
+
+	return sprintf(buf, ZORRO_DEVICE_MODALIAS_FMT "\n", z->id);
+}
+
+static DEVICE_ATTR(modalias, S_IRUGO, modalias_show, NULL);
+
 static ssize_t zorro_read_config(struct kobject *kobj,
 				 struct bin_attribute *bin_attr,
 				 char *buf, loff_t off, size_t count)
@@ -89,6 +99,7 @@ int zorro_create_sysfs_dev_files(struct zorro_dev *z)
 	    (error = device_create_file(dev, &dev_attr_slotaddr)) ||
 	    (error = device_create_file(dev, &dev_attr_slotsize)) ||
 	    (error = device_create_file(dev, &dev_attr_resource)) ||
+	    (error = device_create_file(dev, &dev_attr_modalias)) ||
 	    (error = sysfs_create_bin_file(&dev->kobj, &zorro_config_attr)))
 		return error;
 
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 1bf5900..a31cf4f 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -463,4 +463,13 @@ struct platform_device_id {
 			__attribute__((aligned(sizeof(kernel_ulong_t))));
 };
 
+struct zorro_device_id {
+	__u32 id;			/* Device ID or ZORRO_WILDCARD */
+	kernel_ulong_t driver_data;	/* Data private to the driver */
+};
+
+#define ZORRO_WILDCARD			(0xffffffff)	/* not official */
+
+#define ZORRO_DEVICE_MODALIAS_FMT	"zorro:i%08X"
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/linux/zorro.h b/include/linux/zorro.h
index 913bfc2..908db1b 100644
--- a/include/linux/zorro.h
+++ b/include/linux/zorro.h
@@ -38,8 +38,6 @@
 typedef __u32 zorro_id;
 
 
-#define ZORRO_WILDCARD		(0xffffffff)	/* not official */
-
 /* Include the ID list */
 #include <linux/zorro_ids.h>
 
@@ -116,6 +114,7 @@ struct ConfigDev {
 
 #include <linux/init.h>
 #include <linux/ioport.h>
+#include <linux/mod_devicetable.h>
 
 #include <asm/zorro.h>
 
@@ -155,16 +154,6 @@ extern struct bus_type zorro_bus_type;
 
 
     /*
-     *  Zorro device IDs
-     */
-
-struct zorro_device_id {
-	zorro_id id;			/* Device ID or ZORRO_WILDCARD */
-	unsigned long driver_data;	/* Data private to the driver */
-};
-
-
-    /*
      *  Zorro device drivers
      */
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index a334428..633af66 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -718,6 +718,16 @@ static int do_platform_entry(const char *filename,
 	return 1;
 }
 
+/* Looks like: zorro:iN. */
+static int do_zorro_entry(const char *filename, struct zorro_device_id *id,
+			  char *alias)
+{
+	id->id = TO_NATIVE(id->id);
+	strcpy(alias, "zorro:");
+	ADD(alias, "i", id->id != ZORRO_WILDCARD, id->id);
+	return 1;
+}
+
 /* Ignore any prefix, eg. some architectures prepend _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -861,6 +871,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct platform_device_id), "platform",
 			 do_platform_entry, mod);
+	else if (sym_is(symname, "__mod_zorro_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct zorro_device_id), "zorro",
+			 do_zorro_entry, mod);
 	free(zeros);
 }
 
-- 
1.6.2.3

