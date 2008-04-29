Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbYD2NgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbYD2NgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbYD2Nfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:35:52 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46000 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbYD2Nfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:35:51 -0400
Date: Tue, 29 Apr 2008 16:35:14 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
       Christian Kujau <lists@nerdbynature.de>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25: pmac_newworld undefined
Message-ID: <20080429133514.GA30524@cs181133002.pp.htv.fi>
References: <alpine.DEB.1.10.0804271951190.11017@sheep.housecafe.de> <20080428042044.GX20457@bakeyournoodle.com> <20080428193324.GC13400@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080428193324.GC13400@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:33:24PM +0200, Sam Ravnborg wrote:
> On Mon, Apr 28, 2008 at 02:20:44PM +1000, Tony Breeds wrote:
> > On Sun, Apr 27, 2008 at 08:03:46PM +0200, Christian Kujau wrote:
> > > Hi,
> > > 
> > > the build failure reported[0] by Kamalesh back in 01/2008 is still 
> > > present in today's 2.6.25-git with CONFIG_NVRAM=m (instead of =y):
> > > 
> > >   Building modules, stage 2.
> > >   MODPOST 72 modules
> > > ERROR: "pmac_newworld" [arch/powerpc/platforms/powermac/nvram.ko] undefined!
> > > ERROR: "__alloc_bootmem" [arch/powerpc/platforms/powermac/nvram.ko] 
> > > undefined!
> > > make[1]: *** [__modpost] Error 1
> > 
> > Yeah that isn't really surprising.  Essentially
> > arch/powerpc/platforms/powermac/nvram.c must be builtin (not modular)
> > but CONFIG_NVRAM is tristate, and your .config has CONFIG_NVRAM=m.
> > 
> > We can probably "fix" this by adding another config config symbol and
> > "selecting" that from CONFIG_NVRAM.  Then using this new symbol in
> > arch/powerpc/platforms/powermac/*
> > 
> > so I think with we need is:
> > config NVRAM
> >   bool "..." if PPC32
> >   tristate "..." if !PPC32
> >   ...
> >   ...
> > 
> > Sam is there some way to achieve that or should we just create an
> > secondary symbol?
> 
> In the Makefile you could just do a:
> 
> obj-$(CONFIG_NVRAM:m=y)             += nvram.o
> 
> Then you would force nvram to be build-in.
> That looks simpler than messing with Kconfig in this case.

You miss that this is only true on powerpc.

And for such issues Kconfig anyway is the right place - assume how your 
solution would break if NVRAM would some day select or depend on some 
helper code.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

