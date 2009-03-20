Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbZCTTeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbZCTTeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759128AbZCTTeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:34:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37813 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZCTTeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:34:00 -0400
Date: Fri, 20 Mar 2009 20:33:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
Message-ID: <20090320193334.GA19501@elte.hu>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain> <20090320092234.GA3792@elte.hu> <alpine.LFD.2.00.0903201127360.29264@localhost.localdomain> <20090320185917.GB6224@elte.hu> <alpine.LFD.2.00.0903202010250.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903202010250.29264@localhost.localdomain>
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

> On Fri, 20 Mar 2009, Ingo Molnar wrote:
> > 
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Fri, 20 Mar 2009, Ingo Molnar wrote:
> > > > > ---
> > > > >  scripts/Kbuild.include |    5 +++--
> > > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > > 
> > > > Doesnt fully work:
> > > > 
> > > > arch/x86/kernel/entry_32.S:346: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > > arch/x86/kernel/entry_32.S:394: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > > arch/x86/kernel/entry_32.S:519: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > > arch/x86/kernel/entry_32.S:614: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > > arch/x86/kernel/entry_32.S:685: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > > arch/x86/kernel/entry_32.S:754: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > > 
> > > > config attached. Distcc driven build.
> > > 
> > > Same config works fine here. Do you have different 
> > > compilers/binutils on your distcc cluster ? I tripped over this 
> > > distcc feature in the past, that's why I have switched to iceccc.
> > 
> > the distcc binutils is different from the host build environment 
> > binutils and compiler. This always worked fine - can we preserve 
> > it?
> 
> It depends what you define as "worked fine".

as in "did not fail the build" :-)

> The point is that the CFI checks are done at compile time by 
> checking binutils. If you have two versions - one with and one 
> without CFI support - then it's just a question of luck which one 
> is checked. So in your case it might have worked because both 
> distcc and your local gcc agreed that CFI is not enabled, but the 
> reason why the distcc check for CFI fails is because it fails to 
> handle the stdin input and not because it does not support CFI.
> 
> So with my patch distcc gives you the correct answer, but now you 
> trip over the local binutils lack of CFI support.
> 
> I don't think that such a setup is something we need to preserve.

i dont do anything weird. i use:

CROSS_COMPILE='distcc 
/opt/crosstool/gcc-4.2.2-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-unknown-linux-gnu-'

host compiler was never supposed to be the same in terms of 
capability as target compiler.

	Ingo
