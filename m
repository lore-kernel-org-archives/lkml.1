Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbZCDL60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbZCDL60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZCDL6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:58:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46790 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZCDL6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:58:15 -0500
Subject: Re: [PATCH -v2] tracing: lockdep tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Jason Baron <jbaron@redhat.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090304114319.GA4916@elte.hu>
References: <1236164586.5330.7142.camel@laptop>
	 <20090304112345.GB6032@nowhere> <1236166375.5330.7209.camel@laptop>
	 <20090304114319.GA4916@elte.hu>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 12:58:03 +0100
Message-Id: <1236167883.5330.7264.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 12:43 +0100, Ingo Molnar wrote:
> 
> > +TRACE_FORMAT(lock_contended,
> > +     TPPROTO(struct lockdep_map *lock, unsigned long ip),
> > +     TPARGS(lock, ip),
> > +     TPFMT("%s", lock->name)
> > +     );
> 
> Would it be possible to use the C syntax tracepoints perhaps? 
> They are bigger:
> 
>      TRACE_EVENT_FORMAT(sched_switch,
>         TPPROTO(struct rq *rq, struct task_struct *prev,
>                 struct task_struct *next),
>         TPARGS(rq, prev, next),
>         TPFMT("task %s:%d ==> %s:%d",
>               prev->comm, prev->pid, next->comm, next->pid),
>         TRACE_STRUCT(
>                 TRACE_FIELD(pid_t, prev_pid, prev->pid)
>                 TRACE_FIELD(int, prev_prio, prev->prio)
>                 TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
>                                     next_comm,
>                                     TPCMD(memcpy(TRACE_ENTRY->next_comm,
>                                                  next->comm,
>                                                  TASK_COMM_LEN)))
>                 TRACE_FIELD(pid_t, next_pid, next->pid)
>                 TRACE_FIELD(int, next_prio, next->prio)
>         ),
>         TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
>         );

I'm not quite sure how to do strings with those. The IRQ tracepoints
cheat and omit the string, and the sched tracepoints cheat and use this
static sized comm array.

