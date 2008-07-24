Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYGXOa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYGXOa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYGXOaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:30:14 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:53591 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbYGXOaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:30:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAJ8piEhMRKxB/2dsb2JhbACBWq95
Date: Thu, 24 Jul 2008 10:30:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 08/17] LTTng instrumentation - kernel
Message-ID: <20080724143009.GA8094@Krystal>
References: <20080715222604.331269462@polymtl.ca> <20080715222747.761260243@polymtl.ca> <Pine.LNX.4.58.0807240956350.14946@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807240956350.14946@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:27:58 up 49 days, 19:08,  4 users,  load average: 0.52, 0.80,
	0.87
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> On Tue, 15 Jul 2008, Mathieu Desnoyers wrote:
> >
> >  /*
> >   * Low level drivers may need that to know if they can schedule in
> > @@ -601,6 +603,7 @@ asmlinkage int printk(const char *fmt, .
> >  	int r;
> >
> >  	va_start(args, fmt);
> > +	trace_kernel_printk(__builtin_return_address(0));
> 
> BTW, ftrace.h has macros that let you use CALLER_ADDR0 for
> __builtin_return_address. It also converts it from a pointer to a long,
> but makes the code look prettier.
> 

include/linux/kernel.h:#define _RET_IP_   (unsigned long)__builtin_return_address(0)

Hrm, did not see this one. So I guess we can both switch to it ?

Thanks for pointing this out,

Mathieu

> 
> >  	r = vprintk(fmt, args);
> >  	va_end(args);
> >
> > @@ -677,6 +680,9 @@ asmlinkage int vprintk(const char *fmt,
> >  	raw_local_irq_save(flags);
> >  	this_cpu = smp_processor_id();
> >
> > +	trace_kernel_vprintk(__builtin_return_address(0),
> > +		printk_buf, printed_len);
> > +
> >  	/*
> >  	 * Ouch, printk recursed into itself!
> >  	 */
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
