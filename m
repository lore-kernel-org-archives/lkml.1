Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZCTUOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZCTUOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZCTUN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:13:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42493 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZCTUN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:13:58 -0400
Message-ID: <49C3F8FE.4050406@linux.vnet.ibm.com>
Date: Fri, 20 Mar 2009 13:13:50 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] perfcounters: record time running and time   enabled
 for each counter
References: <18883.34555.748843.35920@cargo.ozlabs.ibm.com>
In-Reply-To: <18883.34555.748843.35920@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Impact: new functionality
> 
> Currently, if there are more counters enabled than can fit on the CPU,
> the kernel will multiplex the counters on to the hardware using
> round-robin scheduling.  That isn't too bad for sampling counters, but
> for counting counters it means that the value read from a counter
> represents some unknown fraction of the true count of events that
> occurred while the counter was enabled.
> 
> This remedies the situation by keeping track of how long each counter
> is enabled for, and how long it is actually on the cpu and counting
> events.  These times are recorded in nanoseconds using the task clock
> for per-task counters and the cpu clock for per-cpu counters.
> 
> These values can be supplied to userspace on a read from the counter.
> Userspace requests that they be supplied after the counter value by
> setting the PERF_FORMAT_TIME_ENABLED and/or PERF_FORMAT_TIME_RUNNING
> bits in the hw_event.read_format field when creating the counter.
> (There is no way to change the read format after the counter is
> created, though it would be possible to add some way to do that.)
[snip]

This would make the implementation of PAPI simpler than using software 
CPU timers attached to each group (which I have prototyped).

I'm a little confused about the ABI, though.  I see that I can specify 
which times I want to be able to read, but the order that they appear in 
the stream seems to be unstated.  I tried to figure it out by looking at 
  the kernel code, but there is no reference to PERF_FORMAT_TIME_ENABLED 
or PERF_FORMAT_TIME_RUNNING in the patch (besides the definition).


Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

