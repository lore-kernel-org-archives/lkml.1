Return-Path: <linux-kernel-owner+w=401wt.eu-S1422655AbXBVBAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422655AbXBVBAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422849AbXBVBAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:00:04 -0500
Received: from tim.rpsys.net ([194.106.48.114]:46626 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422655AbXBVBAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:00:01 -0500
Subject: Re: [PATCH 1/1] PXAFB: Support for backlight control
From: Richard Purdie <rpurdie@rpsys.net>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Paul Sokolovsky <pmiscml@gmail.com>
In-Reply-To: <20070221145353.GA23916@enneenne.com>
References: <20070221145353.GA23916@enneenne.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 00:59:06 +0000
Message-Id: <1172105946.5790.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 15:53 +0100, Rodolfo Giometti wrote:
> Backlight control support for the PXA fram buffer.
> 
> Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
> 
> ---
> 
> Each platform should define the backlight properties in its own setup
> file in "linux/arch/arm/mach-pxa/" as follow:
> 
>    static int pxafb_bl_get_brightness(struct backlight_device *bl_dev)
>    {
>         return read_the_backlight_brightness();
>    }
> 
>    static int pxafb_bl_update_status(struct backlight_device *bl_dev)
>    {
>            int perc, ret;
> 
>            if (bl_dev->props->power != FB_BLANK_UNBLANK ||
>                bl_dev->props->fb_blank != FB_BLANK_UNBLANK)
>                    perc = 0;
>            else
>                    perc = bl_dev->props->brightness;
> 
>         write_the_backlight_brightness(perc);
> 
>            return 0;
>    }
> 
>    static struct backlight_properties wwpc1100_backlight_props = {
>            .get_brightness         = pxafb_bl_get_brightness,
>            .update_status          = pxafb_bl_update_status,
>            .max_brightness         = 100,
>    };
>       
> and then seting up the fb info as follow:
> 
>    wwpc1100_pxafb_info.modes = &special_modes;
>    wwpc1100_pxafb_info.bl_props = &wwpc1100_backlight_props;
>    set_pxa_fb_info(&wwpc1100_pxafb_info);

Reading through the patch its:

1) Not against any mainline kernel
2) Not against a recent kernel

There were a number of backlight class changes just merged into mainline
and you need to sync up any patch against them.

As mentioned by others, there is no need to tie the backlight driver
into the framebuffer any more. Have a look at
drivers/video/backlight/corgi_bl.c for an example (its used by PXA
devices).

I have said elsewhere I will take patches to make corgi_bl a more
generic driver (or maybe create a simple generic backlight driver) along
the lines of what Paul mentioned.

Regards,

Richard


