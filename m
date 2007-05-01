Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXEAPea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXEAPea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXEAPea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:34:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXEAPe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:34:29 -0400
Message-ID: <46375E04.5030506@redhat.com>
Date: Tue, 01 May 2007 11:34:28 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Michel Lespinasse <walken@zoy.org>
CC: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: 24 lost ticks with 2.6.20.10 kernel
References: <20070501130715.GB29131@zoy.org>
In-Reply-To: <20070501130715.GB29131@zoy.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
> 
> I'm having an issue with lost ticks, runnign linux 2.6.20.10 on an
> intel DQ965GF motherboard. For some reason this occurs with clock-like
> regularity, always exactly 24 lost ticks, about every two seconds.
> This is running with 250-HZ ticks, and the small pause every two seconds
> is also noticeable when using the console.
> 
> 
> running with report_lost_ticks, I see the following:
> 
> May  1 12:58:57 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 12:58:59 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 12:59:01 server kernel: time.c: Lost 25 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 12:59:03 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 12:59:07 server last message repeated 2 times
> May  1 12:59:10 server kernel: time.c: Lost 24 timer tick(s)! rip handle_IRQ_event+0x19/0x55)
> May  1 12:59:12 server kernel: time.c: Lost 24 timer tick(s)! rip handle_IRQ_event+0x19/0x55)
> May  1 12:59:14 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 12:59:16 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 12:59:18 server kernel: time.c: Lost 24 timer tick(s)! rip handle_IRQ_event+0x19/0x55)
> May  1 12:59:20 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 12:59:52 server last message repeated 15 times
> May  1 13:00:51 server last message repeated 28 times
> May  1 13:01:47 server last message repeated 27 times
> May  1 13:01:50 server kernel: time.c: Lost 25 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> May  1 13:01:56 server last message repeated 3 times
> May  1 13:01:58 server kernel: time.c: Lost 24 timer tick(s)! rip _spin_unlock_irqrestore+0x8/0x9)
> 
> 
> Since the rip often mentions _spin_unlock_irqrestore, I figured maybe
> someone sleeps for 25 ticks with the interrupts disabled. I tried
> running with CONFIG_DEBUG_SPINLOCK_SLEEP but this did not uncover anything.
> 
> 
> I also noticed this code in arch/x86_64/kernel/time.c. I'm not sure if it
> has anything to do with my issue, but it might since I get lost_count==24...
> I could not figure out what this code is trying to do though.
> 
> #ifdef CONFIG_CPU_FREQ
>         /* In some cases the CPU can change frequency without us noticing
>            Give cpufreq a change to catch up. */
>         if ((lost_count+1) % 25 == 0)
>                 cpufreq_delayed_get();
> #endif
> 
> 
> I'm not sure where to go from here. Additional information about my system:
> 
 
Try disabling CONFIG_CPU_FREQ?


> One last thing: I have another box which is fairly similar, with a
> DG965RY motherboard. That other box does *not* seem to lose any ticks,
> running the same kernel that works so poorly on the DQ965GF board.
> Does that point to a hardware/bios issue then ?????

Is it running the exact same kernel, with the same cpufreq settings at
runtime (governor, controller, etc?)
