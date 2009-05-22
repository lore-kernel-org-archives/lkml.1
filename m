Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbZEVJ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbZEVJ4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZEVJ4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:56:24 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:33102 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZEVJ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:56:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18966.28834.891679.726583@cargo.ozlabs.ibm.com>
Date: Fri, 22 May 2009 19:30:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] perf_counter: dynamically allocate tasks'
 perf_counter_context struct [v2]
In-Reply-To: <1242979584.26820.616.camel@twins>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	<1242979584.26820.616.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> On Fri, 2009-05-22 at 14:17 +1000, Paul Mackerras wrote:
> > +               /*
> > +                * Make sure other cpus see correct values for *ctx
> > +                * once task->perf_counter_ctxp is visible to them.
> > +                */
> > +               smp_wmb();
> > +               tctx = cmpxchg(&task->perf_counter_ctxp, NULL, ctx);
> 
> 
> Documentation/memory-barriers.txt:
> 
> > Any atomic operation that modifies some state in memory and returns information
> > about the state (old or new) implies an SMP-conditional general memory barrier
> > (smp_mb()) on each side of the actual operation (with the exception of
> > explicit lock operations, described later).  These include:
> 
> >         cmpxchg();

OK, fair enough, I'll take it out.

Paul.
