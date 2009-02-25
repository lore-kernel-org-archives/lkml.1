Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbZBYQ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbZBYQ72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbZBYQ7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:59:01 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:40479 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbZBYQ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:59:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAKcDpUlMQWWY/2dsb2JhbACBb9d1hBEG
Date: Wed, 25 Feb 2009 11:58:49 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com
Subject: Re: [PATCH] new irq tracer
Message-ID: <20090225165849.GA13463@Krystal>
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49A5765C.2020001@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:55:29 up 4 days,  8:29,  4 users,  load average: 0.16, 0.24,
	0.31
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> 
> 
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

I seriously doubt we should consider a trace with missing events as
"reliable". If your only argument is that when the buffers are not large
enough we could lose events, then I think we should just hint people at
doing the right thing, which is to tweak the tracer parameters (e.g.
larger buffers) so they stop losing events.

A trace with events lost is really a scenario close to a corrupted
trace because we don't know which event has been lost, nor where. I
don't think we should increase the event size to support that kind of
broken scenario.

Mathieu

> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
