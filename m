Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZEAK57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZEAK57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZEAK5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:57:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41098 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZEAK5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:57:50 -0400
Date: Fri, 1 May 2009 11:57:34 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Thomas Glexiner <tglx@linutronix.de>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: 044d408409cc4e1bc75c886e27ca85c270db104c causes warnings
Message-ID: <20090501105734.GA27799@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People have been complaining about this new warning which has appeared,
but unfortunately none of them seem to have reported this to the relevent
people.  I've just had someone else mention about this, so I guess I'm
going to have to do the legwork for them...

Adding the WARN_ONCE() in 044d408409cc4e1bc75c886e27ca85c270db104c
causes warnings to appear on ARM.  Eg,

WARNING: at /build/linux/kernel/irq/handle.c:353 handle_IRQ_event+0x58/0xd8()
BUG: IRQ handler called from non-hardirq context!
Backtrace:
[<c0460e60>] (handle_IRQ_event+0x0/0xd8) from [<c046257c>] (handle_edge_irq+0x114/0x150)
[<c0462468>] (handle_edge_irq+0x0/0x150) from [<c0461b80>] (resend_irqs+0x48/0x80)
[<c0461b38>] (resend_irqs+0x0/0x80) from [<c043ffa8>] (tasklet_action+0x88/0xe0)
[<c043ff20>] (tasklet_action+0x0/0xe0) from [<c043f9e0>] (__do_softirq+0x68/0x104)

to which tglx said:

--- Day changed Mon Mar 30 2009
17:03 < tglx> rmk: hmpf
17:44 < rmk> tglx: seems to be nicely reproducable when accessing stuff via a PCMCIA NE2K NIC on PXA
17:44 < tglx> sure
17:44 < tglx> I know why it triggers
17:45 < tglx> darn
17:53 < tglx> the warn_once is crap when you use the resend mechanism, which runs in a tasklet :(

So the question is: what's happening about this?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
