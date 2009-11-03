Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZKCHrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZKCHrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:47:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbZKCHrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:47:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42436 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118AbZKCHrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:47:00 -0500
Date: Tue, 3 Nov 2009 08:46:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH 7/7] Adding general performance benchmarking
	subsystem to perf.
Message-ID: <20091103074648.GG19928@elte.hu>
References: <20091103.133927.580735811043340004.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103.133927.580735811043340004.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

> 
> Adding general performance benchmarking subsystem to perf.
> This patch adds builtin-bench-pipe.c
> 
> builtin-bench-pipe.c is a benchmark program
> to measure performance of pipe() system call.
> This benchmark is based on pipe-test-1m.c by Ingo Molnar.
> http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
>  tools/perf/builtin-bench-pipe.c |   89 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 89 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/builtin-bench-pipe.c
> 
> diff --git a/tools/perf/builtin-bench-pipe.c b/tools/perf/builtin-bench-pipe.c
> new file mode 100644
> index 0000000..081515e
> --- /dev/null
> +++ b/tools/perf/builtin-bench-pipe.c
> @@ -0,0 +1,89 @@
> +/*
> + *
> + * builtin-bench-pipe.c
> + *
> + * pipe: Benchmark for pipe()
> + *
> + * Based on pipe-test-1m.c by Ingo Molnar <mingo@redhat.com>
> + *  http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c
> + * Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> + *
> + */

Ok, i think there's going to be quite a few of these benchmarks, so i'd 
suggest you start a new directory for the benchmark modules: 
tools/perf/bench/ for example.

We'll still have tools/perf/builtin-bench.c which represents the highest 
level 'perf bench' tool - and new modules can be added by adding them to 
bench/.

What do you think?

All in one, i very much like the modular direction you are taking here. 

There will be a handful of more details i'm sure but once there's a good 
base we can commit it - would you / will you be interested in extending 
it further and adding more benchmark modules as well?

There's quite a few useful small benchmarks that people are using to 
measure the kernel. Having a good collection of them in one place, with 
standardized options and standardized output would be very useful.

	Ingo
