Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZKIDJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZKIDJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZKIDJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:09:07 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59855 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZKIDJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:09:06 -0500
Date: Mon, 09 Nov 2009 12:09:08 +0900 (JST)
Message-Id: <20091109.120908.552412311744460070.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       a.p.zijlstra@chello.nl, efault@gmx.de, acme@redhat.com,
       fweisbec@gmail.com, jkosina@suse.cz
Subject: Re: [PATCH v5 0/7] Adding general performance benchmarking
 subcommand to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091108092121.GB21267@elte.hu>
References: <1257381097-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091108092121.GB21267@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v5 0/7] Adding general performance benchmarking subcommand to perf.
Date: Sun, 8 Nov 2009 10:21:21 +0100

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > This patch series add general benchmark subcommand to perf.
> > 
> > The subcommand will unify the benchmarking programs
> > and provide these in standardized way.
> > 
> > I fixed this series for latest tip tree.
> > My previous patch series conflicts with cmd_probe().
> > So please discard v4 and use this v5.
> > 
> > Hitoshi Mitake (7):
> >   Adding new directory and header for new subcommand 'bench'
> >   sched-messaging.c: benchmark for scheduler and IPC mechanisms based
> >     on hackbench
> >   sched-pipe.c: benchmark for pipe() system call
> >   builtin-bench.c: General framework for benchmark suites
> >   Modifying builtin.h for new prototype
> >   Modyfing perf.c for subcommand 'bench'
> >   Modyfing Makefile to build subcommand 'bench'
> > 
> >  tools/perf/Makefile                |    6 +
> >  tools/perf/bench/bench.h           |    9 +
> >  tools/perf/bench/sched-messaging.c |  332 ++++++++++++++++++++++++++++++++++++
> >  tools/perf/bench/sched-pipe.c      |  113 ++++++++++++
> >  tools/perf/builtin-bench.c         |  128 ++++++++++++++
> >  tools/perf/builtin.h               |    1 +
> >  tools/perf/perf.c                  |    1 +
> >  7 files changed, 590 insertions(+), 0 deletions(-)
> >  create mode 100644 tools/perf/bench/bench.h
> >  create mode 100644 tools/perf/bench/sched-messaging.c
> >  create mode 100644 tools/perf/bench/sched-pipe.c
> >  create mode 100644 tools/perf/builtin-bench.c
> 
> Looks good - i've applied the patches to tip:perf/bench, thanks!

Thanks! Then I'll work on documentation and merging other
benchmarks such like lmbench or copybench.

> 
> There's one small bug i noticed:
> 
> $ ./perf bench sched pipe
> (executing 1000000 pipe operations between two tasks)
> 
> 	Total time:4.898 sec
> $ 		4.898586 usecs/op
> 		204140 ops/sec
> 
> 
> the shell prompt came back before the usecs/op and ops/sec line was 
> printed. Process teardown race, lack of wait() or so?

Thanks for your notify. I prepared a patch to fix this problem.
I'll send it later.

