Return-Path: <linux-kernel-owner+w=401wt.eu-S1030369AbXDJGYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030369AbXDJGYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 02:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030410AbXDJGYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 02:24:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030369AbXDJGYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 02:24:36 -0400
Date: Tue, 10 Apr 2007 08:24:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: align rq to cacheline boundary
Message-ID: <20070410062421.GA23274@elte.hu>
References: <20070409180853.GC3948@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409180853.GC3948@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> Align the per cpu runqueue to the cacheline boundary. This will 
> minimize the number of cachelines touched during remote wakeup.

> -static DEFINE_PER_CPU(struct rq, runqueues);
> +static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;

ouch!! Now how did _that_ slip through. The runqueues had been 
cacheline-aligned for ages. Or at least, they were supposed to be.

could you see any improvement in profiles or workloads with this patch 
applied? (just curious - it's an obviously right fix)

> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
