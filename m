Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZKUPrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZKUPrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZKUPrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:47:35 -0500
Received: from mathups.math.u-psud.fr ([129.175.52.4]:60806 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754379AbZKUPrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:47:35 -0500
X-Greylist: delayed 1401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2009 10:47:35 EST
Message-ID: <4B080620.5050500@math.u-psud.fr>
Date: Sat, 21 Nov 2009 16:24:16 +0100
From: Duncan Sands <duncan.sands@math.u-psud.fr>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/8] cxacru: check device isn't being removed during sysfs
 calls
References: <4B08013B.90403@simon.arlott.org.uk> <4B080344.5030104@simon.arlott.org.uk>
In-Reply-To: <4B080344.5030104@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

> +static inline void *to_usbatm_driver_data(struct usb_interface *intf)
> +{
> +	struct usbatm_data *usbatm_instance;
> +
> +	if (intf == NULL)
> +		return NULL;
> +
> +	usbatm_instance = usb_get_intfdata(intf);
> +
> +	if (usbatm_instance == NULL) /* set NULL before unbind() */
> +		return NULL;
> +
> +	return usbatm_instance->driver_data; /* set NULL after unbind() */
> +}
> +
> +static inline void *to_usbatm_atm_dev(struct usb_interface *intf)
> +{
> +	struct usbatm_data *usbatm_instance;
> +
> +	if (intf == NULL)
> +		return NULL;
> +
> +	usbatm_instance = usb_get_intfdata(intf);
> +
> +	if (usbatm_instance == NULL) /* set NULL before unbind() */
> +		return NULL;
> +
> +	return usbatm_instance->atm_dev; /* set NULL after unbind() */
> +}
> +

why not collapse these two into one that just returns usbatm_instance,
and have users extract the ->driver_data or ->atm_dev fields?

Ciao,

Duncan.
