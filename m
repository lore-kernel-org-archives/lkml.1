Return-Path: <linux-kernel-owner+w=401wt.eu-S1761205AbXKTPxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761205AbXKTPxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758982AbXKTPwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:52:51 -0500
Received: from rtr.ca ([76.10.145.34]:1571 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358AbXKTPwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:52:50 -0500
Message-ID: <474302D0.9000509@rtr.ca>
Date: Tue, 20 Nov 2007 10:52:48 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <47425EA5.7000607@rtr.ca>	<200711201517.16171.nickpiggin@yahoo.com.au>	<20071119213727.16d5917b@laptopd505.fenrus.org>	<200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org> <4743018C.1000307@rtr.ca>
In-Reply-To: <4743018C.1000307@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Arjan van de Ven wrote:
>> ..
>> I listed a few;
>> 1) it's policy 2) the memory is only needed for a short time (20 
>> seconds or so) on
>> single-socket machines
>> 3) it makes decisions on "subjective" information such as interrupt
>> device classes that the kernel currently just doesn't have (it could
>> grow that obviously), and is clearly policy information.
> ..
> 
> It's much more than just "policy".
> Distributing IRQs across available cores is *essential* functionality,
> not an optional "extra" as this would have it be.
> 
> After reading some of the replies, I installed it on my malfunctioning 
> 64-bit
> system, but discovered it does not perform nearly as well as the kernel 
> solution
> in the 32-bit system does.
> 
> Responsiveness was jerky, and it took a long time to have any noticeable 
> effect.
> 
> And in the end, it still just assigned IRQs to two of the four available 
> cores.
> Which still results in the task scheduler fighting against IRQs more 
> than necessary.
> 
> Much of this could be due to a slow response curve in the userspace 
> balancer (?),
> but I have not yet examined it for such bugs.  Hopefully it also is 
> clever enough
> to mlock() itself, and to run at a low RT priority ?
> It really does need to respond *quickly* to changes in IRQ load,
> as otherwise I see dropouts on sound playback (let along video..) and 
> the like.
> 
> The vast majority of Linux machines are "single package", and this software
> appears to be designed more for multi package, and doesn't do a great 
> job here
> on the single package Intel cores I have (Core2duo, Core2quad).
..

All of which reminds me of perhaps *the* most important reason to keep
core functionality like "IRQ distribution" *inside* the kernel:

   It has to pass peer review on this mailing list.

External utilities have no such accountability, and can generally just
follow the whims of their maintainers at the expense of kernel performance.

Not that this may be the case (or not) here, but..

Cheers
