Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZGAS0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZGAS0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZGAS0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:26:12 -0400
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:47736 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZGAS0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:26:10 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 14:26:09 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C9FA78.3D0DF07A"
x-cr-puzzleid: {8B86A2EA-5F61-498E-BCAD-7F3490A58FB1}
x-cr-hashedpuzzle: vr0= DJSF DiRR Dufi I2vE JYTA KjB+ KsYx LFjV Nd9B PeOZ Q8PZ RUhD R1gu Tx8j U3nn;2;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAbQAtAHMAZQBuAHMAbwByAHMAQABsAG0ALQBzAGUAbgBzAG8AcgBzAC4AbwByAGcA;Sosha1_v1;7;{8B86A2EA-5F61-498E-BCAD-7F3490A58FB1};YwBoAHIAaQBzAHYAQABjAHkAYgBlAHIAcwB3AGkAdABjAGgAaQBuAGcALgBjAG8AbQA=;Wed, 01 Jul 2009 18:17:40 GMT;WwBQAEEAVABDAEgAXQAgAGEAZAB4AGwAMwA0ADUAIABhAGMAYwBlAGwAZQByAG8AbQBlAHQAZQByACAAaAB3AG0AbwBuACAAZAByAGkAdgBlAHIA
Content-class: urn:content-classes:message
Subject: [PATCH] adxl345 accelerometer hwmon driver
Date: Wed, 1 Jul 2009 11:17:40 -0700
Message-ID: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] adxl345 accelerometer hwmon driver
Thread-Index: Acn6eDhBoTUmzVqOSVGG9a2LiwqVrA==
From: "Chris Verges" <chrisv@cyberswitching.com>
To: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009062201)]
X-MAIL-FROM: <chrisv@cyberswitching.com>
X-SOURCE-IP: [64.81.28.110]
X-AnalysisOut: [v=1.0 c=1 a=sr6qEOWWBcYA:10 a=4zsJQXJisSY22NXBO5KRuA==:17 ]
X-AnalysisOut: [a=wzgqfsuUAAAA:8 a=5Up8faWwAAAA:8 a=eAvSDxW-k_2PI7rRL_kA:9]
X-AnalysisOut: [ a=GxgZRbsYMcnFtWd0tE8A:7 a=dgv0Flmuo6r0NZUzVqAgpC4v9oYA:4]
X-AnalysisOut: [ a=yvfu_RGVus0A:10 a=v6MMM96S_sUA:10 a=OQBCenhqjXis7uDX:21]
X-AnalysisOut: [ a=2VGWN8BtC2QmN9Si:21 a=089Uxu0kX7_s5PIaRrYA:7 a=f1PLI9so]
X-AnalysisOut: [o9AQVaGIk20r8_sV62IA:4 a=cZBGH-sSwzOzqpeF:21 a=3K2taa89qCy]
X-AnalysisOut: [zJRMI:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9FA78.3D0DF07A
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi kernel hackers,

Here is a patch that adds support to the Linux kernel for Analog
Device's ADXL345 chip.  It is an accelerometer that uses I2C and HWMON.
When I looked into the MAINTAINERS file for the appropriate list, the
"Orphan" status of "Hardware Monitoring" confused me as to the proper
list for this patch ... please let me know if I need to forward it
elsewhere.

ALPHA Warning: THIS CODE COMPILES WITHOUT ERROR, BUT HAS NOT BEEN TESTED
YET.

I'd appreciate feedback from those who have the time/interest to help!
Code review would be great, someone with hardware for testing would be
excellent.

Thanks,
Chris


--- PATCH BELOW ---

Signed-off-by: Chris Verges <chrisv@cyberswitching.com>
Index: drivers/hwmon/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.29.3-orig/drivers/hwmon/Makefile	(revision 33)
+++ linux-2.6.29.3/drivers/hwmon/Makefile	(revision 49)
@@ -29,6 +29,7 @@
 obj-$(CONFIG_SENSORS_ADT7470)	+=3D adt7470.o
 obj-$(CONFIG_SENSORS_ADT7473)	+=3D adt7473.o
 obj-$(CONFIG_SENSORS_ADT7475)	+=3D adt7475.o
+obj-$(CONFIG_SENSORS_ADXL345)	+=3D adxl345.o
=20
 obj-$(CONFIG_SENSORS_APPLESMC)	+=3D applesmc.o
 obj-$(CONFIG_SENSORS_AMS)	+=3D ams/
Index: drivers/hwmon/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.29.3-orig/drivers/hwmon/Kconfig	(revision 33)
+++ linux-2.6.29.3/drivers/hwmon/Kconfig	(revision 49)
@@ -199,6 +199,16 @@
 	  This driver can also be build as a module.  If so, the module
 	  will be called adt7475.
=20
+config SENSORS_ADXL345
+	tristate "Analog Devices ADXL345"
+	depends on I2C && EXPERIMENTAL
+	help
+	  If you say yes here, you get support for the Analog Devices
+	  ADXL345 digital accelerometer chip.
+
+	  This driver can also be build as a module.  If so, the module
+	  will be called adxl345.
+
 config SENSORS_K8TEMP
 	tristate "AMD Athlon64/FX or Opteron temperature sensor"
 	depends on X86 && PCI && EXPERIMENTAL
Index: drivers/hwmon/adxl345.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.29.3-orig/drivers/hwmon/adxl345.c	(revision 0)
+++ linux-2.6.29.3/drivers/hwmon/adxl345.c	(revision 49)
@@ -0,0 +1,521 @@
+/*
+ * A hwmon driver for the Analog Devices ADXL345
+ *
+ * Copyright (c) 2009 Cyber Switching, Inc.
+ * Author: Robert Mehranfar <robertme@earthlink.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+#include <linux/i2c.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/hwmon-vid.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/kernel.h>
+
+#define DRV_NAME	"adxl345"
+#define DRV_VERSION	"0.1"
+
+#define SIMULATE 1
+
+/*
+ * The ADXL345 registers
+ */
+#define ADXL345_REG_DEV_ID		0x00
+#define ADXL345_REG_OFS(nr)		(0x1E + (nr))
+#define ADXL345_REG_DATA(nr)		(0x32 + (nr))
+#define ADXL345_REG_DATA_FORMAT		0x31
+
+/*
+ * See ADXL345 specification
+ */
+#define OFFSET_SCALE_FACTOR_WHOLE 15
+#define OFFSET_SCALE_FACTOR_FRACTIONAL 6
+
+#define MAX_OFFSET 1988
+#define MIN_OFFSET -1998
+
+/*
+ * Based on 10-bit resolution +/-16 range set in the DATA FORMAT
register
+ */
+#define DATA_SCALE_FACTOR_WHOLE 15
+#define DATA_SCALE_FACTOR_FRACTIONAL 6
+#define NUMBER_OF_AXES 3
+
+#define X_AXIS 0
+#define Y_AXIS 1
+#define Z_AXIS 2
+
+/* Position in the sysfs attribute array */
+#define X_AXIS_ATTR 0
+#define Y_AXIS_ATTR 1
+#define Z_AXIS_ATTR 2
+#define DATA_ATTR 3
+
+/*
+ * Functions declaration
+ */
+static void adxl345_init_client(struct i2c_client *client);
+static struct adxl345_data *adxl345_update_device(struct device *dev);
+static void convert_to_fraction(s16 data, u8 whole_scale, u8
fraction_scale,
+					int *decimal, int *fraction);
+
+/*
+ * Client data (each client gets its own)
+ */
+struct adxl345_data {
+	struct i2c_client	client;
+	struct device		*hwmon_dev;
+	struct mutex		update_lock;	/* lock on the structure
*/
+	char			valid;		/* 0 until below are
valid */
+	unsigned long		last_updated;	/* in jiffies */
+
+	/*
+	 * ADXL345 Data
+	 * In two's complement, data coming in from or going out to
user-space
+	 * must be converted.
+	 */
+	u8			offset[NUMBER_OF_AXES];
+	u16			data[NUMBER_OF_AXES];
+};
+
+
+/*
+ * Converts internal data to a decimal-fraction value.
+ * Notes: Must already be converted out of twos complement
+ *
+ * @param data  Data to be converted
+ * @param whole_scale Scale factor for whole number part. (Set to 1 for
no scaling).
+ * @param fraction_scale Scale factor for fractional number part. (Set
to 1 for no scaling).
+ * @param decimal Pointer to location to store decimal part.
+ * @param fraction Pointer to location to store fractional part.
+ */
+static void convert_to_fraction(s16 data, u8 whole_scale, u8
fraction_scale,
+					int *decimal, int *fraction)
+{
+	int temp_decimal, temp_fraction, temp;
+	int sign =3D 1;
+
+	/* Scale the decimal and fractional parts */
+	temp_decimal =3D data * whole_scale * 10;
+	temp_fraction =3D data * fraction_scale;
+
+	/* get rid of the sign for negative fractions */
+	if (temp_fraction < 0) {
+		sign =3D -1;
+		temp_fraction *=3D sign;
+	}
+
+	/* If necessary, carry */
+	if (temp_fraction >=3D 10) {
+		/* Add to the decimal part */
+		temp_decimal +=3D sign * temp_fraction;
+
+		/* Amount to be subtracted from the fractional part */
+		temp =3D temp_fraction / 10;
+
+		temp_fraction -=3D temp * 10;
+	}
+
+	temp_decimal /=3D 10;
+
+	/*
+	 * If at least 10 still remains in the fractional part, one
+	 * last carry
+	 */
+	if (temp_fraction >=3D 10) {
+		temp_decimal +=3D sign;
+		temp_fraction -=3D 10;
+	}
+
+	/* Pass the values up */
+	*decimal =3D temp_decimal;
+	*fraction =3D temp_fraction;
+}
+
+/*
+ * Called in response to cat ofs(x,y,z) in sysfs
+ *
+ * @param dev Pointer to device
+ * @param attr Pointer to the device attributes
+ * @param buf Pointer to string shown in user space
+ * @return Number of chars copied to buffer
+*/
+static ssize_t show_offset(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	int index =3D to_sensor_dev_attr(attr)->index;
+	struct adxl345_data *data =3D adxl345_update_device(dev);
+	int decimal, fraction;
+	s8 temp_data;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	/* Convert from 2's complement */
+	temp_data =3D ~(data->offset[index] - 1);
+
+	dev_dbg(dev, "temp_data=3D%d\n", temp_data);
+
+	convert_to_fraction(temp_data,
+			OFFSET_SCALE_FACTOR_WHOLE,
+			OFFSET_SCALE_FACTOR_FRACTIONAL,
+			&decimal,
+			&fraction);
+
+	return snprintf(buf, PAGE_SIZE,
+			"%4d.%1d\n", decimal, fraction);
+}
+
+/*
+ * Called in response to echoing data to ofs(x,y,z) in sysfs
+ * Note: Input range is -1998 to 1998 milli-g's
+ *
+ * @param dev Pointer to device
+ * @param attr Pointer to the device attributes
+ * @param buf Pointer to string passed in from user space
+ * @param count Number of chars passed in from user space..
+ * @return Number of chars passed in from user space.
+ */
+static ssize_t set_offset(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t count)
+{
+	int index =3D to_sensor_dev_attr(attr)->index;
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct adxl345_data *data =3D i2c_get_clientdata(client);
+	long val;
+	long temp_val;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	if (!strict_strtol(buf, 10, &val)) {
+		dev_dbg(dev, "error in converting string '%s' to
long\n",
+				buf);
+		return 0;
+	}
+
+	/* If outside offset range, clip to max or min value */
+	if (val < MIN_OFFSET)
+		val =3D MIN_OFFSET;
+	else if (val > MAX_OFFSET)
+		val =3D MAX_OFFSET;
+
+	temp_val =3D (val * 100) %
+			((OFFSET_SCALE_FACTOR_WHOLE * 100) +
+			(OFFSET_SCALE_FACTOR_FRACTIONAL * 10));
+	if (temp_val < 0)
+		temp_val *=3D -1;
+
+	/* Get rid of scale for internal storage */
+	val =3D (val * 100) /
+			((OFFSET_SCALE_FACTOR_WHOLE * 100) +
+			(OFFSET_SCALE_FACTOR_FRACTIONAL * 10));
+
+	if (temp_val > (OFFSET_SCALE_FACTOR_WHOLE * 100) / 2 && val > 0)
+		++val;
+	else if (temp_val > (OFFSET_SCALE_FACTOR_WHOLE * 100) / 2 && val
< 0)
+		--val;
+
+	val =3D ~val + 1;  /* convert to two's complement */
+
+	mutex_lock(&data->update_lock);
+
+	data->offset[index] =3D val;
+
+	dev_dbg(dev, "offset[%d]=3D%d\n", index, data->offset[index]);
+
+	/* Write the avlue to the chip via I2C */
+	i2c_smbus_write_byte_data(client,
+			ADXL345_REG_OFS(index),
+			data->offset[index]);
+
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+
+/*
+ * Called in response to cat data in sysfs
+ *
+ * @param dev Pointer to device
+ * @param attr Pointer to the device attributes
+ * @param buf Pointer to string shown in user space
+ * @return Number of chars copied to buffer
+*/
+static ssize_t show_data(struct device *dev, struct device_attribute
*attr,
+				char *buf)
+{
+	int i;
+	s16 temp_data;
+	int decimal[NUMBER_OF_AXES], fraction[NUMBER_OF_AXES];
+
+	struct adxl345_data *data =3D adxl345_update_device(dev);
+
+	/* Convert x,y,z values */
+	for (i =3D 0; i < NUMBER_OF_AXES; i++) {
+		/* Convert from 2's complement */
+		temp_data =3D ~(data->data[i] - 1);
+
+		convert_to_fraction(temp_data,
+				DATA_SCALE_FACTOR_WHOLE,
+				DATA_SCALE_FACTOR_FRACTIONAL,
+				&decimal[i],
+				&fraction[i]);
+	}
+
+	return snprintf(buf, PAGE_SIZE,
+			"x:%5d.%1d y:%5d.%1d z:%5d.%1d\n",
+			decimal[X_AXIS], fraction[X_AXIS],
+			decimal[Y_AXIS], fraction[Y_AXIS],
+			decimal[Z_AXIS], fraction[Z_AXIS]);
+}
+
+/*  Attributes of the sysfs entries */
+static SENSOR_DEVICE_ATTR(ofsx, S_IWUSR | S_IRUGO,
+				show_offset, set_offset, X_AXIS_ATTR);
+static SENSOR_DEVICE_ATTR(ofsy, S_IWUSR | S_IRUGO,
+				show_offset, set_offset, Y_AXIS_ATTR);
+static SENSOR_DEVICE_ATTR(ofsz, S_IWUSR | S_IRUGO,
+				show_offset, set_offset, Z_AXIS_ATTR);
+static SENSOR_DEVICE_ATTR(data, S_IRUGO,
+				show_data, NULL, DATA_ATTR);
+
+static struct attribute *adxl345_attributes[] =3D {
+	&sensor_dev_attr_ofsx.dev_attr.attr,
+	&sensor_dev_attr_ofsy.dev_attr.attr,
+	&sensor_dev_attr_ofsz.dev_attr.attr,
+	&sensor_dev_attr_data.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group adxl345_group =3D {
+	.attrs =3D adxl345_attributes,
+};
+
+/*
+ * Initialize the chip
+ *
+ * @param client Pointer to the client structure
+ */
+static void adxl345_init_client(struct i2c_client *client)
+{
+	dev_dbg(&client->dev, "%s\n", __func__);
+
+	/*
+	 * Set up the device, No self test, Dont care about SPI or
+	 * interrupt, 10 bit resoltion, +/- 16g range
+	 */
+	i2c_smbus_write_byte_data(client, ADXL345_REG_DATA_FORMAT,
0x03);
+}
+
+/*
+ * Does more than just detection. If detection succeeds, it also
+ * registers the new chip.
+ *
+ * @param adapter Pointer to the adapter
+ * @param address I2C address
+ * @return Zero, upon success
+ */
+static int adxl345_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct adxl345_data *data;
+	int err =3D 0;
+	u8 dev_id;
+
+	dev_dbg(&client->dev, "%s\n", __func__);
+
+	if (!i2c_check_functionality(client->adapter,
I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	data =3D kzalloc(sizeof(struct adxl345_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, data);
+
+	#ifdef SIMULATE
+	dev_id =3D 0xE5; /* Spoof the Analog Devices device ID */
+	dev_dbg(&client->dev, "Simulating ADXL345 device\n");
+	#else
+	dev_id =3D i2c_smbus_read_byte_data(client, ADXL345_REG_DEV_ID);
+	#endif
+
+	/* If the chip is not from Analog Devices, report an error */
+	if (dev_id !=3D 0xE5) {
+		dev_err(&client->dev, "Unsupported chip
(dev_id=3D0x%02X)\n",
+				dev_id);
+		err =3D -EINVAL;
+		goto err_free_mem;
+	}
+
+	dev_info(&client->dev, "chip found, driver version "
+			DRV_VERSION "\n");
+
+	/* We can fill in the remaining client fields */
+	mutex_init(&data->update_lock);
+
+	/* Initialize the ADXL345 chip */
+	adxl345_init_client(client);
+
+	/* Register sysfs hooks */
+	err =3D sysfs_create_group(&client->dev.kobj, &adxl345_group);
+	if (err)
+		goto err_free_mem;
+
+	data->hwmon_dev =3D hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err =3D PTR_ERR(data->hwmon_dev);
+		goto err_remove;
+	}
+
+	return 0;
+
+err_remove:
+	sysfs_remove_group(&client->dev.kobj, &adxl345_group);
+err_free_mem:
+	kfree(data);
+
+	return err;
+}
+
+/*
+ * Unregister device, remove the sysfs entries, and detach the client
+ * from I2C bus.
+ *
+ * @param client Pointer to the client structure
+ * @return Zero, upon success.
+ */
+static int adxl345_remove(struct i2c_client *client)
+{
+	struct adxl345_data *data =3D i2c_get_clientdata(client);
+
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &adxl345_group);
+
+	i2c_unregister_device(client);
+
+	kfree(data);
+
+	return 0;
+}
+
+/*
+ * Gets the data from the chip.
+ *
+ * @param client Pointer to the device
+ * @return Pointer to structure containing the data
+ */
+static struct adxl345_data *adxl345_update_device(struct device *dev)
+{
+	struct i2c_client *client =3D to_i2c_client(dev);
+	struct adxl345_data *data =3D i2c_get_clientdata(client);
+	int i;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	mutex_lock(&data->update_lock);
+
+	/*
+	 * This delay is 500ms, based on a default value of 100 for HZ
+	 * in ARM kernels
+	 */
+	if (time_after(jiffies, data->last_updated + HZ * 50) ||
+		!data->valid) {
+		for (i =3D 0; i < NUMBER_OF_AXES; i++) {
+			data->offset[i] =3D
i2c_smbus_read_byte_data(client,
+						ADXL345_REG_OFS(i));
+			dev_dbg(dev, "offset[%d]=3D%d\n", i,
data->offset[i]);
+		}
+
+		/*
+		 * Concatenate the data from each register pair
+		 * Indexing logic is needed as per ADXL345 spec, LSB is
first
+		 * INDEX(reg)  LSB  MSB
+		 *     0        0    1
+		 *     1        2    3
+		 *     2        4    5
+		 */
+		for (i =3D 0; i < NUMBER_OF_AXES; i++) {
+			/* Get the MSB, shift by 8, and then get the LSB
*/
+			data->data[i] =3D i2c_smbus_read_byte_data(client,
+						ADXL345_REG_DATA(i*2+1))
<< 8;
+			data->data[i] |=3D
i2c_smbus_read_byte_data(client,
+						ADXL345_REG_DATA(i*2));
+
+			dev_dbg(dev, "data[%d]=3D%d\n", i, data->data[i]);
+		}
+
+		data->last_updated =3D jiffies;
+		data->valid =3D 1;
+	}
+
+	mutex_unlock(&data->update_lock);
+
+	return data;
+}
+
+/*
+ * Driver data (common to all clients)
+ */
+
+static const struct i2c_device_id adxl345_id[] =3D {
+	{ "adxl345", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, adxl345_id);
+
+static struct i2c_driver adxl345_driver =3D {
+	.driver =3D {
+		.name	=3D DRV_NAME,
+	},
+	.probe		=3D adxl345_probe,
+	.remove		=3D adxl345_remove,
+	.id_table	=3D adxl345_id,
+};
+
+/*
+ * Initialize the module
+ *
+ * @return Zero, upon success
+ */
+static int __init adxl345_init(void)
+{
+	return i2c_add_driver(&adxl345_driver);
+}
+
+/*
+ * Remove the module
+ */
+static void __exit adxl345_exit(void)
+{
+	i2c_del_driver(&adxl345_driver);
+}
+
+MODULE_AUTHOR("Robert Mehranfar <robertme@earthlink.net>");
+MODULE_DESCRIPTION("Analog Devices ADXL345 driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+module_init(adxl345_init);
+module_exit(adxl345_exit);

------_=_NextPart_001_01C9FA78.3D0DF07A
Content-Type: application/octet-stream;
	name="adxl345.patch"
Content-Transfer-Encoding: base64
Content-Description: adxl345.patch
Content-Disposition: attachment;
	filename="adxl345.patch"

U2lnbmVkLW9mZi1ieTogQ2hyaXMgVmVyZ2VzIDxjaHJpc3ZAY3liZXJzd2l0Y2hpbmcuY29tPgpJ
bmRleDogZHJpdmVycy9od21vbi9NYWtlZmlsZQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjku
My1vcmlnL2RyaXZlcnMvaHdtb24vTWFrZWZpbGUJKHJldmlzaW9uIDMzKQorKysgbGludXgtMi42
LjI5LjMvZHJpdmVycy9od21vbi9NYWtlZmlsZQkocmV2aXNpb24gNDkpCkBAIC0yOSw2ICsyOSw3
IEBACiBvYmotJChDT05GSUdfU0VOU09SU19BRFQ3NDcwKQkrPSBhZHQ3NDcwLm8KIG9iai0kKENP
TkZJR19TRU5TT1JTX0FEVDc0NzMpCSs9IGFkdDc0NzMubwogb2JqLSQoQ09ORklHX1NFTlNPUlNf
QURUNzQ3NSkJKz0gYWR0NzQ3NS5vCitvYmotJChDT05GSUdfU0VOU09SU19BRFhMMzQ1KQkrPSBh
ZHhsMzQ1Lm8KIAogb2JqLSQoQ09ORklHX1NFTlNPUlNfQVBQTEVTTUMpCSs9IGFwcGxlc21jLm8K
IG9iai0kKENPTkZJR19TRU5TT1JTX0FNUykJKz0gYW1zLwpJbmRleDogZHJpdmVycy9od21vbi9L
Y29uZmlnCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yOS4zLW9yaWcvZHJpdmVycy9od21vbi9L
Y29uZmlnCShyZXZpc2lvbiAzMykKKysrIGxpbnV4LTIuNi4yOS4zL2RyaXZlcnMvaHdtb24vS2Nv
bmZpZwkocmV2aXNpb24gNDkpCkBAIC0xOTksNiArMTk5LDE2IEBACiAJICBUaGlzIGRyaXZlciBj
YW4gYWxzbyBiZSBidWlsZCBhcyBhIG1vZHVsZS4gIElmIHNvLCB0aGUgbW9kdWxlCiAJICB3aWxs
IGJlIGNhbGxlZCBhZHQ3NDc1LgogCitjb25maWcgU0VOU09SU19BRFhMMzQ1CisJdHJpc3RhdGUg
IkFuYWxvZyBEZXZpY2VzIEFEWEwzNDUiCisJZGVwZW5kcyBvbiBJMkMgJiYgRVhQRVJJTUVOVEFM
CisJaGVscAorCSAgSWYgeW91IHNheSB5ZXMgaGVyZSwgeW91IGdldCBzdXBwb3J0IGZvciB0aGUg
QW5hbG9nIERldmljZXMKKwkgIEFEWEwzNDUgZGlnaXRhbCBhY2NlbGVyb21ldGVyIGNoaXAuCisK
KwkgIFRoaXMgZHJpdmVyIGNhbiBhbHNvIGJlIGJ1aWxkIGFzIGEgbW9kdWxlLiAgSWYgc28sIHRo
ZSBtb2R1bGUKKwkgIHdpbGwgYmUgY2FsbGVkIGFkeGwzNDUuCisKIGNvbmZpZyBTRU5TT1JTX0s4
VEVNUAogCXRyaXN0YXRlICJBTUQgQXRobG9uNjQvRlggb3IgT3B0ZXJvbiB0ZW1wZXJhdHVyZSBz
ZW5zb3IiCiAJZGVwZW5kcyBvbiBYODYgJiYgUENJICYmIEVYUEVSSU1FTlRBTApJbmRleDogZHJp
dmVycy9od21vbi9hZHhsMzQ1LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42LjI5LjMtb3JpZy9k
cml2ZXJzL2h3bW9uL2FkeGwzNDUuYwkocmV2aXNpb24gMCkKKysrIGxpbnV4LTIuNi4yOS4zL2Ry
aXZlcnMvaHdtb24vYWR4bDM0NS5jCShyZXZpc2lvbiA0OSkKQEAgLTAsMCArMSw1MjEgQEAKKy8q
CisgKiBBIGh3bW9uIGRyaXZlciBmb3IgdGhlIEFuYWxvZyBEZXZpY2VzIEFEWEwzNDUKKyAqCisg
KiBDb3B5cmlnaHQgKGMpIDIwMDkgQ3liZXIgU3dpdGNoaW5nLCBJbmMuCisgKiBBdXRob3I6IFJv
YmVydCBNZWhyYW5mYXIgPHJvYmVydG1lQGVhcnRobGluay5uZXQ+CisgKgorICogVGhpcyBwcm9n
cmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2Rp
ZnkKKyAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vu
c2UgYXMgcHVibGlzaGVkIGJ5CisgKiB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRo
ZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvcgorICogKGF0IHlvdXIgb3B0aW9uKSBhbnkg
bGF0ZXIgdmVyc2lvbi4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhl
IGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwKKyAqIGJ1dCBXSVRIT1VUIEFOWSBXQVJSQU5U
WTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mCisgKiBNRVJDSEFOVEFCSUxJ
VFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlCisgKiBHTlUg
R2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgorICoKKyAqIFlvdSBzaG91
bGQgaGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
CisgKiBhbG9uZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBT
b2Z0d2FyZQorICogRm91bmRhdGlvbiwgSW5jLiwgNjc1IE1hc3MgQXZlLCBDYW1icmlkZ2UsIE1B
IDAyMTM5LCBVU0EuCisgKi8KKworI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgorI2luY2x1ZGUg
PGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CisjaW5jbHVkZSA8bGludXgv
amlmZmllcy5oPgorI2luY2x1ZGUgPGxpbnV4L2kyYy5oPgorI2luY2x1ZGUgPGxpbnV4L2h3bW9u
Lmg+CisjaW5jbHVkZSA8bGludXgvaHdtb24tc3lzZnMuaD4KKyNpbmNsdWRlIDxsaW51eC9od21v
bi12aWQuaD4KKyNpbmNsdWRlIDxsaW51eC9lcnIuaD4KKyNpbmNsdWRlIDxsaW51eC9tdXRleC5o
PgorI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorCisjZGVmaW5lIERSVl9OQU1FCSJhZHhsMzQ1
IgorI2RlZmluZSBEUlZfVkVSU0lPTgkiMC4xIgorCisjZGVmaW5lIFNJTVVMQVRFIDEKKworLyoK
KyAqIFRoZSBBRFhMMzQ1IHJlZ2lzdGVycworICovCisjZGVmaW5lIEFEWEwzNDVfUkVHX0RFVl9J
RAkJMHgwMAorI2RlZmluZSBBRFhMMzQ1X1JFR19PRlMobnIpCQkoMHgxRSArIChucikpCisjZGVm
aW5lIEFEWEwzNDVfUkVHX0RBVEEobnIpCQkoMHgzMiArIChucikpCisjZGVmaW5lIEFEWEwzNDVf
UkVHX0RBVEFfRk9STUFUCQkweDMxCisKKy8qCisgKiBTZWUgQURYTDM0NSBzcGVjaWZpY2F0aW9u
CisgKi8KKyNkZWZpbmUgT0ZGU0VUX1NDQUxFX0ZBQ1RPUl9XSE9MRSAxNQorI2RlZmluZSBPRkZT
RVRfU0NBTEVfRkFDVE9SX0ZSQUNUSU9OQUwgNgorCisjZGVmaW5lIE1BWF9PRkZTRVQgMTk4OAor
I2RlZmluZSBNSU5fT0ZGU0VUIC0xOTk4CisKKy8qCisgKiBCYXNlZCBvbiAxMC1iaXQgcmVzb2x1
dGlvbiArLy0xNiByYW5nZSBzZXQgaW4gdGhlIERBVEEgRk9STUFUIHJlZ2lzdGVyCisgKi8KKyNk
ZWZpbmUgREFUQV9TQ0FMRV9GQUNUT1JfV0hPTEUgMTUKKyNkZWZpbmUgREFUQV9TQ0FMRV9GQUNU
T1JfRlJBQ1RJT05BTCA2CisjZGVmaW5lIE5VTUJFUl9PRl9BWEVTIDMKKworI2RlZmluZSBYX0FY
SVMgMAorI2RlZmluZSBZX0FYSVMgMQorI2RlZmluZSBaX0FYSVMgMgorCisvKiBQb3NpdGlvbiBp
biB0aGUgc3lzZnMgYXR0cmlidXRlIGFycmF5ICovCisjZGVmaW5lIFhfQVhJU19BVFRSIDAKKyNk
ZWZpbmUgWV9BWElTX0FUVFIgMQorI2RlZmluZSBaX0FYSVNfQVRUUiAyCisjZGVmaW5lIERBVEFf
QVRUUiAzCisKKy8qCisgKiBGdW5jdGlvbnMgZGVjbGFyYXRpb24KKyAqLworc3RhdGljIHZvaWQg
YWR4bDM0NV9pbml0X2NsaWVudChzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50KTsKK3N0YXRpYyBz
dHJ1Y3QgYWR4bDM0NV9kYXRhICphZHhsMzQ1X3VwZGF0ZV9kZXZpY2Uoc3RydWN0IGRldmljZSAq
ZGV2KTsKK3N0YXRpYyB2b2lkIGNvbnZlcnRfdG9fZnJhY3Rpb24oczE2IGRhdGEsIHU4IHdob2xl
X3NjYWxlLCB1OCBmcmFjdGlvbl9zY2FsZSwKKwkJCQkJaW50ICpkZWNpbWFsLCBpbnQgKmZyYWN0
aW9uKTsKKworLyoKKyAqIENsaWVudCBkYXRhIChlYWNoIGNsaWVudCBnZXRzIGl0cyBvd24pCisg
Ki8KK3N0cnVjdCBhZHhsMzQ1X2RhdGEgeworCXN0cnVjdCBpMmNfY2xpZW50CWNsaWVudDsKKwlz
dHJ1Y3QgZGV2aWNlCQkqaHdtb25fZGV2OworCXN0cnVjdCBtdXRleAkJdXBkYXRlX2xvY2s7CS8q
IGxvY2sgb24gdGhlIHN0cnVjdHVyZSAqLworCWNoYXIJCQl2YWxpZDsJCS8qIDAgdW50aWwgYmVs
b3cgYXJlIHZhbGlkICovCisJdW5zaWduZWQgbG9uZwkJbGFzdF91cGRhdGVkOwkvKiBpbiBqaWZm
aWVzICovCisKKwkvKgorCSAqIEFEWEwzNDUgRGF0YQorCSAqIEluIHR3bydzIGNvbXBsZW1lbnQs
IGRhdGEgY29taW5nIGluIGZyb20gb3IgZ29pbmcgb3V0IHRvIHVzZXItc3BhY2UKKwkgKiBtdXN0
IGJlIGNvbnZlcnRlZC4KKwkgKi8KKwl1OAkJCW9mZnNldFtOVU1CRVJfT0ZfQVhFU107CisJdTE2
CQkJZGF0YVtOVU1CRVJfT0ZfQVhFU107Cit9OworCisKKy8qCisgKiBDb252ZXJ0cyBpbnRlcm5h
bCBkYXRhIHRvIGEgZGVjaW1hbC1mcmFjdGlvbiB2YWx1ZS4KKyAqIE5vdGVzOiBNdXN0IGFscmVh
ZHkgYmUgY29udmVydGVkIG91dCBvZiB0d29zIGNvbXBsZW1lbnQKKyAqCisgKiBAcGFyYW0gZGF0
YSAgRGF0YSB0byBiZSBjb252ZXJ0ZWQKKyAqIEBwYXJhbSB3aG9sZV9zY2FsZSBTY2FsZSBmYWN0
b3IgZm9yIHdob2xlIG51bWJlciBwYXJ0LiAoU2V0IHRvIDEgZm9yIG5vIHNjYWxpbmcpLgorICog
QHBhcmFtIGZyYWN0aW9uX3NjYWxlIFNjYWxlIGZhY3RvciBmb3IgZnJhY3Rpb25hbCBudW1iZXIg
cGFydC4gKFNldCB0byAxIGZvciBubyBzY2FsaW5nKS4KKyAqIEBwYXJhbSBkZWNpbWFsIFBvaW50
ZXIgdG8gbG9jYXRpb24gdG8gc3RvcmUgZGVjaW1hbCBwYXJ0LgorICogQHBhcmFtIGZyYWN0aW9u
IFBvaW50ZXIgdG8gbG9jYXRpb24gdG8gc3RvcmUgZnJhY3Rpb25hbCBwYXJ0LgorICovCitzdGF0
aWMgdm9pZCBjb252ZXJ0X3RvX2ZyYWN0aW9uKHMxNiBkYXRhLCB1OCB3aG9sZV9zY2FsZSwgdTgg
ZnJhY3Rpb25fc2NhbGUsCisJCQkJCWludCAqZGVjaW1hbCwgaW50ICpmcmFjdGlvbikKK3sKKwlp
bnQgdGVtcF9kZWNpbWFsLCB0ZW1wX2ZyYWN0aW9uLCB0ZW1wOworCWludCBzaWduID0gMTsKKwor
CS8qIFNjYWxlIHRoZSBkZWNpbWFsIGFuZCBmcmFjdGlvbmFsIHBhcnRzICovCisJdGVtcF9kZWNp
bWFsID0gZGF0YSAqIHdob2xlX3NjYWxlICogMTA7CisJdGVtcF9mcmFjdGlvbiA9IGRhdGEgKiBm
cmFjdGlvbl9zY2FsZTsKKworCS8qIGdldCByaWQgb2YgdGhlIHNpZ24gZm9yIG5lZ2F0aXZlIGZy
YWN0aW9ucyAqLworCWlmICh0ZW1wX2ZyYWN0aW9uIDwgMCkgeworCQlzaWduID0gLTE7CisJCXRl
bXBfZnJhY3Rpb24gKj0gc2lnbjsKKwl9CisKKwkvKiBJZiBuZWNlc3NhcnksIGNhcnJ5ICovCisJ
aWYgKHRlbXBfZnJhY3Rpb24gPj0gMTApIHsKKwkJLyogQWRkIHRvIHRoZSBkZWNpbWFsIHBhcnQg
Ki8KKwkJdGVtcF9kZWNpbWFsICs9IHNpZ24gKiB0ZW1wX2ZyYWN0aW9uOworCisJCS8qIEFtb3Vu
dCB0byBiZSBzdWJ0cmFjdGVkIGZyb20gdGhlIGZyYWN0aW9uYWwgcGFydCAqLworCQl0ZW1wID0g
dGVtcF9mcmFjdGlvbiAvIDEwOworCisJCXRlbXBfZnJhY3Rpb24gLT0gdGVtcCAqIDEwOworCX0K
KworCXRlbXBfZGVjaW1hbCAvPSAxMDsKKworCS8qCisJICogSWYgYXQgbGVhc3QgMTAgc3RpbGwg
cmVtYWlucyBpbiB0aGUgZnJhY3Rpb25hbCBwYXJ0LCBvbmUKKwkgKiBsYXN0IGNhcnJ5CisJICov
CisJaWYgKHRlbXBfZnJhY3Rpb24gPj0gMTApIHsKKwkJdGVtcF9kZWNpbWFsICs9IHNpZ247CisJ
CXRlbXBfZnJhY3Rpb24gLT0gMTA7CisJfQorCisJLyogUGFzcyB0aGUgdmFsdWVzIHVwICovCisJ
KmRlY2ltYWwgPSB0ZW1wX2RlY2ltYWw7CisJKmZyYWN0aW9uID0gdGVtcF9mcmFjdGlvbjsKK30K
KworLyoKKyAqIENhbGxlZCBpbiByZXNwb25zZSB0byBjYXQgb2ZzKHgseSx6KSBpbiBzeXNmcwor
ICoKKyAqIEBwYXJhbSBkZXYgUG9pbnRlciB0byBkZXZpY2UKKyAqIEBwYXJhbSBhdHRyIFBvaW50
ZXIgdG8gdGhlIGRldmljZSBhdHRyaWJ1dGVzCisgKiBAcGFyYW0gYnVmIFBvaW50ZXIgdG8gc3Ry
aW5nIHNob3duIGluIHVzZXIgc3BhY2UKKyAqIEByZXR1cm4gTnVtYmVyIG9mIGNoYXJzIGNvcGll
ZCB0byBidWZmZXIKKyovCitzdGF0aWMgc3NpemVfdCBzaG93X29mZnNldChzdHJ1Y3QgZGV2aWNl
ICpkZXYsCisJCQkJc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsCisJCQkJY2hhciAqYnVm
KQoreworCWludCBpbmRleCA9IHRvX3NlbnNvcl9kZXZfYXR0cihhdHRyKS0+aW5kZXg7CisJc3Ry
dWN0IGFkeGwzNDVfZGF0YSAqZGF0YSA9IGFkeGwzNDVfdXBkYXRlX2RldmljZShkZXYpOworCWlu
dCBkZWNpbWFsLCBmcmFjdGlvbjsKKwlzOCB0ZW1wX2RhdGE7CisKKwlkZXZfZGJnKGRldiwgIiVz
XG4iLCBfX2Z1bmNfXyk7CisKKwkvKiBDb252ZXJ0IGZyb20gMidzIGNvbXBsZW1lbnQgKi8KKwl0
ZW1wX2RhdGEgPSB+KGRhdGEtPm9mZnNldFtpbmRleF0gLSAxKTsKKworCWRldl9kYmcoZGV2LCAi
dGVtcF9kYXRhPSVkXG4iLCB0ZW1wX2RhdGEpOworCisJY29udmVydF90b19mcmFjdGlvbih0ZW1w
X2RhdGEsCisJCQlPRkZTRVRfU0NBTEVfRkFDVE9SX1dIT0xFLAorCQkJT0ZGU0VUX1NDQUxFX0ZB
Q1RPUl9GUkFDVElPTkFMLAorCQkJJmRlY2ltYWwsCisJCQkmZnJhY3Rpb24pOworCisJcmV0dXJu
IHNucHJpbnRmKGJ1ZiwgUEFHRV9TSVpFLAorCQkJIiU0ZC4lMWRcbiIsIGRlY2ltYWwsIGZyYWN0
aW9uKTsKK30KKworLyoKKyAqIENhbGxlZCBpbiByZXNwb25zZSB0byBlY2hvaW5nIGRhdGEgdG8g
b2ZzKHgseSx6KSBpbiBzeXNmcworICogTm90ZTogSW5wdXQgcmFuZ2UgaXMgLTE5OTggdG8gMTk5
OCBtaWxsaS1nJ3MKKyAqCisgKiBAcGFyYW0gZGV2IFBvaW50ZXIgdG8gZGV2aWNlCisgKiBAcGFy
YW0gYXR0ciBQb2ludGVyIHRvIHRoZSBkZXZpY2UgYXR0cmlidXRlcworICogQHBhcmFtIGJ1ZiBQ
b2ludGVyIHRvIHN0cmluZyBwYXNzZWQgaW4gZnJvbSB1c2VyIHNwYWNlCisgKiBAcGFyYW0gY291
bnQgTnVtYmVyIG9mIGNoYXJzIHBhc3NlZCBpbiBmcm9tIHVzZXIgc3BhY2UuLgorICogQHJldHVy
biBOdW1iZXIgb2YgY2hhcnMgcGFzc2VkIGluIGZyb20gdXNlciBzcGFjZS4KKyAqLworc3RhdGlj
IHNzaXplX3Qgc2V0X29mZnNldChzdHJ1Y3QgZGV2aWNlICpkZXYsCisJCQkJc3RydWN0IGRldmlj
ZV9hdHRyaWJ1dGUgKmF0dHIsCisJCQkJY29uc3QgY2hhciAqYnVmLAorCQkJCXNpemVfdCBjb3Vu
dCkKK3sKKwlpbnQgaW5kZXggPSB0b19zZW5zb3JfZGV2X2F0dHIoYXR0ciktPmluZGV4OworCXN0
cnVjdCBpMmNfY2xpZW50ICpjbGllbnQgPSB0b19pMmNfY2xpZW50KGRldik7CisJc3RydWN0IGFk
eGwzNDVfZGF0YSAqZGF0YSA9IGkyY19nZXRfY2xpZW50ZGF0YShjbGllbnQpOworCWxvbmcgdmFs
OworCWxvbmcgdGVtcF92YWw7CisKKwlkZXZfZGJnKGRldiwgIiVzXG4iLCBfX2Z1bmNfXyk7CisK
KwlpZiAoIXN0cmljdF9zdHJ0b2woYnVmLCAxMCwgJnZhbCkpIHsKKwkJZGV2X2RiZyhkZXYsICJl
cnJvciBpbiBjb252ZXJ0aW5nIHN0cmluZyAnJXMnIHRvIGxvbmdcbiIsCisJCQkJYnVmKTsKKwkJ
cmV0dXJuIDA7CisJfQorCisJLyogSWYgb3V0c2lkZSBvZmZzZXQgcmFuZ2UsIGNsaXAgdG8gbWF4
IG9yIG1pbiB2YWx1ZSAqLworCWlmICh2YWwgPCBNSU5fT0ZGU0VUKQorCQl2YWwgPSBNSU5fT0ZG
U0VUOworCWVsc2UgaWYgKHZhbCA+IE1BWF9PRkZTRVQpCisJCXZhbCA9IE1BWF9PRkZTRVQ7CisK
Kwl0ZW1wX3ZhbCA9ICh2YWwgKiAxMDApICUKKwkJCSgoT0ZGU0VUX1NDQUxFX0ZBQ1RPUl9XSE9M
RSAqIDEwMCkgKworCQkJKE9GRlNFVF9TQ0FMRV9GQUNUT1JfRlJBQ1RJT05BTCAqIDEwKSk7CisJ
aWYgKHRlbXBfdmFsIDwgMCkKKwkJdGVtcF92YWwgKj0gLTE7CisKKwkvKiBHZXQgcmlkIG9mIHNj
YWxlIGZvciBpbnRlcm5hbCBzdG9yYWdlICovCisJdmFsID0gKHZhbCAqIDEwMCkgLworCQkJKChP
RkZTRVRfU0NBTEVfRkFDVE9SX1dIT0xFICogMTAwKSArCisJCQkoT0ZGU0VUX1NDQUxFX0ZBQ1RP
Ul9GUkFDVElPTkFMICogMTApKTsKKworCWlmICh0ZW1wX3ZhbCA+IChPRkZTRVRfU0NBTEVfRkFD
VE9SX1dIT0xFICogMTAwKSAvIDIgJiYgdmFsID4gMCkKKwkJKyt2YWw7CisJZWxzZSBpZiAodGVt
cF92YWwgPiAoT0ZGU0VUX1NDQUxFX0ZBQ1RPUl9XSE9MRSAqIDEwMCkgLyAyICYmIHZhbCA8IDAp
CisJCS0tdmFsOworCisJdmFsID0gfnZhbCArIDE7ICAvKiBjb252ZXJ0IHRvIHR3bydzIGNvbXBs
ZW1lbnQgKi8KKworCW11dGV4X2xvY2soJmRhdGEtPnVwZGF0ZV9sb2NrKTsKKworCWRhdGEtPm9m
ZnNldFtpbmRleF0gPSB2YWw7CisKKwlkZXZfZGJnKGRldiwgIm9mZnNldFslZF09JWRcbiIsIGlu
ZGV4LCBkYXRhLT5vZmZzZXRbaW5kZXhdKTsKKworCS8qIFdyaXRlIHRoZSBhdmx1ZSB0byB0aGUg
Y2hpcCB2aWEgSTJDICovCisJaTJjX3NtYnVzX3dyaXRlX2J5dGVfZGF0YShjbGllbnQsCisJCQlB
RFhMMzQ1X1JFR19PRlMoaW5kZXgpLAorCQkJZGF0YS0+b2Zmc2V0W2luZGV4XSk7CisKKwltdXRl
eF91bmxvY2soJmRhdGEtPnVwZGF0ZV9sb2NrKTsKKworCXJldHVybiBjb3VudDsKK30KKworLyoK
KyAqIENhbGxlZCBpbiByZXNwb25zZSB0byBjYXQgZGF0YSBpbiBzeXNmcworICoKKyAqIEBwYXJh
bSBkZXYgUG9pbnRlciB0byBkZXZpY2UKKyAqIEBwYXJhbSBhdHRyIFBvaW50ZXIgdG8gdGhlIGRl
dmljZSBhdHRyaWJ1dGVzCisgKiBAcGFyYW0gYnVmIFBvaW50ZXIgdG8gc3RyaW5nIHNob3duIGlu
IHVzZXIgc3BhY2UKKyAqIEByZXR1cm4gTnVtYmVyIG9mIGNoYXJzIGNvcGllZCB0byBidWZmZXIK
KyovCitzdGF0aWMgc3NpemVfdCBzaG93X2RhdGEoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3Qg
ZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwKKwkJCQljaGFyICpidWYpCit7CisJaW50IGk7CisJczE2
IHRlbXBfZGF0YTsKKwlpbnQgZGVjaW1hbFtOVU1CRVJfT0ZfQVhFU10sIGZyYWN0aW9uW05VTUJF
Ul9PRl9BWEVTXTsKKworCXN0cnVjdCBhZHhsMzQ1X2RhdGEgKmRhdGEgPSBhZHhsMzQ1X3VwZGF0
ZV9kZXZpY2UoZGV2KTsKKworCS8qIENvbnZlcnQgeCx5LHogdmFsdWVzICovCisJZm9yIChpID0g
MDsgaSA8IE5VTUJFUl9PRl9BWEVTOyBpKyspIHsKKwkJLyogQ29udmVydCBmcm9tIDIncyBjb21w
bGVtZW50ICovCisJCXRlbXBfZGF0YSA9IH4oZGF0YS0+ZGF0YVtpXSAtIDEpOworCisJCWNvbnZl
cnRfdG9fZnJhY3Rpb24odGVtcF9kYXRhLAorCQkJCURBVEFfU0NBTEVfRkFDVE9SX1dIT0xFLAor
CQkJCURBVEFfU0NBTEVfRkFDVE9SX0ZSQUNUSU9OQUwsCisJCQkJJmRlY2ltYWxbaV0sCisJCQkJ
JmZyYWN0aW9uW2ldKTsKKwl9CisKKwlyZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsCisJ
CQkieDolNWQuJTFkIHk6JTVkLiUxZCB6OiU1ZC4lMWRcbiIsCisJCQlkZWNpbWFsW1hfQVhJU10s
IGZyYWN0aW9uW1hfQVhJU10sCisJCQlkZWNpbWFsW1lfQVhJU10sIGZyYWN0aW9uW1lfQVhJU10s
CisJCQlkZWNpbWFsW1pfQVhJU10sIGZyYWN0aW9uW1pfQVhJU10pOworfQorCisvKiAgQXR0cmli
dXRlcyBvZiB0aGUgc3lzZnMgZW50cmllcyAqLworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUihv
ZnN4LCBTX0lXVVNSIHwgU19JUlVHTywKKwkJCQlzaG93X29mZnNldCwgc2V0X29mZnNldCwgWF9B
WElTX0FUVFIpOworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRUUihvZnN5LCBTX0lXVVNSIHwgU19J
UlVHTywKKwkJCQlzaG93X29mZnNldCwgc2V0X29mZnNldCwgWV9BWElTX0FUVFIpOworc3RhdGlj
IFNFTlNPUl9ERVZJQ0VfQVRUUihvZnN6LCBTX0lXVVNSIHwgU19JUlVHTywKKwkJCQlzaG93X29m
ZnNldCwgc2V0X29mZnNldCwgWl9BWElTX0FUVFIpOworc3RhdGljIFNFTlNPUl9ERVZJQ0VfQVRU
UihkYXRhLCBTX0lSVUdPLAorCQkJCXNob3dfZGF0YSwgTlVMTCwgREFUQV9BVFRSKTsKKworc3Rh
dGljIHN0cnVjdCBhdHRyaWJ1dGUgKmFkeGwzNDVfYXR0cmlidXRlc1tdID0geworCSZzZW5zb3Jf
ZGV2X2F0dHJfb2ZzeC5kZXZfYXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfb2ZzeS5kZXZf
YXR0ci5hdHRyLAorCSZzZW5zb3JfZGV2X2F0dHJfb2Zzei5kZXZfYXR0ci5hdHRyLAorCSZzZW5z
b3JfZGV2X2F0dHJfZGF0YS5kZXZfYXR0ci5hdHRyLAorCU5VTEwKK307CisKK3N0YXRpYyBjb25z
dCBzdHJ1Y3QgYXR0cmlidXRlX2dyb3VwIGFkeGwzNDVfZ3JvdXAgPSB7CisJLmF0dHJzID0gYWR4
bDM0NV9hdHRyaWJ1dGVzLAorfTsKKworLyoKKyAqIEluaXRpYWxpemUgdGhlIGNoaXAKKyAqCisg
KiBAcGFyYW0gY2xpZW50IFBvaW50ZXIgdG8gdGhlIGNsaWVudCBzdHJ1Y3R1cmUKKyAqLworc3Rh
dGljIHZvaWQgYWR4bDM0NV9pbml0X2NsaWVudChzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50KQor
eworCWRldl9kYmcoJmNsaWVudC0+ZGV2LCAiJXNcbiIsIF9fZnVuY19fKTsKKworCS8qCisJICog
U2V0IHVwIHRoZSBkZXZpY2UsIE5vIHNlbGYgdGVzdCwgRG9udCBjYXJlIGFib3V0IFNQSSBvcgor
CSAqIGludGVycnVwdCwgMTAgYml0IHJlc29sdGlvbiwgKy8tIDE2ZyByYW5nZQorCSAqLworCWky
Y19zbWJ1c193cml0ZV9ieXRlX2RhdGEoY2xpZW50LCBBRFhMMzQ1X1JFR19EQVRBX0ZPUk1BVCwg
MHgwMyk7Cit9CisKKy8qCisgKiBEb2VzIG1vcmUgdGhhbiBqdXN0IGRldGVjdGlvbi4gSWYgZGV0
ZWN0aW9uIHN1Y2NlZWRzLCBpdCBhbHNvCisgKiByZWdpc3RlcnMgdGhlIG5ldyBjaGlwLgorICoK
KyAqIEBwYXJhbSBhZGFwdGVyIFBvaW50ZXIgdG8gdGhlIGFkYXB0ZXIKKyAqIEBwYXJhbSBhZGRy
ZXNzIEkyQyBhZGRyZXNzCisgKiBAcmV0dXJuIFplcm8sIHVwb24gc3VjY2VzcworICovCitzdGF0
aWMgaW50IGFkeGwzNDVfcHJvYmUoc3RydWN0IGkyY19jbGllbnQgKmNsaWVudCwKKwkJCQljb25z
dCBzdHJ1Y3QgaTJjX2RldmljZV9pZCAqaWQpCit7CisJc3RydWN0IGFkeGwzNDVfZGF0YSAqZGF0
YTsKKwlpbnQgZXJyID0gMDsKKwl1OCBkZXZfaWQ7CisKKwlkZXZfZGJnKCZjbGllbnQtPmRldiwg
IiVzXG4iLCBfX2Z1bmNfXyk7CisKKwlpZiAoIWkyY19jaGVja19mdW5jdGlvbmFsaXR5KGNsaWVu
dC0+YWRhcHRlciwgSTJDX0ZVTkNfU01CVVNfQllURV9EQVRBKSkKKwkJcmV0dXJuIC1FTk9ERVY7
CisKKwlkYXRhID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IGFkeGwzNDVfZGF0YSksIEdGUF9LRVJO
RUwpOworCWlmICghZGF0YSkKKwkJcmV0dXJuIC1FTk9NRU07CisKKwlpMmNfc2V0X2NsaWVudGRh
dGEoY2xpZW50LCBkYXRhKTsKKworCSNpZmRlZiBTSU1VTEFURQorCWRldl9pZCA9IDB4RTU7IC8q
IFNwb29mIHRoZSBBbmFsb2cgRGV2aWNlcyBkZXZpY2UgSUQgKi8KKwlkZXZfZGJnKCZjbGllbnQt
PmRldiwgIlNpbXVsYXRpbmcgQURYTDM0NSBkZXZpY2VcbiIpOworCSNlbHNlCisJZGV2X2lkID0g
aTJjX3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCwgQURYTDM0NV9SRUdfREVWX0lEKTsKKwkj
ZW5kaWYKKworCS8qIElmIHRoZSBjaGlwIGlzIG5vdCBmcm9tIEFuYWxvZyBEZXZpY2VzLCByZXBv
cnQgYW4gZXJyb3IgKi8KKwlpZiAoZGV2X2lkICE9IDB4RTUpIHsKKwkJZGV2X2VycigmY2xpZW50
LT5kZXYsICJVbnN1cHBvcnRlZCBjaGlwIChkZXZfaWQ9MHglMDJYKVxuIiwKKwkJCQlkZXZfaWQp
OworCQllcnIgPSAtRUlOVkFMOworCQlnb3RvIGVycl9mcmVlX21lbTsKKwl9CisKKwlkZXZfaW5m
bygmY2xpZW50LT5kZXYsICJjaGlwIGZvdW5kLCBkcml2ZXIgdmVyc2lvbiAiCisJCQlEUlZfVkVS
U0lPTiAiXG4iKTsKKworCS8qIFdlIGNhbiBmaWxsIGluIHRoZSByZW1haW5pbmcgY2xpZW50IGZp
ZWxkcyAqLworCW11dGV4X2luaXQoJmRhdGEtPnVwZGF0ZV9sb2NrKTsKKworCS8qIEluaXRpYWxp
emUgdGhlIEFEWEwzNDUgY2hpcCAqLworCWFkeGwzNDVfaW5pdF9jbGllbnQoY2xpZW50KTsKKwor
CS8qIFJlZ2lzdGVyIHN5c2ZzIGhvb2tzICovCisJZXJyID0gc3lzZnNfY3JlYXRlX2dyb3VwKCZj
bGllbnQtPmRldi5rb2JqLCAmYWR4bDM0NV9ncm91cCk7CisJaWYgKGVycikKKwkJZ290byBlcnJf
ZnJlZV9tZW07CisKKwlkYXRhLT5od21vbl9kZXYgPSBod21vbl9kZXZpY2VfcmVnaXN0ZXIoJmNs
aWVudC0+ZGV2KTsKKwlpZiAoSVNfRVJSKGRhdGEtPmh3bW9uX2RldikpIHsKKwkJZXJyID0gUFRS
X0VSUihkYXRhLT5od21vbl9kZXYpOworCQlnb3RvIGVycl9yZW1vdmU7CisJfQorCisJcmV0dXJu
IDA7CisKK2Vycl9yZW1vdmU6CisJc3lzZnNfcmVtb3ZlX2dyb3VwKCZjbGllbnQtPmRldi5rb2Jq
LCAmYWR4bDM0NV9ncm91cCk7CitlcnJfZnJlZV9tZW06CisJa2ZyZWUoZGF0YSk7CisKKwlyZXR1
cm4gZXJyOworfQorCisvKgorICogVW5yZWdpc3RlciBkZXZpY2UsIHJlbW92ZSB0aGUgc3lzZnMg
ZW50cmllcywgYW5kIGRldGFjaCB0aGUgY2xpZW50CisgKiBmcm9tIEkyQyBidXMuCisgKgorICog
QHBhcmFtIGNsaWVudCBQb2ludGVyIHRvIHRoZSBjbGllbnQgc3RydWN0dXJlCisgKiBAcmV0dXJu
IFplcm8sIHVwb24gc3VjY2Vzcy4KKyAqLworc3RhdGljIGludCBhZHhsMzQ1X3JlbW92ZShzdHJ1
Y3QgaTJjX2NsaWVudCAqY2xpZW50KQoreworCXN0cnVjdCBhZHhsMzQ1X2RhdGEgKmRhdGEgPSBp
MmNfZ2V0X2NsaWVudGRhdGEoY2xpZW50KTsKKworCWh3bW9uX2RldmljZV91bnJlZ2lzdGVyKGRh
dGEtPmh3bW9uX2Rldik7CisJc3lzZnNfcmVtb3ZlX2dyb3VwKCZjbGllbnQtPmRldi5rb2JqLCAm
YWR4bDM0NV9ncm91cCk7CisKKwlpMmNfdW5yZWdpc3Rlcl9kZXZpY2UoY2xpZW50KTsKKworCWtm
cmVlKGRhdGEpOworCisJcmV0dXJuIDA7Cit9CisKKy8qCisgKiBHZXRzIHRoZSBkYXRhIGZyb20g
dGhlIGNoaXAuCisgKgorICogQHBhcmFtIGNsaWVudCBQb2ludGVyIHRvIHRoZSBkZXZpY2UKKyAq
IEByZXR1cm4gUG9pbnRlciB0byBzdHJ1Y3R1cmUgY29udGFpbmluZyB0aGUgZGF0YQorICovCitz
dGF0aWMgc3RydWN0IGFkeGwzNDVfZGF0YSAqYWR4bDM0NV91cGRhdGVfZGV2aWNlKHN0cnVjdCBk
ZXZpY2UgKmRldikKK3sKKwlzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50ID0gdG9faTJjX2NsaWVu
dChkZXYpOworCXN0cnVjdCBhZHhsMzQ1X2RhdGEgKmRhdGEgPSBpMmNfZ2V0X2NsaWVudGRhdGEo
Y2xpZW50KTsKKwlpbnQgaTsKKworCWRldl9kYmcoZGV2LCAiJXNcbiIsIF9fZnVuY19fKTsKKwor
CW11dGV4X2xvY2soJmRhdGEtPnVwZGF0ZV9sb2NrKTsKKworCS8qCisJICogVGhpcyBkZWxheSBp
cyA1MDBtcywgYmFzZWQgb24gYSBkZWZhdWx0IHZhbHVlIG9mIDEwMCBmb3IgSFoKKwkgKiBpbiBB
Uk0ga2VybmVscworCSAqLworCWlmICh0aW1lX2FmdGVyKGppZmZpZXMsIGRhdGEtPmxhc3RfdXBk
YXRlZCArIEhaICogNTApIHx8CisJCSFkYXRhLT52YWxpZCkgeworCQlmb3IgKGkgPSAwOyBpIDwg
TlVNQkVSX09GX0FYRVM7IGkrKykgeworCQkJZGF0YS0+b2Zmc2V0W2ldID0gaTJjX3NtYnVzX3Jl
YWRfYnl0ZV9kYXRhKGNsaWVudCwKKwkJCQkJCUFEWEwzNDVfUkVHX09GUyhpKSk7CisJCQlkZXZf
ZGJnKGRldiwgIm9mZnNldFslZF09JWRcbiIsIGksIGRhdGEtPm9mZnNldFtpXSk7CisJCX0KKwor
CQkvKgorCQkgKiBDb25jYXRlbmF0ZSB0aGUgZGF0YSBmcm9tIGVhY2ggcmVnaXN0ZXIgcGFpcgor
CQkgKiBJbmRleGluZyBsb2dpYyBpcyBuZWVkZWQgYXMgcGVyIEFEWEwzNDUgc3BlYywgTFNCIGlz
IGZpcnN0CisJCSAqIElOREVYKHJlZykgIExTQiAgTVNCCisJCSAqICAgICAwICAgICAgICAwICAg
IDEKKwkJICogICAgIDEgICAgICAgIDIgICAgMworCQkgKiAgICAgMiAgICAgICAgNCAgICA1CisJ
CSAqLworCQlmb3IgKGkgPSAwOyBpIDwgTlVNQkVSX09GX0FYRVM7IGkrKykgeworCQkJLyogR2V0
IHRoZSBNU0IsIHNoaWZ0IGJ5IDgsIGFuZCB0aGVuIGdldCB0aGUgTFNCICovCisJCQlkYXRhLT5k
YXRhW2ldID0gaTJjX3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCwKKwkJCQkJCUFEWEwzNDVf
UkVHX0RBVEEoaSoyKzEpKSA8PCA4OworCQkJZGF0YS0+ZGF0YVtpXSB8PSBpMmNfc21idXNfcmVh
ZF9ieXRlX2RhdGEoY2xpZW50LAorCQkJCQkJQURYTDM0NV9SRUdfREFUQShpKjIpKTsKKworCQkJ
ZGV2X2RiZyhkZXYsICJkYXRhWyVkXT0lZFxuIiwgaSwgZGF0YS0+ZGF0YVtpXSk7CisJCX0KKwor
CQlkYXRhLT5sYXN0X3VwZGF0ZWQgPSBqaWZmaWVzOworCQlkYXRhLT52YWxpZCA9IDE7CisJfQor
CisJbXV0ZXhfdW5sb2NrKCZkYXRhLT51cGRhdGVfbG9jayk7CisKKwlyZXR1cm4gZGF0YTsKK30K
KworLyoKKyAqIERyaXZlciBkYXRhIChjb21tb24gdG8gYWxsIGNsaWVudHMpCisgKi8KKworc3Rh
dGljIGNvbnN0IHN0cnVjdCBpMmNfZGV2aWNlX2lkIGFkeGwzNDVfaWRbXSA9IHsKKwl7ICJhZHhs
MzQ1IiwgMCB9LAorCXsgfQorfTsKK01PRFVMRV9ERVZJQ0VfVEFCTEUoaTJjLCBhZHhsMzQ1X2lk
KTsKKworc3RhdGljIHN0cnVjdCBpMmNfZHJpdmVyIGFkeGwzNDVfZHJpdmVyID0geworCS5kcml2
ZXIgPSB7CisJCS5uYW1lCT0gRFJWX05BTUUsCisJfSwKKwkucHJvYmUJCT0gYWR4bDM0NV9wcm9i
ZSwKKwkucmVtb3ZlCQk9IGFkeGwzNDVfcmVtb3ZlLAorCS5pZF90YWJsZQk9IGFkeGwzNDVfaWQs
Cit9OworCisvKgorICogSW5pdGlhbGl6ZSB0aGUgbW9kdWxlCisgKgorICogQHJldHVybiBaZXJv
LCB1cG9uIHN1Y2Nlc3MKKyAqLworc3RhdGljIGludCBfX2luaXQgYWR4bDM0NV9pbml0KHZvaWQp
Cit7CisJcmV0dXJuIGkyY19hZGRfZHJpdmVyKCZhZHhsMzQ1X2RyaXZlcik7Cit9CisKKy8qCisg
KiBSZW1vdmUgdGhlIG1vZHVsZQorICovCitzdGF0aWMgdm9pZCBfX2V4aXQgYWR4bDM0NV9leGl0
KHZvaWQpCit7CisJaTJjX2RlbF9kcml2ZXIoJmFkeGwzNDVfZHJpdmVyKTsKK30KKworTU9EVUxF
X0FVVEhPUigiUm9iZXJ0IE1laHJhbmZhciA8cm9iZXJ0bWVAZWFydGhsaW5rLm5ldD4iKTsKK01P
RFVMRV9ERVNDUklQVElPTigiQW5hbG9nIERldmljZXMgQURYTDM0NSBkcml2ZXIiKTsKK01PRFVM
RV9MSUNFTlNFKCJHUEwiKTsKK01PRFVMRV9WRVJTSU9OKERSVl9WRVJTSU9OKTsKKworbW9kdWxl
X2luaXQoYWR4bDM0NV9pbml0KTsKK21vZHVsZV9leGl0KGFkeGwzNDVfZXhpdCk7Cg==

------_=_NextPart_001_01C9FA78.3D0DF07A--
