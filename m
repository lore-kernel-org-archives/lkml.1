Return-Path: <linux-kernel-owner+w=401wt.eu-S1751318AbXAXM3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbXAXM3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 07:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXAXM3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 07:29:12 -0500
Received: from smtp6-g19.free.fr ([212.27.42.36]:46706 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbXAXM3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 07:29:09 -0500
Subject: Re: 2.6.19.2 sky2/acpi crashes
From: Lionel Landwerlin <landwer@free.fr>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>
In-Reply-To: <200701232136.54731.lenb@kernel.org>
References: <1169542768.5537.11.camel@cocoduo>
	 <1169599541.5235.4.camel@cocoduo>
	 <3877989d0701231739l1399afaci61aed9f26e3cd14@mail.gmail.com>
	 <200701232136.54731.lenb@kernel.org>
Content-Type: multipart/mixed; boundary="=-9W+DZoCts8yO98pagc2d"
Date: Wed, 24 Jan 2007 13:23:45 +0100
Message-Id: <1169641425.8145.5.camel@cocoduo>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9W+DZoCts8yO98pagc2d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le mardi 23 janvier 2007 à 21:36 -0500, Len Brown a écrit :
> > > > Apple Macbook 2GHz (x86, not amd64)
> 
> > > > > > Please try to remove processor module.
> > > > >
> > > > > Ok, that's done. Same problem.
> > > >
> > > > any difference with "idle=poll"?
> > > > if yes, how about "idle=halt"?
> > >
> > > idle=poll seems to fix the problem (cpu fan is running almost at full
> > > speed). Maybe I should run a longer test... For now it consists to run
> > > about 15 torrents and watching HDTV through ethernet device.
> > >
> > > idle=halt does not :
> > 
> > It sounds like issues relative to Processor C state.
> > Please enter a bug in ACPI category on bugzilla.kernel.org
> 
> Actually, the test above with the processor module removed proved
> that it isn't ACPI C-states -- as they will not be available.
> You should be able to observe that /proc/acpi/processor/*/power
> does not indicate any C-state use when processor is unloaded.
> 
> My guess was that some deep C-state with long exit latency
> was interfering with the device.  booting w/o the processor
> module should have left you running the native mwait idle.
> booting with idle=halt should have left you running the HLT idle.
> booting with idle=poll is a busy spin loop that never enters
> any hardware power saving state.
> 
> I'm quite puzzled that idle=halt was not sufficient to solve the issue,
> because that should be the lowest exit latency idle loop.
> So maybe I'm wrong about the cause -- though I can't then
> explain why idle=poll helps...
> 
> All of the idle selection options cause the kernel to print
> a line with the word "idle" in it.  Perhaps you could search
> your dmesg for "idle" to verify that it is running what we
> think it is?

Here I join the complete log for idle=halt

I'm running idle=poll for more 1 hour now with heavy ethernet load, no
crash. It usualy happens in 10~15mn with idle=halt and 4~5mn with no
idle option.

-- 
Lionel Landwerlin <landwer@free.fr>

--=-9W+DZoCts8yO98pagc2d
Content-Disposition: attachment; filename=halt.txt
Content-Type: text/plain; name=halt.txt; charset=utf-8
Content-Transfer-Encoding: 8bit

Jan 24 01:11:21 cocoduo syslogd 1.4.1#18ubuntu6: restart.
Jan 24 01:11:21 cocoduo kernel: Inspecting /boot/System.map-2.6.19.2-mactel
Jan 24 01:11:21 cocoduo kernel: Loaded 24013 symbols from /boot/System.map-2.6.19.2-mactel.
Jan 24 01:11:21 cocoduo kernel: Symbols match kernel version 2.6.19.
Jan 24 01:11:21 cocoduo kernel: No module symbols loaded - kernel modules not enabled. 
Jan 24 01:11:21 cocoduo kernel: [    0.000000] Linux version 2.6.19.2-mactel (root@cocoduo) (gcc version 4.1.2 20060928 (prerelease) (Ubuntu 4.1.1-13ubuntu5)) #2 SMP Mon Jan 22 11:08:41 CET 2007
Jan 24 01:11:21 cocoduo kernel: [    0.000000] BIOS-provided physical RAM map:
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 00000000000ede00 - 0000000000100000 (reserved)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007dfdc000 (usable)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 000000007dfdc000 - 000000007e1dd000 (ACPI NVS)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 000000007e1dd000 - 000000007eebf000 (ACPI data)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 000000007eebf000 - 000000007eeef000 (ACPI NVS)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 000000007eeef000 - 000000007ef00000 (ACPI data)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 000000007ef00000 - 0000000080000000 (reserved)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jan 24 01:11:21 cocoduo kernel: [    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
Jan 24 01:11:21 cocoduo kernel: [    0.000000] 1119MB HIGHMEM available.
Jan 24 01:11:21 cocoduo kernel: [    0.000000] 896MB LOWMEM available.
Jan 24 01:11:21 cocoduo kernel: [    0.000000] Entering add_active_range(0, 0, 516060) 0 entries of 256 used
Jan 24 01:11:21 cocoduo kernel: [    0.000000] Zone PFN ranges:
Jan 24 01:11:21 cocoduo kernel: [    0.000000]   DMA             0 ->     4096
Jan 24 01:11:21 cocoduo kernel: [    0.000000]   Normal       4096 ->   229376
Jan 24 01:11:21 cocoduo kernel: [    0.000000]   HighMem    229376 ->   516060
Jan 24 01:11:21 cocoduo kernel: [    0.000000] early_node_map[1] active PFN ranges
Jan 24 01:11:21 cocoduo kernel: [    0.000000]     0:        0 ->   516060
Jan 24 01:11:21 cocoduo kernel: [    0.000000] On node 0 totalpages: 516060
Jan 24 01:11:21 cocoduo kernel: [    0.000000]   DMA zone: 32 pages used for memmap
Jan 24 01:11:21 cocoduo kernel: [    0.000000]   DMA zone: 0 pages reserved
Jan 24 01:11:21 cocoduo kernel: [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
Jan 24 01:11:21 cocoduo kernel: [    0.000000]   Normal zone: 1760 pages used for memmap
Jan 24 01:11:21 cocoduo kernel: [    0.000000]   Normal zone: 223520 pages, LIFO batch:31
Jan 24 01:11:21 cocoduo kernel: [    0.000000]   HighMem zone: 2239 pages used for memmap
Jan 24 01:11:21 cocoduo kernel: [    0.000000]   HighMem zone: 284445 pages, LIFO batch:31
Jan 24 01:11:21 cocoduo kernel: [    0.000000] DMI 2.4 present.
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: RSDP (v002 APPLE                                 ) @ 0x000fe020
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: XSDT (v001 APPLE   Apple00 0x00000061      0x01000013) @ 0x7eefd120
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: FADT (v003 APPLE   Apple00 0x00000061 Loki 0x0000005f) @ 0x7eefb000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: HPET (v001 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eefa000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: MADT (v001 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eef9000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: MCFG (v001 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eef8000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: ASF! (v032 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eef7000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: SBST (v001 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eef6000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: ECDT (v001 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eef5000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: SSDT (v001 APPLE   SataPri 0x00001000 INTL 0x20050309) @ 0x7eebc000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: SSDT (v001 APPLE   SataSec 0x00001000 INTL 0x20050309) @ 0x7eebb000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: SSDT (v001 APPLE     CpuPm 0x00003000 INTL 0x20050309) @ 0x7eeef000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: DSDT (v001 APPLE   MacBook 0x00010001 INTL 0x20050309) @ 0x00000000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jan 24 01:11:21 cocoduo kernel: [    0.000000] Processor #0 6:14 APIC version 20
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Jan 24 01:11:21 cocoduo kernel: [    0.000000] Processor #1 6:14 APIC version 20
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
Jan 24 01:11:21 cocoduo kernel: [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: IRQ0 used by override.
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: IRQ2 used by override.
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: IRQ9 used by override.
Jan 24 01:11:21 cocoduo kernel: [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
Jan 24 01:11:21 cocoduo kernel: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
Jan 24 01:11:21 cocoduo kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Jan 24 01:11:21 cocoduo kernel: [    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
Jan 24 01:11:21 cocoduo kernel: [    0.000000] Detected 2130.039 MHz processor.
Jan 24 01:11:21 cocoduo kernel: [   30.741001] Built 1 zonelists.  Total pages: 512029
Jan 24 01:11:21 cocoduo kernel: [   30.741004] Kernel command line: root=/dev/sda1 ro lpj=8000000 idle=halt quiet splash
Jan 24 01:11:21 cocoduo kernel: [   30.741018] using halt in idle threads.
Jan 24 01:11:21 cocoduo kernel: [   30.741164] mapped APIC to ffffd000 (fee00000)
Jan 24 01:11:21 cocoduo kernel: [   30.741166] mapped IOAPIC to ffffc000 (fec00000)
Jan 24 01:11:21 cocoduo kernel: [   30.741169] Enabling fast FPU save and restore... done.
Jan 24 01:11:21 cocoduo kernel: [   30.741171] Enabling unmasked SIMD FPU exception support... done.
Jan 24 01:11:21 cocoduo kernel: [   30.741174] Initializing CPU#0
Jan 24 01:11:21 cocoduo kernel: [   30.741250] PID hash table entries: 4096 (order: 12, 16384 bytes)
Jan 24 01:11:21 cocoduo kernel: [   30.742708] Console: colour VGA+ 80x25
Jan 24 01:11:21 cocoduo kernel: [   30.742926] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Jan 24 01:11:21 cocoduo kernel: [   30.743255] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Jan 24 01:11:21 cocoduo kernel: [   30.894683] Memory: 2036768k/2064240k available (1956k kernel code, 26140k reserved, 1125k data, 312k init, 1146736k highmem)
Jan 24 01:11:21 cocoduo kernel: [   30.894692] virtual kernel memory layout:
Jan 24 01:11:21 cocoduo kernel: [   30.894693]     fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
Jan 24 01:11:21 cocoduo kernel: [   30.894695]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Jan 24 01:11:21 cocoduo kernel: [   30.894696]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
Jan 24 01:11:21 cocoduo kernel: [   30.894697]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
Jan 24 01:11:21 cocoduo kernel: [   30.894698]       .init : 0xc0409000 - 0xc0457000   ( 312 kB)
Jan 24 01:11:21 cocoduo kernel: [   30.894700]       .data : 0xc02e93e1 - 0xc0402b74   (1125 kB)
Jan 24 01:11:21 cocoduo kernel: [   30.894701]       .text : 0xc0100000 - 0xc02e93e1   (1956 kB)
Jan 24 01:11:21 cocoduo kernel: [   30.894704] Checking if this processor honours the WP bit even in supervisor mode... Ok.
Jan 24 01:11:21 cocoduo kernel: [   30.898409] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Jan 24 01:11:21 cocoduo kernel: [   30.898414] hpet0: 3 64-bit timers, 14318180 Hz
Jan 24 01:11:21 cocoduo kernel: [   30.899357] Using HPET for base-timer
Jan 24 01:11:21 cocoduo kernel: [   30.899363] Calibrating delay loop (skipped)... 4000.00 BogoMIPS preset
Jan 24 01:11:21 cocoduo kernel: [   30.899398] Security Framework v1.0.0 initialized
Jan 24 01:11:21 cocoduo kernel: [   30.899407] SELinux:  Disabled at boot.
Jan 24 01:11:21 cocoduo kernel: [   30.899421] Mount-cache hash table entries: 512
Jan 24 01:11:21 cocoduo kernel: [   30.899550] CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000
Jan 24 01:11:21 cocoduo kernel: [   30.899559] monitor/mwait feature present.
Jan 24 01:11:21 cocoduo kernel: [   30.899563] CPU: L1 I cache: 32K, L1 D cache: 32K
Jan 24 01:11:21 cocoduo kernel: [   30.899565] CPU: L2 cache: 2048K
Jan 24 01:11:21 cocoduo kernel: [   30.899567] CPU: Physical Processor ID: 0
Jan 24 01:11:21 cocoduo kernel: [   30.899569] CPU: Processor Core ID: 0
Jan 24 01:11:21 cocoduo kernel: [   30.899571] CPU: After all inits, caps: bfe9fbff 00100000 00000000 00000140 0000c1a9 00000000 00000000
Jan 24 01:11:21 cocoduo kernel: [   30.899579] Compat vDSO mapped to ffffe000.
Jan 24 01:11:21 cocoduo kernel: [   30.899590] Checking 'hlt' instruction... OK.
Jan 24 01:11:21 cocoduo kernel: [   30.913471] SMP alternatives: switching to UP code
Jan 24 01:11:21 cocoduo kernel: [   30.913645] ACPI: Core revision 20060707
Jan 24 01:11:21 cocoduo kernel: [   30.971520] CPU0: Intel Genuine Intel(R) CPU            1500  @ 2.00GHz stepping 08
Jan 24 01:11:21 cocoduo kernel: [   30.971530] SMP alternatives: switching to SMP code
Jan 24 01:11:21 cocoduo kernel: [   30.971563] Booting processor 1/1 eip 3000
Jan 24 01:11:21 cocoduo kernel: [   30.981497] Initializing CPU#1
Jan 24 01:11:21 cocoduo kernel: [   30.982179] Calibrating delay loop (skipped)... 4000.00 BogoMIPS preset
Jan 24 01:11:21 cocoduo kernel: [   30.982184] CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000
Jan 24 01:11:21 cocoduo kernel: [   30.982190] monitor/mwait feature present.
Jan 24 01:11:21 cocoduo kernel: [   30.982193] CPU: L1 I cache: 32K, L1 D cache: 32K
Jan 24 01:11:21 cocoduo kernel: [   30.982195] CPU: L2 cache: 2048K
Jan 24 01:11:21 cocoduo kernel: [   30.982197] CPU: Physical Processor ID: 0
Jan 24 01:11:21 cocoduo kernel: [   30.982198] CPU: Processor Core ID: 1
Jan 24 01:11:21 cocoduo kernel: [   30.982200] CPU: After all inits, caps: bfe9fbff 00100000 00000000 00000140 0000c1a9 00000000 00000000
Jan 24 01:11:21 cocoduo kernel: [   30.982549] CPU1: Intel Genuine Intel(R) CPU            1500  @ 2.00GHz stepping 08
Jan 24 01:11:21 cocoduo kernel: [   30.982572] Total of 2 processors activated (8000.00 BogoMIPS).
Jan 24 01:11:21 cocoduo kernel: [   30.982756] ENABLING IO-APIC IRQs
Jan 24 01:11:21 cocoduo kernel: [   30.982943] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Jan 24 01:11:21 cocoduo kernel: [   31.119367] checking TSC synchronization across 2 CPUs: passed.
Jan 24 01:11:21 cocoduo kernel: [    0.003743] Brought up 2 CPUs
Jan 24 01:11:21 cocoduo kernel: [    0.154452] migration_cost=53
Jan 24 01:11:21 cocoduo kernel: [    0.154571] checking if image is initramfs... it is
Jan 24 01:11:21 cocoduo kernel: [    0.649095] Freeing initrd memory: 5281k freed
Jan 24 01:11:21 cocoduo kernel: [    0.649410] NET: Registered protocol family 16
Jan 24 01:11:21 cocoduo kernel: [    0.649493] EISA bus registered
Jan 24 01:11:21 cocoduo kernel: [    0.649497] ACPI: bus type pci registered
Jan 24 01:11:21 cocoduo kernel: [    0.649508] PCI: Using MMCONFIG
Jan 24 01:11:21 cocoduo kernel: [    0.650170] Setting up standard PCI resources
Jan 24 01:11:21 cocoduo kernel: [    0.656113] ACPI: Interpreter enabled
Jan 24 01:11:21 cocoduo kernel: [    0.656116] ACPI: Using IOAPIC for interrupt routing
Jan 24 01:11:21 cocoduo kernel: [    0.656647] ACPI: PCI Root Bridge [PCI0] (0000:00)
Jan 24 01:11:21 cocoduo kernel: [    0.656654] PCI: Probing PCI hardware (bus 00)
Jan 24 01:11:21 cocoduo kernel: [    0.659703] Boot video device is 0000:00:02.0
Jan 24 01:11:21 cocoduo kernel: [    0.660182] PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
Jan 24 01:11:21 cocoduo kernel: [    0.660186] PCI quirk: region 0500-053f claimed by ICH6 GPIO
Jan 24 01:11:21 cocoduo kernel: [    0.660228] PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
Jan 24 01:11:21 cocoduo kernel: [    0.661021] PCI: Transparent bridge - 0000:00:1e.0
Jan 24 01:11:21 cocoduo kernel: [    0.661066] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jan 24 01:11:21 cocoduo kernel: [    0.668249] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
Jan 24 01:11:21 cocoduo kernel: [    0.668493] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
Jan 24 01:11:21 cocoduo kernel: [    0.669895] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
Jan 24 01:11:21 cocoduo kernel: [    0.670715] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
Jan 24 01:11:21 cocoduo kernel: [    0.670938] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
Jan 24 01:11:21 cocoduo kernel: [    0.671155] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
Jan 24 01:11:21 cocoduo kernel: [    0.671373] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
Jan 24 01:11:21 cocoduo kernel: [    0.671590] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
Jan 24 01:11:21 cocoduo kernel: [    0.671809] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
Jan 24 01:11:21 cocoduo kernel: [    0.672026] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
Jan 24 01:11:21 cocoduo kernel: [    0.672242] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
Jan 24 01:11:21 cocoduo kernel: [    0.679162] Linux Plug and Play Support v0.97 (c) Adam Belay
Jan 24 01:11:21 cocoduo kernel: [    0.679175] pnp: PnP ACPI init
Jan 24 01:11:21 cocoduo kernel: [    0.683115] pnp: PnP ACPI: found 10 devices
Jan 24 01:11:21 cocoduo kernel: [    0.683119] PnPBIOS: Disabled by ACPI PNP
Jan 24 01:11:21 cocoduo kernel: [    0.683149] intel_rng: FWH not detected
Jan 24 01:11:21 cocoduo kernel: [    0.683264] PCI: Using ACPI for IRQ routing
Jan 24 01:11:21 cocoduo kernel: [    0.683267] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Jan 24 01:11:21 cocoduo kernel: [    0.684028] PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
Jan 24 01:11:21 cocoduo kernel: [    0.684033] PCI: Bridge: 0000:00:1c.0
Jan 24 01:11:21 cocoduo kernel: [    0.684036]   IO window: 1000-1fff
Jan 24 01:11:21 cocoduo kernel: [    0.684041]   MEM window: 90200000-902fffff
Jan 24 01:11:21 cocoduo kernel: [    0.684045]   PREFETCH window: 90500000-905fffff
Jan 24 01:11:21 cocoduo kernel: [    0.684050] PCI: Bridge: 0000:00:1c.1
Jan 24 01:11:21 cocoduo kernel: [    0.684051]   IO window: disabled.
Jan 24 01:11:21 cocoduo kernel: [    0.684056]   MEM window: 90100000-901fffff
Jan 24 01:11:21 cocoduo kernel: [    0.684060]   PREFETCH window: disabled.
Jan 24 01:11:21 cocoduo kernel: [    0.684064] PCI: Bridge: 0000:00:1e.0
Jan 24 01:11:21 cocoduo kernel: [    0.684066]   IO window: disabled.
Jan 24 01:11:21 cocoduo kernel: [    0.684070]   MEM window: 90000000-900fffff
Jan 24 01:11:21 cocoduo kernel: [    0.684074]   PREFETCH window: disabled.
Jan 24 01:11:21 cocoduo kernel: [    0.684096] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 16
Jan 24 01:11:21 cocoduo kernel: [    0.684103] PCI: Setting latency timer of device 0000:00:1c.0 to 64
Jan 24 01:11:21 cocoduo kernel: [    0.684121] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 17
Jan 24 01:11:21 cocoduo kernel: [    0.684126] PCI: Setting latency timer of device 0000:00:1c.1 to 64
Jan 24 01:11:21 cocoduo kernel: [    0.684137] PCI: Setting latency timer of device 0000:00:1e.0 to 64
Jan 24 01:11:21 cocoduo kernel: [    0.684160] NET: Registered protocol family 2
Jan 24 01:11:21 cocoduo kernel: [    0.730313] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Jan 24 01:11:21 cocoduo kernel: [    0.730418] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Jan 24 01:11:21 cocoduo kernel: [    0.731736] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Jan 24 01:11:21 cocoduo kernel: [    0.732383] TCP: Hash tables configured (established 131072 bind 65536)
Jan 24 01:11:21 cocoduo kernel: [    0.732386] TCP reno registered
Jan 24 01:11:21 cocoduo kernel: [    0.732929] audit: initializing netlink socket (disabled)
Jan 24 01:11:21 cocoduo kernel: [    0.732943] audit(1169597457.044:1): initialized
Jan 24 01:11:21 cocoduo kernel: [    0.733023] highmem bounce pool size: 64 pages
Jan 24 01:11:21 cocoduo kernel: [    0.733103] VFS: Disk quotas dquot_6.5.1
Jan 24 01:11:21 cocoduo kernel: [    0.733128] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Jan 24 01:11:21 cocoduo kernel: [    0.733172] io scheduler noop registered
Jan 24 01:11:21 cocoduo kernel: [    0.733175] io scheduler anticipatory registered
Jan 24 01:11:21 cocoduo kernel: [    0.733177] io scheduler deadline registered
Jan 24 01:11:21 cocoduo kernel: [    0.733188] io scheduler cfq registered (default)
Jan 24 01:11:21 cocoduo kernel: [    0.733487] PCI: Setting latency timer of device 0000:00:1c.0 to 64
Jan 24 01:11:21 cocoduo kernel: [    0.733531] assign_interrupt_mode Found MSI capability
Jan 24 01:11:21 cocoduo kernel: [    0.733576] Allocate Port Service[0000:00:1c.0:pcie00]
Jan 24 01:11:21 cocoduo kernel: [    0.733616] Allocate Port Service[0000:00:1c.0:pcie02]
Jan 24 01:11:21 cocoduo kernel: [    0.733647] Allocate Port Service[0000:00:1c.0:pcie03]
Jan 24 01:11:21 cocoduo kernel: [    0.733738] PCI: Setting latency timer of device 0000:00:1c.1 to 64
Jan 24 01:11:21 cocoduo kernel: [    0.733781] assign_interrupt_mode Found MSI capability
Jan 24 01:11:21 cocoduo kernel: [    0.733815] Allocate Port Service[0000:00:1c.1:pcie00]
Jan 24 01:11:21 cocoduo kernel: [    0.733847] Allocate Port Service[0000:00:1c.1:pcie02]
Jan 24 01:11:21 cocoduo kernel: [    0.733878] Allocate Port Service[0000:00:1c.1:pcie03]
Jan 24 01:11:21 cocoduo kernel: [    0.734039] isapnp: Scanning for PnP cards...
Jan 24 01:11:21 cocoduo kernel: [    1.065814] isapnp: No Plug & Play device found
Jan 24 01:11:21 cocoduo kernel: [    1.086593] Real Time Clock Driver v1.12ac
Jan 24 01:11:21 cocoduo kernel: [    1.086642] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Jan 24 01:11:21 cocoduo kernel: [    1.087684] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
Jan 24 01:11:21 cocoduo kernel: [    1.087775] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Jan 24 01:11:21 cocoduo kernel: [    1.087778] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Jan 24 01:11:21 cocoduo kernel: [    1.088082] PNP: No PS/2 controller found. Probing ports directly.
Jan 24 01:11:21 cocoduo kernel: [    1.088886] i8042.c: No controller found.
Jan 24 01:11:21 cocoduo kernel: [    1.088983] mice: PS/2 mouse device common for all mice
Jan 24 01:11:21 cocoduo kernel: [    1.089068] EISA: Probing bus 0 at eisa.0
Jan 24 01:11:21 cocoduo kernel: [    1.089075] Cannot allocate resource for EISA slot 1
Jan 24 01:11:21 cocoduo kernel: [    1.089077] Cannot allocate resource for EISA slot 2
Jan 24 01:11:21 cocoduo kernel: [    1.089104] EISA: Detected 0 cards.
Jan 24 01:11:21 cocoduo kernel: [    1.089185] TCP cubic registered
Jan 24 01:11:21 cocoduo kernel: [    1.089192] NET: Registered protocol family 1
Jan 24 01:11:21 cocoduo kernel: [    1.089197] NET: Registered protocol family 8
Jan 24 01:11:21 cocoduo kernel: [    1.089198] NET: Registered protocol family 20
Jan 24 01:11:21 cocoduo kernel: [    1.089256] Starting balanced_irq
Jan 24 01:11:21 cocoduo kernel: [    1.089266] Using IPI No-Shortcut mode
Jan 24 01:11:21 cocoduo kernel: [    1.089345] Apple MacBook detected (ICH7 SCI_EN quirk enabled)
Jan 24 01:11:21 cocoduo kernel: [    1.089347] ACPI: (supports S0 S3 S4 S5)
Jan 24 01:11:21 cocoduo kernel: [    1.089533] Freeing unused kernel memory: 312k freed
Jan 24 01:11:21 cocoduo kernel: [    1.089793] Time: tsc clocksource has been installed.
Jan 24 01:11:21 cocoduo kernel: [    2.173068] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [APPLE ] OemTableId [ Cpu0Ist] [20060707]
Jan 24 01:11:21 cocoduo kernel: [    2.173266] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [APPLE ] OemTableId [ Cpu0Cst] [20060707]
Jan 24 01:11:21 cocoduo kernel: [    2.173557] Monitor-Mwait will be used to enter C-1 state
Jan 24 01:11:21 cocoduo kernel: [    2.173560] Monitor-Mwait will be used to enter C-2 state
Jan 24 01:11:21 cocoduo kernel: [    2.173562] Monitor-Mwait will be used to enter C-3 state
Jan 24 01:11:21 cocoduo kernel: [    2.173570] ACPI: Processor [CPU0] (supports 8 throttling states)
Jan 24 01:11:21 cocoduo kernel: [    2.174034] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [APPLE ] OemTableId [ Cpu1Ist] [20060707]
Jan 24 01:11:21 cocoduo kernel: [    2.174207] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [APPLE ] OemTableId [ Cpu1Cst] [20060707]
Jan 24 01:11:21 cocoduo kernel: [    2.174543] ACPI: Processor [CPU1] (supports 8 throttling states)
Jan 24 01:11:21 cocoduo kernel: [    2.433486] ICH7: IDE controller at PCI slot 0000:00:1f.1
Jan 24 01:11:21 cocoduo kernel: [    2.433501] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
Jan 24 01:11:21 cocoduo kernel: [    2.433511] ICH7: chipset revision 2
Jan 24 01:11:21 cocoduo kernel: [    2.433513] ICH7: not 100%% native mode: will probe irqs later
Jan 24 01:11:21 cocoduo kernel: [    2.433523]     ide0: BM-DMA at 0x20c0-0x20c7, BIOS settings: hda:DMA, hdb:pio
Jan 24 01:11:21 cocoduo kernel: [    2.433536]     ide1: BM-DMA at 0x20c8-0x20cf, BIOS settings: hdc:pio, hdd:pio
Jan 24 01:11:21 cocoduo kernel: [    2.433544] Probing IDE interface ide0...
Jan 24 01:11:21 cocoduo kernel: [    3.123644] hda: MATSHITADVD-R UJ-857, ATAPI CD/DVD-ROM drive
Jan 24 01:11:21 cocoduo kernel: [    3.438191] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Jan 24 01:11:21 cocoduo kernel: [    3.438219] Probing IDE interface ide1...
Jan 24 01:11:21 cocoduo kernel: [    3.974587] SCSI subsystem initialized
Jan 24 01:11:21 cocoduo kernel: [    3.978606] libata version 2.00 loaded.
Jan 24 01:11:21 cocoduo kernel: [    3.979907] ata_piix 0000:00:1f.2: version 2.00ac6
Jan 24 01:11:21 cocoduo kernel: [    3.979914] ata_piix 0000:00:1f.2: MAP [ P0 P2 XX XX ]
Jan 24 01:11:21 cocoduo kernel: [    3.979918] ata_piix 0000:00:1f.2: invalid MAP value 0
Jan 24 01:11:21 cocoduo kernel: [    4.123253] PCI: Enabling device 0000:00:1f.2 (0005 -> 0007)
Jan 24 01:11:21 cocoduo kernel: [    4.123260] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
Jan 24 01:11:21 cocoduo kernel: [    4.123276] PCI: Setting latency timer of device 0000:00:1f.2 to 64
Jan 24 01:11:21 cocoduo kernel: [    4.123307] ata1: SATA max UDMA/133 cmd 0x20D8 ctl 0x20FE bmdma 0x2020 irq 19
Jan 24 01:11:21 cocoduo kernel: [    4.123331] ata2: SATA max UDMA/133 cmd 0x20D0 ctl 0x20FA bmdma 0x2028 irq 19
Jan 24 01:11:21 cocoduo kernel: [    4.123342] scsi0 : ata_piix
Jan 24 01:11:21 cocoduo kernel: [    4.279714] ATA: abnormal status 0x7F on port 0x20DF
Jan 24 01:11:21 cocoduo kernel: [    4.290094] ATA: abnormal status 0x7F on port 0x20DF
Jan 24 01:11:21 cocoduo kernel: [    4.291224] ata1.01: ATA-7, max UDMA/133, 156301488 sectors: LBA48 NCQ (depth 0/32)
Jan 24 01:11:21 cocoduo kernel: [    4.291227] ata1.01: ata1: dev 1 multi count 16
Jan 24 01:11:21 cocoduo kernel: [    4.294678] ata1.01: configured for UDMA/133
Jan 24 01:11:21 cocoduo kernel: [    4.294682] scsi1 : ata_piix
Jan 24 01:11:21 cocoduo kernel: [    4.448206] ATA: abnormal status 0x7F on port 0x20D7
Jan 24 01:11:21 cocoduo kernel: [    4.448296] scsi 0:0:1:0: Direct-Access     ATA      ST98823AS        7.01 PQ: 0 ANSI: 5
Jan 24 01:11:21 cocoduo kernel: [    4.454195] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Jan 24 01:11:21 cocoduo kernel: [    4.454206] sda: Write Protect is off
Jan 24 01:11:21 cocoduo kernel: [    4.454208] sda: Mode Sense: 00 3a 00 00
Jan 24 01:11:21 cocoduo kernel: [    4.454222] SCSI device sda: drive cache: write back
Jan 24 01:11:21 cocoduo kernel: [    4.454271] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Jan 24 01:11:21 cocoduo kernel: [    4.454280] sda: Write Protect is off
Jan 24 01:11:21 cocoduo kernel: [    4.454282] sda: Mode Sense: 00 3a 00 00
Jan 24 01:11:21 cocoduo kernel: [    4.454296] SCSI device sda: drive cache: write back
Jan 24 01:11:21 cocoduo kernel: [    4.454299]  sda:<6>hda: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(66)
Jan 24 01:11:21 cocoduo kernel: [    4.460070] Uniform CD-ROM driver Revision: 3.20
Jan 24 01:11:21 cocoduo kernel: [    4.526363]  sda1 sda2
Jan 24 01:11:21 cocoduo kernel: [    4.549788] sd 0:0:1:0: Attached scsi disk sda
Jan 24 01:11:21 cocoduo kernel: [    4.778835] Probing IDE interface ide1...
Jan 24 01:11:21 cocoduo kernel: [    4.798884] usbcore: registered new interface driver usbfs
Jan 24 01:11:21 cocoduo kernel: [    4.798904] usbcore: registered new interface driver hub
Jan 24 01:11:21 cocoduo kernel: [    4.798924] usbcore: registered new device driver usb
Jan 24 01:11:21 cocoduo kernel: [    4.799794] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 20
Jan 24 01:11:21 cocoduo kernel: [    4.799806] PCI: Setting latency timer of device 0000:00:1d.7 to 64
Jan 24 01:11:21 cocoduo kernel: [    4.799810] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Jan 24 01:11:21 cocoduo kernel: [    4.799913] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
Jan 24 01:11:21 cocoduo kernel: [    4.799944] ehci_hcd 0000:00:1d.7: debug port 1
Jan 24 01:11:21 cocoduo kernel: [    4.799949] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
Jan 24 01:11:21 cocoduo kernel: [    4.799958] ehci_hcd 0000:00:1d.7: irq 20, io mem 0x90445400
Jan 24 01:11:21 cocoduo kernel: [    4.803607] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Jan 24 01:11:21 cocoduo kernel: [    4.803679] usb usb1: configuration #1 chosen from 1 choice
Jan 24 01:11:21 cocoduo kernel: [    4.803706] hub 1-0:1.0: USB hub found
Jan 24 01:11:21 cocoduo kernel: [    4.803713] hub 1-0:1.0: 8 ports detected
Jan 24 01:11:21 cocoduo kernel: [    4.822838] ieee1394: Initialized config rom entry `ip1394'
Jan 24 01:11:21 cocoduo kernel: [    4.826385] USB Universal Host Controller Interface driver v3.0
Jan 24 01:11:21 cocoduo kernel: [    4.898559] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 20
Jan 24 01:11:21 cocoduo kernel: [    4.898571] PCI: Setting latency timer of device 0000:00:1d.0 to 64
Jan 24 01:11:21 cocoduo kernel: [    4.898574] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Jan 24 01:11:21 cocoduo kernel: [    4.898597] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Jan 24 01:11:21 cocoduo kernel: [    4.898625] uhci_hcd 0000:00:1d.0: irq 20, io base 0x000020a0
Jan 24 01:11:21 cocoduo kernel: [    4.898711] usb usb2: configuration #1 chosen from 1 choice
Jan 24 01:11:21 cocoduo kernel: [    4.898735] hub 2-0:1.0: USB hub found
Jan 24 01:11:21 cocoduo kernel: [    4.898740] hub 2-0:1.0: 2 ports detected
Jan 24 01:11:21 cocoduo kernel: [    4.995908] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
Jan 24 01:11:21 cocoduo kernel: [    4.995918] PCI: Setting latency timer of device 0000:00:1d.1 to 64
Jan 24 01:11:21 cocoduo kernel: [    4.995921] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Jan 24 01:11:21 cocoduo kernel: [    4.995942] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
Jan 24 01:11:21 cocoduo kernel: [    4.995971] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002080
Jan 24 01:11:21 cocoduo kernel: [    4.996056] usb usb3: configuration #1 chosen from 1 choice
Jan 24 01:11:21 cocoduo kernel: [    4.996078] hub 3-0:1.0: USB hub found
Jan 24 01:11:21 cocoduo kernel: [    4.996083] hub 3-0:1.0: 2 ports detected
Jan 24 01:11:21 cocoduo kernel: [    5.093252] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
Jan 24 01:11:21 cocoduo kernel: [    5.093259] PCI: Setting latency timer of device 0000:00:1d.2 to 64
Jan 24 01:11:21 cocoduo kernel: [    5.093262] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Jan 24 01:11:21 cocoduo kernel: [    5.093287] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
Jan 24 01:11:21 cocoduo kernel: [    5.093315] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002060
Jan 24 01:11:21 cocoduo kernel: [    5.093393] usb usb4: configuration #1 chosen from 1 choice
Jan 24 01:11:21 cocoduo kernel: [    5.093412] hub 4-0:1.0: USB hub found
Jan 24 01:11:21 cocoduo kernel: [    5.093417] hub 4-0:1.0: 2 ports detected
Jan 24 01:11:21 cocoduo kernel: [    5.190632] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 17
Jan 24 01:11:21 cocoduo kernel: [    5.190639] PCI: Setting latency timer of device 0000:00:1d.3 to 64
Jan 24 01:11:21 cocoduo kernel: [    5.190642] uhci_hcd 0000:00:1d.3: UHCI Host Controller
Jan 24 01:11:21 cocoduo kernel: [    5.190666] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
Jan 24 01:11:21 cocoduo kernel: [    5.190693] uhci_hcd 0000:00:1d.3: irq 17, io base 0x00002040
Jan 24 01:11:21 cocoduo kernel: [    5.190767] usb usb5: configuration #1 chosen from 1 choice
Jan 24 01:11:21 cocoduo kernel: [    5.190786] hub 5-0:1.0: USB hub found
Jan 24 01:11:21 cocoduo kernel: [    5.190791] hub 5-0:1.0: 2 ports detected
Jan 24 01:11:21 cocoduo kernel: [    5.289286] ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 19 (level, low) -> IRQ 19
Jan 24 01:11:21 cocoduo kernel: [    5.295439] usb 1-4: new high speed USB device using ehci_hcd and address 3
Jan 24 01:11:21 cocoduo kernel: [    5.337824] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[90000000-900007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
Jan 24 01:11:21 cocoduo kernel: [    5.358978] Attempting manual resume
Jan 24 01:11:21 cocoduo kernel: [    5.400061] kjournald starting.  Commit interval 5 seconds
Jan 24 01:11:21 cocoduo kernel: [    5.400067] EXT3-fs: mounted filesystem with ordered data mode.
Jan 24 01:11:21 cocoduo kernel: [    5.419425] usb 1-4: configuration #1 chosen from 1 choice
Jan 24 01:11:21 cocoduo kernel: [    5.988255] usb 2-2: new full speed USB device using uhci_hcd and address 2
Jan 24 01:11:21 cocoduo kernel: [    6.171122] usb 2-2: configuration #1 chosen from 1 choice
Jan 24 01:11:21 cocoduo kernel: [    6.523789] usb 4-2: new full speed USB device using uhci_hcd and address 2
Jan 24 01:11:21 cocoduo kernel: [    6.535138] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0017f2fffe6a9282]
Jan 24 01:11:21 cocoduo kernel: [    6.698181] usb 4-2: configuration #1 chosen from 1 choice
Jan 24 01:11:21 cocoduo kernel: [    6.924505] usb 5-1: new full speed USB device using uhci_hcd and address 2
Jan 24 01:11:21 cocoduo kernel: [    7.096097] usb 5-1: configuration #1 chosen from 1 choice
Jan 24 01:11:21 cocoduo kernel: [   14.923434] input: PC Speaker as /class/input/input0
Jan 24 01:11:21 cocoduo kernel: [   15.040139] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jan 24 01:11:21 cocoduo kernel: [   15.042998] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Jan 24 01:11:21 cocoduo kernel: [   15.053333] Linux agpgart interface v0.101 (c) Dave Jones
Jan 24 01:11:21 cocoduo kernel: [   15.055383] agpgart: Detected an Intel 945GM Chipset.
Jan 24 01:11:21 cocoduo kernel: [   15.056400] agpgart: Detected 16124K stolen memory.
Jan 24 01:11:21 cocoduo kernel: [   15.070110] agpgart: AGP aperture is 256M @ 0x80000000
Jan 24 01:11:21 cocoduo kernel: [   15.303158] ath_hal: module license 'Proprietary' taints kernel.
Jan 24 01:11:21 cocoduo kernel: [   15.304048] ath_hal: 0.9.17.2 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
Jan 24 01:11:21 cocoduo kernel: [   15.315236] wlan: 0.8.4.2 (0.9.2.1)
Jan 24 01:11:21 cocoduo kernel: [   15.316276] ath_rate_sample: 1.2 (0.9.2.1)
Jan 24 01:11:21 cocoduo kernel: [   15.349784] usbcore: registered new interface driver hiddev
Jan 24 01:11:21 cocoduo kernel: [   15.391834] ath_pci: 0.9.4.5 (0.9.2.1)
Jan 24 01:11:21 cocoduo kernel: [   15.391894] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 16
Jan 24 01:11:21 cocoduo kernel: [   15.391906] PCI: Setting latency timer of device 0000:02:00.0 to 64
Jan 24 01:11:21 cocoduo kernel: [   15.400994] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input1
Jan 24 01:11:21 cocoduo kernel: [   15.401035] input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
Jan 24 01:11:21 cocoduo kernel: [   15.404656] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input2
Jan 24 01:11:21 cocoduo kernel: [   15.404690] input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
Jan 24 01:11:21 cocoduo kernel: [   15.512331] input: HID 05ac:1000 as /class/input/input3
Jan 24 01:11:21 cocoduo kernel: [   15.512372] input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
Jan 24 01:11:21 cocoduo kernel: [   15.529161] input: HID 05ac:1000 as /class/input/input4
Jan 24 01:11:21 cocoduo kernel: [   15.529212] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
Jan 24 01:11:21 cocoduo kernel: [   15.529221] usbcore: registered new interface driver usbhid
Jan 24 01:11:21 cocoduo kernel: [   15.529225] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
Jan 24 01:11:21 cocoduo kernel: [   15.884471] wifi0: 11a rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
Jan 24 01:11:21 cocoduo kernel: [   15.884480] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
Jan 24 01:11:21 cocoduo kernel: [   15.884484] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
Jan 24 01:11:21 cocoduo kernel: [   15.884493] wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
Jan 24 01:11:21 cocoduo kernel: [   15.884498] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
Jan 24 01:11:21 cocoduo kernel: [   15.884502] wifi0: mac 10.3 phy 6.1 radio 10.2
Jan 24 01:11:21 cocoduo kernel: [   15.884506] wifi0: Use hw queue 1 for WME_AC_BE traffic
Jan 24 01:11:21 cocoduo kernel: [   15.884508] wifi0: Use hw queue 0 for WME_AC_BK traffic
Jan 24 01:11:21 cocoduo kernel: [   15.884511] wifi0: Use hw queue 2 for WME_AC_VI traffic
Jan 24 01:11:21 cocoduo kernel: [   15.884513] wifi0: Use hw queue 3 for WME_AC_VO traffic
Jan 24 01:11:21 cocoduo kernel: [   15.884515] wifi0: Use hw queue 8 for CAB traffic
Jan 24 01:11:21 cocoduo kernel: [   15.884516] wifi0: Use hw queue 9 for beacons
Jan 24 01:11:21 cocoduo kernel: [   15.970429] tpm_inf_pnp 00:03: Found TPM with ID IFX0101
Jan 24 01:11:21 cocoduo kernel: [   15.970480] tpm_inf_pnp 00:03: TPM found: config base 0x4e, io base 0x4700, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
Jan 24 01:11:21 cocoduo kernel: [   16.028311] input: Apple Mac mini infrared remote control driver as /class/input/input5
Jan 24 01:11:21 cocoduo kernel: [   16.028352] usbcore: registered new interface driver appleir
Jan 24 01:11:21 cocoduo kernel: [   16.028355] drivers/usb/input/appleir.c: v1.1:USB Apple MacMini IR Receiver driver
Jan 24 01:11:21 cocoduo kernel: [   16.029557] wifi0: Atheros 5424: mem=0x90100000, irq=16
Jan 24 01:11:21 cocoduo kernel: [   16.029673] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 17
Jan 24 01:11:21 cocoduo kernel: [   16.029685] PCI: Setting latency timer of device 0000:01:00.0 to 64
Jan 24 01:11:21 cocoduo kernel: [   16.029750] sky2 v1.10 addr 0x90200000 irq 17 Yukon-EC (0xb6) rev 2
Jan 24 01:11:21 cocoduo kernel: [   16.030170] sky2 eth0: addr 00:17:f2:2c:fb:0a
Jan 24 01:11:21 cocoduo kernel: [   16.083616] sd 0:0:1:0: Attached scsi generic sg0 type 0
Jan 24 01:11:21 cocoduo kernel: [   16.121805] appletouch Geyser 3 inited.
Jan 24 01:11:21 cocoduo kernel: [   16.121867] input: appletouch as /class/input/input6
Jan 24 01:11:21 cocoduo kernel: [   16.121921] usbcore: registered new interface driver appletouch
Jan 24 01:11:21 cocoduo kernel: [   16.129048] sky2 eth0: enabling interface
Jan 24 01:11:21 cocoduo kernel: [   16.300996] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
Jan 24 01:11:21 cocoduo kernel: [   16.301016] PCI: Setting latency timer of device 0000:00:1b.0 to 64
Jan 24 01:11:21 cocoduo kernel: [   16.874706] lp: driver loaded but no devices found
Jan 24 01:11:21 cocoduo kernel: [   16.896812] ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=1)
Jan 24 01:11:21 cocoduo kernel: [   16.896816] ieee1394: sbp2: Try serialize_io=0 for better performance
Jan 24 01:11:21 cocoduo kernel: [   16.957431] applesmc: Apple MacBook detected:
Jan 24 01:11:21 cocoduo kernel: [   16.957434] applesmc:  - Model with accelerometer
Jan 24 01:11:21 cocoduo kernel: [   16.957436] applesmc:  - Model without light sensors and backlight
Jan 24 01:11:21 cocoduo kernel: [   16.957438] applesmc:  - Model with 7 temperature sensors
Jan 24 01:11:21 cocoduo kernel: [   16.958677] applesmc: device has already been initialized (0xe0, 0x00).
Jan 24 01:11:21 cocoduo kernel: [   16.958679] applesmc: device successfully initialized.
Jan 24 01:11:21 cocoduo kernel: [   16.958930] applesmc: 1 fans found.
Jan 24 01:11:21 cocoduo kernel: [   16.959704] input: applesmc as /class/input/input7
Jan 24 01:11:21 cocoduo kernel: [   16.959902] applesmc: driver successfully loaded.
Jan 24 01:11:21 cocoduo kernel: [   16.992785] Adding 2096472k swap on /dev/disk/by-uuid/dc3f9a9e-8b28-4987-827a-d226978d8e1b.  Priority:-1 extents:1 across:2096472k
Jan 24 01:11:21 cocoduo kernel: [   17.063774] EXT3 FS on sda1, internal journal
Jan 24 01:11:21 cocoduo kernel: [   17.217765] NET: Registered protocol family 17
Jan 24 01:11:21 cocoduo kernel: [   17.862016] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
Jan 24 01:11:21 cocoduo kernel: [   21.798709] NET: Registered protocol family 10
Jan 24 01:11:21 cocoduo kernel: [   21.798849] lo: Disabled Privacy Extensions
Jan 24 01:11:21 cocoduo kernel: [   22.993286] ACPI: AC Adapter [ADP1] (on-line)
Jan 24 01:11:21 cocoduo kernel: [   23.084249] ACPI: Battery Slot [BAT0] (battery present)
Jan 24 01:11:21 cocoduo kernel: [   23.097778] ACPI: Power Button (FF) [PWRF]
Jan 24 01:11:21 cocoduo kernel: [   23.097791] ACPI: Lid Switch [LID0]
Jan 24 01:11:21 cocoduo kernel: [   23.097798] ACPI: Power Button (CM) [PWRB]
Jan 24 01:11:21 cocoduo kernel: [   23.097804] ACPI: Sleep Button (CM) [SLPB]
Jan 24 01:11:21 cocoduo kernel: [   23.111533] Using specific hotkey driver
Jan 24 01:11:21 cocoduo kernel: [   23.222290] ibm_acpi: ec object not found
Jan 24 01:11:21 cocoduo kernel: [   23.267635] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
Jan 24 01:11:21 cocoduo kernel: [   23.281388] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
Jan 24 01:11:24 cocoduo hpiod: 1.6.9 accepting connections at 2208... 
Jan 24 01:11:24 cocoduo kernel: [   26.641139] [drm] Initialized drm 1.0.1 20051102
Jan 24 01:11:24 cocoduo kernel: [   26.680201] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 17
Jan 24 01:11:24 cocoduo kernel: [   26.681008] [drm] Initialized i915 1.5.0 20060119 on minor 0
Jan 24 01:11:28 cocoduo gconfd (djdeath-4595): démarrage (version 2.16.0), pid 4595 utilisateur « djdeath »
Jan 24 01:11:28 cocoduo rpc.statd[4596]: Version 1.0.9 Starting
Jan 24 01:11:28 cocoduo kernel: [   31.192106] eth0: no IPv6 routers present
Jan 24 01:11:29 cocoduo gconfd (djdeath-4595): Adresse « xml:readonly:/etc/gconf/gconf.xml.mandatory » résolue vers une source de configuration en lecture seule à la position 0
Jan 24 01:11:29 cocoduo gconfd (djdeath-4595): Adresse « xml:readwrite:/home/djdeath/.gconf » résolue vers une source de configuration accessible en écriture à la position 1
Jan 24 01:11:29 cocoduo gconfd (djdeath-4595): Adresse « xml:readonly:/etc/gconf/gconf.xml.defaults » résolue vers une source de configuration en lecture seule à la position 2
Jan 24 01:11:29 cocoduo gconfd (djdeath-4595): Adresse « xml:readonly:/var/lib/gconf/debian.defaults » résolue vers une source de configuration en lecture seule à la position 3
Jan 24 01:11:29 cocoduo gconfd (djdeath-4595): Adresse « xml:readonly:/var/lib/gconf/defaults » résolue vers une source de configuration en lecture seule à la position 4
Jan 24 01:11:29 cocoduo hcid[4617]: Bluetooth HCI daemon
Jan 24 01:11:29 cocoduo kernel: [   31.665101] Bluetooth: Core ver 2.11
Jan 24 01:11:29 cocoduo kernel: [   31.665524] NET: Registered protocol family 31
Jan 24 01:11:29 cocoduo kernel: [   31.665529] Bluetooth: HCI device and connection manager initialized
Jan 24 01:11:29 cocoduo kernel: [   31.665534] Bluetooth: HCI socket layer initialized
Jan 24 01:11:29 cocoduo hcid[4617]: Register path:/org/bluez fallback:1
Jan 24 01:11:29 cocoduo kernel: [   31.716495] Bluetooth: L2CAP ver 2.8
Jan 24 01:11:29 cocoduo kernel: [   31.716502] Bluetooth: L2CAP socket layer initialized
Jan 24 01:11:29 cocoduo sdpd[4627]: Bluetooth SDP daemon 
Jan 24 01:11:29 cocoduo kernel: [   31.744981] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
Jan 24 01:11:29 cocoduo kernel: [   31.838403] Bluetooth: RFCOMM socket layer initialized
Jan 24 01:11:29 cocoduo kernel: [   31.838420] Bluetooth: RFCOMM TTY layer initialized
Jan 24 01:11:29 cocoduo kernel: [   31.838424] Bluetooth: RFCOMM ver 1.8
Jan 24 01:11:29 cocoduo anacron[4659]: Anacron 2.3 started on 2007-01-24
Jan 24 01:11:29 cocoduo kernel: [   31.967606] usb 5-1: USB disconnect, address 2
Jan 24 01:11:29 cocoduo anacron[4659]: Normal exit (0 jobs run)
Jan 24 01:11:29 cocoduo /usr/sbin/cron[4699]: (CRON) INFO (pidfile fd = 3)
Jan 24 01:11:29 cocoduo /usr/sbin/cron[4700]: (CRON) STARTUP (fork ok)
Jan 24 01:11:29 cocoduo /usr/sbin/cron[4700]: (CRON) INFO (Running @reboot jobs)
Jan 24 01:11:29 cocoduo kernel: [   32.192040] usb 5-1: new full speed USB device using uhci_hcd and address 3
Jan 24 01:11:30 cocoduo kernel: [   32.378442] usb 5-1: configuration #1 chosen from 1 choice
Jan 24 01:11:30 cocoduo kernel: [   32.538911] Bluetooth: HCI USB driver ver 2.9
Jan 24 01:11:30 cocoduo hcid[4617]: HCI dev 0 registered
Jan 24 01:11:30 cocoduo kernel: [   32.541355] usbcore: registered new interface driver hci_usb
Jan 24 01:11:30 cocoduo hcid[4617]: Register path:/org/bluez/hci0 fallback:0
Jan 24 01:11:30 cocoduo hcid[4617]: HCI dev 0 up
Jan 24 01:11:30 cocoduo hcid[4617]: Device hci0 has been added
Jan 24 01:11:30 cocoduo hcid[4617]: Starting security manager 0
Jan 24 01:11:30 cocoduo hcid[4617]: Device hci0 has been activated
Jan 24 01:11:37 cocoduo gconfd (djdeath-4595): Adresse « xml:readwrite:/home/djdeath/.gconf » résolue vers une source de configuration accessible en écriture à la position 0
Jan 24 01:11:37 cocoduo hcid[4617]: name_listener_add(:1.6)
Jan 24 01:11:37 cocoduo hcid[4617]: Default passkey agent (:1.6, /org/bluez/applet) registered
Jan 24 01:17:02 cocoduo /USR/SBIN/CRON[5487]: (root) CMD (   run-parts --report /etc/cron.hourly)
Jan 24 01:31:21 cocoduo -- MARK --
Jan 24 01:37:02 cocoduo kernel: [ 1562.672639] NETDEV WATCHDOG: eth0: transmit timed out
Jan 24 01:37:02 cocoduo kernel: [ 1562.672648] sky2 eth0: tx timeout
Jan 24 01:37:02 cocoduo kernel: [ 1562.672656] sky2 eth0: transmit ring 243 .. 222 report=244 done=244
Jan 24 01:37:02 cocoduo kernel: [ 1562.672660] sky2 status report lost?
Jan 24 01:37:08 cocoduo gnome-power-manager: (djdeath) Déconnexion interactive GNOME car Le bouton de mise sous tension a été pressé
Jan 24 01:37:11 cocoduo kernel: [ 1571.787958] BUG: soft lockup detected on CPU#0!
Jan 24 01:37:11 cocoduo kernel: [ 1571.787989]  [softlockup_tick+155/208] softlockup_tick+0x9b/0xd0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788007]  [update_process_times+49/128] update_process_times+0x31/0x80
Jan 24 01:37:11 cocoduo kernel: [ 1571.788020]  [smp_apic_timer_interrupt+145/176] smp_apic_timer_interrupt+0x91/0xb0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788032]  [apic_timer_interrupt+31/36] apic_timer_interrupt+0x1f/0x24
Jan 24 01:37:11 cocoduo kernel: [ 1571.788048]  [_spin_lock_bh+15/32] _spin_lock_bh+0xf/0x20
Jan 24 01:37:11 cocoduo kernel: [ 1571.788061]  [pg0+946730645/1068803072] sky2_tx_timeout+0xf5/0x1d0 [sky2]
Jan 24 01:37:11 cocoduo kernel: [ 1571.788083]  [dev_watchdog+0/208] dev_watchdog+0x0/0xd0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788090]  [dev_watchdog+192/208] dev_watchdog+0xc0/0xd0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788099]  [run_timer_softirq+273/400] run_timer_softirq+0x111/0x190
Jan 24 01:37:11 cocoduo kernel: [ 1571.788114]  [__do_softirq+116/240] __do_softirq+0x74/0xf0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788125]  [do_softirq+59/80] do_softirq+0x3b/0x50
Jan 24 01:37:11 cocoduo kernel: [ 1571.788134]  [smp_apic_timer_interrupt+150/176] smp_apic_timer_interrupt+0x96/0xb0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788143]  [apic_timer_interrupt+31/36] apic_timer_interrupt+0x1f/0x24
Jan 24 01:37:11 cocoduo kernel: [ 1571.788153]  [default_idle+0/112] default_idle+0x0/0x70
Jan 24 01:37:11 cocoduo kernel: [ 1571.788166]  [default_idle+54/112] default_idle+0x36/0x70
Jan 24 01:37:11 cocoduo kernel: [ 1571.788175]  [cpu_idle+116/208] cpu_idle+0x74/0xd0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788184]  [start_kernel+872/1072] start_kernel+0x368/0x430
Jan 24 01:37:11 cocoduo kernel: [ 1571.788194]  [unknown_bootoption+0/624] unknown_bootoption+0x0/0x270
Jan 24 01:37:11 cocoduo kernel: [ 1571.788208]  =======================
Jan 24 01:37:12 cocoduo gconfd (djdeath-4595): Sortie
Jan 24 01:37:12 cocoduo hcid[4617]: :1.6 exited without unregistering the default passkey agent
Jan 24 01:37:13 cocoduo gdm[4251]: Arrêt du maître…
Jan 24 01:37:32 cocoduo init: rc0 process (6318) killed by signal 15

--=-9W+DZoCts8yO98pagc2d--

