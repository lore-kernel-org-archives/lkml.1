Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYDUGK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYDUGK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYDUGKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:10:48 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57846 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYDUGKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:10:48 -0400
Date: Mon, 21 Apr 2008 08:11:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stringify support commas
Message-ID: <20080421061118.GA12222@uranus.ravnborg.org>
References: <20080420183256.GA11350@Krystal> <20080420190631.GA6629@uranus.ravnborg.org> <20080420212124.GA18039@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080420212124.GA18039@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 05:21:24PM -0400, Mathieu Desnoyers wrote:
> * Sam Ravnborg (sam@ravnborg.org) wrote:
> > On Sun, Apr 20, 2008 at 02:32:56PM -0400, Mathieu Desnoyers wrote:
> > > #define MYDEF a, b, c
> > > 
> > > __stringify(MYDEF) should be replaced by "a, b, c", but compilation fails
> > > because the __stringify macro expects only one argument. Fix it by using
> > > variable macro arguments in __stringify and __stringify_1.
> > > 
> > > Needed in my current NMI safe iret paravirt support work so I can expand
> > > a macro containing assembly code into a string.
> > 
> > This is a no-no for those archs that still use -traditional.
> > I dunno if this is a problem for you at the moment and the
> > right fix is anyway to nuke -traditional.
> > 
> > 	Sam
> 
> A quick grep through arch/ gives me the following :
> 
> arch/cris/arch-v10/boot/compressed/Makefile
>         @$(CC) -D__ASSEMBLY__ -traditional -c $< -o $@
> arch/cris/arch-v10/boot/rescue/Makefile
> asflags-y += -traditional
> arch/cris/arch-v10/lib/Makefile
> EXTRA_AFLAGS := -traditional
> arch/h8300/boot/compressed/Makefile
> EXTRA_AFLAGS    := -traditional
> arch/m32r/boot/compressed/Makefile
> EXTRA_AFLAGS    := -traditional
> arch/m32r/kernel/Makefile
> EXTRA_AFLAGS    := -traditional
> arch/m68k/fpsp040/Makefile
> EXTRA_AFLAGS := -traditional
> arch/m68k/ifpsp060/Makefile
> EXTRA_AFLAGS := -traditional
> arch/m68k/kernel/Makefile
> EXTRA_AFLAGS := -traditional
> arch/m68k/lib/Makefile
> EXTRA_AFLAGS := -traditional
> arch/m68k/math-emu/Makefile
> EXTRA_AFLAGS := -traditional
> arch/parisc/kernel/Makefile
> AFLAGS_entry.o  := -traditional
> AFLAGS_pacache.o := -traditional
> arch/powerpc/boot/Makefile
> BOOTAFLAGS      := -D__ASSEMBLY__ $(BOOTCFLAGS) -traditional -nostdinc
> arch/s390/kernel/Makefile
> EXTRA_AFLAGS    := -traditional
> arch/s390/lib/Makefile
> EXTRA_AFLAGS := -traditional
> arch/s390/math-emu/Makefile
> EXTRA_AFLAGS := -traditional
> arch/sh/boot/compressed/Makefile_32
> EXTRA_AFLAGS    := -traditional
> arch/sh/boot/compressed/Makefile_64
> EXTRA_AFLAGS    := -traditional
> 
> Would their removal break something ?
I do not recall why they were added but removing -traditional from
x86 was painless.
So a simple approach would be to send a patch towards the arch maintainers.
But even better to try it out with a cross toolchain first.
Any breakage should be obvious.

	Sam
