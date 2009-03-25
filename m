Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZCYCBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZCYCBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZCYCAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:00:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZCYCAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:00:53 -0400
Date: Tue, 24 Mar 2009 22:00:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 2/9] LTTng instrumentation - irq
In-Reply-To: <20090324201146.GA4350@Krystal>
Message-ID: <alpine.DEB.2.00.0903242153080.22830@gandalf.stny.rr.com>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.080628193@polymtl.ca> <20090324173354.GC3129@redhat.com> <20090324175049.GC31117@elte.hu> <20090324175750.GE3129@redhat.com> <20090324191252.GA11665@elte.hu> <20090324201146.GA4350@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Mar 2009, Mathieu Desnoyers wrote:
> 
> This is actually a very good example of what Christoph Hellwig, Peter
> Zijlstra and myself have been trying to warn you about the TRACE_EVENT
> macro : it exports the tracepoints to userspace, and thus makes them a
> userspace-visible API, when those tracepoints should be tied to the
> kernel code and nothing else. An adaptation layer should provide the
> abstractions that makes the information presented to the user more
> "logical".

Let me correct you here. TRACE_EVENT does ***NOT*** export anything to 
userspace. There is no code what so ever in TRACE_EVENT that does so.

Now, ftrace does export information using TRACE_EVENT to userspace. But 
that is the way ftrace wants to handle it. There's nothing needed to 
export to userspace. What is exported, is exported ***BECAUSE*** it can 
change. I'll only try to keep the format that is exported the same. But 
nothing should rely on what the format represents staying the same.

If someone adds a TRACE_EVENT, you can uses it to record you data, anyway
you like. Ftrace will use it to show how to read the binary data, which
is only needed if you want to do that. It uses the print format to print
to the console in case of failure. Or to the trace file, which by the way
can also change without notice.


-- Steve

