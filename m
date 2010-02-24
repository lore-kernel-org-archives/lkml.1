Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab0BXXnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 18:43:14 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:46814 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546Ab0BXXnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 18:43:13 -0500
Date: Wed, 24 Feb 2010 18:42:42 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Ben Gardner <gardner.ben@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cs5535_gpio: gpio_chip.get should return the input
 value
Message-ID: <20100224184242.24027054@droptest.queued.net>
In-Reply-To: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 16:55:17 -0600
Ben Gardner <gardner.ben@gmail.com> wrote:

> The gpio_chip.get() function for the CS5535 GPIO driver currently
> returns the output value instead of the input value.
> This patch changes it to return the input value.
> 
> Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
> ---
> --- linux-2.6.33-rc8.orig/drivers/gpio/cs5535-gpio.c
> +++ linux-2.6.33-rc8/drivers/gpio/cs5535-gpio.c
> @@ -154,7 +154,7 @@
> 
>  static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
>  {
> -	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
> +	return cs5535_gpio_isset(offset, GPIO_READ_BACK);
>  }
> 
>  static void chip_gpio_set(struct gpio_chip *chip, unsigned offset,
> int val)

Hm, you're probably right.  Of course this breaks cs5535audio_olpc.c,
since the GPIO isn't marked bidirectional (only output is enabled).
I'll follow up w/ a patch.

Acked-by: Andres Salomon <dilinger@collabora.co.uk>
