Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbXKTEMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbXKTEMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 23:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXKTEMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 23:12:24 -0500
Received: from rtr.ca ([76.10.145.34]:1844 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbXKTEMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 23:12:24 -0500
Message-ID: <47425EA5.7000607@rtr.ca>
Date: Mon, 19 Nov 2007 23:12:21 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: CONFIG_IRQBALANCE for 64-bit x86 ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit x86, we have CONFIG_IRQBALANCE available,
but not on 64-bit x86.  Why not?

I ask, because this feature seems almost essential to obtaining
reasonable latencies during heavy I/O with fast devices.

My 32-bit Core2Duo MythTV box drops audio frames without it,
but works perfectly *with* IRQBALANCE.

My QuadCore box works very well in 32-bit mode with IRQBALANCE,
but responsiveness sucks bigtime when run in 64-bit mode (no IRQBALANCE)
during periods of multiple heavy I/O streams (USB flash drives).

That's with both the 32 and 64 bit versions of Kubuntu Gutsy,
so the software uses pretty much identical versions either way.

As near as I can tell, when IRQBALANCE is not configured,
all I/O device interrupts go to CPU#0.

I don't think our CPU scheduler takes that into account when assigning
tasks to CPUs, so anything sent to CPU0 runs with very high latencies.

Or something like that.

Why no IRQ_BALANCE in 64-bit mode ?
