Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206Ab0AJH4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab0AJH4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 02:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006Ab0AJH4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 02:56:22 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:52790 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab0AJH4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 02:56:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vD5Jw67ggLwTVGkhrxMkNTovc/6kQeR3Nv+gjwSAGFD2O8NqogjD3nl1JJWLDuGRcW
         /ki/6046Y5yA4E4p4q9pUdSg3S7j6A62xk6w2Iz9vsCk/Mhak8V6dAdQ+Qnn1MZak5JN
         InbgBb4QEammwkKKbJ9IrbhnUI8lDOZgEoPaA=
Date: Sat, 9 Jan 2010 23:56:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input/joystick/xpad.c: Add rumble support for
 original xbox controller
Message-ID: <20100110075615.GC16057@core.coreip.homeip.net>
References: <20100108033215.447c814e@rechenknecht2k7>
 <20100108075054.GA3696@core.coreip.homeip.net>
 <20100108112610.0b78785b@piBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108112610.0b78785b@piBook>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 11:26:10AM +0100, Benjamin Valentin wrote:
> On Thu, 7 Jan 2010 23:50:54 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > Thank you for your patch. Could I please have your "Signed-off-by: "
> > so I can apply it? Also, if you have any more patches ofr in put
> > devices, could you please CC linux-input@vger.kernel.org?
> 
> This way?
> 
> Signed-off-by: Benjamin Valentin <benpicco@zedat.fu-berlin.de>

Yep, thanks.

> 
> --- /usr/src/linux-source-2.6.33/drivers/input/joystick/xpad.c
> 2010-01-08 02:56:59.365851076 +0100 +++ xpad.c	2010-01-08
> 03:13:38.477835651 +0100 @@ -505,7 +505,7 @@
>  	struct usb_endpoint_descriptor *ep_irq_out;
>  	int error = -ENOMEM;
>  
> -	if (xpad->xtype != XTYPE_XBOX360)
> +	if (xpad->xtype != XTYPE_XBOX360 && xpad->xtype != XTYPE_XBOX)
>  		return 0;
>  
>  	xpad->odata = usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN,
> @@ -535,13 +535,13 @@
>  
>  static void xpad_stop_output(struct usb_xpad *xpad)
>  {
> -	if (xpad->xtype == XTYPE_XBOX360)
> +	if (xpad->xtype == XTYPE_XBOX360 || xpad->xtype != XTYPE_XBOX)

This should cretainly be "... || xpad->xtype == XTYPE_XBOX)", I'll fix
it up locally.

>  		usb_kill_urb(xpad->irq_out);
>  }
>  
>  static void xpad_deinit_output(struct usb_xpad *xpad)
>  {
> -	if (xpad->xtype == XTYPE_XBOX360) {
> +	if (xpad->xtype == XTYPE_XBOX360 || xpad->xtype != XTYPE_XBOX)

Same here.

BTW, your mailer line-wraps e-mail which is bad when sending patches.

-- 
Dmitry
