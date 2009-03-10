Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZCJFur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZCJFur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZCJFuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:50:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55766 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZCJFug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:50:36 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/7] tracing: new format for specialized trace points
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090310045811.279394388@goodmis.org>
References: <20090310045710.286915983@goodmis.org> <20090310045811.279394388@goodmis.org>
Message-Id: <20090310144700.A48E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 10 Mar 2009 14:50:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

>  TRACE_EVENT(sched_switch,
> 
> 	TP_PROTO(struct rq *rq, struct task_struct *prev,
> 		 struct task_struct *next),
> 
> 	TP_ARGS(rq, prev, next),
> 
> 	TP_STRUCT__entry(
> 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
> 		__field(	pid_t,	prev_pid			)
> 		__field(	int,	prev_prio			)
> 		__array(	char,	next_comm,	TASK_COMM_LEN	)
> 		__field(	pid_t,	next_pid			)
> 		__field(	int,	next_prio			)
> 	),
> 
> 	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
> 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
> 		__entry->next_comm, __entry->next_pid, __entry->next_prio),
> 
> 	TP_fast_assign(
> 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> 		__entry->prev_pid	= prev->pid;
> 		__entry->prev_prio	= prev->prio;
> 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> 		__entry->next_pid	= next->pid;
> 		__entry->next_prio	= next->prio;
> 	)
>  );

Could you please write the documentation how to make new tracepont and 
use various TP_ macro?
Some developer (include me) plan to add new tracepoint. but these macro
usage is a bit difficult.



