Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZKHJVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZKHJVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZKHJVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:21:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46162 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZKHJVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:21:33 -0500
Date: Sun, 8 Nov 2009 10:21:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, fweisbec@gmail.com,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v5 0/7] Adding general performance benchmarking
 subcommand to perf.
Message-ID: <20091108092121.GB21267@elte.hu>
References: <1257381097-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257381097-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
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

> This patch series add general benchmark subcommand to perf.
> 
> The subcommand will unify the benchmarking programs
> and provide these in standardized way.
> 
> I fixed this series for latest tip tree.
> My previous patch series conflicts with cmd_probe().
> So please discard v4 and use this v5.
> 
> Hitoshi Mitake (7):
>   Adding new directory and header for new subcommand 'bench'
>   sched-messaging.c: benchmark for scheduler and IPC mechanisms based
>     on hackbench
>   sched-pipe.c: benchmark for pipe() system call
>   builtin-bench.c: General framework for benchmark suites
>   Modifying builtin.h for new prototype
>   Modyfing perf.c for subcommand 'bench'
>   Modyfing Makefile to build subcommand 'bench'
> 
>  tools/perf/Makefile                |    6 +
>  tools/perf/bench/bench.h           |    9 +
>  tools/perf/bench/sched-messaging.c |  332 ++++++++++++++++++++++++++++++++++++
>  tools/perf/bench/sched-pipe.c      |  113 ++++++++++++
>  tools/perf/builtin-bench.c         |  128 ++++++++++++++
>  tools/perf/builtin.h               |    1 +
>  tools/perf/perf.c                  |    1 +
>  7 files changed, 590 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/bench/bench.h
>  create mode 100644 tools/perf/bench/sched-messaging.c
>  create mode 100644 tools/perf/bench/sched-pipe.c
>  create mode 100644 tools/perf/builtin-bench.c

Looks good - i've applied the patches to tip:perf/bench, thanks!

There's one small bug i noticed:

$ ./perf bench sched pipe
(executing 1000000 pipe operations between two tasks)

	Total time:4.898 sec
$ 		4.898586 usecs/op
		204140 ops/sec


the shell prompt came back before the usecs/op and ops/sec line was 
printed. Process teardown race, lack of wait() or so?

	Ingo
