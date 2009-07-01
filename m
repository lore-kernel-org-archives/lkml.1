Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZGAJIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZGAJIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZGAJH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:07:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbZGAJH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:07:56 -0400
Date: Wed, 1 Jul 2009 11:07:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
	how many spinlocks to schedstat
Message-ID: <20090701090749.GA13535@elte.hu>
References: <20090701.152115.706994265076015808.mitake@dcl.info.waseda.ac.jp> <87hbxwj1k3.fsf@basil.nowhere.org> <20090701.174226.419764642024067218.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701.174226.419764642024067218.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> From: Andi Kleen <andi@firstfloor.org>
> Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> Date: Wed, 01 Jul 2009 09:38:04 +0200
> 
> > Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> writes:
> > 
> > > Hi,
> > >
> > > I wrote a test patch which add information of counts processes acquired how many spinlocks to schedstat.
> > > After applied this patch, /proc/<PID>/sched will change like this,
> > 
> > The problem is that spinlocks are very common and schedstats is 
> > enabled commonly in production kernels. You would need to 
> > demonstrate that such a change doesn't have significant 
> > performance impact. For me it looks like it has.
> 
> I agree with your opinion about performance impact.
> I thought this will make no problem,
> because schedstat is categorized as "Kernel hacking" section.
> But according to you, many production kernels enable it
> so my patch will make widespread performance degradation.
> I didn't know that, sorry.

His arguments are bogus: both lockstat and perfcounters are optional 
(and default off), and the sw counter can be made near zero cost 
even if both perfcounters and lockstat is enabled. Also, sw counters 
are generally per CPU, etc. so not a performance issue.

The only (small) overhead will be when the lock-acquire sw counter 
is actively enabled because you run 'perf stat -e lock-acquire' - 
but that is expected and inherent in pretty much any kind of 
instrumentation.

The feature you are working on has the chance to be a very useful 
and popular piece of instrumentation. Being able to tell the lock 
acquire stats on a per task, per workload, per CPU or system-wide 
basis is a unique capability no other tool can offer right now.

Andi is often trolling perfcounters related (and other) threads, 
please dont let yourself be deterred by that and feel free to ignore 
him.

	Ingo
