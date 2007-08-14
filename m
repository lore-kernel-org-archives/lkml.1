Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbXHNKTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbXHNKTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbXHNKOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:14:08 -0400
Received: from 193-189-87-45.ip.kis.lt ([193.189.87.45]:31558 "EHLO
	barclay.wilibox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758736AbXHNKOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:14:05 -0400
Subject: Re: Linux 2.6.23-rc3
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <6bffcb0e0708130949y35976025j1c84446dd85f1e7c@mail.gmail.com>
References: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org>
	 <1187007793.5717.11.camel@zv.wilibox.com>
	 <6bffcb0e0708130949y35976025j1c84446dd85f1e7c@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 13:14:01 +0300
Message-Id: <1187086441.5107.12.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michal, 

This morning I have booted laptop, for a while fan had been turned off.
But then after a light load (compiling stuff & co), fan was turned on
and now it is still on. 

zilvinas@zv:~$ acpi -bt
     Battery 1: charged, 97%
     Thermal 1: ok, 48.0 degrees C
     Thermal 2: ok, 37.0 degrees C
     Thermal 3: ok, 46.0 degrees C
     Thermal 4: ok, 37.0 degrees C
     Thermal 5: ok, 32.0 degrees C
     Thermal 6: ok, 20.0 degrees C

Temperatures don't seem to be that high to keep the fan on.

Z. 

On Mon, 2007-08-13 at 18:49 +0200, Michal Piotrowski wrote:
> Hi Zilvinas,
> 
> On 13/08/07, Zilvinas Valinskas <zilvinas@wilibox.com> wrote:
> > Hello lkml,
> >
> > Linux kernel v2.6.23-rc3 booted ok and so far everything is fine. I have
> > HP Compaq nx9420 laptop (Dual Core).
> >
> > Just a few things that I found interesting:
> >
> > 1. /sys/devices/system/clocksource/clocksource0/*
> >
> > $ sudo grep . *
> > available_clocksource:hpet hpet acpi_pm jiffies tsc
> >                       ^^^^^^^^^ listed twice ;) not a big deal but still.
> > current_clocksource:hpet
> >                     ^^^^ seems selected ;) although in dmesg there are
> >
> > $ dmesg | grep -i hpet
> > $ dmesg | grep -i hpet
> > ACPI: HPET 7FFE59BC, 0038 (r1 HP     309F            1 HP          1)
> > ACPI: HPET id: 0x8086a201 base: 0xfed00000
> > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> > hpet0: 3 64-bit timers, 14318180 Hz
> > hpet_resources: 0xfed00000 is busy
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ? strange.
> >
> > Time: hpet clocksource has been installed.
> >
> > 2. ACPI related (?) - one fan is always on, even when system is idling.
> >
> > It never stops ;)
> 
> Hmmm... looks like a thermal trip points problem.
> 
> >
> > $ acpi -bt
> >      Battery 1: charged, 98%
> >      Thermal 1: ok, 48.0 degrees C
> >      Thermal 2: ok, 38.0 degrees C
> >      Thermal 3: active[5], 47.0 degrees C
> >      Thermal 4: ok, 37.0 degrees C
> >      Thermal 5: ok, 32.0 degrees C
> >      Thermal 6: ok, 25.0 degrees C
> >
> >
> > In earlier kernel versions it was turned on when needed (mostly during
> > compilation ...) and then when system is cooled  enough fan was
> > automatically turned off.
> >
> > 3. the same messages are printed twice (2.6.23-rc2 was fine).
> >
> > Brought up 2 CPUs
> > NET: Registered protocol family 16
> > ACPI: bus type pci registered
> > PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
> > PCI: Not using MMCONFIG.
> > PCI: Using configuration type 1
> > ACPI: EC: Look up EC in DSDT
> > ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
> > ^^^^^^^^^^^^^^^^^^^^^^^^ 1st time
> > ACPI: Interpreter enabled
> > ACPI: (supports S0 S3)
> > ACPI: Using IOAPIC for interrupt routing
> > ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
> > ^^^^^^^^^^^^^^^^^^^^^^^^ 2nd time
> > ACPI: PCI Root Bridge [C003] (0000:00)
> >
> >
> > Otherwise I am happy with 2.6.23-rc3. Thank y'all ;)
> >
> > Best regards,
> > Zilvinas
> 
> Regards,
> Michal
> 

