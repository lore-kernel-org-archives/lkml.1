Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbZBXW0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbZBXW0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbZBXW0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:26:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37723 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbZBXW0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:26:08 -0500
Message-ID: <49A473ED.4010001@redhat.com>
Date: Tue, 24 Feb 2009 17:25:49 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/4][RFC] event tracer
References: <20090224193344.638329210@goodmis.org> <1235504556.4645.2252.camel@laptop> <alpine.DEB.2.00.0902241706260.12697@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0902241706260.12697@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 24 Feb 2009, Peter Zijlstra wrote:
> 
>> On Tue, 2009-02-24 at 14:33 -0500, Steven Rostedt wrote:
>>
>>>  DECLARE_TRACE_FMT(sched_kthread_stop,
>>>         TPPROTO(struct task_struct *t),
>>>                   TPARGS(t),
>>>                    "task %s:%d", TPARGS(t->comm, t->pid));
>> Consistency would require something like:
>>
>> DECLARE_TRACE_FMT(sched_kthread_stop,
>> 		  TPPROTO(struct task_struct *t),
>> 		  TPARGS(t),
>> 		  TPFMT("task %s:%d", t->comm, t->pid));
>>
>> I seem to remember Jason proposing something like this in the past.
> 
> Hmm, I'll have to look at that. (althought I was going to use a different 
> TPARGS for the format args.)
> 
> I have, for now:
> 
> 	event_printk("(%s)" fmt "\n", #call, fmtargs);
> 
> I guess I can redefine the TPFMT too.
> 
> #undef TPFMT
> #define TPFMT(fmt, args...) \
> 	"(%s)" fmt "\n", #call, ##args
> 
> and then I could do
> 
> 	event_printk(fmt);

Why don't you do as below? :)
	event_printk_line("(" #call ")" ##fmtandargs);

Anyway, your proposal is good for me, because it will recover
an information which tracepoint has lost.

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

