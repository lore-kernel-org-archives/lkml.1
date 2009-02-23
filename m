Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZBWLLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZBWLLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZBWLLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:11:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZBWLLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:11:42 -0500
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
In-Reply-To: <20090222122424.GA9951@redhat.com>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com>
	 <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu>
	 <1235302980.4632.8.camel@laptop> <y0mocwuptbc.fsf@ton.toronto.redhat.com>
	 <1235304876.4632.10.camel@laptop>  <20090222122424.GA9951@redhat.com>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 12:11:27 +0100
Message-Id: <1235387487.4645.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-22 at 07:24 -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> On Sun, Feb 22, 2009 at 01:14:36PM +0100, Peter Zijlstra wrote:
> > > > I would like to never merge an ftrace_printk() user... just as I'd like
> > > > to get rid of every marker.
> > > 
> > > But why?  They solve a problem well enough that Ingo had in effect
> > > reinvented them on Friday.
> > 
> > Because after a printk() debug spree, I don't commit them, I toss them
> > out and keep the fix.
> 
> Markers solve a problem closer to tracepoints than to debugging
> printk's.

Not so. In both cases the regular stuff (NMI trace, OOPS,
function/graph/sched trace, etc) is not enough and you wish to augment
its output.

> In this context, the main difference between tracepoints is that
> markers need almost no hand-written glue code of the sort that make up
> ftrace engines that just trace simple values.  Simpler & smaller code
> for the same output seems like a win.

Right, for dumb tracers that's true I suppose, however any
high-bandwidth tracer will try to avoid putting silly ASCII strings in
and will therefore need to write more glue code.

Which reduces these default thingies to printk() level debugging.

