Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbYEVOYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbYEVOYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 10:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYEVOYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 10:24:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61498 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYEVOYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 10:24:10 -0400
Date: Thu, 22 May 2008 10:24:07 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: trace_mark ugliness
Message-ID: <Pine.LNX.4.58.0805220949560.14724@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mathieu,

I'm working back on ftrace and I see that you have a lot of updates with
the trace markers there. I'm going about cleaning up the code since some
of the changes broke some of the functionality of ftrace.

That's not a big deal, the breakage is easily fixed, and it's not taking
much of my time. But I've been discussing the trace_mark itself with Peter
Zijlstra and it still makes us cringe when we see it.

The thing that bothers us the most is the force use of the "pretty print"
interface. There's got to be a better way. I'd much rather see a
file_marker.h file that has the interfaces defined, like what we have for
sched.c.

Where we have a sched_trace.h that has the defined prototypes. That is
what the tracers should use too.

The trace_mark should just have the string to find the tracer, but get rid
of the "pretty print" aspect of it. Sorry, but the more I think about it,
the nastier it seems. It forces all the users to do a va_start.

I know you developed trace_mark for LTT, and that's great. But where I'm
disagreeing is that you should not force all other users of trace_mark to
conform to the LTT way when it can be easier to have LTT conform to a more
generic way.

Hence, this is what I propose.

Remove the format part altogether, the format should be checked via the
prototype. I know that you are afraid of changes to markers and that
breaking code, but honestly, that is up to the developers of the tracers
to fix. This should not be placed in the code itself. The markers
shouldn't change anyway. If there is to be a check, it should be a compile
time check (i.e. prototype compare) not a runtime check (as it is now).

I like the rest of trace_mark, it is just this print format ugliness that
boths me (and others). It is very clumsy to work with. There just has to
be a better way here.

As for LTT, you can make your own LTT wrapper to add the print formats for
userspace. Lets not force this on other traces like ftrace that just
wastes time hopping over the parameters that it doesn't need.

Thanks,

-- Steve

