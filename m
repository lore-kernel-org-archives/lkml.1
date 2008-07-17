Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbYGQHFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbYGQHFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYGQHFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:05:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYGQHFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:05:43 -0400
Date: Thu, 17 Jul 2008 00:01:03 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080717070103.GA21961@kroah.com>
References: <20080715213108.GB23331@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715213108.GB23331@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 05:31:08PM -0400, Jason Baron wrote:
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 1a06026..fb03dbc 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -592,7 +592,11 @@ extern const char *dev_driver_string(struct device *dev);
>  #define dev_info(dev, format, arg...)		\
>  	dev_printk(KERN_INFO , dev , format , ## arg)
>  
> -#ifdef DEBUG
> +#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
> +#define dev_dbg(dev, format, ...) do { \
> +	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
> +	} while (0)
> +#elif defined(DEBUG)
>  #define dev_dbg(dev, format, arg...)		\
>  	dev_printk(KERN_DEBUG , dev , format , ## arg)
>  #else

In looking at your follow-on patches, where you add this to subsystems,
it seems that you have to add a lot of #include <linux/dynamic_printk.h>
lines.

And in looking at this modification to device.h, I think lots of the
kernel should break, but you are getting it "for free" by including the
.h file within kernel.h.

Why not also include it here in device.h?

Also, with this change, code that is already using dev_dbg() today is
instantly converted over to this logic now, right?

Anyway, this looks great, no objections from me at all, very good work.

thanks,

greg k-h
