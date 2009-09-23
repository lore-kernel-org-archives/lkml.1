Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbZIWPbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbZIWPbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZIWPbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:31:45 -0400
Received: from mail.atmel.fr ([81.80.104.162]:42928 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbZIWPbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:31:44 -0400
Message-ID: <4ABA3F54.3020600@atmel.com>
Date: Wed, 23 Sep 2009 17:31:32 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Victor <avictor.za@gmail.com>
CC: David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       patrice.vilchez@atmel.com
Subject: Re: [PATCH 2/2] at91/USB: at91sam9g45 series USB host integration
References: <1244547493-19654-1-git-send-email-nicolas.ferre@atmel.com>	 <200906190043.00428.david-b@pacbell.net>	 <20090619095148.67a74ed9@hskinnemoen-d830>	 <200906190226.56278.david-b@pacbell.net> <cd73a99e0909211349w3cbcfad3yb8d0e2bdcb2480cb@mail.gmail.com>
In-Reply-To: <cd73a99e0909211349w3cbcfad3yb8d0e2bdcb2480cb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Victor :
> hi David,
> 
>> On Friday 19 June 2009, Haavard Skinnemoen wrote:
>>> David Brownell wrote:
>>>>> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
>>>>> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
>>>>> + /* Enable VBus control for UHP ports */
>>>>> + for (i = 0; i < data->ports; i++) {
>>>>> +         if (data->vbus_pin[i])
>>>>> +                 at91_set_gpio_output(data->vbus_pin[i], 0);
>>>> This should gpio_request() and gpio_direction_output().
>>> Hmm...I thought the driver was supposed to call gpio_request(), not the
>>> platform code?
>> In some cases.  This isn't a good case for that.  Especially
>> if it's going to call gpio_direction_output() ... which needs
>> gpio_request() to have been done first.
> 
> I have to agree with Haavard on this - it's really not clear if
> gpio_request() should be called in the platform-code or in the driver.
> 
> If the platform code performs a gpio_request() then surely it needs to
> call a gpio_free() after configuring the pin.
> Otherwise the driver's initialization code performs another
> gpio_request() for that pin, but it is still "in-use" by the platform
> code.
> 
> Also Documentation/gpio.txt doesn't say if a GPIO pin should even
> retain it's configured state across after a gpio_free().
> 
> 
> So for the core AT91 platform code, I'd continue to use the
> AT91-specific GPIO configuration functions.
> The drivers should perform the gpio_request() / gpio_free(), and it
> can still call gpio_direction_output() if necessary.

Fair enough. So I forget my gpiolib patch on top of the former USB
integration one.

With your Ack, I will publish it to Russell's patch tracking system...

Bye,
-- 
Nicolas Ferre

