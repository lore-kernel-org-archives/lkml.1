Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZBWPos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZBWPos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbZBWPoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:44:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55758 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440AbZBWPoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:44:37 -0500
Date: Mon, 23 Feb 2009 10:44:04 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090223154404.GA30147@redhat.com>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <1235302980.4632.8.camel@laptop> <y0mocwuptbc.fsf@ton.toronto.redhat.com> <1235304876.4632.10.camel@laptop> <20090222122424.GA9951@redhat.com> <1235387487.4645.28.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235387487.4645.28.camel@laptop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Mon, Feb 23, 2009 at 12:11:27PM +0100, Peter Zijlstra wrote:
> [...]
> > > Because after a printk() debug spree, I don't commit them, I toss them
> > > out and keep the fix.
> > 
> > Markers solve a problem closer to tracepoints than to debugging
> > printk's.

> Not so. In both cases the regular stuff (NMI trace, OOPS,
> function/graph/sched trace, etc) is not enough and you wish to
> augment its output.

Sorry, I don't see how that relates.  If the general function tracing
widgetry is insufficient for some subsystem/purpose, some sort of
static instrumentation is needed.  Whether that instrumentation is
done by markers (with a thin glue to ftrace) or by tracepoints (with a
thick glue to ftrace) doesn't change the need for "augmentation".


> > In this context, the main difference between tracepoints is that
> > markers need almost no hand-written glue code of the sort that make up
> > ftrace engines that just trace simple values.  Simpler & smaller code
> > for the same output seems like a win.
> 
> Right, for dumb tracers that's true I suppose, however any
> high-bandwidth tracer will try to avoid putting silly ASCII strings in
> and will therefore need to write more glue code.

So let's leave it up to the wisdom of each subsystem maintainer to
decide whether any particular trace event is high enough throughput
that direct ASCII rendering is not favourable.  (Considering the
finite size of tracing buffers, high-throughput trace events would
need to be continually drained with ASCII conversion anyway, so the
overall benefit of using packed binary as an intermediate copy may not
be large after all.)

I see all this as an argument to keep the subsystem's options open.
Sometimes the extra complexity of tracepoints is worth it, sometimes
it isn't.

- FChE
