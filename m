Return-Path: <linux-kernel-owner+w=401wt.eu-S933869AbXGMPEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869AbXGMPEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760849AbXGMPEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:04:37 -0400
Received: from rtr.ca ([64.26.128.89]:2621 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759720AbXGMPEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:04:37 -0400
Message-ID: <46979483.2090502@rtr.ca>
Date: Fri, 13 Jul 2007 11:04:35 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Maarten Maathuis <madman2003@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [realtime-preempt] [x86_64] HR_TIMER and/or DYNTICKS cause an
 early boot freeze
References: <6d4bc9fc0707130702l41f58c20l72423be27292d884@mail.gmail.com>
In-Reply-To: <6d4bc9fc0707130702l41f58c20l72423be27292d884@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten Maathuis wrote:
> I have determined that version 2.6.22.1-rt2 freeze after:
> 
> NET: Register protocol family 2
> 
> This is very early in the boot stage, and i cannot determine what
> exactly causes it.
> 
> It happens if either high resolution timers or dynamic ticks are active.

There's a race in there somewhere, and it seems to come and go
depending upon exactly how the kernel is configured, and possibly
on which things end up on which cache lines.

First reported by me here (below), and never resolved.
Currently it's not happening with my kernels, but it does reappear
from time to time:

> -------- Original Message --------
> Subject: [BUG] 2.6.21: Kernel won't boot with either/both of CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
> Date: Mon, 30 Apr 2007 16:17:00 -0400
> From: Mark Lord <lkml@rtr.ca>
> To: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
> CC: Linus Torvalds <torvalds@osdl.org>
>
> I have a new notebook (Dell Inspiron 9400) with Core2-Duo T7400 @ 2.1Ghz.
> When either/both of CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS is used,
> the 2.6.21 kernel hangs on startup just after printing one/both of these:
>
> kernel: switched to high resolution mode on cpu 1
> kernel: switched to high resolution mode on cpu 0
>
> 100% of the time.  The only fix I've found is to rebuild
> the kernel without those two options.
>
> The failed kernel.config is attached.
> Here is /proc/cpuinfo and lspci -v.
>
> Any help appreciated. 
