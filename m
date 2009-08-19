Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbZHSDIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbZHSDIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZHSDIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:08:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZHSDIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:08:09 -0400
Message-ID: <4A8B6C80.4050805@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 11:07:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing, sched: mark preempt_schedule() notrace
References: <4A8A5FF5.8080609@cn.fujitsu.com> <20090818103853.GB5231@nowhere> <alpine.DEB.2.00.0908181220280.7852@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908181220280.7852@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> On Tue, 18 Aug 2009, Frederic Weisbecker wrote:
> 
>> On Tue, Aug 18, 2009 at 04:01:57PM +0800, Lai Jiangshan wrote:
>>> Current preempt_schedule() is not marked notrace. It may be
>>> infinite recursion in __trace_graph_return().
>>>
>>> preempt_schedule()
>>>   __trace_graph_return()
>>>     ftrace_preempt_disable() (!!return false!!)
>>>     ftrace_preempt_enable()
>>>       preempt_enable_notrace()
>>>          preempt_schedule() (need_resched() may be true again)
>>
>>
>> It would happen in __trace_graph_return() , when preempt_schedule()
>> has finished its job. It's very unlikely the TIF_NEED_RESCHED is
>> set just after (because it has just been cleared).
>> But why not. In that case, preempt_schedule() is called again but it's
>> not a real tracing recursion.
>>
>> That seems like a normal behaviour actually.
> 
> In fact, this is actually something to be traced. I would not add a 
> notrace to it. This is not saving anything, the trace_graph_return does 
> not need to worry about stack overflow, since the return code already 
> freed the stack.
> 

You're right, I forgot to read trace_graph_return().
trace_graph_return() protects itself from recursion.

Since there is no may-recursive trace_func_graph_ret_t.
Just omit this patch.
Sorry for bothered you all.


