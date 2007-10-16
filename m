Return-Path: <linux-kernel-owner+w=401wt.eu-S935171AbXJPSjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935171AbXJPSjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbXJPSjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:39:43 -0400
Received: from rtr.ca ([76.10.145.34]:2262 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958AbXJPSjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:39:40 -0400
Message-ID: <47150565.5090102@rtr.ca>
Date: Tue, 16 Oct 2007 14:39:33 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
References: <4714C0A6.1030204@rtr.ca>	<4714D700.7060008@rtr.ca> <20071016084634.8a0d695a.kristen.c.accardi@intel.com>
In-Reply-To: <20071016084634.8a0d695a.kristen.c.accardi@intel.com>
Content-Type: multipart/mixed;
 boundary="------------050107040009090008050101"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050107040009090008050101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Kristen Carlson Accardi wrote:
>
> Hi Mark,
> So, just to make sure I understand, your reproducer for the failing case is:
> 1.  Boot laptop with no card.
> 2.  Load pciehp

Note that at this point I can insert/remove cards and they work fine.
If I suspend with card inserted, then lspci still shows the card on resume
but pciehp no longer functions (doesn't notice insert/removal events).

> 3.  Suspend laptop (slot is still empty)
> 4.  Resume laptop (slot is still empty)
> 5.  insert card - card is not detected.

Correct.  Then rmmod pciehp; modprobe pciehp;  and it works again.

Another thing:  if a card is already in the slot before pciehp is loaded
(under any circumstances), then pciehp does *not* see the card until I
unplug/replug it.

I also checked my modprobe.d/ options, and I am using pciehp_force=1.
Without that flag, none of this ever works.

> Can you tell me which Dell laptop you have, and also send me the dmesg
> output of the failing case after loading pciehp with pciehp_debug=1.

I'm attaching a syslog capture (if you just want the kernel stuff,
then just do:  grep 'kernel|logger' syslog.txt

Also attached is a full  lspci -vv  for this machine,
which happens to be a Dell Inspiron 9400 with 2.1GHz Core2Duo
and 2GB of RAM.

Cheers

--------------050107040009090008050101
Content-Type: text/plain;
 name="syslog.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="syslog.txt"

Oct 16 14:19:16 corey syslogd 1.4.1#20ubuntu4: restart.
Oct 16 14:19:16 corey dhclient: bound to 10.0.0.6 -- renewal in 33709 seconds.
Oct 16 14:19:16 corey kernel: Inspecting /boot/System.map-2.6.23.1
Oct 16 14:19:16 corey kernel: Loaded 24564 symbols from /boot/System.map-2.6.23.1.
Oct 16 14:19:16 corey kernel: Symbols match kernel version 2.6.23.
Oct 16 14:19:16 corey kernel: No module symbols loaded - kernel modules not enabled. 
Oct 16 14:19:16 corey kernel: Linux version 2.6.23.1 (root@corey) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #1 SMP PREEMPT Sun Oct 14 16:48:27 EDT 2007
Oct 16 14:19:16 corey kernel: BIOS-provided physical RAM map:
Oct 16 14:19:16 corey kernel:  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
Oct 16 14:19:16 corey kernel:  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
Oct 16 14:19:16 corey kernel:  BIOS-e820: 0000000000100000 - 000000007fed3400 (usable)
Oct 16 14:19:16 corey kernel:  BIOS-e820: 000000007fed3400 - 0000000080000000 (reserved)
Oct 16 14:19:16 corey kernel:  BIOS-e820: 00000000f0000000 - 00000000f4007000 (reserved)
Oct 16 14:19:16 corey kernel:  BIOS-e820: 00000000f4008000 - 00000000f400c000 (reserved)
Oct 16 14:19:16 corey kernel:  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
Oct 16 14:19:16 corey kernel:  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
Oct 16 14:19:16 corey kernel:  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
Oct 16 14:19:16 corey kernel:  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
Oct 16 14:19:16 corey kernel: 1150MB HIGHMEM available.
Oct 16 14:19:16 corey kernel: 896MB LOWMEM available.
Oct 16 14:19:16 corey kernel: Entering add_active_range(0, 0, 523987) 0 entries of 256 used
Oct 16 14:19:16 corey kernel: Zone PFN ranges:
Oct 16 14:19:16 corey kernel:   DMA             0 ->     4096
Oct 16 14:19:16 corey kernel:   Normal       4096 ->   229376
Oct 16 14:19:16 corey kernel:   HighMem    229376 ->   523987
Oct 16 14:19:16 corey kernel: Movable zone start PFN for each node
Oct 16 14:19:16 corey kernel: early_node_map[1] active PFN ranges
Oct 16 14:19:16 corey kernel:     0:        0 ->   523987
Oct 16 14:19:16 corey kernel: On node 0 totalpages: 523987
Oct 16 14:19:16 corey kernel:   DMA zone: 32 pages used for memmap
Oct 16 14:19:16 corey kernel:   DMA zone: 0 pages reserved
Oct 16 14:19:16 corey kernel:   DMA zone: 4064 pages, LIFO batch:0
Oct 16 14:19:16 corey kernel:   Normal zone: 1760 pages used for memmap
Oct 16 14:19:16 corey kernel:   Normal zone: 223520 pages, LIFO batch:31
Oct 16 14:19:16 corey kernel:   HighMem zone: 2301 pages used for memmap
Oct 16 14:19:16 corey kernel:   HighMem zone: 292310 pages, LIFO batch:31
Oct 16 14:19:16 corey kernel:   Movable zone: 0 pages used for memmap
Oct 16 14:19:16 corey kernel: DMI 2.4 present.
Oct 16 14:19:16 corey kernel: ACPI: RSDP 000FC1B0, 0014 (r0 DELL  )
Oct 16 14:19:16 corey kernel: ACPI: RSDT 7FED39CD, 0040 (r1 DELL    M07     27D7061B ASL        61)
Oct 16 14:19:16 corey kernel: ACPI: FACP 7FED4800, 0074 (r1 DELL    M07     27D7061B ASL        61)
Oct 16 14:19:16 corey kernel: ACPI: DSDT 7FED5400, 4841 (r1 INT430 SYSFexxx     1001 INTL 20050624)
Oct 16 14:19:16 corey kernel: ACPI: FACS 7FEE3C00, 0040
Oct 16 14:19:16 corey kernel: ACPI: HPET 7FED4F00, 0038 (r1 DELL    M07            1 ASL        61)
Oct 16 14:19:16 corey kernel: ACPI: APIC 7FED5000, 0068 (r1 DELL    M07     27D7061B ASL        47)
Oct 16 14:19:16 corey kernel: ACPI: MCFG 7FED4FC0, 003E (r16 DELL    M07     27D7061B ASL        61)
Oct 16 14:19:16 corey kernel: ACPI: SLIC 7FED509C, 0176 (r1 DELL    M07     27D7061B ASL        61)
Oct 16 14:19:16 corey kernel: ACPI: BOOT 7FED4BC0, 0028 (r1 DELL    M07     27D7061B ASL        61)
Oct 16 14:19:16 corey kernel: ACPI: SSDT 7FED3A0D, 04DC (r1  PmRef    CpuPm     3000 INTL 20050624)
Oct 16 14:19:16 corey kernel: ACPI: PM-Timer IO Port: 0x1008
Oct 16 14:19:16 corey kernel: ACPI: Local APIC address 0xfee00000
Oct 16 14:19:16 corey kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Oct 16 14:19:16 corey kernel: Processor #0 6:15 APIC version 20
Oct 16 14:19:16 corey kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Oct 16 14:19:16 corey kernel: Processor #1 6:15 APIC version 20
Oct 16 14:19:16 corey kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Oct 16 14:19:16 corey kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Oct 16 14:19:16 corey kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Oct 16 14:19:16 corey kernel: IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
Oct 16 14:19:16 corey kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Oct 16 14:19:16 corey kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Oct 16 14:19:16 corey kernel: ACPI: IRQ0 used by override.
Oct 16 14:19:16 corey kernel: ACPI: IRQ2 used by override.
Oct 16 14:19:16 corey kernel: ACPI: IRQ9 used by override.
Oct 16 14:19:16 corey kernel: Enabling APIC mode:  Flat.  Using 1 I/O APICs
Oct 16 14:19:16 corey kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Oct 16 14:19:16 corey kernel: Using ACPI (MADT) for SMP configuration information
Oct 16 14:19:16 corey kernel: Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
Oct 16 14:19:16 corey kernel: swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
Oct 16 14:19:16 corey kernel: swsusp: Registered nosave memory region: 00000000000a0000 - 0000000000100000
Oct 16 14:19:16 corey kernel: Built 1 zonelists in Zone order.  Total pages: 519894
Oct 16 14:19:16 corey kernel: Kernel command line: root=/dev/sda1 ro resume=/dev/sda3 vga=ext
Oct 16 14:19:16 corey kernel: mapped APIC to ffffb000 (fee00000)
Oct 16 14:19:16 corey kernel: mapped IOAPIC to ffffa000 (fec00000)
Oct 16 14:19:16 corey kernel: Enabling fast FPU save and restore... done.
Oct 16 14:19:16 corey kernel: Enabling unmasked SIMD FPU exception support... done.
Oct 16 14:19:16 corey kernel: Initializing CPU#0
Oct 16 14:19:16 corey kernel: CPU 0 irqstacks, hard=c0375000 soft=c0373000
Oct 16 14:19:16 corey kernel: PID hash table entries: 4096 (order: 12, 16384 bytes)
Oct 16 14:19:16 corey kernel: Detected 2161.357 MHz processor.
Oct 16 14:19:16 corey syslogd: /dev/console: Resource temporarily unavailable
Oct 16 14:19:16 corey kernel: Console: colour VGA+ 80x50
Oct 16 14:19:16 corey kernel: console [tty0] enabled
Oct 16 14:19:16 corey kernel: Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Oct 16 14:19:16 corey kernel: Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Oct 16 14:19:16 corey kernel: Memory: 2074644k/2095948k available (1618k kernel code, 20180k reserved, 673k data, 184k init, 1178444k highmem)
Oct 16 14:19:16 corey kernel: virtual kernel memory layout:
Oct 16 14:19:16 corey kernel:     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
Oct 16 14:19:16 corey kernel:     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Oct 16 14:19:16 corey kernel:     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
Oct 16 14:19:16 corey kernel:     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
Oct 16 14:19:16 corey kernel:       .init : 0xc0342000 - 0xc0370000   ( 184 kB)
Oct 16 14:19:16 corey kernel:       .data : 0xc0294b7a - 0xc033d180   ( 673 kB)
Oct 16 14:19:16 corey kernel:       .text : 0xc0100000 - 0xc0294b7a   (1618 kB)
Oct 16 14:19:16 corey kernel: Checking if this processor honours the WP bit even in supervisor mode... Ok.
Oct 16 14:19:16 corey kernel: SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Oct 16 14:19:16 corey kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Oct 16 14:19:16 corey kernel: hpet0: 3 64-bit timers, 14318180 Hz
Oct 16 14:19:16 corey kernel: Calibrating delay using timer specific routine.. 4327.32 BogoMIPS (lpj=7210119)
Oct 16 14:19:16 corey kernel: Mount-cache hash table entries: 512
Oct 16 14:19:16 corey kernel: CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
Oct 16 14:19:16 corey kernel: monitor/mwait feature present.
Oct 16 14:19:16 corey kernel: using mwait in idle threads.
Oct 16 14:19:16 corey kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Oct 16 14:19:16 corey kernel: CPU: L2 cache: 4096K
Oct 16 14:19:16 corey kernel: CPU: Physical Processor ID: 0
Oct 16 14:19:16 corey kernel: CPU: Processor Core ID: 0
Oct 16 14:19:16 corey kernel: CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Oct 16 14:19:16 corey kernel: Compat vDSO mapped to ffffe000.
Oct 16 14:19:16 corey kernel: Checking 'hlt' instruction... OK.
Oct 16 14:19:16 corey kernel: SMP alternatives: switching to UP code
Oct 16 14:19:16 corey kernel: ACPI: Core revision 20070126
Oct 16 14:19:16 corey kernel: CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
Oct 16 14:19:16 corey kernel: SMP alternatives: switching to SMP code
Oct 16 14:19:16 corey kernel: Booting processor 1/1 eip 3000
Oct 16 14:19:16 corey kernel: CPU 1 irqstacks, hard=c0376000 soft=c0374000
Oct 16 14:19:16 corey kernel: Initializing CPU#1
Oct 16 14:19:16 corey kernel: Calibrating delay using timer specific routine.. 4324.64 BogoMIPS (lpj=7204227)
Oct 16 14:19:16 corey kernel: CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
Oct 16 14:19:16 corey kernel: monitor/mwait feature present.
Oct 16 14:19:16 corey kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Oct 16 14:19:16 corey kernel: CPU: L2 cache: 4096K
Oct 16 14:19:16 corey kernel: CPU: Physical Processor ID: 0
Oct 16 14:19:16 corey kernel: CPU: Processor Core ID: 1
Oct 16 14:19:16 corey kernel: CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Oct 16 14:19:16 corey kernel: CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
Oct 16 14:19:16 corey kernel: Total of 2 processors activated (8652.96 BogoMIPS).
Oct 16 14:19:16 corey kernel: ENABLING IO-APIC IRQs
Oct 16 14:19:16 corey kernel: ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Oct 16 14:19:16 corey kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
Oct 16 14:19:16 corey kernel: Measured 4037161492 cycles TSC warp between CPUs, turning off TSC clock.
Oct 16 14:19:16 corey kernel: Marking TSC unstable due to: check_tsc_sync_source failed.
Oct 16 14:19:16 corey kernel: Brought up 2 CPUs
Oct 16 14:19:16 corey kernel: NET: Registered protocol family 16
Oct 16 14:19:16 corey kernel: ACPI: bus type pci registered
Oct 16 14:19:16 corey kernel: PCI: Using MMCONFIG
Oct 16 14:19:16 corey kernel: Setting up standard PCI resources
Oct 16 14:19:16 corey kernel: ACPI: EC: Look up EC in DSDT
Oct 16 14:19:16 corey kernel: ACPI: Interpreter enabled
Oct 16 14:19:16 corey kernel: ACPI: (supports S0 S3 S4 S5)
Oct 16 14:19:16 corey kernel: ACPI: Using IOAPIC for interrupt routing
Oct 16 14:19:16 corey kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Oct 16 14:19:16 corey kernel: PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
Oct 16 14:19:16 corey kernel: PCI quirk: region 1080-10bf claimed by ICH6 GPIO
Oct 16 14:19:16 corey kernel: PCI: Transparent bridge - 0000:00:1e.0
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *4
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs *5 7)
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs *9 10 11)
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *3
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
Oct 16 14:19:16 corey kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
Oct 16 14:19:16 corey kernel: pnp: PnP ACPI init
Oct 16 14:19:16 corey kernel: ACPI: bus type pnp registered
Oct 16 14:19:16 corey kernel: pnp: PnP ACPI: found 12 devices
Oct 16 14:19:16 corey kernel: ACPI: ACPI bus type pnp unregistered
Oct 16 14:19:16 corey kernel: SCSI subsystem initialized
Oct 16 14:19:16 corey kernel: libata version 2.21 loaded.
Oct 16 14:19:16 corey kernel: PCI: Using ACPI for IRQ routing
Oct 16 14:19:16 corey kernel: PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Oct 16 14:19:16 corey kernel: ACPI: RTC can wake from S4
Oct 16 14:19:16 corey kernel: Time: hpet clocksource has been installed.
Oct 16 14:19:16 corey kernel: Switched to high resolution mode on CPU 0
Oct 16 14:19:16 corey kernel: Switched to high resolution mode on CPU 1
Oct 16 14:19:16 corey kernel: pnp: 00:00: iomem range 0x0-0x9fbff could not be reserved
Oct 16 14:19:16 corey kernel: pnp: 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
Oct 16 14:19:16 corey kernel: pnp: 00:00: iomem range 0xc0000-0xcffff could not be reserved
Oct 16 14:19:16 corey kernel: pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
Oct 16 14:19:16 corey kernel: pnp: 00:02: ioport range 0x4d0-0x4d1 has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:02: ioport range 0x1000-0x1005 has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:02: ioport range 0x1008-0x100f has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:03: ioport range 0xf400-0xf4fe has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:03: ioport range 0x1006-0x1007 has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:03: ioport range 0x100a-0x1059 could not be reserved
Oct 16 14:19:16 corey kernel: pnp: 00:03: ioport range 0x1060-0x107f has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:03: ioport range 0x1080-0x10bf has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:03: ioport range 0x10c0-0x10df has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:08: ioport range 0xc80-0xcff could not be reserved
Oct 16 14:19:16 corey kernel: pnp: 00:08: ioport range 0x910-0x91f has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:08: ioport range 0x920-0x92f has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:08: ioport range 0xcb0-0xcbf has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:08: ioport range 0x930-0x97f has been reserved
Oct 16 14:19:16 corey kernel: pnp: 00:0b: iomem range 0xfed00000-0xfed003ff has been reserved
Oct 16 14:19:16 corey kernel: PCI: Bridge: 0000:00:01.0
Oct 16 14:19:16 corey kernel:   IO window: e000-efff
Oct 16 14:19:16 corey kernel:   MEM window: efd00000-efefffff
Oct 16 14:19:16 corey kernel:   PREFETCH window: d0000000-dfffffff
Oct 16 14:19:16 corey kernel: PCI: Bridge: 0000:00:1c.0
Oct 16 14:19:16 corey kernel:   IO window: disabled.
Oct 16 14:19:16 corey kernel:   MEM window: disabled.
Oct 16 14:19:16 corey kernel:   PREFETCH window: disabled.
Oct 16 14:19:16 corey kernel: PCI: Bridge: 0000:00:1c.1
Oct 16 14:19:16 corey kernel:   IO window: disabled.
Oct 16 14:19:16 corey kernel:   MEM window: efc00000-efcfffff
Oct 16 14:19:16 corey kernel:   PREFETCH window: disabled.
Oct 16 14:19:16 corey kernel: PCI: Bridge: 0000:00:1c.3
Oct 16 14:19:16 corey kernel:   IO window: d000-dfff
Oct 16 14:19:16 corey kernel:   MEM window: efa00000-efbfffff
Oct 16 14:19:16 corey kernel:   PREFETCH window: e0000000-e01fffff
Oct 16 14:19:16 corey kernel: PCI: Bridge: 0000:00:1e.0
Oct 16 14:19:16 corey kernel:   IO window: disabled.
Oct 16 14:19:16 corey kernel:   MEM window: ef900000-ef9fffff
Oct 16 14:19:16 corey kernel:   PREFETCH window: disabled.
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:01.0 to 64
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1c.0 to 64
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1c.1 to 64
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1c.3 to 64
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64
Oct 16 14:19:16 corey kernel: NET: Registered protocol family 2
Oct 16 14:19:16 corey kernel: IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Oct 16 14:19:16 corey kernel: TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
Oct 16 14:19:16 corey kernel: TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
Oct 16 14:19:16 corey kernel: TCP: Hash tables configured (established 131072 bind 65536)
Oct 16 14:19:16 corey kernel: TCP reno registered
Oct 16 14:19:16 corey kernel: Simple Boot Flag at 0x79 set to 0x1
Oct 16 14:19:16 corey kernel: highmem bounce pool size: 64 pages
Oct 16 14:19:16 corey kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Oct 16 14:19:16 corey kernel: io scheduler noop registered
Oct 16 14:19:16 corey kernel: io scheduler anticipatory registered
Oct 16 14:19:16 corey kernel: io scheduler cfq registered (default)
Oct 16 14:19:16 corey kernel: Boot video device is 0000:01:00.0
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:01.0 to 64
Oct 16 14:19:16 corey kernel: assign_interrupt_mode Found MSI capability
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:01.0:pcie00]
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:01.0:pcie03]
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1c.0 to 64
Oct 16 14:19:16 corey kernel: assign_interrupt_mode Found MSI capability
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:1c.0:pcie00]
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:1c.0:pcie02]
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:1c.0:pcie03]
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1c.1 to 64
Oct 16 14:19:16 corey kernel: assign_interrupt_mode Found MSI capability
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:1c.1:pcie00]
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:1c.1:pcie02]
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:1c.1:pcie03]
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1c.3 to 64
Oct 16 14:19:16 corey kernel: assign_interrupt_mode Found MSI capability
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:1c.3:pcie00]
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:1c.3:pcie02]
Oct 16 14:19:16 corey kernel: Allocate Port Service[0000:00:1c.3:pcie03]
Oct 16 14:19:16 corey kernel: hpet_resources: 0xfed00000 is busy
Oct 16 14:19:16 corey kernel: Generic RTC Driver v1.07
Oct 16 14:19:16 corey kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
Oct 16 14:19:16 corey kernel: RAMDISK driver initialized: 4 RAM disks of 8192K size 1024 blocksize
Oct 16 14:19:16 corey kernel: ata_piix 0000:00:1f.2: version 2.12
Oct 16 14:19:16 corey kernel: ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64
Oct 16 14:19:16 corey kernel: scsi0 : ata_piix
Oct 16 14:19:16 corey kernel: scsi1 : ata_piix
Oct 16 14:19:16 corey kernel: ata1: SATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001bfa0 irq 14
Oct 16 14:19:16 corey kernel: ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001bfa8 irq 15
Oct 16 14:19:16 corey kernel: ata1.00: ATA-7: ST9160823AS, 3.AAB, max UDMA/133
Oct 16 14:19:16 corey kernel: ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 0/32)
Oct 16 14:19:16 corey kernel: ata1.00: configured for UDMA/133
Oct 16 14:19:16 corey kernel: ata2.00: ATAPI: SONY DVD RW DW-Q58A, UYS2, max UDMA/33
Oct 16 14:19:16 corey kernel: ata2.00: configured for UDMA/33
Oct 16 14:19:16 corey kernel: scsi 0:0:0:0: Direct-Access     ATA      ST9160823AS      3.AA PQ: 0 ANSI: 5
Oct 16 14:19:16 corey kernel: sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
Oct 16 14:19:16 corey kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 16 14:19:16 corey kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 16 14:19:16 corey kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 16 14:19:16 corey kernel: sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
Oct 16 14:19:16 corey kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 16 14:19:16 corey kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 16 14:19:16 corey kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 16 14:19:16 corey kernel:  sda: sda1 sda2 sda3
Oct 16 14:19:16 corey kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Oct 16 14:19:16 corey kernel: scsi 1:0:0:0: CD-ROM            SONY     DVD RW DW-Q58A   UYS2 PQ: 0 ANSI: 5
Oct 16 14:19:16 corey kernel: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Oct 16 14:19:16 corey kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Oct 16 14:19:16 corey kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Oct 16 14:19:16 corey kernel: rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
Oct 16 14:19:16 corey kernel: rtc0: alarms up to one month, y3k
Oct 16 14:19:16 corey kernel: TCP cubic registered
Oct 16 14:19:16 corey kernel: Using IPI No-Shortcut mode
Oct 16 14:19:16 corey kernel: input: AT Translated Set 2 keyboard as /class/input/input0
Oct 16 14:19:16 corey kernel: rtc_cmos 00:06: setting the system clock to 2007-10-16 18:19:00 (1192558740)
Oct 16 14:19:16 corey kernel: kjournald starting.  Commit interval 5 seconds
Oct 16 14:19:16 corey kernel: EXT3-fs: mounted filesystem with ordered data mode.
Oct 16 14:19:16 corey kernel: VFS: Mounted root (ext3 filesystem) readonly.
Oct 16 14:19:16 corey kernel: Freeing unused kernel memory: 184k freed
Oct 16 14:19:16 corey kernel: NET: Registered protocol family 1
Oct 16 14:19:16 corey kernel: usbcore: registered new interface driver usbfs
Oct 16 14:19:16 corey kernel: usbcore: registered new interface driver hub
Oct 16 14:19:16 corey kernel: usbcore: registered new device driver usb
Oct 16 14:19:16 corey kernel: USB Universal Host Controller Interface driver v3.0
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 19
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.0: irq 19, io base 0x0000bf80
Oct 16 14:19:16 corey kernel: usb usb1: configuration #1 chosen from 1 choice
Oct 16 14:19:16 corey kernel: hub 1-0:1.0: USB hub found
Oct 16 14:19:16 corey kernel: hub 1-0:1.0: 2 ports detected
Oct 16 14:19:16 corey kernel: Linux agpgart interface v0.102
Oct 16 14:19:16 corey kernel: ACPI: SSDT 7FED4134, 0244 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
Oct 16 14:19:16 corey kernel: ACPI: SSDT 7FED3EE9, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
Oct 16 14:19:16 corey kernel: ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
Oct 16 14:19:16 corey kernel: ACPI: Processor [CPU0] (supports 8 throttling states)
Oct 16 14:19:16 corey kernel: ACPI: SSDT 7FED4378, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
Oct 16 14:19:16 corey kernel: ACPI: SSDT 7FED40AF, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
Oct 16 14:19:16 corey kernel: ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
Oct 16 14:19:16 corey kernel: ACPI: Processor [CPU1] (supports 8 throttling states)
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 20
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000bf60
Oct 16 14:19:16 corey kernel: usb usb2: configuration #1 chosen from 1 choice
Oct 16 14:19:16 corey kernel: hub 2-0:1.0: USB hub found
Oct 16 14:19:16 corey kernel: hub 2-0:1.0: 2 ports detected
Oct 16 14:19:16 corey kernel: ACPI: AC Adapter [AC] (on-line)
Oct 16 14:19:16 corey kernel: input: Lid Switch as /class/input/input1
Oct 16 14:19:16 corey kernel: ACPI: Lid Switch [LID]
Oct 16 14:19:16 corey kernel: input: Power Button (CM) as /class/input/input2
Oct 16 14:19:16 corey kernel: ACPI: Power Button (CM) [PBTN]
Oct 16 14:19:16 corey kernel: input: Sleep Button (CM) as /class/input/input3
Oct 16 14:19:16 corey kernel: ACPI: Sleep Button (CM) [SBTN]
Oct 16 14:19:16 corey kernel: intel_rng: FWH not detected
Oct 16 14:19:16 corey kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Oct 16 14:19:16 corey kernel: sr 1:0:0:0: Attached scsi generic sg1 type 5
Oct 16 14:19:16 corey kernel: sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Oct 16 14:19:16 corey kernel: Uniform CD-ROM driver Revision: 3.20
Oct 16 14:19:16 corey kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0
Oct 16 14:19:16 corey kernel: ACPI: Battery Slot [BAT0] (battery present)
Oct 16 14:19:16 corey kernel: input: PC Speaker as /class/input/input4
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 21
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.2: irq 21, io base 0x0000bf40
Oct 16 14:19:16 corey kernel: usb usb3: configuration #1 chosen from 1 choice
Oct 16 14:19:16 corey kernel: hub 3-0:1.0: USB hub found
Oct 16 14:19:16 corey kernel: hub 3-0:1.0: 2 ports detected
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 22
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
Oct 16 14:19:16 corey kernel: uhci_hcd 0000:00:1d.3: irq 22, io base 0x0000bf20
Oct 16 14:19:16 corey kernel: usb usb4: configuration #1 chosen from 1 choice
Oct 16 14:19:16 corey kernel: hub 4-0:1.0: USB hub found
Oct 16 14:19:16 corey kernel: hub 4-0:1.0: 2 ports detected
Oct 16 14:19:16 corey kernel: sdhci: Secure Digital Host Controller Interface driver
Oct 16 14:19:16 corey kernel: sdhci: Copyright(c) Pierre Ossman
Oct 16 14:19:16 corey kernel: ACPI: Thermal Zone [THM] (52 C)
Oct 16 14:19:16 corey kernel: usb 1-1: new full speed USB device using uhci_hcd and address 2
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 19
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64
Oct 16 14:19:16 corey kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Oct 16 14:19:16 corey kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
Oct 16 14:19:16 corey kernel: ehci_hcd 0000:00:1d.7: debug port 1
Oct 16 14:19:16 corey kernel: PCI: cache line size of 32 is not supported by device 0000:00:1d.7
Oct 16 14:19:16 corey kernel: ehci_hcd 0000:00:1d.7: irq 19, io mem 0xffa80000
Oct 16 14:19:16 corey kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Oct 16 14:19:16 corey kernel: usb usb5: configuration #1 chosen from 1 choice
Oct 16 14:19:16 corey kernel: hub 5-0:1.0: USB hub found
Oct 16 14:19:16 corey kernel: hub 5-0:1.0: 8 ports detected
Oct 16 14:19:16 corey kernel: Synaptics Touchpad, model: 1, fw: 6.2, id: 0xfa0b1, caps: 0xa04713/0x200000
Oct 16 14:19:16 corey kernel: input: SynPS/2 Synaptics TouchPad as /class/input/input5
Oct 16 14:19:16 corey kernel: mice: PS/2 mouse device common for all mice
Oct 16 14:19:16 corey kernel: b44.c:v1.01 (Jun 16, 2006)
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
Oct 16 14:19:16 corey kernel: eth0: Broadcom 4400 10/100BaseT Ethernet 00:18:8b:a7:bf:42
Oct 16 14:19:16 corey kernel: sdhci: SDHCI controller found at 0000:03:01.1 [1180:0822] (rev 19)
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, low) -> IRQ 23
Oct 16 14:19:16 corey kernel: mmc0: SDHCI at 0xef9fd400 irq 23 DMA
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 20
Oct 16 14:19:16 corey kernel: PCI: Setting latency timer of device 0000:00:1b.0 to 64
Oct 16 14:19:16 corey kernel: ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -> IRQ 18
Oct 16 14:19:16 corey kernel: firewire_ohci: Added fw-ohci device 0000:03:01.0, OHCI version 1.10
Oct 16 14:19:16 corey kernel: usb 5-1: new high speed USB device using ehci_hcd and address 2
Oct 16 14:19:16 corey kernel: firewire_sbp2: Unknown parameter `serialize_io'
Oct 16 14:19:16 corey kernel: fuse init (API version 7.8)
Oct 16 14:19:16 corey kernel: usb 5-1: configuration #1 chosen from 1 choice
Oct 16 14:19:16 corey kernel: hub 5-1:1.0: USB hub found
Oct 16 14:19:16 corey kernel: hub 5-1:1.0: 4 ports detected
Oct 16 14:19:16 corey kernel: firewire_core: created new fw device fw0 (0 config rom retries, S400)
Oct 16 14:19:16 corey kernel: usb 5-7: new high speed USB device using ehci_hcd and address 3
Oct 16 14:19:16 corey kernel: usb 5-7: configuration #1 chosen from 1 choice
Oct 16 14:19:16 corey kernel: hub 5-7:1.0: USB hub found
Oct 16 14:19:16 corey kernel: hub 5-7:1.0: 4 ports detected
Oct 16 14:19:16 corey kernel: usb 5-7.2: new full speed USB device using ehci_hcd and address 4
Oct 16 14:19:16 corey kernel: usb 5-7.2: configuration #1 chosen from 1 choice
Oct 16 14:19:16 corey kernel: NET: Registered protocol family 17
Oct 16 14:19:16 corey kernel: usb 5-7.3: new low speed USB device using ehci_hcd and address 5
Oct 16 14:19:16 corey kernel: usb 5-7.3: configuration #1 chosen from 1 choice
Oct 16 14:19:16 corey kernel: usbcore: registered new interface driver usbserial
Oct 16 14:19:16 corey kernel: drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
Oct 16 14:19:16 corey kernel: usbcore: registered new interface driver usbserial_generic
Oct 16 14:19:16 corey kernel: drivers/usb/serial/usb-serial.c: USB Serial Driver core
Oct 16 14:19:16 corey kernel: drivers/usb/serial/usb-serial.c: USB Serial support registered for Handspring Visor / Palm OS
Oct 16 14:19:16 corey kernel: drivers/usb/serial/usb-serial.c: USB Serial support registered for Sony Clie 3.5
Oct 16 14:19:16 corey kernel: drivers/usb/serial/usb-serial.c: USB Serial support registered for Sony Clie 5.0
Oct 16 14:19:16 corey kernel: usbcore: registered new interface driver visor
Oct 16 14:19:16 corey kernel: drivers/usb/serial/visor.c: USB HandSpring Visor / Palm OS driver
Oct 16 14:19:16 corey kernel: drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
Oct 16 14:19:16 corey kernel: pl2303 5-7.2:1.0: pl2303 converter detected
Oct 16 14:19:16 corey kernel: usb 5-7.2: pl2303 converter now attached to ttyUSB0
Oct 16 14:19:16 corey kernel: usbcore: registered new interface driver pl2303
Oct 16 14:19:16 corey kernel: drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
Oct 16 14:19:16 corey kernel: usbcore: registered new interface driver hiddev
Oct 16 14:19:16 corey kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Oct 16 14:19:16 corey kernel: input: Logitech Optical USB Mouse as /class/input/input6
Oct 16 14:19:16 corey kernel: input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.7-7.3
Oct 16 14:19:16 corey kernel: usbcore: registered new interface driver usbhid
Oct 16 14:19:16 corey kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver

Oct 16 14:19:16 corey kernel: pciehp: pcie_init: hotplug controller vendor id 0x8086 device id 0x27d0
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: pcie_cap_base 40
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: CAPREG offset 42 cap_reg 141
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTCAP offset 54 slot_cap 10a0e0
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTSTATUS offset 5a slot_status 0
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTCTRL offset 58 slot_ctrl 8
Oct 16 14:19:16 corey kernel: pciehp: HPC vendor_id 8086 device_id 27d0 ss_vid 0 ss_did 0
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTCTRL 58 value read 8
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: request_irq 16 for hpc0 (returns 0)
Oct 16 14:19:16 corey kernel: pciehp: pciehp ctrl b:d:f:irq=0x0:1c:0:10
Oct 16 14:19:16 corey kernel: pciehp: Bypassing BIOS check for pciehp use on 0000:00:1c.0
Oct 16 14:19:16 corey kernel: pciehp: pciehp_probe: ctrl bus=0x0, device=1c, function=0, irq=10
Oct 16 14:19:16 corey kernel: pciehp: get_power_status - physical_slot = 0011_0002
Oct 16 14:19:16 corey kernel: pciehp: hpc_get_power_status: SLOTCTRL 58 value read 28
Oct 16 14:19:16 corey kernel: pciehp: get_attention_status - physical_slot = 0011_0002
Oct 16 14:19:16 corey kernel: pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 28
Oct 16 14:19:16 corey kernel: pciehp: get_latch_status - physical_slot = 0011_0002
Oct 16 14:19:16 corey kernel: pciehp: get_adapter_status - physical_slot = 0011_0002
Oct 16 14:19:16 corey kernel: pciehp: Registering bus=b dev=0 hp_slot=0 sun=2 slot_device_offset=0
Oct 16 14:19:16 corey kernel: Load service driver hpdriver on pcie device 0000:00:1c.0:pcie02
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: hotplug controller vendor id 0x8086 device id 0x27d2
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: pcie_cap_base 40
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: CAPREG offset 42 cap_reg 141
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTCAP offset 54 slot_cap 18a0e0
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTSTATUS offset 5a slot_status 40
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTCTRL offset 58 slot_ctrl 8
Oct 16 14:19:16 corey kernel: pciehp: pci resource[8] start=0xefc00000(len=0x100000)
Oct 16 14:19:16 corey kernel: pciehp: HPC vendor_id 8086 device_id 27d2 ss_vid 0 ss_did 0
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTCTRL 58 value read 8
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: request_irq 17 for hpc1 (returns 0)
Oct 16 14:19:16 corey kernel: pciehp: pciehp ctrl b:d:f:irq=0x0:1c:1:11
Oct 16 14:19:16 corey kernel: pciehp: Bypassing BIOS check for pciehp use on 0000:00:1c.1
Oct 16 14:19:16 corey kernel: pciehp: pciehp_probe: ctrl bus=0x0, device=1c, function=1, irq=11
Oct 16 14:19:16 corey kernel: pciehp: get_power_status - physical_slot = 0012_0003
Oct 16 14:19:16 corey kernel: pciehp: hpc_get_power_status: SLOTCTRL 58 value read 28
Oct 16 14:19:16 corey kernel: pciehp: get_attention_status - physical_slot = 0012_0003
Oct 16 14:19:16 corey kernel: pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 28
Oct 16 14:19:16 corey kernel: pciehp: get_latch_status - physical_slot = 0012_0003
Oct 16 14:19:16 corey kernel: pciehp: get_adapter_status - physical_slot = 0012_0003
Oct 16 14:19:16 corey kernel: pciehp: Registering bus=c dev=0 hp_slot=0 sun=3 slot_device_offset=0
Oct 16 14:19:16 corey kernel: Load service driver hpdriver on pcie device 0000:00:1c.1:pcie02
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: hotplug controller vendor id 0x8086 device id 0x27d6
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: pcie_cap_base 40
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: CAPREG offset 42 cap_reg 141
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTCAP offset 54 slot_cap 28a0e0
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTSTATUS offset 5a slot_status 0
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTCTRL offset 58 slot_ctrl 8
Oct 16 14:19:16 corey kernel: pciehp: pci resource[7] start=0xd000(len=0x1000)
Oct 16 14:19:16 corey kernel: pciehp: pci resource[8] start=0xefa00000(len=0x200000)
Oct 16 14:19:16 corey kernel: pciehp: pci resource[9] start=0xe0000000(len=0x200000)
Oct 16 14:19:16 corey kernel: pciehp: HPC vendor_id 8086 device_id 27d6 ss_vid 0 ss_did 0
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: SLOTCTRL 58 value read 8
Oct 16 14:19:16 corey kernel: pciehp: pcie_init: request_irq 18 for hpc2 (returns 0)
Oct 16 14:19:16 corey kernel: pciehp: pciehp ctrl b:d:f:irq=0x0:1c:3:12
Oct 16 14:19:16 corey kernel: pciehp: Bypassing BIOS check for pciehp use on 0000:00:1c.3
Oct 16 14:19:16 corey kernel: pciehp: pciehp_probe: ctrl bus=0x0, device=1c, function=3, irq=12
Oct 16 14:19:16 corey kernel: pciehp: get_power_status - physical_slot = 0013_0005
Oct 16 14:19:16 corey kernel: pciehp: hpc_get_power_status: SLOTCTRL 58 value read 28
Oct 16 14:19:16 corey kernel: pciehp: get_attention_status - physical_slot = 0013_0005
Oct 16 14:19:16 corey kernel: pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 28
Oct 16 14:19:16 corey kernel: pciehp: get_latch_status - physical_slot = 0013_0005
Oct 16 14:19:16 corey kernel: pciehp: get_adapter_status - physical_slot = 0013_0005
Oct 16 14:19:16 corey kernel: pciehp: Registering bus=d dev=0 hp_slot=0 sun=5 slot_device_offset=0
Oct 16 14:19:16 corey kernel: Load service driver hpdriver on pcie device 0000:00:1c.3:pcie02
Oct 16 14:19:16 corey kernel: pciehp: pcie_port_service_register = 0
Oct 16 14:19:16 corey kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4

Oct 16 14:19:16 corey kernel: Adding 2064344k swap on /dev/sda3.  Priority:-1 extents:1 across:2064344k
Oct 16 14:19:16 corey kernel: EXT3 FS on sda1, internal journal
Oct 16 14:19:16 corey kernel: kjournald starting.  Commit interval 5 seconds
Oct 16 14:19:16 corey kernel: EXT3 FS on sda2, internal journal
Oct 16 14:19:16 corey kernel: EXT3-fs: mounted filesystem with ordered data mode.
Oct 16 14:19:16 corey kernel: b44: eth0: Link is up at 100 Mbps, full duplex.
Oct 16 14:19:16 corey kernel: b44: eth0: Flow control is off for TX and off for RX.
Oct 16 14:19:16 corey kernel: IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
Oct 16 14:19:16 corey dhcdbd: Started up.
Oct 16 14:19:17 corey atieventsd[3533]: ATI External Events Daemon started... 
Oct 16 14:19:17 corey atieventsd[3533]: Event daemon control socket created 
Oct 16 14:19:17 corey atieventsd[3533]: acpid connection established 
Oct 16 14:19:18 corey kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Oct 16 14:19:18 corey kernel: NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Oct 16 14:19:18 corey kernel: NFSD: starting 90-second grace period
Oct 16 14:19:18 corey sshd[3698]: Server listening on 0.0.0.0 port 22.
Oct 16 14:19:18 corey rpc.statd[3750]: Version 1.0.11 Starting
Oct 16 14:19:19 corey ntpd[3781]: ntpd 4.2.2p4@1.1585-o Wed Mar  7 20:43:30 UTC 2007 (1)
Oct 16 14:19:19 corey ntpd[3782]: precision = 1.000 usec
Oct 16 14:19:19 corey ntpd[3782]: Listening on interface wildcard, 0.0.0.0#123 Disabled
Oct 16 14:19:19 corey ntpd[3782]: Listening on interface lo, 127.0.0.1#123 Enabled
Oct 16 14:19:19 corey ntpd[3782]: Listening on interface eth0, 10.0.0.6#123 Enabled
Oct 16 14:19:19 corey ntpd[3782]: kernel time sync status 0040
Oct 16 14:19:19 corey ntpd[3782]: frequency initialized 137.839 PPM from /var/lib/ntp/ntp.drift
Oct 16 14:19:19 corey hcid[3803]: Bluetooth HCI daemon
Oct 16 14:19:19 corey kernel: Bluetooth: Core ver 2.11
Oct 16 14:19:19 corey kernel: NET: Registered protocol family 31
Oct 16 14:19:19 corey kernel: Bluetooth: HCI device and connection manager initialized
Oct 16 14:19:19 corey kernel: Bluetooth: HCI socket layer initialized
Oct 16 14:19:19 corey hcid[3803]: Starting SDP server
Oct 16 14:19:19 corey kernel: Bluetooth: L2CAP ver 2.8
Oct 16 14:19:19 corey kernel: Bluetooth: L2CAP socket layer initialized
Oct 16 14:19:19 corey kernel: Bluetooth: RFCOMM socket layer initialized
Oct 16 14:19:19 corey kernel: Bluetooth: RFCOMM TTY layer initialized
Oct 16 14:19:19 corey kernel: Bluetooth: RFCOMM ver 1.8
Oct 16 14:19:19 corey anacron[3850]: Anacron 2.3 started on 2007-10-16
Oct 16 14:19:19 corey anacron[3850]: Normal exit (0 jobs run)
Oct 16 14:19:19 corey /usr/sbin/cron[3881]: (CRON) INFO (pidfile fd = 3)
Oct 16 14:19:19 corey /usr/sbin/cron[3882]: (CRON) STARTUP (fork ok)
Oct 16 14:19:19 corey /usr/sbin/cron[3882]: (CRON) INFO (Running @reboot jobs)
Oct 16 14:19:20 corey kernel: vmmon: module license 'unspecified' taints kernel.
Oct 16 14:19:20 corey kernel: /dev/vmmon[3920]: VMCI: Driver initialized.
Oct 16 14:19:20 corey kernel: /dev/vmmon[3920]: Module vmmon: registered with major=10 minor=165
Oct 16 14:19:20 corey kernel: /dev/vmmon[3920]: Initial HV check: anyNotCapable=0 anyUnlocked=0 anyEnabled=1 anyDisabled=0
Oct 16 14:19:20 corey kernel: /dev/vmmon[3920]: HV check: anyNotCapable=0 anyUnlocked=0 anyEnabled=1 anyDisabled=0
Oct 16 14:19:20 corey kernel: /dev/vmmon[3920]: Module vmmon: initialized
Oct 16 14:19:21 corey kernel: /dev/vmnet: open called by PID 3965 (vmnet-bridge)
Oct 16 14:19:21 corey kernel: /dev/vmnet: hub 0 does not exist, allocating memory.
Oct 16 14:19:21 corey kernel: /dev/vmnet: port on hub 0 successfully opened
Oct 16 14:19:21 corey kernel: bridge-eth0: enabling the bridge
Oct 16 14:19:21 corey kernel: bridge-eth0: up
Oct 16 14:19:21 corey kernel: bridge-eth0: already up
Oct 16 14:19:21 corey kernel: bridge-eth0: attached
Oct 16 14:19:21 corey vmnet-dhcpd: Internet Software Consortium DHCP Server 2.0
Oct 16 14:19:21 corey vmnet-dhcpd: Copyright 1995, 1996, 1997, 1998, 1999 The Internet Software Consortium.
Oct 16 14:19:21 corey vmnet-dhcpd: All rights reserved.
Oct 16 14:19:21 corey vmnet-dhcpd: 
Oct 16 14:19:21 corey vmnet-dhcpd: Please contribute if you find this software useful.
Oct 16 14:19:21 corey vmnet-dhcpd: For info, please visit http://www.isc.org/dhcp-contrib.html
Oct 16 14:19:21 corey vmnet-dhcpd: 
Oct 16 14:19:21 corey vmnet-dhcpd: Configured subnet: 192.168.99.0
Oct 16 14:19:21 corey vmnet-dhcpd: Setting vmnet-dhcp IP address: 192.168.99.254
Oct 16 14:19:21 corey vmnet-dhcpd: Recving on     VNet/vmnet1/192.168.99.0
Oct 16 14:19:21 corey vmnet-dhcpd: Sending on     VNet/vmnet1/192.168.99.0
Oct 16 14:19:21 corey kernel: /dev/vmnet: open called by PID 3981 (vmnet-dhcpd)
Oct 16 14:19:21 corey kernel: /dev/vmnet: hub 1 does not exist, allocating memory.
Oct 16 14:19:21 corey kernel: /dev/vmnet: port on hub 1 successfully opened
Oct 16 14:19:21 corey vmnet-dhcpd: Internet Software Consortium DHCP Server 2.0
Oct 16 14:19:21 corey vmnet-dhcpd: Copyright 1995, 1996, 1997, 1998, 1999 The Internet Software Consortium.
Oct 16 14:19:21 corey vmnet-dhcpd: All rights reserved.
Oct 16 14:19:21 corey vmnet-dhcpd: 
Oct 16 14:19:21 corey vmnet-dhcpd: Please contribute if you find this software useful.
Oct 16 14:19:21 corey vmnet-dhcpd: For info, please visit http://www.isc.org/dhcp-contrib.html
Oct 16 14:19:21 corey vmnet-dhcpd: 
Oct 16 14:19:21 corey vmnet-detect[3971]: NetDetectDaemonInit: No host policy file found. Not initializing filter. 
Oct 16 14:19:21 corey vmnet-detect[3971]: Unable to initialize the daemon 
Oct 16 14:19:21 corey vmnet-dhcpd: Configured subnet: 192.168.239.0
Oct 16 14:19:21 corey vmnet-dhcpd: Setting vmnet-dhcp IP address: 192.168.239.254
Oct 16 14:19:21 corey vmnet-dhcpd: Recving on     VNet/vmnet8/192.168.239.0
Oct 16 14:19:21 corey vmnet-dhcpd: Sending on     VNet/vmnet8/192.168.239.0
Oct 16 14:19:21 corey kernel: /dev/vmnet: open called by PID 3992 (vmnet-dhcpd)
Oct 16 14:19:21 corey kernel: /dev/vmnet: hub 8 does not exist, allocating memory.
Oct 16 14:19:21 corey kernel: /dev/vmnet: port on hub 8 successfully opened
Oct 16 14:19:21 corey kernel: /dev/vmnet: open called by PID 3997 (vmnet-natd)
Oct 16 14:19:21 corey kernel: /dev/vmnet: port on hub 8 successfully opened
Oct 16 14:19:30 corey kdm_greet[4100]: Can't open default user face
Oct 16 14:19:31 corey kernel: /dev/vmnet: open called by PID 4103 (vmnet-netifup)
Oct 16 14:19:31 corey kernel: /dev/vmnet: port on hub 1 successfully opened
Oct 16 14:19:31 corey kernel: /dev/vmnet: open called by PID 4114 (vmnet-netifup)
Oct 16 14:19:31 corey kernel: /dev/vmnet: port on hub 8 successfully opened
Oct 16 14:19:37 corey kdm_greet[4100]: Internal error: memory corruption detected
Oct 16 14:19:37 corey kdm: :0[4084]: (pam_unix) session opened for user root by (uid=0)
Oct 16 14:19:57 corey hcid[3803]: Default passkey agent (:1.6, /org/bluez/passkey_agent_4285) registered
Oct 16 14:23:39 corey ntpd[3782]: synchronized to 10.0.0.2, stratum 3
Oct 16 14:23:39 corey ntpd[3782]: time reset -0.240395 s
Oct 16 14:23:39 corey ntpd[3782]: kernel time sync enabled 0001
Oct 16 14:26:38 corey logger: /usr/local/bin/suspend.sh 
Oct 16 14:26:52 corey kernel: Stopping tasks ... done.
Oct 16 14:26:52 corey kernel: Suspending console(s)
Oct 16 14:26:52 corey kernel: pl2303 5-7.2:1.0: no suspend for driver pl2303?
Oct 16 14:26:52 corey kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
Oct 16 14:26:52 corey kernel: sd 0:0:0:0: [sda] Stopping disk

Oct 16 14:26:52 corey kernel: pciehp_suspend ENTRY
Oct 16 14:26:52 corey last message repeated 2 times

Oct 16 14:26:52 corey kernel: ACPI handle has no context!
Oct 16 14:26:52 corey kernel: ACPI: PCI interrupt for device 0000:03:01.1 disabled
Oct 16 14:26:52 corey kernel: ACPI handle has no context!
Oct 16 14:26:52 corey kernel: ACPI: PCI interrupt for device 0000:03:00.0 disabled
Oct 16 14:26:52 corey kernel: ACPI: PCI interrupt for device 0000:00:1f.2 disabled
Oct 16 14:26:52 corey kernel: ACPI: PCI interrupt for device 0000:00:1d.7 disabled
Oct 16 14:26:52 corey kernel: ACPI: PCI interrupt for device 0000:00:1d.3 disabled
Oct 16 14:26:52 corey kernel: ACPI: PCI interrupt for device 0000:00:1d.2 disabled
Oct 16 14:26:52 corey kernel: ACPI: PCI interrupt for device 0000:00:1d.1 disabled
Oct 16 14:26:52 corey kernel: ACPI: PCI interrupt for device 0000:00:1d.0 disabled

Oct 16 14:26:52 corey kernel: pciehp_suspend ENTRY
Oct 16 14:26:52 corey last message repeated 2 times

Oct 16 14:26:52 corey kernel: ACPI: PCI interrupt for device 0000:00:1b.0 disabled
Oct 16 14:26:52 corey kernel: Disabling non-boot CPUs ...
Oct 16 14:26:52 corey kernel: CPU 1 is now offline
Oct 16 14:26:52 corey kernel: SMP alternatives: switching to UP code
Oct 16 14:26:52 corey kernel: CPU1 is down
Oct 16 14:26:52 corey kernel: Back to C!
Oct 16 14:26:52 corey kernel: Enabling non-boot CPUs ...
Oct 16 14:26:52 corey kernel: SMP alternatives: switching to SMP code
Oct 16 14:26:52 corey kernel: Booting processor 1/1 eip 3000
Oct 16 14:26:52 corey kernel: CPU 1 irqstacks, hard=c0376000 soft=c0374000
Oct 16 14:26:52 corey kernel: Initializing CPU#1
Oct 16 14:26:52 corey kernel: Calibrating delay using timer specific routine.. 4324.31 BogoMIPS (lpj=7205309)
Oct 16 14:26:52 corey kernel: CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
Oct 16 14:26:52 corey kernel: monitor/mwait feature present.
Oct 16 14:26:52 corey kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Oct 16 14:26:52 corey kernel: CPU: L2 cache: 4096K
Oct 16 14:26:52 corey kernel: CPU: Physical Processor ID: 0
Oct 16 14:26:52 corey kernel: CPU: Processor Core ID: 1
Oct 16 14:26:52 corey kernel: CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Oct 16 14:26:52 corey kernel: CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
Oct 16 14:26:52 corey kernel: CPU1 is up
Oct 16 14:26:52 corey kernel: Switched to high resolution mode on CPU 1
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:01.0 at offset a (was f, writing 0)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:01.0 at offset 3 (was 10000, writing 10010)
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:01.0 to 64
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1b.0 at offset f (was 100, writing 10b)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1b.0 at offset 4 (was ffa7c004, writing efffc004)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1b.0 at offset 3 (was 0, writing 10)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100000, writing 100102)
Oct 16 14:26:52 corey kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 20
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1b.0 to 64

Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset f (was 100, writing 20100)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 9 (was 10001, writing 1fff1)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 8 (was 0, writing fff0)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 7 (was 0, writing 200000f0)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 6 (was 0, writing b0b00)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 3 (was 810000, writing 810010)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100000, writing 100007)
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1c.0 to 64
Oct 16 14:26:52 corey kernel: pciehp_resume ENTRY

Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset f (was 200, writing 20200)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 9 (was 10001, writing 1fff1)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 8 (was 0, writing efc0efc0)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 7 (was 20000000, writing 200000f0)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 6 (was 0, writing c0c00)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 3 (was 810000, writing 810010)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100000, writing 100107)
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1c.1 to 64
Oct 16 14:26:52 corey kernel: pciehp_resume ENTRY

Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset f (was 400, writing 20400)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 9 (was 10001, writing e011e001)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 8 (was 0, writing efb0efa0)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 7 (was 0, writing d0d0)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 6 (was 0, writing e0d00)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 3 (was 810000, writing 810010)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100000, writing 100007)
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1c.3 to 64
Oct 16 14:26:52 corey kernel: pciehp_resume ENTRY

Oct 16 14:26:52 corey kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 19
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64
Oct 16 14:26:52 corey kernel: usb usb1: root hub lost power or was reset
Oct 16 14:26:52 corey kernel: PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
Oct 16 14:26:52 corey kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 20
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1d.1 at offset 8 (was 1, writing bf61)
Oct 16 14:26:52 corey kernel: usb usb2: root hub lost power or was reset
Oct 16 14:26:52 corey kernel: PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
Oct 16 14:26:52 corey kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 21
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 309)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1d.2 at offset 8 (was 1, writing bf41)
Oct 16 14:26:52 corey kernel: usb usb3: root hub lost power or was reset
Oct 16 14:26:52 corey kernel: PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
Oct 16 14:26:52 corey kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 22
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 407)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1d.3 at offset 8 (was 1, writing bf21)
Oct 16 14:26:52 corey kernel: usb usb4: root hub lost power or was reset
Oct 16 14:26:52 corey kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 19
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 100f1, writing 1fff1)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 8 (was 90, writing ef90ef90)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was 2280e0f0, writing 228000f0)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100007, writing 100107)
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1f.0 at offset 1 (was 2100007, writing 2100107)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1f.2 at offset f (was 200, writing 205)
Oct 16 14:26:52 corey kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
Oct 16 14:26:52 corey kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1f.3 at offset f (was 200, writing 205)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:00:1f.3 at offset 1 (was 2800001, writing 2800101)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:01:00.0 at offset f (was 1ff, writing 104)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:01:00.0 at offset 3 (was 0, writing 10)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:0c:00.0 at offset f (was 100, writing 105)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:0c:00.0 at offset 4 (was 0, writing efcff000)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:0c:00.0 at offset 3 (was 0, writing 10)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:0c:00.0 at offset 1 (was 100000, writing 100106)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:00.0 at offset f (was 100, writing 105)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:00.0 at offset 4 (was 0, writing ef9fe000)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:00.0 at offset 3 (was 0, writing 4000)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100000, writing 100106)
Oct 16 14:26:52 corey kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.0 at offset f (was 4020100, writing 4020103)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.0 at offset 4 (was 0, writing ef9fd800)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.0 at offset 3 (was 800000, writing 804000)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.0 at offset 1 (was 2100000, writing 2100106)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.1 at offset f (was 200, writing 209)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.1 at offset 4 (was 0, writing ef9fd400)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.1 at offset 3 (was 800000, writing 804000)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.1 at offset 1 (was 2100000, writing 2100106)
Oct 16 14:26:52 corey kernel: ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, low) -> IRQ 23
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.2 at offset f (was 200, writing 209)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.2 at offset 4 (was 0, writing ef9fd500)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.2 at offset 1 (was 2100000, writing 2100106)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.3 at offset f (was 200, writing 209)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.3 at offset 4 (was 0, writing ef9fd600)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.3 at offset 1 (was 2100000, writing 2100102)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.4 at offset f (was 200, writing 209)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.4 at offset 4 (was 0, writing ef9fd700)
Oct 16 14:26:52 corey kernel: PM: Writing back config space on device 0000:03:01.4 at offset 1 (was 2100000, writing 2100102)

Oct 16 14:26:52 corey kernel: pciehp_resume ENTRY
Oct 16 14:26:52 corey last message repeated 2 times
Oct 16 14:26:52 corey kernel: sd 0:0:0:0: [sda] Starting disk
Oct 16 14:26:52 corey kernel: ata2.00: configured for UDMA/33
Oct 16 14:26:52 corey kernel: ata1.00: configured for UDMA/133
Oct 16 14:26:52 corey kernel: sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
Oct 16 14:26:52 corey kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 16 14:26:52 corey kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 16 14:26:52 corey kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 16 14:26:52 corey kernel: b44: eth0: Link is up at 100 Mbps, full duplex.
Oct 16 14:26:52 corey kernel: b44: eth0: Flow control is off for TX and off for RX.
Oct 16 14:26:52 corey kernel: Restarting tasks ... <6>usb 5-1: USB disconnect, address 2
Oct 16 14:26:52 corey kernel: done.
Oct 16 14:26:52 corey kernel: usb 5-1: new high speed USB device using ehci_hcd and address 6
Oct 16 14:26:52 corey kernel: usb 5-1: configuration #1 chosen from 1 choice
Oct 16 14:26:52 corey kernel: hub 5-1:1.0: USB hub found
Oct 16 14:26:52 corey kernel: hub 5-1:1.0: 4 ports detected
Oct 16 14:26:52 corey kernel: Uhhuh. NMI received for unknown reason 80 on CPU 0.
Oct 16 14:26:52 corey kernel: You have some hardware problem, likely on the PCI bus.
Oct 16 14:26:52 corey kernel: Dazed and confused, but trying to continue
Oct 16 14:26:52 corey kernel: usb 5-7: USB disconnect, address 3
Oct 16 14:26:52 corey kernel: usb 5-7.2: USB disconnect, address 4
Oct 16 14:26:52 corey kernel: pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
Oct 16 14:26:52 corey kernel: pl2303 5-7.2:1.0: device disconnected
Oct 16 14:26:52 corey kernel: usb 5-7.3: USB disconnect, address 5
Oct 16 14:26:52 corey kernel: usb 5-7: new high speed USB device using ehci_hcd and address 7
Oct 16 14:26:53 corey kernel: usb 5-7: configuration #1 chosen from 1 choice
Oct 16 14:26:53 corey kernel: hub 5-7:1.0: USB hub found
Oct 16 14:26:53 corey kernel: hub 5-7:1.0: 4 ports detected
Oct 16 14:26:53 corey kernel: usb 5-1.4: new full speed USB device using ehci_hcd and address 8
Oct 16 14:26:53 corey kernel: usb 5-1.4: configuration #1 chosen from 1 choice
Oct 16 14:26:53 corey kernel: Bluetooth: HCI USB driver ver 2.9
Oct 16 14:26:53 corey kernel: usb 5-7.2: new full speed USB device using ehci_hcd and address 9
Oct 16 14:26:53 corey kernel: usb 5-7.2: configuration #1 chosen from 1 choice
Oct 16 14:26:53 corey kernel: pl2303 5-7.2:1.0: pl2303 converter detected
Oct 16 14:26:53 corey kernel: usb 5-7.2: pl2303 converter now attached to ttyUSB0
Oct 16 14:26:53 corey kernel: usb 5-7.3: new low speed USB device using ehci_hcd and address 10
Oct 16 14:26:54 corey kernel: usb 5-7.3: configuration #1 chosen from 1 choice
Oct 16 14:26:54 corey kernel: input: Logitech Optical USB Mouse as /class/input/input7
Oct 16 14:26:54 corey kernel: input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.7-7.3
Oct 16 14:26:54 corey kernel: usbcore: registered new interface driver hci_usb
Oct 16 14:26:54 corey hcid[3803]: HCI dev 0 registered
Oct 16 14:26:54 corey hcid[3803]: HCI dev 0 up
Oct 16 14:26:54 corey hcid[3803]: Device hci0 has been added
Oct 16 14:26:54 corey hcid[3803]: Starting security manager 0
Oct 16 14:26:54 corey hcid[3803]: Device hci0 has been activated
Oct 16 14:26:56 corey kernel: usb 5-1.4: USB disconnect, address 8
Oct 16 14:26:56 corey hcid[3803]: HCI dev 0 down
Oct 16 14:26:56 corey hcid[3803]: Stopping security manager 0
Oct 16 14:26:56 corey hcid[3803]: Device hci0 has been disabled
Oct 16 14:26:57 corey hcid[3803]: HCI dev 0 unregistered
Oct 16 14:26:57 corey hcid[3803]: Unregister path: /org/bluez/hci0
Oct 16 14:26:57 corey hcid[3803]: Device hci0 has been removed

Oct 16 14:27:45 corey logger: resumed, tried inserting ExpressCard, no effect.  Removing it and doing rmmod pciehp.

Oct 16 14:27:54 corey kernel: pciehp: unload_pciehpd()
Oct 16 14:27:54 corey kernel: Unload service driver hpdriver on pcie device 0000:00:1c.3:pcie02
Oct 16 14:27:54 corey kernel: pciehp: release_slot - physical_slot = 0013_0005
Oct 16 14:27:54 corey kernel: Unload service driver hpdriver on pcie device 0000:00:1c.1:pcie02
Oct 16 14:27:54 corey kernel: pciehp: release_slot - physical_slot = 0012_0003
Oct 16 14:27:54 corey kernel: Unload service driver hpdriver on pcie device 0000:00:1c.0:pcie02
Oct 16 14:27:54 corey kernel: pciehp: release_slot - physical_slot = 0011_0002
Oct 16 14:27:54 corey kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4 unloaded

Oct 16 14:28:06 corey logger: removed pciehp, now modprobing it again

Oct 16 14:28:09 corey kernel: pciehp: pcie_init: hotplug controller vendor id 0x8086 device id 0x27d0
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: pcie_cap_base 40
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: CAPREG offset 42 cap_reg 141
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTCAP offset 54 slot_cap 10a0e0
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTSTATUS offset 5a slot_status 0
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTCTRL offset 58 slot_ctrl 8
Oct 16 14:28:09 corey kernel: pciehp: HPC vendor_id 8086 device_id 27d0 ss_vid 0 ss_did 0
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTCTRL 58 value read 8
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: request_irq 16 for hpc0 (returns 0)
Oct 16 14:28:09 corey kernel: pciehp: pciehp ctrl b:d:f:irq=0x0:1c:0:10
Oct 16 14:28:09 corey kernel: pciehp: Bypassing BIOS check for pciehp use on 0000:00:1c.0
Oct 16 14:28:09 corey kernel: pciehp: pciehp_probe: ctrl bus=0x0, device=1c, function=0, irq=10
Oct 16 14:28:09 corey kernel: pciehp: get_power_status - physical_slot = 0011_0002
Oct 16 14:28:09 corey kernel: pciehp: hpc_get_power_status: SLOTCTRL 58 value read 28
Oct 16 14:28:09 corey kernel: pciehp: get_attention_status - physical_slot = 0011_0002
Oct 16 14:28:09 corey kernel: pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 28
Oct 16 14:28:09 corey kernel: pciehp: get_latch_status - physical_slot = 0011_0002
Oct 16 14:28:09 corey kernel: pciehp: get_adapter_status - physical_slot = 0011_0002
Oct 16 14:28:09 corey kernel: pciehp: Registering bus=b dev=0 hp_slot=0 sun=2 slot_device_offset=0
Oct 16 14:28:09 corey kernel: Load service driver hpdriver on pcie device 0000:00:1c.0:pcie02
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: hotplug controller vendor id 0x8086 device id 0x27d2
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: pcie_cap_base 40
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: CAPREG offset 42 cap_reg 141
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTCAP offset 54 slot_cap 18a0e0
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTSTATUS offset 5a slot_status 40
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTCTRL offset 58 slot_ctrl 8
Oct 16 14:28:09 corey kernel: pciehp: pci resource[8] start=0xefc00000(len=0x100000)
Oct 16 14:28:09 corey kernel: pciehp: HPC vendor_id 8086 device_id 27d2 ss_vid 0 ss_did 0
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTCTRL 58 value read 8
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: request_irq 17 for hpc1 (returns 0)
Oct 16 14:28:09 corey kernel: pciehp: pciehp ctrl b:d:f:irq=0x0:1c:1:11
Oct 16 14:28:09 corey kernel: pciehp: Bypassing BIOS check for pciehp use on 0000:00:1c.1
Oct 16 14:28:09 corey kernel: pciehp: pciehp_probe: ctrl bus=0x0, device=1c, function=1, irq=11
Oct 16 14:28:09 corey kernel: pciehp: get_power_status - physical_slot = 0012_0003
Oct 16 14:28:09 corey kernel: pciehp: hpc_get_power_status: SLOTCTRL 58 value read 28
Oct 16 14:28:09 corey kernel: pciehp: get_attention_status - physical_slot = 0012_0003
Oct 16 14:28:09 corey kernel: pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 28
Oct 16 14:28:09 corey kernel: pciehp: get_latch_status - physical_slot = 0012_0003
Oct 16 14:28:09 corey kernel: pciehp: get_adapter_status - physical_slot = 0012_0003
Oct 16 14:28:09 corey kernel: pciehp: Registering bus=c dev=0 hp_slot=0 sun=3 slot_device_offset=0
Oct 16 14:28:09 corey kernel: Load service driver hpdriver on pcie device 0000:00:1c.1:pcie02
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: hotplug controller vendor id 0x8086 device id 0x27d6
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: pcie_cap_base 40
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: CAPREG offset 42 cap_reg 141
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTCAP offset 54 slot_cap 28a0e0
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTSTATUS offset 5a slot_status 100
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTCTRL offset 58 slot_ctrl 8
Oct 16 14:28:09 corey kernel: pciehp: pci resource[7] start=0xd000(len=0x1000)
Oct 16 14:28:09 corey kernel: pciehp: pci resource[8] start=0xefa00000(len=0x200000)
Oct 16 14:28:09 corey kernel: pciehp: pci resource[9] start=0xe0000000(len=0x200000)
Oct 16 14:28:09 corey kernel: pciehp: HPC vendor_id 8086 device_id 27d6 ss_vid 0 ss_did 0
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: SLOTCTRL 58 value read 8
Oct 16 14:28:09 corey kernel: pciehp: pcie_init: request_irq 18 for hpc2 (returns 0)
Oct 16 14:28:09 corey kernel: pciehp: pciehp ctrl b:d:f:irq=0x0:1c:3:12
Oct 16 14:28:09 corey kernel: pciehp: Bypassing BIOS check for pciehp use on 0000:00:1c.3
Oct 16 14:28:09 corey kernel: pciehp: pciehp_probe: ctrl bus=0x0, device=1c, function=3, irq=12
Oct 16 14:28:09 corey kernel: pciehp: get_power_status - physical_slot = 0013_0005
Oct 16 14:28:09 corey kernel: pciehp: hpc_get_power_status: SLOTCTRL 58 value read 28
Oct 16 14:28:09 corey kernel: pciehp: get_attention_status - physical_slot = 0013_0005
Oct 16 14:28:09 corey kernel: pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 28
Oct 16 14:28:09 corey kernel: pciehp: get_latch_status - physical_slot = 0013_0005
Oct 16 14:28:09 corey kernel: pciehp: get_adapter_status - physical_slot = 0013_0005
Oct 16 14:28:09 corey kernel: pciehp: Registering bus=d dev=0 hp_slot=0 sun=5 slot_device_offset=0
Oct 16 14:28:09 corey kernel: Load service driver hpdriver on pcie device 0000:00:1c.3:pcie02
Oct 16 14:28:09 corey kernel: pciehp: pcie_port_service_register = 0
Oct 16 14:28:09 corey kernel: pciehp: PCI Express Hot Plug Controller Driver version: 0.4

Oct 16 14:28:18 corey logger: now inserting ExpressCard

Oct 16 14:28:21 corey kernel: pciehp: pcie_isr: intr_loc 8
Oct 16 14:28:21 corey kernel: pciehp: pcie_isr: pciehp_readw(SLOTCTRL) with value 28
Oct 16 14:28:21 corey kernel: pciehp: pcie_isr: pciehp_readw(SLOTSTATUS) with value 148
Oct 16 14:28:21 corey kernel: pciehp: pciehp:  Presence/Notify input change.
Oct 16 14:28:21 corey kernel: pciehp: Card present on Slot(0013_0005)
Oct 16 14:28:21 corey kernel: pciehp: pcie_isr: Unmask Hot-plug Interrupt Enable
Oct 16 14:28:21 corey kernel: pciehp: pcie_isr: pciehp_writew(SLOTSTATUS) with value 1f
Oct 16 14:28:21 corey kernel: pciehp: Surprise Removal
Oct 16 14:28:21 corey kernel: pciehp: hpc_get_power_status: SLOTCTRL 58 value read 28
Oct 16 14:28:21 corey kernel: pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 28
Oct 16 14:28:21 corey kernel: pciehp: board_added: slot device, slot offset, hp slot = 0, 0 ,0
Oct 16 14:28:22 corey kernel: pciehp: hpc_check_lnk_status: lnk_status = 3011
Oct 16 14:28:22 corey kernel: program_fw_provided_values: Could not get hotplug parameters
Oct 16 14:28:22 corey kernel: pciehp: hpc_get_power_status: SLOTCTRL 58 value read 28
Oct 16 14:28:22 corey kernel: pciehp: hpc_get_attention_status: SLOTCTRL 58, value read 28
Oct 16 14:28:22 corey kernel: sata_sil24 0000:0d:00.0: version 1.0
Oct 16 14:28:22 corey kernel: PCI: Enabling device 0000:0d:00.0 (0000 -> 0003)
Oct 16 14:28:22 corey kernel: ACPI: PCI Interrupt 0000:0d:00.0[A] -> GSI 19 (level, low) -> IRQ 18
Oct 16 14:28:22 corey kernel: PCI: Setting latency timer of device 0000:0d:00.0 to 64
Oct 16 14:28:22 corey kernel: scsi2 : sata_sil24
Oct 16 14:28:22 corey kernel: scsi3 : sata_sil24
Oct 16 14:28:22 corey kernel: ata3: SATA max UDMA/100 cmd 0xf8b98000 ctl 0x00000000 bmdma 0x00000000 irq 18
Oct 16 14:28:22 corey kernel: ata4: SATA max UDMA/100 cmd 0xf8b9a000 ctl 0x00000000 bmdma 0x00000000 irq 18
Oct 16 14:28:23 corey kernel: ata3: SATA link down (SStatus 0 SControl 300)
Oct 16 14:28:23 corey kernel: ata4: SATA link down (SStatus 0 SControl 300)

--------------050107040009090008050101
Content-Type: text/plain;
 name="lspci_vv.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci_vv.txt"

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
	Subsystem: Dell Unknown device 01cd
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express PCI Express Root Port (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR+ <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: efd00000-efefffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [88] Subsystem: Dell Unknown device 01cd
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [a0] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 2
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 1, PowerLimit 75.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [140] Unknown (5)

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
	Subsystem: Dell Unknown device 01cd
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at efffc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express Unknown type IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed unknown, Width x0
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Unknown (5)

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable- Non-Fatal- Fatal+ Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 2, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Unknown device 01cd
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
	Memory behind bridge: efc00000-efcfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 3, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Unknown device 01cd
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=0d, subordinate=0e, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: efa00000-efbfffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000e01fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 4
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 5, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Unknown device 01cd
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01cd
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 4: I/O ports at bf80 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01cd
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 20
	Region 4: I/O ports at bf60 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01cd
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 21
	Region 4: I/O ports at bf40 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01cd
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 22
	Region 4: I/O ports at bf20 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: Dell Unknown device 01cd
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at ffa80000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
	Memory behind bridge: ef900000-ef9fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Subsystem: Dell Unknown device 01cd

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 01)
	Subsystem: Dell Unknown device 01cd
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controller IDE (rev 01) (prog-if 80 [Master])
	Subsystem: Dell Unknown device 01cd
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at bfa0 [size=16]
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
	Subsystem: Dell Unknown device 01cd
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 5
	Region 4: I/O ports at 10c0 [size=32]

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility X1400 (prog-if 00 [VGA])
	Subsystem: Dell Unknown device 2002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 4
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at ee00 [size=256]
	Region 2: Memory at efdf0000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at efe00000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express Legacy Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <4us, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x16

03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
	Subsystem: Dell Unknown device 01cd
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at ef9fe000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832 (prog-if 10 [OHCI])
	Subsystem: Dell Unknown device 01cd
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 1000ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at ef9fd800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME+

03:01.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19) (prog-if 01)
	Subsystem: Dell Unknown device 01cd
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin B routed to IRQ 23
	Region 0: Memory at ef9fd400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:01.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
	Subsystem: Dell Unknown device 01cd
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 9
	Region 0: Memory at ef9fd500 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 0a)
	Subsystem: Dell Unknown device 01cd
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 9
	Region 0: Memory at ef9fd600 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
	Subsystem: Dell Unknown device 01cd
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 9
	Region 0: Memory at ef9fd700 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
	Subsystem: Intel Corporation Unknown device 1000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at efcff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express Legacy Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
		Link: Latency L0s <128ns, L1 <64us
		Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 6f-5e-72-ff-ff-d2-19-00


--------------050107040009090008050101--
