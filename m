Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXDLUcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXDLUcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXDLUcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:32:15 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:55224 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753189AbXDLUcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:32:11 -0400
Date: Thu, 12 Apr 2007 22:25:19 +0200
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-ID: <20070412202519.GB14705@aitel.hist.no>
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 08:32:50PM +0200, Jiri Kosina wrote:
> OK, so it hangs somewhere nearby usbhid's hid_init(), and the 
> usb_register() has been already invoked. Could you please apply the 
> superstupid patch below and send me the output up to the point it hangs? I 
> am curious to know whether it hangs somewhere inside usb_register(), or 
> elsewhere.
> 
> Thanks.
>
Are you sure this is the correct patch - against 2.6.21-rc6-mm1 ?
Hunk 1 out of 1 failed . . .
 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 1ddca31..d930f62 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -1550,15 +1550,22 @@ static int __init hid_init(void)
>  	retval = hiddev_init();
>  	if (retval)
>  		goto hiddev_init_fail;
> +	printk(KERN_DEBUG "hid_init: before usb_register()\n");
>  	retval = usb_register(&hid_driver);
> +	printk(KERN_DEBUG "hid_init: after usb_register(), retuned %d\n", retval);
>  	if (retval)
>  		goto usb_register_fail;
>  	info(DRIVER_VERSION ":" DRIVER_DESC);
>  
> +	printk(KERN_DEBUG "hid_init: returning 0\n");
> +	dump_stack();
>  	return 0;
>  usb_register_fail:
> +	printk(KERN_DEBUG "hid_init: calling hiddev_exit()\n");
>  	hiddev_exit();
>  hiddev_init_fail:
> +	printk(KERN_DEBUG "hid_init: returning %d\n", retval);
> +	dump_stack();
>  	return retval;
>  }
>  
