Return-Path: <linux-kernel-owner+w=401wt.eu-S1763862AbZEOM2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763862AbZEOM2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762700AbZEOMXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:23:15 -0400
Received: from relay3.sgi.com ([192.48.156.57]:40724 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762299AbZEOMXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:23:08 -0400
Date: Fri, 15 May 2009 07:23:08 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/2] sched, timers: simplify calc_load and avoid cpu
	iteration loop
Message-ID: <20090515122308.GA11465@sgi.com>
References: <20090514105915.973318588@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514105915.973318588@linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dimitri Sivanich <sivanich@sgi.com>

On Thu, May 14, 2009 at 11:21:14AM -0000, Thomas Gleixner wrote:
> Dimitri Sivanich pointed out that calc_load iterates over all online
> CPUs under xtime lock which can cause long latencies on large SMP
> systems.
> 
> The following patch series removes the iteration loop and lets
> scheduler_tick() on each CPU update the number of active tasks. The
> calc_load() function just uses this variable and updates avenrun from
> do_timer().
> 
> Dimitri, can you please test run this on one of your large machines ?
> 
> Thanks,
> 
> 	tglx
> 
