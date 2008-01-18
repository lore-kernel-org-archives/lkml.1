Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYARK4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYARK4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYARK4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:56:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbYARK4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:56:02 -0500
Date: Fri, 18 Jan 2008 11:55:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Colin Fowler <elethiomel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Performance loss 2.6.22->22.6.23->2.6.24-rc7 on CPU intensive
	benchmark on 8 Core Xeon
Message-ID: <20080118105545.GC12228@elte.hu>
References: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com> <20080114185520.GA26540@elte.hu> <cf3edd8d0801141442nedf4ac1p6b1fd6bc94900063@mail.gmail.com> <cf3edd8d0801150901p653edeear62d5bc91d9f46981@mail.gmail.com> <20080115220641.GC2665@elte.hu> <cf3edd8d0801160934u2e39110dv2ccc98081e983b25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf3edd8d0801160934u2e39110dv2ccc98081e983b25@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0187]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Colin Fowler <elethiomel@gmail.com> wrote:

> > there are a handful of 'scheduler feature bits' in
> > /proc/sys/kernel/sched_features:
> >
> > enum {
> >         SCHED_FEAT_NEW_FAIR_SLEEPERS    = 1,
> >         SCHED_FEAT_WAKEUP_PREEMPT       = 2,
> >         SCHED_FEAT_START_DEBIT          = 4,
> >         SCHED_FEAT_TREE_AVG             = 8,
> >         SCHED_FEAT_APPROX_AVG           = 16,
> > };
> >
> 
> Toggling SCHED_FEAT_NEW_FAIR_SLEEPERS to 0 or 
> SCHED_FEAT_WAKEUP_PREEMPT to 0 gives me results more inline with my 
> 2.6.22 results. Toggling them both to 0 gives me slightly better 
> results than 2.6.22!

ok, but it would be nice to avoid having to turn these off. Could you 
try whether tuning the /proc/sys/kernel/*granularity* values (in 
particular wakeup_granularity) has any positive effect on your workload?

also, could you run your workload as SCHED_BATCH [via schedtool -B ], 
does that improve the results as well on a default-tuned kernel?

	Ingo
