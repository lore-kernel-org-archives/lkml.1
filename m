Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZCDNJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZCDNJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbZCDNJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:09:15 -0500
Received: from mail.polezero.com ([216.68.55.34]:52432 "EHLO
	firewall.polezero.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbZCDNJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:09:14 -0500
Subject: Re: New HID device support
From: Jason Noble <nobleja@polezero.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0903041144310.4971@jikos.suse.cz>
References: <1236096277.26321.29.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>
	 <1236107096.7793.1.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903041144310.4971@jikos.suse.cz>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 08:08:50 -0500
Message-Id: <1236172130.21288.2.camel@paradox.pz.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should this apply against 2.6.28.7?
Sorry, I'm probably doing something wrong, I've only ever applied whole
kernel patches.

cd /usr/src
patch -p0 < patch-file-name-here

On Wed, 2009-03-04 at 11:45 +0100, Jiri Kosina wrote:
> On Tue, 3 Mar 2009, Jason Noble wrote:
> 
> > Attached is the output.
> 
> Thanks. Does the driver below make your device work properly?
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> HID: support for Kensington silblade trackball
> 
> Establish proper button mappings for 0x47d/0x2041 device.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 9cc662c..c16fc4f 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -150,6 +150,13 @@ config HID_GYRATION
>  	---help---
>  	Support for Gyration remote control.
>  
> +config HID_KENSINGTON
> +	tristate "Kensington" if EMBEDDED
> +	depends on USB_HID
> +	default !EMBEDDED
> +	---help---
> +	Support for Kensington Slimblade Trackball.
> +
>  config HID_LOGITECH
>  	tristate "Logitech" if EMBEDDED
>  	depends on USB_HID
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index 0fdbda6..53e1331 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
>  obj-$(CONFIG_DRAGONRISE_FF)	+= hid-drff.o
>  obj-$(CONFIG_HID_EZKEY)		+= hid-ezkey.o
>  obj-$(CONFIG_HID_GYRATION)	+= hid-gyration.o
> +obj-$(CONFIG_HID_KENSINGTON)	+= hid-kensington.o
>  obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
>  obj-$(CONFIG_HID_MICROSOFT)	+= hid-microsoft.o
>  obj-$(CONFIG_HID_MONTEREY)	+= hid-monterey.o
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 941e7d6..320442c 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1270,6 +1270,7 @@ static const struct hid_device_id hid_blacklist[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0012) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
> diff --git a/drivers/hid/hid-dummy.c b/drivers/hid/hid-dummy.c
> index 536aa15..28815fd 100644
> --- a/drivers/hid/hid-dummy.c
> +++ b/drivers/hid/hid-dummy.c
> @@ -37,6 +37,9 @@ static int __init hid_dummy_init(void)
>  #ifdef CONFIG_HID_GYRATION_MODULE
>  	HID_COMPAT_CALL_DRIVER(gyration);
>  #endif
> +#ifdef CONFIG_HID_KENSINGTON_MODULE
> +	HID_COMPAT_CALL_DRIVER(kensington);
> +#endif
>  #ifdef CONFIG_HID_LOGITECH_MODULE
>  	HID_COMPAT_CALL_DRIVER(logitech);
>  #endif
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 6c730de..c3c9e63 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -274,6 +274,9 @@
>  #define USB_DEVICE_ID_LD_POWERCONTROL	0x2030
>  #define USB_DEVICE_ID_LD_MACHINETEST	0x2040
>  
> +#define USB_VENDOR_ID_KENSINGTON	0x047d
> +#define USB_DEVICE_ID_KS_SLIMBLADE	0x2041
> +
>  #define USB_VENDOR_ID_LOGITECH		0x046d
>  #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
>  #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
> diff --git a/drivers/hid/hid-kensington.c b/drivers/hid/hid-kensington.c
> new file mode 100644
> index 0000000..aff0e24
> --- /dev/null
> +++ b/drivers/hid/hid-kensington.c
> @@ -0,0 +1,65 @@
> +/*
> + *  HID driver for Kensigton special device
> + *
> + *  Copyright (c) 2009 Jiri Kosina
> + */
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/input.h>
> +#include <linux/hid.h>
> +#include <linux/module.h>
> +
> +#include "hid-ids.h"
> +
> +#define ks_map_key(c)	hid_map_usage(hi, usage, bit, max, EV_KEY, (c))
> +
> +static int ks_input_mapping(struct hid_device *hdev, struct hid_input *hi,
> +		struct hid_field *field, struct hid_usage *usage,
> +		unsigned long **bit, int *max)
> +{
> +	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_MSVENDOR)
> +		return 0;
> +
> +	switch (usage->hid & HID_USAGE) {
> +	case 0x01: ks_map_key(BTN_2);	break;
> +	case 0x02: ks_map_key(BTN_3);	break;
> +	default:
> +		return 0;
> +	}
> +	return 1;
> +}
> +
> +static const struct hid_device_id ks_devices[] = {
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(hid, ks_devices);
> +
> +static struct hid_driver ks_driver = {
> +	.name = "kensington",
> +	.id_table = ks_devices,
> +	.input_mapping = ks_input_mapping,
> +};
> +
> +static int ks_init(void)
> +{
> +	return hid_register_driver(&ks_driver);
> +}
> +
> +static void ks_exit(void)
> +{
> +	hid_unregister_driver(&ks_driver);
> +}
> +
> +module_init(ks_init);
> +module_exit(ks_exit);
> +MODULE_LICENSE("GPL");
> +
> +HID_COMPAT_LOAD_DRIVER(kensington);

