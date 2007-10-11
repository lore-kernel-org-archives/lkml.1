Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbXJKMq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbXJKMq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXJKMqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:46:51 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:41299 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbXJKMqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:46:49 -0400
Date: Thu, 11 Oct 2007 14:46:47 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Landley <rob@landley.net>, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
In-Reply-To: <20071011113931.GB8393@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0710111443530.3729@anakin>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710110923470.23818@anakin>
 <20071011113931.GB8393@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Sam Ravnborg wrote:
> On Thu, Oct 11, 2007 at 09:25:19AM +0200, Geert Uytterhoeven wrote:
> > On Wed, 10 Oct 2007, Rob Landley wrote:
> > > From: Rob Landley <rob@landley.net>
> > > 
> > > Rip out hardwired cross compiler name assumption that only m68k makes.
> > > 
> > > Signed-off-by: Rob Landley <rob@landley.net>
> > > ---
> > > When you cross compile, you have to set the prefix CROSS_COMPILE to your
> > > cross compiler prefix.  You need to do this for all targets (arm, mips, ppc,
> > > x86-64 on x86, etc).  This is not specific to m68k, and this value is
> > > supplied _to_ the build, not supplied _by_ the build.
> > > 
> > > The build shouldn't unconditionally overwrite the existing value of this
> > > variable with one it makes up.  It has no idea what I called my cross compiler.
> > 
> > The build does not unconditionally overwrite the existing value of this
> > variable. You can specify the name of your cross compiler like this:
> > 
> >     make CROSS_COMPILE=m68k-linux-
> > 
> > BTW, m68k-linux-gnu- is the default name for a m68k cross compiler.
> 
> For "make headers_install" this is not good.
> But I see there is confliting usages here.
> 1) current functionality makes it easy to build a cross compiled m68k
> 
> Btw. if you did:
> CROSS_COMPILE ?= m68k-linux-
> 
> then I could do:
> export CROSS_COMPILE=my-m68k-linux-
> make
> 
> and still get the expected result.

That won't work, cfr. http://lkml.org/lkml/2007/5/6/58.

> 2) suggested functionality makes it easy to do make headers_install

This is something completely different (cfr. the other thread handling
it). If `make headers_install' doesn't need the cross compiler, it
should not try to execute it.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
