Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbXJ2Xzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbXJ2Xzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXJ2Xzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:55:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbXJ2Xza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:55:30 -0400
Date: Mon, 29 Oct 2007 17:00:54 -0700
From: Greg KH <gregkh@suse.de>
To: Emil Medve <Emilian.Medve@Freescale.com>
Cc: mochel@osdl.org, linux-kernel@vger.kernel.org, hjlipp@web.de,
       tilman@imap.cc, gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, mac@melware.de,
       linux-omap-open-source@linux.omap.com
Subject: Re: [PATCH resend] Make the dev_*() family of macros in device.h
	complete
Message-ID: <20071030000054.GA19022@suse.de>
References: <1193697795-7823-1-git-send-email-Emilian.Medve@Freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193697795-7823-1-git-send-email-Emilian.Medve@Freescale.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 05:43:15PM -0500, Emil Medve wrote:
> Removed duplicates defined elsewhere
> 
> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
> ---
> 
> Reseding the patch to a larger audience
> 
> The macros are defined in the relative order KERN_* are defined in kernel.h
> 
> linux-2.6> scripts/checkpatch.pl 0001-Make-the-dev_-family-of-macros-in-device.h-comple.patch 
> Your patch has no obvious style problems and is ready for submission.
> 
>  drivers/i2c/chips/isp1301_omap.c |    6 ------
>  drivers/isdn/gigaset/gigaset.h   |    6 ------
>  include/linux/device.h           |   26 ++++++++++++++++----------
>  3 files changed, 16 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/i2c/chips/isp1301_omap.c b/drivers/i2c/chips/isp1301_omap.c
> index fe04e46..35b9909 100644
> --- a/drivers/i2c/chips/isp1301_omap.c
> +++ b/drivers/i2c/chips/isp1301_omap.c
> @@ -259,12 +259,6 @@ static inline const char *state_name(struct isp1301 *isp)
>  	return state_string(isp->otg.state);
>  }
>  
> -#ifdef	VERBOSE
> -#define	dev_vdbg			dev_dbg
> -#else
> -#define	dev_vdbg(dev, fmt, arg...)	do{}while(0)
> -#endif
> -
>  /*-------------------------------------------------------------------------*/
>  
>  /* NOTE:  some of this ISP1301 setup is specific to H2 boards;
> diff --git a/drivers/isdn/gigaset/gigaset.h b/drivers/isdn/gigaset/gigaset.h
> index a0317ab..02bdaf2 100644
> --- a/drivers/isdn/gigaset/gigaset.h
> +++ b/drivers/isdn/gigaset/gigaset.h
> @@ -106,12 +106,6 @@ enum debuglevel {
>  					 activated */
>  };
>  
> -/* missing from linux/device.h ... */
> -#ifndef dev_notice
> -#define dev_notice(dev, format, arg...)		\
> -	dev_printk(KERN_NOTICE , dev , format , ## arg)
> -#endif
> -
>  /* Kernel message macros for situations where dev_printk and friends cannot be
>   * used for lack of reliable access to a device structure.
>   * linux/usb.h already contains these but in an obsolete form which clutters
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 2e15822..e4f8a1c 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -557,9 +557,24 @@ extern const char *dev_driver_string(struct device *dev);
>  #define dev_printk(level, dev, format, arg...)	\
>  	printk(level "%s %s: " format , dev_driver_string(dev) , (dev)->bus_id , ## arg)
>  
> +#define dev_emerg(dev, format, arg...)		\
> +	dev_printk(KERN_EMERG, dev, format, ## arg)
> +#define dev_alert(dev, format, arg...)		\
> +	dev_printk(KERN_ALERT, dev, format, ## arg)
> +#define dev_crit(dev, format, arg...)		\
> +	dev_printk(KERN_CRIT, dev, format, ## arg)
> +#define dev_err(dev, format, arg...)		\
> +	dev_printk(KERN_ERR, dev, format, ## arg)
> +#define dev_warn(dev, format, arg...)		\
> +	dev_printk(KERN_WARNING, dev, format, ## arg)
> +#define dev_notice(dev, format, arg...)		\
> +	dev_printk(KERN_NOTICE, dev, format, ## arg)
> +#define dev_info(dev, format, arg...)		\
> +	dev_printk(KERN_INFO, dev, format, ## arg)
> +
>  #ifdef DEBUG
>  #define dev_dbg(dev, format, arg...)		\
> -	dev_printk(KERN_DEBUG , dev , format , ## arg)
> +	dev_printk(KERN_DEBUG, dev, format, ## arg)

Those extra spaces are there for a good reason, older versions of gcc
are broken without it.  So please, put them all back...

thanks,

greg k-h
