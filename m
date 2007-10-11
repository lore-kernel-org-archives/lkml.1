Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbXJKLiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbXJKLiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 07:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbXJKLiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 07:38:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40831 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbXJKLiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 07:38:05 -0400
Date: Thu, 11 Oct 2007 13:39:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rob Landley <rob@landley.net>, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Message-ID: <20071011113931.GB8393@uranus.ravnborg.org>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710110923470.23818@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710110923470.23818@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 09:25:19AM +0200, Geert Uytterhoeven wrote:
> On Wed, 10 Oct 2007, Rob Landley wrote:
> > From: Rob Landley <rob@landley.net>
> > 
> > Rip out hardwired cross compiler name assumption that only m68k makes.
> > 
> > Signed-off-by: Rob Landley <rob@landley.net>
> > ---
> > When you cross compile, you have to set the prefix CROSS_COMPILE to your
> > cross compiler prefix.  You need to do this for all targets (arm, mips, ppc,
> > x86-64 on x86, etc).  This is not specific to m68k, and this value is
> > supplied _to_ the build, not supplied _by_ the build.
> > 
> > The build shouldn't unconditionally overwrite the existing value of this
> > variable with one it makes up.  It has no idea what I called my cross compiler.
> 
> The build does not unconditionally overwrite the existing value of this
> variable. You can specify the name of your cross compiler like this:
> 
>     make CROSS_COMPILE=m68k-linux-
> 
> BTW, m68k-linux-gnu- is the default name for a m68k cross compiler.

For "make headers_install" this is not good.
But I see there is confliting usages here.
1) current functionality makes it easy to build a cross compiled m68k
2) suggested functionality makes it easy to do make headers_install

Btw. if you did:
CROSS_COMPILE ?= m68k-linux-

then I could do:
export CROSS_COMPILE=my-m68k-linux-
make

and still get the expected result.

	Sam


> 
> >  arch/m68k/Makefile |    7 -------
> >  1 file changed, 7 deletions(-)
> > 
> > diff -r 79f0ea1e0e70 arch/m68k/Makefile
> > --- a/arch/m68k/Makefile	Tue Oct 09 21:00:40 2007 +0000
> > +++ b/arch/m68k/Makefile	Wed Oct 10 17:02:17 2007 -0500
> > @@ -13,17 +13,10 @@
> >  # Copyright (C) 1994 by Hamish Macdonald
> >  #
> >  
> > -# test for cross compiling
> > -COMPILE_ARCH = $(shell uname -m)
> > -
> >  # override top level makefile
> >  AS += -m68020
> >  LDFLAGS := -m m68kelf
> >  LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
> > -ifneq ($(COMPILE_ARCH),$(ARCH))
> > -	# prefix for cross-compiling binaries
> > -	CROSS_COMPILE = m68k-linux-gnu-
> > -endif
> >  
> >  ifdef CONFIG_SUN3
> >  LDFLAGS_vmlinux = -N
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
