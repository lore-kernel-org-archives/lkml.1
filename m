Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYBYLKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYBYLKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYBYLJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:09:57 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51285 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbYBYLJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:09:56 -0500
Date: Mon, 25 Feb 2008 13:08:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225110858.GA32450@cs181133002.pp.htv.fi>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080225101433.GA30685@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:14:33AM +0100, Ingo Molnar wrote:
> 
> * Florian Fainelli <florian.fainelli@telecomint.eu> wrote:
> 
> > This patch adds the default kernel configuration for the RDC R-321x 
> > SoC.
> 
> hm, i'm not sure. Right now we just have a 32-bit defconfig and a 64-bit 
> defconfig - but there are about 8 subarchitectures in arch/x86. Given 
> the amount of variety in PC hardware, i doubt it makes sense to start 
> collecting defconfigs for hardware variants - we'd end up having 
> hundreds or thousands of them. Even ARM has only 75 defconfigs.

What I want is at least one defconfig per subarchitecture for compile 
tests.

And especially considering the original purpose "configuration users can 
use as a starting point for configuring their kernel" I even wouldn't 
mind if we had a few dozen x86 defconfigs.

> what i do is i regularly test whether "make allyesconfig" boots all the 
> way up to general user-space in regular whitebox PC hardware. For 
> example the attached config is such a config, i successfully booted it 
> on 2.6.25-rc3 on a stock PC.

You are testing something completely different here.

What I want is that e.g. after fiddling with kernel headers I want an 
easy way of having much compile coverage. And my script that builds all 
defconfig's is trivial (although it takes a day to finish).

> This way we can ensure that the (near-) totality of the config space is 
> bootable on regular PCs, and the subarch support is basically just 
> bootstrap and quirks differences.

You miss our headers mess.

You remember how your big x86 merge this merge window broke 8 or 9 other 
architectures? Change one file under include/ and watch how many 
configurations no longer build.

Or other subtle differences between the subarchs that have in the past 
led to compile errors.

I do consider them useful for the way I'm doing kernel tests, and even 
if you don't consider them that useful can we agree that adding a 
defconfig is neither a big deal for the subarchitecture maintainer nor 
imposes any maintainance work on you as maintainer (except for sometimes 
applying patches adding/updating them)?

> Longer term we should get rid of the 
> subarchitecture distinction altogether and turn them into regular 
> quirks/callbacks/drivers.
>...

Generally agreed (with my biggest worry being whether changing 
CLOCK_TICK_RATE from a compile time constant to a runtime
variable has any performance effects).

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

