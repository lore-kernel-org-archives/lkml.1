Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZHLGm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZHLGm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 02:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbZHLGm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 02:42:28 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:45668 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750845AbZHLGm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 02:42:27 -0400
Message-ID: <4A826453.1060609@snapgear.com>
Date: Wed, 12 Aug 2009 16:42:27 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: uClinux development list <uclinux-dev@uclinux.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] m68k: restore lost coldfire CLOCK_TICK_RATE
References: <20090620201147.GA14095@frolo.macqel>
In-Reply-To: <20090620201147.GA14095@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philippe,

Philippe De Muyter wrote:
> The good definition of CLOCK_TICK_RATE for coldfires has been lost in the
> merge of m68k and m68knommu include files.  Restore it.  Culprit :
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ebafc17468d58bd903c886175ca84a4edc69ae1d;hp=34055b806a6334624e7e8af6eefc3aee42372a85
> 
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>

I have added this to the for-linus branch at 
git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git.

Thanks
Greg



> diff -r 8dcc271a81a8 arch/m68k/include/asm/timex.h
> --- a/arch/m68k/include/asm/timex.h	Thu Jun 18 14:07:46 2009 -0700
> +++ b/arch/m68k/include/asm/timex.h	Sat Jun 20 21:46:25 2009 +0200
> @@ -3,10 +3,23 @@
>   *
>   * m68k architecture timex specifications
>   */
> -#ifndef _ASMm68k_TIMEX_H
> -#define _ASMm68k_TIMEX_H
> +#ifndef _ASMm68K_TIMEX_H
> +#define _ASMm68K_TIMEX_H
>  
> +#ifdef CONFIG_COLDFIRE
> +/*
> + * CLOCK_TICK_RATE should give the underlying frequency of the tick timer
> + * to make ntp work best.  For Coldfires, that's the main clock.
> + */
> +#include <asm/coldfire.h>
> +#define CLOCK_TICK_RATE	MCF_CLK
> +#else
> +/*
> + * This default CLOCK_TICK_RATE is probably wrong for many 68k boards
> + * Users of those boards will need to check and modify accordingly
> + */
>  #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
> +#endif
>  
>  typedef unsigned long cycles_t;
>  
> _______________________________________________
> uClinux-dev mailing list
> uClinux-dev@uclinux.org
> http://mailman.uclinux.org/mailman/listinfo/uclinux-dev
> This message was resent by uclinux-dev@uclinux.org
> To unsubscribe see:
> http://mailman.uclinux.org/mailman/options/uclinux-dev
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
