Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbZCZWfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbZCZWfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761274AbZCZWfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:35:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759414AbZCZWfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:35:21 -0400
Date: Thu, 26 Mar 2009 23:34:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -tip] x86: unification of module.c
Message-ID: <20090326223406.GB28755@elte.hu>
References: <1238072913.2507.3.camel@ht.satnam> <alpine.LFD.2.00.0903261835020.3397@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903261835020.3397@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 26 Mar 2009, Jaswinder Singh Rajput wrote:
> > This patch is based on -tip:x86/core:
> > 
> > From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Date: Thu, 26 Mar 2009 18:33:45 +0530
> > Subject: [PATCH] x86: unification of module.c
> > 
> > Impact: Unification, cleanup
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/kernel/Makefile    |    2 +-
> >  arch/x86/kernel/module.c    |  261 +++++++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/module_32.c |  152 -------------------------
> >  arch/x86/kernel/module_64.c |  194 --------------------------------
> >  4 files changed, 262 insertions(+), 347 deletions(-)
> >  create mode 100644 arch/x86/kernel/module.c
> >  delete mode 100644 arch/x86/kernel/module_32.c
> >  delete mode 100644 arch/x86/kernel/module_64.c
> 
> Sigh. We went through this before.
> 
> First make module_32 and module_64 the same if necessary in 
> several steps. The last step is to rename one of the files to 
> module.c and remove the other one.
> 
> This cobble all together approach is hard to review and error 
> prone.

Correct. There are countless examples of properly structured and 
well executed unifications in the arch/x86 tree.

The most recent one has been done by Gustavo F. Padovan - and this 
was one of this first complex contributions to Linux:

 c577b09: x86, fixmap: unify fixmap.h
 c78f322: x86, fixmap: prepare fixmap_32.h for unification
 e365bcd: x86, fixmap: prepare fixmap_64.h for unification
 5f403fa: x86, fixmap: add CONFIG_EFI
 2ae38da: x86, fixmap: add CONFIG_X86_{LOCAL,IO}_APIC
 fd862dd: x86, fixmap: define reserve_top_address for x86_64
 ab93e3c: x86, fixmap: define FIXADDR_BOOT_* and redefine FIX_ADDR_SIZE
 d09375a: x86, fixmap: rename __FIXADDR_SIZE and __FIXADDR_BOOT_SIZE

Please use this as a template - all-in-one patches for unifications 
are not reviewable, not testable and not acceptable.

	Ingo
