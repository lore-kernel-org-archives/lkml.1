Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbXKTPrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbXKTPrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbXKTPr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:47:28 -0500
Received: from rtr.ca ([76.10.145.34]:1859 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255AbXKTPr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:47:27 -0500
Message-ID: <4743018C.1000307@rtr.ca>
Date: Tue, 20 Nov 2007 10:47:24 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <47425EA5.7000607@rtr.ca>	<200711201517.16171.nickpiggin@yahoo.com.au>	<20071119213727.16d5917b@laptopd505.fenrus.org>	<200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org>
In-Reply-To: <20071120064747.2a8036cd@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>..
> I listed a few;
> 1) it's policy 
> 2) the memory is only needed for a short time (20 seconds or so) on
> single-socket machines
> 3) it makes decisions on "subjective" information such as interrupt
> device classes that the kernel currently just doesn't have (it could
> grow that obviously), and is clearly policy information.
..

It's much more than just "policy".
Distributing IRQs across available cores is *essential* functionality,
not an optional "extra" as this would have it be.

After reading some of the replies, I installed it on my malfunctioning 64-bit
system, but discovered it does not perform nearly as well as the kernel solution
in the 32-bit system does.

Responsiveness was jerky, and it took a long time to have any noticeable effect.

And in the end, it still just assigned IRQs to two of the four available cores.
Which still results in the task scheduler fighting against IRQs more than necessary.

Much of this could be due to a slow response curve in the userspace balancer (?),
but I have not yet examined it for such bugs.  Hopefully it also is clever enough
to mlock() itself, and to run at a low RT priority ? 

It really does need to respond *quickly* to changes in IRQ load,
as otherwise I see dropouts on sound playback (let along video..) and the like.

The vast majority of Linux machines are "single package", and this software
appears to be designed more for multi package, and doesn't do a great job here
on the single package Intel cores I have (Core2duo, Core2quad).

Cheers
