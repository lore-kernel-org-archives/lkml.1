Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYJIWl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYJIWl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 18:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYJIWlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 18:41:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57644 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYJIWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 18:41:17 -0400
Subject: Re: Building a tracing userspace tool in the kernel tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <48EE871A.2030302@nortel.com>
References: <20081009191626.GA29344@Krystal>
	 <1223590513.7382.45.camel@lappy.programming.kicks-ass.net>
	 <48EE871A.2030302@nortel.com>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 00:40:49 +0200
Message-Id: <1223592050.7382.48.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 16:35 -0600, Chris Friesen wrote:
> Peter Zijlstra wrote:
> > On Thu, 2008-10-09 at 15:16 -0400, Mathieu Desnoyers wrote:
> > 
> >>Hi Sam,
> >>
> >>At the kernel summit, people seemed to be interested to have the basic
> >>userspace tools required to extract and pretty-print a trace available
> >>within the kernel tree. Therefore, what I am trying to do is something
> >>along the lines of
> >>
> >>ltt/usr/
> >>ltt/usr/tracectl/    (control tracing)
> >>ltt/usr/tracesplice/ (splice buffers to disk)
> >>ltt/usr/tracecat/    (merge sort and format the binary buffers into
> >>                      human-readable text)
> > 
> > 
> > I'd rather have you provide that interface from the kernel much like
> > ftrace does. So we can do:
> > 
> > # cat /debug/tracing/lttng/trace
> > 
> 
> Do we really want to reserve memory in the kernel to store all the data? 
>   Assuming not, do we really want to have to deal with filesystem 
> namespaces in the kernel when interpreting which file we want to log to?

Not quite sure I get what you mean here. The kernel already needs the
memory anyway, as we keep the trace buffers in memory in either case.

All this does is provide a debugfs interface that does the exact same
thing the tracecat proglet would otherwise do.

I don't know how filesystem namespaces and debugfs interact, but seeing
as non of the debugfs users seem to be bothered with that, I don't see
why we should be.


