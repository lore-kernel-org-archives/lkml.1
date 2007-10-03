Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbXJCH76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbXJCH76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 03:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXJCH7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 03:59:52 -0400
Received: from mx12.go2.pl ([193.17.41.142]:58137 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752018AbXJCH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 03:59:51 -0400
Date: Wed, 3 Oct 2007 10:02:24 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071003080224.GB1726@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002060607.GA18588@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-10-2007 08:06, Ingo Molnar wrote:
> * David Schwartz <davids@webmaster.com> wrote:
...
>> I'm not familiar enough with CFS' internals to help much on the 
>> implementation, but there may be some simple compromise yield that 
>> might work well enough. How about simply acting as if the task used up 
>> its timeslice and scheduling the next one? (Possibly with a slight 
>> reduction in penalty or reward for not really using all the time, if 
>> possible?)
> 
> firstly, there's no notion of "timeslices" in CFS. (in CFS tasks "earn" 
> a right to the CPU, and that "right" is not sliced in the traditional 
> sense) But we tried a conceptually similar thing [...]

>From kernel/sched_fair.c:

"/*
 * Targeted preemption latency for CPU-bound tasks:
 * (default: 20ms, units: nanoseconds)
 *
 * NOTE: this latency value is not the same as the concept of
 * 'timeslice length' - timeslices in CFS are of variable length.
 * (to see the precise effective timeslice length of your workload,
 *  run vmstat and monitor the context-switches field)
..."

So, no notion of something, which are(!) of variable length, and which
precise effective timeslice lenght can be seen in nanoseconds? (But
not timeslice!)

Well, I start to think, this new scheduler could be too simple yet...


> [...] [ and this is driven by compatibility 
> goals - regardless of how broken we consider yield use. The ideal 
> solution is of course to almost never use yield. Fortunately 99%+ of 
> Linux apps follow that ideal solution ;-) ]

Nevertheless, it seems, this 1% is important enough to boast a little:

  "( another detail: due to nanosec accounting and timeline sorting,
     sched_yield() support is very simple under CFS, and in fact under
     CFS sched_yield() behaves much better than under any other
     scheduler i have tested so far. )"
				[Documentation/sched-design-CFS.txt]

Cheers,
Jarek P.
