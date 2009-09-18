Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZIRJKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZIRJKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 05:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZIRJKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 05:10:22 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:46156 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZIRJKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 05:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hI/yqFFld9v5eJObzLJd6O6AqHus5cxvywVQUAMH3suglX8t+OILBjQwBTEbeTJdbu
         9e7rPpAN37J72aN2WlbX/6QOqbSIRYDzHtfG8Vetzvf8i+4gZmJ3fKiiioh4MsAsVqwT
         5O700gpQyAc02jmd1pF+NafTUys9JAxt05xQ4=
MIME-Version: 1.0
In-Reply-To: <1253215662-11404-1-git-send-email-getarunks@gmail.com>
References: <1253215662-11404-1-git-send-email-getarunks@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 18 Sep 2009 17:10:05 +0800
Message-ID: <f17812d70909180210xdceaf22u7901befa23cd89c7@mail.gmail.com>
Subject: Re: [PATCH] Adding LED1 & LED2 control for DA9034 backlight driver
To: =?UTF-8?B?5bqE5rWp5Z2aIChIYW9qaWFuKQ==?= <haojian.zhuang@gmail.com>,
       getarunks@gmail.com
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, eric.miao@marvell.com,
       mike@compulab.co.il
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haojian,

Could you please help check if the patch below applies for micco?

Thanks
- eric

On Fri, Sep 18, 2009 at 3:27 AM,  <getarunks@gmail.com> wrote:
> From: Arun KS <getarunks@gmail.com>
>
> Signed-off-by: Arun KS <getarunks@gmail.com>
> ---
>  drivers/video/backlight/Kconfig     |    2 +-
>  drivers/video/backlight/da903x_bl.c |   12 ++++++++++++
>  2 files changed, 13 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 90861cd..1607bc9 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -203,7 +203,7 @@ config BACKLIGHT_DA903X
>        depends on BACKLIGHT_CLASS_DEVICE && PMIC_DA903X
>        help
>          If you have a LCD backlight connected to the WLED output of DA9030
> -         or DA9034 WLED output, say Y here to enable this driver.
> +         or DA9034 WLED, LED1, LED2 outputs, say Y here to enable this driver.
>
>  config BACKLIGHT_MBP_NVIDIA
>        tristate "MacBook Pro Nvidia Backlight Driver"
> diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
> index 93bb434..c6ceb76 100644
> --- a/drivers/video/backlight/da903x_bl.c
> +++ b/drivers/video/backlight/da903x_bl.c
> @@ -23,6 +23,8 @@
>  #define DA9030_WLED_CP_EN      (1 << 6)
>  #define DA9030_WLED_TRIM(x)    ((x) & 0x7)
>
> +#define DA9034_LED1_CONTROL    0x35
> +#define DA9034_LED2_CONTROL    0x36
>  #define DA9034_WLED_CONTROL1   0x3C
>  #define DA9034_WLED_CONTROL2   0x3D
>
> @@ -66,6 +68,14 @@ static int da903x_backlight_set(struct backlight_device *bl, int brightness)
>                val |= brightness ? DA9030_WLED_CP_EN : 0;
>                ret = da903x_write(dev, DA9030_WLED_CONTROL, val);
>                break;
> +       case DA9034_ID_LED_1:
> +               ret = da903x_update(dev, DA9034_LED1_CONTROL,
> +                               brightness, 0x7f);
> +               break;
> +       case DA9034_ID_LED_2:
> +               ret = da903x_update(dev, DA9034_LED2_CONTROL,
> +                               brightness, 0x7f);
> +               break;
>        }
>
>        if (ret)
> @@ -114,6 +124,8 @@ static int da903x_backlight_probe(struct platform_device *pdev)
>                max_brightness = DA9030_MAX_BRIGHTNESS;
>                break;
>        case DA9034_ID_WLED:
> +       case DA9034_ID_LED_1:
> +       case DA9034_ID_LED_2:
>                max_brightness = DA9034_MAX_BRIGHTNESS;
>                break;
>        default:
> --
> 1.5.4.3
>
>
