Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbXFUPGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbXFUPGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbXFUPF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:05:57 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:38734 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbXFUPF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:05:56 -0400
Message-ID: <467A93BF.9020104@free.fr>
Date: Thu, 21 Jun 2007 17:05:35 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Selective system profiling
References: <46779B8D.6050900@free.fr>
In-Reply-To: <46779B8D.6050900@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> Hello everyone,
> 
> Here's my situation:
> 
> I'm pushing data in chunks of 1316 bytes to a PCI device at 38 Mbit/s.
> In other words, I write 1316 bytes to the device every 277 microseconds.
> 
> I've noticed that the latency of this operation varies immensely. Most 
> of the time it completes in 50-80 microseconds, but there are occasions 
> when it takes several milliseconds (I've even logged 23 ms).
> 
> The pseudo-code looks like this:
> 
>   deadline = now;
> 
>   while ( 1 )
>   {
>     deadline += 277 µs
>     sleep_until(deadline)
>     t0 = now;
>     write 1316 bytes to PCI device
>     t1 = now;
>     if (t1-t0 > 100 µs) scream & panic
>   }
> 
> Relevant (?) information about the setup:
> 
> I'm running a PREEMPT_RT kernel with high-resolution timers.
> (Specifically 2.6.20.7-rt8)
> http://rt.wiki.kernel.org/index.php/Main_Page
> HZ=100
> The process is in SCHED_RR with priority 75.
> The only "process" (?) with higher priority is posix_cpu_timer.
> write() is implemented as an ioctl in the driver.
> You might think that write() blocks when the buffers on the PCI board 
> are full, but I am 99.9% sure that the buffers are never full.
> 
> 
> Here's my question:
> 
> When my process comes back from a write operation, and I find that I 
> have been blocked for more than X ms, can I call a function from a 
> system profiler (oprofile perhaps?) to know exactly where in the kernel 
> the CPU has been for the last X ms, and how much time has been spent in 
> each function, either sleeping or doing something?

Perhaps I could take this matter to a different list?
