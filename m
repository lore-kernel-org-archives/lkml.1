Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365Ab0ADVyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0ADVyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633Ab0ADVyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:54:16 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:29584
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563Ab0ADVyP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:54:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIBAILyQUt8qNTn/2dsb2JhbAAI1UWEMAQ
X-IronPort-AV: E=Sophos;i="4.47,500,1257091200"; 
   d="scan'208";a="540545836"
Subject: Re: [PATCH 1/1] atmel uaba : Adding invert vbus_pin
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <B5E0EDE940845B429B7ECCE186529F2C0641D177FD@dware2702>
Date: Tue, 5 Jan 2010 08:54:11 +1100
Cc: "kernel@avr32linux.org" <kernel@avr32linux.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0FB63DBE-F99F-405F-BE58-4FAAE83C8298@niasdigital.com>
References: <B5E0EDE940845B429B7ECCE186529F2C0641D177FD@dware2702>
To: Eirik Aanonsen <EAA@wprmedical.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/01/2010, at 12:01 AM, Eirik Aanonsen wrote:

> Adding vbus_pin_inverted so that the usb detect pin can be active high or low.
> This because depending on HW implementation it is better to have active low.
> Also replaced the pio_get_value(udc->vbus_pin); with a call to vbus_is_present(udc);
> 
> Signed-off-by: Eirik Aanonsen <eaa@wprmedical.com>
> ---
> drivers/usb/gadget/atmel_usba_udc.c |   16 +++++++++++++---
> drivers/usb/gadget/atmel_usba_udc.h |    1 +
> include/linux/usb/atmel_usba_udc.h  |    1 +
> 3 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 4e970cf..1c469d4 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -320,8 +320,17 @@ static inline void usba_cleanup_debugfs(struct usba_udc *udc)
> static int vbus_is_present(struct usba_udc *udc)
> {
> 	if (gpio_is_valid(udc->vbus_pin))
> -		return gpio_get_value(udc->vbus_pin);
> -
> +	{	
> +		if(udc->vbus_pin_inverted)
> +		{
> +			if( gpio_get_value(udc->vbus_pin) == 1)
> +				return 0;
> +			else
> +				return 1;
> +		}
> +		else
> +			return gpio_get_value(udc->vbus_pin);
> +	}

return gpio_get_value(udc->vbus_pin) ^ udc->vbus_pin_inverted

	--Ben.

