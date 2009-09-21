Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZIUUtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZIUUtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 16:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZIUUtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 16:49:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:59416 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbZIUUtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 16:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VR/WF7k9RP5BXkZldP4SxnfmDHrcocvldcMjyTQi+2hfiNC6p5B0jMeO9dHLn6cBnl
         qFLMPwEVsI5nN/eMzCJDdvIESsSBYFwIde0w5MpR9Rnd9hItKGha/DKqAlLLRyTvxg4o
         zhVrmjfW+5iCeu34yOQurdNblirNHRUL/XKV0=
MIME-Version: 1.0
In-Reply-To: <200906190226.56278.david-b@pacbell.net>
References: <1244547493-19654-1-git-send-email-nicolas.ferre@atmel.com>
	 <200906190043.00428.david-b@pacbell.net>
	 <20090619095148.67a74ed9@hskinnemoen-d830>
	 <200906190226.56278.david-b@pacbell.net>
Date: Mon, 21 Sep 2009 22:49:05 +0200
Message-ID: <cd73a99e0909211349w3cbcfad3yb8d0e2bdcb2480cb@mail.gmail.com>
Subject: Re: [PATCH 2/2] at91/USB: at91sam9g45 series USB host integration
From: Andrew Victor <avictor.za@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, patrice.vilchez@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi David,

> On Friday 19 June 2009, Haavard Skinnemoen wrote:
>> David Brownell wrote:
>> > > --- a/arch/arm/mach-at91/at91sam9g45_devices.c
>> > > +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
>>
>> > > + /* Enable VBus control for UHP ports */
>> > > + for (i = 0; i < data->ports; i++) {
>> > > +         if (data->vbus_pin[i])
>> > > +                 at91_set_gpio_output(data->vbus_pin[i], 0);
>> >
>> > This should gpio_request() and gpio_direction_output().
>>
>> Hmm...I thought the driver was supposed to call gpio_request(), not the
>> platform code?
>
> In some cases.  This isn't a good case for that.  Especially
> if it's going to call gpio_direction_output() ... which needs
> gpio_request() to have been done first.

I have to agree with Haavard on this - it's really not clear if
gpio_request() should be called in the platform-code or in the driver.

If the platform code performs a gpio_request() then surely it needs to
call a gpio_free() after configuring the pin.
Otherwise the driver's initialization code performs another
gpio_request() for that pin, but it is still "in-use" by the platform
code.

Also Documentation/gpio.txt doesn't say if a GPIO pin should even
retain it's configured state across after a gpio_free().


So for the core AT91 platform code, I'd continue to use the
AT91-specific GPIO configuration functions.
The drivers should perform the gpio_request() / gpio_free(), and it
can still call gpio_direction_output() if necessary.


Regards,
  Andrew Victor
