Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYFZMC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYFZMC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYFZMCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:02:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44413 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbYFZMCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:02:17 -0400
Date: Thu, 26 Jun 2008 14:02:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080626120202.GH29619@elte.hu>
References: <20080610214544.GA14824@damson.getinternet.no> <20080618103006.GF15255@elte.hu> <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Wed, Jun 18, 2008 at 12:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> >> PS: I now have a pretty cool framework in Perl for parsing and
> >> checking headers. And it can be used to transform them automatically
> >> too. So if you want to standardize the guard format of all the headers
> >> in one go, we have the means to do it quickly and efficiently...
> >
> > very nice! I think the reference should be something like the unified
> > include/asm-x86/processor.h.
> >
> > could you try a run with that and put the result into a git tree for me
> > to pull for review? I think we want to finetune that result and do a
> > flag day for those cleanups, right after all the x86 topics went into
> > v2.6.27.
> 
> Done! You can pull the 'for-x86' branch of
> 
>     git pull git://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-2.6-headers.git
> for-x86
> 
> (that's gonna wrap.) The first commit
> (d160e5c4f1b912ec7c1583c393bb3db66cdb63c2) is the interesting one, the
> rest are just manual fix-ups.
> 
> I've looked over most of it to make sure everything's okay; in
> addition, the diff consists of change in preprocessor lines only.
> 'make headers_check' also succeeds, although no change here should
> change the result of that.
> 
> 
> The headers that still need to be looked at manually (probably because
> there was no guard there in the first place), are:
> 
> # add include/asm-x86/mach-visws/entry_arch.h
> # add include/asm-x86/mach-visws/setup_arch.h
> # add include/asm-x86/mach-visws/smpboot_hooks.h
> # add include/asm-x86/posix_types.h
> # add include/asm-x86/mach-default/pci-functions.h
> # add include/asm-x86/mach-default/entry_arch.h
> # add include/asm-x86/mach-default/do_timer.h
> # add include/asm-x86/mach-default/smpboot_hooks.h
> # add include/asm-x86/vic.h
> # add include/asm-x86/suspend_32.h
> # add include/asm-x86/calling.h
> # add include/asm-x86/alternative-asm.h
> # add include/asm-x86/processor-cyrix.h
> # add include/asm-x86/mach-voyager/entry_arch.h
> # add include/asm-x86/mach-voyager/do_timer.h
> # add include/asm-x86/mach-voyager/setup_arch.h
> # add include/asm-x86/mach-rdc321x/rdc321x_defs.h
> # add include/asm-x86/unistd.h
> # add include/asm-x86/irqflags.h
> # add include/asm-x86/vmi.h
> # add include/asm-x86/voyager.h
> # add include/asm-x86/frame.h
> 
> Vegard (a.k.a. "The Churninator")

thanks Vegard, these changes are looking rather good. I've created a 
tip/x86/header-guards topic for it and did a test-merge. There were 30+ 
trivial conflicts with tip/master that were easy to fix - find the list 
of conflicting files below.

Lets keep these changes out of tip/master for now though, to reduce the 
churn - i'll do a merge/rebase in the v2.6.27-rc1 timeframe, ok?

or perhaps we could include it in tip/master right now as well, if you 
did another branch that excluded the files below. That would make 
merging a lot easier - and we could do a second phase in v2.6.27-rc1. 
Hm?

	Ingo

-------------------->
commit c4f439ec18082153bcff1bd6e4550dbad5ff5cbc
Merge: efd27e7... 391ebbd...
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jun 26 13:55:09 2008 +0200

    Merge branch 'x86/header-guards'
    
    Conflicts:
    
    	include/asm-x86/bios_ebda.h
    	include/asm-x86/bootparam.h
    	include/asm-x86/current_32.h
    	include/asm-x86/current_64.h
    	include/asm-x86/ds.h
    	include/asm-x86/e820_32.h
    	include/asm-x86/e820_64.h
    	include/asm-x86/fixmap.h
    	include/asm-x86/fixmap_64.h
    	include/asm-x86/gart.h
    	include/asm-x86/genapic_64.h
    	include/asm-x86/hw_irq_32.h
    	include/asm-x86/hw_irq_64.h
    	include/asm-x86/i8259.h
    	include/asm-x86/irq_32.h
    	include/asm-x86/irq_64.h
    	include/asm-x86/kdebug.h
    	include/asm-x86/mach-bigsmp/mach_mpspec.h
    	include/asm-x86/mach-default/irq_vectors.h
    	include/asm-x86/mach-default/irq_vectors_limits.h
    	include/asm-x86/mach-es7000/mach_mpspec.h
    	include/asm-x86/mach-numaq/mach_mpspec.h
    	include/asm-x86/mach-summit/mach_mpspec.h
    	include/asm-x86/mach-visws/irq_vectors.h
    	include/asm-x86/mach-voyager/irq_vectors.h
    	include/asm-x86/pat.h
    	include/asm-x86/percpu.h
    	include/asm-x86/processor-flags.h
    	include/asm-x86/seccomp_32.h
    	include/asm-x86/seccomp_64.h
    	include/asm-x86/thread_info.h
    	include/asm-x86/thread_info_32.h
    	include/asm-x86/thread_info_64.h
    	include/asm-x86/topology.h
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
