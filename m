Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbXKJJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbXKJJiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 04:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbXKJJiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 04:38:11 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:36596 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbXKJJiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 04:38:10 -0500
Date: Sat, 10 Nov 2007 10:39:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071110093948.GB5707@uranus.ravnborg.org>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org> <20071110082152.GA18632@linux-sh.org> <47356AD5.4070102@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47356AD5.4070102@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 03:24:53AM -0500, Jeff Garzik wrote:
> Paul Mundt wrote:
> >This is one of the things I've been wondering about with an sh/sh64
> >unification, as we have no option but having completely different
> >toolchains, and CONFIG_64BIT=y won't work there when they are both
> >using a 32-bit ABI.
> 
> 
> IMO it seems like you ought to be able to do
> 
> 	make ARCH=sh
> 		or
> 	make ARCH=sh64
> 
> and have it do the right thing.  Ditto for ppc/ppc64, etc.
> 
> Sane, straightforward, simple, consistent with existing practice...

Excpet that setting ARCH=... imply more than the 32/64 bit choice.
One other thing is that using ARCH=xxx64 tells people
that the kernel is located in arch/xxx64/boot/

So what is it we want ARCH=xxx to say?
a) the exact architecture to use? (seems not)
b) a good hint about the architecture and a 32/64 bit selector (seems so)
c) part of the location of the build kernel (not discussed)
d) output of `uname -m` (?)

ARCH=xxx
is used for more than the 32/64 bit selection mechanish.
It is in fact an overloaded interface selecting several
things in one go.


And it is not even used consistent across the linux kernel.
Some use it for their generic architecture and later
decide on the bit size. Other let it imply the bit size.

In general a confusing thing that we are now getting used to.

In an not opposed to keep ARCH={i386,x86_64} but then we should
establish clear semantics.
What does it imply when I build a kernel with ARCH=i386?
- 32 bit, build kernel, uname -m

and what about the intuitive version: make ARCH=x86
Is this a 32 or 64 bit kernel?

How do we in a generic way say "this is a 64 bt kernel"?
Something that works equally well for s390, ppc, sh, sparc etc?

make ARCH=s39064 looks bad...
make ARCH=sh64 looks OK...

	Sam
