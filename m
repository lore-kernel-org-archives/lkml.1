Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZBYNCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZBYNCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZBYNB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:01:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58584 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbZBYNBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:01:55 -0500
Date: Wed, 25 Feb 2009 08:01:51 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH 1/4] tracing: add DEFINE_TRACE_FMT to tracepoint.h
In-Reply-To: <1235543227.4645.2907.camel@laptop>
Message-ID: <alpine.DEB.2.00.0902250758100.12697@gandalf.stny.rr.com>
References: <20090225025608.956691460@goodmis.org>  <20090225025753.547618424@goodmis.org> <1235543227.4645.2907.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Feb 2009, Peter Zijlstra wrote:

> On Tue, 2009-02-24 at 21:56 -0500, Steven Rostedt wrote:
> 
> > +#define DEFINE_TRACE_FMT(name, proto, args, fmt)		\
> > +	DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
> > +
> 
> If TPPROTO and TPARGS were anything but empty stubs, the above would add
> them twice, no?

I guess I can rename them too.

The problem comes from passing in more than one argument. If a proto or 
args has a comma, you get a nasty error about unmatched number of 
parameters.

I believe that they were purposely made to be empty stubs to allow for 
multiple parameters. But you are right, if that changes we need to fix it.

Since the above is only to protect against the substitution into multiple 
parameters, we could probably create a new macro name to just be

 #define PARAMS(args...) args
 #define DEFINE_TRACE_FMT(name, proto, args, fmt) \
	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))

-- Steve

