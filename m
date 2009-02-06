Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZBFPTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZBFPTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbZBFPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:18:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58756 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbZBFPSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:18:48 -0500
Date: Fri, 6 Feb 2009 16:18:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
       oleg@redhat.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, ming.m.lin@intel.com
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
Message-ID: <20090206151832.GL18368@elte.hu>
References: <20090205112414.104100700@chello.nl> <20090205120608.GB8799@elte.hu> <1233895919.2604.323.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233895919.2604.323.camel@ymzhang>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> On Thu, 2009-02-05 at 13:06 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > This should hopefully address all the itimer borkage.
> > 
> > Applied to tip:timers/urgent, thanks Peter!
> > 
> > Yanmin: could you check hacbench_pth with latest tip/master, do
> > these fixes resolve that 3% regression you reported?
>
> Lin Ming tested it and hackbench_pth/volanoMark regression all disappear. 
> But oltp has a regression. We think oltp new regression isn't related to 
> the patch. Ming is investigating it.

Potential suspects for oltp regression would be:

 3d39870: sched_rt: don't use first_cpu on cpumask created with cpumask_and
 a571bbe: sched: fix buddie group latency
 a9f3e2b: sched: clear buddies more aggressively
 1596e29: sched: symmetric sync vs avg_overlap
 d942fb6: sched: fix sync wakeups

	Ingo
