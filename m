Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYIRH0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYIRH0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYIRH01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:26:27 -0400
Received: from pih-relay08.plus.net ([212.159.14.20]:46644 "EHLO
	pih-relay08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYIRH00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:26:26 -0400
Message-ID: <48D202A0.5070401@yahoo.com>
Date: Thu, 18 Sep 2008 08:26:24 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <fa.ERZTl/6uH+mhNoef5fPJKTRjJag@ifi.uio.no> <fa.PtPFzP5kIJVCCov6YCewrh+o4z4@ifi.uio.no> <fa.C6WSm5Rh2Nb+Qho7b0qDOZ9RPV8@ifi.uio.no> <fa.ch6j4qXs/2sFpLkHz5fXrtjTR8c@ifi.uio.no> <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no>
In-Reply-To: <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 93aab519ac05c6aaf005956b5570cc90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2008-09-17 at 14:54 -0700, Arjan van de Ven wrote:
>> On Wed, 17 Sep 2008 22:48:55 +0100
>>
>>>> Cause                                                Maximum
>>>>
>> Percentage 
>>
>> Scheduler: waiting for cpu                        208 msec         59.4 %
>>
>>
>> you're rather CPU bound, and your process was woken up but didn't run for over 200 milliseconds..
>> that sounds like a scheduler fairness issue!
> 
> Really hard subject. Perfect fairness requires 0 latency - which with a
> CPU only being able to run one thing at a time is impossible. So what
> latency ends up being is a measure for the convergence towards fairness.
> 
> Anyway - 200ms isn't too weird depending on the circumstances. We start
> out with a 20ms latency for UP, we then multiply with 1+log2(nr_cpus)
> which in say a quad core machine ends up with 60ms. That ought to mean
> that under light load the max latency should not exceed twice that
> (basically a consequence of the Nyquist-Shannon sampling theorem IIRC).
> 
> Now, if you get get under some load (by default: nr_running > 5) the
> expected latency starts to linearly grow with nr_running.
> 
>>From what I gather from the reply to this email the machine was not
> doing much (and after having looked up the original email I see its a
> eeeeeeeee atom - which is dual cpu iirc, so that yields 40ms default) -
> so 200 is definately on the high side.

No, it's not an eeeeee atom. It's an eee celeron M (900Mhz) so it's 
definitely a single CPU with no hyperthreading (and SMP is not enabled 
in the kernel config either). It has less grunt that the atom and can't 
do cpu scaling either (although it seems to have C states).

The load average is less than 0.5 but obviously I don't know if it is 
periodically spiking over 5 and then smoothing out.

> What you can do to investigate this, is use the sched_wakeup tracer from
> ftrace, that should give a function trace of the highest wakeup latency
> showing what the kernel is doing.

Thanks for the hint - I was wondering where to look next.
