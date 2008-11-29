Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbYK2SA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbYK2SA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 13:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYK2SAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 13:00:20 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:35143 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYK2SAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 13:00:20 -0500
Date: Sat, 29 Nov 2008 19:01:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-ID: <20081129180144.GA15533@uranus.ravnborg.org>
References: <200811290056.mAT0uTuk028924@terminus.zytor.com> <20081129164736.0b5a71db.h.mitake@gmail.com> <20081129093858.GC26691@elte.hu> <20081129192610.716a2d57.h.mitake@gmail.com> <20081129105229.GA9643@uranus.ravnborg.org> <20081129222449.e341f028.h.mitake@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129222449.e341f028.h.mitake@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 10:24:49PM +0900, Hitoshi Mitake wrote:
> On Sat, 29 Nov 2008 11:52:29 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > 
> > > But this is old way. ARCH_HAS_READQ and ARCH_HAS_WRITEQ are new ways
> > > to determine existence of readq/writeq. Drivers which use readq/writeq should
> > > depend on these values in their Kconfig file.
> > 
> > If we look at arch/x86/Kconfig we see:
> > ### Arch settings
> > config X86
> >         def_bool y
> >         select HAVE_AOUT if X86_32
> >         select HAVE_UNSTABLE_SCHED_CLOCK
> >         select HAVE_IDE
> >         select HAVE_OPROFILE
> >         select HAVE_IOREMAP_PROT
> >         select HAVE_KPROBES
> >         select ARCH_WANT_OPTIONAL_GPIOLIB
> > 	...
> > 
> > So the normal syntax here is "HAVE_XXX_XXX" - not ARCH_HAS_XXX_XXX
> > 
> > If you update your patch please use this syntax,
> > and locate the select under X86 - not under the 32/64 entries.
> 
> Thanks for your notification. I didn't notice that syntax rule.
> 
> > 
> > But I do not see why adding these in the first place.
> > 
> 
> Andrew Morton told that drivers which need readq/writeq should use ones of kernel,
> and if architecture part of kernel does not provide readq/writeq, drivers should be disabled.
> 
> This is Andrew's mail:
> http://marc.info/?l=linux-kernel&m=122625885124798&w=2
> ===> Quote:
> 
> #ifdef readq
> 
> Is a suitable way of determining whether the architecture implements
> readq and writeq.  It isn't pretty, but it will suffice.
> 
> A problem with it is that drivers will then do
> 
> #ifndef readq
> <provide a local implementation here>
> #endif
> 
> which rather sucks - we don't want lots of little private readq/writeq
> implementations all over the tree.
> 
> Perhaps it would be better to have a CONFIG_ARCH_HAS_READQ and to then
> disable these drivers on the architectures which don't provide
> readq/writeq support.
> 
> <====
I see both rationales and you combine them in your patch - OK.

And the reason why you cannot just add this to
include/linux/io.h is that not all architectures
provide a readl()/writel() I assume.

Feel free to add my Acked-by: to the patch.

	Sam
