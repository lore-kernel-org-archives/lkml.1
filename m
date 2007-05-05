Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbXEEP1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbXEEP1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbXEEP03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:26:29 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4679 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbXEEPZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:25:47 -0400
Date: Sat, 5 May 2007 11:04:26 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 4/10] ARM: OMAP: gpio init section cleanups
Message-ID: <20070505100426.GA9943@flint.arm.linux.org.uk>
Mail-Followup-To: Tony Lindgren <tony@atomide.com>,
	linux-kernel@vger.kernel.org,
	David Brownell <dbrownell@users.sourceforge.net>
References: <11761524713580-git-send-email-tony@atomide.com> <1176152483689-git-send-email-tony@atomide.com> <11761524911912-git-send-email-tony@atomide.com> <1176152494436-git-send-email-tony@atomide.com> <11761525022200-git-send-email-tony@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11761525022200-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 05:01:06PM -0400, Tony Lindgren wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Minor GPIO cleanups:  remove needless #include, and omap_gpio_init()
> should be __init, as well as all the board init code calling it.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

I've applied 8 patches from this series by cherry picking it from your
git tree, minus this patch which git wouldn't apply due to fuzz in
arch/arm/plat-omap/gpio.c.

> ---
>  arch/arm/mach-omap1/board-fsample.c   |    2 +-
>  arch/arm/mach-omap1/board-h3.c        |    2 +-
>  arch/arm/mach-omap1/board-innovator.c |    2 +-
>  arch/arm/mach-omap1/board-perseus2.c  |    2 +-
>  arch/arm/plat-omap/gpio.c             |    3 +--
>  5 files changed, 5 insertions(+), 6 deletions(-)
> 
> --- a/arch/arm/mach-omap1/board-fsample.c
> +++ b/arch/arm/mach-omap1/board-fsample.c
> @@ -246,7 +246,7 @@ static void __init fsample_init_smc91x(void)
>  	mdelay(50);
>  }
>  
> -void omap_fsample_init_irq(void)
> +static void __init omap_fsample_init_irq(void)
>  {
>  	omap1_init_common_hw();
>  	omap_init_irq();
> --- a/arch/arm/mach-omap1/board-h3.c
> +++ b/arch/arm/mach-omap1/board-h3.c
> @@ -455,7 +455,7 @@ static void __init h3_init_smc91x(void)
>  	}
>  }
>  
> -void h3_init_irq(void)
> +static void __init h3_init_irq(void)
>  {
>  	omap1_init_common_hw();
>  	omap_init_irq();
> --- a/arch/arm/mach-omap1/board-innovator.c
> +++ b/arch/arm/mach-omap1/board-innovator.c
> @@ -308,7 +308,7 @@ static void __init innovator_init_smc91x(void)
>  	}
>  }
>  
> -void innovator_init_irq(void)
> +static void __init innovator_init_irq(void)
>  {
>  	omap1_init_common_hw();
>  	omap_init_irq();
> --- a/arch/arm/mach-omap1/board-perseus2.c
> +++ b/arch/arm/mach-omap1/board-perseus2.c
> @@ -246,7 +246,7 @@ static void __init perseus2_init_smc91x(void)
>  	mdelay(50);
>  }
>  
> -void omap_perseus2_init_irq(void)
> +static void __init omap_perseus2_init_irq(void)
>  {
>  	omap1_init_common_hw();
>  	omap_init_irq();
> --- a/arch/arm/plat-omap/gpio.c
> +++ b/arch/arm/plat-omap/gpio.c
> @@ -13,7 +13,6 @@
>  
>  #include <linux/init.h>
>  #include <linux/module.h>
> -#include <linux/sched.h>
>  #include <linux/interrupt.h>
>  #include <linux/ptrace.h>
>  #include <linux/sysdev.h>
> @@ -1329,7 +1328,7 @@ void omap2_gpio_resume_after_retention(void)
>   * This may get called early from board specific init
>   * for boards that have interrupts routed via FPGA.
>   */
> -int omap_gpio_init(void)
> +int __init omap_gpio_init(void)
>  {
>  	if (!initialized)
>  		return _omap_gpio_init();
> -- 
> 1.4.4.2
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
