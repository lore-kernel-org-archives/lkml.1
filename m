Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab0CCRHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 12:07:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0CCRHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:07:30 -0500
X-Authority-Analysis: v=1.0 c=1 a=JmiDjSKT-SYA:10 a=7U3hwN5JcxgA:10 a=QF5HcNAIr1wxC3HZ0lYA:9 a=E0zEotW1mdet4QwpUhbqvy_B3O4A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
 events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1267634258.25158.88.camel@laptop>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
	 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
	 <1267632387.10871.59.camel@gandalf.stny.rr.com>
	 <1267634258.25158.88.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Mar 2010 12:07:26 -0500
Message-ID: <1267636046.10871.74.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 17:37 +0100, Peter Zijlstra wrote:

> > >  	/* Trace events already protected against recursion */
> > >  	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
> > > -				&data, regs);
> > > +				&data, &regs);
> > 
> > Off-topic: Why is the above a perf sw event? Couldn't that also be a
> > normal TRACE_EVENT()?
> 
> Well, no, this is the stuff that transforms TRACE_EVENT() into perf
> software events ;-)
> 

oops, my bad :-), I thought this was in the x86 arch directory. For the
University, I was helping them with adding trace points for page faults
when I came across this in arch/x86/mm/fault.c:

	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);


This is what I actually was wondering about. Why is it a "perf only"
trace point instead of a TRACE_EVENT()?

-- Steve


