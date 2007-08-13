Return-Path: <linux-kernel-owner+w=401wt.eu-S943155AbXHMPOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943155AbXHMPOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030890AbXHMM7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:59:05 -0400
Received: from 193-189-87-45.ip.kis.lt ([193.189.87.45]:21324 "EHLO
	barclay.wilibox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030790AbXHMM7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:59:01 -0400
X-Greylist: delayed 1972 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 08:59:00 EDT
Subject: Re: Linux 2.6.23-rc3
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 15:23:13 +0300
Message-Id: <1187007793.5717.11.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello lkml, 

Linux kernel v2.6.23-rc3 booted ok and so far everything is fine. I have
HP Compaq nx9420 laptop (Dual Core). 

Just a few things that I found interesting:

1. /sys/devices/system/clocksource/clocksource0/*

$ sudo grep . *
available_clocksource:hpet hpet acpi_pm jiffies tsc
                      ^^^^^^^^^ listed twice ;) not a big deal but still. 
current_clocksource:hpet
                    ^^^^ seems selected ;) although in dmesg there are

$ dmesg | grep -i hpet
$ dmesg | grep -i hpet
ACPI: HPET 7FFE59BC, 0038 (r1 HP     309F            1 HP          1)
ACPI: HPET id: 0x8086a201 base: 0xfed00000
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
hpet_resources: 0xfed00000 is busy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ? strange.

Time: hpet clocksource has been installed.

2. ACPI related (?) - one fan is always on, even when system is idling.

It never stops ;)

$ acpi -bt
     Battery 1: charged, 98%
     Thermal 1: ok, 48.0 degrees C
     Thermal 2: ok, 38.0 degrees C
     Thermal 3: active[5], 47.0 degrees C
     Thermal 4: ok, 37.0 degrees C
     Thermal 5: ok, 32.0 degrees C
     Thermal 6: ok, 25.0 degrees C


In earlier kernel versions it was turned on when needed (mostly during
compilation ...) and then when system is cooled  enough fan was
automatically turned off.

3. the same messages are printed twice (2.6.23-rc2 was fine).

Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
^^^^^^^^^^^^^^^^^^^^^^^^ 1st time
ACPI: Interpreter enabled
ACPI: (supports S0 S3)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
^^^^^^^^^^^^^^^^^^^^^^^^ 2nd time
ACPI: PCI Root Bridge [C003] (0000:00)


Otherwise I am happy with 2.6.23-rc3. Thank y'all ;)

Best regards,
Zilvinas


