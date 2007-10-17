Return-Path: <linux-kernel-owner+w=401wt.eu-S1761720AbXJQHU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761720AbXJQHU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 03:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbXJQHUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 03:20:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58245 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbXJQHUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 03:20:19 -0400
Date: Wed, 17 Oct 2007 09:20:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: fix improper load balance across sched domain
Message-ID: <20071017072003.GA18044@elte.hu>
References: <b040c32a0710161207s4d6d4d4cq1fa7f0dd1a7f017d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0710161207s4d6d4d4cq1fa7f0dd1a7f017d@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0200]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> We recently discovered a nasty performance bug in the kernel CPU load 
> balancer where we were hit by 50% performance regression.
> 
> When tasks are assigned to a subset of CPUs that span across 
> sched_domains (either ccNUMA node or the new multi-core domain) via 
> cpu affinity, kernel fails to perform proper load balance at these 
> domains, due to several logic in find_busiest_group() miss identified 
> busiest sched group within a given domain. This leads to inadequate 
> load balance and causes 50% performance hit.
[...]
> So proposing the following fix: add addition logic in 
> find_busiest_group to detect intrinsic imbalance within the busiest 
> group.  When such condition is detected, load balance goes into spread 
> mode instead of default grouping mode.

thanks - i've added your fix to the scheduler queue, and i'll check it 
with a few workloads too. (Right now the scheduler queue is blocked by a 
showstopper crasher bug in group scheduling and we are trying to fix 
that first, before doing any other change.)

	Ingo
