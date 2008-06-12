Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYFLQyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYFLQyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYFLQx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:53:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:47197 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbYFLQxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:53:55 -0400
Subject: Re: Kernel marker has no performance impact on ia64.
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20080612155332.GA16658@redhat.com>
References: <48447052.3030300@redhat.com>
	 <1212445965.6269.22.camel@lappy.programming.kicks-ass.net>
	 <20080602232135.GA20173@Krystal>
	 <1212618449.19205.35.camel@lappy.programming.kicks-ass.net>
	 <20080604232241.GA8488@Krystal>
	 <1212653539.19205.47.camel@lappy.programming.kicks-ass.net>
	 <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins>
	 <20080612155332.GA16658@redhat.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 18:53:41 +0200
Message-Id: <1213289621.31518.128.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 11:53 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Thu, Jun 12, 2008 at 04:27:03PM +0200, Peter Zijlstra wrote:
> > [...]
> > > Well, the string contains each field name and type. Therefore, SystemTAP
> > > can hook on a marker and parse the string looking for some elements by
> > > passing a NULL format string upon probe registration. Alternatively, it
> > > can provide the exact format string expected when it registers its probe
> > > to the marker and a check will be done to verify that the format string
> > > passed along with the registered probe matches the marker format string.
> > 
> > Yes, I get that, its one of the ugliest things I've met in this whole
> > marker story. Why can't stap not insert a normal trace handler that
> > extracts the information from prev/next it wants? [...]
> 
> Think this through.  How should systemtap (or another user-space
> separate-compiled tool like lttng) do this exactly?

lttng has trace handlers to write data into some buffer, right?
The trace point need not be concerned with which data, nor into what
buffer.

> (a) rely on debugging information?  Even assuming we could get proper
>     anchors (PC addresses or unambiguous type names) to start
>     searching dwarf data, we lose a key attractions of markers: that
>     it can robustly transfer data *without* dwarf data kept around.

Perhaps you can ship a reduced set of dwarf info tailored to contain the
bits you need, like where to find ->pid in struct task_struct. Or you
can hook into the lttng tracer.

> (b) rely on hand-written C code (prototypes, pointer derefrencing
>     wrappers) distributed with systemtap?  Not only would this be a
>     brittle maintenance pain in the form of cude duplication, but then
>     errors in it couldn't even be detected until the final C
>     compilation stage.  That would make a lousy user experience.

Not really sure what you mean here - I throught compile time errors were
the goal?!

> (c) have systemtap try to parse the mhiramat-proposed "(struct
>     task_struct * next, struct task_struct * prev)" format strings?
>     Then we're asking systemtap to parse potentially general C type
>     expressions, find the kernel headers that declare the types?
>     Parse available subfields?  That seems too much to ask for.

tcc and sourcefs sound like way fun ;-)

> (d) or another way?

Get your own tracer in kernel - that provides exactly what stap needs?


