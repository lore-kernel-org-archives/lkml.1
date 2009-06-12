Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbZFLMuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbZFLMuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZFLMuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:50:11 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:20539 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZFLMuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:50:09 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4A324F00.7020602@tremplin-utc.net>
Date: Fri, 12 Jun 2009 14:50:08 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3: add click function
References: <20090612101805.GC18682@elf.ucw.cz> <1244803042-2913-1-git-send-email-daniel@caiaq.de> <4A323FB4.1090404@tremplin-utc.net> <20090612123156.GE29236@buzzloop.caiaq.de>
In-Reply-To: <20090612123156.GE29236@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 12-06-09 14:31, Daniel Mack schreef:
:
> 
> It's not so much black magic but follows the standard procedure for
> passing device specific data to probed SPI devices. What you find in
> board support code for embedded devices is a defintion of an
> spi_board_info struct. On my platform, it looks like this for the lis3
> device:
> 
> static struct lis3lv02d_platform_data lis3_pdata = {
>         .click_flags    = LIS3_CLICK_SINGLE_X |
>                           LIS3_CLICK_SINGLE_Y |
>                           LIS3_CLICK_SINGLE_Z,
>         .click_thresh_x = 10,
>         .click_thresh_y = 10,
>         .click_thresh_z = 10,
>         .irq_cfg        = LIS3_IRQ1_CLICK,
>                           LIS3_IRQ_ACTIVE_HIGH,
> };
> 
> static struct spi_board_info my_spi_devices[] __initdata = {
>         {
>                 .modalias       = "lis3lv02d_spi",
>                 .max_speed_hz   = 1000000,
>                 .bus_num        = 0,
>                 .chip_select    = 0,
>                 .controller_data = (void *) mfp_to_gpio(GPIO_ACCEL_CS),
>                 .platform_data  = &lis3_pdata,
>                 .irq            = gpio_to_irq(mfp_to_gpio(GPIO_ACCEL_IRQ)),
>         },
> 
I see. So your platform is not among the one contained in the vanilla
kernel? Shouldn't this above code be written somewhere so that people
know about it? Some of the values do not seem especially obvious!

> I don't know ACPI, so I can't say how a similiar abstraction could be
> achieved.
> 
>> Also, it seems to only set up the "click" feature, without ever using
>> it. How do you access this information from userspace? Is it specific to
>> SPI? Maybe it could also generate button events in the joystick interface?
> 
> We're using the IRQ outputs of that chips directly as source to other
> circuity, so there is no userspace logic in the game. If anyone needs
> that, a simple callback function would be easy to add at some later
> point.
I guess that to have the functionality in ACPI, a complete handling of
the interruptions, up to the generation of button events would be
needed. This can be done later on, whenever someone finds the need...

> 
> See the updated patch below.
Looks good to me.

> 
> From 17d749d1f7b9c1287cc5b8109921e7a6f149b8bc Mon Sep 17 00:00:00 2001
> From: Daniel Mack <daniel@caiaq.de>
> Date: Thu, 11 Jun 2009 21:47:10 +0200
> Subject: [PATCH] lis3: add click function
> 

Acked-by: Eric Piel <eric.piel@tremplin-utc.net>

Thanks,
Eric
