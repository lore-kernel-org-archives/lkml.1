Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbZCTTcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbZCTTcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZCTTch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:32:37 -0400
Received: from www.tglx.de ([62.245.132.106]:46521 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZCTTch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:32:37 -0400
Date: Fri, 20 Mar 2009 20:31:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] kbuild: work around distcc/icecc madness
In-Reply-To: <20090320185917.GB6224@elte.hu>
Message-ID: <alpine.LFD.2.00.0903202010250.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain> <20090320092234.GA3792@elte.hu> <alpine.LFD.2.00.0903201127360.29264@localhost.localdomain> <20090320185917.GB6224@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Ingo Molnar wrote:
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Fri, 20 Mar 2009, Ingo Molnar wrote:
> > > > ---
> > > >  scripts/Kbuild.include |    5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > Doesnt fully work:
> > > 
> > > arch/x86/kernel/entry_32.S:346: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > arch/x86/kernel/entry_32.S:394: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > arch/x86/kernel/entry_32.S:519: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > arch/x86/kernel/entry_32.S:614: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > arch/x86/kernel/entry_32.S:685: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > arch/x86/kernel/entry_32.S:754: Error: unknown pseudo-op: `.cfi_signal_frame'
> > > 
> > > config attached. Distcc driven build.
> > 
> > Same config works fine here. Do you have different 
> > compilers/binutils on your distcc cluster ? I tripped over this 
> > distcc feature in the past, that's why I have switched to iceccc.
> 
> the distcc binutils is different from the host build environment 
> binutils and compiler. This always worked fine - can we preserve it?

It depends what you define as "worked fine".

The point is that the CFI checks are done at compile time by checking
binutils. If you have two versions - one with and one without CFI
support - then it's just a question of luck which one is checked. So
in your case it might have worked because both distcc and your local
gcc agreed that CFI is not enabled, but the reason why the distcc
check for CFI fails is because it fails to handle the stdin input and
not because it does not support CFI.

So with my patch distcc gives you the correct answer, but now you trip
over the local binutils lack of CFI support.

I don't think that such a setup is something we need to preserve.

Thanks,

	tglx
