Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZGXSar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZGXSar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZGXSar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:30:47 -0400
Received: from kroah.org ([198.145.64.141]:46794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbZGXSaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:30:46 -0400
Date: Fri, 24 Jul 2009 11:29:05 -0700
From: Greg KH <greg@kroah.com>
To: Trevor Pace <trevorpace@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removed useless retval variables in usb-serial.c
Message-ID: <20090724182905.GA4389@kroah.com>
References: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
 <4A69E164.9040403@ru.mvista.com>
 <bad58e960907241006y22ac529dhfcccd4e1739b907c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bad58e960907241006y22ac529dhfcccd4e1739b907c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 02:06:16PM -0300, Trevor Pace wrote:
>  int usb_serial_resume(struct usb_interface *intf)
>  {
>  	struct usb_serial *serial = usb_get_intfdata(intf);
> -	int rv;
> 
>  	serial->suspending = 0;
> -	if (serial->type->resume)
> -		rv = serial->type->resume(serial);
> -	else
> -		rv = usb_serial_generic_resume(serial);
> 
> -	return rv;
> +	return (serial->type->resume)
> +		? serial->type->resume(serial)
> +		: usb_serial_generic_resume(serial);

Sorry, but no, I'm not going to take something like this.

The first version is just so much more readable, and easier to
understand, which is the main point.  We want and need code to be easy
to read and understand at a very quick glance.  This change only makes
it harder to do so.

thanks,

greg k-h
