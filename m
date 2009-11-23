Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZKWQIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZKWQIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZKWQIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:08:43 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42451 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZKWQIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:08:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=biJzBQYOwXAmHsjn2Vnh2NhzLru8rGkhRQ9eoRxxm0rWgR9TpU8ggx7fmCMPDWCWv8
         Z6OVFy6W1QE22yCDH7J4ESs/RjQa9QWlZtEZ1iDPsi3mHvespP9S8tm245IpbRT2fR8U
         8liyUC8HZrwMnJHflf+rnSj5+KVA+jUk7jobs=
Date: Mon, 23 Nov 2009 08:08:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] do not overwrite the first part of phys string
Message-ID: <20091123160841.GA3491@core.coreip.homeip.net>
References: <4B079CE0.60604@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B079CE0.60604@freemail.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

Do you want to split out usbkbd section or do you want me to pick up
everything?

Thanks.

On Sat, Nov 21, 2009 at 08:55:12AM +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Use strlcat() to append a string to the previously created first part.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -upr linux-2.6.32-rc7.orig/drivers/hid/usbhid/usbkbd.c linux-2.6.32-rc7/drivers/hid/usbhid/usbkbd.c
> --- linux-2.6.32-rc7.orig/drivers/hid/usbhid/usbkbd.c	2009-09-10 00:13:59.000000000 +0200
> +++ linux-2.6.32-rc7/drivers/hid/usbhid/usbkbd.c	2009-11-21 08:48:32.000000000 +0100
> @@ -266,7 +266,7 @@ static int usb_kbd_probe(struct usb_inte
>  			 le16_to_cpu(dev->descriptor.idProduct));
> 
>  	usb_make_path(dev, kbd->phys, sizeof(kbd->phys));
> -	strlcpy(kbd->phys, "/input0", sizeof(kbd->phys));
> +	strlcat(kbd->phys, "/input0", sizeof(kbd->phys));
> 
>  	input_dev->name = kbd->name;
>  	input_dev->phys = kbd->phys;
> diff -upr linux-2.6.32-rc7.orig/drivers/input/misc/ati_remote.c linux-2.6.32-rc7/drivers/input/misc/ati_remote.c
> --- linux-2.6.32-rc7.orig/drivers/input/misc/ati_remote.c	2009-09-10 00:13:59.000000000 +0200
> +++ linux-2.6.32-rc7/drivers/input/misc/ati_remote.c	2009-11-21 08:48:50.000000000 +0100
> @@ -766,7 +766,7 @@ static int ati_remote_probe(struct usb_i
>  	ati_remote->interface = interface;
> 
>  	usb_make_path(udev, ati_remote->phys, sizeof(ati_remote->phys));
> -	strlcpy(ati_remote->phys, "/input0", sizeof(ati_remote->phys));
> +	strlcat(ati_remote->phys, "/input0", sizeof(ati_remote->phys));
> 
>  	if (udev->manufacturer)
>  		strlcpy(ati_remote->name, udev->manufacturer, sizeof(ati_remote->name));
> diff -upr linux-2.6.32-rc7.orig/drivers/input/misc/powermate.c linux-2.6.32-rc7/drivers/input/misc/powermate.c
> --- linux-2.6.32-rc7.orig/drivers/input/misc/powermate.c	2009-09-10 00:13:59.000000000 +0200
> +++ linux-2.6.32-rc7/drivers/input/misc/powermate.c	2009-11-21 08:48:44.000000000 +0100
> @@ -338,7 +338,7 @@ static int powermate_probe(struct usb_in
>  	pm->input = input_dev;
> 
>  	usb_make_path(udev, pm->phys, sizeof(pm->phys));
> -	strlcpy(pm->phys, "/input0", sizeof(pm->phys));
> +	strlcat(pm->phys, "/input0", sizeof(pm->phys));
> 
>  	spin_lock_init(&pm->lock);
> 

-- 
Dmitry
