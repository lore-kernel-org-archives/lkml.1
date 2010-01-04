Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095Ab0ADVhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0ADVhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020Ab0ADVh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:37:29 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:14730 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752848Ab0ADVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:37:28 -0500
Message-ID: <4B425F80.2070409@ru.mvista.com>
Date: Tue, 05 Jan 2010 00:37:04 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Eirik Aanonsen <EAA@wprmedical.com>
Cc: "kernel@avr32linux.org" <kernel@avr32linux.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
References: <B5E0EDE940845B429B7ECCE186529F2C0641D177FD@dware2702>
In-Reply-To: <B5E0EDE940845B429B7ECCE186529F2C0641D177FD@dware2702>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Eirik Aanonsen wrote:

> Adding vbus_pin_inverted so that the usb detect pin can be active high or low.
> This because depending on HW implementation it is better to have active low.
> Also replaced the pio_get_value(udc->vbus_pin); with a call to vbus_is_present(udc);
>
> Signed-off-by: Eirik Aanonsen <eaa@wprmedical.com>
>   
[...]
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 4e970cf..1c469d4 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -320,8 +320,17 @@ static inline void usba_cleanup_debugfs(struct usba_udc *udc)
>  static int vbus_is_present(struct usba_udc *udc)
>  {
>  	if (gpio_is_valid(udc->vbus_pin))
> -		return gpio_get_value(udc->vbus_pin);
> -
> +	{	
> +		if(udc->vbus_pin_inverted)
>   

   Space missing after *if*.

> +		{
> +			if( gpio_get_value(udc->vbus_pin) == 1)
>   

   Space missing after *if* and there should be no space after (.

> +				return 0;
> +			else
> +				return 1;
>   

   Why not simply:

			return !gpio_get_value(udc->vbus_pin);


> +		}
> +		else
>   

   } and *else* should be on the same line.
   Please run your patches thru scripts/checkpatch.pl before submitting...

WBR, Sergei


