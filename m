Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZKLLed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZKLLed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZKLLed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:34:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbZKLLec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:34:32 -0500
Date: Thu, 12 Nov 2009 12:34:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: fix/add missing update_rq_clock() calls
Message-ID: <20091112113429.GA7440@elte.hu>
References: <1258020464.6491.2.camel@marge.simson.net>
 <1258023705.4039.103.camel@laptop>
 <20091112112734.GE24684@elte.hu>
 <1258025363.4039.104.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258025363.4039.104.camel@laptop>
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

> On Thu, 2009-11-12 at 12:27 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Thu, 2009-11-12 at 11:07 +0100, Mike Galbraith wrote:
> > > > sched: fix/add missing update_rq_clock() calls.
> > > > 
> > > > kthread_bind(), migrate_task() and sched_fork were missing updates, and
> > > > try_to_wake_up() was updating after having already used the stale clock.
> > > 
> > > 
> > > I'm almost at the point where I think we should ditch rq->clock 
> > > alltogether and simply call cpu_clock() directly when we need it. This 
> > > trying to optimize and avoid calling it game has brought way too many 
> > > head-aches.
> > 
> > It's not just about optimization - it's also accounting precision - we 
> > want to handle the full act of schedule() at a single timestamp - not a 
> > series of timestamps.
> > 
> > But ... we can get rid of it if it can be done sanely.
> 
> Ah, good point, hard to do for the migration paths though.

yes, migration is always the odd one out anyway, unless the hardware 
does cross-CPU-synchronous timestamps.

	Ingo
