Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293Ab0BYWd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:33:28 -0500
Received: from legolas.restena.lu ([158.64.1.34]:50270 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934273Ab0BYWd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:33:26 -0500
Date: Thu, 25 Feb 2010 23:32:50 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Cc: linux-kernel@vger.kernel.org, npavel@ituner.com, tomi.valkeinen@nokia.com,
       tony@atomide.com, FlorianSchandinat@gmx.de, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-fbdev@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH] Add sysfs support for fbdefio delay
Message-ID: <20100225233250.241e7d6d@neptune.home>
In-Reply-To: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
References: <201002252215.o1PMFnoP011425@mustang.cs.nmsu.edu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 February 2010 "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu> wrote:
> This patch adds support for examining and modifying the fbdefio delay
> parameter through sysfs. It also adds two driver definable minimum
> and maximum bounds.
> 
> The default behavior is to not permit modifications if delay_max is 0,
> thus preventing modification of the delay if the driver does not
> explicitly permit modification.
> 

...

> @@ -503,6 +584,12 @@ static struct device_attribute device_attrs[] = {
>  #ifdef CONFIG_FB_BACKLIGHT
>  	__ATTR(bl_curve, S_IRUGO|S_IWUSR, show_bl_curve, store_bl_curve),
>  #endif
> +#ifdef CONFIG_FB_DEFERRED_IO
> +	__ATTR(defio_delay, S_IRUGO|S_IWUSR,
> +	       show_defio_delay, store_defio_delay),
> +	__ATTR(defio_delay_min, S_IRUGO, show_defio_delay_min, NULL),
> +	__ATTR(defio_delay_max, S_IRUGO, show_defio_delay_max, NULL),
> +#endif
>  };
>  
>  int fb_init_device(struct fb_info *fb_info)

Would it be reasonable to add these attributes in
fb_deferred_io_init() and remove them in fb_deferred_io_cleanup()?
This would also make it possible to add write permission to delay
attribute only when it effectively can be modified.

IMHO having only attributes pertinent to the features supported by the
framebuffer is better than having all the possible ones and those of
unsupported features returning -ENODEV.

Bruno
