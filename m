Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYHSAqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYHSAqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYHSAp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:45:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34231 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbYHSAp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:45:58 -0400
Date: Tue, 19 Aug 2008 02:45:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
	to use function calls [POST 2]
Message-ID: <20080819004531.GI9914@elte.hu>
References: <patchbomb.1219083817@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1219083817@localhost>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> This series:
>  - adds a simple debugfs profiling entry for cross-cpu tlb flushes
>  - converts them to using smp_call_function_mask
>  - unifies 32 and 64-bit tlb flushes
>  - converts smp_call_function to using multiple queues (using the now
>    freed vectors)
>  - allows config-time adjustment of the number of queues
>  - adds a kernel parameter to disable multi-queue in case it causes
>    problems
> 
> The main concern is whether using smp_call_function adds an 
> unacceptible performance hit to cross-cpu tlb flushes.  My limited 
> measurements show a ~35% regression in latency for a particular flush; 
> it would be interesting to try this on a wider range of hardware.  I 
> gather the effect tlb flush performance is very application specific 
> as well, but I'm not sure what benchmarks show what effects.
> 
> Trading off agains the latency of a given flush, the smp_function_call 
> mechanism allows multiple requests to be queued, and so may improve 
> throughput on a system-wide basis.
> 
> So, I'd like people to try this out and see what performance effects 
> it has.

nice stuff!

I suspect the extra cost might be worth it for two reasons: 1) we could 
optimize the cross-call implementation further 2) on systems where TLB 
flushes actually matter, the ability to overlap multiple TLB flushes to 
the same single CPU might improve workloads.

FYI, i've created a new -tip topic for your patches, tip/x86/tlbflush. 
It's based on tip/irq/sparseirq (there are a good deal of dependencies 
with that topic).

It would be nice to see some numbers on sufficiently SMP systems, using 
some mmap/munmap intense workload.

	Ingo
