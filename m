Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYG2FDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYG2FDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYG2FDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:03:08 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:44554 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbYG2FDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:03:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEABU/jkg7p+/x/2dsb2JhbACBW4lFo0A
X-IronPort-AV: E=Sophos;i="4.31,270,1215354600"; 
   d="scan'208";a="159592134"
Message-ID: <488EA477.7070101@call-direct.com.au>
Date: Tue, 29 Jul 2008 15:02:47 +1000
From: Iwo Mergler <iwo@call-direct.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080302)
MIME-Version: 1.0
To: Alessio Sangalli <alesan@manoweb.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: interrupt overhead on ARM architecture
References: <488E7F08.7060309@manoweb.com>
In-Reply-To: <488E7F08.7060309@manoweb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessio Sangalli wrote:
> Hi there, I was wondering if somebody ever did some measurements of the
> interrupt overhead, measured in clock cycles. Basically how much time it
> takes to do the context switch and reach the ISR, and back. My target is
> the ARM9...
> 
> Thanks
> Alessio
>
This depends very much on the system, both hardware and software.

The ARM9 processor can get from an active interrupt line to the
first instruction in the ISR in about 30 clock cycles.

However, it can take a multiple of that if the ISR and relevant
stacks are not in cache. On many systems this can cost you
a few hundred processor clocks, depending on what the software
did just before the interrupt.

At this point the OS ISR is running. It needs to find out which
hardware device triggered. The processor has only one interrupt
line (OK, two), but some systems have hundreds of interrupt sources.

Depending on the interrupt controller hardware, finding out which
interrupt fired, is a matter of reading one register in the best case.
Or reading several and searching for set bits in software in the
worst case. Again, a few tens of cycles, depending on the system
architecture.

Only then the OS ISR can actually call the driver's ISR, which
is probably what you are really interested in.

In other words, you can't even measure the latency on a particular
system and then assume it will stay anywhere near constant. Comparing
different systems with the same processor core is hopeless.


Kind regards,

Iwo


