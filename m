Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0BGRCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 12:02:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60550 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab0BGRCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 12:02:13 -0500
Date: Sun, 7 Feb 2010 18:01:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, Frederic Weisbecker <fweisbec@gmail.com>,
       john smith <whalajam@yahoo.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Don Zickus <dzickus@redhat.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
 get to performance counters
Message-ID: <20100207170156.GB25893@elte.hu>
References: <20090925122556.2f8bd939@infradead.org>
 <20100205154748.GA11469@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205154748.GA11469@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Sep 25, 2009 at 12:25:56PM +0200, Arjan van de Ven wrote:
> > >From 5db5cd76f3c16c9f6093f54d1ccfb97d04b9a1ca Mon Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Fri, 25 Sep 2009 12:20:57 +0200
> > Subject: [PATCH] perf_core: provide a kernel-internal interface to get to performance counters
> 
> So this patch got accepted into mainline a while ago, without a user ever 
> beeing presented, nevermind actually included in mainline.  Time to revert 
> providing these useless exports and dead code?

You are quite wrong about that, this API is being relied on by the upstream 
hw-breakpoints subsystem:

  earth4:~/tip> git grep perf_event_release_kernel
  include/linux/perf_event.h:extern int perf_event_release_kernel(struct perf_event *event);
  kernel/hw_breakpoint.c: perf_event_release_kernel(bp);
  [...]

Furthermore beyond the use mentioned by Arjan there's a new patch-set posted 
to LKML that makes use of this new API as well: the generalized NMI watchdog 
feature posted by Don Zickus.

Thanks,

	Ingo
