Return-Path: <linux-kernel-owner+w=401wt.eu-S1762614AbZBYKbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762614AbZBYKbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761680AbZBYKbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:31:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34237 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760968AbZBYKbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:31:05 -0500
Date: Wed, 25 Feb 2009 11:27:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-ID: <20090225102725.GE12352@elte.hu>
References: <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org> <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org> <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com> <20090225012250.db68e480.akpm@linux-foundation.org> <1235554387.3849.30.camel@penberg-laptop> <20090225014442.7b7b7726.akpm@linux-foundation.org> <20090225095623.GB12352@elte.hu> <20090225020254.97be7715.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225020254.97be7715.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 25 Feb 2009 10:56:23 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Since the concept of a kernel tracing facility being 
> > self-sufficient and being easy to use is an integral and key 
> > concept to ftrace, dont you see why people take your 
> > suggestions as a dismissal of the ftrace concept?
> 
> Nothing I've suggested in any way makes ftrace hard to use.

Note that everything you suggest is _already possible_, if you 
switch on the 'make simple output' option. It's just that the 
human-readable format is the default one.

So i think your suggestion does make ftrace harder to use, in a 
number of ways:

 - There's one more extra tool to be installed on the target
   machine. That target machine might not even have any build
   environment - but tracing on it can still be very useful to 
   pin down bugs and regressions.

   Self-sufficient kernel instrumentation is a key concept to
   usability.

 - That tool will break the current intuitive shell-commands and 
   scripting flow that is based on human readable text output.

   In ftrace we try to strike a good balance between easy
   scriptability and pretty-printing. The two go hand in hand 
   usually so it's not a big task. If you look at the current 
   /debug/tracing/trace output you'll find a lot of small 
   details that we've put in there to make it easy to script - 
   while still being nice to read. [suggestions to improve it 
   are welcome.]

   Your suggestion pushes that completely to the 'minimal 
   output' direction, with no tangible benefit to scripting, and 
   with a lot of damage to readability and usability. A separate
   pretty-printing tool would just add an extra unnecessary step
   and would make the workflow more clumsy. This too is a clear
   step backwards.

 - Plus the extra effort of defining APIs and ABIs to it and the
   extra effort to make it work on all kernel versions. It all
   takes away resources from making tracing more useful in
   practice so it indirectly hurts instrumentation usability. 

   Tracing development manpower is a zero-sum game. If you force 
   people to maintain silly APIs you take away time from other, 
   more important areas. It might even be a negative-sum game: 
   developing something that looks ugly and is hard to use 
   attracts less developers. Tracing under Linux was in such a
   zombie state for a decade and ftrace clearly changed that 
   picture. I dont subscribe to the view that tracing has to be
   stupid and boring.

I.e. i dont see many upsides of your suggestion, and i see a lot 
of downsides.

IMO pretty-printing in the kernel should not be made a religious 
argument but a technical argument. Pretty-printing is a tool, 
and as a tool it sometimes can be used for silly purposes, and 
sometimes it can be used for helpful purposes. You seem to argue 
that doing it in the kernel is always silly - and i strongly 
disagree with that and consider it an extreme-end position - for 
the reasons outlined above.

	Ingo
