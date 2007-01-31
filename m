Return-Path: <linux-kernel-owner+w=401wt.eu-S1750949AbXAaP2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750949AbXAaP2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXAaP2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:28:00 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57689 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbXAaP17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:27:59 -0500
Message-ID: <45C0B570.4000000@garzik.org>
Date: Wed, 31 Jan 2007 10:27:44 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
References: <20070129144055.151cfe52@freekitty> <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org> <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <20070129161626.33277eb1@freekitty> <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org> <20070130065457.GA23390@elte.hu> <45BEF61F.7000400@garzik.org> <20070130075325.GA591@elte.hu> <45BEFBB2.8090402@garzik.org> <20070130080830.GC2840@elte.hu>
In-Reply-To: <20070130080830.GC2840@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Easy to name an example, as they are pretty generic.  When sharing 
>> irqs -- usually ATA is configured to PCI native (IO-APIC-fasteoi) -- 
>> any interrupt storm causes the other devices sharing that irq to crap 
>> themselves (kernel turns off irq, suggests irqpoll, etc.)
> 
> ok. Can you suggest any way for me to reproduce such a bug artificially 
> on a test system? [i have both old and new systems, so if you can think 
> of a way for me to trigger this i'd be happy to try]

Should be pretty easy.  With either the old-IDE driver or libata, 
complete a command without acknowledging an interrupt.  For libata, that 
means poking around in ata_host_intr() and avoiding well-built hardware 
like AHCI.  Anything that uses ata_piix driver, basically all Intel 
machines, should be applicable in the "not well built" category... :)

	Jeff



