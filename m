Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbZCXRyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbZCXRyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZCXRyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:54:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36534 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbZCXRyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:54:01 -0400
Date: Tue, 24 Mar 2009 18:53:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 5/9] LTTng instrumentation scheduler fix task migration
Message-ID: <20090324175317.GD31117@elte.hu>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.554127249@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324160148.554127249@polymtl.ca>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> The scheduler migration only needs to pass the task struct pointer 
> and the destination CPU. The source CPU can be found by using 
> task_cpu(p) in the probe.

> +++ linux-2.6-lttng/include/trace/sched.h	2009-01-30 10:43:19.000000000 -0500
> @@ -30,8 +30,8 @@ DECLARE_TRACE(sched_switch,
>  		TPARGS(rq, prev, next));
>  
>  DECLARE_TRACE(sched_migrate_task,
> -	TPPROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
> -		TPARGS(p, orig_cpu, dest_cpu));
> +	TPPROTO(struct task_struct *p, int dest_cpu),
> +		TPARGS(p, dest_cpu));

Makes sense. Since this tracepoint has been changed in the tracing 
tree already, mind doing this change in that context?

Thanks,

	Ingo
