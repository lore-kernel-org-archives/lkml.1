Return-Path: <linux-kernel-owner+w=401wt.eu-S1761766AbZBYQeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761766AbZBYQeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZBYQd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:33:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36147 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZBYQd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:33:57 -0500
Date: Wed, 25 Feb 2009 17:33:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] tracing: add DEFINE_TRACE_FMT to tracepoint.h
Message-ID: <20090225163309.GA14046@elte.hu>
References: <20090225025608.956691460@goodmis.org> <20090225025753.547618424@goodmis.org> <20090225161335.GB11295@Krystal> <alpine.DEB.2.00.0902251125490.12697@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902251125490.12697@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 25 Feb 2009, Mathieu Desnoyers wrote:
> 
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > This patch creates a DEFINE_TRACE_FMT to map to DECLARE_TRACE.
> > > This allows for the developers to place format strings and
> > > args in with their tracepoint declaration. A tracer may now
> > > override the DEFINE_TRACE_FMT macro and use it to record
> > > a default format.
> > > 
> > 
> > Hi Steven,
> > 
> > How comes does a DEFINE_* maps to a DECLARE_* ?
> > 
> > Usually, DEFINE_* are meant to be put in .c files. DECLARE_* are in
> > headers. I don't see how the mapping you propose here can be
> > semantically correct ?
> 
> Because it can be either a define or a declare ;-)
> 
> Gag, I can't win! First Andrew points out that I use 
> DECLARE_TRACE_FMT when it should be a DEFINE. Now I go change 
> it and you state that it should be a DECLARE not a DEFINE!
> 
> Well, any tracer that remaps it, it should be a DEFINE. Just 
> in the "default" case of trace points, is it used as a 
> DECLARE. Because, it ignores the fmt parameter that would be 
> used in the define.

Add either both or none of them. I'd suggest the latter ;-)

TRACE_FORMAT() would be perfect.

	Ingo
