Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZB0Ddt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZB0Ddt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZB0Ddk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:33:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54377 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZB0Ddk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:33:40 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH] new irq tracer
Cc: kosaki.motohiro@jp.fujitsu.com, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com
In-Reply-To: <20090225173412.GA14269@Krystal>
References: <20090225165747.GC3123@redhat.com> <20090225173412.GA14269@Krystal>
Message-Id: <20090227123037.152E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 27 Feb 2009 12:33:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > the lttng tracepoints wrap the calls to _handle_IRQ_event in 3
> > different places. So the above suggested irq tracepoint provides the
> > same information with 4 less tracepoints in the code. So I believe its
> > simpler - plus we can understand which action handlers are handling the
> > interrupt.
> > 
> 
> The main thing I dislike about only tracing action->handler() calls is
> that you are not tracing an IRQ per se, but rather the invocation of a
> given handler within the interrupt. For instance, it would be difficult
> to calculate the maximum interrupt latency for a given interrupt line,
> because you don't have the "real" irq entry/exit events, just the
> individual handler() calls.

I agree with IRQ latency tracing is very important.
So now, We understand we have another two good requirement.

Therefore, I can agree to Mathieu's separete trace point idea and
Jason's current patch.

Thanks! good discussion.



> 
> But I agree that knowing which handler is called is important.
> 
> How about this compromise :
> 
> trace_irq_entry(irq, action)
>   _handle_IRQ_event()
>     for each action  {
>       trace_irq_handler(action, ret);
>       ret = action->handler(irq, action->dev_id);
>       ...
>     }
> trace_irq_exit(action_ret);
> 
> Would that give you the information you need ?
> 
> Here trace_irq_handler would be passed the _current_ action invoked and
> the _previous_ action return value. Note that we should initialize
> irqreturn_t ret to some initial value if we do this. That should keep
> the tracing overhead minimal.





