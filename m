Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbXETSbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbXETSbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 14:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbXETSbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 14:31:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39973 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757159AbXETSbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 14:31:02 -0400
Date: Sun, 20 May 2007 20:30:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>
Subject: Re: RFC: kconfig select warnings bogus?
Message-ID: <20070520183049.GS6291@stusta.de>
References: <20070519151523.GA26724@uranus.ravnborg.org> <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com> <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com> <20070519230940.GJ6291@stusta.de> <a781481a0705191719u5234b248v8d36af6a368a5119@mail.gmail.com> <Pine.LNX.4.58.0705200228360.1671@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0705200228360.1671@shell4.speakeasy.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 02:52:14AM -0700, Trent Piepho wrote:
> On Sun, 20 May 2007, Satyam Sharma wrote:
> > On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> > > On Sun, May 20, 2007 at 05:25:24AM +0530, Satyam Sharma wrote:
> > > > On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> > > >> On Sun, May 20, 2007 at 05:06:33AM +0530, Satyam Sharma wrote:
> > > >> > On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> > > >> There are cases where "default .. if .." is the right idiom, but there
> > > >> are also cases where "select" is the right idiom. And for helper code
> > > >> like ATARI_KBD_CORE, "select" is the right idiom.
> > > >
> > > > ATARI_KBD_CORE, unlike MII, is defined only by some archs. And the
> > > > correct (most widely used or standard, in any case) idiom for that is
> > > > "default .. if ..". Or perhaps you can convert those helper code options in
> > > > arch/.../config's over to select too, as an exercise? :-)
> > >
> > > Perhaps not as an exercise, but actually for real.
> > >
> > > We had "fixed" such warnings in the past similar to your patch, but that
> > > was actually a mistake.
> > >
> > > And "correct" can easily be the opposite of "most widely used or standard"
> > > if you discover that you did it wrong in the past.
> >
> > In that case the correct approach here too would be to _shift_
> > ATARI_KBD_CORE from arch/m68k/Kconfig to drivers/input/Kconfig
> > and *then* use "select" from the config options that require it in
> > drivers/input/keyboard/Kconfig and drivers/input/mouse/Kconfig
> >
> > (and repeat for other such cases in arch/...)
> 
> You don't need a huge '||' chain, you can always have more than one default
> line:
> 
> config ATARI_KBD_CORE
> 	bool
> 	default y if KEYBOARD_ATARI
> 	default y if MOUSE_ATARI
> 
> Basically a line "config A \n select B" is transformed into "config B \n
> default y if A".  It's the same number of lines, they're just in a new place.

Only if the select'ed option is a bool.
With tristates they are doubled.

And for user visible options like MII you need an additional helper 
option.

And the "just in a new place" makes a big difference in readability.
Compare the version of arch/mips/Kconfig in kernel 2.6.0 with the 
version in current kernels.
E.g. tell me whether there's any system that doesn't select any 
SYS_SUPPORTS_*_ENDIAN. There are possible errors that can be spotted 
much easier when using "select" at the right places.

> Another alternative would be to shift the arch specific drivers to a file
> that's arch specific.  e.g. move MOUSE_ATARI from drivers/input/mouse/Kconfig
> to arch/m68k/Kconfig.

Where is for a Kconfig user (person compiling her own kernel) the 
logical place to search for the Atari mouse driver option?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

