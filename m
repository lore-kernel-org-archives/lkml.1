Return-Path: <linux-kernel-owner+w=401wt.eu-S935990AbXHHFdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935990AbXHHFdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 01:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932094AbXHHFcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 01:32:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:58631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762111AbXHHFcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 01:32:00 -0400
Message-Id: <20070808053026.385116000@suse.de>
References: <20070808052842.451400000@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 07 Aug 2007 22:28:46 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Kay Sievers <kay.sievers@vrfy.org>
Subject: [patch 4/6] Convert from class_device to device for hwmon users
Content-Disposition: inline; filename=hwmon_users.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from class_device to device for users of 
hwmon_device_register/unregister

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

---
 drivers/hwmon/abituguru.c           |   10 +++++-----
 drivers/hwmon/abituguru3.c          |   10 +++++-----
 drivers/hwmon/ad7418.c              |   10 +++++-----
 drivers/hwmon/adm1021.c             |   10 +++++-----
 drivers/hwmon/adm1025.c             |   10 +++++-----
 drivers/hwmon/adm1026.c             |   10 +++++-----
 drivers/hwmon/adm1029.c             |   10 +++++-----
 drivers/hwmon/adm1031.c             |   10 +++++-----
 drivers/hwmon/adm9240.c             |   10 +++++-----
 drivers/hwmon/applesmc.c            |   10 +++++-----
 drivers/hwmon/asb100.c              |   10 +++++-----
 drivers/hwmon/atxp1.c               |   10 +++++-----
 drivers/hwmon/coretemp.c            |   10 +++++-----
 drivers/hwmon/dme1737.c             |   10 +++++-----
 drivers/hwmon/ds1621.c              |   10 +++++-----
 drivers/hwmon/f71805f.c             |   10 +++++-----
 drivers/hwmon/fscher.c              |   10 +++++-----
 drivers/hwmon/fscpos.c              |   10 +++++-----
 drivers/hwmon/gl518sm.c             |   10 +++++-----
 drivers/hwmon/gl520sm.c             |   10 +++++-----
 drivers/hwmon/it87.c                |   10 +++++-----
 drivers/hwmon/k8temp.c              |   10 +++++-----
 drivers/hwmon/lm63.c                |   10 +++++-----
 drivers/hwmon/lm70.c                |   12 ++++++------
 drivers/hwmon/lm75.c                |   10 +++++-----
 drivers/hwmon/lm77.c                |   10 +++++-----
 drivers/hwmon/lm78.c                |   18 +++++++++---------
 drivers/hwmon/lm80.c                |   10 +++++-----
 drivers/hwmon/lm83.c                |   10 +++++-----
 drivers/hwmon/lm85.c                |   10 +++++-----
 drivers/hwmon/lm87.c                |   10 +++++-----
 drivers/hwmon/lm90.c                |   10 +++++-----
 drivers/hwmon/lm92.c                |   10 +++++-----
 drivers/hwmon/lm93.c                |   10 +++++-----
 drivers/hwmon/max1619.c             |   10 +++++-----
 drivers/hwmon/max6650.c             |   10 +++++-----
 drivers/hwmon/pc87360.c             |   10 +++++-----
 drivers/hwmon/pc87427.c             |   10 +++++-----
 drivers/hwmon/sis5595.c             |   10 +++++-----
 drivers/hwmon/smsc47b397.c          |   10 +++++-----
 drivers/hwmon/smsc47m1.c            |   10 +++++-----
 drivers/hwmon/smsc47m192.c          |   10 +++++-----
 drivers/hwmon/via686a.c             |   10 +++++-----
 drivers/hwmon/vt1211.c              |   10 +++++-----
 drivers/hwmon/vt8231.c              |   10 +++++-----
 drivers/hwmon/w83627ehf.c           |   10 +++++-----
 drivers/hwmon/w83627hf.c            |   10 +++++-----
 drivers/hwmon/w83781d.c             |   18 +++++++++---------
 drivers/hwmon/w83791d.c             |   10 +++++-----
 drivers/hwmon/w83792d.c             |   10 +++++-----
 drivers/hwmon/w83793.c              |   10 +++++-----
 drivers/hwmon/w83l785ts.c           |   10 +++++-----
 drivers/input/touchscreen/ads7846.c |    4 ++--
 drivers/misc/thinkpad_acpi.c        |    2 +-
 drivers/misc/thinkpad_acpi.h        |    2 +-
 55 files changed, 273 insertions(+), 273 deletions(-)

--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -124,7 +124,7 @@ struct abituguru3_motherboard_info {
    The structure is dynamically allocated, at the same time when a new
    abituguru3 device is allocated. */
 struct abituguru3_data {
-	struct class_device *class_dev; /* hwmon registered device */
+	struct device *hwmon_dev;	/* hwmon registered device */
 	struct mutex update_lock;	/* protect access to data and uGuru */
 	unsigned short addr;		/* uguru base address */
 	char valid;			/* !=0 if following fields are valid */
@@ -933,9 +933,9 @@ static int __devinit abituguru3_probe(st
 				&abituguru3_sysfs_attr[i].dev_attr))
 			goto abituguru3_probe_error;
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->class_dev)) {
-		res = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		res = PTR_ERR(data->hwmon_dev);
 		goto abituguru3_probe_error;
 	}
 
@@ -957,7 +957,7 @@ static int __devexit abituguru3_remove(s
 	struct abituguru3_data *data = platform_get_drvdata(pdev);
 
 	platform_set_drvdata(pdev, NULL);
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	for (i = 0; data->sysfs_attr[i].dev_attr.attr.name; i++)
 		device_remove_file(&pdev->dev, &data->sysfs_attr[i].dev_attr);
 	for (i = 0; i < ARRAY_SIZE(abituguru3_sysfs_attr); i++)
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -176,7 +176,7 @@ MODULE_PARM_DESC(verbose, "How verbose s
    The structure is dynamically allocated, at the same time when a new
    abituguru device is allocated. */
 struct abituguru_data {
-	struct class_device *class_dev; /* hwmon registered device */
+	struct device *hwmon_dev;	/* hwmon registered device */
 	struct mutex update_lock;	/* protect access to data and uGuru */
 	unsigned long last_updated;	/* In jiffies */
 	unsigned short addr;		/* uguru base address */
@@ -1287,11 +1287,11 @@ static int __devinit abituguru_probe(str
 				&abituguru_sysfs_attr[i].dev_attr))
 			goto abituguru_probe_error;
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (!IS_ERR(data->class_dev))
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (!IS_ERR(data->hwmon_dev))
 		return 0; /* success */
 
-	res = PTR_ERR(data->class_dev);
+	res = PTR_ERR(data->hwmon_dev);
 abituguru_probe_error:
 	for (i = 0; data->sysfs_attr[i].dev_attr.attr.name; i++)
 		device_remove_file(&pdev->dev, &data->sysfs_attr[i].dev_attr);
@@ -1308,7 +1308,7 @@ static int __devexit abituguru_remove(st
 	int i;
 	struct abituguru_data *data = platform_get_drvdata(pdev);
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	for (i = 0; data->sysfs_attr[i].dev_attr.attr.name; i++)
 		device_remove_file(&pdev->dev, &data->sysfs_attr[i].dev_attr);
 	for (i = 0; i < ARRAY_SIZE(abituguru_sysfs_attr); i++)
--- a/drivers/hwmon/ad7418.c
+++ b/drivers/hwmon/ad7418.c
@@ -47,7 +47,7 @@ static const u8 AD7418_REG_TEMP[] = { AD
 
 struct ad7418_data {
 	struct i2c_client	client;
-	struct class_device	*class_dev;
+	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
 	enum chips		type;
 	struct mutex		lock;
@@ -326,9 +326,9 @@ static int ad7418_detect(struct i2c_adap
 	if ((err = sysfs_create_group(&client->dev.kobj, &data->attrs)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -347,7 +347,7 @@ exit:
 static int ad7418_detach_client(struct i2c_client *client)
 {
 	struct ad7418_data *data = i2c_get_clientdata(client);
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &data->attrs);
 	i2c_detach_client(client);
 	kfree(data);
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -90,7 +90,7 @@ clearing it.  Weird, ey?   --Phil  */
 /* Each client has this additional data */
 struct adm1021_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	enum chips type;
 
 	struct mutex update_lock;
@@ -305,9 +305,9 @@ static int adm1021_detect(struct i2c_ada
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &adm1021_group)))
 		goto error2;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto error3;
 	}
 
@@ -337,7 +337,7 @@ static int adm1021_detach_client(struct 
 	struct adm1021_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm1021_group);
 
 	if ((err = i2c_detach_client(client)))
--- a/drivers/hwmon/adm1025.c
+++ b/drivers/hwmon/adm1025.c
@@ -133,7 +133,7 @@ static struct i2c_driver adm1025_driver 
 
 struct adm1025_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -472,9 +472,9 @@ static int adm1025_detect(struct i2c_ada
 			goto exit_remove;
 	}
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -538,7 +538,7 @@ static int adm1025_detach_client(struct 
 	struct adm1025_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm1025_group);
 	sysfs_remove_group(&client->dev.kobj, &adm1025_group_opt);
 
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -260,7 +260,7 @@ struct pwm_data {
 
 struct adm1026_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	enum chips type;
 
 	struct mutex update_lock;
@@ -1676,9 +1676,9 @@ static int adm1026_detect(struct i2c_ada
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &adm1026_group)))
 		goto exitdetach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exitremove;
 	}
 
@@ -1698,7 +1698,7 @@ exit:
 static int adm1026_detach_client(struct i2c_client *client)
 {
 	struct adm1026_data *data = i2c_get_clientdata(client);
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm1026_group);
 	i2c_detach_client(client);
 	kfree(data);
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -141,7 +141,7 @@ static struct i2c_driver adm1029_driver 
 
 struct adm1029_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;		/* zero until following fields are valid */
 	unsigned long last_updated;	/* in jiffies */
@@ -391,9 +391,9 @@ static int adm1029_detect(struct i2c_ada
 	if ((err = sysfs_create_group(&client->dev.kobj, &adm1029_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -431,7 +431,7 @@ static int adm1029_detach_client(struct 
 	struct adm1029_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm1029_group);
 
 	if ((err = i2c_detach_client(client)))
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -70,7 +70,7 @@ typedef u8 auto_chan_table_t[8][2];
 /* Each client has this additional data */
 struct adm1031_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	int chip_type;
 	char valid;		/* !=0 if following fields are valid */
@@ -853,9 +853,9 @@ static int adm1031_detect(struct i2c_ada
 			goto exit_remove;
 	}
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -877,7 +877,7 @@ static int adm1031_detach_client(struct 
 	struct adm1031_data *data = i2c_get_clientdata(client);
 	int ret;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm1031_group);
 	sysfs_remove_group(&client->dev.kobj, &adm1031_group_opt);
 	if ((ret = i2c_detach_client(client)) != 0) {
--- a/drivers/hwmon/adm9240.c
+++ b/drivers/hwmon/adm9240.c
@@ -150,7 +150,7 @@ static struct i2c_driver adm9240_driver 
 struct adm9240_data {
 	enum chips type;
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;
 	unsigned long last_updated_measure;
@@ -590,9 +590,9 @@ static int adm9240_detect(struct i2c_ada
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &adm9240_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -620,7 +620,7 @@ static int adm9240_detach_client(struct 
 	struct adm9240_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &adm9240_group);
 
 	if ((err = i2c_detach_client(client)))
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -127,7 +127,7 @@ static s16 rest_x;
 static s16 rest_y;
 static struct timer_list applesmc_timer;
 static struct input_dev *applesmc_idev;
-static struct class_device *hwmon_class_dev;
+static struct device *hwmon_dev;
 
 /* Indicates whether this computer has an accelerometer. */
 static unsigned int applesmc_accelerometer;
@@ -1287,9 +1287,9 @@ static int __init applesmc_init(void)
 			goto out_light_wq;
 	}
 
-	hwmon_class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(hwmon_class_dev)) {
-		ret = PTR_ERR(hwmon_class_dev);
+	hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(hwmon_dev)) {
+		ret = PTR_ERR(hwmon_dev);
 		goto out_light_ledclass;
 	}
 
@@ -1331,7 +1331,7 @@ out:
 
 static void __exit applesmc_exit(void)
 {
-	hwmon_device_unregister(hwmon_class_dev);
+	hwmon_device_unregister(hwmon_dev);
 	if (applesmc_light) {
 		led_classdev_unregister(&applesmc_backlight);
 		destroy_workqueue(applesmc_led_wq);
--- a/drivers/hwmon/asb100.c
+++ b/drivers/hwmon/asb100.c
@@ -182,7 +182,7 @@ static u8 DIV_TO_REG(long val)
    dynamically allocated, at the same time the client itself is allocated. */
 struct asb100_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex lock;
 	enum chips type;
 
@@ -844,9 +844,9 @@ static int asb100_detect(struct i2c_adap
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &asb100_group)))
 		goto ERROR3;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR4;
 	}
 
@@ -874,7 +874,7 @@ static int asb100_detach_client(struct i
 
 	/* main client */
 	if (data) {
-		hwmon_device_unregister(data->class_dev);
+		hwmon_device_unregister(data->hwmon_dev);
 		sysfs_remove_group(&client->dev.kobj, &asb100_group);
 	}
 
--- a/drivers/hwmon/atxp1.c
+++ b/drivers/hwmon/atxp1.c
@@ -61,7 +61,7 @@ static struct i2c_driver atxp1_driver = 
 
 struct atxp1_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	unsigned long last_updated;
 	u8 valid;
@@ -335,9 +335,9 @@ static int atxp1_detect(struct i2c_adapt
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &atxp1_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -361,7 +361,7 @@ static int atxp1_detach_client(struct i2
 	struct atxp1_data * data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &atxp1_group);
 
 	err = i2c_detach_client(client);
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -47,7 +47,7 @@ typedef enum { SHOW_TEMP, SHOW_TJMAX, SH
 static struct coretemp_data *coretemp_update_device(struct device *dev);
 
 struct coretemp_data {
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	const char *name;
 	u32 id;
@@ -228,9 +228,9 @@ static int __devinit coretemp_probe(stru
 	if ((err = sysfs_create_group(&pdev->dev.kobj, &coretemp_group)))
 		goto exit_free;
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		dev_err(&pdev->dev, "Class registration failed (%d)\n",
 			err);
 		goto exit_class;
@@ -250,7 +250,7 @@ static int __devexit coretemp_remove(str
 {
 	struct coretemp_data *data = platform_get_drvdata(pdev);
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &coretemp_group);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
--- a/drivers/hwmon/dme1737.c
+++ b/drivers/hwmon/dme1737.c
@@ -155,7 +155,7 @@ static const u8 DME1737_BIT_ALARM_FAN[] 
 
 struct dme1737_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 
 	struct mutex update_lock;
 	int valid;			/* !=0 if following fields are valid */
@@ -1983,9 +1983,9 @@ static int dme1737_detect(struct i2c_ada
 	}
 
 	/* Register device */
-	data->class_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -2030,7 +2030,7 @@ static int dme1737_detach_client(struct 
 	struct dme1737_data *data = i2c_get_clientdata(client);
 	int ix, err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 
 	for (ix = 0; ix < ARRAY_SIZE(dme1737_fan_group); ix++) {
 		if (data->has_fan & (1 << ix)) {
--- a/drivers/hwmon/ds1621.c
+++ b/drivers/hwmon/ds1621.c
@@ -73,7 +73,7 @@ static const u8 DS1621_REG_TEMP[3] = {
 /* Each client has this additional data */
 struct ds1621_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;			/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
@@ -266,9 +266,9 @@ static int ds1621_detect(struct i2c_adap
 	if ((err = sysfs_create_group(&client->dev.kobj, &ds1621_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -289,7 +289,7 @@ static int ds1621_detach_client(struct i
 	struct ds1621_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &ds1621_group);
 
 	if ((err = i2c_detach_client(client)))
--- a/drivers/hwmon/f71805f.c
+++ b/drivers/hwmon/f71805f.c
@@ -159,7 +159,7 @@ struct f71805f_auto_point {
 struct f71805f_data {
 	unsigned short addr;
 	const char *name;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 
 	struct mutex update_lock;
 	char valid;		/* !=0 if following fields are valid */
@@ -1378,9 +1378,9 @@ static int __devinit f71805f_probe(struc
 		}
 	}
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		dev_err(&pdev->dev, "Class registration failed (%d)\n", err);
 		goto exit_remove_files;
 	}
@@ -1407,7 +1407,7 @@ static int __devexit f71805f_remove(stru
 	struct resource *res;
 	int i;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &f71805f_group);
 	for (i = 0; i < 4; i++)
 		sysfs_remove_group(&pdev->dev.kobj, &f71805f_group_optin[i]);
--- a/drivers/hwmon/fscher.c
+++ b/drivers/hwmon/fscher.c
@@ -134,7 +134,7 @@ static struct i2c_driver fscher_driver =
 
 struct fscher_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -344,9 +344,9 @@ static int fscher_detect(struct i2c_adap
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &fscher_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -367,7 +367,7 @@ static int fscher_detach_client(struct i
 	struct fscher_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &fscher_group);
 
 	if ((err = i2c_detach_client(client)))
--- a/drivers/hwmon/fscpos.c
+++ b/drivers/hwmon/fscpos.c
@@ -115,7 +115,7 @@ static struct i2c_driver fscpos_driver =
  */
 struct fscpos_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; 		/* 0 until following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
@@ -539,9 +539,9 @@ static int fscpos_detect(struct i2c_adap
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &fscpos_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -562,7 +562,7 @@ static int fscpos_detach_client(struct i
 	struct fscpos_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &fscpos_group);
 
 	if ((err = i2c_detach_client(client)))
--- a/drivers/hwmon/gl518sm.c
+++ b/drivers/hwmon/gl518sm.c
@@ -119,7 +119,7 @@ static inline u8 FAN_TO_REG(long rpm, in
 /* Each client has this additional data */
 struct gl518_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	enum chips type;
 
 	struct mutex update_lock;
@@ -460,9 +460,9 @@ static int gl518_detect(struct i2c_adapt
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &gl518_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -502,7 +502,7 @@ static int gl518_detach_client(struct i2
 	struct gl518_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &gl518_group);
 
 	if ((err = i2c_detach_client(client)))
--- a/drivers/hwmon/gl520sm.c
+++ b/drivers/hwmon/gl520sm.c
@@ -122,7 +122,7 @@ static struct i2c_driver gl520_driver = 
 /* Client data */
 struct gl520_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;		/* zero until the following fields are valid */
 	unsigned long last_updated;	/* in jiffies */
@@ -622,9 +622,9 @@ static int gl520_detect(struct i2c_adapt
 	}
 
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -685,7 +685,7 @@ static int gl520_detach_client(struct i2
 	struct gl520_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &gl520_group);
 	sysfs_remove_group(&client->dev.kobj, &gl520_group_opt);
 
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -222,7 +222,7 @@ struct it87_sio_data {
 /* For each registered chip, we need to keep some data in memory.
    The structure is dynamically allocated. */
 struct it87_data {
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	enum chips type;
 
 	unsigned short addr;
@@ -1089,9 +1089,9 @@ static int __devinit it87_probe(struct p
 			goto ERROR4;
 	}
 
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR4;
 	}
 
@@ -1113,7 +1113,7 @@ static int __devexit it87_remove(struct 
 {
 	struct it87_data *data = platform_get_drvdata(pdev);
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &it87_group);
 	sysfs_remove_group(&pdev->dev.kobj, &it87_group_opt);
 
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -38,7 +38,7 @@
 #define SEL_CORE	0x04
 
 struct k8temp_data {
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	const char *name;
 	char valid;		/* zero until following fields are valid */
@@ -225,10 +225,10 @@ static int __devinit k8temp_probe(struct
 	if (err)
 		goto exit_remove;
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
 
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -255,7 +255,7 @@ static void __devexit k8temp_remove(stru
 {
 	struct k8temp_data *data = dev_get_drvdata(&pdev->dev);
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	device_remove_file(&pdev->dev,
 			   &sensor_dev_attr_temp1_input.dev_attr);
 	device_remove_file(&pdev->dev,
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -154,7 +154,7 @@ static struct i2c_driver lm63_driver = {
 
 struct lm63_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -502,9 +502,9 @@ static int lm63_detect(struct i2c_adapte
 			goto exit_remove_files;
 	}
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -561,7 +561,7 @@ static int lm63_detach_client(struct i2c
 	struct lm63_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm63_group);
 	sysfs_remove_group(&client->dev.kobj, &lm63_group_fan1);
 
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -37,7 +37,7 @@
 #define DRVNAME		"lm70"
 
 struct lm70 {
-	struct class_device *cdev;
+	struct device *dev;
 	struct semaphore sem;
 };
 
@@ -107,10 +107,10 @@ static int __devinit lm70_probe(struct s
 	init_MUTEX(&p_lm70->sem);
 
 	/* sysfs hook */
-	p_lm70->cdev = hwmon_device_register(&spi->dev);
-	if (IS_ERR(p_lm70->cdev)) {
+	p_lm70->dev = hwmon_device_register(&spi->dev);
+	if (IS_ERR(p_lm70->dev)) {
 		dev_dbg(&spi->dev, "hwmon_device_register failed.\n");
-		status = PTR_ERR(p_lm70->cdev);
+		status = PTR_ERR(p_lm70->dev);
 		goto out_dev_reg_failed;
 	}
 	dev_set_drvdata(&spi->dev, p_lm70);
@@ -123,7 +123,7 @@ static int __devinit lm70_probe(struct s
 	return 0;
 
 out_dev_create_file_failed:
-	hwmon_device_unregister(p_lm70->cdev);
+	hwmon_device_unregister(p_lm70->dev);
 out_dev_reg_failed:
 	dev_set_drvdata(&spi->dev, NULL);
 	kfree(p_lm70);
@@ -135,7 +135,7 @@ static int __devexit lm70_remove(struct 
 	struct lm70 *p_lm70 = dev_get_drvdata(&spi->dev);
 
 	device_remove_file(&spi->dev, &dev_attr_temp1_input);
-	hwmon_device_unregister(p_lm70->cdev);
+	hwmon_device_unregister(p_lm70->dev);
 	dev_set_drvdata(&spi->dev, NULL);
 	kfree(p_lm70);
 
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -50,7 +50,7 @@ static const u8 LM75_REG_TEMP[3] = {
 /* Each client has this additional data */
 struct lm75_data {
 	struct i2c_client	client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex		update_lock;
 	char			valid;		/* !=0 if following fields are valid */
 	unsigned long		last_updated;	/* In jiffies */
@@ -219,9 +219,9 @@ static int lm75_detect(struct i2c_adapte
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &lm75_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -240,7 +240,7 @@ exit:
 static int lm75_detach_client(struct i2c_client *client)
 {
 	struct lm75_data *data = i2c_get_clientdata(client);
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm75_group);
 	i2c_detach_client(client);
 	kfree(data);
--- a/drivers/hwmon/lm77.c
+++ b/drivers/hwmon/lm77.c
@@ -51,7 +51,7 @@ I2C_CLIENT_INSMOD_1(lm77);
 /* Each client has this additional data */
 struct lm77_data {
 	struct i2c_client	client;
-	struct class_device *class_dev;
+	struct device 		*hwmon_dev;
 	struct mutex		update_lock;
 	char			valid;
 	unsigned long		last_updated;	/* In jiffies */
@@ -337,9 +337,9 @@ static int lm77_detect(struct i2c_adapte
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &lm77_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -358,7 +358,7 @@ exit:
 static int lm77_detach_client(struct i2c_client *client)
 {
 	struct lm77_data *data = i2c_get_clientdata(client);
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm77_group);
 	i2c_detach_client(client);
 	kfree(data);
--- a/drivers/hwmon/lm78.c
+++ b/drivers/hwmon/lm78.c
@@ -131,7 +131,7 @@ static inline int TEMP_FROM_REG(s8 val)
    the driver field to differentiate between I2C and ISA chips. */
 struct lm78_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex lock;
 	enum chips type;
 
@@ -585,9 +585,9 @@ static int lm78_detect(struct i2c_adapte
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &lm78_group)))
 		goto ERROR3;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR4;
 	}
 
@@ -608,7 +608,7 @@ static int lm78_detach_client(struct i2c
 	struct lm78_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm78_group);
 
 	if ((err = i2c_detach_client(client)))
@@ -659,9 +659,9 @@ static int __devinit lm78_isa_probe(stru
 	 || (err = device_create_file(&pdev->dev, &dev_attr_name)))
 		goto exit_remove_files;
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -681,7 +681,7 @@ static int __devexit lm78_isa_remove(str
 {
 	struct lm78_data *data = platform_get_drvdata(pdev);
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &lm78_group);
 	device_remove_file(&pdev->dev, &dev_attr_name);
 	release_region(data->client.addr, LM78_EXTENT);
--- a/drivers/hwmon/lm80.c
+++ b/drivers/hwmon/lm80.c
@@ -108,7 +108,7 @@ static inline long TEMP_FROM_REG(u16 tem
 
 struct lm80_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
@@ -497,9 +497,9 @@ static int lm80_detect(struct i2c_adapte
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &lm80_group)))
 		goto error_detach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto error_remove;
 	}
 
@@ -520,7 +520,7 @@ static int lm80_detach_client(struct i2c
 	struct lm80_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm80_group);
 	if ((err = i2c_detach_client(client)))
 		return err;
--- a/drivers/hwmon/lm83.c
+++ b/drivers/hwmon/lm83.c
@@ -144,7 +144,7 @@ static struct i2c_driver lm83_driver = {
 
 struct lm83_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -400,9 +400,9 @@ static int lm83_detect(struct i2c_adapte
 			goto exit_remove_files;
 	}
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -424,7 +424,7 @@ static int lm83_detach_client(struct i2c
 	struct lm83_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm83_group);
 	sysfs_remove_group(&client->dev.kobj, &lm83_group_opt);
 
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -328,7 +328,7 @@ struct lm85_autofan {
    The structure is dynamically allocated. */
 struct lm85_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	enum chips type;
 
 	struct mutex update_lock;
@@ -1257,9 +1257,9 @@ static int lm85_detect(struct i2c_adapte
 					&dev_attr_in4_max)))
 			goto ERROR3;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR3;
 	}
 
@@ -1280,7 +1280,7 @@ static int lm85_detect(struct i2c_adapte
 static int lm85_detach_client(struct i2c_client *client)
 {
 	struct lm85_data *data = i2c_get_clientdata(client);
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm85_group);
 	sysfs_remove_group(&client->dev.kobj, &lm85_group_opt);
 	i2c_detach_client(client);
--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -176,7 +176,7 @@ static struct i2c_driver lm87_driver = {
 
 struct lm87_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* In jiffies */
@@ -755,9 +755,9 @@ static int lm87_detect(struct i2c_adapte
 			goto exit_remove;
 	}
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -816,7 +816,7 @@ static int lm87_detach_client(struct i2c
 	struct lm87_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm87_group);
 	sysfs_remove_group(&client->dev.kobj, &lm87_group_opt);
 
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -214,7 +214,7 @@ static struct i2c_driver lm90_driver = {
 
 struct lm90_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -653,9 +653,9 @@ static int lm90_detect(struct i2c_adapte
 			goto exit_remove_files;
 	}
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -707,7 +707,7 @@ static int lm90_detach_client(struct i2c
 	struct lm90_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm90_group);
 	device_remove_file(&client->dev, &dev_attr_pec);
 
--- a/drivers/hwmon/lm92.c
+++ b/drivers/hwmon/lm92.c
@@ -96,7 +96,7 @@ static struct i2c_driver lm92_driver;
 /* Client data (each client gets its own) */
 struct lm92_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -379,9 +379,9 @@ static int lm92_detect(struct i2c_adapte
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &lm92_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -409,7 +409,7 @@ static int lm92_detach_client(struct i2c
 	struct lm92_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm92_group);
 
 	if ((err = i2c_detach_client(client)))
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -201,7 +201,7 @@ struct block1_t {
  */
 struct lm93_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 
 	struct mutex update_lock;
 	unsigned long last_updated;	/* In jiffies */
@@ -2590,11 +2590,11 @@ static int lm93_detect(struct i2c_adapte
 		goto err_detach;
 
 	/* Register hwmon driver class */
-	data->class_dev = hwmon_device_register(&client->dev);
-	if ( !IS_ERR(data->class_dev))
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if ( !IS_ERR(data->hwmon_dev))
 		return 0;
 
-	err = PTR_ERR(data->class_dev);
+	err = PTR_ERR(data->hwmon_dev);
 	dev_err(&client->dev, "error registering hwmon device.\n");
 	sysfs_remove_group(&client->dev.kobj, &lm93_attr_grp);
 err_detach:
@@ -2619,7 +2619,7 @@ static int lm93_detach_client(struct i2c
 	struct lm93_data *data = i2c_get_clientdata(client);
 	int err = 0;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &lm93_attr_grp);
 
 	err = i2c_detach_client(client);
--- a/drivers/hwmon/max1619.c
+++ b/drivers/hwmon/max1619.c
@@ -105,7 +105,7 @@ static struct i2c_driver max1619_driver 
 
 struct max1619_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -293,9 +293,9 @@ static int max1619_detect(struct i2c_ada
 	if ((err = sysfs_create_group(&new_client->dev.kobj, &max1619_group)))
 		goto exit_detach;
 
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -331,7 +331,7 @@ static int max1619_detach_client(struct 
 	struct max1619_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &max1619_group);
 
 	if ((err = i2c_detach_client(client)))
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -128,7 +128,7 @@ static struct i2c_driver max6650_driver 
 struct max6650_data
 {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -523,11 +523,11 @@ static int max6650_detect(struct i2c_ada
 	if (err)
 		goto err_detach;
 
-	data->class_dev = hwmon_device_register(&client->dev);
-	if (!IS_ERR(data->class_dev))
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (!IS_ERR(data->hwmon_dev))
 		return 0;
 
-	err = PTR_ERR(data->class_dev);
+	err = PTR_ERR(data->hwmon_dev);
 	dev_err(&client->dev, "error registering hwmon device.\n");
 	sysfs_remove_group(&client->dev.kobj, &max6650_attr_grp);
 err_detach:
@@ -543,7 +543,7 @@ static int max6650_detach_client(struct 
 	int err;
 
 	sysfs_remove_group(&client->dev.kobj, &max6650_attr_grp);
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	err = i2c_detach_client(client);
 	if (!err)
 		kfree(data);
--- a/drivers/hwmon/pc87360.c
+++ b/drivers/hwmon/pc87360.c
@@ -180,7 +180,7 @@ static inline u8 PWM_TO_REG(int val, int
 
 struct pc87360_data {
 	const char *name;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex lock;
 	struct mutex update_lock;
 	char valid;		/* !=0 if following fields are valid */
@@ -1054,9 +1054,9 @@ static int __devinit pc87360_probe(struc
 	if ((err = device_create_file(dev, &dev_attr_name)))
 		goto ERROR3;
 
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR3;
 	}
 	return 0;
@@ -1083,7 +1083,7 @@ static int __devexit pc87360_remove(stru
 	struct pc87360_data *data = platform_get_drvdata(pdev);
 	int i;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 
 	device_remove_file(&pdev->dev, &dev_attr_name);
 	sysfs_remove_group(&pdev->dev.kobj, &pc8736x_temp_group);
--- a/drivers/hwmon/pc87427.c
+++ b/drivers/hwmon/pc87427.c
@@ -42,7 +42,7 @@ static struct platform_device *pdev;
    device is using banked registers) and the register cache (needed to keep
    the data in the registers and the cache in sync at any time). */
 struct pc87427_data {
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex lock;
 	int address[2];
 	const char *name;
@@ -454,9 +454,9 @@ static int __devinit pc87427_probe(struc
 			goto exit_remove_files;
 	}
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		dev_err(&pdev->dev, "Class registration failed (%d)\n", err);
 		goto exit_remove_files;
 	}
@@ -484,7 +484,7 @@ static int __devexit pc87427_remove(stru
 	struct resource *res;
 	int i;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	device_remove_file(&pdev->dev, &dev_attr_name);
 	for (i = 0; i < 8; i++) {
 		if (!(data->fan_enabled & (1 << i)))
--- a/drivers/hwmon/sis5595.c
+++ b/drivers/hwmon/sis5595.c
@@ -163,7 +163,7 @@ static inline u8 DIV_TO_REG(int val)
 struct sis5595_data {
 	unsigned short addr;
 	const char *name;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex lock;
 
 	struct mutex update_lock;
@@ -557,9 +557,9 @@ static int __devinit sis5595_probe(struc
 			goto exit_remove_files;
 	}
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -580,7 +580,7 @@ static int __devexit sis5595_remove(stru
 {
 	struct sis5595_data *data = platform_get_drvdata(pdev);
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &sis5595_group);
 	sysfs_remove_group(&pdev->dev.kobj, &sis5595_group_opt);
 
--- a/drivers/hwmon/smsc47b397.c
+++ b/drivers/hwmon/smsc47b397.c
@@ -94,7 +94,7 @@ static u8 smsc47b397_reg_temp[] = {0x25,
 struct smsc47b397_data {
 	unsigned short addr;
 	const char *name;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex lock;
 
 	struct mutex update_lock;
@@ -222,7 +222,7 @@ static int __devexit smsc47b397_remove(s
 	struct smsc47b397_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &smsc47b397_group);
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	release_region(res->start, SMSC_EXTENT);
@@ -272,9 +272,9 @@ static int __devinit smsc47b397_probe(st
 	if ((err = sysfs_create_group(&dev->kobj, &smsc47b397_group)))
 		goto error_free;
 
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto error_remove;
 	}
 
--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -97,7 +97,7 @@ static inline int TEMP_FROM_REG(s8 val)
 
 struct smsc47m192_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
@@ -553,9 +553,9 @@ static int smsc47m192_detect(struct i2c_
 			goto exit_remove_files;
 	}
 
-	data->class_dev = hwmon_device_register(&client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -577,7 +577,7 @@ static int smsc47m192_detach_client(stru
 	struct smsc47m192_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &smsc47m192_group);
 	sysfs_remove_group(&client->dev.kobj, &smsc47m192_group_in4);
 
--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -116,7 +116,7 @@ struct smsc47m1_data {
 	unsigned short addr;
 	const char *name;
 	enum chips type;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 
 	struct mutex update_lock;
 	unsigned long last_updated;	/* In jiffies */
@@ -586,9 +586,9 @@ static int __devinit smsc47m1_probe(stru
 	if ((err = device_create_file(dev, &dev_attr_alarms)))
 		goto error_remove_files;
 
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto error_remove_files;
 	}
 
@@ -609,7 +609,7 @@ static int __devexit smsc47m1_remove(str
 	struct smsc47m1_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &smsc47m1_group);
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
--- a/drivers/hwmon/via686a.c
+++ b/drivers/hwmon/via686a.c
@@ -294,7 +294,7 @@ static inline long TEMP_FROM_REG10(u16 v
 struct via686a_data {
 	unsigned short addr;
 	const char *name;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
@@ -627,9 +627,9 @@ static int __devinit via686a_probe(struc
 	if ((err = sysfs_create_group(&pdev->dev.kobj, &via686a_group)))
 		goto exit_free;
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -648,7 +648,7 @@ static int __devexit via686a_remove(stru
 {
 	struct via686a_data *data = platform_get_drvdata(pdev);
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &via686a_group);
 
 	release_region(data->addr, VIA686A_EXTENT);
--- a/drivers/hwmon/vt1211.c
+++ b/drivers/hwmon/vt1211.c
@@ -108,7 +108,7 @@ static const u8 bitalarmfan[]	= {6, 7};
 struct vt1211_data {
 	unsigned short addr;
 	const char *name;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 
 	struct mutex update_lock;
 	char valid;			/* !=0 if following fields are valid */
@@ -1191,9 +1191,9 @@ static int __devinit vt1211_probe(struct
 	}
 
 	/* Register device */
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		dev_err(dev, "Class registration failed (%d)\n", err);
 		goto EXIT_DEV_REMOVE_SILENT;
 	}
@@ -1217,7 +1217,7 @@ static int __devexit vt1211_remove(struc
 	struct vt1211_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	vt1211_remove_sysfs(pdev);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -148,7 +148,7 @@ struct vt8231_data {
 	const char *name;
 
 	struct mutex update_lock;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
 
@@ -726,9 +726,9 @@ int vt8231_probe(struct platform_device 
 		}
 	}
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 	return 0;
@@ -756,7 +756,7 @@ static int __devexit vt8231_remove(struc
 	struct vt8231_data *data = platform_get_drvdata(pdev);
 	int i;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 
 	for (i = 0; i < ARRAY_SIZE(vt8231_group_volts); i++)
 		sysfs_remove_group(&pdev->dev.kobj, &vt8231_group_volts[i]);
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -256,7 +256,7 @@ struct w83627ehf_data {
 	int addr;	/* IO base of hw monitor block */
 	const char *name;
 
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex lock;
 
 	struct mutex update_lock;
@@ -1376,9 +1376,9 @@ static int __devinit w83627ehf_probe(str
 			goto exit_remove;
 	}
 
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -1398,7 +1398,7 @@ static int __devexit w83627ehf_remove(st
 {
 	struct w83627ehf_data *data = platform_get_drvdata(pdev);
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	w83627ehf_device_remove_files(&pdev->dev);
 	release_region(data->addr, IOREGION_LENGTH);
 	platform_set_drvdata(pdev, NULL);
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -346,7 +346,7 @@ static inline u8 DIV_TO_REG(long val)
 struct w83627hf_data {
 	unsigned short addr;
 	const char *name;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex lock;
 	enum chips type;
 
@@ -1294,9 +1294,9 @@ static int __devinit w83627hf_probe(stru
 		 || (err = device_create_file(dev, &dev_attr_pwm3_freq)))
 			goto ERROR4;
 
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR4;
 	}
 
@@ -1319,7 +1319,7 @@ static int __devexit w83627hf_remove(str
 	struct w83627hf_data *data = platform_get_drvdata(pdev);
 	struct resource *res;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 
 	sysfs_remove_group(&pdev->dev.kobj, &w83627hf_group);
 	sysfs_remove_group(&pdev->dev.kobj, &w83627hf_group_opt);
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -220,7 +220,7 @@ DIV_TO_REG(long val, enum chips type)
    the driver field to differentiate between I2C and ISA chips. */
 struct w83781d_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex lock;
 	enum chips type;
 
@@ -1156,9 +1156,9 @@ w83781d_detect(struct i2c_adapter *adapt
 	if (err)
 		goto ERROR4;
 
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto ERROR4;
 	}
 
@@ -1192,7 +1192,7 @@ w83781d_detach_client(struct i2c_client 
 
 	/* main client */
 	if (data) {
-		hwmon_device_unregister(data->class_dev);
+		hwmon_device_unregister(data->hwmon_dev);
 		sysfs_remove_group(&client->dev.kobj, &w83781d_group);
 		sysfs_remove_group(&client->dev.kobj, &w83781d_group_opt);
 	}
@@ -1259,9 +1259,9 @@ w83781d_isa_probe(struct platform_device
 	if (err)
 		goto exit_remove_files;
 
-	data->class_dev = hwmon_device_register(&pdev->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -1283,7 +1283,7 @@ w83781d_isa_remove(struct platform_devic
 {
 	struct w83781d_data *data = platform_get_drvdata(pdev);
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &w83781d_group);
 	sysfs_remove_group(&pdev->dev.kobj, &w83781d_group_opt);
 	device_remove_file(&pdev->dev, &dev_attr_name);
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -247,7 +247,7 @@ static u8 div_to_reg(int nr, long val)
 
 struct w83791d_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 
 	char valid;			/* !=0 if following fields are valid */
@@ -1017,9 +1017,9 @@ static int w83791d_detect(struct i2c_ada
 		goto error3;
 
 	/* Everything is ready, now register the working device */
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto error4;
 	}
 
@@ -1051,7 +1051,7 @@ static int w83791d_detach_client(struct 
 
 	/* main client */
 	if (data) {
-		hwmon_device_unregister(data->class_dev);
+		hwmon_device_unregister(data->hwmon_dev);
 		sysfs_remove_group(&client->dev.kobj, &w83791d_group);
 	}
 
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -267,7 +267,7 @@ DIV_TO_REG(long val)
 
 struct w83792d_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	enum chips type;
 
 	struct mutex update_lock;
@@ -1396,9 +1396,9 @@ w83792d_detect(struct i2c_adapter *adapt
 					      &w83792d_group_fan[3])))
 			goto exit_remove_files;
 
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove_files;
 	}
 
@@ -1433,7 +1433,7 @@ w83792d_detach_client(struct i2c_client 
 
 	/* main client */
 	if (data) {
-		hwmon_device_unregister(data->class_dev);
+		hwmon_device_unregister(data->hwmon_dev);
 		sysfs_remove_group(&client->dev.kobj, &w83792d_group);
 		for (i = 0; i < ARRAY_SIZE(w83792d_group_fan); i++)
 			sysfs_remove_group(&client->dev.kobj,
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -179,7 +179,7 @@ static inline s8 TEMP_TO_REG(long val, s
 struct w83793_data {
 	struct i2c_client client;
 	struct i2c_client *lm75[2];
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid;			/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
@@ -1075,7 +1075,7 @@ static int w83793_detach_client(struct i
 
 	/* main client */
 	if (data) {
-		hwmon_device_unregister(data->class_dev);
+		hwmon_device_unregister(data->hwmon_dev);
 
 		for (i = 0; i < ARRAY_SIZE(w83793_sensor_attr_2); i++)
 			device_remove_file(dev,
@@ -1434,9 +1434,9 @@ static int w83793_detect(struct i2c_adap
 		}
 	}
 
-	data->class_dev = hwmon_device_register(dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
--- a/drivers/hwmon/w83l785ts.c
+++ b/drivers/hwmon/w83l785ts.c
@@ -107,7 +107,7 @@ static struct i2c_driver w83l785ts_drive
 
 struct w83l785ts_data {
 	struct i2c_client client;
-	struct class_device *class_dev;
+	struct device *hwmon_dev;
 	struct mutex update_lock;
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
@@ -247,9 +247,9 @@ static int w83l785ts_detect(struct i2c_a
 		goto exit_remove;
 
 	/* Register sysfs hooks */
-	data->class_dev = hwmon_device_register(&new_client->dev);
-	if (IS_ERR(data->class_dev)) {
-		err = PTR_ERR(data->class_dev);
+	data->hwmon_dev = hwmon_device_register(&new_client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
 		goto exit_remove;
 	}
 
@@ -272,7 +272,7 @@ static int w83l785ts_detach_client(struc
 	struct w83l785ts_data *data = i2c_get_clientdata(client);
 	int err;
 
-	hwmon_device_unregister(data->class_dev);
+	hwmon_device_unregister(data->hwmon_dev);
 	device_remove_file(&client->dev,
 			   &sensor_dev_attr_temp1_input.dev_attr);
 	device_remove_file(&client->dev,
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -83,7 +83,7 @@ struct ads7846 {
 
 #if defined(CONFIG_HWMON) || defined(CONFIG_HWMON_MODULE)
 	struct attribute_group	*attr_group;
-	struct class_device	*hwmon;
+	struct device		*hwmon;
 #endif
 
 	u16			model;
@@ -369,7 +369,7 @@ static struct attribute_group ads7845_at
 
 static int ads784x_hwmon_register(struct spi_device *spi, struct ads7846 *ts)
 {
-	struct class_device *hwmon;
+	struct device *hwmon;
 	int err;
 
 	/* hwmon sensors need a reference voltage */
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -517,7 +517,7 @@ static char *next_cmd(char **cmds)
  ****************************************************************************/
 
 static struct platform_device *tpacpi_pdev;
-static struct class_device *tpacpi_hwmon;
+static struct device *tpacpi_hwmon;
 static struct input_dev *tpacpi_inputdev;
 
 
--- a/drivers/misc/thinkpad_acpi.h
+++ b/drivers/misc/thinkpad_acpi.h
@@ -171,7 +171,7 @@ static int parse_strtoul(const char *buf
 
 /* Device model */
 static struct platform_device *tpacpi_pdev;
-static struct class_device *tpacpi_hwmon;
+static struct device *tpacpi_hwmon;
 static struct platform_driver tpacpi_pdriver;
 static struct input_dev *tpacpi_inputdev;
 static int tpacpi_create_driver_attributes(struct device_driver *drv);

-- 
