Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZHFIUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZHFIUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbZHFIUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:20:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40384 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZHFIUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:20:45 -0400
Message-ID: <4A7A925A.90606@cs.helsinki.fi>
Date: Thu, 06 Aug 2009 11:20:42 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, acme <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       roland <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       fche <fche@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: malloc() tracing in perf?
References: <4A7A8ADD.4080208@cs.helsinki.fi> <1249546610.32113.35.camel@twins>
In-Reply-To: <1249546610.32113.35.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-08-06 at 10:48 +0300, Pekka Enberg wrote:
>> Hi,
>>
>> It's me again :-).
>>
>> I have a little user-space application that is pretty memory hungry and 
>> I want to understand why. I started to google around for a memory 
>> profiler or a malloc() tracer but didn't seem to find anything really 
>> useful.
>>
>> But then it hit me, why can't I have kmemtrace + perf but for 
>> user-space? Something like the "Malloc Trace" shown here:
>>
>> http://developer.apple.com/documentation/developertools/conceptual/SharkUserGuide/OtherProfilingandTracingTechniques/OtherProfilingandTracingTechniques.html#//apple_ref/doc/uid/TP40005233-CH6-SW17
>>
>> Does this sound like something that could/should be part of "perf"? How 
>> would all this work anyway? Can we intercept malloc() and free() 
>> somehow? Where would the data be pushed? Am I just going perf-crazy and 
>> trying to turn it into a swiss army knife because it's so easy to use?-)
> 
> OK, you just trod into a wasp's nest :-)
> 
> 
> That sounds like uprobes, the equivalent of kprobes but for userspace.
> 
> I seem to have heard people are working on such a thing, but I can't
> seem to find a single LKML post with 'uprobe' in the subject in the past
> two years or something (except for MTUprobe) -- so I guess its not
> really going anywhere any fast.
> 
> Now doing probes on userspace is hard because you need to know more
> about the userspace bits than a kernel really ought to be interested in.
> 
> Then again, the only way to extract bits from userspace is to stop it --
> now one could do that using [pu]trace and have some monitoring app prod
> at it like any other debugger would, and I think this is the approach
> suggested by some (hch iirc).
> 
> Others seem to think we ought to stuff all this into the kernel, I can
> only imagine the pain that will cause, since you need to teach the
> kernel about these instrumentation sites' context, so I can only imagine
> it'd be through a kernel module interface much like system-tap does
> (they would be doing the in-kernel bit).
> 
> Then there are the tracer folks who also want to collect userspace
> traces. Some have proposed a sys_trace() call, others want to play silly
> games with mmap() and then there is the uprobe idea. Others (tglx and
> me) proposed letting userspace log itself and post-merge all the various
> trace buffers to get a complete picture.
> 
> 
> Anyway, like you say, it has uses (potentially very powerful ones),
> Sun/Apple do it with Dtrace, Linux wants it but I don't think we quite
> agreed on how to do it :-)
> 
> 
> And here I see LKML isn't on the CC list, perhaps we should?

Oh sure, lets do that, half of the people seem to be on the CC anyway 
now :-).

			Pekka
