Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbXJLKUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbXJLKUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 06:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXJLKTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 06:19:55 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38489 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbXJLKTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 06:19:54 -0400
Date: Fri, 12 Oct 2007 12:21:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, Rob Landley <rob@landley.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Message-ID: <20071012102124.GA18959@uranus.ravnborg.org>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710111707270.3729@anakin> <Pine.LNX.4.64.0710120211130.4083@loopy.telegraphics.com.au> <200710111614.39879.rob@landley.net> <Pine.LNX.4.64.0710120849480.11634@anakin> <Pine.LNX.4.64.0710121731110.17887@loopy.telegraphics.com.au> <Pine.LNX.4.64.0710121046020.7335@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710121046020.7335@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 10:51:00AM +0200, Geert Uytterhoeven wrote:
> On Fri, 12 Oct 2007, Finn Thain wrote:
> > > If your cross-compiler is called differently than the default on in 
> > > arch/*/Makefile,
> > 
> > Part of the problem is that there is no compelling default. The name of 
> > the cross-compiler can vary depending on the chosen executable prefix or 
> > the chosen target tuple.
> > 
> > Let's say I create new cross toolchains for both m68k and powerpc. I use 
> > the "m68k-linux-gnu" to follow the m68k default, but let's assume powerpc 
> > users prefer their default "powerpc-linux" so I follow that too. The 
> > result is that I now have gcc's -B option working (or not working) in 
> > suprising ways too.
> > 
> > Uniformity is more helpful downstream than a different arbitrary default 
> > for each architecture. Debian should patch their default into their kernel 
> > source packages if they've standardised on cross compiler prefixes.
> > 
> > > what's the problem with calling?
> > > 
> > >     make ARCH=myarch CROSS_COMPILE=my-cross-compile-prefx-
> > > 
> > > This has been working for +10 years on all non-ia32 platforms I ever worked on.
> > 
> > But there is no problem with calling that (?). Rob's patch doesn't change 
> > this.
> 
> But it makes life harder for the people who use it daily.
> 
> If the consensus is to not provide default cross compiler prefixes in
> arch/*/Makefile, fine for me, but IFF it's done for all architectures
> (i.e. check with the blackfin, h8300, mips, parisc, and xtensa people
> first).

Test if the expected gcc is available and set CROSS_COMPILE
if it is present. Otherwise do not touch CROSS_COMPILE.

m68kgcc := $(shell "test if m68k-gcc is present and echo 'y' if so")
ifeq ($(m68kgcc,y)
        CROSS_COMPILE := m68k-foo
endif

Then everyone is happy.
parisc does something similar.

	Sam
