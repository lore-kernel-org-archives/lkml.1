Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbXJJTwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbXJJTwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 15:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbXJJTwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 15:52:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39947 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbXJJTwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:52:39 -0400
Date: Wed, 10 Oct 2007 21:54:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: parisc arch makefile clean-up needed [Was: cleaning up "make headers_install" for various architectures]
Message-ID: <20071010195406.GB2791@uranus.ravnborg.org>
References: <20071010191538.GF2730@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071010191538.GF2730@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Oct 10, 2007 at 08:42:25PM +0200, Sam Ravnborg wrote:
> > parisc arch Makefile needs some love and care...
> > 
> > The logic selecting CROSS_COMPILE seems fishy and wrong -
> > the error reported by rday is obvious in this respect.
> 
> He doesn't have a compiler installed that can target parisc.  It doesn't
> seem obvious to me that this should work.

We have at least the header_install target where it makes sense
to continue with a gcc that is not for the architecture being build.

So plain gcc (aka no CROSS_COMPILE) should be the fallback
solution. This fallback is anyway what most architectures use.


> > The libs-y assignment should learn from the other architectures how to
> > get the gcc lib filename:
> > $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
> 
> Actually, this looks utterly unstandardised:
> 
> arch/cris/Makefile:LIBGCC = $(shell $(CC) $(CFLAGS) -print-file-name=libgcc.a)
> arch/h8300/Makefile:LIBGCC := $(shell $(CROSS-COMPILE)$(CC) $(CFLAGS) -print-libgcc-file-name)
> arch/m32r/Makefile:LIBGCC       := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
> arch/parisc/Makefile:libs-y     += arch/parisc/lib/ `$(CC) -print-libgcc-file-name`
> arch/sh64/Makefile:LIBGCC := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
> arch/sh/Makefile:LIBGCC := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
> arch/xtensa/Makefile:LIBGCC := $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
> 
> How about we set it in the main Makefile, or one of the ones in
> scripts/?  That way we don't have to learn why $(shell $(CC) $(CFLAGS)
> -print-libgcc-file-name) is superior to `$(CC) -print-libgcc-file-name`

cris lacks a major rehaul - planned in this merge window. Will sync it when done.
h8300 should not use CROSS_COMPILE - a bit confused here.

And the reason why $(shell ) is preferred over backticks is simple.
We almost never use backticks in the kernel Makefile since the $(shell )
syntax is more obvious and I like it this way.

	Sam
