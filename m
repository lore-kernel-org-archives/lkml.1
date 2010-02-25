Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab0BYEGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:06:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932091Ab0BYEGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:06:51 -0500
Date: Wed, 24 Feb 2010 20:05:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Gardner <gardner.ben@gmail.com>
Cc: Andres Salomon <dilinger@collabora.co.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] cs5535_gpio: gpio_chip.get should return the input
 value
Message-Id: <20100224200559.fa911282.akpm@linux-foundation.org>
In-Reply-To: <808c8e9d1002241952s63633da3m471b6fb170558789@mail.gmail.com>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
	<20100224145822.803e86ed.akpm@linux-foundation.org>
	<808c8e9d1002241952s63633da3m471b6fb170558789@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010 21:52:07 -0600 Ben Gardner <gardner.ben@gmail.com> wrote:

> >> --- linux-2.6.33-rc8.orig/drivers/gpio/cs5535-gpio.c
> >> +++ linux-2.6.33-rc8/drivers/gpio/cs5535-gpio.c
> >> @@ -154,7 +154,7 @@
> >>
> >> __static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
> >> __{
> >> - __ __ return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
> >> + __ __ return cs5535_gpio_isset(offset, GPIO_READ_BACK);
> >> __}
> >>
> >> __static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
> >
> > <presses F10>
> >
> > What were the user-visible effects of this bug?
> 
> The user-visible effects were that the input didn't work.
> I use the CS5535 chip in a custom board that uses GPIO 25 and 26 as
> voltage monitoring inputs (external voltage comparators).
> Since the char-based cs5535-gpio is now deprecated, I'm trying out the
> gpio driver.
> I export the GPIO pins via sysfs to access them from user-space.
> Reading the 'value' member didn't reflect the input.

OK, then in that case we'd want to backport this into 2.6.33.x and
perhaps earlier?

> Personally, I would prefer a separate sysfs entry for the output and
> the input, since the GPIO pins can be both outputs and inputs, but
> that would require a gpiolib change.
> Since there doesn't appear to be a gpio maintainer, any change to that
> might be tricky.

Eh, we can cope.  Propose a patch and cc lots of people..
