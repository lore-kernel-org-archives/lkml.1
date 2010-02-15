Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0BOTkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:40:08 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:40121 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab0BOTkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:40:06 -0500
MIME-Version: 1.0
In-Reply-To: <20100205205437.GA4733@oksana.dev.rtsoft.ru>
References: <20100205205437.GA4733@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 15 Feb 2010 12:39:44 -0700
X-Google-Sender-Auth: 5c57a396f4afc00a
Message-ID: <fa686aa41002151139yf7035d9kdfb6b9b592486fe4@mail.gmail.com>
Subject: Re: [PATCH] leds-gpio: Fix default state handling on OF platforms
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Richard Purdie <rpurdie@linux.intel.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 1:54 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> The driver wrongly sets default state for LEDs that don't specify
> default-state property.
>
> Currently the driver handles default state this way:
>
> memset(&led, 0, sizeof(led));
> for_each_child_of_node(np, child) {
>        state = of_get_property(child, "default-state", NULL);
>        if (state) {
>                if (!strcmp(state, "keep"))
>                        led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
>                ...
>        }
>        ret = create_gpio_led(&led, ...);
> }
>
> Which means that all LEDs that do not specify default-state will
> inherit the last value of the default-state property, which is wrong.
>
> This patch fixes the issue by moving LED's template initialization
> into the loop body.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Richard, I assume you'll pick this one up via your tree?

g.

> ---
>  drivers/leds/leds-gpio.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index e5225d2..0823e26 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -211,7 +211,6 @@ static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
>                                        const struct of_device_id *match)
>  {
>        struct device_node *np = ofdev->node, *child;
> -       struct gpio_led led;
>        struct gpio_led_of_platform_data *pdata;
>        int count = 0, ret;
>
> @@ -226,8 +225,8 @@ static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
>        if (!pdata)
>                return -ENOMEM;
>
> -       memset(&led, 0, sizeof(led));
>        for_each_child_of_node(np, child) {
> +               struct gpio_led led = {};
>                enum of_gpio_flags flags;
>                const char *state;
>
> --
> 1.6.5.7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
