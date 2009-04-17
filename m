Return-Path: <linux-kernel-owner+w=401wt.eu-S1760808AbZDQNqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808AbZDQNqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbZDQNq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:46:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50238 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281AbZDQNq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:46:28 -0400
Date: Fri, 17 Apr 2009 15:45:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make workqueue
	tracepoints use TRACE_EVENT macro
Message-ID: <20090417134557.GA23493@elte.hu>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E82CA7.2040606@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> +TRACE_EVENT(workqueue_insertion,
> +TRACE_EVENT(workqueue_execution,
> +TRACE_EVENT(workqueue_creation,
> +TRACE_EVENT(workqueue_destruction,

I'm missing all the worklet tracepoints i suggested. (and i think 
which you had in earlier versions)

Basically, i'd suggest the following complete set of events instead:

 TRACE_EVENT(workqueue_create
 TRACE_EVENT(workqueue_flush              /* NEW */
 TRACE_EVENT(workqueue_destroy

 TRACE_EVENT(worklet_enqueue              /* NEW */
 TRACE_EVENT(worklet_enqueue_delayed      /* NEW */

 TRACE_EVENT(worklet_execute              /* instead of workqueue_execution */
 TRACE_EVENT(worklet_complete             /* NEW */

 TRACE_EVENT(worklet_cancel               /* NEW */

This allows the understanding of the life cycle of a workqueue and 
of worklets that enter that workqueue. Note the distinction between 
workqueue and worklet (work) - that is essential.

The parameters of the events are obvious, with one detail: i'd 
suggest a 'cpu' parameter to the enqueue events, to allow the 
mapping of the _on(..cpu) variants too.

I would not bother with schedule_on_each_cpu() instrumentation - 
it's rarely used.

	Ingo
