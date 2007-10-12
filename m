Return-Path: <linux-kernel-owner+w=401wt.eu-S932534AbXJLGwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbXJLGwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758961AbXJLGvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:51:55 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:42210 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbXJLGvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:51:53 -0400
Date: Fri, 12 Oct 2007 08:51:50 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
cc: Finn Thain <fthain@telegraphics.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
In-Reply-To: <200710111614.39879.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0710120849480.11634@anakin>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710111707270.3729@anakin>
 <Pine.LNX.4.64.0710120211130.4083@loopy.telegraphics.com.au>
 <200710111614.39879.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Rob Landley wrote:
> On Thursday 11 October 2007 11:26:07 am Finn Thain wrote:
> My toolchains override the default prefix to just the target, resulting 
> in "m68k-gcc".  (It's shorter, and when you're creating a dozen toolchains 
> having them all say -linux- in the middle of every command name gets a bit 
> silly...)
> 
> When it started complaining about "m68k-linux-gnu-gcc" (which is _not_ what my 
> cross compiler is called) I spent half an hour tracking down where it was 
> getting that name from and what exactly was going on.  (Was my build script 
> supplying the wrong name?  Did something set an environment variable it 
> shouldn't have?  Did the gcc build suddenly reveal another strange buried 
> corner case that made it revert to a default against explicit instructions 
> _again_?)
> 
> When I found the surprising behavior that cost me time and effort to diagnose, 
> I submitted a patch so it wouldn't confuse future developers the first time 
> _they_ try to build m68k.  (Yes, I think there might be such.  Call me 
> crazy.)  I've seen "didn't specify any cross compiler" failures before, on 
> arm and x86-64 and mips and sparc and so on.  I've seen it in the linux 
> kernel, in busybox, in uClibc, and in various gnu packages 
> with ./configureitis.  This is the first time I've seen a package confidently 
> decide for itself to use a compiler name that isn't in the $PATH, and 
> especially the first time I've seen Linux do it.  It cost me time to 
> disagnose because it looks like it's getting a CROSS_COMPILE setting from its 
> environment somehow, and the logical thing to do is look at that environment 
> (and the build scripts driving it, and the temp files) to see where such a 
> thing might be leaking in from.  The fact it might be hallucinating its own 
> value was not my first guess, because nothing else I've encountered does that 
> in this context.
> 
> > This wasn't an issue before we came to depend on cross compilers. Since we
> > tend to need them more as compilation becomes more expensive, IMHO we
> > should follow the practice of the embedded architectures.
> 
> That topic's a can of worms, but I point out that you always needed a cross 
> compiler to bootstrap a new platform. :)
> 
> If you're going to support cross compiling at all, you might as well do it 
> more or less consistently for all targets.

If your cross-compiler is called differently than the default on in
arch/*/Makefile, what's the problem with calling?

    make ARCH=myarch CROSS_COMPILE=my-cross-compile-prefx-

This has been working for +10 years on all non-ia32 platforms I ever worked on.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
