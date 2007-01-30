Return-Path: <linux-kernel-owner+w=401wt.eu-S965418AbXA3HjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418AbXA3HjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 02:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965423AbXA3HjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 02:39:17 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43791 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965418AbXA3HjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 02:39:16 -0500
Message-ID: <45BEF61F.7000400@garzik.org>
Date: Tue, 30 Jan 2007 02:39:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
References: <1170101430.29240.34.camel@localhost.localdomain> <20070129133849.1b523226@freekitty> <1170109401.29240.49.camel@localhost.localdomain> <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org> <20070129144055.151cfe52@freekitty> <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org> <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <20070129161626.33277eb1@freekitty> <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org> <20070130065457.GA23390@elte.hu>
In-Reply-To: <20070130065457.GA23390@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'm wondering, could we go with Thomas' temporary patch that disables 
> sky2 MSI if CONFIG_PM is enabled - we could revert that after 2.6.20. 
> It's not like MSI is a life and death feature. On IO-APIC systems 
> vectors are abundant and in any case we share irqs just fine. The true 
> advantage of MSI is minimal. (MSI-X has the potential to be better by 
> being message based, but in reality it still goes through the full IRQ 
> layer.) MSI might be useful on really, really large systems - but i 
> really hope those really large systems dont rely on CONFIG_PM. Meanwhile 
> Thomas' patch maximizes the amount of working hardware (it has the 
> chance to produce working systems in 100% of the cases) - which is a few 
> orders of magnitude more important than IRQ management micro-costs. Am i 
> missing anything?


Sharing irqs /sucks/.  I routinely have to fight a USB device dying, 
because the ATA device is causing an interrupt storm, or vice versa. 
/Very/ common headache.

Other than that, they use a tiny bit fewer CPU cycles, and allow 
simplification of the interrupt handler (saving another few CPU cycles).

The biggest benefit is (a) for hardware designers, where MSI means a 
cleaner h/w design, and (b) preparation of drivers and the kernel 
systems for MSI-only hardware.

At present only high end hardware is MSI-only (like infiniband), but 
that's the future direction.

	Jeff


