Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbZCMDVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbZCMDVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZCMDUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:20:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769AbZCMDUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:20:48 -0400
Date: Thu, 12 Mar 2009 23:20:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 05/16] tracing: show that buffer size is not expanded
In-Reply-To: <20090313114953.43E2.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0903122317280.18396@gandalf.stny.rr.com>
References: <20090313023704.971438367@goodmis.org> <20090313023825.869949732@goodmis.org> <20090313114953.43E2.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 13 Mar 2009, KOSAKI Motohiro wrote:

> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: do not confuse user on small trace buffer sizes
> > 
> > When the system boots up, the trace buffer is small to conserve memory.
> > It is only two pages per online CPU. When the tracer is used, it expands
> > to the default value.
> > 
> > This can confuse the user if they look at the buffer size and see only
> > 7, but then later they see 1408.
> > 
> >  # cat /debug/tracing/buffer_size_kb
> > 7
> > 
> >  # echo sched_switch > /debug/tracing/current_tracer
> > 
> >  # cat /debug/tracing/buffer_size_kb
> > 1408
> > 
> > This patch tries to help remove this confustion by showing that the
> > buffer has not been expanded.
> > 
> >  # cat /debug/tracing/buffer_size_kb
> > 7 (expanded: 1408)
> 
> Hi,
> 
> I have one question.
> Why souldn't use following output?
> 
> sprintf(buf, "%lu\n", trace_buf_size >> 10);
> 
> 
> My point is:
>   - pure number output can hadle easily.
>   - nobody need to know internal memory saving logic.

My answer to the second point is: "I do" ;-)

I like to know the real buffer size. That '7' comes from the ring buffer 
size directly. If something is going wrong, I do not want to hide the fact 
that the ring buffer size is not what I expect it to be. Lets say someone 
modifies the code, and we miss expanding the buffer. It will be very hard 
to debug why we are getting a small trace. But if we see that the buffer 
has not been expanded, we know exactly what is wrong.

-- Steve

