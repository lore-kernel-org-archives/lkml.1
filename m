Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXETLHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXETLHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbXETLHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:07:25 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:38038 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbXETLHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:07:24 -0400
Date: Sun, 20 May 2007 13:07:20 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: RFC: kconfig select warnings bogus?
In-Reply-To: <20070520094033.GA9645@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0705201305580.20754@anakin>
References: <20070519151523.GA26724@uranus.ravnborg.org>
 <20070519110944.2a52061e.akpm@linux-foundation.org> <20070519230537.GI6291@stusta.de>
 <20070519162239.1bcb03d6.akpm@linux-foundation.org>
 <20070520094033.GA9645@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Russell King wrote:
> On Sat, May 19, 2007 at 04:22:39PM -0700, Andrew Morton wrote:
> > On Sun, 20 May 2007 01:05:37 +0200 Adrian Bunk <bunk@stusta.de> wrote:
> > > Look for example at the last one in drivers/input/mouse/Kconfig:
> > > 
> > > config MOUSE_ATARI
> > >         tristate "Atari mouse"
> > >         depends on ATARI
> > >         select ATARI_KBD_CORE
> > > 
> > > This is perfectly correct (the select'ed symbol is only unavailable when 
> > > the dependency can't be fulfilled), and all things to "fix" the warning 
> > > will make it worse.
> > 
> > If ATARI is unset then we shouldn't be generating the "'select' used by
> > config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'"
> > warnings, should we?
> 
> Playing devils advocate here.  What if "ATARI_KBD_CORE" never exists?
> Let's say you run 'make kconfig' and you select the ATARI option.  When
> does the lack of ATARI_KBD_CORE get noticed and what is the expected
> result?
> 
> Let's put it another way.  Given the complexities of the configuration
> system as it is today, if we do not generate a warning at parse time,
> how do we find things like:
> 
> config SHARPSL_PM
>         bool
>         select APM_EMULATION
> 
> config PXA_SHARP_C7xx
>         bool
>         select PXA_SSP
>         select SHARPSL_PM
> 
> config MACH_CORGI
>         bool "Enable Sharp SL-C700 (Corgi) Support"
>         depends on PXA_SHARPSL_25x
>         select PXA_SHARP_C7xx
> 
> and (lets say for the sake of argument) APM_EMULATION were to go away.

It will probably fail to build :-)

> Do we really need an exhaustive set of configuration combinations to
> run through Kconfig to find possible missing symbols?  Or do we need a
> Kconfig lint to find them?

Now let's say PXA_SHARPSL_25x goes away (or someone made a typo
in her `depends on')...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
