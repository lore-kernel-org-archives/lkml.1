Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZIPQR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZIPQR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbZIPQRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:17:23 -0400
Received: from mail.atmel.fr ([81.80.104.162]:53581 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759436AbZIPQRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:17:21 -0400
Message-ID: <4AB10F7D.9060706@atmel.com>
Date: Wed, 16 Sep 2009 18:17:01 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>, linux-usb@vger.kernel.org,
       avictor.za@gmail.com
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       linux-kernel@vger.kernel.org, patrice.vilchez@atmel.com,
       Nicolas FERRE <nicolas.ferre@atmel.com>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] at91/USB: at91sam9g45 series USB host integration
References: <1244547493-19654-1-git-send-email-nicolas.ferre@atmel.com> <200906190043.00428.david-b@pacbell.net> <20090619095148.67a74ed9@hskinnemoen-d830> <200906190226.56278.david-b@pacbell.net>
In-Reply-To: <200906190226.56278.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I come back on this topic as at91sam9g45 is now in mainline. I need this
integration code to have the USB EHCI work on the evaluation kit.

David Brownell :
> On Friday 19 June 2009, Haavard Skinnemoen wrote:
>> David Brownell wrote:
>>>> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
>>>> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
>>>> +	/* Enable VBus control for UHP ports */
>>>> +	for (i = 0; i < data->ports; i++) {
>>>> +		if (data->vbus_pin[i])
>>>> +			at91_set_gpio_output(data->vbus_pin[i], 0);  
>>> This should gpio_request() and gpio_direction_output().
>> Hmm...I thought the driver was supposed to call gpio_request(), not the
>> platform code?
> 
> In some cases.  This isn't a good case for that.  Especially
> if it's going to call gpio_direction_output() ... which needs
> gpio_request() to have been done first.

Ok, I am building a patch on top of this one that uses these calls. This
way I can change both vbus pin configuration: OCHI and EHCI.

Best regards,
-- 
Nicolas Ferre

