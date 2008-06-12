Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYFLTgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYFLTgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYFLTg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:36:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbYFLTg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:36:27 -0400
Message-ID: <48517A56.20603@redhat.com>
Date: Thu, 12 Jun 2008 15:34:46 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
References: <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins> <20080612155332.GA16658@redhat.com> <48514BE3.3000506@redhat.com> <20080612164318.GB17814@redhat.com> <48515770.4020002@redhat.com> <20080612174834.GB22454@redhat.com>
In-Reply-To: <20080612174834.GB22454@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

Frank Ch. Eigler wrote:
> Hi -
> 
> On Thu, Jun 12, 2008 at 01:05:52PM -0400, Masami Hiramatsu wrote:
>> [...]
>>>> "sched_switch(struct task_struct * next, struct task_struct * prev)":"next %p prev %p"
>>>> out of tree. Thus, you can use the printf-style format parser.
>>> That's an interesting idea, but errors in this table would themselves
>>> only be caught at C compilation time.
> 
>> Hmm, why would you think so?  I think if we can't find corresponding
>> entry from the lookup table, it becomes an error.
> 
> Sure, but if the entry exists but is wrong, we'd emit C code that
> won't compile.

I think if someone changes the trace point in the kernel,
Module.markers is also changed.

ex.)
 DEFINE_TRACE(sched_switch, (struct task_struct * next, struct task_struct * prev),
	     next, prev);

if someone changes above to below,

 DEFINE_TRACE(sched_switch, (int prev_pid, int next_pid), prev_pid, next_pid);

Module.markers also change like

 sched_switch	vmlinux	(struct task_struct * next, struct task_struct * prev)

to

 sched_switch	vmlinux	(int prev_pid, int next_pid)

In this case, the below entry never matches to new Module.markers.

"sched_switch(struct task_struct * next, struct task_struct * prev)":"next %p prev %p"

Thus, we can find an error.
However, of cause, we should take care of the task_struct changes.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

