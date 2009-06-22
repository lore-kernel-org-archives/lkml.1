Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbZFVLzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbZFVLzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZFVLyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:54:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51952 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZFVLyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:54:51 -0400
Date: Mon, 22 Jun 2009 13:54:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.8 - Generalized cache events
Message-ID: <20090622115433.GI24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
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

> 8/ Generalized cache events
>
>  In recent days, you have added support for what you call
> 'generalized cache events'.
>
>  The log defines:
> new event type: PERF_TYPE_HW_CACHE
>
>  This is a 3-dimensional space:
>  { L1-D, L1-I, L2, ITLB, DTLB, BPU } x
>  { load, store, prefetch } x
>  { accesses, misses }
>
> Those generic events are then mapped by the kernel onto actual PMU
> events if possible.
>
> I don't see any justification for adding this and especially in
> the kernel.
>
> What's the motivation and goal of this?
>
> If you define generic events, you need to provide a clear
> definition of what they are actually measuring. This is especially
> true for caches because there are many cache events and many
> different behaviors.
>
> If the goal is to make comparisons easier. I believe this is
> doomed to fail. Because different caches behave differently,
> events capture different subtle things, e.g, HW prefetch vs. sw
> prefetch. If to actually understand what the generic event is
> counting I need to know the mapping, then this whole feature is
> useless.

[ we since renamed L2 to LL ]

I beg to differ, subtle differences don't matter for big picture
performance indications.

If you measure significant last level cache misses by any metric,
you know you're hosed. Any work done to reduce this metric will
improve your workload.

Why do I need to care for the exact details of the event to make
valid use of this?

Sure, some people might be interested, and yes there are certainly
cases where you do want all detail available, but this interface
does not prohibit that usage - you can still use the full raw
spectrum of events, thousands of them if you so wish, easily
accessed both via the syscall and via the tools.

This categorization we added merely enables a somewhat simpler high
level view (that tries to be CPU model invariant) that suffices for
a lot of things.
