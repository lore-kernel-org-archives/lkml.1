Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYH1QRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYH1QRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYH1QRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:17:32 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44812 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYH1QRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:17:31 -0400
Date: Thu, 28 Aug 2008 19:16:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080828161632.GA13609@cs181140183.pp.htv.fi>
References: <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org> <20080826232411.GC11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261648140.3363@nehalem.linux-foundation.org> <20080827002316.GE11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261726560.3363@nehalem.linux-foundation.org> <20080827115829.GF11734@cs181140183.pp.htv.fi> <20080827160052.GA15968@linux-sh.org> <20080827173544.GH11734@cs181140183.pp.htv.fi> <20080828003211.GA18893@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080828003211.GA18893@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 09:32:13AM +0900, Paul Mundt wrote:
> On Wed, Aug 27, 2008 at 08:35:44PM +0300, Adrian Bunk wrote:
> > On Thu, Aug 28, 2008 at 01:00:52AM +0900, Paul Mundt wrote:
> > > On Wed, Aug 27, 2008 at 02:58:30PM +0300, Adrian Bunk wrote:
> > > In addition to that, debugging the runaway stack users on 4k tends to be
> > > easier anyways since you end up blowing the stack a lot sooner. On sh
> > > we've had pretty good luck with it, though most of our users are using
> > > fairly deterministic workloads and continually profiling the footprint.
> > > Anything that runs away or uses an insane amount of stack space needs to
> > > be fixed well before that anyways, so catching it sooner is always
> > > preferable. I imagine the same case is true for m68knommu (even sans IRQ
> > > stacks).
> > 
> > CONFIG_DEBUG_STACKOVERFLOW should give you the same information, and if
> > wanted with an arbitrary limit.
> > 
> In some cases, yes. In the CONFIG_DEBUG_STACKOVERFLOW case the check is
> only performed from do_IRQ(), which is sporadic at best, especially on
> tickless. While it catches some things, it's not a complete solution in
> and of iteslf.
> 
> In addition to this, there are even fewer platforms that support it than
> there are platforms that do 4k stacks. At first glance, it looks like
> it's only m32r, powerpc, sh, x86, and xtensa.
>...

As far as I can see the only architectures that optionally offer 4kB 
stacks today are m68knommu, s390, sh and x86.

Did I miss some architectures or is 5 < 4 ;) ?

> Others support the Kconfig
> option, but don't seem to realize that it's not an option that the kernel
> does anything with by itself, and so don't actually do anything (ie,
> FRV).

Unless I miss anything these "others" include only FRV.

> > IMHO there seems to currently be a mismatch between it's maintainance 
> > cost and the actual number of users. That's in my opinion the main 
> > problem with it, no matter in which direction it gets resolved.
> > 
> Perhaps that's true on x86, but in general I take issue with that. On sh
> we've had to do very little maintenance for it and most shipping products
> are using it today (at least on MMU-Linux, we don't bother with it on
> nommu). Most of the problems we ran in to with 4k stacks tended to be
> stuff that we wanted to fix for 8k anyways. I suspect that this case is
> true for the other embedded platforms also.
>...

Most stack issues are not platform or architecture specific.

The maintainance effort therefore mostly depends on whether a non-zero 
number of architectures uses 4kB stacks.

And if something is considered to be important for small embedded 
systems, but not supported on ARM, MIPS or PowerPC, then that's 
a bit strange.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

