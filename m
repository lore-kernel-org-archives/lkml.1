Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZBIMUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZBIMUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZBIMTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:19:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:23040 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbZBIMTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:19:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ow/XgwqpLFFp9mLTT8Tuit/477PsGhiS8lfPkfb5xHqmHSHFZoQO5o8Ir7WRXwJwju
         fIHQlK6D+sPrXk7moBvN0gMjGXQWHXMbBlBpZgWh3YghSuN5BBAz0WMPlVAi+FUG2W/n
         HMyevaJkw+REGW4Ks74Vr8+NKuiDqJkQtRS/Y=
MIME-Version: 1.0
In-Reply-To: <200902082153.30479.david-b@pacbell.net>
References: <4e1455be0902062015i1ff94b28p93588e61b7860618@mail.gmail.com>
	 <200902082011.36500.david-b@pacbell.net>
	 <4e1455be0902082129i2c038477g886c8de03d3073dd@mail.gmail.com>
	 <200902082153.30479.david-b@pacbell.net>
Date: Mon, 9 Feb 2009 21:19:48 +0900
Message-ID: <4e1455be0902090419v206bae9et23ddb5492db49e55@mail.gmail.com>
Subject: Re: [PATCH] OMAP3 GPIO: Fix getting the value of the GPIO output pin
From: Joonyoung Shim <dofmind@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/9 David Brownell <david-b@pacbell.net>:
> On Sunday 08 February 2009, Joonyoung Shim wrote:
>> > Which should clearly be AE6_34XX_GPIO141_OUT since it does
>> > not enable the input driver.  Try making that ...PIN_OUTPUT
>> > read ...PIN_INPUT and see if things behave.
>>
>> Of course, it will be better if the name is clear as AE6_34XX_GPIO141_OUT.
>> but, the core of this problem is not it, the chip->get() called in
>> gpiolib_dbg_show()
>> of drivers/gpio/gpiolib.c or dbg_gpio_show() of arch/arm/plat-omap/gpio.c
>> can return the wrong value when gpio pin is configured as an output.
>
> No, the core of the problem is that you're using a GPIO
> which is explicitly configured as output-only ... but are
> treating it as if it were a normal bi-directional GPIO.
>
> It's acting *exactly* right for an output-only GPIO.  But
> that's not the behavior you expect, or want.
>
> If you weren't disabling the input driver, then when you
> ask for the input value it would work as you expect.  Which
> is why I suggested you change how that ball is configured.
> (That's actually a bugfix to those muxing tables ...)

I understood that you say, ths PIN_OUTPUT flag must use
when GPIO pin is output-only, and i got the result i want
after GPIO pin is configured as bi-diretional GPIO.

But i wonder why don't control in gpio_get() of arch/arm/plat-omap/gpio.c
when the GPIO pin is output-only?

thank you.

- Joonyoung

>
> - Dave
>
> p.s. This specific confusion is new on OMAP3; previous
>     OMAPs didn't have the extra byte of options to
>     configure.  The PIN_INPUT flag was, on previous
>     chips, effectively hard-wired on for GPIOs.
>
