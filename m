Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbZBYRSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbZBYRSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbZBYRSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:18:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51233 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbZBYRSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:18:34 -0500
Message-ID: <49A57D85.4090201@redhat.com>
Date: Wed, 25 Feb 2009 12:19:01 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com
Subject: Re: [PATCH] new irq tracer
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com> <20090225165849.GA13463@Krystal>
In-Reply-To: <20090225165849.GA13463@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>>
>> KOSAKI Motohiro wrote:
>>>>  /**
>>>>   * handle_IRQ_event - irq action chain handler
>>>>   * @irq:	the interrupt number
>>>> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
>>>>  		local_irq_enable_in_hardirq();
>>>>  
>>>>  	do {
>>>> +		trace_irq_entry(irq);
>>>>  		ret = action->handler(irq, action->dev_id);
>>>> +		trace_irq_exit(irq, ret);
>>>>  		if (ret == IRQ_HANDLED)
>>>>  			status |= action->flags;
>>>>  		retval |= ret;
>>> Nobdy want unnecessary redundant tracepoint.
>>> Please discuss with mathieu, and merge his tracepoint.
>> Hmm, from the viewpoint of trouble shooting, the place of LTTng's tracepoint
>> is enough. However, from the same viewpoint, it should pass irq-number
>> to irq-exit event too, because we may lost some previous events by buffer-overflow
>> etc.
>>
>>          trace_irq_entry(irq, NULL);
>>          ret = _handle_IRQ_event(irq, action);
>>          trace_irq_exit(irq, ret);
>>                         ^^^^
>>
> 
> I seriously doubt we should consider a trace with missing events as
> "reliable". If your only argument is that when the buffers are not large
> enough we could lose events, then I think we should just hint people at
> doing the right thing, which is to tweak the tracer parameters (e.g.
> larger buffers) so they stop losing events.

Hi Mathieu,

I think it depends on what events we'd like to trace on what environment
(not have so much memories).
Someone(like me) may want "reliability" for those events, someone not.

> A trace with events lost is really a scenario close to a corrupted
> trace because we don't know which event has been lost, nor where. I
> don't think we should increase the event size to support that kind of
> broken scenario.

Why LTTng doesn't filter those unused arguments inside their handlers?
Is there no room for compromise on sharing tracepoints with other
tracers? IMHO, tracepoints in the kernel should be a common
infrastructure for many users.

Thank you,

> 
> Mathieu
> 
>> Thank you,
>>
>> -- 
>> Masami Hiramatsu
>>
>> Software Engineer
>> Hitachi Computer Products (America) Inc.
>> Software Solutions Division
>>
>> e-mail: mhiramat@redhat.com
>>
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

