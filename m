Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZBWRNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZBWRNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZBWRNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:13:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40145 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbZBWRNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:13:06 -0500
Date: Mon, 23 Feb 2009 12:10:32 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090223171032.GA2566@redhat.com>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <1235302980.4632.8.camel@laptop> <y0mocwuptbc.fsf@ton.toronto.redhat.com> <1235304876.4632.10.camel@laptop> <20090222122424.GA9951@redhat.com> <1235387487.4645.28.camel@laptop> <20090223154404.GA30147@redhat.com> <1235406159.4645.366.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235406159.4645.366.camel@laptop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 05:22:39PM +0100, Peter Zijlstra wrote:
> [...]
> > > Not so. In both cases the regular stuff (NMI trace, OOPS,
> > > function/graph/sched trace, etc) is not enough and you wish to
> > > augment its output.
> > 
> > Sorry, I don't see how that relates.  If the general function tracing
> > widgetry is insufficient for some subsystem/purpose, some sort of
> > static instrumentation is needed.  Whether that instrumentation is
> > done by markers (with a thin glue to ftrace) or by tracepoints (with a
> > thick glue to ftrace) doesn't change the need for "augmentation".
> 
> I'm not arguing against static instrumentation per-se (although
> expanding the coverage of dynamic/automatic instrumentation is much more
> profitable IMHO).

Much prior discussion (incl. at the kernel summit) indicates that we
need both.

> What I'm arguing is that trace_mark()s one distinguishing feature over
> tracepoints is only suited for quick debug like work.

I see where you're coming from, but one may also caricaturize the
other alternative as requiring make-work glue code to pack & unpack
all the same inforation.


> Furthermore, trace_mark() exposes that crap like an ABI, now suppose
> some distro goes and declares that stable for some daft reason,
> imagine the poor sod having to fix something littered with
> trace_mark().

The impression that this is somehow different with tracepoints is
mistaken.  Tracepoints are *exactly* as "ABI-like" as markers.


> [...]  presenting that information in big bloated blobs is beyond
> that scope.

Do you have some specific bloated blobs in mind?  It's not as if the
rendered text is necessarily much bigger than a struct containing all
the same parameters.  Consider all the fields rounded up to 4 or 8
bytes each.


- FChE
