Return-Path: <linux-kernel-owner+w=401wt.eu-S1762318AbXJYXfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318AbXJYXfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbXJYXfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:35:45 -0400
Received: from xenotime.net ([66.160.160.81]:41090 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754036AbXJYXfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:35:43 -0400
Date: Thu, 25 Oct 2007 16:35:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 3/6] x86: unification of i386 and x86_64 Kconfig.debug
Message-Id: <20071025163541.ee081c26.rdunlap@xenotime.net>
In-Reply-To: <86802c440710251630j71b9f750j2e0fbe4c9b37165e@mail.gmail.com>
References: <20071025195644.GA14501@uranus.ravnborg.org>
	<20071025200434.GD14501@uranus.ravnborg.org>
	<86802c440710251630j71b9f750j2e0fbe4c9b37165e@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 16:30:48 -0700 Yinghai Lu wrote:

> On 10/25/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > From 16b853f53463e43bfce341965ac10a78a3755a14 Mon Sep 17 00:00:00 2001
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > Date: Wed, 24 Oct 2007 15:50:43 -0700
> > Subject: [PATCH] x86: unification of i386 and x86_64 Kconfig.debug
> >
> > Adding proper dependencies so the two Kconfig.debug files
> > are now identical.
> >
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > ---
> >  arch/i386/Kconfig.debug             |   51 ++++++++++++++++++++++++++++-------
> >  arch/x86_64/Kconfig                 |    4 ---
> >  arch/{i386 => x86_64}/Kconfig.debug |   51 ++++++++++++++++++++++++++++-------
> >  3 files changed, 82 insertions(+), 24 deletions(-)
> >  copy arch/{i386 => x86_64}/Kconfig.debug (65%)
> >
> > diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
> > index f03531e..970b2de 100644
> > --- a/arch/i386/Kconfig.debug
> > +++ b/arch/i386/Kconfig.debug
> > @@ -1,14 +1,14 @@
> >  menu "Kernel hacking"
> >
> >  config TRACE_IRQFLAGS_SUPPORT
> > -       bool
> > -       default y
> > +       def_bool y
> >
> >  source "lib/Kconfig.debug"
> >
> >  config EARLY_PRINTK
> >         bool "Early printk" if EMBEDDED && DEBUG_KERNEL
> >         default y
> > +       depends on X86_32
> >         help
> >           Write kernel log output directly into the VGA buffer or to a serial
> >           port.
> > @@ -37,10 +37,12 @@ config DEBUG_STACK_USAGE
> ...
> > diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
> > index 308970a..1bc0268 100644
> > --- a/arch/x86_64/Kconfig
> > +++ b/arch/x86_64/Kconfig
> > @@ -97,10 +97,6 @@ config X86_CMPXCHG
> >         bool
> >         default y
> >
> > -config EARLY_PRINTK
> > -       bool
> > -       default y
> > -
> >  config GENERIC_ISA_DMA
> >         bool
> >         default y
> > diff --git a/arch/i386/Kconfig.debug b/arch/x86_64/Kconfig.debug
> > similarity index 65%
> > copy from arch/i386/Kconfig.debug
> > copy to arch/x86_64/Kconfig.debug
> > index f03531e..970b2de 100644
> > --- a/arch/i386/Kconfig.debug
> > +++ b/arch/x86_64/Kconfig.debug
> > @@ -1,14 +1,14 @@
> >  menu "Kernel hacking"
> >
> >  config TRACE_IRQFLAGS_SUPPORT
> > -       bool
> > -       default y
> > +       def_bool y
> >
> >  source "lib/Kconfig.debug"
> >
> >  config EARLY_PRINTK
> >         bool "Early printk" if EMBEDDED && DEBUG_KERNEL
> >         default y
> > +       depends on X86_32
> >         help
> >           Write kernel log output directly into the VGA buffer or to a serial
> >           port.
> ...
> 
> why disabling early_printk for x86_64?

It doesn't do that.  EARLY_PRINTK for x86_64 lives in
arch/x86_64/Kconfig (i.e., a different file).

Patches welcome.

---
~Randy
