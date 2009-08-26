Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbZHZJRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbZHZJRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbZHZJRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:17:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46361 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbZHZJRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:17:04 -0400
Date: Wed, 26 Aug 2009 11:16:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090826091642.GB7743@elte.hu>
References: <20090817124641.GA13354@in.ibm.com> <20090819161119.GA3633@in.ibm.com> <20090819173259.GF4972@nowhere> <20090820172719.GA16499@in.ibm.com> <20090821142811.GF11098@elte.hu> <20090826033637.GB6245@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826033637.GB6245@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Aug 21, 2009 at 04:28:11PM +0200, Ingo Molnar wrote:
> > 
> > * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> > 
> > > > Providing those would let us build a pmu struct on top of this 
> > > > high level API, hopefully.
> > 
> > Note that there's a PMU struct already in 
> > arch/x86/kernel/cpu/perf_counter.c. Could debug-register ops be 
> > tacked on to it?
> 
> No, we don't need to build an arch level pmu since the BP api 
> already handles the arch abstraction (or well, it is planned to).
> 
> Instead, what we need is a core pmu that relies on the BP api. 
> Such pmu will be allocated dynamically while creating a hardware 
> breakpoint counter.

i'm not convinced at all we need all that layering of 
perfcounters->pmu->BP. Why not add BP support to the PMU abstraction 
and be done with it?

That way we get hardware breakpoints via 'pinned, exclusive, per cpu 
hw-breakpoint counters' for example and kernel/hw-breakpoint.c can 
go away altogether.

kernel/perf_counter.c already handles scheduling, conflict 
resolution, enumeration, syscall exposure and more.

Hm?

	Ingo
