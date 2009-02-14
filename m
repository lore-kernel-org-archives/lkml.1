Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZBNQBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZBNQBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 11:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbZBNQBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 11:01:06 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:11000 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbZBNQBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 11:01:05 -0500
From: Frans Pop <elendil@planet.nl>
To: pavel@suse.cz
Subject: Re: hp accelerometer: add freefall detection
Date: Sat, 14 Feb 2009 17:01:01 +0100
User-Agent: KMail/1.9.9
Cc: =?iso-8859-1?q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, trenn@suse.de
References: <200901162234.n0GMYB8Z022317@imap1.linux-foundation.org> <200901162234.n0GMYB8Z022317@imap1.linux-foundation.org> <4992C57E.9050109@tremplin-utc.net>
In-reply-To: <4992C57E.9050109@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902141701.02876.elendil@planet.nl>
X-OriginalArrivalTime: 14 Feb 2009 16:01:03.0254 (UTC) FILETIME=[6FCE8B60:01C98EBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> +++ b/drivers/hwmon/lis3lv02d.c
[...]
> +static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
[...]
> +       if (ret) {
> +               clear_bit(0, &adev.misc_opened);
> +               printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", ad
> +               return -EBUSY;
> +       }
> +       lis3lv02d_increase_use(&adev);
> +       printk("lis3: registered interrupt %d\n", adev.irq);

Is this a debug printk that should be removed altogether or should it
be given a proper format and KERN_DEBUG?

> +       return 0;
> +}
[...]
> @@ -268,6 +393,19 @@ int lis3lv02d_init_device(struct acpi_lis3lv02d
> *dev) if (lis3lv02d_joystick_enable())
>                 printk(KERN_ERR DRIVER_NAME ": joystick initialization failed
>
> +       printk("lis3_init_device: irq %d\n", dev->irq);

Same here.

> +
> +       /* if we did not get an IRQ from ACPI - we have nothing more to do */
> +       if (!dev->irq) { 
> +               printk(KERN_ERR DRIVER_NAME
> +                       ": No IRQ in ACPI. Disabling /dev/freefall\n");
> +               goto out;
> +       }
> +
> +       printk("lis3: registering device\n");

And here.

> +       if (misc_register(&lis3lv02d_misc_device))
> +               printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");

Cheers,
FJP
