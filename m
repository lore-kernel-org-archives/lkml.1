Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZKCKxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZKCKxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZKCKxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:53:40 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:63467 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZKCKxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:53:36 -0500
Date: Tue, 03 Nov 2009 19:53:35 +0900 (JST)
Message-Id: <20091103.195335.229420428319821713.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       a.p.zijlstra@chello.nl, efault@gmx.de, acme@redhat.com,
       fweisbec@gmail.com
Subject: Re: [RFC][PATCH 7/7] Adding general performance benchmarking
 subsystem to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091103074648.GG19928@elte.hu>
References: <20091103.133927.580735811043340004.mitake@dcl.info.waseda.ac.jp>
	<20091103074648.GG19928@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 7/7] Adding general performance benchmarking subsystem to perf.
Date: Tue, 3 Nov 2009 08:46:48 +0100

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > 
> > Adding general performance benchmarking subsystem to perf.
> > This patch adds builtin-bench-pipe.c
> > 
> > builtin-bench-pipe.c is a benchmark program
> > to measure performance of pipe() system call.
> > This benchmark is based on pipe-test-1m.c by Ingo Molnar.
> > http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c
> > 
> > Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Mike Galbraith <efault@gmx.de>
> > ---
> >  tools/perf/builtin-bench-pipe.c |   89 +++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 89 insertions(+), 0 deletions(-)
> >  create mode 100644 tools/perf/builtin-bench-pipe.c
> > 
> > diff --git a/tools/perf/builtin-bench-pipe.c b/tools/perf/builtin-bench-pipe.c
> > new file mode 100644
> > index 0000000..081515e
> > --- /dev/null
> > +++ b/tools/perf/builtin-bench-pipe.c
> > @@ -0,0 +1,89 @@
> > +/*
> > + *
> > + * builtin-bench-pipe.c
> > + *
> > + * pipe: Benchmark for pipe()
> > + *
> > + * Based on pipe-test-1m.c by Ingo Molnar <mingo@redhat.com>
> > + *  http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c
> > + * Ported to perf by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > + *
> > + */
> 

Thanks for your detailed comments, Ingo!
I read your comments and rewrote the patch series.
I'll sent the series later as new thread.

> Ok, i think there's going to be quite a few of these benchmarks, so i'd 
> suggest you start a new directory for the benchmark modules: 
> tools/perf/bench/ for example.
> 
> We'll still have tools/perf/builtin-bench.c which represents the highest 
> level 'perf bench' tool - and new modules can be added by adding them to 
> bench/.
> 
> What do you think?

I agree with your way making new bench/ directory.
I feel that modules of bench should not be at top of tools/perf/.

> 
> All in one, i very much like the modular direction you are taking here. 
> 

Thanks, I'm grad to hear it.

> There will be a handful of more details i'm sure but once there's a good 
> base we can commit it - would you / will you be interested in extending 
> it further and adding more benchmark modules as well?
> 
> There's quite a few useful small benchmarks that people are using to 
> measure the kernel. Having a good collection of them in one place, with 
> standardized options and standardized output would be very useful.

Yes, of course! Unified benchmarking utilities will be big help for
Linux users including me.

e.g. I think that copybench (http://code.google.com/p/copybench/) will be
good benchmark for I/O, memory and file system.
I'll work on this after that the patch series I'll send later is merged.

Do you know any other good candidates to include?
