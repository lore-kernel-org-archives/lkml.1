Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbZEAN0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbZEAN0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZEAN0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:26:08 -0400
Received: from www.tglx.de ([62.245.132.106]:44912 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691AbZEAN0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:26:07 -0400
Date: Fri, 1 May 2009 15:25:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 044d408409cc4e1bc75c886e27ca85c270db104c causes warnings
In-Reply-To: <20090501105734.GA27799@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0905011524310.3375@localhost.localdomain>
References: <20090501105734.GA27799@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Russell King wrote:

> People have been complaining about this new warning which has appeared,
> but unfortunately none of them seem to have reported this to the relevent
> people.  I've just had someone else mention about this, so I guess I'm
> going to have to do the legwork for them...
> 
> Adding the WARN_ONCE() in 044d408409cc4e1bc75c886e27ca85c270db104c
> causes warnings to appear on ARM.  Eg,
> 
> WARNING: at /build/linux/kernel/irq/handle.c:353 handle_IRQ_event+0x58/0xd8()
> BUG: IRQ handler called from non-hardirq context!
> Backtrace:
> [<c0460e60>] (handle_IRQ_event+0x0/0xd8) from [<c046257c>] (handle_edge_irq+0x114/0x150)
> [<c0462468>] (handle_edge_irq+0x0/0x150) from [<c0461b80>] (resend_irqs+0x48/0x80)
> [<c0461b38>] (resend_irqs+0x0/0x80) from [<c043ffa8>] (tasklet_action+0x88/0xe0)
> [<c043ff20>] (tasklet_action+0x0/0xe0) from [<c043f9e0>] (__do_softirq+0x68/0x104)
> 
> to which tglx said:
> 
> --- Day changed Mon Mar 30 2009
> 17:03 < tglx> rmk: hmpf
> 17:44 < rmk> tglx: seems to be nicely reproducable when accessing stuff via a PCMCIA NE2K NIC on PXA
> 17:44 < tglx> sure
> 17:44 < tglx> I know why it triggers
> 17:45 < tglx> darn
> 17:53 < tglx> the warn_once is crap when you use the resend mechanism, which runs in a tasklet :(
> 
> So the question is: what's happening about this?

Queued a revert for linus.

Thanks,

	tglx
