Return-Path: <linux-kernel-owner+w=401wt.eu-S965087AbXAYMEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087AbXAYMEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 07:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932936AbXAYMEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 07:04:08 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:48375 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932886AbXAYMEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 07:04:07 -0500
X-Greylist: delayed 7315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 07:04:07 EST
Message-ID: <45B89C99.2060500@free.fr>
Date: Thu, 25 Jan 2007 13:03:37 +0100
From: John <shill@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@timesys.com, mingo@elte.hu, johnstul@us.ibm.com, akpm@osdl.org,
       shill@free.fr
Subject: Re: One-shot high-resolution POSIX timer periodically late
References: <fa.NwnlFyMPfa3XG6my3HKGWnCW3x4@ifi.uio.no> <fa.Ji4GnAbBF2FR5JbSxvxn2haJZIk@ifi.uio.no> <fa.8TBiwbgs8B881k+3X+IlFjhqpLI@ifi.uio.no>
In-Reply-To: <fa.8TBiwbgs8B881k+3X+IlFjhqpLI@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Re-sending in the hope that it will be archived ]

Ingo Molnar wrote:

> John Stultz wrote:
> 
>> On Wed, 2007-01-24 at 10:41 +0100, John wrote:
>> 
>>> I'm using the POSIX timers API. My platform is x86 running Linux
>>> 2.6.18.6 patched with the high-resolution timer subsystem.
>>> 
>>> http://www.tglx.de/hrtimers.html
>>> 
>>> My process is the only SCHED_FIFO process on the system. There are 
>>> no user-space processes with a higher priority. AFAICT, only a 
>>> kernel thread could keep the CPU away from my app.
>>> 
>>> Is there a periodic kernel thread that runs every 2 seconds, cannot 
>>> be preempted, and runs for over 50 µs??
>> 
>> This sounds like a BIOS SMI issue. Can you reproduce this behavior on 
>> different hardware?
> 
> note that only the -hrt patchset is used - not the full -rt patchset
> - so 50 usecs delays (and more) are quite possible and common.

Ingo,

You are correct, I only used -hrt.
I will _definitely_ give -rt a try.

I am fully aware that an occasional 100 µs delay is possible, given a
soft real-time operating system. However, what I cannot explain is:

Why do these /occasional/ delays always happen a multiple of 2 seconds
apart? Can you explain this odd behavior?

> My question would be: does the same problem occur with the full -rt
> patchset and PREEMPT_RT? (see http://rt.wiki.kernel.org for details)

I will test on a different PC, as John suggested.
I will try the full -rt patchset in a few days.

+++++

On a related note, there is no -hrt patch for 2.6.19:
http://www.tglx.de/projects/hrtimers/
Is it because the patch for 2.6.19-rc4-mm1 applies cleanly to 2.6.19?

There is no -hrt patch for 2.6.20.
Has it been completely merged?

Regards.

