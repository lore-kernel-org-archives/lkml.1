Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab0BYDwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:52:10 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51010 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab0BYDwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:52:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DAUcVKveAjSuJD8+ENsMn5v7pqSwfi6ywk8vGkUu9+GE03lkbGINX0wKMEI7heufnk
         Mkvt+5MEbc2Tb9TRmX3jNTnbq++BLLx77Q+G+bwBbNTi6t7Dj8m20HJcqO6kuTjd6xLr
         3aEis0BCbmdJVTmc69UDzf0uawyq3BHBc5mWc=
MIME-Version: 1.0
In-Reply-To: <20100224145822.803e86ed.akpm@linux-foundation.org>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
	 <20100224145822.803e86ed.akpm@linux-foundation.org>
Date: Wed, 24 Feb 2010 21:52:07 -0600
Message-ID: <808c8e9d1002241952s63633da3m471b6fb170558789@mail.gmail.com>
Subject: Re: [PATCH] cs5535_gpio: gpio_chip.get should return the input value
From: Ben Gardner <gardner.ben@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andres Salomon <dilinger@collabora.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- linux-2.6.33-rc8.orig/drivers/gpio/cs5535-gpio.c
>> +++ linux-2.6.33-rc8/drivers/gpio/cs5535-gpio.c
>> @@ -154,7 +154,7 @@
>>
>>  static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
>>  {
>> -     return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
>> +     return cs5535_gpio_isset(offset, GPIO_READ_BACK);
>>  }
>>
>>  static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
>
> <presses F10>
>
> What were the user-visible effects of this bug?

The user-visible effects were that the input didn't work.
I use the CS5535 chip in a custom board that uses GPIO 25 and 26 as
voltage monitoring inputs (external voltage comparators).
Since the char-based cs5535-gpio is now deprecated, I'm trying out the
gpio driver.
I export the GPIO pins via sysfs to access them from user-space.
Reading the 'value' member didn't reflect the input.

Personally, I would prefer a separate sysfs entry for the output and
the input, since the GPIO pins can be both outputs and inputs, but
that would require a gpiolib change.
Since there doesn't appear to be a gpio maintainer, any change to that
might be tricky.

Ben
