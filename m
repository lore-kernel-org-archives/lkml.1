Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbXHNKOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbXHNKOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbXHNKKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:54 -0400
Received: from 193-189-87-45.ip.kis.lt ([193.189.87.45]:49199 "EHLO
	barclay.wilibox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755553AbXHNKKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:47 -0400
Subject: Re: Linux 2.6.23-rc3
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1187007793.5717.11.camel@zv.wilibox.com>
References: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org>
	 <1187007793.5717.11.camel@zv.wilibox.com>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 13:10:43 +0300
Message-Id: <1187086243.5107.7.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

I have also noticed that there are other messages printed twice, not a
big problem but still ;) . Perhaps it should be that way, don't know.

$ dmesg | grep sda
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA


Inserting USB key also has the same behavior:

Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 6:0:0:0: Direct-Access     USB 2.0  Flash Disk       1100 PQ: 0 ANSI: 0 CCS
sd 6:0:0:0: [sdb] 4062208 512-byte hardware sectors (2080 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
sd 6:0:0:0: [sdb] 4062208 512-byte hardware sectors (2080 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 43 00 00 00
sd 6:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 6:0:0:0: [sdb] Attached SCSI removable disk
sd 6:0:0:0: Attached scsi generic sg2 type 0

On Mon, 2007-08-13 at 15:23 +0300, Zilvinas Valinskas wrote:
> Hello lkml, 
> 
> Linux kernel v2.6.23-rc3 booted ok and so far everything is fine. I have
> HP Compaq nx9420 laptop (Dual Core). 
> 
> Just a few things that I found interesting:
> 
> 1. /sys/devices/system/clocksource/clocksource0/*
> 
> $ sudo grep . *
> available_clocksource:hpet hpet acpi_pm jiffies tsc
>                       ^^^^^^^^^ listed twice ;) not a big deal but still. 
> current_clocksource:hpet
>                     ^^^^ seems selected ;) although in dmesg there are
> 
> $ dmesg | grep -i hpet
> $ dmesg | grep -i hpet
> ACPI: HPET 7FFE59BC, 0038 (r1 HP     309F            1 HP          1)
> ACPI: HPET id: 0x8086a201 base: 0xfed00000
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 64-bit timers, 14318180 Hz
> hpet_resources: 0xfed00000 is busy
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ? strange.
> 
> Time: hpet clocksource has been installed.
> 
> 2. ACPI related (?) - one fan is always on, even when system is idling.
> 
> It never stops ;)
> 
> $ acpi -bt
>      Battery 1: charged, 98%
>      Thermal 1: ok, 48.0 degrees C
>      Thermal 2: ok, 38.0 degrees C
>      Thermal 3: active[5], 47.0 degrees C
>      Thermal 4: ok, 37.0 degrees C
>      Thermal 5: ok, 32.0 degrees C
>      Thermal 6: ok, 25.0 degrees C
> 
> 
> In earlier kernel versions it was turned on when needed (mostly during
> compilation ...) and then when system is cooled  enough fan was
> automatically turned off.
> 
> 3. the same messages are printed twice (2.6.23-rc2 was fine).
> 
> Brought up 2 CPUs
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
> PCI: Not using MMCONFIG.
> PCI: Using configuration type 1
> ACPI: EC: Look up EC in DSDT
> ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
> ^^^^^^^^^^^^^^^^^^^^^^^^ 1st time
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
> ^^^^^^^^^^^^^^^^^^^^^^^^ 2nd time
> ACPI: PCI Root Bridge [C003] (0000:00)
> 
> 
> Otherwise I am happy with 2.6.23-rc3. Thank y'all ;)
> 
> Best regards,
> Zilvinas
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

