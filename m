Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbZLOTrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbZLOTrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZLOTrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:47:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54592 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZLOTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:47:34 -0500
Date: Tue, 15 Dec 2009 20:47:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Arve Hj?nnev?g <arve@android.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: GPIO support for HTC Dream
Message-ID: <20091215194725.GH24406@elf.ucw.cz>
References: <20091208214658.GC4164@elf.ucw.cz>
 <4B1ECEEE.3000209@bluewatersys.com>
 <4B203575.6050407@bluewatersys.com>
 <20091210172458.GJ19454@elf.ucw.cz>
 <4B2150B7.3040207@bluewatersys.com>
 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
 <20091211221015.GB24456@elf.ucw.cz>
 <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com>
 <20091214064545.GK5114@elf.ucw.cz>
 <BD79186B4FD85F4B8E60E381CAEE19090200E9E6@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200E9E6@mi8nycmail19.Mi8.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +int gpio_to_irq(unsigned gpio)
> > +{
> > +	return -EINVAL;
> > +}
> 
> This should probably just be an inline function in
> arch/arm/mach-msm/include/mach/gpio.h

Well, it is not performance critical in any way and it is likely to
change in future. I'd leave it here.

> > diff --git a/arch/arm/mach-msm/board-dream.h b/arch/arm/mach-msm/board-dream.h
> > index 4f345a5..dbd78b9 100644
> > --- a/arch/arm/mach-msm/board-dream.h
> > +++ b/arch/arm/mach-msm/board-dream.h
> > @@ -1,5 +1,58 @@
> >  
> > -#define TROUT_CPLD_BASE   0xE8100000
> > -#define TROUT_CPLD_START  0x98000000
> > -#define TROUT_CPLD_SIZE   SZ_4K
> > +#define MSM_SMI_BASE		0x00000000
> > +#define MSM_SMI_SIZE		0x00800000
...
> > +#define DREAM_CPLD_BASE   0xE8100000
> > +#define DREAM_CPLD_START  0x98000000
> > +#define DREAM_CPLD_SIZE   SZ_4K
> > +
> 
> This header might need to be a separate patch.  The only thing in it
> related to the rest of this is DREAM_CPLD_BASE.

Yep.

> > +#ifndef __ASM_ARCH_MSM_GPIO_H
> > +#define __ASM_ARCH_MSM_GPIO_H
> > +
> > +extern int gpio_to_irq(unsigned gpio);
> 
> This should probably be an inline as mentioned above.
> 
> For completeness you should probably also add:
> 
> static inline int irq_to_gpio(unsigned irq)
> {
> 	return -EINVAL;
> }

I'd say that would be overdoing it.

> And, nitpick, move both of them after the gpio_cansleep below.

I'll do the move.

> > +#define DREAM_GPIO_CABLE_IN1		(83)
> > +#define DREAM_GPIO_CABLE_IN2		(49)
> > +
> > +#define DREAM_GPIO_START (128)
> 
> Nitpick.  Tab align these three with the ones below.

Ok.

> > +#define DREAM_GPIO_SDMC_CD_N                (DREAM_GPIO_VIRTUAL_BASE + 0)
> > +#define DREAM_GPIO_END                      (DREAM_GPIO_SDMC_CD_N)
> > +#define DREAM_GPIO_BANK1_FIRST_INT_SOURCE   (DREAM_GPIO_SDMC_CD_N)
> > +#define DREAM_GPIO_BANK1_LAST_INT_SOURCE    (DREAM_GPIO_SDMC_CD_N)
> > +
> > +#endif
> 
> Otherwise, looks good to me.  Just test it to make sure it works :-).
> 
> Since I have no way of compiling or testing this...
> 
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

I believe inlining that function would be bad change. Can I still use
reviewed-by tag?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
