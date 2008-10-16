Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbYJPRSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbYJPRSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbYJPROO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:14 -0400
Received: from kroah.org ([198.145.64.141]:46935 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756110AbYJPROL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/46] device create: misc: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:08 -0700
Message-Id: <1224177047-11859-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/mips/kernel/rtlx.c             |    4 ++--
 arch/mips/sibyte/common/sb_tbprof.c |    3 +--
 arch/x86/kernel/cpuid.c             |    4 ++--
 arch/x86/kernel/msr.c               |    4 ++--
 drivers/dca/dca-sysfs.c             |    8 +++-----
 drivers/hid/hidraw.c                |    5 ++---
 drivers/hwmon/hwmon.c               |    4 ++--
 drivers/i2c/i2c-dev.c               |    6 +++---
 drivers/isdn/capi/capi.c            |    3 +--
 drivers/leds/led-class.c            |    4 ++--
 drivers/macintosh/adb.c             |    3 +--
 drivers/media/dvb/dvb-core/dvbdev.c |    2 +-
 drivers/misc/phantom.c              |    6 +++---
 drivers/mtd/mtdchar.c               |   10 ++++------
 drivers/power/power_supply_core.c   |    4 ++--
 drivers/spi/spidev.c                |    7 +++----
 drivers/uio/uio.c                   |    6 +++---
 fs/coda/psdev.c                     |    5 ++---
 18 files changed, 39 insertions(+), 49 deletions(-)

diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index dfd868b..4ce93aa 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -522,8 +522,8 @@ static int __init rtlx_module_init(void)
 		atomic_set(&channel_wqs[i].in_open, 0);
 		mutex_init(&channel_wqs[i].mutex);
 
-		dev = device_create_drvdata(mt_class, NULL, MKDEV(major, i),
-					    NULL, "%s%d", module_name, i);
+		dev = device_create(mt_class, NULL, MKDEV(major, i), NULL,
+				    "%s%d", module_name, i);
 		if (IS_ERR(dev)) {
 			err = PTR_ERR(dev);
 			goto out_chrdev;
diff --git a/arch/mips/sibyte/common/sb_tbprof.c b/arch/mips/sibyte/common/sb_tbprof.c
index 66e3e3f..637a194 100644
--- a/arch/mips/sibyte/common/sb_tbprof.c
+++ b/arch/mips/sibyte/common/sb_tbprof.c
@@ -576,8 +576,7 @@ static int __init sbprof_tb_init(void)
 
 	tb_class = tbc;
 
-	dev = device_create_drvdata(tbc, NULL, MKDEV(SBPROF_TB_MAJOR, 0),
-				    NULL, "tb");
+	dev = device_create(tbc, NULL, MKDEV(SBPROF_TB_MAJOR, 0), NULL, "tb");
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_class;
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 6a44d64..72cefd1 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -147,8 +147,8 @@ static __cpuinit int cpuid_device_create(int cpu)
 {
 	struct device *dev;
 
-	dev = device_create_drvdata(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu),
-				    NULL, "cpu%d", cpu);
+	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu), NULL,
+			    "cpu%d", cpu);
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 2e2af5d..82a7c7e 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -163,8 +163,8 @@ static int __cpuinit msr_device_create(int cpu)
 {
 	struct device *dev;
 
-	dev = device_create_drvdata(msr_class, NULL, MKDEV(MSR_MAJOR, cpu),
-				    NULL, "msr%d", cpu);
+	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu), NULL,
+			    "msr%d", cpu);
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
 
diff --git a/drivers/dca/dca-sysfs.c b/drivers/dca/dca-sysfs.c
index 7af4b40..bb538b9 100644
--- a/drivers/dca/dca-sysfs.c
+++ b/drivers/dca/dca-sysfs.c
@@ -15,9 +15,8 @@ int dca_sysfs_add_req(struct dca_provider *dca, struct device *dev, int slot)
 	struct device *cd;
 	static int req_count;
 
-	cd = device_create_drvdata(dca_class, dca->cd,
-				   MKDEV(0, slot + 1), NULL,
-				   "requester%d", req_count++);
+	cd = device_create(dca_class, dca->cd, MKDEV(0, slot + 1), NULL,
+			   "requester%d", req_count++);
 	if (IS_ERR(cd))
 		return PTR_ERR(cd);
 	return 0;
@@ -48,8 +47,7 @@ idr_try_again:
 		return err;
 	}
 
-	cd = device_create_drvdata(dca_class, dev, MKDEV(0, 0), NULL,
-				   "dca%d", dca->id);
+	cd = device_create(dca_class, dev, MKDEV(0, 0), NULL, "dca%d", dca->id);
 	if (IS_ERR(cd)) {
 		spin_lock(&dca_idr_lock);
 		idr_remove(&dca_idr, dca->id);
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 497e0d1..af3edb9 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -326,9 +326,8 @@ int hidraw_connect(struct hid_device *hid)
 		goto out;
 	}
 
-	dev->dev = device_create_drvdata(hidraw_class, NULL,
-					 MKDEV(hidraw_major, minor), NULL,
-					 "%s%d", "hidraw", minor);
+	dev->dev = device_create(hidraw_class, NULL, MKDEV(hidraw_major, minor),
+				 NULL, "%s%d", "hidraw", minor);
 
 	if (IS_ERR(dev->dev)) {
 		spin_lock(&minors_lock);
diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 7321a88..076a59c 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -55,8 +55,8 @@ again:
 		return ERR_PTR(err);
 
 	id = id & MAX_ID_MASK;
-	hwdev = device_create_drvdata(hwmon_class, dev, MKDEV(0, 0), NULL,
-				      HWMON_ID_FORMAT, id);
+	hwdev = device_create(hwmon_class, dev, MKDEV(0, 0), NULL,
+			      HWMON_ID_FORMAT, id);
 
 	if (IS_ERR(hwdev)) {
 		spin_lock(&idr_lock);
diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 307d976..c171988 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -521,9 +521,9 @@ static int i2cdev_attach_adapter(struct i2c_adapter *adap)
 		return PTR_ERR(i2c_dev);
 
 	/* register this i2c device with the driver core */
-	i2c_dev->dev = device_create_drvdata(i2c_dev_class, &adap->dev,
-					     MKDEV(I2C_MAJOR, adap->nr),
-					     NULL, "i2c-%d", adap->nr);
+	i2c_dev->dev = device_create(i2c_dev_class, &adap->dev,
+				     MKDEV(I2C_MAJOR, adap->nr), NULL,
+				     "i2c-%d", adap->nr);
 	if (IS_ERR(i2c_dev->dev)) {
 		res = PTR_ERR(i2c_dev->dev);
 		goto error;
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 798d7f3..1b5bf87 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1553,8 +1553,7 @@ static int __init capi_init(void)
 		return PTR_ERR(capi_class);
 	}
 
-	device_create_drvdata(capi_class, NULL, MKDEV(capi_major, 0), NULL,
-			      "capi");
+	device_create(capi_class, NULL, MKDEV(capi_major, 0), NULL, "capi");
 
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
 	if (capinc_tty_init() < 0) {
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 559a408..ee74ee7 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -103,8 +103,8 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 {
 	int rc;
 
-	led_cdev->dev = device_create_drvdata(leds_class, parent, 0, led_cdev,
-					      "%s", led_cdev->name);
+	led_cdev->dev = device_create(leds_class, parent, 0, led_cdev,
+				      "%s", led_cdev->name);
 	if (IS_ERR(led_cdev->dev))
 		return PTR_ERR(led_cdev->dev);
 
diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index cae5248..23741ce 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -862,8 +862,7 @@ adbdev_init(void)
 	adb_dev_class = class_create(THIS_MODULE, "adb");
 	if (IS_ERR(adb_dev_class))
 		return;
-	device_create_drvdata(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), NULL,
-			      "adb");
+	device_create(adb_dev_class, NULL, MKDEV(ADB_MAJOR, 0), NULL, "adb");
 
 	platform_device_register(&adb_pfdev);
 	platform_driver_probe(&adb_pfdrv, adb_dummy_probe);
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index e713277..665776d 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -233,7 +233,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 
 	mutex_unlock(&dvbdev_register_lock);
 
-	clsdev = device_create_drvdata(dvb_class, adap->device,
+	clsdev = device_create(dvb_class, adap->device,
 			       MKDEV(DVB_MAJOR, nums2minor(adap->num, type, id)),
 			       NULL, "dvb%d.%s%d", adap->num, dnames[type], id);
 	if (IS_ERR(clsdev)) {
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index daf5856..abdebe3 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -399,9 +399,9 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
 		goto err_irq;
 	}
 
-	if (IS_ERR(device_create_drvdata(phantom_class, &pdev->dev,
-					 MKDEV(phantom_major, minor),
-					 NULL, "phantom%u", minor)))
+	if (IS_ERR(device_create(phantom_class, &pdev->dev,
+				 MKDEV(phantom_major, minor), NULL,
+				 "phantom%u", minor)))
 		dev_err(&pdev->dev, "can't create device\n");
 
 	pci_set_drvdata(pdev, pht);
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index e00d424..1c74762 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -26,13 +26,11 @@ static void mtd_notify_add(struct mtd_info* mtd)
 	if (!mtd)
 		return;
 
-	device_create_drvdata(mtd_class, NULL,
-			      MKDEV(MTD_CHAR_MAJOR, mtd->index*2),
-			      NULL, "mtd%d", mtd->index);
+	device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2),
+		      NULL, "mtd%d", mtd->index);
 
-	device_create_drvdata(mtd_class, NULL,
-			      MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1),
-			      NULL, "mtd%dro", mtd->index);
+	device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1),
+		      NULL, "mtd%dro", mtd->index);
 }
 
 static void mtd_notify_remove(struct mtd_info* mtd)
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index cb1ccb4..3007695 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -91,8 +91,8 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 {
 	int rc = 0;
 
-	psy->dev = device_create_drvdata(power_supply_class, parent, 0,
-					 psy, "%s", psy->name);
+	psy->dev = device_create(power_supply_class, parent, 0, psy,
+				 "%s", psy->name);
 	if (IS_ERR(psy->dev)) {
 		rc = PTR_ERR(psy->dev);
 		goto dev_create_failed;
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index e5e0cfe..89a4375 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -583,10 +583,9 @@ static int spidev_probe(struct spi_device *spi)
 		struct device *dev;
 
 		spidev->devt = MKDEV(SPIDEV_MAJOR, minor);
-		dev = device_create_drvdata(spidev_class, &spi->dev,
-				spidev->devt, spidev,
-				"spidev%d.%d",
-				spi->master->bus_num, spi->chip_select);
+		dev = device_create(spidev_class, &spi->dev, spidev->devt,
+				    spidev, "spidev%d.%d",
+				    spi->master->bus_num, spi->chip_select);
 		status = IS_ERR(dev) ? PTR_ERR(dev) : 0;
 	} else {
 		dev_dbg(&spi->dev, "no minor number available!\n");
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 3a6934b..9ac22c7 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -682,9 +682,9 @@ int __uio_register_device(struct module *owner,
 	if (ret)
 		goto err_get_minor;
 
-	idev->dev = device_create_drvdata(uio_class->class, parent,
-					  MKDEV(uio_major, idev->minor), idev,
-					  "uio%d", idev->minor);
+	idev->dev = device_create(uio_class->class, parent,
+				  MKDEV(uio_major, idev->minor), idev,
+				  "uio%d", idev->minor);
 	if (IS_ERR(idev->dev)) {
 		printk(KERN_ERR "UIO: device register failed\n");
 		ret = PTR_ERR(idev->dev);
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index 0d9b80e..cfd29da 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -362,9 +362,8 @@ static int init_coda_psdev(void)
 		goto out_chrdev;
 	}		
 	for (i = 0; i < MAX_CODADEVS; i++)
-		device_create_drvdata(coda_psdev_class, NULL,
-				      MKDEV(CODA_PSDEV_MAJOR, i),
-				      NULL, "cfs%d", i);
+		device_create(coda_psdev_class, NULL,
+			      MKDEV(CODA_PSDEV_MAJOR, i), NULL, "cfs%d", i);
 	coda_sysctl_init();
 	goto out;
 
-- 
1.6.0.2

