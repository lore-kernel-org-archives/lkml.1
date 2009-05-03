Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbZECSbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbZECSbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 14:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZECSbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 14:31:06 -0400
Received: from 1wt.eu ([62.212.114.60]:4252 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbZECSbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 14:31:05 -0400
Date: Sun, 3 May 2009 20:30:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090503183038.GA8571@1wt.eu>
References: <200904301408.09370.tobias.doerffel@gmail.com> <20090430154051.GA3346@elte.hu> <49F9DB70.2050906@zytor.com> <20090503053821.GI570@1wt.eu> <20090503075346.63fc7211@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503075346.63fc7211@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 07:53:46AM -0700, Arjan van de Ven wrote:
> On Sun, 3 May 2009 07:38:23 +0200
> Willy Tarreau <w@1wt.eu> wrote:
> 
> > On Thu, Apr 30, 2009 at 10:10:08AM -0700, H. Peter Anvin wrote:
> > > Ingo Molnar wrote:
> > > >> diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
> > > >> index 80177ec..07a11b0 100644
> > > >> --- a/arch/x86/Makefile_32.cpu
> > > >> +++ b/arch/x86/Makefile_32.cpu
> > > >> @@ -33,6 +33,7 @@ cflags-$(CONFIG_MCYRIXIII)	+= $(call
> > > >> cc-option,-march=c3,-march=i486) $(align)-f
> > > >> cflags-$(CONFIG_MVIAC3_2)	+= $(call
> > > >> cc-option,-march=c3-2,-march=i686)
> > > >> cflags-$(CONFIG_MVIAC7)		+= -march=i686
> > > >> cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call
> > > >> tune,core2) +cflags-$(CONFIG_MATOM)		+=
> > > >> -march=atom $(call tune,atom) 
> > > 
> > > There should be a fallback option used here rather than requiring a
> > > new gcc, e.g. something like:
> > > 
> > > $(call cc-option,-march=atom,-march=i686)
> > 
> > if it's an in-order architecture, wouldn't it be better to tune for
> > i386 or i486 instead ?
> 
> -march isn't about tuning, it's about supported instructions.

agreed, but unless specified otherwise using -mtune, -march also sets
default tuning for the indicated CPU. At least in my experience.

> The right line is
> $(call cc-option,-march=atom,-march=core2)

OK thanks.

> For tuning, our experience is that currently -mtune=generic works best.

OK.

> Not sure about the gcc's that have complete atom tuning support yet.
> 
> Please don't do something like "oh it's in order, so was the Pentium,
> so lets use that"; it actually gives really really bad results.

I know, I was not thinking about tuning for an "advanced" CPU such as the
pentium, but rather for something generic, hence my proposal of i486 or
i386. I did not know about the "generic" target. In my experience, tuning
for i386/i486 often shows best overall performance on recent CPUs such as
core2. I should try "generic" to compare.

Regards,
Willy

