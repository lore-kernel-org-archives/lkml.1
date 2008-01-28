Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYA1SeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYA1SeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYA1Sdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:33:49 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:57791 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbYA1Sdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:33:46 -0500
X-Greylist: delayed 51841 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 13:33:46 EST
Message-ID: <479E1FD4.5040606@qualcomm.com>
Date: Mon, 28 Jan 2008 10:32:52 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <srostedt@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Paul Jackson <pj@sgi.com>
Subject: Re: [CPUISOL] CPU isolation extensions
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com> <1201511305.6149.30.camel@lappy>
In-Reply-To: <1201511305.6149.30.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Peter Zijlstra wrote:
> [ You really ought to CC people :-) ]
I was not sure who though :)
Do we have a mailing list for scheduler development btw ?
Or it's just folks that you included in CC ?
Some of the latest scheduler patches brake things that I'm doing and I'd like to make
them configurable (RT watchdog, etc).
 
> On Sun, 2008-01-27 at 20:09 -0800, maxk@qualcomm.com wrote:
>> Following patch series extends CPU isolation support. Yes, most people want to virtuallize 
>> CPUs these days and I want to isolate them :).
>> The primary idea here is to be able to use some CPU cores as dedicated engines for running
>> user-space code with minimal kernel overhead/intervention, think of it as an SPE in the 
>> Cell processor.
>>
>> We've had scheduler support for CPU isolation ever since O(1) scheduler went it. 
>> I'd like to extend it further to avoid kernel activity on those CPUs as much as possible.
>> In fact that the primary distinction that I'm making between say "CPU sets" and 
>> "CPU isolation". "CPU sets" let you manage user-space load while "CPU isolation" provides
>> a way to isolate a CPU as much as possible (including kernel activities).
> 
> Ok, so you're aware of CPU sets, miss a feature, but instead of
> extending it to cover your needs you build something new entirely?
It's not really new. CPU isolation bits just has not been exported before that's all.
Also "CPU sets" seem to mostly deal with the scheduler domains. I'll reply to Paul's 
proposal to use that instead.

>> I'm personally using this for hard realtime purposes. With CPU isolation it's very easy to 
>> achieve single digit usec worst case and around 200 nsec average response times on off-the-shelf
>> multi- processor/core systems under exteme system load. I'm working with legal folks on releasing 
>> hard RT user-space framework for that.
>> I can also see other application like simulators and stuff that can benefit from this.
> 
> have you been using just this, or in combination with the -rt effort?
Just this patches. RT patches cannot achieve what I needed. Even RTAI/Xenomai can't do that.
For example I have separate tasks with hard deadlines that must be enforced in 50usec kind 
of range and basically no idle time whatsoever. Just to give more background it's a wireless
basestation with SW MAC/Scheduler. Another requirement is for the SW to know precise timing
because SW. For example there is no way we can do predictable 1-2 usec sleeps. 
So I wrote a user-space engine that does all this, it requires full control of the CPU ie minimal
overhead from the kernel, just IPIs for memory management and that's basically it. When my legal 
department lets me I'll do a presentation on this stuff at Linux RT conference or something. 

Max
