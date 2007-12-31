Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbXLaVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbXLaVyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 16:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXLaVyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 16:54:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbXLaVyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 16:54:14 -0500
Message-ID: <47796363.8060604@zytor.com>
Date: Mon, 31 Dec 2007 13:47:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ondrej Zary <linux@rainbow-software.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl>	<4778FE42.6010003@keyaccess.nl>	<20071231155600.0b06552c@the-village.bc.nu>	<200712312122.13739.linux@rainbow-software.org> <20071231212525.6940ce70@the-village.bc.nu>
In-Reply-To: <20071231212525.6940ce70@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> What about HP PCLan 16/TP+ cards? I have one that runs 24/7 in a 486 box 
>> (2.6.20.6 kernel) and one spare. It has some VLSI HP chip and also ST-NIC 
>> DP83902AV - is that a good candidate for testing?
> 
> What are you trying to test. The documentation explicitly says you need
> the delays and that the delays are in bus clocks not microseconds. That
> means the existing code is correct and it needs a delay dependant on the
> ISA bus clock frequency (somewhere between 6 and 12MHz). Note that the
> delay depends on the bus clock frequency not time.
> 
> We don't do overclocking, we don't support overclocking, please do not
> overclock your ethernet chip.
> 

However, assuming a bus clock of 6 MHz should be safe (167 ns).

4 bus clocks would be 667 ns, or we can round it up to 1 ms to deal with 
bus delay effects.

None of this really helps with *memory-mapped* 8390, though, since 
memory mapped writes can be posted.  Putting any IOIO transaction in the 
middle has the effect of flushing the posting queues; an MMIO read would 
   also work.  The WD80x3 cards were memory-mapped, in particular (and 
were some of the very first cards supported by Linux.)

	-hpa
