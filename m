Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbXHQHXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbXHQHXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbXHQHWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:22:55 -0400
Received: from mx0.karneval.cz ([81.27.192.123]:7403 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274AbXHQHWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:22:54 -0400
X-Greylist: delayed 1347 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2007 03:22:54 EDT
Message-ID: <46C54787.1010909@stud.feec.vutbr.cz>
Date: Fri, 17 Aug 2007 09:00:23 +0200
From: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: GolovaSteek <golovasteek@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: nanosleep() accuracy
References: <f40fb4250708161552ub87bf8ve8168eec1b3955e7@mail.gmail.com>
In-Reply-To: <f40fb4250708161552ub87bf8ve8168eec1b3955e7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

GolovaSteek skrev:
> Hello!
> I need use sleep with accurat timing.
> I use 2.6.21 with rt-prempt patch.
> with enabled rt_preempt, dyn_ticks, and local_apic
> But
> 
> req.tv_nsec = 300000;
> req.tv_sec = 0;
> nanosleep(&req,NULL)
> 
> make pause around 310-330 microseconds.

How do you measure this?
If you want to have something done every 300 microseconds, you must not 
sleep for 300 microseconds in each iteration, because you'd accumulate 
errors. Use a periodic timer or use the current time to compute how long 
to sleep in each iteration. Take a look how cyclictest does it.

> I tried to understend how work nanosleep(), but it not depends from
> jiffies and from smp_apic_timer_interrupt.
> 
> When can accuracy be lost?
> And how are process waked up?
> 
> 
> GolovaSteek

Don't forget the process will always have non-zero wakeup latency. It 
takes some time to process an interrupt, wakeup the process and schedule 
it to run on the CPU. 10-30 microseconds is not unreasonable.

Michal
