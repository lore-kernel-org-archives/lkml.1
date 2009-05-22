Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZEVIGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZEVIGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZEVIG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:06:26 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:28842 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbZEVIGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:06:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/2] perf_counter: dynamically allocate tasks'
 perf_counter_context struct [v2]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 22 May 2009 10:06:24 +0200
Message-Id: <1242979584.26820.616.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 14:17 +1000, Paul Mackerras wrote:
> +               /*
> +                * Make sure other cpus see correct values for *ctx
> +                * once task->perf_counter_ctxp is visible to them.
> +                */
> +               smp_wmb();
> +               tctx = cmpxchg(&task->perf_counter_ctxp, NULL, ctx);


Documentation/memory-barriers.txt:

> Any atomic operation that modifies some state in memory and returns information
> about the state (old or new) implies an SMP-conditional general memory barrier
> (smp_mb()) on each side of the actual operation (with the exception of
> explicit lock operations, described later).  These include:

>         cmpxchg();




