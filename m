Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbXJKPMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbXJKPMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbXJKPML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:12:11 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:54663 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693AbXJKPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:12:08 -0400
Date: Thu, 11 Oct 2007 17:12:06 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
In-Reply-To: <200710110827.12631.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0710111707270.3729@anakin>
References: <200710101722.21126.rob@landley.net> <20071011113931.GB8393@uranus.ravnborg.org>
 <Pine.LNX.4.64.0710111443530.3729@anakin> <200710110827.12631.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Rob Landley wrote:
> On Thursday 11 October 2007 7:46:47 am Geert Uytterhoeven wrote:
> > On Thu, 11 Oct 2007, Sam Ravnborg wrote:
> > > On Thu, Oct 11, 2007 at 09:25:19AM +0200, Geert Uytterhoeven wrote:
> > > > On Wed, 10 Oct 2007, Rob Landley wrote:
> > > > > Rip out hardwired cross compiler name assumption that only m68k
> > > > > makes.
> > > > >
> > > > > Signed-off-by: Rob Landley <rob@landley.net>
> > > > > ---
> > > > > When you cross compile, you have to set the prefix CROSS_COMPILE to
> > > > > your cross compiler prefix.  You need to do this for all targets
> > > > > (arm, mips, ppc, x86-64 on x86, etc).  This is not specific to m68k,
> > > > > and this value is supplied _to_ the build, not supplied _by_ the
> > > > > build.
> > > > >
> > > > > The build shouldn't unconditionally overwrite the existing value of
> > > > > this variable with one it makes up.  It has no idea what I called my
> > > > > cross compiler.
> > > >
> > > > The build does not unconditionally overwrite the existing value of this
> > > > variable. You can specify the name of your cross compiler like this:
> > > >
> > > >     make CROSS_COMPILE=m68k-linux-
> > > >
> > > > BTW, m68k-linux-gnu- is the default name for a m68k cross compiler.
> > >
> > > For "make headers_install" this is not good.
> > > But I see there is confliting usages here.
> > > 1) current functionality makes it easy to build a cross compiled m68k
> > >
> > > Btw. if you did:
> > > CROSS_COMPILE ?= m68k-linux-
> > >
> > > then I could do:
> > > export CROSS_COMPILE=my-m68k-linux-
> > > make
> > >
> > > and still get the expected result.
> >
> > That won't work, cfr. http://lkml.org/lkml/2007/5/6/58.
> 
> Reading the patch in that link, recent cross compilers from _where_?  
> Buildroot?  Cross-tools?  Gentoo embedded?  Cross Linux From Scratch?  My 
> Firmware Linux project?
>
> You assume they all use the same name, yet your patch changes them from one 
> default name to another default name, presumably due to a gcc version change 
> becoming increasingly political about the GNU/Linux/Dammit thing...

Compilers build from the only remaining distribution that supports (sort
of) m68k: Debian.

> None of the other targets I've tried attempt to _supply_ a default.  Just like 
Obviously you haven't tried them all...

> the Linux kernel errors out early in the build if you distclean and then try 
> to run "make" without having run config first.  It doesn't run "defconfig" 
> for you and continue on in that case.  But m68k, uniquely, assumes it knows 
> what you want to do when you didn't tell it.  Other targets do not do this.

If you cross compile for m68k and don't specify a toolchain, you get a
default one: the one the m68k developers use.

On some other architectures, you always have to specify the toolchain.
What's wrong with providing a default?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
