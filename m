Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZCYDa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZCYDa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZCYDaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:30:13 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:44340 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZCYDaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:30:11 -0400
Date: Wed, 25 Mar 2009 09:00:01 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090325033001.GA20411@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090324152028.754123712@K.Prasad> <20090324152811.GL17918@in.ibm.com> <alpine.DEB.2.00.0903242256280.22830@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903242256280.22830@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:03:18PM -0400, Steven Rostedt wrote:
> 
> Hi Prasad,
> 
> On Tue, 24 Mar 2009, K.Prasad wrote:
> 
> > +
> > +static void ksym_trace_print_header(struct seq_file *m)
> > +{
> > +
> > +	seq_puts(m,
> > +		 "#       TASK-PID      CPU#      Symbol         Type    "
> > +		 "Function         \n");
> > +	seq_puts(m,
> > +		 "#          |           |          |              |         "
> > +		 "|            \n");
> > +}
> > +
> > +static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
> > +{
> > +	struct trace_entry *entry = iter->ent;
> > +	struct trace_seq *s = &iter->seq;
> > +	struct trace_ksym *field;
> > +	char str[KSYM_SYMBOL_LEN];
> > +	int ret;
> > +
> > +	trace_assign_type(field, entry);
> 
> Looking at this, you do not test the iter->ent->type. If events or
> trace_printk is running, this will fail your tracer.
> 
> You want to test for your types first, because all trace types will be 
> called for "print_line" function below.
> 
> Thus you want something like
> 
> 	if (entry->type != TRACE_KSYM)
> 		return TRACE_TYPE_UNHANDLED;
> 
> Then the tracer infrastructure could print out the trace event or 
> trace_printk.
> 
> If you only want to print your events and ignore all others. Return
> TRACE_TYPE_HANDLED.
> 
> Note, the if needs to be before the trace_assign_type.
> 
> -- Steve
>

Thanks for pointing that out. I will make those changes and send out a
new patchset.

However, looking at some of the existing plugins I find that many of
them do this check after trace_assign_type() or not do at all (e.g.
trace_branch_print()). They may need similar changes too.

Thanks,
K.Prasad
 
