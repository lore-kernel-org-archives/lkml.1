Return-Path: <linux-kernel-owner+w=401wt.eu-S965444AbXA3IJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965444AbXA3IJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965449AbXA3IJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:09:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40257 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965444AbXA3IJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:09:51 -0500
Date: Tue, 30 Jan 2007 09:08:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070130080830.GC2840@elte.hu>
References: <20070129144055.151cfe52@freekitty> <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org> <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <20070129161626.33277eb1@freekitty> <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org> <20070130065457.GA23390@elte.hu> <45BEF61F.7000400@garzik.org> <20070130075325.GA591@elte.hu> <45BEFBB2.8090402@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BEFBB2.8090402@garzik.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.3 required=5.9 tests=ALL_TRUSTED autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> Easy to name an example, as they are pretty generic.  When sharing 
> irqs -- usually ATA is configured to PCI native (IO-APIC-fasteoi) -- 
> any interrupt storm causes the other devices sharing that irq to crap 
> themselves (kernel turns off irq, suggests irqpoll, etc.)

ok. Can you suggest any way for me to reproduce such a bug artificially 
on a test system? [i have both old and new systems, so if you can think 
of a way for me to trigger this i'd be happy to try]

I /think/ my two patches should automatically avoid the 'cap themselves' 
effect you outlined: the absolutely worst case should be that we'll have 
twice the IRQ rate of the optimal one - but no irq storm nor lost 
interrupts should happen due to irq trigger type mismatches, ever - as 
long as the basic mapping of device to IRQ is correct. [ I tried to push 
to include this in v2.6.20 but i lost that argument ;-) ]

	Ingo
