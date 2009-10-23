Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbZJWTe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbZJWTe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 15:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZJWTe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 15:34:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:15807 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZJWTe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 15:34:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=o3ITJbQ5gkiQb9I47+ykNOwHLCLFgnz6a2kJAQV/8JNhEO+VOoI64GLYVMGXLFqJ55
         gTIf30QlNfxot5tYqaUORzhkxpI1CdjCfFky/gtft5HVK357mo4dOnzToL/sbmrHyBDi
         rqkPezuz+ccA/kBq67DAFg8hmaZGOksO5Ldbo=
Message-ID: <4AE20560.5020908@gmail.com>
Date: Fri, 23 Oct 2009 23:34:56 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ike Panhc <ike.pan@canonical.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexandre Rostovtsev <tetromino@gmail.com>
Subject: Re: [Resend] [PATCH] ACPI: New driver for Lenovo SL laptops
References: <1253805163-12493-1-git-send-email-ike.pan@canonical.com> <1256325108-22626-1-git-send-email-ike.pan@canonical.com>
In-Reply-To: <1256325108-22626-1-git-send-email-ike.pan@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could you please post acpidump from this machine, I would like to 
understand,
why you need to register for EC query events.

Thanks,
Alex.

Ike Panhc пишет:
> lenovo-sl-laptop is a new driver that provides support for hotkeys, bluetooth,
> LenovoCare LEDs and fan speed on the Lenovo ThinkPad SL series laptops. The
> original author is Alexandre Rostovtsev. [1] In February 2009 Alexandre has
> posted the driver on the linux-acpi mailing list and and there was some
> feedback suggesting further modifications. [2] I would like to see Linux
> working properly on these laptops. I was encouraged to push this driver again
> with the modifications that where suggested in the responses to the initial
> post in order to allow me and others interested in that driver to improve it
> and hopefully get it included upstream.
>
> [1] homepage : http://github.com/tetromino/lenovo-sl-laptop/tree/master
> [2] http://patchwork.kernel.org/patch/7427/
>
> Following the suggestions when last time the origin author has posted on the
> linux-acpi mailing list. The major modification of this driver is listed below.
>  - Remove backlight control
>  - Remove procfs EC debug
>  - Remove fan control function
>  - Using generic debugging infrastructure
>  - Support for lastest rfkill infrastructure (by Alexandre)
>  - Register query function into EC for detecting hotkey event
>
> Patch against current checkout of linux-acpi 2.6.31 is below.
>
> The major modification of this driver since last time I posted this driver on
> linux-acpi mailing list [3] is listed below.
>  - Dont free input device when exit
>  - Not to register rfkill on a device which not exist
>  - Add the poll function on rfkill, I found a way to register a notify function
>    on H/W radio switch (on EC event with query bit 0x81), but after register,
>    the H/W radio switch is no longer function to turn off the radio device. I
>    will keep finding a way to use this event.
>  - Remove auto_enable parameters of rfkill since we have a hardware switch.
>  - Using hotkey deivce ids for module alias
>  - Let the driver simpler for reading
>
> [3] http://patchwork.kernel.org/patch/49912/
>
> === 8< ===
>
> lenovo-sl-laptop: Extra driver for Lenovo SL series laptop
>
> This driver provides support for the following functions.
>  - Hotkeys: LenovoCare, Volumn up/down/mute, Battery, Suspend, WLAN switch,
>             Video switch, Pointer switch (as KEY_PROG1), Dock eject (as
>             KEY_PROG2), Hibernate, Lock screen, Screen Zoom and LCD brightness
>             up/down.
>  - Radio RFKILL: switching on/off UWB, bluetooth and wifi.
>  - LenovoCare LEDs: On, off, Dimmed blinking and standard blinking.
>                     (Blinking supported with ledtrig_timer)
>  - Fan speed: Reading current fan speed
>
> The original author of this driver is Alexandre Rostovtsev
>
> The Lenovo ThinkPad SL series laptops are not supported by the normal
> thinkpad_acpi driver because their firmware is quite different from the
> T-series/R-series/X-series ThinkPads. [3]
>
> [3] http://mailman.linux-thinkpad.org/pipermail/linux-thinkpad/2009-January/046122.html
>
>
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
>
> ---
>  drivers/platform/x86/Kconfig            |   12 +
>  drivers/platform/x86/Makefile           |    1 +
>  drivers/platform/x86/lenovo-sl-laptop.c |  721 +++++++++++++++++++++++++++++++
>  3 files changed, 734 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/platform/x86/lenovo-sl-laptop.c
>
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 55ca39d..1ae72e3 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -143,6 +143,18 @@ config HP_WMI
>  	 To compile this driver as a module, choose M here: the module will
>  	 be called hp-wmi.
>  
> +config LENOVO_SL_LAPTOP
> +	tristate "Lenovo ThinkPad SL Series Laptop Extras"
> +	depends on ACPI
> +	select HWMON
> +	select INPUT
> +	select RFKILL
> +	---help---
> +	  This is a driver for the Lenovo ThinkPad SL series laptops
> +	  (SL300/400/500), which are not supported by the thinkpad_acpi
> +	  driver. This driver adds support for hotkeys, rfkill control,
> +	  the Lenovo Care LED, fan speed.
> +
>  config MSI_LAPTOP
>  	tristate "MSI Laptop Extras"
>  	depends on ACPI
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index d1c1621..1037739 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_DELL_WMI)		+= dell-wmi.o
>  obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
>  obj-$(CONFIG_ACERHDF)		+= acerhdf.o
>  obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
> +obj-$(CONFIG_LENOVO_SL_LAPTOP)	+= lenovo-sl-laptop.o
>  obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
>  obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
>  obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
> diff --git a/drivers/platform/x86/lenovo-sl-laptop.c b/drivers/platform/x86/lenovo-sl-laptop.c
> new file mode 100644
> index 0000000..d8fc093
> --- /dev/null
> +++ b/drivers/platform/x86/lenovo-sl-laptop.c
> @@ -0,0 +1,721 @@
> +/*
> + *  lenovo-sl-laptop.c - Lenovo ThinkPad SL Series Extras Driver
> + *
> + *
> + *  Copyright (C) 2008-2009 Alexandre Rostovtsev <tetromino@gmail.com>
> + *                     2009 Ike Panhc <ike.pan@canonical.com>
> + *
> + *  Largely based on thinkpad_acpi.c, eeepc-laptop.c, and video.c which
> + *  are copyright their respective authors.
> + *
> + *  The original website of this driver is at
> + *  http://github.com/tetromino/lenovo-sl-laptop/tree/master
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + *  02110-1301, USA.
> + *
> + */
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/version.h>
> +#include <linux/init.h>
> +#include <linux/acpi.h>
> +#include <linux/pci_ids.h>
> +#include <linux/rfkill.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/platform_device.h>
> +#include <linux/input.h>
> +#include <linux/uaccess.h>
> +
> +#define LENOVO_SL_MODULE_DESC "Lenovo ThinkPad SL Series Extras driver"
> +#define LENOVO_SL_MODULE_NAME "lenovo-sl-laptop"
> +#define ACPI_EC0_PATH "\\_SB.PCI0.SBRG.EC0"
> +#define ACPI_HKEY_PATH ACPI_EC0_PATH ".HKEY"
> +#define LENOVO_SL_MAX_ACPI_ARGS 3
> +
> +MODULE_AUTHOR("Alexandre Rostovtsev");
> +MODULE_AUTHOR("Ike Panhc");
> +MODULE_DESCRIPTION(LENOVO_SL_MODULE_DESC);
> +MODULE_LICENSE("GPL");
> +
> +/* general */
> +
> +static acpi_handle lenovo_sl_laptop_hkey_handle;
> +static acpi_handle lenovo_sl_laptop_ec0_handle;
> +static struct platform_device *lenovo_sl_laptop_pdev;
> +
> +static int lensl_acpi_int_func(acpi_handle handle, char *pathname,
> +			       int *ret, int n_arg, ...)
> +{
> +	acpi_status status;
> +	struct acpi_object_list params;
> +	union acpi_object in_obj[LENOVO_SL_MAX_ACPI_ARGS], out_obj;
> +	struct acpi_buffer result, *resultp;
> +	int i;
> +	va_list ap;
> +
> +	if (!handle)
> +		return -EINVAL;
> +	if (n_arg < 0 || n_arg > LENOVO_SL_MAX_ACPI_ARGS)
> +		return -EINVAL;
> +	va_start(ap, n_arg);
> +	for (i = 0; i < n_arg; i++) {
> +		in_obj[i].integer.value = va_arg(ap, int);
> +		in_obj[i].type = ACPI_TYPE_INTEGER;
> +	}
> +	va_end(ap);
> +	params.count = n_arg;
> +	params.pointer = in_obj;
> +
> +	if (ret) {
> +		result.length = sizeof(out_obj);
> +		result.pointer = &out_obj;
> +		resultp = &result;
> +	} else
> +		resultp = NULL;
> +
> +	status = acpi_evaluate_object(handle, pathname, &params, resultp);
> +	if (ACPI_FAILURE(status))
> +		return -EIO;
> +	if (ret)
> +		*ret = out_obj.integer.value;
> +
> +	return 0;
> +}
> +
> +/*************************************************************************
> +    Bluetooth, WWAN, UWB
> + *************************************************************************/
> +
> +/* ACPI GBDC/SBDC, GWAN/SWAN, GUWB/SUWB bits */
> +#define	LENOVO_SL_RADIO_HWPRESENT  (0x01) /* hardware is available */
> +#define	LENOVO_SL_RADIO_RADIOSSW   (0x02) /* radio is enabled */
> +#define	LENOVO_SL_RADIO_RESUMECTRL (0x04) /* state at resume: off/last state */
> +
> +struct lensl_radio {
> +	int type;
> +	enum rfkill_type rfktype;
> +	char *rfkname;
> +	struct rfkill *rfk;
> +	char *get_pathname;
> +	char *set_pathname;
> +};
> +
> +static int radio_get_acpi(char *pathname, int *value)
> +{
> +	return lensl_acpi_int_func(lenovo_sl_laptop_hkey_handle, pathname,
> +				   value, 0);
> +}
> +
> +static int radio_set_acpi(char *pathname, int value)
> +{
> +	return lensl_acpi_int_func(lenovo_sl_laptop_hkey_handle, pathname,
> +				   NULL, 1, value);
> +}
> +
> +static int radio_get(struct lensl_radio *radio, bool *sw_blocked,
> +			   bool *hw_blocked)
> +{
> +	int wlsw;
> +	int value;
> +
> +	if (!radio)
> +		return -EINVAL;
> +	if (!radio_get_acpi("WLSW", &wlsw) && wlsw)
> +		*hw_blocked = 0;
> +	else
> +		*hw_blocked = 1;
> +	if (radio_get_acpi(radio->get_pathname, &value))
> +		return -ENODEV;
> +	if (!(value & LENOVO_SL_RADIO_HWPRESENT))
> +		return -ENODEV;
> +	if (value & LENOVO_SL_RADIO_RADIOSSW)
> +		*sw_blocked = 0;
> +	else
> +		*sw_blocked = 1;
> +	return 0;
> +}
> +
> +static int radio_set(struct lensl_radio *radio, bool blocked)
> +{
> +	int res, value;
> +
> +	res = radio_get_acpi(radio->get_pathname, &value);
> +	if (res)
> +		return res;
> +
> +	if (blocked)
> +		value &= ~LENOVO_SL_RADIO_RADIOSSW;
> +	else
> +		value |= LENOVO_SL_RADIO_RADIOSSW;
> +	if (radio_set_acpi(radio->set_pathname, value))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +/* Bluetooth/WWAN/UWB rfkill interface */
> +
> +static void radio_rfkill_query(struct rfkill *rfk, void *data)
> +{
> +	struct lensl_radio *radio = data;
> +	int res;
> +	bool sw_blocked, hw_blocked;
> +
> +	if (!radio)
> +		return;
> +
> +	res = radio_get(radio, &sw_blocked, &hw_blocked);
> +	if (res)
> +		return;
> +
> +	rfkill_set_states(rfk, sw_blocked, hw_blocked);
> +}
> +
> +static int radio_rfkill_set_block(void *data, bool blocked)
> +{
> +	struct lensl_radio *radio = data;
> +	int res;
> +	bool sw_blocked, hw_blocked;
> +
> +	if (!radio)
> +		return -EINVAL;
> +
> +	res = radio_get(radio, &sw_blocked, &hw_blocked);
> +	if (res)
> +		return res;
> +
> +	if (hw_blocked)
> +		return 0;
> +	if (sw_blocked == blocked)
> +		return 0;
> +
> +	return radio_set(radio, sw_blocked);
> +}
> +
> +static struct rfkill_ops radio_rfkops = {
> +	.poll = radio_rfkill_query,
> +	.query = radio_rfkill_query,
> +	.set_block = radio_rfkill_set_block,
> +};
> +
> +/* Bluetooth/WWAN/UWB init and exit and HW switch notification */
> +
> +static struct lensl_radio radio_radios[3] = {
> +#define RADIO_BLUETOOTH (0)
> +	{
> +		.type = RADIO_BLUETOOTH,
> +		.rfktype = RFKILL_TYPE_BLUETOOTH,
> +		.rfkname = "lenovo-sl-bluetooth",
> +		.get_pathname = "GBDC",
> +		.set_pathname = "SBDC",
> +	},
> +#define RADIO_WWAN (1)
> +	{
> +		.type = RADIO_WWAN,
> +		.rfktype = RFKILL_TYPE_WWAN,
> +		.rfkname = "lenovo-sl-wwan",
> +		.get_pathname = "GWAN",
> +		.set_pathname = "SWAN",
> +	},
> +#define RADIO_UWB (2)
> +	{
> +		.type = RADIO_UWB,
> +		.rfktype = RFKILL_TYPE_UWB,
> +		.rfkname = "lenovo-sl-uwb",
> +		.get_pathname = "GUWB",
> +		.set_pathname = "SUWB",
> +	},
> +};
> +
> +static void radio_exit(int type)
> +{
> +	if (radio_radios[type].rfk) {
> +		rfkill_unregister(radio_radios[type].rfk);
> +		rfkill_destroy(radio_radios[type].rfk);
> +		radio_radios[type].rfk = NULL;
> +	}
> +}
> +
> +static int radio_init(int type)
> +{
> +	int res;
> +	bool sw_blocked, hw_blocked;
> +
> +	if (!lenovo_sl_laptop_hkey_handle)
> +		return -ENODEV;
> +
> +	/* 1st: Get the sw/hw status */
> +	res = radio_get(&radio_radios[type], &sw_blocked, &hw_blocked);
> +	if (res)
> +		return res;
> +
> +	/* 2nd: allocate rfkill */
> +	radio_radios[type].rfk = rfkill_alloc(radio_radios[type].rfkname,
> +					      &lenovo_sl_laptop_pdev->dev,
> +					      radio_radios[type].rfktype,
> +					      &radio_rfkops,
> +					      &radio_radios[type]);
> +	if (!(radio_radios[type].rfk)) {
> +		pr_err("Failed to allocate memory for rfkill class\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* 3rd: Set status */
> +	rfkill_init_sw_state(radio_radios[type].rfk, sw_blocked);
> +	rfkill_set_hw_state(radio_radios[type].rfk, hw_blocked);
> +
> +	/* 4th: Register rfkill */
> +	res = rfkill_register(radio_radios[type].rfk);
> +	if (res < 0) {
> +		pr_err("Failed to register %s rfkill switch: %d\n",
> +			radio_radios[type].rfkname, res);
> +		rfkill_destroy(radio_radios[type].rfk);
> +		radio_radios[type].rfk = NULL;
> +	}
> +
> +	return res;
> +}
> +
> +/*************************************************************************
> +    LEDs
> + *************************************************************************/
> +#ifdef CONFIG_NEW_LEDS
> +
> +#define LED_OFF   0
> +#define LED_ON    0x02
> +#define LED_BLINK 0x01
> +#define LED_DIM   0x100
> +
> +/* equivalent to the ThinkVantage LED on other ThinkPads */
> +#define LED_NAME "lensl::lenovocare"
> +#define LED_WQ_NAME "lenovo-sl-led-wq"
> +
> +static struct workqueue_struct *led_wq;
> +
> +struct {
> +	struct led_classdev cdev;
> +	enum led_brightness brightness;
> +	int supported, new_code;
> +	struct work_struct work;
> +} led_tv;
> +
> +static inline int led_set_tvls(int code)
> +{
> +	return lensl_acpi_int_func(lenovo_sl_laptop_hkey_handle, "TVLS", NULL,
> +				   1, code);
> +}
> +
> +static void led_tv_worker(struct work_struct *work)
> +{
> +	if (!led_tv.supported)
> +		return;
> +	led_set_tvls(led_tv.new_code);
> +	if (led_tv.new_code)
> +		led_tv.brightness = LED_FULL;
> +	else
> +		led_tv.brightness = LED_OFF;
> +}
> +
> +static void led_tv_brightness_set_sysfs(struct led_classdev *led_cdev,
> +					enum led_brightness brightness)
> +{
> +	switch (brightness) {
> +	case LED_OFF:
> +		led_tv.new_code = LED_OFF;
> +		break;
> +	case LED_FULL:
> +		led_tv.new_code = LED_ON;
> +		break;
> +	default:
> +		return;
> +	}
> +	queue_work(led_wq, &led_tv.work);
> +}
> +
> +static enum led_brightness led_tv_brightness_get_sysfs(
> +						struct led_classdev *led_cdev)
> +{
> +	return led_tv.brightness;
> +}
> +
> +static int led_tv_blink_set_sysfs(struct led_classdev *led_cdev,
> +				  unsigned long *delay_on,
> +				  unsigned long *delay_off)
> +{
> +	if (*delay_on == 0 && *delay_off == 0) {
> +		/* If we can choose the flash rate, use dimmed blinking --
> +		   it looks better */
> +		led_tv.new_code = LED_ON |
> +			LED_BLINK | LED_DIM;
> +		*delay_on = 2000;
> +		*delay_off = 2000;
> +	} else if (*delay_on + *delay_off == 4000) {
> +		/* User wants dimmed blinking */
> +		led_tv.new_code = LED_ON |
> +			LED_BLINK | LED_DIM;
> +	} else if (*delay_on == 7250 && *delay_off == 500) {
> +		/* User wants standard blinking mode */
> +		led_tv.new_code = LED_ON | LED_BLINK;
> +	} else
> +		return -EINVAL;
> +	queue_work(led_wq, &led_tv.work);
> +	return 0;
> +}
> +
> +static void led_exit(void)
> +{
> +	led_set_tvls(LED_OFF);
> +	destroy_workqueue(led_wq);
> +	if (led_tv.supported) {
> +		led_classdev_unregister(&led_tv.cdev);
> +		led_tv.supported = 0;
> +	}
> +}
> +
> +static int led_init(void)
> +{
> +	int res;
> +
> +	led_wq = create_singlethread_workqueue(LED_WQ_NAME);
> +	if (!led_wq) {
> +		pr_err("Failed to create a workqueue\n");
> +		return -ENOMEM;
> +	}
> +
> +	memset(&led_tv, 0, sizeof(led_tv));
> +	led_tv.cdev.brightness_get = led_tv_brightness_get_sysfs;
> +	led_tv.cdev.brightness_set = led_tv_brightness_set_sysfs;
> +	led_tv.cdev.blink_set = led_tv_blink_set_sysfs;
> +	led_tv.cdev.name = LED_NAME;
> +	INIT_WORK(&led_tv.work, led_tv_worker);
> +	led_set_tvls(LED_ON);
> +	res = led_classdev_register(&lenovo_sl_laptop_pdev->dev, &led_tv.cdev);
> +	if (res) {
> +		pr_warning("Failed to register LED device\n");
> +		return res;
> +	}
> +	led_tv.supported = 1;
> +	return 0;
> +}
> +
> +#else /* CONFIG_NEW_LEDS */
> +
> +static void led_exit(void)
> +{
> +}
> +
> +static int led_init(void)
> +{
> +	return -ENODEV;
> +}
> +
> +#endif /* CONFIG_NEW_LEDS */
> +
> +/*************************************************************************
> +    hwmon & fans
> + *************************************************************************/
> +
> +static struct device *hwmon_device;
> +
> +static inline int hwmon_get_tach(int *value, int fan)
> +{
> +	return lensl_acpi_int_func(lenovo_sl_laptop_ec0_handle, "TACH", value,
> +				   1, fan);
> +}
> +
> +static ssize_t hwmon_fan1_input_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	int res;
> +	int rpm;
> +
> +	res = hwmon_get_tach(&rpm, 0);
> +	if (res)
> +		return res;
> +	return snprintf(buf, PAGE_SIZE, "%u\n", rpm);
> +}
> +
> +static struct device_attribute hwmon_fan1_input =
> +	__ATTR(fan1_input, S_IRUGO, hwmon_fan1_input_show, NULL);
> +
> +static struct attribute *hwmon_attributes[] = {
> +	&hwmon_fan1_input.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group hwmon_attr_group = {
> +	.attrs = hwmon_attributes,
> +};
> +
> +static void hwmon_exit(void)
> +{
> +	if (!hwmon_device)
> +		return;
> +
> +	sysfs_remove_group(&hwmon_device->kobj, &hwmon_attr_group);
> +	hwmon_device_unregister(hwmon_device);
> +	hwmon_device = NULL;
> +}
> +
> +static int hwmon_init(void)
> +{
> +	int res;
> +
> +	hwmon_device = hwmon_device_register(&lenovo_sl_laptop_pdev->dev);
> +	if (!hwmon_device) {
> +		pr_err("Failed to register hwmon device\n");
> +		return -ENODEV;
> +	}
> +
> +	res = sysfs_create_group(&hwmon_device->kobj, &hwmon_attr_group);
> +	if (res < 0) {
> +		pr_err("Failed to create hwmon sysfs group\n");
> +		hwmon_device_unregister(hwmon_device);
> +		hwmon_device = NULL;
> +		return -ENODEV;
> +	}
> +	return 0;
> +}
> +
> +/*************************************************************************
> +    hotkeys
> + *************************************************************************/
> +
> +typedef int (*acpi_ec_query_func) (void *data);
> +extern int acpi_ec_add_query_handler(void *ec, u8 query_bit,
> +				     acpi_handle handle,
> +				     acpi_ec_query_func func,
> +				     void *data);
> +extern void acpi_ec_remove_query_handler(void *ec, u8 query_bit);
> +
> +struct key_entry {
> +	char type;
> +	u8 scancode;
> +	int keycode;
> +};
> +
> +enum { KE_KEY, KE_END };
> +
> +static struct input_dev *hkey_inputdev;
> +
> +static struct key_entry hkey_keymap[] = {
> +	{KE_KEY, 0x0B, KEY_COFFEE },
> +	{KE_KEY, 0x0C, KEY_BATTERY },
> +	{KE_KEY, 0x0D, KEY_SLEEP },
> +	{KE_KEY, 0x0E, KEY_WLAN },
> +	{KE_KEY, 0x10, KEY_SWITCHVIDEOMODE },
> +	{KE_KEY, 0x11, KEY_PROG1 },
> +	{KE_KEY, 0x12, KEY_PROG2 },
> +	{KE_KEY, 0x15, KEY_SUSPEND },
> +	{KE_KEY, 0x69, KEY_VOLUMEUP },
> +	{KE_KEY, 0x6A, KEY_VOLUMEDOWN },
> +	{KE_KEY, 0x6B, KEY_MUTE },
> +	{KE_KEY, 0x6C, KEY_BRIGHTNESSDOWN },
> +	{KE_KEY, 0x6D, KEY_BRIGHTNESSUP },
> +	{KE_KEY, 0x71, KEY_ZOOM },
> +	{KE_KEY, 0x80, KEY_VENDOR },
> +	{KE_END, 0},
> +};
> +
> +static int hkey_action(void *data)
> +{
> +	int keycode;
> +	struct key_entry *this_key = data;
> +
> +	if (!data)
> +		return -EINVAL;
> +	keycode = this_key->keycode;
> +
> +	if (keycode != KEY_RESERVED) {
> +		input_report_key(hkey_inputdev, keycode, 1);
> +		input_sync(hkey_inputdev);
> +		input_report_key(hkey_inputdev, keycode, 0);
> +		input_sync(hkey_inputdev);
> +	}
> +
> +	return 0;
> +}
> +
> +static int hkey_add(struct acpi_device *device)
> +{
> +	int result;
> +	struct key_entry *key;
> +
> +	for (key = hkey_keymap; key->type != KE_END; key++) {
> +		result = acpi_ec_add_query_handler(
> +				acpi_driver_data(device->parent),
> +				key->scancode, NULL,
> +				hkey_action, key);
> +		if (result) {
> +			pr_err("Failed to register hotkey notification.\n");
> +			return -ENODEV;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int hkey_remove(struct acpi_device *device, int type)
> +{
> +	struct key_entry *key;
> +
> +	for (key = hkey_keymap; key->type != KE_END; key++) {
> +		acpi_ec_remove_query_handler(
> +			acpi_driver_data(device->parent),
> +			key->scancode);
> +	}
> +	return 0;
> +}
> +
> +static const struct acpi_device_id hkey_ids[] = {
> +	{"LEN0014", 0},
> +	{"", 0},
> +};
> +
> +static struct acpi_driver hkey_driver = {
> +	.name = "lenovo-sl-laptop-hotkey",
> +	.class = "lenovo",
> +	.ids = hkey_ids,
> +	.owner = THIS_MODULE,
> +	.ops = {
> +		.add = hkey_add,
> +		.remove = hkey_remove,
> +	},
> +};
> +
> +static void hkey_inputdev_exit(void)
> +{
> +	if (hkey_inputdev)
> +		input_unregister_device(hkey_inputdev);
> +}
> +
> +static int hkey_inputdev_init(void)
> +{
> +	int result;
> +	struct key_entry *key;
> +
> +	hkey_inputdev = input_allocate_device();
> +	if (!hkey_inputdev) {
> +		pr_err("Failed to allocate hotkey input device\n");
> +		return -ENODEV;
> +	}
> +	hkey_inputdev->name = "Lenovo ThinkPad SL Series extra buttons";
> +	hkey_inputdev->phys = LENOVO_SL_MODULE_NAME "/input0";
> +	hkey_inputdev->uniq = LENOVO_SL_MODULE_NAME;
> +	hkey_inputdev->id.bustype = BUS_HOST;
> +	hkey_inputdev->id.vendor = PCI_VENDOR_ID_LENOVO;
> +	hkey_inputdev->dev.parent = &lenovo_sl_laptop_pdev->dev;
> +	set_bit(EV_KEY, hkey_inputdev->evbit);
> +
> +	for (key = hkey_keymap; key->type != KE_END; key++)
> +		set_bit(key->keycode, hkey_inputdev->keybit);
> +
> +	result = input_register_device(hkey_inputdev);
> +	if (result) {
> +		pr_err("Failed to register hotkey input device\n");
> +		input_free_device(hkey_inputdev);
> +		hkey_inputdev = NULL;
> +		return -ENODEV;
> +	}
> +	return 0;
> +}
> +
> +static void hkey_init(void)
> +{
> +	int result;
> +
> +	result = hkey_inputdev_init();
> +	if (result) {
> +		pr_err("Failed to register input device for hotkeys\n");
> +		return;
> +	}
> +	result = acpi_bus_register_driver(&hkey_driver);
> +	if (result)
> +		pr_err("Failed to register hotkey driver\n");
> +	return;
> +}
> +
> +static void hkey_exit(void)
> +{
> +	hkey_inputdev_exit();
> +	acpi_bus_unregister_driver(&hkey_driver);
> +}
> +
> +/*************************************************************************
> +    init/exit
> + *************************************************************************/
> +
> +static int __init lenovo_sl_laptop_init(void)
> +{
> +	int ret;
> +	acpi_status status;
> +
> +	if (acpi_disabled)
> +		return -ENODEV;
> +
> +	lenovo_sl_laptop_hkey_handle = lenovo_sl_laptop_ec0_handle = NULL;
> +	status = acpi_get_handle(NULL, ACPI_HKEY_PATH,
> +				 &lenovo_sl_laptop_hkey_handle);
> +	if (ACPI_FAILURE(status)) {
> +		pr_err("Failed to get ACPI handle for %s\n", ACPI_HKEY_PATH);
> +		return -ENODEV;
> +	}
> +	status = acpi_get_handle(NULL, ACPI_EC0_PATH,
> +				 &lenovo_sl_laptop_ec0_handle);
> +	if (ACPI_FAILURE(status)) {
> +		pr_err("Failed to get ACPI handle for %s\n", ACPI_EC0_PATH);
> +		return -ENODEV;
> +	}
> +
> +	lenovo_sl_laptop_pdev = platform_device_register_simple(
> +							LENOVO_SL_MODULE_NAME,
> +							-1, NULL, 0);
> +	if (IS_ERR(lenovo_sl_laptop_pdev)) {
> +		ret = PTR_ERR(lenovo_sl_laptop_pdev);
> +		lenovo_sl_laptop_pdev = NULL;
> +		pr_err("Failed to register platform device\n");
> +		return ret;
> +	}
> +
> +	radio_init(RADIO_BLUETOOTH);
> +	radio_init(RADIO_WWAN);
> +	radio_init(RADIO_UWB);
> +
> +	hkey_init();
> +	led_init();
> +	hwmon_init();
> +
> +	return 0;
> +}
> +
> +static void __exit lenovo_sl_laptop_exit(void)
> +{
> +	hwmon_exit();
> +	led_exit();
> +	hkey_exit();
> +
> +	radio_exit(RADIO_UWB);
> +	radio_exit(RADIO_WWAN);
> +	radio_exit(RADIO_BLUETOOTH);
> +
> +	if (lenovo_sl_laptop_pdev)
> +		platform_device_unregister(lenovo_sl_laptop_pdev);
> +}
> +
> +MODULE_DEVICE_TABLE(acpi, hkey_ids);
> +
> +module_init(lenovo_sl_laptop_init);
> +module_exit(lenovo_sl_laptop_exit);
>   

