Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbYLEVY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbYLEVY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYLEVYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:24:46 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34426 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359AbYLEVYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:24:45 -0500
Message-ID: <49399C1B.7000401@us.ibm.com>
Date: Fri, 05 Dec 2008 13:24:43 -0800
From: Corey Ashford <cjashfor@us.ibm.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> > >  - No interaction with ptrace: any task (with sufficient permissions) can
>> > >    monitor other tasks, without having to stop that task.
>> > 
>> > This isn't going to work.
>> >
>> > If you look at the things the perfmon libraries do, you do need to stop 
>> > the task.
>> >
>> > Consider counter virtualization as the most direct example. [...]
>> 
>> Note that counter virtualization is not offered in the perfmon3 patchset that has 
>> been posted to lkml. (It is part of the much larger 'full' perfmon patchset which 
>> has not been submitted for integration)
>> 
>> Nevertheless we will offer counter virtualization in -v2 of our patchset [...]
> 
> i've just implemented it. Running an (infinite-loop) hello.c with 6 counters on a 
> CPU that has only two counters now gives the expected:
> 
>  counter[0 cycles              ]:           3368245084 , delta: 842019470 events
>  counter[1 instructions        ]:           1384678210 , delta: 346108294 events
>  counter[2 cache-refs          ]:                  659 , delta: 150 events
>  counter[3 cache-misses        ]:                    0 
>  counter[4 branch-instructions ]:            266919398 , delta: 66731508 events
>  counter[5 branch-misses       ]:                 1201 , delta: 315 events
> 
> This will be in -v2.
> 
> 	Ingo
>

When you use the term "virtualization" here, I think you mean "event set 
multiplexing" in perfmon terms.  When perfmon talks about 
virtualization, it's the virtualizing of a small counter (e.g. 32-bits) 
to a 64-bit counter via its overflow interrupt.  And 64-bit counter 
support is included in the perfmon3 posted to LKML.

One thing that PAPI needs is some control over which events are in each 
event "set", to use a perfmon term.  In particular, it needs to have a 
cycles counter in each set so that it can properly scale the event 
counts at the time it reads them up.

With your proposal:

* Would there be a way to force a particular event to be in every event 
set that is scheduled onto the processor?

* When monitoring program reads up the counts, how would it find the 
individual cycles count for each set?

* How would it know which other events were in the same set?

* Would it force the round robin scheduling to only a single event 
(paired with the cycles event) in each set?

* On what basis is the round robin scheduling performed?  Time?  Upon 
the overflow of an event counter?  If there is more than one option, how 
is it specified and tweaked? If time is one of the options, how does the 
caller specify the the round-robin switching rate?

These are all things that are supported in a very flexible way in 
perfmon3 (full).

Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com



