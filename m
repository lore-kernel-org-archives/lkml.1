Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbZHBUNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbZHBUNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZHBUNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:13:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54340 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZHBUNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:13:33 -0400
Date: Sun, 2 Aug 2009 22:13:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: a.p.zijlstra@chello.nl, fweisbec@gmail.com, linux@brodo.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding transition of CPU frequency counting
	support to perfcounters
Message-ID: <20090802201321.GH24486@elte.hu>
References: <20090718093115.GB9142@elte.hu> <20090718.231137.187581409.mitake@dcl.info.waseda.ac.jp> <1247933355.6597.11.camel@laptop> <20090721.104639.746976804375753666.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721.104639.746976804375753666.mitake@dcl.info.waseda.ac.jp>
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

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Subject: Re: [PATCH][RFC] Adding transition of CPU frequency counting support to perfcounters
> Date: Sat, 18 Jul 2009 18:09:15 +0200
> 
> > On Sat, 2009-07-18 at 23:11 +0900, mitake@dcl.info.waseda.ac.jp wrote:
> > > 
> > > Oh, my perf could count cpufreq events!
> > > Thanks for your nice advice!
> > > 
> > > % perf stat -a sleep 60
> > > 
> > >  Performance counter stats for 'sleep 60':
> > > 
> > >   479088.075595  task-clock-msecs         #      7.984 CPUs
> > >          199080  context-switches         #      0.000 M/sec
> > >           19584  CPU-migrations           #      0.000 M/sec
> > >          322978  page-faults              #      0.001 M/sec
> > >              29  cpufreq-up               #      0.000 M/sec
> > >              42  cpufreq-down             #      0.000 M/sec
> > >     73703367828  cycles                   #    153.841 M/sec
> > >     52005203450  instructions             #      0.706 IPC
> > >       209762467  cache-references         #      0.438 M/sec
> > >        84916856  cache-misses             #      0.177 M/sec
> > > 
> > >    60.009508200  seconds time elapsed
> > > 
> > > And I'm using ondemand governor now,
> > > so kernel thread [kondemand] context causes freq transition.
> > > I didn't notice that...
> > > 
> > > Could you merge this patch?
> > > Can I send this patch with descriptions and Signed-off-by?
> > 
> > Why, what is the usecase?
> > 
> > 
> 
> Hmm, I considered, and I noticed that this patch makes no sense. 
> Because my first purpose "collecting CPU freq transitions per 
> process level" is completely nonsense. CPU freq transitions are 
> global things, not one of processes.

Well, but 'perf stat -a' will install per CPU counters, i.e. the 
counting is global, not per task.

(even per task counting makes a certain amount of sense: which apps 
generate the most freq change events for example?)

	Ingo
