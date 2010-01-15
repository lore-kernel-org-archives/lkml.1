Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab0AOX33 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 18:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932198Ab0AOX32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 18:29:28 -0500
Received: from kroah.org ([198.145.64.141]:40521 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab0AOX32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 18:29:28 -0500
Date: Fri, 15 Jan 2010 14:48:15 -0800
From: Greg KH <greg@kroah.com>
To: Gernot Hillier <gernot@hillier.de>
Cc: Matthias Urlichs <smurf@smurf.noris.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] option.c: Add blacklisting infrastructure for
 special device handling
Message-ID: <20100115224815.GA12101@kroah.com>
References: <4B4AE188.5010004@hillier.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4AE188.5010004@hillier.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 09:30:00AM +0100, Gernot Hillier wrote:
> From: Gernot Hillier <gernot@hillier.de>
> 
> As suggested by Matthias Urlichs, this patch adds a somehow generic 
> mechanism for special handling of devices which don't support all 
> bits expected by this driver.
> 
> The blacklisting code is heavily stolen from sierra.c, but extended to
> support different special cases.
> 
> For now, one case is implemented (OPTION_BLACKLIST_SENDSETUP),
> targeted at the 4G W14 device: devices which don't understand the 
> setting of RTS/DTR in option_send_setup() causing a USB timeout of
> 5 s in any userspace open() which leads to errors in most userspace
> applications.
> 
> In addition, I prepared another case for devices with interfaces which 
> shall not be accessed by this driver (targeted at the D-Link DWM 652).
> 
> However, OPTION_BLACKLIST_RESERVED_IF is not fully implemented yet as 
> I have no device to test this. Anyone volunteering to help here?
> If not, I'll contact the guys who added D-Link DWM 652 support soon.
> 
> Signed-off-by: Gernot Hillier <gernot@hillier.de>
> 
> Index: linux-next/drivers/usb/serial/option.c
> ===================================================================
> --- linux-next.orig/drivers/usb/serial/option.c	2010-01-09 10:24:57.000000000 +0100
> +++ linux-next/drivers/usb/serial/option.c	2010-01-09 10:25:00.000000000 +0100
> @@ -344,6 +344,19 @@ static int  option_resume(struct usb_ser
>  #define HAIER_VENDOR_ID				0x201e
>  #define HAIER_PRODUCT_CE100			0x2009
>  
> +/* some devices interfaces need special handling due to a number of reasons */
> +typedef enum {
> +		OPTION_BLACKLIST_NONE = 0,
> +		OPTION_BLACKLIST_SENDSETUP = 1,
> +		OPTION_BLACKLIST_RESERVED_IF = 2
> +} option_blacklist_reason_t;

I changed this to not use a typedef, you should not add new typedefs to
the kernel.

thanks,

greg k-h
