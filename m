Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYJIJH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYJIJH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 05:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYJIJHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 05:07:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52749 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbYJIJHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 05:07:15 -0400
Date: Thu, 9 Oct 2008 11:06:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched_clock: prevent scd->clock from moving backwards
Message-ID: <20081009090605.GA21798@elte.hu>
References: <48D959E8.4000303@goop.org> <1223470773.6336.13.camel@norville.austin.ibm.com> <1223470854.6336.15.camel@norville.austin.ibm.com> <1223507104.7382.6.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223507104.7382.6.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2008-10-08 at 08:00 -0500, Dave Kleikamp wrote:
> > sched_clock: prevent scd->clock from moving backwards
> > 
> > When sched_clock_cpu() couples the clocks between two cpus, it may
> > increment scd->clock beyond the GTOD tick window that __update_sched_clock()
> > uses to clamp the clock.  A later call to __update_sched_clock() may move
> > the clock back to scd->tick_gtod + TICK_NSEC, violating the clock's
> > monotonic property.
> > 
> > This patch ensures that scd->clock will not be set backward.
> 
> Ah, yes indeed, this comes from the tick not happening at the same time
> on different cpus, so if we use a local timestamp to move a remote clock
> forward, this scenario could indeed happen.
> 
> The fix looks good to me, good catch, thanks shaggy!
> 
> A related 'fix' which I'm still not quite sure about is making the
> window 'tick_gtod + 2*TICK_NSEC'. That increases the max observed
> difference to 4 jiffies, but allows ticks to be 'late' a bit without
> first holding back time and then jumping ahead again.
> 
> > Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/sched/core, thanks!

	Ingo
