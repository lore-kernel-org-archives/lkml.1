Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030637Ab0B0Skh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:40:37 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:60591 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030578Ab0B0Skg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:40:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uyv3k4byhjC4x512I2Cgp0qmeyyBv1K48uJuP5JObwoWFG7/LLtBOmMu6AQwGLOdLO
         I/bLWoJVrHUfH0iE/iKmwROuNqAsQ62TQvYJ/ANmApp341V3lDlUi2Dxyd4OmsXhe3r5
         7mXjPsNO6kVWFqD/F4pFO1UqVSE8rfinHOGsM=
MIME-Version: 1.0
In-Reply-To: <1267295795-2831-1-git-send-email-gardner.ben@gmail.com>
References: <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
	 <1267295795-2831-1-git-send-email-gardner.ben@gmail.com>
Date: Sat, 27 Feb 2010 12:40:33 -0600
Message-ID: <808c8e9d1002271040w13b6f32drcb2393dd481e153a@mail.gmail.com>
Subject: Re: [PATCH] cs5535-gpio: change input/output enable to match gpiolib 
	expectations
From: Ben Gardner <gardner.ben@gmail.com>
To: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <david-b@pacbell.net>
Cc: Ben Gardner <gardner.ben@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch.
It seems you have to 'commit' in git before 'format-patch'...

On Sat, Feb 27, 2010 at 12:36 PM, Ben Gardner <gardner.ben@gmail.com> wrote:
> The intent of the gpiolib set_direction_xxx functions is as follows:
> output: enable both input and output
> input: disable output, enable input
>
> Change the cs5535 driver to do that.
>
> Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
> CC: Andres Salomon <dilinger@collabora.co.uk>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: David Brownell <dbrownell@users.sourceforge.net>
> CC: Jani Nikula <ext-jani.1.nikula@nokia.com>
> ---
>  drivers/gpio/cs5535-gpio.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
> index 0fdbe94..59ab30e 100644
> --- a/drivers/gpio/cs5535-gpio.c
> +++ b/drivers/gpio/cs5535-gpio.c
> @@ -171,6 +171,7 @@ static int chip_direction_input(struct gpio_chip *c, unsigned offset)
>        unsigned long flags;
>
>        spin_lock_irqsave(&chip->lock, flags);
> +       __cs5535_gpio_set(chip, offset, GPIO_OUTPUT_DISABLE);
>        __cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
>        spin_unlock_irqrestore(&chip->lock, flags);
>
> @@ -185,6 +186,7 @@ static int chip_direction_output(struct gpio_chip *c, unsigned offset, int val)
>        spin_lock_irqsave(&chip->lock, flags);
>
>        __cs5535_gpio_set(chip, offset, GPIO_OUTPUT_ENABLE);
> +       __cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
>        if (val)
>                __cs5535_gpio_set(chip, offset, GPIO_OUTPUT_VAL);
>        else
> --
> 1.7.0
>
>
