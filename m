Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbXL2IID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbXL2IID (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:08:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbXL2IHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:07:36 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57577 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbXL2IHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:07:35 -0500
Date: Sat, 29 Dec 2007 09:07:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Message-ID: <20071229080734.GA16931@uranus.ravnborg.org>
References: <20071228212341.GA6939@uranus.ravnborg.org> <200712290322.35471.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712290322.35471.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 03:22:35AM +0100, Andi Kleen wrote:
> On Friday 28 December 2007 22:23:41 Sam Ravnborg wrote:
> > - For 64 bit the sub architecture stuff is not used but structure
> >  is kept to make it easy to introduce.
> 
> I hope not. subarch is one of the main disaster areas in the i386 port.
The Makefile part looks reasonably ok - the implementation I have not looked at.

> 
> > +        # gcc doesn't support -march=core2 yet as of gcc 4.3, but I hope it
> > +        # will eventually. Use -mtune=generic as fallback
> 
> The comment is out of date, 4.3 has a -march=core2 now.
OK
 
> 
> > +        cflags-$(CONFIG_MCORE2) += \
> > +                $(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
> > +        cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
> > +        KBUILD_CFLAGS += $(cflags-y)
> > +
> > +        KBUILD_CFLAGS += -mno-red-zone
> > +        KBUILD_CFLAGS += -mcmodel=kernel
> > +
> > +        KBUILD_CFLAGS += -Wno-sign-compare
> 
> That one should be on for i386 too. It was a workaround for a gcc prelease
> that unfortunately was shipped in a suse release.
OK
> 
> > +        KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
> 
> And that too should be on for i386 too.
OK
> 
> > +        ifneq ($(CONFIG_DEBUG_INFO),y)
> > +                # -fweb shrinks the kernel a bit, but the difference is very small
> > +                # it also messes up debugging, so don't use it for now.
> > +                #KBUILD_CFLAGS += $(call cc-option,-fweb)
> > +        endif
> 
> Can be dropped completely now.
OK - I was tempted to do so as it is a noop anyway.

> 
> > +        # -funit-at-a-time shrinks the kernel .text considerably
> > +        # unfortunately it makes reading oopses harder.
> > +        KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)
> 
> Should be on for i386 too (see other mail)
OK
> > +
> > +        # prevent gcc from generating any FP code by mistake
> > +        KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
> 
> Should be on for i386 too (in fact i thought it was already, surprised) 
OK
> 
> > +        # this works around some issues with generating unwind tables in older gccs
> > +        # newer gccs do it by default
> > +        KBUILD_CFLAGS += -maccumulate-outgoing-args
> 
> That is only needed for the unwinder; I readd it on i386 too in the out of tree
> unwinder patch. Strictly without it it's not needed, although it can be useful
> for kgdb or fireproxy or crash for the gdb unwinder. But that applies to i386 too.
> So probably it should be either dropped on both or readded to i386. I would
> be for readding. iirc it was dropped because it increased code size slightly,
> but code size is not everything. debuggability is more important.

Thanks for the feedback Andi.
I will prepare a small patch serie so we have the additional options applied for
i386 in individual patches and the original patch will only be slightly updated.

	Sam
