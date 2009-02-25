Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZBYQ7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZBYQ7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZBYQ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:58:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37431 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZBYQ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:58:56 -0500
Date: Wed, 25 Feb 2009 11:57:47 -0500
From: Jason Baron <jbaron@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com, compudj@krystal.dyndns.org
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090225165747.GC3123@redhat.com>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A5765C.2020001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 11:48:28AM -0500, Masami Hiramatsu wrote:
> KOSAKI Motohiro wrote:
> >>  /**
> >>   * handle_IRQ_event - irq action chain handler
> >>   * @irq:	the interrupt number
> >> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
> >>  		local_irq_enable_in_hardirq();
> >>  
> >>  	do {
> >> +		trace_irq_entry(irq);
> >>  		ret = action->handler(irq, action->dev_id);
> >> +		trace_irq_exit(irq, ret);
> >>  		if (ret == IRQ_HANDLED)
> >>  			status |= action->flags;
> >>  		retval |= ret;
> > 
> > Nobdy want unnecessary redundant tracepoint.
> > Please discuss with mathieu, and merge his tracepoint.
> 
> Hmm, from the viewpoint of trouble shooting, the place of LTTng's tracepoint
> is enough. However, from the same viewpoint, it should pass irq-number
> to irq-exit event too, because we may lost some previous events by buffer-overflow
> etc.
> 
>          trace_irq_entry(irq, NULL);
>          ret = _handle_IRQ_event(irq, action);
>          trace_irq_exit(irq, ret);
>                         ^^^^
> 

the lttng tracepoints wrap the calls to _handle_IRQ_event in 3
different places. So the above suggested irq tracepoint provides the
same information with 4 less tracepoints in the code. So I believe its
simpler - plus we can understand which action handlers are handling the
interrupt.

thanks,

-Jason
