Return-Path: <linux-kernel-owner+w=401wt.eu-S1030666AbXCNGwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030666AbXCNGwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 02:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030670AbXCNGwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 02:52:15 -0400
Received: from gw.goop.org ([64.81.55.164]:46700 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030666AbXCNGwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 02:52:15 -0400
Message-ID: <45F79B9C.20609@goop.org>
Date: Tue, 13 Mar 2007 23:52:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>  <45F70A71.9090205@goop.org>	 <1173821224.1416.24.camel@dwalker1>  <45F71EA5.2090203@goop.org> <1173837606.23595.32.camel@imap.mvista.com>
In-Reply-To: <1173837606.23595.32.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> The adjustments that I spoke of above are working regardless of ntp ..
> The stability of the TSC directly effects the clock mult adjustments in
> timekeeping, as does interrupt latency since the clock is essentially
> validated against the timer interrupt.
>   

Yep.  But the tsc is just an example of a clocksource, and doesn't have
any real bearing on what I'm saying.

> like I said there are other factors so that's not going to exactly model
> cpu speed changes. You could come up with another method, but that would
> likely require another known constant clock.
>   

Well, it doesn't need to be a constant clock if its modelling a changing
rate.  And it doesn't need to be an exact model; it just needs to be
better than the current situation.

> sched_clock doesn't measure amounts of cpu work either, it's all about
> timing. 
>   

Specifically, how much cpu time a process has used.  But if the CPU is
running at half speed (or 50% duty cycle), then claiming that the
process got the full amount of time is just an error.

>> Well, lots of cpus have dynamic frequencies.  Any scheduler which
>> maintains history will suffer the same problem, even on UP.  If
>> processes A and B are supposed to have the same priority and they both
>> execute for 1ms of real time, did they make the same amount of
>> progress?  Not if the cpu changed speed in between.
>>     
>
> That's true, but given a constant clock (like what sched_clock should
> have) then the accounting is similarly inaccurate. Any connection
> between the scheduler and the TSC frequency changes aren't part of the
> design AFAIK ..
>   

Well, my whole argument is that sched_clock /should not/ be a constant
clock.  And I'm not quite sure why you keep bringing up the tsc, because
it has no relevance.

    J
