Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZDPCDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZDPCDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZDPCCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:02:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47465 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZDPCCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:02:52 -0400
Date: Wed, 15 Apr 2009 22:02:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with CREATE_TRACE_POINTS and recursion safety
In-Reply-To: <49E6847B.9000003@goop.org>
Message-ID: <alpine.DEB.2.00.0904152201390.4459@gandalf.stny.rr.com>
References: <49E67D1D.8020704@goop.org> <alpine.DEB.2.00.0904152042350.4459@gandalf.stny.rr.com> <49E6847B.9000003@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 15 Apr 2009, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > On Wed, 15 Apr 2009, Jeremy Fitzhardinge wrote:
> > 
> >   
> > > I'm having a problem with CREATE_TRACE_POINTS being too indiscriminate.
> > > The
> > > trouble is that it not only creates tracepoint definitions for the
> > > intended
> > > tracepoints, but any other tracepoint definitions which get included
> > > incidentally.
> > > 
> > > For example, I'm seeing my paravirt tracepoints being instantiated in both
> > > kernel/sched.o and kernel/irq/manage.o as side-effects of the scheduler
> > > and
> > > irq tracepoints being instantiated.
> > > 
> > > I'm experimenting with a different scheme, wherein a subsystem defines
> > > CREATE_FOO_TRACE_POINTS in the .c file where it wants to instantiate the
> > > tracepoints - rather than CREATE_TRACE_POINTS - and its trace/events/foo.h
> > > does:
> > > 
> > >    #ifdef CREATE_FOO_TRACE_POINTS
> > >    #undef CREATE_FOO_TRACE_POINTS	/* avoid infinite recursion */
> > >    #include <trace/instantiate_trace.h>
> > >    #else
> > >    #include <trace/define_trace.h>
> > >    #endif
> > > 
> > > where instantiate_trace.h is:
> > > 
> > >    #define CREATE_TRACE_POINTS
> > >    #include <trace/define_trace.h>
> > >    #undef CREATE_TRACE_POINTS

Have you tried:

#ifdef CREATE_PVOPS_TRACE_POINTS
#define CREATE_TRACE_POINTS
#include <trace/define_trace.h>
#undef CREATE_TRACE_POINTS
#endif

And in your C file do:

#define CREATE_PVOPS_TRACE_POINTS
#include <trace/pvops.h>

??

-- Steve
