Return-Path: <linux-kernel-owner+w=401wt.eu-S1751024AbXCNVie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbXCNVie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 17:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbXCNVid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 17:38:33 -0400
Received: from gw.goop.org ([64.81.55.164]:48169 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXCNVid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 17:38:33 -0400
Message-ID: <45F86B56.6020606@goop.org>
Date: Wed, 14 Mar 2007 14:38:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       James Morris <jmorris@namei.org>, john stultz <johnstul@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org> <200703150836.08670.kernel@kolivas.org>
In-Reply-To: <200703150836.08670.kernel@kolivas.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> I think you're looking for a complex solution to a problem that doesn't exist. 
>   

The problem is subtle, but I think the solution is actually fairly simple.

> The job of the process scheduler is to meter out the available cpu resources. 
> It cannot make up cycles for a slow cpu or one that is throttled.

No, it can't schedule more cpu time than exists.  But it should account
for the time the processes actually had available to them, rather than
assuming they got the full power of the cpu.

>  If the 
> problem is happening due to throttling it should be fixed by altering the 
> throttle. The example you describe with the conservative governor is as easy 
> to fix as changing to the ondemand governor.

That's one workaround, but sometimes its desirable to keep even
cpu-bound processes at a lower cpu performance level for power-saving
reasons.  Modern CPUs are designed to switch performance states very
quickly, so its conceivable you could change performance every context
switch, though no governor currently uses that fine granularity.

>  Differential power cpus on an 
> SMP machine should be managed by SMP balancing choices based on power groups.
>   

Do you mean compute power or energy power here?

> It would be fine to implement some other accounting of this definition of time 
> for other purposes but not for process scheduler decisions per se.
>   

I suppose, but it seems to me that they're pretty much the same thing.

> Sorry to chime in late.  My physical condition prevents me spending any 
> extended period of time at the computer so I've tried to be succinct with my 
> comments and may not be able to reply again.
>   

My sympathies; neck problems are bad news.

    J
