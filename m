Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYJDRP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYJDRP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 13:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYJDRPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 13:15:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58939 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYJDRPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 13:15:10 -0400
Date: Sat, 4 Oct 2008 13:15:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Add a C-state tracer to help power
 optimization
In-Reply-To: <20081004095257.41ba3703@infradead.org>
Message-ID: <alpine.DEB.1.10.0810041314150.6571@gandalf.stny.rr.com>
References: <20081003165533.249261b1@infradead.org> <alpine.DEB.1.10.0810032003140.17863@gandalf.stny.rr.com> <20081004095257.41ba3703@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 4 Oct 2008, Arjan van de Ven wrote:

> On Fri, 3 Oct 2008 20:32:51 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> > > +struct trace_cstate {
> > > +	struct trace_entry	ent;
> > > +	struct cstate_trace	state_data;
> > > +};
> > > +
> > 
> > Can you please register this in the trace_assign_type macro.
> > 
> > 	IF_ASSIGN(var, ent, struct trace_cstate, TRACE_BOOT); \
> 
> I don't see this anywhere in the kernel ;(
> 
> > And here, do not typecast. Use the trace_assign_type macro below.
> 
> nor that guy

The two should be in linux-tip. If you are based against mainline, then
no they will not be.

If you are already using linux-tip, try refreshing.


> 
> 
> > 
> > > +	struct cstate_trace *it = &field->state_data;
> > > +	struct trace_seq *s = &iter->seq;
> > > +	struct timespec stamp = ktime_to_timespec(it->stamp);
> > 
> > Also note that iter->ts holds a timestamp counter from bootup in
> > nanosecs. It currently uses the sched_clock to record, but may change
> > later to something a bit better.
> 
> given that some of these clocks stop during idle... I really do care
> about which timestamp is used, tracing idle with a clock that stops
> during idle won't work too well.
> 

OK, I just wanted to let you know about it.

-- Steve

