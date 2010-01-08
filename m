Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116Ab0AHIci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab0AHIci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740Ab0AHIch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:32:37 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:46526 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536Ab0AHIcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:32:36 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
X-IronPort-AV: E=Sophos;i="4.49,241,1262559600";   d="scan'208";a="40127849"
Message-id: <4B46EDA1.4030902@nets.rwth-aachen.de>
Date: Fri, 08 Jan 2010 09:32:33 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
To: Daniel Mack <daniel@caiaq.de>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-geode@lists.infradead.org" <linux-geode@lists.infradead.org>
Subject: Re: 2.6.33-rc3 regression: leds_alix2: can't allocate I/O for GPIO
References: <4B45B6DD.4060903@nets.rwth-aachen.de>
 <1262861484.8493.14.camel@dax.rpnet.com>
 <4B45CC4C.4030603@nets.rwth-aachen.de> <4B45CF73.9090304@nets.rwth-aachen.de>
 <20100107124630.GU28375@buzzloop.caiaq.de>
 <4B45E905.7040401@nets.rwth-aachen.de>
 <1262885241.27762.1.camel@dax.rpnet.com>
 <20100108030837.GY28375@buzzloop.caiaq.de>
In-reply-to: <20100108030837.GY28375@buzzloop.caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack schrieb:
> On Thu, Jan 07, 2010 at 05:27:21PM +0000, Richard Purdie wrote:
>> On Thu, 2010-01-07 at 15:00 +0100, Arnd Hannemann wrote:
>>> Daniel Mack schrieb:
>>>> On Thu, Jan 07, 2010 at 01:11:31PM +0100, Arnd Hannemann wrote:
>>>>> Arnd Hannemann schrieb:
>>>>> Oh, maybe using cs5535_gpio AND leds_alix2 together was never supposed to work?
>>>> That is the problem indeed. The problem is that three of these GPIOs are
>>>> connected to LEDs, so if both drivers are enabled, they will both alter
>>>> the same GPIOs. Hmm, don't know how to handle this. Maybe the LED driver
>>>> should use the GPIO interface and that's it?
>>> I'm not sure that this configuration needs to be supported at all,
>>> so disallowing that both drivers are configured via Kconfig could be a simple solution.
>> Agreed, Kconfig dependencies for this until the code is improved look
>> like the best option. Does someone want to send me a patch?
> 
> Does the one below look ok?
> 
> Thanks,
> Daniel
> 
> 
> From ebb89d7d1908e85587f3e64bcea0dd77a92cc744 Mon Sep 17 00:00:00 2001
> From: Daniel Mack <daniel@caiaq.de>
> Date: Fri, 8 Jan 2010 02:22:10 +0800
> Subject: [PATCH] LEDS: ALIX2: Add dependency to !GPIO_CS5335
> 
> The ALIX2 LED driver and the CS5535 GPIO driver share the same I/O
> range which causes a conflict if they're both enabled. Fix this for now
> by adding a Kconfig dependency. While at it, also drop the EXPERIMENTAL
> flag, as the code has been around for awhile already.
> 
> Note that this is a hack. At some point, a real platform support for
> this board should be added which handles the LEDs via the leds-gpio
> driver.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
> ---
>  drivers/leds/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 8a0e1ec..7f292ae 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -72,7 +72,7 @@ config LEDS_WRAP
>  
>  config LEDS_ALIX2
>  	tristate "LED Support for ALIX.2 and ALIX.3 series"
> -	depends on LEDS_CLASS && X86 && EXPERIMENTAL
> +	depends on LEDS_CLASS && X86 && !GPIO_CS5535

You should add && !CS5535_GPIO, too. In fact CS5535_GPIO
was the one that I had issues with. Though, I wonder why
there are multiple drivers... Buts thats another issue.

>  	help
>  	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
>  	  You have to set leds-alix2.force=1 for boards with Award BIOS.

Best regards,
Arnd
