Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZIPWGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZIPWGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZIPWGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:06:15 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:36869 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752197AbZIPWGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:06:14 -0400
Date: Wed, 16 Sep 2009 23:53:28 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-usb@vger.kernel.org, avictor.za@gmail.com, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org, david-b@pacbell.net,
       haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] at91: use gpiolib calls for USB vbus pin on at91sam9g45
Message-ID: <20090916215328.GG4172@game.jcrosoft.org>
References: <4AB10F7D.9060706@atmel.com>
 <1253122169-14806-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253122169-14806-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7027585744681544556
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:29 Wed 16 Sep     , Nicolas Ferre wrote:
> Change pin configuration for USB vbus on at91sam9g45: use the generic gpiolib
> call instead of the at91 specific one.
> Use gpio_request() function with same identifier for OHCI and EHCI hosts as
> they are sharing the same pin.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> This patch is on top of at91sam9g45 USB integration one:
> "[PATCH 2/2] at91/USB: at91sam9g45 series USB host integration"
> http://lkml.org/lkml/2009/6/9/221
> 
>  arch/arm/mach-at91/at91sam9g45_devices.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index 5be8cf2..7d939c0 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -118,8 +118,10 @@ void __init at91_add_device_usbh_ohci(struct at91_usbh_data *data)
>  
>  	/* Enable VBus control for UHP ports */
>  	for (i = 0; i < data->ports; i++) {
> -		if (data->vbus_pin[i])
> -			at91_set_gpio_output(data->vbus_pin[i], 0);
> +		if (data->vbus_pin[i]) {
> +			gpio_request(data->vbus_pin[i], "usb host vbus");
> +			gpio_direction_output(data->vbus_pin[i], 0);
> +		}
>  	}
>  
>  	usbh_ohci_data = *data;
> @@ -173,8 +175,10 @@ void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data)
>  
>  	/* Enable VBus control for UHP ports */
>  	for (i = 0; i < data->ports; i++) {
> -		if (data->vbus_pin[i])
> -			at91_set_gpio_output(data->vbus_pin[i], 0);
> +		if (data->vbus_pin[i]) {
> +			gpio_request(data->vbus_pin[i], "usb host vbus");
> +			gpio_direction_output(data->vbus_pin[i], 0);
> +		}
>  	}
as you do the same think for ehci & ohci why not factorize it?

Best Regards,
J.
