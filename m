Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZJHBnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZJHBnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZJHBnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:43:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59940 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZJHBnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:43:14 -0400
Subject: Re: [PATCH V4] fix warning on kernel/trace/trace_branch.c
 andtrace_hw_branches.c
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Zhenwen Xu <helight.xu@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4ACD4266.2050902@cn.fujitsu.com>
References: <20091007113915.GA5265@helight>  <20091008012146.GA4170@helight>
	 <1254965540.1696.198.camel@gandalf.stny.rr.com>
	 <4ACD4266.2050902@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 21:41:15 -0400
Message-Id: <1254966075.1696.199.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 09:37 +0800, Li Zefan wrote:
> >> diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
> >> index 23b6385..52a5903 100644
> >> --- a/kernel/trace/trace_hw_branches.c
> >> +++ b/kernel/trace/trace_hw_branches.c
> >> @@ -165,6 +165,7 @@ void trace_hw_branch(u64 from, u64 to)
> >>  	struct ftrace_event_call *call = &event_hw_branch;
> >>  	struct trace_array *tr = hw_branch_trace;
> >>  	struct ring_buffer_event *event;
> >> +	struct ring_buffer *buf;
> >>  	struct hw_branch_entry *entry;
> >>  	unsigned long irq1;
> >>  	int cpu;
> >> @@ -180,7 +181,8 @@ void trace_hw_branch(u64 from, u64 to)
> >>  	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
> >>  		goto out;
> >>  
> >> -	event = trace_buffer_lock_reserve(tr, TRACE_HW_BRANCHES,
> >> +	buf = tr->buffer
> 
> And here won't compile..

Thanks,

I'll fix up the patch.

-- Steve

> 
> >> +	event = trace_buffer_lock_reserve(buf, TRACE_HW_BRANCHES,
> >>  					  sizeof(*entry), 0, 0);

