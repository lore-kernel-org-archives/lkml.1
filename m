Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbZDGMAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbZDGMAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZDGMAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:00:25 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57764 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751290AbZDGMAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:00:24 -0400
Date: Tue, 7 Apr 2009 14:00:22 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
       Richard Purdie <rpurdie@linux.intel.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: leds: just ignore invalid GPIOs in leds-gpio
In-Reply-To: <200904062059.n36Kxlum026774@hera.kernel.org>
Message-ID: <alpine.LRH.2.00.0904071359010.23019@vixen.sonytel.be>
References: <200904062059.n36Kxlum026774@hera.kernel.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/d379ee8acd0719736ee7f1d1ccc3b5765880eaf8
> Commit:     d379ee8acd0719736ee7f1d1ccc3b5765880eaf8
> Parent:     7fbc3a9b132e93b2ba1fd889c1ad8a4135731cc3
> Author:     David Brownell <dbrownell@users.sourceforge.net>
> AuthorDate: Thu Mar 5 16:46:44 2009 -0800
> Committer:  Richard Purdie <rpurdie@linux.intel.com>
> CommitDate: Mon Apr 6 16:06:27 2009 +0100
> 
>     leds: just ignore invalid GPIOs in leds-gpio
>     
>     Sometimes it's awkward to make sure that the array in the
>     platform_data handed to the leds-gpio driver has only valid
>     data ... some leds may not be always available, and coping
>     with that currently requires patching or rebuilding the array.
>     
>     This patch fixes that by making it be OK to pass an invalid
>     GPIO (such as "-EINVAL") ... such table entries are skipped.
>     
>     [rpurdie@linux.intel.com: adjusted to apply against other led tree changes]
>     Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
>     Tested-by: Diego Dompe <diego.dompe@ridgerun.com>
>     Signed-off-by: Richard Purdie <rpurdie@linux.intel.com>
> ---
>  drivers/leds/leds-gpio.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index 8fa352a..102ef4a 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -78,6 +78,13 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
>  {
>  	int ret;
>  
> +	/* skip leds that aren't available */
> +	if (!gpio_is_valid(template->gpio)) {
> +		printk(KERN_INFO "Skipping unavilable LED gpio %d (%s)\n", 
> +				template->gpio, template->name);
> +		return;

| drivers/leds/leds-gpio.c:85: warning: 'return' with no value, in function
| returning non-void

So what should we return here? -ENODEV? -EINVAL? Anything else?

> +	}
> +
>  	ret = gpio_request(template->gpio, template->name);
>  	if (ret < 0)
>  		return ret;

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
