Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbZBYQsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbZBYQsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZBYQsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:48:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52397 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZBYQsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:48:10 -0500
Message-ID: <49A5765C.2020001@redhat.com>
Date: Wed, 25 Feb 2009 11:48:28 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net, fweisbec@gmail.com, compudj@krystal.dyndns.org
Subject: Re: [PATCH] new irq tracer
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090222123543.359C.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



KOSAKI Motohiro wrote:
>>  /**
>>   * handle_IRQ_event - irq action chain handler
>>   * @irq:	the interrupt number
>> @@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
>>  		local_irq_enable_in_hardirq();
>>  
>>  	do {
>> +		trace_irq_entry(irq);
>>  		ret = action->handler(irq, action->dev_id);
>> +		trace_irq_exit(irq, ret);
>>  		if (ret == IRQ_HANDLED)
>>  			status |= action->flags;
>>  		retval |= ret;
> 
> Nobdy want unnecessary redundant tracepoint.
> Please discuss with mathieu, and merge his tracepoint.

Hmm, from the viewpoint of trouble shooting, the place of LTTng's tracepoint
is enough. However, from the same viewpoint, it should pass irq-number
to irq-exit event too, because we may lost some previous events by buffer-overflow
etc.

         trace_irq_entry(irq, NULL);
         ret = _handle_IRQ_event(irq, action);
         trace_irq_exit(irq, ret);
                        ^^^^

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

