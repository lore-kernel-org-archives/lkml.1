Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZHMNhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZHMNhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 09:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZHMNhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 09:37:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53702 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZHMNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:37:49 -0400
Date: Thu, 13 Aug 2009 15:37:47 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Eric Piel <eric.piel@tremplin-utc.net>,
       Luotao Fu <l.fu@pengutronix.de>, lm-sensors@lm-sensors.org,
       Hans de Goede <hdegoede@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [lm-sensors] [PATCH 3/5] [hwmon] add Freescale MC13783 adc
	driver
Message-ID: <20090813133747.GJ17992@pengutronix.de>
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-4-git-send-email-s.hauer@pengutronix.de> <20090812164252.GE11227@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090812164252.GE11227@sirena.org.uk>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 15:36:35 up 8 days, 55 min, 61 users,  load average: 0.08, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 05:42:53PM +0100, Mark Brown wrote:
> On Wed, Aug 12, 2009 at 05:05:29PM +0200, Sascha Hauer wrote:
> 
> > ---
> >  drivers/hwmon/Kconfig       |    6 ++
> >  drivers/hwmon/Makefile      |    1 +
> >  drivers/hwmon/mc13783-adc.c |  181 +++++++++++++++++++++++++++++++++++++++++++
> 
> Ideally there should be a Documentation/hwmon describing the chip and
> the hwmon features it has.
> 
> > +	for (i = 0; i < entries; i++) {
> > +		ret = device_create_file(&pdev->dev,
> > +				&mc13783_adc_ctl[i].dev_attr);
> > +		if (ret) {
> > +			dev_err(&pdev->dev,
> > +				"device_create_file failed with %d.\n", ret);
> > +			goto out_err;
> > +		}
> > +	}
> 
> Could use sysfs_create_group() here.
> 

Ok, here is an updated version:


commit cb6bff0876a204a0dfceac4dd8d4ea7983b6063e
Author: Luotao Fu <l.fu@pengutronix.de>
Date:   Fri Aug 7 15:21:57 2009 +0200

    [hwmon] add Freescale MC13783 adc driver
    
    This driver provides support for the ADC integrated into the
    Freescale MC13783 PMIC.
    
    Changes since v2:
    
    - Add Documentation Documentation/hwmon/mc13783
    - use sysfs_create_group
    
    Changes since v1:
    
    - add MODULE_ALIAS
    - __init -> __devinit in probe function
    - use platform_driver_probe instead of platform_driver_register
    
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Cc: Hans de Goede <hdegoede@redhat.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Eric Piel <eric.piel@tremplin-utc.net>
    Cc: lm-sensors@lm-sensors.org

diff --git a/Documentation/hwmon/mc13783 b/Documentation/hwmon/mc13783
new file mode 100644
index 0000000..6f2ac45
--- /dev/null
+++ b/Documentation/hwmon/mc13783
@@ -0,0 +1,50 @@
+Kernel driver mc13783
+=====================
+
+Supported chips:
+  * Freescale Atlas MC13783
+    Prefix: 'mc13783'
+    Datasheet: http://www.freescale.com/files/rf_if/doc/data_sheet/MC13783.pdf?fsrch=1
+
+Authors:
+       Sascha Hauer <s.hauer@pengutronix.de>
+
+Description
+-----------
+
+The Freescale MC13783 is a Power Management and Audio Circuit. Among
+other things it contains a 10bit A/D converter. The converter has 16
+channels which can be used in different modes.
+The A/D converter has a resolution of 2.25mV. Channels 0-4 have
+a dedicated meaning with chip internal scaling applied. Channels 5-7
+can be used as general purpose inputs or alternatively in a dedicated
+mode. Channels 12-15 are occupied by the touchscreen if it's active.
+
+Currently the driver only supports raw channel readout and no alternative
+modes for channels 5-7.
+
+See this table for the meaning of the different channels and their chip
+internal scaling:
+
+Channel	Signal						Input Range	Scaling
+-------------------------------------------------------------------------------
+0	Battery Voltage (BATT)				2.50 – 4.65V	-2.40V
+1	Battery Current (BATT – BATTISNS)		-50 - 50 mV	x20
+2	Application Supply (BP)				2.50 – 4.65V	-2.40V
+3	Charger Voltage (CHRGRAW)			0 – 10V /	/5
+							0 – 20V		/10
+4	Charger Current (CHRGISNSP-CHRGISNSN)		-0.25V – 0.25V	X4
+5	General Purpose ADIN5 / Battery Pack Thermistor	0 – 2.30V	No
+6	General Purpose ADIN6 / Backup Voltage (LICELL)	0 – 2.30V /	No /
+							1.50 – 3.50V	-1.20V
+7	General Purpose ADIN7 / UID / Die Temperature	0 – 2.30V /	No /
+							0 – 2.55V /	x0.9 / No
+8	General Purpose ADIN8				0 - 2.30V	No
+9	General Purpose ADIN9				0 - 2.30V	No
+10	General Purpose ADIN10				0 - 2.30V	No
+11	General Purpose ADIN11				0 - 2.30V	No
+12	General Purpose TSX1 / Touchscreen X-plate 1	0 - 2.30V	No
+13	General Purpose TSX2 / Touchscreen X-plate 2	0 - 2.30V	No
+14	General Purpose TSY1 / Touchscreen Y-plate 1	0 - 2.30V	No
+15	General Purpose TSY2 / Touchscreen Y-plate 2	0 - 2.30V	No
+
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 2d50166..a7e34fd 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1017,6 +1017,12 @@ config SENSORS_APPLESMC
 	  Say Y here if you have an applicable laptop and want to experience
 	  the awesome power of applesmc.
 
+config SENSORS_MC13783_ADC
+        tristate "Freescale MC13783 ADC"
+        depends on MFD_MC13783
+        help
+          Support for the ad converter on mc13783 pmic.
+
 config HWMON_DEBUG_CHIP
 	bool "Hardware Monitoring Chip debugging messages"
 	default n
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index b793dce..9b4e131 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -89,6 +89,7 @@ obj-$(CONFIG_SENSORS_VT8231)	+= vt8231.o
 obj-$(CONFIG_SENSORS_W83627EHF)	+= w83627ehf.o
 obj-$(CONFIG_SENSORS_W83L785TS)	+= w83l785ts.o
 obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
+obj-$(CONFIG_SENSORS_MC13783_ADC)       += mc13783-adc.o
 
 ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
new file mode 100644
index 0000000..0a768e7
--- /dev/null
+++ b/drivers/hwmon/mc13783-adc.c
@@ -0,0 +1,204 @@
+/*
+ * Driver for the Freescale Semiconductor MC13783 adc.
+ *
+ * Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright (C) 2009 Sascha Hauer, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#include <linux/mfd/mc13783-private.h>
+#include <linux/platform_device.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/completion.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/hwmon.h>
+#include <linux/input.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+
+#define MC13783_ADC_NAME	"mc13783-adc"
+
+struct mc13783_adc_priv {
+	struct mc13783 *mc13783;
+	struct device *hwmon_dev;
+};
+
+static ssize_t mc13783_adc_show_name(struct device *dev, struct device_attribute
+			      *devattr, char *buf)
+{
+	return sprintf(buf, "mc13783_adc\n");
+}
+
+static ssize_t mc13783_adc_read(struct device *dev,
+		struct device_attribute *devattr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mc13783_adc_priv *priv = platform_get_drvdata(pdev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	unsigned int channel = attr->index;
+	unsigned int res;
+	unsigned int sample[4];
+
+	mc13783_adc_do_conversion(priv->mc13783, MC13783_ADC_MODE_MULT_CHAN,
+			channel, sample);
+
+	channel &= 0x7;
+
+	res = (sample[channel % 4] >> (channel > 3 ? 14 : 2)) & 0x3ff;
+
+	return sprintf(buf, "%u\n", res);
+}
+
+SENSOR_DEVICE_ATTR(name, S_IRUGO, mc13783_adc_show_name, NULL, 0);
+SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, mc13783_adc_read, NULL, 0);
+SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, mc13783_adc_read, NULL, 1);
+SENSOR_DEVICE_ATTR(in2_input, S_IRUGO, mc13783_adc_read, NULL, 2);
+SENSOR_DEVICE_ATTR(in3_input, S_IRUGO, mc13783_adc_read, NULL, 3);
+SENSOR_DEVICE_ATTR(in4_input, S_IRUGO, mc13783_adc_read, NULL, 4);
+SENSOR_DEVICE_ATTR(in5_input, S_IRUGO, mc13783_adc_read, NULL, 5);
+SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, mc13783_adc_read, NULL, 6);
+SENSOR_DEVICE_ATTR(in7_input, S_IRUGO, mc13783_adc_read, NULL, 7);
+SENSOR_DEVICE_ATTR(in8_input, S_IRUGO, mc13783_adc_read, NULL, 8);
+SENSOR_DEVICE_ATTR(in9_input, S_IRUGO, mc13783_adc_read, NULL, 9);
+SENSOR_DEVICE_ATTR(in10_input, S_IRUGO, mc13783_adc_read, NULL, 10);
+SENSOR_DEVICE_ATTR(in11_input, S_IRUGO, mc13783_adc_read, NULL, 11);
+SENSOR_DEVICE_ATTR(in12_input, S_IRUGO, mc13783_adc_read, NULL, 12);
+SENSOR_DEVICE_ATTR(in13_input, S_IRUGO, mc13783_adc_read, NULL, 13);
+SENSOR_DEVICE_ATTR(in14_input, S_IRUGO, mc13783_adc_read, NULL, 14);
+SENSOR_DEVICE_ATTR(in15_input, S_IRUGO, mc13783_adc_read, NULL, 15);
+
+static struct attribute *mc13783_attr[] =
+{
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	&sensor_dev_attr_in2_input.dev_attr.attr,
+	&sensor_dev_attr_in3_input.dev_attr.attr,
+	&sensor_dev_attr_in4_input.dev_attr.attr,
+	&sensor_dev_attr_in5_input.dev_attr.attr,
+	&sensor_dev_attr_in6_input.dev_attr.attr,
+	&sensor_dev_attr_in7_input.dev_attr.attr,
+	&sensor_dev_attr_in8_input.dev_attr.attr,
+	&sensor_dev_attr_in9_input.dev_attr.attr,
+	&sensor_dev_attr_in10_input.dev_attr.attr,
+	&sensor_dev_attr_in11_input.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group mc13783_group = {
+	.attrs = mc13783_attr,
+};
+
+/* last four channels may be occupied by the touchscreen */
+static struct attribute *mc13783_attr_ts[] =
+{
+	&sensor_dev_attr_in12_input.dev_attr.attr,
+	&sensor_dev_attr_in13_input.dev_attr.attr,
+	&sensor_dev_attr_in14_input.dev_attr.attr,
+	&sensor_dev_attr_in15_input.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group mc13783_group_ts = {
+	.attrs = mc13783_attr_ts,
+};
+
+static int __devinit mc13783_adc_probe(struct platform_device *pdev)
+{
+	struct mc13783_adc_priv *priv;
+	int ret;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->mc13783 = dev_get_drvdata(pdev->dev.parent);
+
+	/* Register sysfs hooks */
+	ret = sysfs_create_group(&pdev->dev.kobj, &mc13783_group);
+	if (ret)
+		goto out_err_create1;
+
+	if (!(priv->mc13783->flags & MC13783_USE_TOUCHSCREEN))
+		ret = sysfs_create_group(&pdev->dev.kobj, &mc13783_group_ts);
+		if (ret)
+			goto out_err_create2;
+
+	priv->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(priv->hwmon_dev)) {
+		ret = PTR_ERR(priv->hwmon_dev);
+		dev_err(&pdev->dev,
+				"hwmon_device_register failed with %d.\n", ret);
+		goto out_err_register;
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	return 0;
+
+out_err_register:
+	if (!(priv->mc13783->flags & MC13783_USE_TOUCHSCREEN))
+		sysfs_remove_group(&pdev->dev.kobj, &mc13783_group_ts);
+out_err_create2:
+	sysfs_remove_group(&pdev->dev.kobj, &mc13783_group);
+out_err_create1:
+	kfree(priv);
+
+	return ret;
+}
+
+static int __devexit mc13783_adc_remove(struct platform_device *pdev)
+{
+	struct mc13783_adc_priv *priv = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(&pdev->dev);
+
+	if (!(priv->mc13783->flags & MC13783_USE_TOUCHSCREEN))
+		sysfs_remove_group(&pdev->dev.kobj, &mc13783_group_ts);
+
+	sysfs_remove_group(&pdev->dev.kobj, &mc13783_group);
+
+	kfree(priv);
+
+	return 0;
+}
+
+static struct platform_driver mc13783_adc_driver = {
+	.remove 	= __devexit_p(mc13783_adc_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= MC13783_ADC_NAME,
+	},
+};
+
+static int __init mc13783_adc_init(void)
+{
+	return platform_driver_probe(&mc13783_adc_driver, &mc13783_adc_probe);
+}
+
+static void __exit mc13783_adc_exit(void)
+{
+	platform_driver_unregister(&mc13783_adc_driver);
+}
+
+module_init(mc13783_adc_init);
+module_exit(mc13783_adc_exit);
+
+MODULE_DESCRIPTION("MC13783 input touchscreen driver");
+MODULE_AUTHOR("Luotao Fu, <l.fu@pengutronix.de>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:mc13783-adc");
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
