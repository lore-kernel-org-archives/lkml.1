Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbYABLBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbYABLBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYABLBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:01:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40160 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbYABLBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:01:32 -0500
Subject: Re: 2.6.24-rc6-mm1
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200801022131.15482.nickpiggin@yahoo.com.au>
References: <9DtBq-2jD-3@gated-at.bofh.it>
	 <20071224012524.GA21843@gondor.apana.org.au>
	 <20071230131018.GC16946@elte.hu>
	 <200801022131.15482.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 12:01:16 +0100
Message-Id: <1199271676.6821.112.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-02 at 21:31 +1100, Nick Piggin wrote:
> On Monday 31 December 2007 00:10, Ingo Molnar wrote:
> > * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > > Ingo, it's not good that we have cond_resched() definitions
> > > > conditionally duplicated in kernel.h - that's increasing the risk of
> > > > bugs like this one.
> > >
> > > Actually, why do we even have cond_resched when real preemption is on?
> > > It seems to be a waste of space and time.
> >
> > due to the BKL. cond_resched() in BKL code breaks up BKL latencies.
> >
> > i dont mind not doing that though - we should increase the pain for BKL
> > users, so that subsystems finally get rid of it altogether.
> > lock_kernel() use within the kernel is still rampant - there are still
> > more than 400 callsites to lock_kernel().
> 
> It would be silly to potentially increase latency in some areas
> for CONFIG_PREEMPT kernels, though.
> 
> Better may be to detect when there is CONFIG_PREEMPT and
> CONFIG_PREEMPT_BKL, and ifdef away the cond_resched in that case
> (or -- why do we even make CONFIG_PREEMPT_BKL an option? Are there
> really workloads left where it causes throughput regressions?)

I've seen 1s+ desktop latencies due to PREEMPT_BKL when I was still
using reiserfs.

Both reiserfs and tty were fighting for the bkl and massive prio
inversion ensued. Turning PREEMPT_BKL off made the system usable again.

