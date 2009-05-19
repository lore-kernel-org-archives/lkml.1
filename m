Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbZESGcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbZESGcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZESGcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:32:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51963 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZESGcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:32:10 -0400
Date: Tue, 19 May 2009 15:32:05 +0900
From: Kim Kyuwon <q1.kim@samsung.com>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
In-reply-to: <4A11344B.3000405@cam.ac.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: felipe.balbi@nokia.com, Kim Kyuwon <chammoru@gmail.com>,
       ext Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       "Gross, Mark" <mark.gross@intel.com>,
       jketreno <jketreno@linux.intel.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Message-id: <4A125265.6040509@samsung.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_rRuMZdt3V716HP9OgKWzlw)"
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <20090515131636.GE4443@nokia.com>
 <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com>
 <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com>
 <20090515200235.GA11829@nokia.com>
 <4d34a0a70905180045u6619773dt1563fe38b13d46fb@mail.gmail.com>
 <20090518091236.GH4443@nokia.com> <4A11344B.3000405@cam.ac.uk>
X-OriginalArrivalTime: 19 May 2009 06:32:05.0381 (UTC)
 FILETIME=[86E10350:01C9D84B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_rRuMZdt3V716HP9OgKWzlw)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

Hello Jonathan,

Jonathan Cameron wrote:
>>>> Yeah, let's try to define the best way to expose accelerometers with
>>>> linux kernel and avoid a sysfs hell. Better sooner than later.
>>> Felipe,
>>> Can I ask why did you say "avoid a sysfs hell"?. I have thought Kernel
>>> developers prefer sysfs to IOCTL lately.
>> For sure sysfs is prefered, but I meant that without a proper
>> abstraction or definition of how to export the device, each device
>> driver write will export sysfs nodes as they want and that's really bad
>> since we create the 'userland interface'. If it's messed up from the
>> beginning, it's gonna be like that for ages.
> This was very much one of the thinks IIO was designed to address.
> One thing to keep in mind is that the framework
> was not intended to replace input / hwmon if they are the appropriate places
> for a given driver. In fact one of the conclusions of the discussions linked
> above was that, in cases where an accelerometer (or other sensor) serves
> different purposes in different devices it may make sense to actually provide
> more than one kernel driver. (obviously sharing code where appropriate.

I can't understand this:
"in cases where an accelerometer (or other sensor) serves different 
purposes in different devices it may make sense to actually provide more 
than one kernel driver. (obviously sharing code where appropriate."
Was the conclusion "Make a framework(iio) which can do various functions?"

>>> input_allocate_polled_device, ...) and macros(ABS_X,  ABS_Y, ...)of
>>> Input subsystem are useful to accelerometer too. If we create another
>>> APIs and Macros for accelerometers, I think It's another duplicate
>>> work and result.
> beware of the fact that x,y,z aren't exactly cleanly defined for a given
> sensor!
>> for sure
> Agreed.  If you know a given accelerometer is only going to be used for
> input then that's where the driver belongs.  However, these chips are
> generally capable of a lot more and it tends to be annoying specific.
> Take for example things like calibration offsets, and for the really fun
> cases on chip event driven ring buffers?  These really don't fit into
> your classic input cases.

I can't understand why you inserted ring buffers related stuffs in iio. 
  Please let me understand in easy words. And please note that in 
/Documentation/SubmittingPatches

644 4) Don't over-design.
645
646 Don't try to anticipate nebulous future cases which may or may not
647 be useful:  "Make it as simple as you can, and no simpler."

>>> In conclusion,
>>> We need the inheritance concept in the object-oriented programming.
>>> Accelerometer device sometimes can be hwmon device, sometimes input
>>> device.
> I'd also argue the problem here is that you are going to end up with a
> large class of similar devices.  If you start directly adding accelerometers
> to Input then the same arguement applies to magnetometers, bend sensors,
> gyroscopes etc.

I already answer this issue in previous mail that I sent.

 > Also beware that many accelerometers are going to be wired
> up to adc's (rather than providing digital outputs) so you'll need some
> framework to specify this connectivity. (open area in IIO to and the moment).

I can't understand. Why we should make accelerometer(or sensor) 
framework relate to ADC? My two accelerometer are not in this cases. If 
really sensors are related to ADC, it's better make this as library or 
application. Why don't we to be simple. Please let me understand in easy 
words.

Let me ask a few question in conclusion.

1) Does your iio subsystem have all functions which attached kxsd9 
driver has? i.e.
a. works in polling mode
b. works in interrupt mode
c. provide an interface to user space in order setting a few parameters 
and read x, y, z variances.

2) How long will it take to your iio subsystem is merged into mainline?
I have quick review of you iio subsytem. Sorry but I think it' somewhat 
complicated and have a lot of functions which are still not needed. And 
it seems like your coding style doesn't look like Linux coding style 
that I'm familiar with.

I just hope we can add some accelerometer feature into mainline kernel 
as soon as possible ;)

Regards,
Kyuwon

--Boundary_(ID_rRuMZdt3V716HP9OgKWzlw)
Content-type: text/plain; name=kxsd9.c
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=kxsd9.c

/*
 * kxsd9.c - KXSD9 Tri-axis Accelerometer hardware monitoring driver
 *
 * Copyright (c) 2008-2009 Samsung Eletronics
 * Authors:
 *	Kim Kyuwon <q1.kim@samsung.com>
 *	Kyungmin Park <kyungmin.park@samsung.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * Datasheet: http://www.kionix.com/sensors/accelerometer-products.html
 *
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/hwmon.h>
#include <linux/hwmon-sysfs.h>
#include <linux/interrupt.h>
#include <linux/platform_device.h>
#include <linux/workqueue.h>
#include <linux/mutex.h>
#include <linux/err.h>
#include <linux/i2c.h>
#include <linux/delay.h>
#include <linux/gpio.h>
#include <linux/input-polldev.h>
#include <linux/kxsd9.h>

#define KXSD9_XOUT_H		0x00
#define KXSD9_XOUT_L		0x01
#define KXSD9_YOUT_H		0x02
#define KXSD9_YOUT_L		0x03
#define KXSD9_ZOUT_H		0x04
#define KXSD9_ZOUT_L		0x05
#define KXSD9_AUXOUT_H		0x06
#define KXSD9_AUXOUT_L		0x07
#define KXSD9_RESET_WRITE	0x0A
#define KXSD9_CTRL_REGC		0x0C
#define KXSD9_CTRL_REGB		0x0D
#define KXSD9_CTRL_REGA		0x0E

#define KXSD9_RESET_KEY		0xCA

#define KXSD9_REGC_LP2		(1 << 7)
#define KXSD9_REGC_LP1		(1 << 6)
#define KXSD9_REGC_LP0		(1 << 5)
#define KXSD9_REGC_MOTLEV	(1 << 4)
#define KXSD9_REGC_MOTLAT	(1 << 3)
#define KXSD9_REGC_FS1		(1 << 1)
#define KXSD9_REGC_FS0		(1 << 0)

/*
 * 'CLKhld=1' makes KXSD9 hold SCL low during A/D conversions. This may
 * affect the operation of other I2C devices. Thus, I don't think it is
 * good to set CLKhld to 1.
 */
#define KXSD9_REGB_CLKHLD	(1 << 7)
#define KXSD9_REGB_ENABLE	(1 << 6)
#define KXSD9_REGB_MOTIEN	(1 << 2)

#define KXSD9_REGA_MOTI		(1 << 1)

/*
 * Default Full Scale Range: +/-2 g
 * 12-bit Sensitivity : 819 counts/g
 */
#define KXSD9_RANGE_DEFAULT	(KXSD9_REGC_FS1 | KXSD9_REGC_FS0)

/* Default Motion Wake Up Acceleration Threshold: +/-1 g */
#define KXSD9_THRESHOLD_DEFAULT	(KXSD9_REGC_MOTLEV | KXSD9_RANGE_DEFAULT)

/* Default Operational Bandwidth (Filter Corner Frequency): 50Mhz */
#define KXSD9_BW_DEFAULT	(KXSD9_REGC_LP0 | KXSD9_REGC_LP1 |\
				KXSD9_REGC_LP2)

#define MAX_12BIT		((1 << 12) - 1)
#define POLL_INTERVAL_DEFAULT	100

enum input_type {
	INPUT_NONE,
	INPUT_POLL,	/* Polling */
	INPUT_INT,	/* Interrupt */
};

struct kxsd9_sensor {
	struct i2c_client			*client;
	struct device				*dev;
	struct input_polled_dev			*ipdev;
	struct input_dev			*idev;
	struct kxsd9_sensor_platform_data	*pdata;
	struct work_struct			work;
	struct mutex				lock;

	enum input_type				type;
};

static int kxsd9_write_reg(struct i2c_client *client, u8 reg, u8 val)
{
	int ret = i2c_smbus_write_byte_data(client, reg, val);

	if (ret < 0)
		dev_err(&client->dev, "%s: reg 0x%x, val 0x%x, err %d\n",
						__func__, reg, val, ret);
	return ret;
}

static int kxsd9_read_reg(struct i2c_client *client, u8 reg)
{
	int ret = i2c_smbus_read_byte_data(client, reg);

	if (ret < 0)
		dev_err(&client->dev, "%s, reg 0x%x, err %d\n",
						__func__, reg, ret);
	return ret;
}

static void kxsd9_read_xyz(struct i2c_client *client,
						s16 *x, s16 *y, s16 *z)
{
	*x = kxsd9_read_reg(client, KXSD9_XOUT_H) << 4 |
				kxsd9_read_reg(client, KXSD9_XOUT_L) >> 4;

	*y = kxsd9_read_reg(client, KXSD9_YOUT_H) << 4 |
				kxsd9_read_reg(client, KXSD9_YOUT_L) >> 4;

	*z = kxsd9_read_reg(client, KXSD9_ZOUT_H) << 4 |
				kxsd9_read_reg(client, KXSD9_ZOUT_L) >> 4;
}

static void kxsd9_set_bits(struct i2c_client *client, u8 reg, u8 bits, int on)
{
	struct kxsd9_sensor *sensor = i2c_get_clientdata(client);
	int val;

	mutex_lock(&sensor->lock);
	if (on)
		val = kxsd9_read_reg(client, reg) | bits;
	else
		val = kxsd9_read_reg(client, reg) & ~bits;
	kxsd9_write_reg(client, reg, (u8)val);
	mutex_unlock(&sensor->lock);
}

static int kxsd9_read_bit(struct i2c_client *client, u8 reg, u8 bit)
{
	struct kxsd9_sensor *sensor = i2c_get_clientdata(client);
	int val;

	mutex_lock(&sensor->lock);
	val = kxsd9_read_reg(client, reg) & bit;
	mutex_unlock(&sensor->lock);

	return !!val;
}

static ssize_t kxsd9_show_xyz(struct device *dev,
				struct device_attribute *attr, char *buf)
{
	struct kxsd9_sensor *sensor = dev_get_drvdata(dev);
	s16 x, y, z;

	x = y = z = 0;
	kxsd9_read_xyz(sensor->client, &x, &y, &z);

	return sprintf(buf, "%d, %d, %d\n", x, y, z);
}
static SENSOR_DEVICE_ATTR(xyz, S_IRUGO, kxsd9_show_xyz, NULL, 0);

#define KXSD9_SET_REGISTER(_name, _reg)					\
static ssize_t kxsd9_store_##_name(struct device *dev,			\
	struct device_attribute *attr, const char *buf, size_t count)	\
{									\
	struct kxsd9_sensor *sensor = dev_get_drvdata(dev);		\
	unsigned long val;						\
	int ret = strict_strtoul(buf, 16, &val);			\
	if (ret)							\
		return ret;						\
	mutex_lock(&sensor->lock);					\
	kxsd9_write_reg(sensor->client, KXSD9_CTRL_##_reg, (u8) val);	\
	mutex_unlock(&sensor->lock);					\
	return count;							\
}									\
static SENSOR_DEVICE_ATTR(_name, S_IRUGO | S_IWUSR,			\
					NULL, kxsd9_store_##_name, 0);

KXSD9_SET_REGISTER(regc, REGC);
KXSD9_SET_REGISTER(regb, REGB);

#define KXSD9_CONTROL_BIT(_reg, _bit)					\
static ssize_t kxsd9_show_##_bit(struct device *dev,			\
			struct device_attribute *attr, char *buf)	\
{									\
	struct kxsd9_sensor *sensor = dev_get_drvdata(dev);		\
	int ret = kxsd9_read_bit(sensor->client, KXSD9_CTRL_##_reg,	\
						KXSD9_##_reg##_##_bit);	\
	return sprintf(buf, "%d\n", ret);				\
}									\
static ssize_t kxsd9_store_##_bit(struct device *dev,			\
	struct device_attribute *attr, const char *buf, size_t count)	\
{									\
	struct kxsd9_sensor *sensor = dev_get_drvdata(dev);		\
	unsigned long val;						\
	int ret = strict_strtoul(buf, 10, &val);			\
	if (ret)							\
		return ret;						\
	kxsd9_set_bits(sensor->client, KXSD9_CTRL_##_reg,		\
					KXSD9_##_reg##_##_bit, val);	\
	return count;							\
}									\
static SENSOR_DEVICE_ATTR(_bit, S_IRUGO | S_IWUSR,			\
			kxsd9_show_##_bit, kxsd9_store_##_bit, 0);

KXSD9_CONTROL_BIT(REGB, MOTIEN);
KXSD9_CONTROL_BIT(REGB, ENABLE);

static struct attribute *kxsd9_attributes[] = {
	&sensor_dev_attr_xyz.dev_attr.attr,
	&sensor_dev_attr_regc.dev_attr.attr,
	&sensor_dev_attr_regb.dev_attr.attr,
	&sensor_dev_attr_MOTIEN.dev_attr.attr,
	&sensor_dev_attr_ENABLE.dev_attr.attr,
	NULL
};

static const struct attribute_group kxsd9_group = {
	.attrs	= kxsd9_attributes,
};

static void kxsd9_report_abs(struct kxsd9_sensor *sensor,
						struct input_dev *idev)
{
	s16 x, y, z;

	x = y = z = 0;

	mutex_lock(&sensor->lock);

	kxsd9_read_xyz(sensor->client, &x, &y, &z);

	input_report_abs(idev, ABS_X, x);
	input_report_abs(idev, ABS_Y, y);
	input_report_abs(idev, ABS_Z, z);

	input_sync(idev);

	mutex_unlock(&sensor->lock);
}

static void kxsd9_work(struct work_struct *work)
{
	struct kxsd9_sensor *sensor =
			container_of(work, struct kxsd9_sensor, work);
	s16 x, y, z;
	int ret;

	kxsd9_read_xyz(sensor->client, &x, &y, &z);

	/* The MOT pin can be cleared by reading CTRL_REGA. */
	ret = kxsd9_read_bit(sensor->client, KXSD9_CTRL_REGA, KXSD9_REGA_MOTI);
	if (!ret)
		dev_err(&sensor->client->dev, "MOTI bit is not set\n");

	/*
	 * To re-enter low power motion wakeup mode, reset the MOTIen bit to 1
	 */
	kxsd9_set_bits(sensor->client, KXSD9_CTRL_REGB, KXSD9_REGB_MOTIEN, 1);

	kxsd9_report_abs(sensor, sensor->idev);

	enable_irq(sensor->client->irq);
}

static irqreturn_t kxsd9_irq(int irq, void *dev_id)
{
	struct kxsd9_sensor *sensor = (struct kxsd9_sensor *) dev_id;

	if (!work_pending(&sensor->work)) {
		disable_irq_nosync(irq);
		schedule_work(&sensor->work);
	} else
		dev_err(&sensor->client->dev, "work_pending\n");

	return IRQ_HANDLED;
}

static void kxsd9_initialize(struct kxsd9_sensor *sensor)
{
	/*
	 * The reset time of the KXSD9 accelerometer takes about 11 msec.
	 * So write proper register values at first instead of resetting kxsd9.
	 */

	kxsd9_write_reg(sensor->client, KXSD9_CTRL_REGC,
		KXSD9_BW_DEFAULT | KXSD9_THRESHOLD_DEFAULT
		| KXSD9_REGC_MOTLAT);
	kxsd9_write_reg(sensor->client, KXSD9_CTRL_REGB,
		KXSD9_REGB_ENABLE | KXSD9_REGB_MOTIEN);
}

static void kxsd9_ipdev_poll(struct input_polled_dev *dev)
{
	struct kxsd9_sensor *sensor = dev->private;
	struct input_dev *idev = dev->input;

	kxsd9_report_abs(sensor, idev);
}

static void kxsd9_initialize_input_device(struct input_dev *idev,
						struct i2c_client *client)
{
	idev->name = "KXSD9 Accel";
	idev->id.bustype = BUS_I2C;
	idev->dev.parent = &client->dev;

	/* Let's use idev->open, idev->close later */

	input_set_abs_params(idev, ABS_X, 0, MAX_12BIT, 0, 0);
	input_set_abs_params(idev, ABS_Y, 0, MAX_12BIT, 0, 0);
	input_set_abs_params(idev, ABS_Z, 0, MAX_12BIT, 0, 0);

	set_bit(EV_ABS, idev->evbit);
}

static int kxsd9_register_polled_input_device(struct kxsd9_sensor *sensor)
{
	struct kxsd9_sensor_platform_data *pdata = sensor->pdata;
	struct i2c_client *client = sensor->client;
	struct input_polled_dev *ipdev;
	int ret;

	ipdev = sensor->ipdev = input_allocate_polled_device();
	if (!ipdev) {
		dev_err(&client->dev, "fail: allocate poll input device\n");
		ret = -ENOMEM;
		goto failed_quit_polled_input;
	}

	ipdev->private = sensor;
	ipdev->poll = kxsd9_ipdev_poll;
	ipdev->poll_interval = pdata->poll_interval;

	kxsd9_initialize_input_device(ipdev->input, client);

	ret = input_register_polled_device(ipdev);
	if (ret) {
		dev_err(&client->dev, "fail: register to poll input device\n");
		goto failed_free_polled_input;
	}

	sensor->type = INPUT_POLL;

	return 0;

failed_free_polled_input:
	input_free_polled_device(sensor->ipdev);
failed_quit_polled_input:

	return ret;
}

static void kxsd9_unregister_polled_input_devce(struct kxsd9_sensor *sensor)
{
	input_unregister_polled_device(sensor->ipdev);
	input_free_polled_device(sensor->ipdev);

	sensor->type = INPUT_NONE;
}

static int kxsd9_register_interrupt_input_device(struct kxsd9_sensor *sensor)
{
	struct i2c_client *client = sensor->client;
	int ret;

	sensor->idev = input_allocate_device();
	if (!sensor->idev) {
		dev_err(&client->dev, "fail: allocate input device\n");
		ret = -ENOMEM;
		goto failed_quit_interrupt_input;
	}

	kxsd9_initialize_input_device(sensor->idev, client);

	ret = input_register_device(sensor->idev);
	if (ret) {
		dev_err(&client->dev, "fail: register to input device\n");
		goto failed_free_interrupt_input;
	}

	ret = request_irq(client->irq, kxsd9_irq, IRQF_TRIGGER_HIGH,
						"KXSD9 Accel", sensor);
	if (ret) {
		dev_err(&client->dev, "can't get IRQ %d, ret %d\n",
						client->irq, ret);
		goto failed_unregister_input;
	}

	sensor->type = INPUT_INT;

	return 0;

failed_unregister_input:
	input_unregister_device(sensor->idev);
failed_free_interrupt_input:
	input_free_device(sensor->idev);
failed_quit_interrupt_input:

	return ret;
}

static void kxsd9_unregister_interrupt_input_devce(struct kxsd9_sensor *sensor)
{
	struct i2c_client *client = sensor->client;

	free_irq(client->irq, sensor);
	input_unregister_device(sensor->idev);
	input_free_device(sensor->idev);

	sensor->type = INPUT_NONE;
 }

static int kxsd9_unregister_input_device(struct kxsd9_sensor *sensor)
{
	struct i2c_client *client = sensor->client;

	if (sensor->type == INPUT_INT)
		kxsd9_unregister_interrupt_input_devce(sensor);
	else if (sensor->type == INPUT_POLL)
		kxsd9_unregister_polled_input_devce(sensor);
	else
		dev_err(&client->dev, "No input device to unregister\n");

	return 0;
}

static int __devinit kxsd9_probe(struct i2c_client *client,
					const struct i2c_device_id *id)
{
	struct kxsd9_sensor *sensor;
	int ret;

	sensor = kzalloc(sizeof(struct kxsd9_sensor), GFP_KERNEL);
	if (!sensor) {
		dev_err(&client->dev, "failed to allocate driver data\n");
		return -ENOMEM;
	}

	sensor->client = client;
	sensor->pdata = client->dev.platform_data;
	i2c_set_clientdata(client, sensor);

	/* Detect KXSD9 */
	ret = kxsd9_read_reg(client, KXSD9_CTRL_REGC);
	if (ret < 0) {
		dev_err(&client->dev, "failed to detect device\n");
		goto failed_free;
	} else
		dev_info(&client->dev, "successed to detect device\n");

	/* Initialize KXSD9 */
	kxsd9_initialize(sensor);

	INIT_WORK(&sensor->work, kxsd9_work);
	mutex_init(&sensor->lock);

	ret = sysfs_create_group(&client->dev.kobj, &kxsd9_group);
	if (ret) {
		dev_err(&client->dev, "failed to create kxsd9 attribute group");
		goto failed_free;
	}

	sensor->dev = hwmon_device_register(&client->dev);
	if (IS_ERR(sensor->dev)) {
		dev_err(&client->dev, "failed to register to hwmon device");
		ret = PTR_ERR(sensor->dev);
		goto failed_remove_sysfs;
	}

	if (client->irq > 0)
		ret = kxsd9_register_interrupt_input_device(sensor);
	else
		ret = kxsd9_register_polled_input_device(sensor);
	if (ret)
		goto failed_unregister_hwmon;

	return 0;

failed_unregister_hwmon:
	hwmon_device_unregister(&client->dev);
failed_remove_sysfs:
	sysfs_remove_group(&client->dev.kobj, &kxsd9_group);
failed_free:
	i2c_set_clientdata(client, NULL);
	kfree(sensor);

	return ret;
}

static int __devexit kxsd9_remove(struct i2c_client *client)
{
	struct kxsd9_sensor *sensor = i2c_get_clientdata(client);

	kxsd9_set_bits(client, KXSD9_CTRL_REGB, KXSD9_REGB_ENABLE, 0);
	kxsd9_unregister_input_device(sensor);
	hwmon_device_unregister(&client->dev);
	sysfs_remove_group(&client->dev.kobj, &kxsd9_group);
	i2c_set_clientdata(client, NULL);
	kfree(sensor);

	return 0;
}

static int kxsd9_suspend(struct i2c_client *client, pm_message_t mesg)
{
	disable_irq(client->irq);
	kxsd9_set_bits(client, KXSD9_CTRL_REGB, KXSD9_REGB_ENABLE, 0);

	return 0;
}

static int kxsd9_resume(struct i2c_client *client)
{
	kxsd9_set_bits(client, KXSD9_CTRL_REGB, KXSD9_REGB_ENABLE, 1);
	enable_irq(client->irq);

	return 0;
}

static const struct i2c_device_id kxsd9_id[] = {
	{ "KXSD9", 0 },
	{ }
};
MODULE_DEVICE_TABLE(i2c, kxsd9_id);

static struct i2c_driver kxsd9_i2c_driver = {
	.class		= I2C_CLASS_HWMON,
	.driver	= {
		.name	= "KXSD9",
	},
	.probe		= kxsd9_probe,
	.remove		= __devexit_p(kxsd9_remove),
	.suspend	= kxsd9_suspend,
	.resume		= kxsd9_resume,
	.id_table	= kxsd9_id,
};

static int __init kxsd9_init(void)
{
	return i2c_add_driver(&kxsd9_i2c_driver);
}
module_init(kxsd9_init);

static void __exit kxsd9_exit(void)
{
	i2c_del_driver(&kxsd9_i2c_driver);
}
module_exit(kxsd9_exit);

MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
MODULE_DESCRIPTION("KXSD9 hardware monitoring driver");
MODULE_LICENSE("GPL v2");

--Boundary_(ID_rRuMZdt3V716HP9OgKWzlw)--
