Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbZBYQJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbZBYQJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759395AbZBYQJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:09:16 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:65486 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758784AbZBYQJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:09:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAEj6pElMQWWY/2dsb2JhbACBb9dshBEG
Date: Wed, 25 Feb 2009 11:09:03 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20090225160903.GA11295@Krystal>
References: <20090225025608.956691460@goodmis.org> <20090225025753.547618424@goodmis.org> <1235543227.4645.2907.camel@laptop> <alpine.DEB.2.00.0902250758100.12697@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902250758100.12697@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:08:15 up 4 days,  7:42,  2 users,  load average: 0.43, 0.35,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Wed, 25 Feb 2009, Peter Zijlstra wrote:
> 
> > On Tue, 2009-02-24 at 21:56 -0500, Steven Rostedt wrote:
> > 
> > > +#define DEFINE_TRACE_FMT(name, proto, args, fmt)		\
> > > +	DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
> > > +
> > 
> > If TPPROTO and TPARGS were anything but empty stubs, the above would add
> > them twice, no?
> 
> I guess I can rename them too.
> 
> The problem comes from passing in more than one argument. If a proto or 
> args has a comma, you get a nasty error about unmatched number of 
> parameters.
> 
> I believe that they were purposely made to be empty stubs to allow for 
> multiple parameters. But you are right, if that changes we need to fix it.
> 
> Since the above is only to protect against the substitution into multiple 
> parameters, we could probably create a new macro name to just be
> 
>  #define PARAMS(args...) args
>  #define DEFINE_TRACE_FMT(name, proto, args, fmt) \
> 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> 

Yes, I think this should work. Just be careful to test passing a "void"
function parameter to these when you make any changes. This is a
subtle corner-case.

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
