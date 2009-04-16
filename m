Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbZDPPyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbZDPPyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbZDPPyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:54:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54078 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbZDPPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:54:42 -0400
Date: Thu, 16 Apr 2009 11:53:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
In-Reply-To: <20090416153618.GB6004@nowhere>
Message-ID: <alpine.DEB.2.00.0904161152260.20429@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <20090416153618.GB6004@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Apr 2009, Frederic Weisbecker wrote:
> >  
> > +static int ftrace_module_notify(struct notifier_block *self,
> > +				unsigned long val, void *data)
> > +{
> > +	struct module *mod = data;
> > +
> > +	switch (val) {
> > +	case MODULE_STATE_COMING:
> > +		ftrace_init_module(mod, mod->ftrace_callsites,
> > +				   mod->ftrace_callsites +
> > +				   mod->num_ftrace_callsites);
> > +		break;
> > +	case MODULE_STATE_GOING:
> > +		ftrace_release(mod->ftrace_callsites,
> > +			       mod->ftrace_callsites +
> > +			       mod->num_ftrace_callsites);
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +}
> > +#else
> > +static int ftrace_module_notify(struct notifier_block *self,
> > +				unsigned long val, void *data)
> > +{
> > +	return 0;
> > +}
> 
> 
> 
> You don't seem to like my __init idea :)

Nah, just forgot about it.

> 
> 
> 
> > +#endif /* CONFIG_MODULES */
> > +
> > +struct notifier_block ftrace_module_nb = {
> > +	.notifier_call = ftrace_module_notify,
> > +	.priority = 0,
> > +};
> > +
> 
> 
> 
> Neither the __initdata_or_module.

Ooh, I never knew that existed.

-- Steve
