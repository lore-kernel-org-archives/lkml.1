Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZHQOlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZHQOlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZHQOlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:41:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59097 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbZHQOlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:41:19 -0400
Date: Mon, 17 Aug 2009 16:40:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Jiaying Zhang <jiayingz@google.com>, Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 4/4] perf tools: Add perf trace
Message-ID: <20090817144007.GC3602@elte.hu>
References: <1250518688-7207-1-git-send-email-fweisbec@gmail.com> <1250518688-7207-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250518688-7207-4-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> This adds perf trace into the set of perf tools. It is written to 
> fetch the tracepoints samples from perf events and display them, 
> according to the events informations given by the debugfs files 
> through the util/trace* tools.
> 
> It is a rough first shot and doesn't yet handle the cpu, 
> timestamps fields and some other things.
> 
> Example:
> 
> perf record -f -e workqueue:workqueue_execution:record -F 1 -a
> perf trace
> 
>        kblockd/0-236   [000]     0.000000: workqueue_execution: thread=:236 func=cfq_kick_queue+0x0
>      kondemand/0-360   [000]     0.000000: workqueue_execution: thread=:360 func=do_dbs_timer+0x0
>      kondemand/0-360   [000]     0.000000: workqueue_execution: thread=:360 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
>      kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0

Nice!

> Todo:
> 
> - A lot of things!

heh :-)

To help this move forward i've put the patches into 
tip:perfcounters/tracing. We might still rebase that branch, should 
it become necessary, before merging it into perfcounters/core - but 
it should give a first glimpse to people who want to try this.

A first bugreport:

took me some time to figure out that i need to pass in -R to create 
a trace.info. I think we want to share the namespace anyway - 
there's no real difference between perf.data and trace.info - both 
contain trace records.

once i added -R i ran into this problem:

# perf record -R -f -e workqueue:workqueue_execution:record -F 1 -a
^C
[ perf record: Captured and wrote 0.250 MB perf.data (~10928 samples) ]

aldebaran:/home/mingo/linux/linux/tools/perf> perf trace
  Fatal: bad op token )
version = 0.5

Some missing patch?

	Ingo
