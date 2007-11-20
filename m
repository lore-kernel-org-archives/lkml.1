Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbXKTERc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbXKTERc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 23:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbXKTERY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 23:17:24 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:24380 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752541AbXKTERX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 23:17:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qHy5mxTk1Y65XFTklEZFysG5k+tdBeDpNkUrnSg0/KN7Y4yalrIEC8qnVxfQ2bze/AA7RvgELo8KP1J5PjKVbgDnQ0gpB0ARIPj1ULI0CLBAHC2xwTy4+vRawqqUtO8PpBxQtLj0DpzwsRpSxlHHtbOF6Srk2yTYvRuw7JM9Ht4=  ;
X-YMail-OSG: wi8OAJIVM1mfMe.pcn7IuZ7B1jK.1iMZfUR0sChOV5JzDVkKSS5Coz46S_JnODwrOwCPFPuxbA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Date: Tue, 20 Nov 2007 15:17:15 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <47425EA5.7000607@rtr.ca>
In-Reply-To: <47425EA5.7000607@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201517.16171.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 15:12, Mark Lord wrote:
> On 32-bit x86, we have CONFIG_IRQBALANCE available,
> but not on 64-bit x86.  Why not?
>
> I ask, because this feature seems almost essential to obtaining
> reasonable latencies during heavy I/O with fast devices.
>
> My 32-bit Core2Duo MythTV box drops audio frames without it,
> but works perfectly *with* IRQBALANCE.
>
> My QuadCore box works very well in 32-bit mode with IRQBALANCE,
> but responsiveness sucks bigtime when run in 64-bit mode (no IRQBALANCE)
> during periods of multiple heavy I/O streams (USB flash drives).
>
> That's with both the 32 and 64 bit versions of Kubuntu Gutsy,
> so the software uses pretty much identical versions either way.
>
> As near as I can tell, when IRQBALANCE is not configured,
> all I/O device interrupts go to CPU#0.
>
> I don't think our CPU scheduler takes that into account when assigning
> tasks to CPUs, so anything sent to CPU0 runs with very high latencies.
>
> Or something like that.
>
> Why no IRQ_BALANCE in 64-bit mode ?

For that matter, I'd like to know why it has been decided that the
best place for IRQ balancing is in userspace. It should be in kernel
IMO, and it would probably allow better power saving, performance,
fairness, etc. if it were to be integrated with the task balancer as
well.
