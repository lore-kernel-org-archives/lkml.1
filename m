Return-Path: <linux-kernel-owner+w=401wt.eu-S1764241AbYJJUr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764241AbYJJUr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbYJJUrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:47:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55727 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757975AbYJJUrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:47:17 -0400
Date: Fri, 10 Oct 2008 22:47:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #1
Message-ID: <20081010204704.GA16362@elte.hu>
References: <20081009234705.GA20540@elte.hu> <alpine.LFD.2.00.0810100808540.3524@nehalem.linux-foundation.org> <20081010152631.GB26231@elte.hu> <20081010155830.GA4767@elte.hu> <19f34abd0810101339x66afc6d3mb6efa1a52e186816@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19f34abd0810101339x66afc6d3mb6efa1a52e186816@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Fri, Oct 10, 2008 at 5:58 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> > Ok, so I pulled phase 1, but quite frankly, I think this was utter
> >> > crap. Why the hell did this go in?
> >>
> >> we'll fix that up. We'll move all header files to
> >> arch/x86/include/asm/ anyway later in the merge window, once the dust
> >> settles, and can do a separate commit for this as well.
> >
> > we'll do the commit below once we've moved the header files to
> > arch/x86/include/asm/. (doing it right now would conflict with various
> > existing branches so it would be nice to wait with this.)
> >
> >        Ingo
> >
> > ---------------->
> > From 5f3a8db0d4b091521541153580454099618fec2c Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Fri, 10 Oct 2008 17:51:28 +0200
> > Subject: [PATCH] x86: fix header guard naming ugliness
> >
> > as Linus has noticed, the underscore aspect of these changes in
> > 77ef50a ("x86: consolidate header guards") are bogus:
> >
> > -#ifndef _ASM_BOOT_H
> > -#define _ASM_BOOT_H
> > +#ifndef ASM_X86__BOOT_H
> > +#define ASM_X86__BOOT_H
> >
> > as Linus pointed out:
> >
> > 1) header guard symbols are internal symbols in a reserved namespace,
> >   so a leading underscore is perfectly justified
> >
> > 2) user-space might accidentally stumble into the new symbols:
> >
> >        #include <sys/types.h>
> >
> >        int ASM_X86__TYPES_H = 1;
> >
> > plus this deviates from all the standard header guard naming we
> > use elsewhere in the kernel.
> 
> Note: If you don't want the double underscores anywhere, this patch is
> not enough.

yeah - it was just a simple sed job.

> For example:
> 
> > -#endif /* ASM_X86__MACH_DEFAULT__MACH_TIMER_H */
> > +#endif /* _ASM_X86_MACH_DEFAULT__MACH_TIMER_H */
> 
> There are also a few non-trivial changes, which could break with a 
> naïve sed script. So I suggest to simply revert it, it's a lot safer 
> than trying to patch it up in the last minute.
> 
> I'm obviously also sorry for causing this problem in the first 
> place... *blush*

it's not your fault really, you clearly suggested multiple variants and 
asked our opinion and we accepted that approach. So the buck stops here 
:)

	Ingo
