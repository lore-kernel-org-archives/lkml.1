Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0CBXXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:23:41 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:62669 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0CBXXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:23:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VMrQDRvaN/jHyHlUiP0hO0ep+4CbNM/U7NP4Dv6AVdt0xxRg+5hZi/v3Oo7/0hw/Hf
         +DlxQOQkem0gVshwS//1shpEvXfY2NQIjxiao5brW6BmmTuDO5lp+ILmTkzy7N7H/Gww
         4bL72m/hCbH2NjkeIVMs1U4Qv6tlDNMNX9Gyw=
MIME-Version: 1.0
In-Reply-To: <201003021848.o22ImLSS004394@mustang.cs.nmsu.edu>
References: <201003021848.o22ImLSS004394@mustang.cs.nmsu.edu>
Date: Wed, 3 Mar 2010 07:23:37 +0800
Message-ID: <45a44e481003021523h4a05a9bfu9691f2c0f2f053c7@mail.gmail.com>
Subject: Re: [PATCH] hid Logitech G13 Driver 0.0.5
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Cc: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, pavel@ucw.cz,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       FlorianSchandinat@gmx.de, krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-fbdev@vger.kernel.org, jkosina@suse.cz, bonbons@linux-vserver.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 2:48 AM, Rick L. Vinyard Jr.
<rvinyard@cs.nmsu.edu> wrote:
> [PATCH] hid Logitech G13 Driver 0.0.5

Hi Rick,

Thanks for posting this. It has improved a lot.

>
> This driver relies on two patches:
>  1. Bruno Prémont's [PATCH 2/3] hid: add suspend/resume hooks for hid drivers
>  2. [PATCH] Add sysfs support for fbdefio delay

Please help me understand in what way does this patch have to have the
global userspace exposure of defio delay in sysfs support. If that
sysfs patch was not accepted, I don't see this patch affected
negatively.

> However, the driver does use the HID feature reports extensively to
> control the backlight, LEDs, et. al.

Ok.

> - Removed the update rate sysfs attribute as it is in the second patch above.

Why? There is no consensus that exposing defio delay for _all_ fb
drivers is a good idea. I would rather you left that in here for now.

> +/*
> + * This is a default logo to be loaded upon driver initialization
> + * replacing the default Logitech G13 image loaded on device
> + * initialization. This is to provide the user a cue that the
> + * Linux driver is loaded and ready.
> + *
> + * This logo contains the text G13 in the center with two penguins
> + * on each side of the text. The penguins are a 33x40 rendition of
> + * the default framebuffer 80x80 monochrome image scaled down and
> + * cleaned up to retain something that looks a little better than
> + * a simple scaling.
> + *
> + * This logo is a simple xbm image created in GIMP and exported.
> + * To view the image copy the following two #defines plus the
> + * g13_lcd_bits to an ASCII text file and save with extension
> + * .xbm, then open with GIMP or any other graphical editor
> + * such as eog that recognizes the .xbm format.
> + */
...
> +static unsigned char g13_lcd_bits[] = {
> + 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

I think you'll agree above is not an elegant solution.

> +
> +static DEVICE_ATTR(rgb, 0666, g13_rgb_show, g13_rgb_store);

Reading above code, it looks like this new userspace sysfs attribute
is for backlight control. Could that be better exposed using the
existing backlight class?

Thanks,
jaya
