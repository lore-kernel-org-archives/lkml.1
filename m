Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYJDQxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYJDQxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 12:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYJDQxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 12:53:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:58028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbYJDQxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 12:53:08 -0400
Date: Sat, 4 Oct 2008 09:52:57 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Add a C-state tracer to help power optimization
Message-ID: <20081004095257.41ba3703@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0810032003140.17863@gandalf.stny.rr.com>
References: <20081003165533.249261b1@infradead.org>
	<alpine.DEB.1.10.0810032003140.17863@gandalf.stny.rr.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 20:32:51 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:
> > +struct trace_cstate {
> > +	struct trace_entry	ent;
> > +	struct cstate_trace	state_data;
> > +};
> > +
> 
> Can you please register this in the trace_assign_type macro.
> 
> 	IF_ASSIGN(var, ent, struct trace_cstate, TRACE_BOOT); \

I don't see this anywhere in the kernel ;(

> And here, do not typecast. Use the trace_assign_type macro below.

nor that guy


> 
> > +	struct cstate_trace *it = &field->state_data;
> > +	struct trace_seq *s = &iter->seq;
> > +	struct timespec stamp = ktime_to_timespec(it->stamp);
> 
> Also note that iter->ts holds a timestamp counter from bootup in
> nanosecs. It currently uses the sched_clock to record, but may change
> later to something a bit better.

given that some of these clocks stop during idle... I really do care
about which timestamp is used, tracing idle with a clock that stops
during idle won't work too well.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
