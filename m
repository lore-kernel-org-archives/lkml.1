Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZBBW3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZBBW3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZBBW3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:29:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38819 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZBBW3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:29:09 -0500
Date: Mon, 2 Feb 2009 20:28:36 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 0/3] tracing/blkftrace improvements
Message-ID: <20090202222836.GA12082@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4982c159.190c660a.7424.ffffabf9@mx.google.com> <alpine.DEB.1.10.0901301155300.6222@gandalf.stny.rr.com> <20090130172102.GB8754@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130172102.GB8754@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 30, 2009 at 03:21:02PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Jan 30, 2009 at 11:56:41AM -0500, Steven Rostedt escreveu:
> > 
> > Frederic and Arnaldo,
> > 
> > I'm fine with this change. Are there other changes you are going to put on 
> > top of this, or should I wait for new stuff before pulling it in and 
> > sendingo it to Ingo?
> 
> Steve, please wait a bit, I'm reworking these changes so that they have
> a first solid user in blktrace, I'll post it later today.

OK, here it is, please take a look to see if it is acceptable.

Frederic, I kept you as the author for the first patch, as I just
trimmed it a little bit, lemme know if this is OK with you.

I removed the callbacks from the patch Frederic submitted, I think its
better to have the functions as a library, i.e. if a tracer wants to
disable the standard context info for one of its callbacks, it can just
call the function for the callbacks it wants.

Then I converted the tracer_event print callbacks to match the struct
trace print callback parameter list, i.e. to pass the trace_iterator,
from where we can get the trace_seq and the trace_entry, as well as
other stuff such as the timestamp.

The last patch makes use of this changes in blktrace, to provide a
binary trace that doesn't use the standard context info and that uses
the timestamp from the trace_iterator to synthesize most of  the data
expected by the userspace blktrace utilities.

In the end I think I'll have to have the per cpu sequence numbers in the
ftrace plugin to be able to provide exactly what the userspace utilities
expect as I couldn't find a way to get it from the ring_buffer or
tracing guts (struct trace_array, etc) :-\

- Arnaldo
