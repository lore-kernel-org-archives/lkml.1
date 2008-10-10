Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYJJJRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYJJJRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJJJRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:17:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38781 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYJJJRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:17:34 -0400
Date: Fri, 10 Oct 2008 11:17:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched_clock: prevent scd->clock from moving backwards
Message-ID: <20081010091711.GA7805@elte.hu>
References: <48D959E8.4000303@goop.org> <1223470773.6336.13.camel@norville.austin.ibm.com> <1223470854.6336.15.camel@norville.austin.ibm.com> <1223507104.7382.6.camel@lappy.programming.kicks-ass.net> <20081009090605.GA21798@elte.hu> <20081009151703.GA8010@elte.hu> <1223574862.6407.16.camel@norville.austin.ibm.com> <1223576490.6394.3.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223576490.6394.3.camel@norville.austin.ibm.com>
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


* Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> On Thu, 2008-10-09 at 12:54 -0500, Dave Kleikamp wrote:
> 
> > I'll fix the patch and retest it before sending it again.
> 
> I'm definitely running with the new patch now.  Here goes:
>  -------------------------------------------------
> sched_clock: prevent scd->clock from moving backwards
> 
> When sched_clock_cpu() couples the clocks between two cpus, it may
> increment scd->clock beyond the GTOD tick window that __update_sched_clock()
> uses to clamp the clock.  A later call to __update_sched_clock() may move
> the clock back to scd->tick_gtod + TICK_NSEC, violating the clock's
> monotonic property.
> 
> This patch ensures that scd->clock will not be set backward.
> 
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/sched/clock, thanks Dave!

	Ingo
