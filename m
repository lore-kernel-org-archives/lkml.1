Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYFAEPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYFAEPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 00:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYFAEP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 00:15:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:63533 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYFAEPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 00:15:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :message-id;
        b=eQkRpgalrUUbwYxIrvsOyhwGpISossl8BXSAeBgpG+ArgI2MVQ3jWct//qao6ucK9J
         gmGk0PuP23o8Nlw/iMYTQOydeOIT6ze9LKNYY6QLgcVqYxyRvhNhu7aBvjfQ4E9HdBJK
         0SbbqRiHUorrJibELFhAFNAebEyCva9IEAOz0=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2,6.26-rc4-git2 - long pause during boot
Date: Sun, 1 Jun 2008 04:15:05 +0000
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JJiQInXJAOA3AaU"
Message-Id: <200806010415.05290.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_JJiQInXJAOA3AaU
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I've just started testing 2.6.26 on my desktop machine and have found that I get 
a long pause (20 seconds or so) as the system boots. By pause I mean that the 
boot messages that normally scroll by stop doing so for, as I say, about 20 
seconds.

I've done a bisect and arrived at:

b0ed43360fdca227048d88a08290365cb681c1a8 is first bad commit
commit b0ed43360fdca227048d88a08290365cb681c1a8
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Mar 18 14:32:28 2008 +0100

    [SCSI] add scsi_host and scsi_target to scsi_bus

    This patch implements scsi_host and scsi_target device types
    and adds both to the scsi_bus.

    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

:040000 040000 4e3140909966b4c9aa987d34ee4078d283fe0351 
46e4fd28cc537ba700eb4f5652abf043fed4d76d M      drivers

The config file for that kernel is attached as are the kernel log for booting 
that kernel and the bisect log.

I've also noticed that it takes much longer for icons to appear on my desktop 
when I plug a usb storage device in. (The icons are shown/hidden by a simple 
sctript that is run via udev when the device is attached/detached.)

Let me know of any way I can help solve this.

Please cc me to any reply as I'm not subscribed.

Chris
-- 
Beauty is in the eye of the beerholder.

--Boundary-00=_JJiQInXJAOA3AaU
Content-Type: text/x-log;
  charset="us-ascii";
  name="bigpause.kernel.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bigpause.kernel.log"

May 30 05:11:12 upstairs kernel: klogd 1.3-3, log source = /proc/kmsg started.
May 30 05:11:12 upstairs kernel: Inspecting /boot/System.map-2.6.25
May 30 05:11:13 upstairs kernel: Loaded 26125 symbols from /boot/System.map-2.6.25.
May 30 05:11:13 upstairs kernel: Symbols match kernel version 2.6.25.
May 30 05:11:13 upstairs kernel: No module symbols loaded - kernel modules not enabled. 
May 30 05:11:13 upstairs kernel: Linux version 2.6.25 (chris@upstairs) (gcc version 4.2.4) #47 SMP PREEMPT Fri May 30 05:09:55 UTC 2008 
May 30 05:11:13 upstairs kernel: BIOS-provided physical RAM map: 
May 30 05:11:13 upstairs kernel:  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable) 
May 30 05:11:13 upstairs kernel:  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved) 
May 30 05:11:13 upstairs kernel:  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved) 
May 30 05:11:13 upstairs kernel:  BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable) 
May 30 05:11:13 upstairs kernel:  BIOS-e820: 000000007ffb0000 - 000000007ffc0000 (ACPI data) 
May 30 05:11:13 upstairs kernel:  BIOS-e820: 000000007ffc0000 - 000000007fff0000 (ACPI NVS) 
May 30 05:11:13 upstairs kernel:  BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved) 
May 30 05:11:13 upstairs kernel:  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved) 
May 30 05:11:13 upstairs kernel: x86: PAT support disabled. 
May 30 05:11:13 upstairs kernel: 1151MB HIGHMEM available. 
May 30 05:11:13 upstairs kernel: 896MB LOWMEM available. 
May 30 05:11:13 upstairs kernel: found SMP MP-table at [c00ff780] 000ff780 
May 30 05:11:13 upstairs kernel: Entering add_active_range(0, 0, 524208) 0 entries of 256 used 
May 30 05:11:13 upstairs kernel: Zone PFN ranges: 
May 30 05:11:13 upstairs kernel:   DMA             0 ->     4096 
May 30 05:11:13 upstairs kernel:   Normal       4096 ->   229376 
May 30 05:11:13 upstairs kernel:   HighMem    229376 ->   524208 
May 30 05:11:13 upstairs kernel: Movable zone start PFN for each node 
May 30 05:11:13 upstairs kernel: early_node_map[1] active PFN ranges 
May 30 05:11:13 upstairs kernel:     0:        0 ->   524208 
May 30 05:11:13 upstairs kernel: On node 0 totalpages: 524208 
May 30 05:11:13 upstairs kernel:   DMA zone: 32 pages used for memmap 
May 30 05:11:13 upstairs kernel:   DMA zone: 0 pages reserved 
May 30 05:11:13 upstairs kernel:   DMA zone: 4064 pages, LIFO batch:0 
May 30 05:11:13 upstairs kernel:   Normal zone: 1760 pages used for memmap 
May 30 05:11:13 upstairs kernel:   Normal zone: 223520 pages, LIFO batch:31 
May 30 05:11:13 upstairs kernel:   HighMem zone: 2303 pages used for memmap 
May 30 05:11:13 upstairs kernel:   HighMem zone: 292529 pages, LIFO batch:31 
May 30 05:11:13 upstairs kernel:   Movable zone: 0 pages used for memmap 
May 30 05:11:13 upstairs kernel: DMI 2.3 present. 
May 30 05:11:13 upstairs kernel: ACPI: RSDP 000FAF50, 0021 (r2 ACPIAM) 
May 30 05:11:13 upstairs kernel: ACPI: XSDT 7FFB0100, 003C (r1 A M I  OEMXSDT   6000626 MSFT       97) 
May 30 05:11:13 upstairs kernel: ACPI: FACP 7FFB0290, 00F4 (r3 A M I  OEMFACP   6000626 MSFT       97) 
May 30 05:11:13 upstairs kernel: ACPI: DSDT 7FFB0400, 3552 (r1  A0495 A0495036       36 INTL  2002026) 
May 30 05:11:13 upstairs kernel: ACPI: FACS 7FFC0000, 0040 
May 30 05:11:13 upstairs kernel: ACPI: APIC 7FFB0390, 006C (r1 A M I  OEMAPIC   6000626 MSFT       97) 
May 30 05:11:13 upstairs kernel: ACPI: OEMB 7FFC0040, 003F (r1 A M I  OEMBIOS   6000626 MSFT       97) 
May 30 05:11:13 upstairs kernel: ACPI: PM-Timer IO Port: 0x808 
May 30 05:11:13 upstairs kernel: ACPI: Local APIC address 0xfee00000 
May 30 05:11:13 upstairs kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled) 
May 30 05:11:13 upstairs kernel: BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor) 
May 30 05:11:13 upstairs kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled) 
May 30 05:11:13 upstairs kernel: BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor) 
May 30 05:11:13 upstairs kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled) 
May 30 05:11:13 upstairs kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled) 
May 30 05:11:13 upstairs kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0]) 
May 30 05:11:13 upstairs kernel: IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23 
May 30 05:11:13 upstairs kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl) 
May 30 05:11:13 upstairs kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level) 
May 30 05:11:13 upstairs kernel: ACPI: IRQ0 used by override. 
May 30 05:11:13 upstairs kernel: ACPI: IRQ2 used by override. 
May 30 05:11:13 upstairs kernel: ACPI: IRQ9 used by override. 
May 30 05:11:13 upstairs kernel: Enabling APIC mode:  Flat.  Using 1 I/O APICs 
May 30 05:11:13 upstairs kernel: Using ACPI (MADT) for SMP configuration information 
May 30 05:11:13 upstairs kernel: Allocating PCI resources starting at 88000000 (gap: 80000000:7fb80000) 
May 30 05:11:13 upstairs kernel: SMP: Allowing 2 CPUs, 0 hotplug CPUs 
May 30 05:11:13 upstairs kernel: PERCPU: Allocating 36288 bytes of per cpu data 
May 30 05:11:13 upstairs kernel: NR_CPUS: 2, nr_cpu_ids: 2 
May 30 05:11:13 upstairs kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520113 
May 30 05:11:13 upstairs kernel: Kernel command line: root=/dev/sdc1 ro usbcore.old_scheme_first=1 
May 30 05:11:13 upstairs kernel: mapped APIC to ffffb000 (fee00000) 
May 30 05:11:13 upstairs kernel: mapped IOAPIC to ffffa000 (fec00000) 
May 30 05:11:13 upstairs kernel: Enabling fast FPU save and restore... done. 
May 30 05:11:13 upstairs kernel: Enabling unmasked SIMD FPU exception support... done. 
May 30 05:11:13 upstairs kernel: Initializing CPU#0 
May 30 05:11:13 upstairs kernel: CPU 0 irqstacks, hard=c0436000 soft=c0434000 
May 30 05:11:13 upstairs kernel: PID hash table entries: 4096 (order: 12, 16384 bytes) 
May 30 05:11:13 upstairs kernel: Detected 3194.342 MHz processor. 
May 30 05:11:13 upstairs kernel: Console: colour VGA+ 80x25 
May 30 05:11:13 upstairs kernel: console [tty0] enabled 
May 30 05:11:13 upstairs kernel: Dentry cache hash table entries: 131072 (order: 7, 524288 bytes) 
May 30 05:11:13 upstairs kernel: Inode-cache hash table entries: 65536 (order: 6, 262144 bytes) 
May 30 05:11:13 upstairs kernel: Memory: 2074796k/2096832k available (2208k kernel code, 20816k reserved, 846k data, 196k init, 1179328k highmem) 
May 30 05:11:13 upstairs kernel: virtual kernel memory layout: 
May 30 05:11:13 upstairs kernel:     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB) 
May 30 05:11:13 upstairs kernel:     pkmap   : 0xff800000 - 0xffc00000   (4096 kB) 
May 30 05:11:13 upstairs kernel:     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB) 
May 30 05:11:13 upstairs kernel:     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB) 
May 30 05:11:13 upstairs kernel:       .init : 0xc0400000 - 0xc0431000   ( 196 kB) 
May 30 05:11:13 upstairs kernel:       .data : 0xc0328322 - 0xc03fbda0   ( 846 kB) 
May 30 05:11:13 upstairs kernel:       .text : 0xc0100000 - 0xc0328322   (2208 kB) 
May 30 05:11:13 upstairs kernel: Checking if this processor honours the WP bit even in supervisor mode...Ok. 
May 30 05:11:13 upstairs kernel: CPA: page pool initialized 1 of 1 pages preallocated 
May 30 05:11:13 upstairs kernel: Calibrating delay using timer specific routine.. 6390.93 BogoMIPS (lpj=3195469) 
May 30 05:11:13 upstairs kernel: Mount-cache hash table entries: 512 
May 30 05:11:13 upstairs kernel: CPU: Trace cache: 12K uops, L1 D cache: 16K 
May 30 05:11:13 upstairs kernel: CPU: L2 cache: 2048K 
May 30 05:11:13 upstairs kernel: CPU: Physical Processor ID: 0 
May 30 05:11:13 upstairs kernel: Intel machine check architecture supported. 
May 30 05:11:13 upstairs kernel: Intel machine check reporting enabled on CPU#0. 
May 30 05:11:13 upstairs kernel: CPU0: Intel P4/Xeon Extended MCE MSRs (24) available 
May 30 05:11:13 upstairs kernel: Compat vDSO mapped to ffffe000. 
May 30 05:11:13 upstairs kernel: Checking 'hlt' instruction... OK. 
May 30 05:11:13 upstairs kernel: ACPI: Core revision 20070126 
May 30 05:11:13 upstairs kernel: ENABLING IO-APIC IRQs 
May 30 05:11:13 upstairs kernel: ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1 
May 30 05:11:13 upstairs kernel: CPU0: Intel(R) Pentium(R) D CPU 3.20GHz stepping 02 
May 30 05:11:13 upstairs kernel: CPU 1 irqstacks, hard=c0437000 soft=c0435000 
May 30 05:11:13 upstairs kernel: Booting processor 1/1 ip 6000 
May 30 05:11:13 upstairs kernel: Initializing CPU#1 
May 30 05:11:13 upstairs kernel: Calibrating delay using timer specific routine.. 6386.83 BogoMIPS (lpj=3193417) 
May 30 05:11:13 upstairs kernel: CPU: Trace cache: 12K uops, L1 D cache: 16K 
May 30 05:11:13 upstairs kernel: CPU: L2 cache: 2048K 
May 30 05:11:13 upstairs kernel: CPU: Physical Processor ID: 0 
May 30 05:11:13 upstairs kernel: Intel machine check architecture supported. 
May 30 05:11:13 upstairs kernel: Intel machine check reporting enabled on CPU#1. 
May 30 05:11:13 upstairs kernel: CPU1: Intel P4/Xeon Extended MCE MSRs (24) available 
May 30 05:11:13 upstairs kernel: x86: PAT support disabled. 
May 30 05:11:13 upstairs kernel: CPU1: Intel(R) Pentium(R) D CPU 3.20GHz stepping 02 
May 30 05:11:13 upstairs kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed. 
May 30 05:11:13 upstairs kernel: Brought up 2 CPUs 
May 30 05:11:13 upstairs kernel: Total of 2 processors activated (12777.77 BogoMIPS). 
May 30 05:11:13 upstairs kernel: net_namespace: 488 bytes 
May 30 05:11:13 upstairs kernel: NET: Registered protocol family 16 
May 30 05:11:13 upstairs kernel: No dock devices found. 
May 30 05:11:13 upstairs kernel: ACPI: bus type pci registered 
May 30 05:11:13 upstairs kernel: PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2 
May 30 05:11:13 upstairs kernel: PCI: Using configuration type 1 
May 30 05:11:13 upstairs kernel: Setting up standard PCI resources 
May 30 05:11:13 upstairs kernel: ACPI: EC: Look up EC in DSDT 
May 30 05:11:13 upstairs kernel: ACPI: Interpreter enabled 
May 30 05:11:13 upstairs kernel: ACPI: (supports S0 S1 S3 S5) 
May 30 05:11:13 upstairs kernel: ACPI: Using IOAPIC for interrupt routing 
May 30 05:11:13 upstairs kernel: ACPI: PCI Root Bridge [PCI0] (0000:00) 
May 30 05:11:13 upstairs kernel: pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO 
May 30 05:11:13 upstairs kernel: pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH4 GPIO 
May 30 05:11:13 upstairs kernel: PCI: Transparent bridge - 0000:00:1e.0 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT] 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT] 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15) 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15) 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15) 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15) 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled. 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15) 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15) 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15) 
May 30 05:11:13 upstairs kernel: ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  C9, should be BC [20070126] 
May 30 05:11:13 upstairs kernel: Linux Plug and Play Support v0.97 (c) Adam Belay 
May 30 05:11:13 upstairs kernel: pnp: PnP ACPI init 
May 30 05:11:13 upstairs kernel: ACPI: bus type pnp registered 
May 30 05:11:13 upstairs kernel: pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active) 
May 30 05:11:13 upstairs kernel: pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active) 
May 30 05:11:13 upstairs kernel: pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active) 
May 30 05:11:13 upstairs kernel: pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active) 
May 30 05:11:13 upstairs kernel: pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active) 
May 30 05:11:13 upstairs kernel: pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (active) 
May 30 05:11:13 upstairs kernel: pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active) 
May 30 05:11:13 upstairs kernel:  00:07: calling quirk 0xc020f75f: quirk_system_pci_resources+0x0/0x1e5() 
May 30 05:11:13 upstairs kernel: pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active) 
May 30 05:11:13 upstairs kernel:  00:08: calling quirk 0xc020f75f: quirk_system_pci_resources+0x0/0x1e5() 
May 30 05:11:13 upstairs kernel: pnp 00:08: Plug and Play ACPI device, IDs PNP0c02 (active) 
May 30 05:11:13 upstairs kernel:  00:09: calling quirk 0xc020f75f: quirk_system_pci_resources+0x0/0x1e5() 
May 30 05:11:13 upstairs kernel: pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active) 
May 30 05:11:13 upstairs kernel: pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active) 
May 30 05:11:13 upstairs kernel: pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active) 
May 30 05:11:13 upstairs kernel:  00:0c: calling quirk 0xc020f75f: quirk_system_pci_resources+0x0/0x1e5() 
May 30 05:11:13 upstairs kernel: pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active) 
May 30 05:11:13 upstairs kernel: pnp: PnP ACPI: found 13 devices 
May 30 05:11:13 upstairs kernel: ACPI: ACPI bus type pnp unregistered 
May 30 05:11:13 upstairs kernel: SCSI subsystem initialized 
May 30 05:11:13 upstairs kernel: libata version 3.00 loaded. 
May 30 05:11:13 upstairs kernel: usbcore: registered new interface driver usbfs 
May 30 05:11:13 upstairs kernel: usbcore: registered new interface driver hub 
May 30 05:11:13 upstairs kernel: usbcore: registered new device driver usb 
May 30 05:11:13 upstairs kernel: PCI: Using ACPI for IRQ routing 
May 30 05:11:13 upstairs kernel: pnp: the driver 'system' has been registered 
May 30 05:11:13 upstairs kernel: system 00:07: ioport range 0x290-0x297 has been reserved 
May 30 05:11:13 upstairs kernel: system 00:07: driver attached 
May 30 05:11:13 upstairs kernel: system 00:08: ioport range 0x4d0-0x4d1 has been reserved 
May 30 05:11:13 upstairs kernel: system 00:08: ioport range 0x800-0x87f has been reserved 
May 30 05:11:13 upstairs kernel: system 00:08: ioport range 0x400-0x41f has been reserved 
May 30 05:11:13 upstairs kernel: system 00:08: ioport range 0x480-0x4bf has been reserved 
May 30 05:11:13 upstairs kernel: system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved 
May 30 05:11:13 upstairs kernel: system 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved 
May 30 05:11:13 upstairs kernel: system 00:08: driver attached 
May 30 05:11:13 upstairs kernel: system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved 
May 30 05:11:13 upstairs kernel: system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved 
May 30 05:11:13 upstairs kernel: system 00:09: driver attached 
May 30 05:11:13 upstairs kernel: system 00:0c: iomem range 0x0-0x9ffff could not be reserved 
May 30 05:11:13 upstairs kernel: system 00:0c: iomem range 0xc0000-0xdffff could not be reserved 
May 30 05:11:13 upstairs kernel: system 00:0c: iomem range 0xe0000-0xfffff could not be reserved 
May 30 05:11:13 upstairs kernel: system 00:0c: iomem range 0x100000-0x7ffeffff could not be reserved 
May 30 05:11:13 upstairs kernel: system 00:0c: iomem range 0xfff00000-0xffffffff could not be reserved 
May 30 05:11:13 upstairs kernel: system 00:0c: driver attached 
May 30 05:11:13 upstairs kernel: PCI: Bridge: 0000:00:01.0 
May 30 05:11:13 upstairs kernel:   IO window: c000-cfff 
May 30 05:11:13 upstairs kernel:   MEM window: 0xfa000000-0xfbefffff 
May 30 05:11:13 upstairs kernel:   PREFETCH window: 0x00000000e0000000-0x00000000f8ffffff 
May 30 05:11:13 upstairs kernel: PCI: Bridge: 0000:00:1e.0 
May 30 05:11:13 upstairs kernel:   IO window: d000-efff 
May 30 05:11:13 upstairs kernel:   MEM window: 0xfbf00000-0xfbffffff 
May 30 05:11:13 upstairs kernel:   PREFETCH window: disabled. 
May 30 05:11:13 upstairs kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64 
May 30 05:11:13 upstairs kernel: NET: Registered protocol family 2 
May 30 05:11:13 upstairs kernel: IP route cache hash table entries: 32768 (order: 5, 131072 bytes) 
May 30 05:11:13 upstairs kernel: TCP established hash table entries: 131072 (order: 8, 1048576 bytes) 
May 30 05:11:13 upstairs kernel: TCP bind hash table entries: 65536 (order: 7, 524288 bytes) 
May 30 05:11:13 upstairs kernel: TCP: Hash tables configured (established 131072 bind 65536) 
May 30 05:11:13 upstairs kernel: TCP reno registered 
May 30 05:11:13 upstairs kernel: highmem bounce pool size: 64 pages 
May 30 05:11:13 upstairs kernel: io scheduler noop registered 
May 30 05:11:13 upstairs kernel: io scheduler cfq registered (default) 
May 30 05:11:13 upstairs kernel: pci 0000:01:00.0: Boot video device 
May 30 05:11:13 upstairs kernel: input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0 
May 30 05:11:13 upstairs kernel: ACPI: Power Button (FF) [PWRF] 
May 30 05:11:13 upstairs kernel: input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1 
May 30 05:11:13 upstairs kernel: ACPI: Power Button (CM) [PWRB] 
May 30 05:11:13 upstairs kernel: ACPI: ACPI0007:00 is registered as cooling_device0 
May 30 05:11:13 upstairs kernel: ACPI: Processor [CPU1] (supports 8 throttling states) 
May 30 05:11:13 upstairs kernel: ACPI: ACPI0007:01 is registered as cooling_device1 
May 30 05:11:13 upstairs kernel: Real Time Clock Driver v1.12ac 
May 30 05:11:13 upstairs kernel: Linux agpgart interface v0.103 
May 30 05:11:13 upstairs kernel: agpgart: Detected an Intel 865 Chipset. 
May 30 05:11:13 upstairs kernel: agpgart: AGP aperture is 16M @ 0xdf000000 
May 30 05:11:13 upstairs kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled 
May 30 05:11:13 upstairs kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A 
May 30 05:11:13 upstairs kernel: pnp: the driver 'serial' has been registered 
May 30 05:11:13 upstairs kernel: 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A 
May 30 05:11:13 upstairs kernel: serial 00:0b: driver attached 
May 30 05:11:13 upstairs kernel: 8139too Fast Ethernet driver 0.9.28 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt 0000:02:0d.0[A] -> GSI 23 (level, low) -> IRQ 23 
May 30 05:11:13 upstairs kernel: eth0: RealTek RTL8139 at 0xf8816c00, 00:17:31:a9:1d:48, IRQ 23 
May 30 05:11:13 upstairs kernel: eth0:  Identified 8139 chip type 'RTL-8100B/8139D' 
May 30 05:11:13 upstairs kernel: Driver 'sd' needs updating - please use bus_type methods 
May 30 05:11:13 upstairs kernel: Driver 'sr' needs updating - please use bus_type methods 
May 30 05:11:13 upstairs kernel: ata_piix 0000:00:1f.1: version 2.12 
May 30 05:11:13 upstairs kernel: ata_piix 0000:00:1f.1: enabling device (0005 -> 0007) 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18 
May 30 05:11:13 upstairs kernel: PCI: Setting latency timer of device 0000:00:1f.1 to 64 
May 30 05:11:13 upstairs kernel: scsi0 : ata_piix 
May 30 05:11:13 upstairs kernel: scsi1 : ata_piix 
May 30 05:11:13 upstairs kernel: ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14 
May 30 05:11:13 upstairs kernel: ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15 
May 30 05:11:13 upstairs kernel: ata1.00: ATA-7: MAXTOR STM3250820A, 3.AAE, max UDMA/100 
May 30 05:11:13 upstairs kernel: ata1.00: 488397168 sectors, multi 16: LBA48  
May 30 05:11:13 upstairs kernel: ata1.01: ATA-7: Maxtor 6L160P0, BAJ41G20, max UDMA/133 
May 30 05:11:13 upstairs kernel: ata1.01: 320173056 sectors, multi 16: LBA48  
May 30 05:11:13 upstairs kernel: ata1.00: configured for UDMA/100 
May 30 05:11:13 upstairs kernel: ata1.01: configured for UDMA/100 
May 30 05:11:13 upstairs kernel: ata2.00: ATAPI: SONY    DVD RW DW-G120A, MYS2, max UDMA/66 
May 30 05:11:13 upstairs kernel: ata2.01: ATAPI: PHILIPS DVDR1628P1, Q2.2, max UDMA/33 
May 30 05:11:13 upstairs kernel: Switched to NOHz mode on CPU #1 
May 30 05:11:13 upstairs kernel: Switched to NOHz mode on CPU #0 
May 30 05:11:13 upstairs kernel: ata2.00: configured for UDMA/66 
May 30 05:11:13 upstairs kernel: ata2.01: configured for UDMA/33 
May 30 05:11:13 upstairs kernel: scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM325082 3.AA PQ: 0 ANSI: 5 
May 30 05:11:13 upstairs kernel: sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB) 
May 30 05:11:13 upstairs kernel: sd 0:0:0:0: [sda] Write Protect is off 
May 30 05:11:13 upstairs kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00 
May 30 05:11:13 upstairs kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 30 05:11:13 upstairs kernel: sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB) 
May 30 05:11:13 upstairs kernel: sd 0:0:0:0: [sda] Write Protect is off 
May 30 05:11:13 upstairs kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00 
May 30 05:11:13 upstairs kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 30 05:11:13 upstairs kernel:  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 > 
May 30 05:11:13 upstairs kernel: sd 0:0:0:0: [sda] Attached SCSI disk 
May 30 05:11:13 upstairs kernel: scsi 0:0:1:0: Direct-Access     ATA      Maxtor 6L160P0   BAJ4 PQ: 0 ANSI: 5 
May 30 05:11:13 upstairs kernel: sd 0:0:1:0: [sdb] 320173056 512-byte hardware sectors (163929 MB) 
May 30 05:11:13 upstairs kernel: sd 0:0:1:0: [sdb] Write Protect is off 
May 30 05:11:13 upstairs kernel: sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00 
May 30 05:11:13 upstairs kernel: sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 30 05:11:13 upstairs kernel: sd 0:0:1:0: [sdb] 320173056 512-byte hardware sectors (163929 MB) 
May 30 05:11:13 upstairs kernel: sd 0:0:1:0: [sdb] Write Protect is off 
May 30 05:11:13 upstairs kernel: sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00 
May 30 05:11:13 upstairs kernel: sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 30 05:11:13 upstairs kernel:  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 > 
May 30 05:11:13 upstairs kernel:  sdb2: <bsd: sdb9 sdb10 sdb11 sdb12 sdb13 > 
May 30 05:11:13 upstairs kernel: sd 0:0:1:0: [sdb] Attached SCSI disk 
May 30 05:11:13 upstairs kernel: scsi 1:0:0:0: CD-ROM            SONY     DVD RW DW-G120A  MYS2 PQ: 0 ANSI: 5 
May 30 05:11:13 upstairs kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray 
May 30 05:11:13 upstairs kernel: Uniform CD-ROM driver Revision: 3.20 
May 30 05:11:13 upstairs kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0 
May 30 05:11:13 upstairs kernel: scsi 1:0:1:0: CD-ROM            PHILIPS  DVDR1628P1       Q2.2 PQ: 0 ANSI: 5 
May 30 05:11:13 upstairs kernel: sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray 
May 30 05:11:13 upstairs kernel: sr 1:0:1:0: Attached scsi CD-ROM sr1 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 18 
May 30 05:11:13 upstairs kernel: ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ] 
May 30 05:11:13 upstairs kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64 
May 30 05:11:13 upstairs kernel: scsi2 : ata_piix 
May 30 05:11:13 upstairs kernel: scsi3 : ata_piix 
May 30 05:11:13 upstairs kernel: ata3: SATA max UDMA/133 cmd 0x9800 ctl 0x9400 bmdma 0x8400 irq 18 
May 30 05:11:13 upstairs kernel: ata4: SATA max UDMA/133 cmd 0x9000 ctl 0x8800 bmdma 0x8408 irq 18 
May 30 05:11:13 upstairs kernel: ata3.00: ATA-7: Hitachi HDS721616PLA380, P22OA70A, max UDMA/133 
May 30 05:11:13 upstairs kernel: ata3.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32) 
May 30 05:11:13 upstairs kernel: ata3.00: configured for UDMA/133 
May 30 05:11:13 upstairs kernel: scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDS72161 P22O PQ: 0 ANSI: 5 
May 30 05:11:13 upstairs kernel: sd 2:0:0:0: [sdc] 321672960 512-byte hardware sectors (164697 MB) 
May 30 05:11:13 upstairs kernel: sd 2:0:0:0: [sdc] Write Protect is off 
May 30 05:11:13 upstairs kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00 
May 30 05:11:13 upstairs kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 30 05:11:13 upstairs kernel: sd 2:0:0:0: [sdc] 321672960 512-byte hardware sectors (164697 MB) 
May 30 05:11:13 upstairs kernel: sd 2:0:0:0: [sdc] Write Protect is off 
May 30 05:11:13 upstairs kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00 
May 30 05:11:13 upstairs kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA 
May 30 05:11:13 upstairs kernel:  sdc: sdc1 sdc2 
May 30 05:11:13 upstairs kernel: sd 2:0:0:0: [sdc] Attached SCSI disk 
May 30 05:11:13 upstairs kernel: pnp: the driver 'i8042 kbd' has been registered 
May 30 05:11:13 upstairs kernel: i8042 kbd 00:0a: driver attached 
May 30 05:11:13 upstairs kernel: pnp: the driver 'i8042 aux' has been registered 
May 30 05:11:13 upstairs kernel: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1 
May 30 05:11:13 upstairs kernel: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp 
May 30 05:11:13 upstairs kernel: serio: i8042 KBD port at 0x60,0x64 irq 1 
May 30 05:11:13 upstairs kernel: mice: PS/2 mouse device common for all mice 
May 30 05:11:13 upstairs kernel: Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16:40:16 2008 UTC). 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 17 
May 30 05:11:13 upstairs kernel: PCI: Setting latency timer of device 0000:00:1f.5 to 64 
May 30 05:11:13 upstairs kernel: intel8x0_measure_ac97_clock: measured 50834 usecs 
May 30 05:11:13 upstairs kernel: intel8x0: clocking to 48000 
May 30 05:11:13 upstairs kernel: ALSA device list: 
May 30 05:11:13 upstairs kernel:   #0: Intel ICH5 with ALC655 at irq 17 
May 30 05:11:13 upstairs kernel: TCP cubic registered 
May 30 05:11:13 upstairs kernel: NET: Registered protocol family 1 
May 30 05:11:13 upstairs kernel: NET: Registered protocol family 15 
May 30 05:11:13 upstairs kernel: p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available 
May 30 05:11:13 upstairs kernel: Starting balanced_irq 
May 30 05:11:13 upstairs kernel: Using IPI No-Shortcut mode 
May 30 05:11:13 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
May 30 05:11:13 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
May 30 05:11:13 upstairs kernel: VFS: Mounted root (ext3 filesystem) readonly. 
May 30 05:11:13 upstairs kernel: Freeing unused kernel memory: 196k freed 
May 30 05:11:13 upstairs kernel: EXT3 FS on sdc1, internal journal 
May 30 05:11:13 upstairs kernel: USB Universal Host Controller Interface driver v3.0 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16 
May 30 05:11:13 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000a800 
May 30 05:11:13 upstairs kernel: usb usb1: configuration #1 chosen from 1 choice 
May 30 05:11:13 upstairs kernel: hub 1-0:1.0: USB hub found 
May 30 05:11:13 upstairs kernel: hub 1-0:1.0: 2 ports detected 
May 30 05:11:13 upstairs kernel: ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver 
May 30 05:11:13 upstairs kernel: pnp: the driver 'parport_pc' has been registered 
May 30 05:11:13 upstairs kernel: parport_pc 00:06: reported by Plug and Play ACPI 
May 30 05:11:13 upstairs kernel: parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)] 
May 30 05:11:13 upstairs kernel: parport_pc 00:06: driver attached 
May 30 05:11:13 upstairs kernel: usb usb1: New USB device found, idVendor=1d6b, idProduct=0001 
May 30 05:11:13 upstairs kernel: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:13 upstairs kernel: usb usb1: Product: UHCI Host Controller 
May 30 05:11:13 upstairs kernel: usb usb1: Manufacturer: Linux 2.6.25 uhci_hcd 
May 30 05:11:13 upstairs kernel: usb usb1: SerialNumber: 0000:00:1d.0 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19 
May 30 05:11:13 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b000 
May 30 05:11:13 upstairs kernel: usb usb2: configuration #1 chosen from 1 choice 
May 30 05:11:13 upstairs kernel: hub 2-0:1.0: USB hub found 
May 30 05:11:13 upstairs kernel: hub 2-0:1.0: 2 ports detected 
May 30 05:11:13 upstairs kernel: usb usb2: New USB device found, idVendor=1d6b, idProduct=0001 
May 30 05:11:13 upstairs kernel: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:13 upstairs kernel: usb usb2: Product: UHCI Host Controller 
May 30 05:11:13 upstairs kernel: usb usb2: Manufacturer: Linux 2.6.25 uhci_hcd 
May 30 05:11:13 upstairs kernel: usb usb2: SerialNumber: 0000:00:1d.1 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18 
May 30 05:11:13 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b400 
May 30 05:11:13 upstairs kernel: usb usb3: configuration #1 chosen from 1 choice 
May 30 05:11:13 upstairs kernel: hub 3-0:1.0: USB hub found 
May 30 05:11:13 upstairs kernel: hub 3-0:1.0: 2 ports detected 
May 30 05:11:13 upstairs kernel: usb usb3: New USB device found, idVendor=1d6b, idProduct=0001 
May 30 05:11:13 upstairs kernel: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:13 upstairs kernel: usb usb3: Product: UHCI Host Controller 
May 30 05:11:13 upstairs kernel: usb usb3: Manufacturer: Linux 2.6.25 uhci_hcd 
May 30 05:11:13 upstairs kernel: usb usb3: SerialNumber: 0000:00:1d.2 
May 30 05:11:13 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 16 
May 30 05:11:13 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4 
May 30 05:11:13 upstairs kernel: uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000b800 
May 30 05:11:13 upstairs kernel: usb usb4: configuration #1 chosen from 1 choice 
May 30 05:11:13 upstairs kernel: hub 4-0:1.0: USB hub found 
May 30 05:11:13 upstairs kernel: hub 4-0:1.0: 2 ports detected 
May 30 05:11:42 upstairs kernel: usb 1-2: new full speed USB device using uhci_hcd and address 2 
May 30 05:11:42 upstairs kernel: usb 1-2: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: usb 1-2: New USB device found, idVendor=06bd, idProduct=2061 
May 30 05:11:42 upstairs kernel: usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
May 30 05:11:42 upstairs kernel: usb 1-2: Product: SNAPSCAN 
May 30 05:11:42 upstairs kernel: usb 1-2: Manufacturer: AGFA  
May 30 05:11:42 upstairs kernel: usb usb4: New USB device found, idVendor=1d6b, idProduct=0001 
May 30 05:11:42 upstairs kernel: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:42 upstairs kernel: usb usb4: Product: UHCI Host Controller 
May 30 05:11:42 upstairs kernel: usb usb4: Manufacturer: Linux 2.6.25 uhci_hcd 
May 30 05:11:42 upstairs kernel: usb usb4: SerialNumber: 0000:00:1d.3 
May 30 05:11:42 upstairs kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 23 
May 30 05:11:42 upstairs kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:00:1d.7: debug port 1 
May 30 05:11:42 upstairs kernel: PCI: cache line size of 128 is not supported by device 0000:00:1d.7 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fffc00 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
May 30 05:11:42 upstairs kernel: usb usb5: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: hub 5-0:1.0: USB hub found 
May 30 05:11:42 upstairs kernel: hub 5-0:1.0: 8 ports detected 
May 30 05:11:42 upstairs kernel: usb usb5: New USB device found, idVendor=1d6b, idProduct=0002 
May 30 05:11:42 upstairs kernel: usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:42 upstairs kernel: usb usb5: Product: EHCI Host Controller 
May 30 05:11:42 upstairs kernel: usb usb5: Manufacturer: Linux 2.6.25 ehci_hcd 
May 30 05:11:42 upstairs kernel: usb usb5: SerialNumber: 0000:00:1d.7 
May 30 05:11:42 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> GSI 17 (level, low) -> IRQ 17 
May 30 05:11:42 upstairs kernel: uhci_hcd 0000:02:09.0: UHCI Host Controller 
May 30 05:11:42 upstairs kernel: uhci_hcd 0000:02:09.0: new USB bus registered, assigned bus number 6 
May 30 05:11:42 upstairs kernel: uhci_hcd 0000:02:09.0: irq 17, io base 0x0000e400 
May 30 05:11:42 upstairs kernel: usb usb6: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: hub 6-0:1.0: USB hub found 
May 30 05:11:42 upstairs kernel: hub 6-0:1.0: 2 ports detected 
May 30 05:11:42 upstairs kernel: usb 1-2: USB disconnect, address 2 
May 30 05:11:42 upstairs kernel: usb usb6: New USB device found, idVendor=1d6b, idProduct=0001 
May 30 05:11:42 upstairs kernel: usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:42 upstairs kernel: usb usb6: Product: UHCI Host Controller 
May 30 05:11:42 upstairs kernel: usb usb6: Manufacturer: Linux 2.6.25 uhci_hcd 
May 30 05:11:42 upstairs kernel: usb usb6: SerialNumber: 0000:02:09.0 
May 30 05:11:42 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.1[B] -> GSI 18 (level, low) -> IRQ 18 
May 30 05:11:42 upstairs kernel: uhci_hcd 0000:02:09.1: UHCI Host Controller 
May 30 05:11:42 upstairs kernel: uhci_hcd 0000:02:09.1: new USB bus registered, assigned bus number 7 
May 30 05:11:42 upstairs kernel: uhci_hcd 0000:02:09.1: irq 18, io base 0x0000e800 
May 30 05:11:42 upstairs kernel: usb usb7: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: hub 7-0:1.0: USB hub found 
May 30 05:11:42 upstairs kernel: hub 7-0:1.0: 2 ports detected 
May 30 05:11:42 upstairs kernel: usb usb7: New USB device found, idVendor=1d6b, idProduct=0001 
May 30 05:11:42 upstairs kernel: usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:42 upstairs kernel: usb usb7: Product: UHCI Host Controller 
May 30 05:11:42 upstairs kernel: usb usb7: Manufacturer: Linux 2.6.25 uhci_hcd 
May 30 05:11:42 upstairs kernel: usb usb7: SerialNumber: 0000:02:09.1 
May 30 05:11:42 upstairs kernel: ACPI: PCI Interrupt 0000:02:09.2[C] -> GSI 19 (level, low) -> IRQ 19 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:02:09.2: EHCI Host Controller 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:02:09.2: new USB bus registered, assigned bus number 8 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:02:09.2: irq 19, io mem 0xfbfffc00 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:02:09.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004 
May 30 05:11:42 upstairs kernel: usb usb8: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: hub 8-0:1.0: USB hub found 
May 30 05:11:42 upstairs kernel: hub 8-0:1.0: 4 ports detected 
May 30 05:11:42 upstairs kernel: usb usb8: New USB device found, idVendor=1d6b, idProduct=0002 
May 30 05:11:42 upstairs kernel: usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:42 upstairs kernel: usb usb8: Product: EHCI Host Controller 
May 30 05:11:42 upstairs kernel: usb usb8: Manufacturer: Linux 2.6.25 ehci_hcd 
May 30 05:11:42 upstairs kernel: usb usb8: SerialNumber: 0000:02:09.2 
May 30 05:11:42 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 21 (level, low) -> IRQ 21 
May 30 05:11:42 upstairs kernel: ohci_hcd 0000:02:0a.0: OHCI Host Controller 
May 30 05:11:42 upstairs kernel: ohci_hcd 0000:02:0a.0: new USB bus registered, assigned bus number 9 
May 30 05:11:42 upstairs kernel: ohci_hcd 0000:02:0a.0: irq 21, io mem 0xfbffd000 
May 30 05:11:42 upstairs kernel: usb usb9: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: hub 9-0:1.0: USB hub found 
May 30 05:11:42 upstairs kernel: hub 9-0:1.0: 3 ports detected 
May 30 05:11:42 upstairs kernel: usb 8-1: new high speed USB device using ehci_hcd and address 2 
May 30 05:11:42 upstairs kernel: usb 8-1: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: usb 8-1: New USB device found, idVendor=2040, idProduct=9950 
May 30 05:11:42 upstairs kernel: usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3 
May 30 05:11:42 upstairs kernel: usb 8-1: Product: WinTV Nova-DT 
May 30 05:11:42 upstairs kernel: usb 8-1: Manufacturer: Hauppauge 
May 30 05:11:42 upstairs kernel: usb 8-1: SerialNumber: 4030248054 
May 30 05:11:42 upstairs kernel: usb 1-2: new full speed USB device using uhci_hcd and address 3 
May 30 05:11:42 upstairs kernel: usb 1-2: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: usb 1-2: New USB device found, idVendor=06bd, idProduct=2061 
May 30 05:11:42 upstairs kernel: usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
May 30 05:11:42 upstairs kernel: usb 1-2: Product: SNAPSCAN 
May 30 05:11:42 upstairs kernel: usb 1-2: Manufacturer: AGFA  
May 30 05:11:42 upstairs kernel: usb usb9: New USB device found, idVendor=1d6b, idProduct=0001 
May 30 05:11:42 upstairs kernel: usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:42 upstairs kernel: usb usb9: Product: OHCI Host Controller 
May 30 05:11:42 upstairs kernel: usb usb9: Manufacturer: Linux 2.6.25 ohci_hcd 
May 30 05:11:42 upstairs kernel: usb usb9: SerialNumber: 0000:02:0a.0 
May 30 05:11:42 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.1[B] -> GSI 22 (level, low) -> IRQ 22 
May 30 05:11:42 upstairs kernel: ohci_hcd 0000:02:0a.1: OHCI Host Controller 
May 30 05:11:42 upstairs kernel: ohci_hcd 0000:02:0a.1: new USB bus registered, assigned bus number 10 
May 30 05:11:42 upstairs kernel: ohci_hcd 0000:02:0a.1: irq 22, io mem 0xfbffe000 
May 30 05:11:42 upstairs kernel: usb 2-2: new low speed USB device using uhci_hcd and address 2 
May 30 05:11:42 upstairs kernel: usb 2-2: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: usb 2-2: New USB device found, idVendor=045e, idProduct=00f1 
May 30 05:11:42 upstairs kernel: usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0 
May 30 05:11:42 upstairs kernel: usb 2-2: Product: Microsoft Wireless Desktop Receiver 3.1A 
May 30 05:11:42 upstairs kernel: usb 2-2: Manufacturer: Microsft 
May 30 05:11:42 upstairs kernel: usb usb10: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: hub 10-0:1.0: USB hub found 
May 30 05:11:42 upstairs kernel: hub 10-0:1.0: 2 ports detected 
May 30 05:11:42 upstairs kernel: usb usb10: New USB device found, idVendor=1d6b, idProduct=0001 
May 30 05:11:42 upstairs kernel: usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:42 upstairs kernel: usb usb10: Product: OHCI Host Controller 
May 30 05:11:42 upstairs kernel: usb usb10: Manufacturer: Linux 2.6.25 ohci_hcd 
May 30 05:11:42 upstairs kernel: usb usb10: SerialNumber: 0000:02:0a.1 
May 30 05:11:42 upstairs kernel: ACPI: PCI Interrupt 0000:02:0a.2[C] -> GSI 23 (level, low) -> IRQ 23 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:02:0a.2: EHCI Host Controller 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:02:0a.2: new USB bus registered, assigned bus number 11 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:02:0a.2: irq 23, io mem 0xfbfff800 
May 30 05:11:42 upstairs kernel: ehci_hcd 0000:02:0a.2: USB 2.0 started, EHCI 0.95, driver 10 Dec 2004 
May 30 05:11:42 upstairs kernel: usb usb11: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: hub 11-0:1.0: USB hub found 
May 30 05:11:42 upstairs kernel: hub 11-0:1.0: 5 ports detected 
May 30 05:11:42 upstairs kernel: usb usb11: New USB device found, idVendor=1d6b, idProduct=0002 
May 30 05:11:42 upstairs kernel: usb usb11: New USB device strings: Mfr=3, Product=2, SerialNumber=1 
May 30 05:11:42 upstairs kernel: usb usb11: Product: EHCI Host Controller 
May 30 05:11:42 upstairs kernel: usb usb11: Manufacturer: Linux 2.6.25 ehci_hcd 
May 30 05:11:42 upstairs kernel: usb usb11: SerialNumber: 0000:02:0a.2 
May 30 05:11:42 upstairs kernel: ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 22 (level, low) -> IRQ 22 
May 30 05:11:42 upstairs kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[fbfff000-fbfff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8] 
May 30 05:11:42 upstairs kernel: input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb2/2-2/2-2:1.0/input/input2 
May 30 05:11:42 upstairs kernel: input: USB HID v1.11 Keyboard [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
May 30 05:11:42 upstairs kernel: dib0700: loaded with support for 6 different device-types 
May 30 05:11:42 upstairs kernel: dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state. 
May 30 05:11:42 upstairs kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
May 30 05:11:42 upstairs kernel: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
May 30 05:11:42 upstairs kernel: usb 11-4: new high speed USB device using ehci_hcd and address 2 
May 30 05:11:42 upstairs kernel: usb 11-4: configuration #1 chosen from 1 choice 
May 30 05:11:42 upstairs kernel: hub 11-4:1.0: USB hub found 
May 30 05:11:42 upstairs kernel: hub 11-4:1.0: 4 ports detected 
May 30 05:11:42 upstairs kernel: input: Microsft Microsoft Wireless Desktop Receiver 3.1A as /devices/pci0000:00/0000:00:1d.1/usb2/2-2/2-2:1.1/input/input3 
May 30 05:11:42 upstairs kernel: input: USB HID v1.11 Mouse [Microsft Microsoft Wireless Desktop Receiver 3.1A] on usb-0000:00:1d.1-2 
May 30 05:11:42 upstairs kernel: DVB: registering frontend 0 (DiBcom 3000MC/P)... 
May 30 05:11:42 upstairs kernel: MT2060: successfully identified (IF1 = 1230) 
May 30 05:11:42 upstairs kernel: usb 11-4: New USB device found, idVendor=0409, idProduct=0059 
May 30 05:11:42 upstairs kernel: usb 11-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0 
May 30 05:11:42 upstairs kernel: usbcore: registered new interface driver usbhid 
May 30 05:11:42 upstairs kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver 
May 30 05:11:42 upstairs kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer. 
May 30 05:11:42 upstairs kernel: DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T) 
May 30 05:11:42 upstairs kernel: DVB: registering frontend 1 (DiBcom 3000MC/P)... 
May 30 05:11:42 upstairs kernel: MT2060: successfully identified (IF1 = 1234) 
May 30 05:11:42 upstairs kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1e.0/0000:02:09.2/usb8/8-1/input/input4 
May 30 05:11:42 upstairs kernel: dvb-usb: schedule remote query interval to 150 msecs. 
May 30 05:11:42 upstairs kernel: dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and connected. 
May 30 05:11:42 upstairs kernel: usbcore: registered new interface driver dvb_usb_dib0700 
May 30 05:11:42 upstairs kernel: ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00110666000013cc] 
May 30 05:11:42 upstairs kernel: fuse init (API version 7.9) 
May 30 05:11:42 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
May 30 05:11:42 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
May 30 05:11:42 upstairs kernel: EXT3 FS on sdb6, internal journal 
May 30 05:11:42 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
May 30 05:11:42 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
May 30 05:11:42 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
May 30 05:11:42 upstairs kernel: EXT3 FS on sda6, internal journal 
May 30 05:11:42 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
May 30 05:11:42 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
May 30 05:11:42 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
May 30 05:11:42 upstairs kernel: EXT3 FS on sda7, internal journal 
May 30 05:11:42 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
May 30 05:11:42 upstairs kernel: kjournald starting.  Commit interval 5 seconds 
May 30 05:11:42 upstairs kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is recommended 
May 30 05:11:42 upstairs kernel: EXT3 FS on sdc2, internal journal 
May 30 05:11:42 upstairs kernel: EXT3-fs: mounted filesystem with ordered data mode. 
May 30 05:11:42 upstairs kernel: Adding 4096532k swap on /dev/sda5.  Priority:-1 extents:1 across:4096532k 
May 30 05:11:42 upstairs kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1 
May 30 05:11:42 upstairs kernel: ip_tables: (C) 2000-2006 Netfilter Core Team 
May 30 05:11:42 upstairs kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max) 
May 30 05:11:42 upstairs kernel: parport_pc 00:06: disabled 
May 30 05:11:42 upstairs kernel: pnp: the driver 'parport_pc' has been unregistered 
May 30 05:11:42 upstairs kernel: ieee1394: Node removed: ID:BUS[0-00:1023]  GUID[00110666000013cc] 

--Boundary-00=_JJiQInXJAOA3AaU
Content-Type: text/plain;
  charset="us-ascii";
  name="config.bad"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="config.bad"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25
# Fri May 30 05:09:11 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=15
# CONFIG_CGROUPS is not set
# CONFIG_GROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
CONFIG_MPENTIUM4=y
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=6
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_HPET_TIMER is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
CONFIG_IRQBALANCE=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=m

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
# CONFIG_NET_IPGRE_BROADCAST is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CT_ACCT is not set
# CONFIG_NF_CONNTRACK_MARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
CONFIG_NETFILTER_XT_MATCH_HELPER=m
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=m
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_MATCH_RECENT is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
CONFIG_IP_NF_FILTER=m
# CONFIG_IP_NF_TARGET_REJECT is not set
CONFIG_IP_NF_TARGET_LOG=m
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
# CONFIG_IP_NF_TARGET_REDIRECT is not set
# CONFIG_IP_NF_TARGET_NETMAP is not set
# CONFIG_NF_NAT_SNMP_BASIC is not set
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
CONFIG_TIPC=m
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
# CONFIG_ATM is not set
CONFIG_BRIDGE=m
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_RR is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=m
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
# CONFIG_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=m
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=m
# CONFIG_BT_L2CAP is not set
# CONFIG_BT_SCO is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
# CONFIG_BT_HCIUSB_SCO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
CONFIG_CFG80211=m
# CONFIG_NL80211 is not set
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
# CONFIG_MAC80211_DEBUG is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_OHCI1394=m

#
# Protocols
#
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
CONFIG_IEEE1394_DV1394=m
CONFIG_IEEE1394_RAWIO=m
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_IFB is not set
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_EEPRO100 is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_IWLCORE is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_ASYNC=m
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_MPPE is not set
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
CONFIG_SLIP=m
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLHC=m
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=128
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_I810=m
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_BWQCAM is not set
# CONFIG_VIDEO_CQCAM is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_TUNER_3036 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_W9968CF is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_CORE=m
CONFIG_DVB_CORE_ATTACH=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
# CONFIG_DVB_USB_A800 is not set
# CONFIG_DVB_USB_DIBUSB_MB is not set
# CONFIG_DVB_USB_DIBUSB_MC is not set
CONFIG_DVB_USB_DIB0700=m
# CONFIG_DVB_USB_UMT_010 is not set
# CONFIG_DVB_USB_CXUSB is not set
# CONFIG_DVB_USB_M920X is not set
# CONFIG_DVB_USB_GL861 is not set
# CONFIG_DVB_USB_AU6610 is not set
# CONFIG_DVB_USB_DIGITV is not set
# CONFIG_DVB_USB_VP7045 is not set
# CONFIG_DVB_USB_VP702X is not set
# CONFIG_DVB_USB_GP8PSK is not set
# CONFIG_DVB_USB_NOVA_T_USB2 is not set
# CONFIG_DVB_USB_TTUSB2 is not set
CONFIG_DVB_USB_DTT200U=m
# CONFIG_DVB_USB_OPERA1 is not set
# CONFIG_DVB_USB_AF9005 is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_CINERGYT2 is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_TDA10086 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
# CONFIG_DVB_ZL10353 is not set
# CONFIG_DVB_DIB3000MB is not set
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
# CONFIG_DVB_LGDT330X is not set
# CONFIG_DVB_S5H1409 is not set

#
# Tuners/PLL support
#
CONFIG_DVB_PLL=m
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TDA827X is not set
# CONFIG_DVB_TDA18271 is not set
# CONFIG_DVB_TUNER_QT1010 is not set
CONFIG_DVB_TUNER_MT2060=m
CONFIG_DVB_TUNER_MT2266=m
# CONFIG_DVB_TUNER_MT2131 is not set
CONFIG_DVB_TUNER_DIB0070=m
# CONFIG_DVB_TUNER_XC5000 is not set

#
# Miscellaneous devices
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_TUA6100 is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=y
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_AC97_POWER_SAVE is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# ALSA SoC audio for Freescale SOCs
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=m
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_CPA_DEBUG is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
# CONFIG_CRC16 is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-00=_JJiQInXJAOA3AaU
Content-Type: text/x-log;
  charset="us-ascii";
  name="bisect.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bisect.log"

git-bisect start
# good: [4b119e21d0c66c22e8ca03df05d9de623d0eb50f] Linux 2.6.25
git-bisect good 4b119e21d0c66c22e8ca03df05d9de623d0eb50f
# bad: [e490517a039a99d692cb3a5561941b0a5f576172] Linux 2.6.26-rc4
git-bisect bad e490517a039a99d692cb3a5561941b0a5f576172
# good: [10c993a6b5418cb1026775765ba4c70ffb70853d] Merge branch 'for-linus' of git://linux-nfs.org/~bfields/linux
git-bisect good 10c993a6b5418cb1026775765ba4c70ffb70853d
# bad: [3547ff3aefbe092ca35506c60c02e2d17a4f2199] signals: do_tkill: don't use tasklist_lock
git-bisect bad 3547ff3aefbe092ca35506c60c02e2d17a4f2199
# bad: [a3b51e0142d1be156ac697eaadadd6cfbb7ba32b] mempolicy: convert MPOL constants to enum
git-bisect bad a3b51e0142d1be156ac697eaadadd6cfbb7ba32b
# good: [eb855fd8e7f6b1d8b50f24aa36803e29b367b041] Merge branch 'for-linus' of git://git.o-hand.com/linux-rpurdie-leds
git-bisect good eb855fd8e7f6b1d8b50f24aa36803e29b367b041
# good: [adb1ff46754a87f3f6c9e7ee0a92f9a8a183bb38] KVM: Limit vcpu mmap size to one page on non-x86
git-bisect good adb1ff46754a87f3f6c9e7ee0a92f9a8a183bb38
# good: [66c0b394f08fd89236515c1c84485ea712a157be] KVM: kill file->f_count abuse in kvm
git-bisect good 66c0b394f08fd89236515c1c84485ea712a157be
# good: [42cadc86008aae0fd9ff31642dc01ed50723cf32] Merge branch 'kvm-updates-2.6.26' of git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm
git-bisect good 42cadc86008aae0fd9ff31642dc01ed50723cf32
# bad: [d1d7b19d433188e94fc87cc7ca66363cd77a0bba] [SCSI] aic7xxx: add static
git-bisect bad d1d7b19d433188e94fc87cc7ca66363cd77a0bba
# bad: [9f9a73b6fe0c8fd9b54b650e34956eb92df6abfa] [SCSI] scsi_transport_spi: include sysfs.h
git-bisect bad 9f9a73b6fe0c8fd9b54b650e34956eb92df6abfa
# bad: [97f46ae45c70857e459b7f8df1fc2807e7bd90a9] [SCSI] bsg: add release callback support
git-bisect bad 97f46ae45c70857e459b7f8df1fc2807e7bd90a9
# bad: [bbd1ae412c9eb09ae7bb11cfaf7018a2367d493f] [SCSI] qla2xxx, lfpc: Rename 'state' attribute to 'link_state'
git-bisect bad bbd1ae412c9eb09ae7bb11cfaf7018a2367d493f
# good: [cb6b7f40630f94126233194847a86bf5501fb63c] [SCSI] ses: fix up functionality after class_device->device conversion
git-bisect good cb6b7f40630f94126233194847a86bf5501fb63c
# bad: [b0ed43360fdca227048d88a08290365cb681c1a8] [SCSI] add scsi_host and scsi_target to scsi_bus
git-bisect bad b0ed43360fdca227048d88a08290365cb681c1a8

--Boundary-00=_JJiQInXJAOA3AaU--
