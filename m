Return-Path: <linux-kernel-owner+w=401wt.eu-S1761926AbZBYJ5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761926AbZBYJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbZBYJ5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:57:15 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55985 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbZBYJ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:57:15 -0500
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <20090225014442.7b7b7726.akpm@linux-foundation.org>
References: <20090225025608.956691460@goodmis.org>
	 <20090225025753.798204550@goodmis.org>
	 <20090224194548.3effb746.akpm@linux-foundation.org>
	 <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com>
	 <20090224203308.8d623e0b.akpm@linux-foundation.org>
	 <20090225081118.GC15303@elte.hu>
	 <20090225002852.5ef5b869.akpm@linux-foundation.org>
	 <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com>
	 <20090225012250.db68e480.akpm@linux-foundation.org>
	 <1235554387.3849.30.camel@penberg-laptop>
	 <20090225014442.7b7b7726.akpm@linux-foundation.org>
Date: Wed, 25 Feb 2009 11:57:11 +0200
Message-Id: <1235555831.3849.37.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, 2009-02-25 at 01:44 -0800, Andrew Morton wrote:
> > $ grep -v "#" trace 
> >   <idle>-0     0d..1    0us+: trace_hardirqs_off_thunk (apic_timer_interrupt)
> >   <idle>-0     0d.s.   97us : __do_softirq (do_softirq)
> >   <idle>-0     0d.s1   98us : trace_hardirqs_on (do_softirq)
> > 
> > after which you have access to the raw data. This particular trace seems
> > to be somewhat hard to parse (because not all fields are whitespace
> > delimited) but I can assure you that any format I rely on is not.
> 
> yes, but now you need to think about how this interface would have been
> designed if we'd decided to access it with something smarter than
> `cat'.
> 
> I mean, look at it.  All the multi-space column lining upping, the
> unnecessary "us" annotation, the strange symbol(symbol) thing, etc. 
> Plus it would have been more self-describing.  Right now, your parser
> has to either assume that the second character of "0d..1" is
> "irqs-off", or it has to learn how to follow ascii art lines.

Multi-space columns are probably not a big problem but sure, it's better
to keep the raw data as simple as possible and put things like units in
the header.

But anyway, I'm the wrong person to talk to if you want someone to
defend that particular format. If you find similar problems with the
kmemtrace output, then sure, by all means let me know about it and we'll
fix it up.

Note: it still make sense to have a specific kind of "pretty printing"
in the kernel. For things like kmemtrace, the amount of data gets pretty
big so it's very convenient to have "summarizing formatters" like the
histogram formatter thing that's being cooked up in ftrace tree
somewhere.

			Pekka

