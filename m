Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0BHHo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:44:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44018 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab0BHHo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:44:56 -0500
Date: Mon, 8 Feb 2010 08:44:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH] perf_events: Fix FORK events
Message-ID: <20100208074438.GC24721@elte.hu>
References: <1265384243.30057.42.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265384243.30057.42.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Hi,
> 
> While looking into a problem reported by Pekka, I noticed that I wasn't
> receiving any FORK events for a workload that did fork (see attachment).

ah yes, my old testcase for forks.

> After making the below change, stuff started working again, thing is, I'm 
> not sure why.

In case it matters: that workload of 4x fork (and the whole fork events 
mechanism) was always very sensitive to the precise timing of when a child 
and a parent does what, in the final dance of wait(), do_exit(), 
release_task(), etc. when a task exits. Especially on SMP systems.

> The main change is sending the FORK event to the parent instead of the 
> child thread, however perf_event_fork() is at the end of copy_process(), 
> which is after perf_event_init_task() which inherits all the counters, so 
> it should all have worked as it was.
> 
> We could of course just slam the commit in and not worry about it, but
> that just doesn't feel right.

Would be nice to figure it out ...

	Ingo
