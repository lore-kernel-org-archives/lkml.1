Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZCTJ1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZCTJ1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZCTJ1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:27:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32832 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZCTJ1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:27:32 -0400
Date: Fri, 20 Mar 2009 10:27:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] tracepoint perf counter events and new ABI
Message-ID: <20090320092714.GA6256@elte.hu>
References: <20090319192610.660857280@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319192610.660857280@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> These patches change the event tracer to provide id files:
> 
> [root@opteron ~]# for i in /debug/tracing/events/irq/*/id; do echo `cat $i` - $i; done
> 28 - /debug/tracing/events/irq/irq_handler_entry/id
> 29 - /debug/tracing/events/irq/irq_handler_exit/id
> 27 - /debug/tracing/events/irq/softirq_entry/id
> 26 - /debug/tracing/events/irq/softirq_exit/id
> 
> These can then be used in profiling as:
> 
> [root@opteron linux-2.6]# ~/perfstat -e 2:28 make O=native-build/ -j4 lib
> ...
> 
>  Performance counter stats for 'make':
> 
>    18280.657602  task clock ticks     (msecs)
> 
>             465  tp: 28               (events)
> 
>  Wall-clock time elapsed: 11265.199196 msecs
> 
> Showing that we had 465 irq_handler_entry events during that workload.

nice! I suspect perfstat could use "-e irq_handler_entry" type of 
symbolic input as well.

I've started picking up the patches and started testing them.
Thanks Peter,

	Ingo
