Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbZCJKIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbZCJKIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 06:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZCJKIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 06:08:39 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:52774 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZCJKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 06:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SjR42bkqKP3/NOfxBGodRZiCDx3mZpSTbyCJ0Yt7PITnjBK/CzNRsC0MlwvSDIvAoV
         fVVoEmcj5+7a2WXL5prA2xngbwQ3HDzMkdoD1xjabUcJbh31aNNRcyov8ObFrMPIa7qH
         5BWj2MrWRjdacUGNnPlZtDlhC4xqIQTK+FQF4=
Date: Tue, 10 Mar 2009 11:08:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 1/2] tracing/ftrace: syscall tracing infrastructure
Message-ID: <20090310100831.GC6825@nowhere>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-2-git-send-email-fweisbec@gmail.com> <20090307074917.GA5749@nowhere> <alpine.DEB.2.00.0903090947450.2203@gandalf.stny.rr.com> <20090309204748.GD5010@nowhere> <alpine.DEB.2.00.0903092050580.2203@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903092050580.2203@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 08:52:00PM -0400, Steven Rostedt wrote:
> 
> 
> On Mon, 9 Mar 2009, Frederic Weisbecker wrote:
> 
> > On Mon, Mar 09, 2009 at 09:52:20AM -0400, Steven Rostedt wrote:
> > > 
> > > On Sat, 7 Mar 2009, Frederic Weisbecker wrote:
> > > > +
> > > > +
> > > > +static atomic_t refcount;
> > > > +
> > > > +enum print_line_t
> > > > +print_syscall_enter(struct trace_iterator *iter, int flags)
> > > > +{
> > > > +	struct trace_seq *s = &iter->seq;
> > > > +	struct trace_entry *ent = iter->ent;
> > > > +	struct syscall_trace_enter *trace;
> > > > +	enum syscall_trace_nr syscall;
> > > > +	const struct syscall_trace_entry *entry;
> > > > +	char *str = NULL;
> > > > +	int i, ret;
> > > > +
> > > > +	trace_assign_type(trace, ent);
> > > > +
> > > > +	syscall = trace->nr;
> > > > +
> > > > +	if (!syscall || syscall >= __SYSCALL_TRACE_END)
> > > 
> > > You still need to print a "\n" otherwise the output of the next line
> > > will start on the current line.
> > 
> > Are you sure?
> > This entry will be ignored. And the previous one did print a newline.
> > So the next one should not have any problem.
> 
> Does this take over the printline? Otherwise we could be printing a 
> header, (comm, timestamp, cpu, etc).
> 
> -- Steve

Ah ok, I did not think of the headers.

