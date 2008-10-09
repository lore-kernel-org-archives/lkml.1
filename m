Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbYJIXLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbYJIXLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYJIXLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:11:43 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:64009 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYJIXLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:11:42 -0400
Message-ID: <48EE8FA4.8040003@nortel.com>
Date: Thu, 09 Oct 2008 17:11:32 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Building a tracing userspace tool in the kernel tree
References: <20081009191626.GA29344@Krystal> <1223590513.7382.45.camel@lappy.programming.kicks-ass.net> <48EE871A.2030302@nortel.com> <1223592050.7382.48.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223592050.7382.48.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2008 23:11:36.0181 (UTC) FILETIME=[608E6250:01C92A64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-10-09 at 16:35 -0600, Chris Friesen wrote:
>>Peter Zijlstra wrote:
>>>On Thu, 2008-10-09 at 15:16 -0400, Mathieu Desnoyers wrote:

>>>>At the kernel summit, people seemed to be interested to have the basic
>>>>userspace tools required to extract and pretty-print a trace available
>>>>within the kernel tree. Therefore, what I am trying to do is something
>>>>along the lines of
>>>>
>>>>ltt/usr/
>>>>ltt/usr/tracectl/    (control tracing)
>>>>ltt/usr/tracesplice/ (splice buffers to disk)
>>>>ltt/usr/tracecat/    (merge sort and format the binary buffers into
>>>>                     human-readable text)

>>>I'd rather have you provide that interface from the kernel much like
>>>ftrace does. So we can do:
>>>
>>># cat /debug/tracing/lttng/trace

>>Do we really want to reserve memory in the kernel to store all the data? 
>>  Assuming not, do we really want to have to deal with filesystem 
>>namespaces in the kernel when interpreting which file we want to log to?
> 
> 
> Not quite sure I get what you mean here. The kernel already needs the
> memory anyway, as we keep the trace buffers in memory in either case.
> 
> All this does is provide a debugfs interface that does the exact same
> thing the tracecat proglet would otherwise do.
> 
> I don't know how filesystem namespaces and debugfs interact, but seeing
> as non of the debugfs users seem to be bothered with that, I don't see
> why we should be.

Maybe I misunderstood something.  I was under the impression that the 
standard LTT usage is to stream raw trace data to disk and then 
post-process it.  If we're writing to disk, we should probably think 
about filesystem namespaces.

Chris
