Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZCDNeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZCDNeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZCDNe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:34:27 -0500
Received: from mail.polezero.com ([216.68.55.34]:43433 "EHLO
	firewall.polezero.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751537AbZCDNe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:34:26 -0500
Subject: Re: New HID device support
From: Jason Noble <nobleja@polezero.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0903041419250.4971@jikos.suse.cz>
References: <1236096277.26321.29.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>
	 <1236107096.7793.1.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903041144310.4971@jikos.suse.cz>
	 <1236172544.21288.3.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903041419250.4971@jikos.suse.cz>
Content-Type: multipart/mixed; boundary="=-StzUAbb9t7Ie9wg/0Hxg"
Date: Wed, 04 Mar 2009 08:34:14 -0500
Message-Id: <1236173654.21288.8.camel@paradox.pz.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-StzUAbb9t7Ie9wg/0Hxg
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Sorry to be such a bother.
Attached .rej files if they help.

clean just untared 2.6.28.7

patching file a/drivers/hid/Kconfig
Hunk #1 succeeded at 157 with fuzz 2.
patching file a/drivers/hid/Makefile
Hunk #1 FAILED at 30.
1 out of 1 hunk FAILED -- saving rejects to file
a/drivers/hid/Makefile.rej
patching file a/drivers/hid/hid-core.c
Hunk #1 FAILED at 1271.
1 out of 1 hunk FAILED -- saving rejects to file
a/drivers/hid/hid-core.c.rej
patching file a/drivers/hid/hid-dummy.c
Hunk #1 succeeded at 34 with fuzz 2.
patching file a/drivers/hid/hid-ids.h
Hunk #1 FAILED at 279.
1 out of 1 hunk FAILED -- saving rejects to file
a/drivers/hid/hid-ids.h.rej
patching file b/drivers/hid/hid-kensington.c
paradox:/usr/src# ls a/drivers/hid/Makefile.rej 
a/drivers/hid/Makefile.rej





On Wed, 2009-03-04 at 14:20 +0100, Jiri Kosina wrote:
> On Wed, 4 Mar 2009, Jason Noble wrote:
> 
> > 2.6.28.7
> > 
> > patching file a/drivers/hid/Kconfig
> > Hunk #1 succeeded at 157 with fuzz 2 (offset 7 lines).
> > patching file a/drivers/hid/Makefile
> > Hunk #1 FAILED at 29.
> > 1 out of 1 hunk FAILED -- saving rejects to file
> > a/drivers/hid/Makefile.rej
> > patching file a/drivers/hid/hid-core.c
> > Hunk #1 FAILED at 1270.
> > 1 out of 1 hunk FAILED -- saving rejects to file
> > a/drivers/hid/hid-core.c.rej
> > patching file a/drivers/hid/hid-dummy.c
> > Hunk #1 succeeded at 34 with fuzz 2 (offset -3 lines).
> > patching file a/drivers/hid/hid-ids.h
> > Hunk #1 FAILED at 274.
> > 1 out of 1 hunk FAILED -- saving rejects to file
> > a/drivers/hid/hid-ids.h.rej
> > patching file b/drivers/hid/hid-kensington.c
> 
> The patch was against HID development tree.
> 
> Please try the one below instead, I have refreshed it to apply on top of 
> 2.6.28.7
> 
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index b4fd8ca..d1669d4 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -157,6 +157,13 @@ config HID_GYRATION
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
> index b09e43e..feb3682 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
>  obj-$(CONFIG_HID_DELL)		+= hid-dell.o
>  obj-$(CONFIG_HID_EZKEY)		+= hid-ezkey.o
>  obj-$(CONFIG_HID_GYRATION)	+= hid-gyration.o
> +obj-$(CONFIG_HID_KENSINGTON)	+= hid-kensington.o
>  obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
>  obj-$(CONFIG_HID_MICROSOFT)	+= hid-microsoft.o
>  obj-$(CONFIG_HID_MONTEREY)	+= hid-monterey.o
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 40df3e1..d0e1e3d 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1271,6 +1271,7 @@ static const struct hid_device_id hid_blacklist[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0003) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
> diff --git a/drivers/hid/hid-dummy.c b/drivers/hid/hid-dummy.c
> index e148f86..128b873 100644
> --- a/drivers/hid/hid-dummy.c
> +++ b/drivers/hid/hid-dummy.c
> @@ -34,6 +34,9 @@ static int __init hid_dummy_init(void)
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
> index 3928969..11f9f6e 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -279,6 +279,9 @@
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=-StzUAbb9t7Ie9wg/0Hxg
Content-Disposition: attachment; filename=hid-core.c.rej
Content-Type: application/x-reject; name=hid-core.c.rej
Content-Transfer-Encoding: 7bit

*************** static const struct hid_device_id hid_blacklist[] = {
*** 1271,1276 ****
         { HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0003) },
         { HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
         { HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
         { HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
         { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
         { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
--- 1271,1277 ----
         { HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0003) },
         { HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
         { HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
+        { HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
         { HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
         { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
         { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },

--=-StzUAbb9t7Ie9wg/0Hxg
Content-Disposition: attachment; filename=hid-ids.h.rej
Content-Type: application/x-reject; name=hid-ids.h.rej
Content-Transfer-Encoding: 7bit

***************
*** 279,284 ****
  #define USB_DEVICE_ID_LD_POWERCONTROL  0x2030
  #define USB_DEVICE_ID_LD_MACHINETEST   0x2040
  
  #define USB_VENDOR_ID_LOGITECH         0x046d
  #define USB_DEVICE_ID_LOGITECH_RECEIVER        0xc101
  #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
--- 279,287 ----
  #define USB_DEVICE_ID_LD_POWERCONTROL  0x2030
  #define USB_DEVICE_ID_LD_MACHINETEST   0x2040
  
+ #define USB_VENDOR_ID_KENSINGTON       0x047d
+ #define USB_DEVICE_ID_KS_SLIMBLADE     0x2041
+ 
  #define USB_VENDOR_ID_LOGITECH         0x046d
  #define USB_DEVICE_ID_LOGITECH_RECEIVER        0xc101
  #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110

--=-StzUAbb9t7Ie9wg/0Hxg
Content-Disposition: attachment; filename=Makefile.rej
Content-Type: application/x-reject; name=Makefile.rej
Content-Transfer-Encoding: 7bit

*************** obj-$(CONFIG_HID_CYPRESS)     += hid-cypress.o
*** 30,35 ****
  obj-$(CONFIG_HID_DELL)         += hid-dell.o
  obj-$(CONFIG_HID_EZKEY)                += hid-ezkey.o
  obj-$(CONFIG_HID_GYRATION)     += hid-gyration.o
  obj-$(CONFIG_HID_LOGITECH)     += hid-logitech.o
  obj-$(CONFIG_HID_MICROSOFT)    += hid-microsoft.o
  obj-$(CONFIG_HID_MONTEREY)     += hid-monterey.o
--- 30,36 ----
  obj-$(CONFIG_HID_DELL)         += hid-dell.o
  obj-$(CONFIG_HID_EZKEY)                += hid-ezkey.o
  obj-$(CONFIG_HID_GYRATION)     += hid-gyration.o
+ obj-$(CONFIG_HID_KENSINGTON)   += hid-kensington.o
  obj-$(CONFIG_HID_LOGITECH)     += hid-logitech.o
  obj-$(CONFIG_HID_MICROSOFT)    += hid-microsoft.o
  obj-$(CONFIG_HID_MONTEREY)     += hid-monterey.o

--=-StzUAbb9t7Ie9wg/0Hxg--

