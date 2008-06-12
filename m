Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbYFLHaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbYFLHaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 03:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYFLHaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 03:30:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbYFLHa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 03:30:29 -0400
Date: Thu, 12 Jun 2008 09:30:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.26-rc5-git2] WARNING: at kernel/lockdep.c:2658
	check_flags+0x4c/0x128()
Message-ID: <20080612073014.GA9402@elte.hu>
References: <5a4c581d0806111506m31412b21lee7bb851dabe6576@mail.gmail.com> <19f34abd0806112355v7330ccd4x41e66151f333c144@mail.gmail.com> <1213254306.31518.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213254306.31518.84.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2008-06-12 at 08:55 +0200, Vegard Nossum wrote:
> 
> 
> > From: Vegard Nossum <vegard.nossum@gmail.com>
> > Date: Thu, 12 Jun 2008 08:49:18 +0200
> > Subject: [PATCH] x86: more hardirq annotations for notify_die()
> > 
> > Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
> > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> > ---
> >  arch/x86/kernel/traps_32.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
> > index bde6f63..be9ecae 100644
> > --- a/arch/x86/kernel/traps_32.c
> > +++ b/arch/x86/kernel/traps_32.c
> > @@ -569,6 +569,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
> >  #define DO_VM86_ERROR(trapnr, signr, str, name)				\
> >  void do_##name(struct pt_regs *regs, long error_code)			\
> >  {									\
> > +	trace_hardirqs_fixup();						\
> >  	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
> >  						== NOTIFY_STOP)		\
> >  		return;							\
> 
> Yeah, I think this is ok, actual traps don't have any way of knowing the
> actual IRQ state afaik. So
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/x86/urgent - thanks.

Alessandro, does the patch from Vegard fix the ltrace warning for you?

	Ingo
