Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab0APSwq (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 13:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296Ab0APSwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 13:52:45 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:46829 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab0APSwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 13:52:44 -0500
Date: Sat, 16 Jan 2010 19:52:37 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-geode@lists.infradead.org" <linux-geode@lists.infradead.org>
Subject: Re: 2.6.33-rc3 regression: leds_alix2: can't allocate I/O for GPIO
Message-ID: <20100116185237.GX29559@buzzloop.caiaq.de>
References: <4B45B6DD.4060903@nets.rwth-aachen.de>
 <1262861484.8493.14.camel@dax.rpnet.com>
 <4B45CC4C.4030603@nets.rwth-aachen.de>
 <4B45CF73.9090304@nets.rwth-aachen.de>
 <20100107124630.GU28375@buzzloop.caiaq.de>
 <4B45E905.7040401@nets.rwth-aachen.de>
 <1262885241.27762.1.camel@dax.rpnet.com>
 <20100108030837.GY28375@buzzloop.caiaq.de>
 <4B46EDA1.4030902@nets.rwth-aachen.de>
 <20100110122754.GC8970@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110122754.GC8970@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Sun, Jan 10, 2010 at 01:27:54PM +0100, Daniel Mack wrote:
> On Fri, Jan 08, 2010 at 09:32:33AM +0100, Arnd Hannemann wrote:
> > Daniel Mack schrieb:
> 
> [...]
> 
> > > From ebb89d7d1908e85587f3e64bcea0dd77a92cc744 Mon Sep 17 00:00:00 2001
> > > From: Daniel Mack <daniel@caiaq.de>
> > > Date: Fri, 8 Jan 2010 02:22:10 +0800
> > > Subject: [PATCH] LEDS: ALIX2: Add dependency to !GPIO_CS5335
> > > 
> > > The ALIX2 LED driver and the CS5535 GPIO driver share the same I/O
> > > range which causes a conflict if they're both enabled. Fix this for now
> > > by adding a Kconfig dependency. While at it, also drop the EXPERIMENTAL
> > > flag, as the code has been around for awhile already.
> > > 
> > > Note that this is a hack. At some point, a real platform support for
> > > this board should be added which handles the LEDs via the leds-gpio
> > > driver.
> > > 
> > > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > > Cc: Richard Purdie <rpurdie@rpsys.net>
> > > Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
> > > ---
> > >  drivers/leds/Kconfig |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> > > index 8a0e1ec..7f292ae 100644
> > > --- a/drivers/leds/Kconfig
> > > +++ b/drivers/leds/Kconfig
> > > @@ -72,7 +72,7 @@ config LEDS_WRAP
> > >  
> > >  config LEDS_ALIX2
> > >  	tristate "LED Support for ALIX.2 and ALIX.3 series"
> > > -	depends on LEDS_CLASS && X86 && EXPERIMENTAL
> > > +	depends on LEDS_CLASS && X86 && !GPIO_CS5535
> > 
> > You should add && !CS5535_GPIO, too. In fact CS5535_GPIO
> > was the one that I had issues with. Though, I wonder why
> > there are multiple drivers... Buts thats another issue.
> 
> Ah, right, thanks for noticing. New patch below.
> 
> Daniel
> 
> 
> From 0ce35578c6705dd1c44d076529df6dba889b7b76 Mon Sep 17 00:00:00 2001
> From: Daniel Mack <daniel@caiaq.de>
> Date: Fri, 8 Jan 2010 02:22:10 +0800
> Subject: [PATCH] LEDS: ALIX2: Add dependency to !GPIO_CS5335
> 
> The ALIX2 LED driver and the CS5535 GPIO drivers share the same I/O
> range which causes a conflict if they're both enabled. Fix this for now
> by adding Kconfig dependencies. While at it, also drop the EXPERIMENTAL
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
> index 8a0e1ec..fef1cf4 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -72,7 +72,7 @@ config LEDS_WRAP
>  
>  config LEDS_ALIX2
>  	tristate "LED Support for ALIX.2 and ALIX.3 series"
> -	depends on LEDS_CLASS && X86 && EXPERIMENTAL
> +	depends on LEDS_CLASS && X86 && !GPIO_CS5535 && !CS5535_GPIO
>  	help
>  	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
>  	  You have to set leds-alix2.force=1 for boards with Award BIOS.
> -- 
> 1.6.3.3
> 
