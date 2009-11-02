Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbZKBKlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbZKBKlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZKBKlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:41:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbZKBKln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:41:43 -0500
Date: Mon, 2 Nov 2009 11:41:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH][RFC] Adding hackbench.c to tools/
Message-ID: <20091102104124.GA5193@elte.hu>
References: <20091101.131027.680961629714047921.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091101.131027.680961629714047921.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> Hi Ingo,
> 
> It seems that hackbench is the de-fact standard benchmarking program 
> for scheduler of Linux. But when I ask google where hackbench.c is, 
> some answers are replied. Like these, (in order of google result)
> 
> http://devresources.linux-foundation.org/craiger/hackbench/ (this page 
> containts link to hackbench.c) 
> http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
> 
> And it seems that second one is newer.
> 
> I think this situation is very confusable. So I wrote this patch to 
> add hackbench to tools/ of kernel tree. This may help hackbench users 
> like me.

I think we can do something nicer: would you be interested in adding it 
as a 'perf bench hackbench' sub-command of tools/perf/?

We already have the tools to measure scheduling behavior under 'perf 
sched', so having a 'perf bench' array of common tests would be nice to 
have.

( I've Cc:-ed Rusty, the original author of hackbench.c. Rusty, the file 
  has no explicit GPLv2 compatible license - is it fine to be put
  into GPLv2 code? )

Adding a new perf sub-command is easy:

create a new tools/perf/builtin-bench.c file and copy hackbench.c to it, 
add it to command-list.txt and to the Makefile - add it to perf.c's 
array of built-in commands and [optional] add a 
Documentation/perf-bench.txt file to generate manpages and usage strings 
for it.

Change the 'main' function to cmd_bench() and add option parsing like 
you can see in the other builtin-*.c files. This should get you going.

Eventually we'd add more scheduler (and other) benchmarks too, not just 
hackbench. I'd also suggest to name it not 'hackbench' but something 
more generic, like:

  perf bench sched messaging

So that we can have subsystem identifier first, then the type of 
benchmark.

	Ingo
