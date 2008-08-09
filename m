Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYHIPFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYHIPFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 11:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYHIPFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 11:05:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:59312 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYHIPFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 11:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jx1xjlJJjnK8cfWoyFMpl/v9NemQh7fPmURFM0EeNmgQRCspEdxJBKyhAovZew0rwn
         6Xu3sy1NXlp2PG9+2pt4AcRLLjQN/PGcKQQ9ss0HVKMuBstgWpepIBZCEkBQdd1amK6F
         z3OeZfFXzJgDgn/uqWsTqCEaBofC8er/BZjs0=
Date: Sat, 9 Aug 2008 17:04:43 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [01/03] USB: add CONFIG_USB_DEBUG_MESSAGES and usb_dbg()
Message-ID: <20080809150439.GA5408@joi>
References: <20080809013820.GA10910@kroah.com> <20080809013917.GB10910@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809013917.GB10910@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 06:39:17PM -0700, Greg KH wrote:
> --- a/drivers/usb/core/usb.h
> +++ b/drivers/usb/core/usb.h
> @@ -132,6 +132,28 @@ static inline int is_active(const struct
>  /* for labeling diagnostics */
>  extern const char *usbcore_name;
>  
> +/* USB debugging */
> +/* if debug is on or not for the USB core */
> +extern int usb_debug;
> +
> +#if defined(CONFIG_USB_DEBUG_MESSAGES)
> +/* macro for debugging */
> +#define usb_dbg(dev, format, arg...)					\
> +	({								\
> +		if (usb_debug)						\

maybe unlikely here?

> +			dev_printk(KERN_DEBUG , dev , format , ## arg); \
> +		0;							\
> +	})
> +#else
> +#define usb_dbg(dev, format, arg...)					\
> +	({								\
> +		if (0)							\
> +			dev_printk(KERN_DEBUG , dev , format , ## arg);	\
> +		0;							\
> +	})
> +#endif
> +
> +
>  /* sysfs stuff */
>  extern struct attribute_group *usb_device_groups[];
>  extern struct attribute_group *usb_interface_groups[];
