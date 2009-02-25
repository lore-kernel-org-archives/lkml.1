Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbZBYOWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbZBYOWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZBYOW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:22:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43267 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbZBYOW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:22:28 -0500
Date: Wed, 25 Feb 2009 09:19:49 -0500
From: Jason Baron <jbaron@redhat.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 0/4][RFC] event tracer
Message-ID: <20090225141948.GA3123@redhat.com>
References: <20090224193344.638329210@goodmis.org> <20090225021033.GA17269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225021033.GA17269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 09:10:33PM -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> > This is still RFC, do not pull.
> > This patch set gives the ability to add a format string and args to
> > a trace point declaration. [...]
> 
> It looks like a good compromise, a dual to the trace_mark_tp
> prototype, and a plausible replacement for markers.  Thank you.  The
> main thing this would lose is a callback API to intercept generic
> varargs event flavour, which we in systemtap land enjoy using, but
> before too long we would make do.
> 

Along these lines, I think it should be possible to have
'DEFINE_TRACE_FMT' define an additional tracepoint with a
signature that is simply a fomat string and a list of args. This
tracpoint is then what could be registred with the original tracepoint.
Then, event_trace_printk can be registered with this additional
tracepoint. In this way different consumers would be able to register
not only with the oringal tracepoint, but also with a format string
callback version of it. this obviously adds extra functions call, but at
the advantage of additional flexibility. If ppl think this makes sense,
I can prototype a patch.

thanks,

-Jason

