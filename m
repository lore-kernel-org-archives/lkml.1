Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZENRXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZENRXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZENRX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:23:28 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48250 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752468AbZENRX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:23:28 -0400
Date: Thu, 14 May 2009 12:23:28 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/2] sched, timers: simplify calc_load and avoid cpu
	iteration loop
Message-ID: <20090514172328.GA25691@sgi.com>
References: <20090514105915.973318588@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514105915.973318588@linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran this patchset on a 64p ia64 machine and latency-wise it looks good.  I can't really speak for the loadavg calculation.

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
