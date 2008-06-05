Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbYFEHu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbYFEHu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 03:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYFEHuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 03:50:50 -0400
Received: from smtp.nokia.com ([192.100.122.230]:55918 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbYFEHut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 03:50:49 -0400
Message-ID: <48479922.6050003@movial.fi>
Date: Thu, 05 Jun 2008 10:43:30 +0300
From: Riku Voipio <riku.voipio@movial.fi>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Yan Burman <burman.yan@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       HWMON <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net, jic23@cam.ac.uk
Subject: Re: [lm-sensors] [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection
 System 3D ACPI	driver
References: <1212235533.3815.5.camel@localhost>
In-Reply-To: <1212235533.3815.5.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2008 07:43:32.0398 (UTC) FILETIME=[DA62E4E0:01C8C6DF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Burman wrote:
> +==================
> +
> +Supported chips:
> +
> +  * STMicroelectronics LIS3LV02DL and LIS3LV02DQ
> +
These chips are connected to either I2C or SPI - This is the 4th driver for
(apparently) these same chips:

http://docwiki.gumstix.org/Lis3lv02dq_spi.c
http://svn.openmoko.org/branches/src/target/kernel/2.6.24.x/patches/lis302dl.patch 

http://article.gmane.org/gmane.linux.kernel.spi.devel/1010

> +	depends on ACPI && INPUT && X86
>   


> +/* The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ
> + * that seems to be connected via SPI */
>   
Perhaps it would make more sense implement support for SPI
bus on the laptop and use the SPI interface directly instead or
routing via the ACPI hiding layer?

> +
> +#define MDPS_WHO_AM_I        0x0F /*r      00111010 */
> +#define MDPS_OFFSET_X        0x16 /*rw              */
> +#define MDPS_OFFSET_Y        0x17 /*rw              */
> +#define MDPS_OFFSET_Z        0x18 /*rw              */
> +#define MDPS_GAIN_X          0x19 /*rw              */
> +#define MDPS_GAIN_Y          0x1A /*rw              */
> +#define MDPS_GAIN_Z          0x1B /*rw              */
> +#define MDPS_CTRL_REG1       0x20 /*rw     00000111 */
> +#define MDPS_CTRL_REG2       0x21 /*rw     00000000 */
> +#define MDPS_CTRL_REG3       0x22 /*rw     00001000 */
> +#define MDPS_HP_FILTER RESET 0x23 /*r               */
> +#define MDPS_STATUS_REG      0x27 /*rw     00000000 */
> +#define MDPS_OUTX_L          0x28 /*r               */
> +#define MDPS_OUTX_H          0x29 /*r               */
> +#define MDPS_OUTY_L          0x2A /*r               */
> +#define MDPS_OUTY_H          0x2B /*r               */
> +#define MDPS_OUTZ_L          0x2C /*r               */
> +#define MDPS_OUTZ_H          0x2D /*r               */
> +#define MDPS_FF_WU_CFG       0x30 /*rw     00000000 */
> +#define MDPS_FF_WU_SRC       0x31 /*rw     00000000 */
> +#define MDPS_FF_WU_ACK       0x32 /*r               */
> +#define MDPS_FF_WU_THS_L     0x34 /*rw     00000000 */
> +#define MDPS_FF_WU_THS_H     0x35 /*rw     00000000 */
> +#define MDPS_FF_WU_DURATION  0x36 /*rw     00000000 */
> +#define MDPS_DD_CFG          0x38 /*rw     00000000 */
> +#define MDPS_DD_SRC          0x39 /*rw     00000000 */
> +#define MDPS_DD_ACK          0x3A /*r               */
> +#define MDPS_DD_THSI_L       0x3C /*rw     00000000 */
> +#define MDPS_DD_THSI_H       0x3D /*rw     00000000 */
> +#define MDPS_DD_THSE_L       0x3E /*rw     00000000 */
> +#define MDPS_DD_THSE_H       0x3F /*rw     00000000 */
> +
> +#define MDPS_ID		0x3A   /* MDPS_WHO_AM_I */
> +#define MDPS_FS		(1<<7) /* MDPS_CTRL_REG2 : Full Scale selection */
> +#define MDPS_BDU	(1<<6) /* MDPS_CTRL_REG2 : Block Data Update */
> +
> +/* joystick device poll interval in milliseconds */
> +#define MDPS_POLL_INTERVAL 30
> +
> +/* Maximum value our axis may get for the input device */
> +#define MDPS_MAX_VAL 2048
> +
> +static unsigned int power_off;
> +module_param(power_off, bool, S_IRUGO);
> +MODULE_PARM_DESC(power_off, "Turn off device on module load");
> +
> +struct axis_conversion {
> +	s8	x;
> +	s8	y;
> +	s8	z;
> +};
> +
> +struct acpi_mdps {
> +	struct acpi_device	*device;   /* The ACPI device */
> +	u32			irq;       /* IRQ number */
> +	struct input_dev	*idev;     /* input device */
> +	struct task_struct	*kthread;  /* kthread for input */
> +	int			xcalib;    /* calibrated null value for x */
> +	int			ycalib;    /* calibrated null value for y */
> +	int			zcalib;    /* calibrated null value for z */
> +	int			is_on;     /* whether the device is on or off */
> +	struct platform_device	*pdev;     /* platform device */
> +	atomic_t		count;     /* interrupt count after last read */
> +	struct fasync_struct	*async_queue;
> +	atomic_t		available; /* whether the device is open */
> +	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
> +	/* conversion between hw axis and logical ones */
> +	struct axis_conversion	ac;
> +};
> +
> +static struct acpi_mdps mdps;
> +
> +static int mdps_remove_fs(void);
> +static int mdps_add_fs(struct acpi_device *device);
> +static void mdps_joystick_enable(void);
> +static void mdps_joystick_disable(void);
> +
> +static struct acpi_device_id mdps_device_ids[] = {
> +	{ACPI_MDPS_ID, 0},
> +	{"", 0},
> +};
> +MODULE_DEVICE_TABLE(acpi, mdps_device_ids);
> +
> +/** Create a single value from 2 bytes received from the accelerometer
> + * @param hi the high byte
> + * @param lo the low byte
> + * @return the resulting value
> + */
> +static inline s16 mdps_glue_bytes(unsigned long hi, unsigned long lo)
> +{
> +	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 = bit 5 */
> +	return (s16)((hi << 8) | lo);
> +}
> +
> +/** ACPI ALRD method: read a register
> + * @param handle the handle of the device
> + * @param reg the register to read
> + * @param[out] ret result of the operation
> + * @return AE_OK on success
> + */
> +static acpi_status mdps_ALRD(acpi_handle handle, int reg,
> +				unsigned long *ret)
> +{
> +	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
> +	struct acpi_object_list args = { 1, &arg0 };
> +
> +	arg0.integer.value = reg;
> +
> +	return acpi_evaluate_integer(handle, "ALRD", &args, ret);
> +}
> +
> +/** ACPI _INI method: initialize the device.
> + * @param handle the handle of the device
> + * @return 0 on success
> + */
> +static inline acpi_status mdps__INI(acpi_handle handle)
> +{
> +	return acpi_evaluate_object(handle, METHOD_NAME__INI, NULL, NULL);
> +}
> +
> +/** ACPI ALWR method: write to a register
> + * @param handle the handle of the device
> + * @param reg the register to write to
> + * @param val the value to write
> + * @param[out] ret result of the operation
> + * @return AE_OK on success
> + */
> +static acpi_status mdps_ALWR(acpi_handle handle, int reg, int val,
> +				unsigned long *ret)
> +{
> +	union acpi_object in_obj[2];
> +	struct acpi_object_list args = { 2, in_obj };
> +
> +	in_obj[0].type          = ACPI_TYPE_INTEGER;
> +	in_obj[0].integer.value = reg;
> +	in_obj[1].type          = ACPI_TYPE_INTEGER;
> +	in_obj[1].integer.value = val;
> +
> +	return acpi_evaluate_integer(handle, "ALWR", &args, ret);
> +}
> +
> +static int mdps_read_axis(acpi_handle handle, int lo_const, int hi_const)
> +{
> +	unsigned long lo_val, hi_val;
> +	mdps_ALRD(handle, lo_const, &lo_val);
> +	mdps_ALRD(handle, hi_const, &hi_val);
> +	return mdps_glue_bytes(hi_val, lo_val);
> +}
> +
> +static inline int mdps_get_axis(s8 axis, int hw_values[3])
> +{
> +	if (axis > 0)
> +		return hw_values[axis - 1];
> +	else
> +		return -hw_values[-axis - 1];
> +}
> +
> +/** Get X, Y and Z axis values from the accelerometer
> + * @param handle the handle to the device
> + * @param[out] x where to store the X axis value
> + * @param[out] y where to store the Y axis value
> + * @param[out] z where to store the Z axis value
> + * @note 40Hz input device can eat up about 10% CPU at 800MHZ
> + */
> +static void mdps_get_xyz(acpi_handle handle, int *x, int *y, int *z)
> +{
> +	int position[3];
> +	position[0] = mdps_read_axis(handle, MDPS_OUTX_L, MDPS_OUTX_H);
> +	position[1] = mdps_read_axis(handle, MDPS_OUTY_L, MDPS_OUTY_H);
> +	position[2] = mdps_read_axis(handle, MDPS_OUTZ_L, MDPS_OUTZ_H);
> +
> +	*x = mdps_get_axis(mdps.ac.x, position);
> +	*y = mdps_get_axis(mdps.ac.y, position);
> +	*z = mdps_get_axis(mdps.ac.z, position);
> +}
> +
> +/** Kthread polling function
> + * @param data unused - here to conform to threadfn prototype
> + */
> +static int mdps_input_kthread(void *data)
> +{
> +	int x, y, z;
> +
> +	while (!kthread_should_stop()) {
> +		mdps_get_xyz(mdps.device->handle, &x, &y, &z);
> +		input_report_abs(mdps.idev, ABS_X, x - mdps.xcalib);
> +		input_report_abs(mdps.idev, ABS_Y, y - mdps.ycalib);
> +		input_report_abs(mdps.idev, ABS_Z, z - mdps.zcalib);
> +
> +		input_sync(mdps.idev);
> +
> +		try_to_freeze();
> +		msleep_interruptible(MDPS_POLL_INTERVAL);
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void mdps_poweroff(acpi_handle handle)
> +{
> +	unsigned long ret;
> +	mdps.is_on = 0;
> +	/* disable X,Y,Z axis and power down */
> +	mdps_ALWR(handle, MDPS_CTRL_REG1, 0x00, &ret);
> +}
> +
> +static inline void mdps_poweron(acpi_handle handle)
> +{
> +	unsigned long val, retw;
> +
> +	mdps.is_on = 1;
> +	mdps__INI(handle);
> +	/*
> +	 * Change to Block Data Update mode: LSB and MSB values are not updated
> +	 * until both have been read. So the value read will always be correct.
> +	 */
> +	mdps_ALRD(handle, MDPS_CTRL_REG2, &val);
> +	val |= MDPS_BDU;
> +	mdps_ALWR(handle, MDPS_CTRL_REG2, val, &retw);
> +}
> +
> +#ifdef CONFIG_PM
> +static int mdps_suspend(struct acpi_device *device, pm_message_t state)
> +{
> +	/* make sure the device is off when we suspend */
> +	mdps_poweroff(mdps.device->handle);
> +	return 0;
> +}
> +#endif
> +
> +static int mdps_resume(struct acpi_device *device)
> +{
> +	/* make sure the device went online */
> +	mdps_poweron(mdps.device->handle);
> +	return 0;
> +}
> +
> +static irqreturn_t mdps_irq(int irq, void *dev_id)
> +{
> +	atomic_inc(&mdps.count);
> +
> +	wake_up_interruptible(&mdps.misc_wait);
> +	kill_fasync(&mdps.async_queue, SIGIO, POLL_IN);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int mdps_misc_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +
> +	if (!atomic_dec_and_test(&mdps.available)) {
> +		atomic_inc(&mdps.available);
> +		return -EBUSY; /* already open */
> +	}
> +
> +	atomic_set(&mdps.count, 0);
> +
> +	/* Can't have shared interrupts here, since we have no way
> +	 * to determine in interrupt context
> +	 * if it was our device that caused the interrupt */
> +	ret = request_irq(mdps.irq, mdps_irq, 0, "mdps", mdps_irq);
> +	if (ret) {
> +		atomic_inc(&mdps.available);
> +		printk(KERN_ERR "mdps: IRQ%d allocation failed\n", mdps.irq);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mdps_misc_release(struct inode *inode, struct file *file)
> +{
> +	fasync_helper(-1, file, 0, &mdps.async_queue);
> +	free_irq(mdps.irq, mdps_irq);
> +	atomic_inc(&mdps.available); /* release the device */
> +	return 0;
> +}
> +
> +static ssize_t mdps_misc_read(struct file *file, char __user *buf,
> +				size_t count, loff_t *pos)
> +{
> +	DECLARE_WAITQUEUE(wait, current);
> +	u32 data;
> +	ssize_t retval = count;
> +
> +	if (count != sizeof(u32))
> +		return -EINVAL;
> +
> +	add_wait_queue(&mdps.misc_wait, &wait);
> +	for (; ; ) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		data = atomic_xchg(&mdps.count, 0);
> +		if (data)
> +			break;
> +
> +		if (file->f_flags & O_NONBLOCK) {
> +			retval = -EAGAIN;
> +			goto out;
> +		}
> +
> +		if (signal_pending(current)) {
> +			retval = -ERESTARTSYS;
> +			goto out;
> +		}
> +
> +		schedule();
> +	}
> +
> +	/* make sure we are not going into copy_to_user() with
> +	 * TASK_INTERRUPTIBLE state */
> +	set_current_state(TASK_RUNNING);
> +	if (copy_to_user(buf, &data, sizeof(data)))
> +		retval = -EFAULT;
> +
> +out:
> +	__set_current_state(TASK_RUNNING);
> +	remove_wait_queue(&mdps.misc_wait, &wait);
> +
> +	return retval;
> +}
> +
> +static unsigned int mdps_misc_poll(struct file *file, poll_table *wait)
> +{
> +	poll_wait(file, &mdps.misc_wait, wait);
> +	if (atomic_read(&mdps.count))
> +		return POLLIN | POLLRDNORM;
> +	return 0;
> +}
> +
> +static int mdps_misc_fasync(int fd, struct file *file, int on)
> +{
> +	return fasync_helper(fd, file, on, &mdps.async_queue);
> +}
> +
> +static const struct file_operations mdps_misc_fops = {
> +	.owner   = THIS_MODULE,
> +	.llseek  = no_llseek,
> +	.read    = mdps_misc_read,
> +	.open    = mdps_misc_open,
> +	.release = mdps_misc_release,
> +	.poll    = mdps_misc_poll,
> +	.fasync  = mdps_misc_fasync,
> +};
> +
> +static struct miscdevice mdps_misc_device = {
> +	.minor   = MISC_DYNAMIC_MINOR,
> +	.name    = "accel",
> +	.fops    = &mdps_misc_fops,
> +};
> +
> +static acpi_status
> +mdps_get_resource(struct acpi_resource *resource, void *context)
> +{
> +	if (resource->type == ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
> +		struct acpi_resource_extended_irq *irq;
> +		u32 *device_irq = context;
> +
> +		irq = &resource->data.extended_irq;
> +		*device_irq = irq->interrupts[0];
> +	}
> +
> +	return AE_OK;
> +}
> +
> +static void mdps_enum_resources(struct acpi_device *device)
> +{
> +	acpi_status status;
> +
> +	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
> +					mdps_get_resource, &mdps.irq);
> +	if (ACPI_FAILURE(status))
> +		printk(KERN_DEBUG "mdps: Error getting resources\n");
> +}
> +
> +static int mdps_dmi_matched(const struct dmi_system_id *dmi)
> +{
> +	mdps.ac = *(struct axis_conversion *)dmi->driver_data;
> +	printk(KERN_INFO "mdps: hardware type %s found.\n", dmi->ident);
> +
> +	return 1;
> +}
> +
> +
> +/* Represents, for each axis seen by userspace, the corresponding hw axis (+1).
> + * If the value is negative, the opposite of the hw value is used. */
> +static struct axis_conversion mdps_axis_normal = {1, 2, 3};
> +static struct axis_conversion mdps_axis_y_inverted = {1, -2, 3};
> +static struct axis_conversion mdps_axis_x_inverted = {-1, 2, 3};
> +
> +static struct dmi_system_id mdps_dmi_ids[] = {
> +	{
> +		.callback = mdps_dmi_matched,
> +		.ident = "NC64x0",
> +		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nc64"),
> +		},
> +		.driver_data = &mdps_axis_x_inverted
> +	},
> +	{
> +		.callback = mdps_dmi_matched,
> +		.ident = "NX9420",
> +		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx9420"),
> +		},
> +		.driver_data = &mdps_axis_x_inverted
> +	},
> +	{
> +		.callback = mdps_dmi_matched,
> +		.ident = "NW9440",
> +		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nw9440"),
> +		},
> +		.driver_data = &mdps_axis_x_inverted
> +	},
> +	{
> +		.callback = mdps_dmi_matched,
> +		.ident = "NC2510",
> +		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 2510"),
> +		},
> +		.driver_data = &mdps_axis_y_inverted
> +	},
> +	{ NULL, }
> +/* Laptop models without axis info (yet):
> + * "NC84x0" "HP Compaq nc84"
> + * "NC651xx" "HP Compaq 651"
> + * "NC671xx" "HP Compaq 671"
> + * "NC6910" "HP Compaq 6910"
> + * HP Compaq 8510x Notebook PC / Mobile Workstation
> + * HP Compaq 8710x Notebook PC / Mobile Workstation
> + * "NC2400" "HP Compaq nc2400"
> + * "NX74x0" "HP Compaq nx74"
> + * "NX6325" "HP Compaq nx6325"
> + * "NC4400" "HP Compaq nc4400"
> + */
> +};
> +
> +static int mdps_add(struct acpi_device *device)
> +{
> +	unsigned long val;
> +	int ret;
> +
> +	if (!device)
> +		return -EINVAL;
> +
> +	mdps.device = device;
> +	strcpy(acpi_device_name(device), DRIVER_NAME);
> +	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
> +	acpi_driver_data(device) = &mdps;
> +
> +	mdps_ALRD(device->handle, MDPS_WHO_AM_I, &val);
> +	if (val != MDPS_ID) {
> +		printk(KERN_ERR
> +			"mdps: Accelerometer chip not LIS3LV02D{L,Q}\n");
> +		return -ENODEV;
> +	}
> +
> +	/* This is just to make sure that the same physical move
> +	 * is reported identically */
> +	if (dmi_check_system(mdps_dmi_ids) == 0) {
> +		printk(KERN_INFO "mdps: laptop model unknown, "
> +				 "using default axes configuration\n");
> +		mdps.ac = mdps_axis_normal;
> +	}
> +
> +	mdps_add_fs(device);
> +	mdps_resume(device);
> +
> +	mdps_joystick_enable();
> +
> +	/* obtain IRQ number of our device from ACPI */
> +	mdps_enum_resources(device);
> +
> +	if (power_off) /* see if user wanted to power off the device on load */
> +		mdps_poweroff(mdps.device->handle);
> +
> +	/* if we did not get an IRQ from ACPI - we have nothing more to do */
> +	if (!mdps.irq) {
> +		printk(KERN_INFO
> +			"mdps: No IRQ in ACPI. Disabling /dev/accel\n");
> +		return 0;
> +	}
> +
> +	atomic_set(&mdps.available, 1); /* init the misc device open count */
> +	init_waitqueue_head(&mdps.misc_wait);
> +
> +	ret = misc_register(&mdps_misc_device);
> +	if (ret)
> +		printk(KERN_ERR "mdps: misc_register failed\n");
> +
> +	return 0;
> +}
> +
> +static int mdps_remove(struct acpi_device *device, int type)
> +{
> +	if (!device)
> +		return -EINVAL;
> +
> +	if (mdps.irq)
> +		misc_deregister(&mdps_misc_device);
> +
> +	mdps_joystick_disable();
> +
> +	return mdps_remove_fs();
> +}
> +
> +static inline void mdps_calibrate_joystick(void)
> +{
> +	mdps_get_xyz(mdps.device->handle, &mdps.xcalib, &mdps.ycalib,
> +		&mdps.zcalib);
> +}
> +
> +static int mdps_joystick_open(struct input_dev *dev)
> +{
> +	mdps.kthread = kthread_run(mdps_input_kthread, NULL, "kmdps");
> +	if (IS_ERR(mdps.kthread))
> +		return PTR_ERR(mdps.kthread);
> +
> +	return 0;
> +}
> +
> +static void mdps_joystick_close(struct input_dev *dev)
> +{
> +	kthread_stop(mdps.kthread);
> +}
> +
> +static void mdps_joystick_enable(void)
> +{
> +	if (mdps.idev)
> +		return;
> +
> +	mdps.idev = input_allocate_device();
> +	if (!mdps.idev)
> +		return;
> +
> +	mdps_calibrate_joystick();
> +
> +	mdps.idev->name       = "HP Mobile Data Protection System";
> +	mdps.idev->phys       = "mdps/input0";
> +	mdps.idev->id.bustype = BUS_HOST;
> +	mdps.idev->id.vendor  = 0;
> +	mdps.idev->dev.parent   = &mdps.pdev->dev;
> +
> +	set_bit(EV_ABS, mdps.idev->evbit);
> +
> +	input_set_abs_params(mdps.idev, ABS_X, -MDPS_MAX_VAL, MDPS_MAX_VAL,
> +		3, 0);
> +	input_set_abs_params(mdps.idev, ABS_Y, -MDPS_MAX_VAL, MDPS_MAX_VAL,
> +		3, 0);
> +	input_set_abs_params(mdps.idev, ABS_Z, -MDPS_MAX_VAL, MDPS_MAX_VAL,
> +		3, 0);
> +
> +	mdps.idev->open  = mdps_joystick_open;
> +	mdps.idev->close = mdps_joystick_close;
> +
> +	if (input_register_device(mdps.idev)) {
> +		input_free_device(mdps.idev);
> +		mdps.idev = NULL;
> +	}
> +}
> +
> +static void mdps_joystick_disable(void)
> +{
> +	if (!mdps.idev)
> +		return;
> +
> +	input_unregister_device(mdps.idev);
> +	mdps.idev = NULL;
> +}
> +
> +/* Sysfs stuff */
> +static ssize_t mdps_position_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	int x, y, z;
> +	mdps_get_xyz(mdps.device->handle, &x, &y, &z);
> +
> +	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
> +}
> +
> +static ssize_t mdps_state_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%s\n", (mdps.is_on ? "on" : "off"));
> +}
> +
> +static ssize_t mdps_calibrate_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "(%d,%d,%d)\n", mdps.xcalib, mdps.ycalib,
> +			mdps.zcalib);
> +}
> +
> +static ssize_t mdps_calibrate_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	mdps_calibrate_joystick();
> +	return count;
> +}
> +
> +static ssize_t mdps_rate_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	unsigned long ctrl;
> +	int rate = 0;
> +
> +	mdps_ALRD(mdps.device->handle, MDPS_CTRL_REG1, &ctrl);
> +
> +	/* get the sampling rate of the accelerometer in HZ */
> +	switch ((ctrl & 0x30) >> 4) {
> +	case 00:
> +		rate = 40;
> +		break;
> +
> +	case 01:
> +		rate = 160;
> +		break;
> +
> +	case 02:
> +		rate = 640;
> +		break;
> +
> +	case 03:
> +		rate = 2560;
> +		break;
> +	}
> +
> +	return sprintf(buf, "%d\n", rate);
> +}
> +
> +static ssize_t mdps_state_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	int state;
> +	if (sscanf(buf, "%d", &state) != 1 || (state != 1 && state != 0))
> +		return -EINVAL;
> +
> +	mdps.is_on = state;
> +
> +	if (mdps.is_on)
> +		mdps_poweron(mdps.device->handle);
> +	else
> +		mdps_poweroff(mdps.device->handle);
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(position, S_IRUGO, mdps_position_show, NULL);
> +static DEVICE_ATTR(calibrate, S_IRUGO|S_IWUSR, mdps_calibrate_show,
> +	mdps_calibrate_store);
> +static DEVICE_ATTR(rate, S_IRUGO, mdps_rate_show, NULL);
> +static DEVICE_ATTR(state, S_IRUGO|S_IWUSR, mdps_state_show, mdps_state_store);
> +
> +static struct attribute *mdps_attributes[] = {
> +	&dev_attr_position.attr,
> +	&dev_attr_calibrate.attr,
> +	&dev_attr_rate.attr,
> +	&dev_attr_state.attr,
> +	NULL
> +};
> +
> +static struct attribute_group mdps_attribute_group = {
> +	.attrs = mdps_attributes
> +};
> +
> +static int mdps_add_fs(struct acpi_device *device)
> +{
> +	mdps.pdev = platform_device_register_simple(DRIVER_NAME, -1, NULL, 0);
> +	if (IS_ERR(mdps.pdev))
> +		return PTR_ERR(mdps.pdev);
> +
> +	return sysfs_create_group(&mdps.pdev->dev.kobj, &mdps_attribute_group);
> +}
> +
> +static int mdps_remove_fs(void)
> +{
> +	sysfs_remove_group(&mdps.pdev->dev.kobj, &mdps_attribute_group);
> +	platform_device_unregister(mdps.pdev);
> +	return 0;
> +}
> +
> +static struct acpi_driver mdps_driver = {
> +	.name  = DRIVER_NAME,
> +	.class = ACPI_MDPS_CLASS,
> +	.ids   = mdps_device_ids,
> +	.ops = {
> +		.add     = mdps_add,
> +		.remove  = mdps_remove,
> +#ifdef CONFIG_PM
> +		.suspend = mdps_suspend,
> +		.resume  = mdps_resume
> +#endif
> +	}
> +};
> +
> +static int __init mdps_init_module(void)
> +{
> +	int ret;
> +
> +	if (acpi_disabled)
> +		return -ENODEV;
> +
> +	ret = acpi_bus_register_driver(&mdps_driver);
> +	if (ret < 0)
> +		return ret;
> +
> +	printk(KERN_INFO "mdps version " VERSION " loaded.\n");
> +
> +	return 0;
> +}
> +
> +static void __exit mdps_exit_module(void)
> +{
> +	acpi_bus_unregister_driver(&mdps_driver);
> +}
> +
> +MODULE_DESCRIPTION("HP three-axis digital accelerometer ACPI driver");
> +MODULE_AUTHOR("Yan Burman (burman.yan@gmail.com)");
> +MODULE_VERSION(VERSION);
> +MODULE_LICENSE("GPL");
> +
> +module_init(mdps_init_module);
> +module_exit(mdps_exit_module);
>
>
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
>   

