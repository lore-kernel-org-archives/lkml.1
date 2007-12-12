Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbXLLO7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbXLLO7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbXLLO67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:58:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:6223 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbXLLO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:58:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mUegYvb/Nc+wQA4cIwm2NXvcUFMgbMxuU4bkxuTGTEk10IXCT35DBFYYKkCXc1w2iLK734iwm1apVbGJAEiOP/83QVOCbDlgVrcvziBcHa6pvcAFOrGgSzq08kIgoWNf//1LyXBJrfZ0DEN+bOCg8IyMoWmVFtV8x7Tr7S7cJYw=
Message-ID: <5501535d0712120658va11a8c0j6a7b9d08b2ce0a48@mail.gmail.com>
Date: Wed, 12 Dec 2007 15:58:56 +0100
From: "Bjoern Olausson" <lkmlist@gmail.com>
To: "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Tejun Heo" <htejun@gmail.com>,
       alan@lxorguk.ukuu.org.uk
Subject: PATA_HPT37X embezzles two ports
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to inform everybody:

PATA_HPT37X embezzles two ports.

It was fixed on 2.6.23.1 by a patch from Alan
http://bugzilla.kernel.org/show_bug.cgi?id=9261

But reoccurs in 2.6.24-rc5

I just diffed the dmesg here, you can find the complete dmesg in the bugzilla
http://bugzilla.kernel.org/show_bug.cgi?id=9261

diff -Nrup hpt-2.6.23.1 hpt-2.6.24-rc5
--- hpt-2.6.23.1        2007-12-12 15:40:11.000000000 +0100
+++ hpt-2.6.24-rc5      2007-12-12 16:28:00.000000000 +0100
@@ -1,182 +1,4 @@
-Linux version 2.6.23.1 (root@enterprise) (gcc version 4.1.2 (Gentoo
4.1.2)) #2 Tue Dec 11 22:43:59 CET 2007
-BIOS-provided physical RAM map:
- BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
- BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
- BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
- BIOS-e820: 0000000000100000 - 000000005ff30000 (usable)
- BIOS-e820: 000000005ff30000 - 000000005ff40000 (ACPI data)
- BIOS-e820: 000000005ff40000 - 000000005fff0000 (ACPI NVS)
- BIOS-e820: 000000005fff0000 - 0000000060000000 (reserved)
- BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
-639MB HIGHMEM available.
-896MB LOWMEM available.
-Entering add_active_range(0, 0, 393008) 0 entries of 256 used
-Zone PFN ranges:
-  DMA             0 ->     4096
-  Normal       4096 ->   229376
-  HighMem    229376 ->   393008
-Movable zone start PFN for each node
-early_node_map[1] active PFN ranges
-    0:        0 ->   393008
-On node 0 totalpages: 393008
-  DMA zone: 32 pages used for memmap
-  DMA zone: 0 pages reserved
-  DMA zone: 4064 pages, LIFO batch:0
-  Normal zone: 1760 pages used for memmap
-  Normal zone: 223520 pages, LIFO batch:31
-  HighMem zone: 1278 pages used for memmap
-  HighMem zone: 162354 pages, LIFO batch:31
-  Movable zone: 0 pages used for memmap
-DMI 2.3 present.
-ACPI: RSDP 000F9BC0, 0014 (r0 ACPIAM)
-ACPI: RSDT 5FF30000, 0030 (r1 A M I  OEMRSDT   2000503 MSFT       97)
-ACPI: FACP 5FF30200, 0081 (r2 A M I  OEMFACP   2000503 MSFT       97)
-ACPI: DSDT 5FF30360, 343A (r1  P4V88 P4V88001        1 INTL  2002026)
-ACPI: FACS 5FF40000, 0040
-ACPI: APIC 5FF30300, 0052 (r1 A M I  OEMAPIC   2000503 MSFT       97)
-ACPI: OEMB 5FF40040, 003F (r1 A M I  OEMBIOS   2000503 MSFT       97)
-ACPI: PM-Timer IO Port: 0x808
-ACPI: Local APIC address 0xfee00000
-ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
-Processor #0 15:4 APIC version 20
-ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
-ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
-IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
-ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
-ACPI: IRQ0 used by override.
-ACPI: IRQ2 used by override.
-ACPI: IRQ9 used by override.
-Enabling APIC mode:  Flat.  Using 1 I/O APICs
-Using ACPI (MADT) for SMP configuration information
-Allocating PCI resources starting at 70000000 (gap: 60000000:9ffc0000)
-Built 1 zonelists in Zone order.  Total pages: 389938
-Kernel command line: root=/dev/md1
-mapped APIC to ffffb000 (fee00000)
-mapped IOAPIC to ffffa000 (fec00000)
-Enabling fast FPU save and restore... done.
-Enabling unmasked SIMD FPU exception support... done.
-Initializing CPU#0
-PID hash table entries: 4096 (order: 12, 16384 bytes)
-Detected 2659.603 MHz processor.
-Console: colour VGA+ 80x25
-console [tty0] enabled
-Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
-Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
-Memory: 1552008k/1572032k available (3754k kernel code, 18872k
reserved, 1349k data, 232k init, 654528k highmem)
-virtual kernel memory layout:
-    fixmap  : 0xfffa8000 - 0xfffff000   ( 348 kB)
-    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
-    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
-    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
-      .init : 0xc0600000 - 0xc063a000   ( 232 kB)
-      .data : 0xc04aaa28 - 0xc05fc19c   (1349 kB)
-      .text : 0xc0100000 - 0xc04aaa28   (3754 kB)
-Checking if this processor honours the WP bit even in supervisor mode... Ok.
-Calibrating delay using timer specific routine.. 5323.32 BogoMIPS (lpj=2661663)
-Mount-cache hash table entries: 512
-CPU: After generic identify, caps: bfebfbff 00000000 00000000
00000000 0000441d 00000000 00000000 00000000
-monitor/mwait feature present.
-using mwait in idle threads.
-CPU: Trace cache: 12K uops, L1 D cache: 16K
-CPU: L2 cache: 256K
-CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b180
0000441d 00000000 00000000 00000000
-Intel machine check architecture supported.
-Intel machine check reporting enabled on CPU#0.
-CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
-CPU0: Thermal monitoring enabled
-Compat vDSO mapped to ffffe000.
-CPU: Intel(R) Celeron(R) CPU 2.66GHz stepping 01
-Checking 'hlt' instruction... OK.
-ACPI: Core revision 20070126
-ENABLING IO-APIC IRQs
-..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
-xor: automatically using best checksumming function: pIII_sse
-   pIII_sse  :  4320.000 MB/sec
-xor: using function: pIII_sse (4320.000 MB/sec)
-NET: Registered protocol family 16
-No dock devices found.
-ACPI: bus type pci registered
-PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=1
-PCI: Using configuration type 1
-Setting up standard PCI resources
-ACPI: EC: Look up EC in DSDT
-ACPI: Interpreter enabled
-ACPI: (supports S0 S5)
-ACPI: Using IOAPIC for interrupt routing
-ACPI: PCI Root Bridge [PCI0] (0000:00)
-ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
-ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 14 15)
-ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 14 15)
-ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 10 11 14 15)
-ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 7 10 11 14 15)
-ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
-ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
-ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
-ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
-ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -
E5, should be D8 [20070126]
-Linux Plug and Play Support v0.97 (c) Adam Belay
-pnp: PnP ACPI init
-ACPI: bus type pnp registered
-pnp: PnP ACPI: found 13 devices
-ACPI: ACPI bus type pnp unregistered
-SCSI subsystem initialized
-libata version 2.21 loaded.
-usbcore: registered new interface driver usbfs
-usbcore: registered new interface driver hub
-usbcore: registered new device driver usb
-PCI: Using ACPI for IRQ routing
-PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
-Time: tsc clocksource has been installed.
-pnp: 00:08: iomem range 0xfec80000-0xfec800ff has been reserved
-pnp: 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
-pnp: 00:08: iomem range 0xfee00000-0xfee00fff has been reserved
-pnp: 00:08: iomem range 0xfff80000-0xffffffff could not be reserved
-pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
-pnp: 00:0c: iomem range 0xc0000-0xdffff could not be reserved
-pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
-pnp: 00:0c: iomem range 0x100000-0x5fffffff could not be reserved
-PCI: Bridge: 0000:00:01.0
-  IO window: disabled.
-  MEM window: f3e00000-f7efffff
-  PREFETCH window: d3d00000-f3cfffff
-PCI: Setting latency timer of device 0000:00:01.0 to 64
-NET: Registered protocol family 2
-IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
-TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
-TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
-TCP: Hash tables configured (established 131072 bind 65536)
-TCP reno registered
-Machine check exception polling timer started.
-IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
-audit: initializing netlink socket (disabled)
-audit(1197473373.195:1): initialized
-highmem bounce pool size: 64 pages
-VFS: Disk quotas dquot_6.5.1
-Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
-Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
-NTFS driver 2.1.28 [Flags: R/W].
-SGI XFS with large block numbers, no debug enabled
-async_tx: api initialized (sync-only)
-io scheduler noop registered
-io scheduler anticipatory registered (default)
-io scheduler deadline registered
-io scheduler cfq registered
-PCI: VIA PCI bridge detected. Disabling DAC.
-PCI: Bypassing VIA 8237 APIC De-Assert Message
-Boot video device is 0000:01:00.0
-input: Power Button (FF) as /devices/virtual/input/input0
-ACPI: Power Button (FF) [PWRF]
-input: Power Button (CM) as /devices/virtual/input/input1
-ACPI: Power Button (CM) [PWRB]
-ACPI: Processor [CPU1] (supports 16 throttling states)
-lp: driver loaded but no devices found
-Real Time Clock Driver v1.12ac
-Non-volatile memory driver v1.2
-Linux agpgart interface v0.102
-agpgart: Detected VIA PT880 chipset
-agpgart: AGP aperture is 64M @ 0xf8000000
-Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
-serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
+irq = 4) is a 16550A
 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
 parport_pc 00:06: reported by Plug and Play ACPI
 parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
@@ -200,8 +22,8 @@ ACPI: PCI Interrupt 0000:00:0f.0[B] -> G
 sata_via 0000:00:0f.0: routed to hard irq line 10
 scsi0 : sata_via
 scsi1 : sata_via
-ata1: SATA max UDMA/133 cmd 0x0001e800 ctl 0x0001e402 bmdma 0x0001d800 irq 18
-ata2: SATA max UDMA/133 cmd 0x0001e000 ctl 0x0001dc02 bmdma 0x0001d808 irq 18
+ata1: SATA max UDMA/133 cmd 0xe800 ctl 0xe400 bmdma 0xd800 irq 18
+ata2: SATA max UDMA/133 cmd 0xe000 ctl 0xdc00 bmdma 0xd808 irq 18
 ata1: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
 ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
 pata_hpt37x: BIOS has not set timing clocks.
@@ -210,8 +32,10 @@ PCI: Enabling device 0000:00:0a.0 (0000
 ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 19
 scsi2 : pata_hpt37x
 scsi3 : pata_hpt37x
-ata3: PATA max UDMA/100 cmd 0x00011400 ctl 0x00011412 bmdma 0x00011000 irq 19
-ata4: PATA max UDMA/100 cmd 0x00011408 ctl 0x00011416 bmdma 0x00011008 irq 19
+ata3: PATA max UDMA/100 cmd 0x1400 ctl 0x1410 bmdma 0x1000 irq 19
+ata4: PATA max UDMA/100 cmd 0x1408 ctl 0x1414 bmdma 0x1008 irq 19
+Find mode for 8 reports AC1F48A
+Find mode for 8 reports AC1F48A
 ata3.00: ATA-7: Maxtor 6Y200P0, YAR41BW0, max UDMA/133
 ata3.00: 398297088 sectors, multi 0: LBA48
 ata3.01: ATA-7: Maxtor 6Y200P0, YAR41BW0, max UDMA/133
@@ -222,6 +46,8 @@ Find mode for DMA 69 reports 12848242
 Find mode for DMA 69 reports 12848242
 ata3.00: configured for UDMA/100
 ata3.01: configured for UDMA/100
+Find mode for 8 reports AC1F48A
+Find mode for 8 reports AC1F48A
 ata4.00: ATA-7: Maxtor 6L250R0, BAJ41G20, max UDMA/133
 ata4.00: 490234752 sectors, multi 0: LBA48
 ata4.01: ATA-7: Maxtor 6L250R0, BAH41G10, max UDMA/133
@@ -285,48 +111,18 @@ pata_hpt37x: bus clock 33MHz, using 50MH
 ACPI: PCI Interrupt 0000:00:0a.1[A] -> GSI 18 (level, low) -> IRQ 19
 scsi4 : pata_hpt37x
 scsi5 : pata_hpt37x
-ata5: PATA max UDMA/100 cmd 0x0001b000 ctl 0x0001ac02 bmdma 0x0001a000 irq 19
-ata6: PATA max UDMA/100 cmd 0x0001a800 ctl 0x0001a402 bmdma 0x0001a008 irq 19
-ata6.00: ATA-7: Maxtor 5A250J0, RAM51VV0, max UDMA/133
-ata6.00: 490234752 sectors, multi 0: LBA48
-ata6.01: ATA-7: HDT722525DLAT80, V44OA96A, max UDMA/133
-ata6.01: 488397168 sectors, multi 0: LBA48
-Find mode for 12 reports A81F442
-Find mode for 12 reports A81F442
-Find mode for DMA 69 reports 12848242
-Find mode for DMA 69 reports 12848242
-ata6.00: configured for UDMA/100
-ata6.01: configured for UDMA/100
-scsi 5:0:0:0: Direct-Access     ATA      Maxtor 5A250J0   RAM5 PQ: 0 ANSI: 5
-sd 5:0:0:0: [sde] 490234752 512-byte hardware sectors (251000 MB)
-sd 5:0:0:0: [sde] Write Protect is off
-sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
-sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
-sd 5:0:0:0: [sde] 490234752 512-byte hardware sectors (251000 MB)
-sd 5:0:0:0: [sde] Write Protect is off
-sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
-sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
- sde: sde1
-sd 5:0:0:0: [sde] Attached SCSI disk
-sd 5:0:0:0: Attached scsi generic sg4 type 0
-scsi 5:0:1:0: Direct-Access     ATA      HDT722525DLAT80  V44O PQ: 0 ANSI: 5
-sd 5:0:1:0: [sdf] 488397168 512-byte hardware sectors (250059 MB)
-sd 5:0:1:0: [sdf] Write Protect is off
-sd 5:0:1:0: [sdf] Mode Sense: 00 3a 00 00
-sd 5:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
-sd 5:0:1:0: [sdf] 488397168 512-byte hardware sectors (250059 MB)
-sd 5:0:1:0: [sdf] Write Protect is off
-sd 5:0:1:0: [sdf] Mode Sense: 00 3a 00 00
-sd 5:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
- sdf: sdf1
-sd 5:0:1:0: [sdf] Attached SCSI disk
-sd 5:0:1:0: Attached scsi generic sg5 type 0
-pata_via 0000:00:0f.1: version 0.3.2
+ata5: PATA max UDMA/100 cmd 0xb000 ctl 0xac00 bmdma 0xa000 irq 19
+ata6: PATA max UDMA/100 cmd 0xa800 ctl 0xa400 bmdma 0xa008 irq 19
+Find mode for 8 reports AC1F48A
+Find mode for 8 reports AC1F48A
+Find mode for 8 reports AC1F48A
+Find mode for 8 reports AC1F48A
+pata_via 0000:00:0f.1: version 0.3.3
 ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 18
 scsi6 : pata_via
 scsi7 : pata_via
-ata7: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001fc00 irq 14
-ata8: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001fc08 irq 15
+ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
+ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
 ata7.00: ATA-7: Maxtor 6Y160P0, YAR41BW0, max UDMA/133
 ata7.00: 320173056 sectors, multi 16: LBA48
 ata7.01: ATA-7: Maxtor 6Y160P0, YAR41BW0, max UDMA/133
@@ -336,31 +132,31 @@ ata7.01: configured for UDMA/133
 ata8.01: ATAPI: ATAPI-CD ROM-DRIVE-52MAX, Ver 52OP, max UDMA/33
 ata8.01: configured for UDMA/33
 scsi 6:0:0:0: Direct-Access     ATA      Maxtor 6Y160P0   YAR4 PQ: 0 ANSI: 5
-sd 6:0:0:0: [sdg] 320173056 512-byte hardware sectors (163929 MB)
-sd 6:0:0:0: [sdg] Write Protect is off
-sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
-sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
-sd 6:0:0:0: [sdg] 320173056 512-byte hardware sectors (163929 MB)
-sd 6:0:0:0: [sdg] Write Protect is off
-sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
-sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
- sdg: sdg1 sdg2 sdg3
-sd 6:0:0:0: [sdg] Attached SCSI disk
-sd 6:0:0:0: Attached scsi generic sg6 type 0
+sd 6:0:0:0: [sde] 320173056 512-byte hardware sectors (163929 MB)
+sd 6:0:0:0: [sde] Write Protect is off
+sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
+sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
+sd 6:0:0:0: [sde] 320173056 512-byte hardware sectors (163929 MB)
+sd 6:0:0:0: [sde] Write Protect is off
+sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
+sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
+ sde: sde1 sde2 sde3
+sd 6:0:0:0: [sde] Attached SCSI disk
+sd 6:0:0:0: Attached scsi generic sg4 type 0
 scsi 6:0:1:0: Direct-Access     ATA      Maxtor 6Y160P0   YAR4 PQ: 0 ANSI: 5
-sd 6:0:1:0: [sdh] 320173056 512-byte hardware sectors (163929 MB)
-sd 6:0:1:0: [sdh] Write Protect is off
-sd 6:0:1:0: [sdh] Mode Sense: 00 3a 00 00
-sd 6:0:1:0: [sdh] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
-sd 6:0:1:0: [sdh] 320173056 512-byte hardware sectors (163929 MB)
-sd 6:0:1:0: [sdh] Write Protect is off
-sd 6:0:1:0: [sdh] Mode Sense: 00 3a 00 00
-sd 6:0:1:0: [sdh] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
- sdh: sdh1 sdh2 sdh3
-sd 6:0:1:0: [sdh] Attached SCSI disk
-sd 6:0:1:0: Attached scsi generic sg7 type 0
+sd 6:0:1:0: [sdf] 320173056 512-byte hardware sectors (163929 MB)
+sd 6:0:1:0: [sdf] Write Protect is off
+sd 6:0:1:0: [sdf] Mode Sense: 00 3a 00 00
+sd 6:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
+sd 6:0:1:0: [sdf] 320173056 512-byte hardware sectors (163929 MB)
+sd 6:0:1:0: [sdf] Write Protect is off
+sd 6:0:1:0: [sdf] Mode Sense: 00 3a 00 00
+sd 6:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
+ sdf: sdf1 sdf2 sdf3
+sd 6:0:1:0: [sdf] Attached SCSI disk
+sd 6:0:1:0: Attached scsi generic sg5 type 0
 scsi 7:0:1:0: CD-ROM            ATAPI-CD ROM-DRIVE-52MAX  52OP PQ: 0 ANSI: 5
-scsi 7:0:1:0: Attached scsi generic sg8 type 5
+scsi 7:0:1:0: Attached scsi generic sg6 type 5
 ieee1394: raw1394: /dev/raw1394 device initialized
 ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 20
 ehci_hcd 0000:00:10.4: EHCI Host Controller
@@ -416,25 +212,25 @@ md: raid0 personality registered for lev
 md: raid1 personality registered for level 1
 md: raid10 personality registered for level 10
 raid6: int32x1    664 MB/s
-raid6: int32x2    738 MB/s
-raid6: int32x4    617 MB/s
-raid6: int32x8    480 MB/s
-raid6: mmxx1     1601 MB/s
-raid6: mmxx2     1660 MB/s
-raid6: sse1x1     937 MB/s
-raid6: sse1x2    1058 MB/s
-raid6: sse2x1    1906 MB/s
-raid6: sse2x2    1750 MB/s
-raid6: using algorithm sse2x1 (1906 MB/s)
+raid6: int32x2    742 MB/s
+raid6: int32x4    621 MB/s
+raid6: int32x8    492 MB/s
+raid6: mmxx1     1613 MB/s
+raid6: mmxx2     1667 MB/s
+raid6: sse1x1     941 MB/s
+raid6: sse1x2    1062 MB/s
+raid6: sse2x1    1917 MB/s
+raid6: sse2x2    1761 MB/s
+raid6: using algorithm sse2x1 (1917 MB/s)
 md: raid6 personality registered for level 6
 md: raid5 personality registered for level 5
 md: raid4 personality registered for level 4
 md: multipath personality registered for level -4
 md: faulty personality registered for level -5
-device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:
dm-devel@redhat.com
+device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised:
dm-devel@redhat.com
 usbcore: registered new interface driver usbhid
 drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
-Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20
09:12:58 2007 UTC).
+Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20
19:16:42 2007 UTC).
 ALSA device list:
   No soundcards found.
 oprofile: using NMI interrupt.
@@ -447,7 +243,7 @@ u32 classifier
     input device check on
     Actions configured
 Netfilter messages via NETLINK v0.30.
-nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
+nf_conntrack version 0.5.0 (14336 buckets, 57344 max)
 ctnetlink v0.93: registering with nfnetlink.
 IPv4 over IPv4 tunneling driver
 ip_tables: (C) 2000-2006 Netfilter Core Team
@@ -456,71 +252,67 @@ arp_tables: (C) 2002 David S. Miller
 TCP cubic registered
 NET: Registered protocol family 1
 NET: Registered protocol family 17
+RPC: Registered udp transport module.
+RPC: Registered tcp transport module.
 p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
 Using IPI Shortcut mode
 md: Autodetecting RAID arrays.
+md: Scanned 8 and added 8 devices.
 md: autorun ...
-md: considering sdh3 ...
-md:  adding sdh3 ...
-md: sdh1 has different UUID to sdh3
-md:  adding sdg3 ...
-md: sdg1 has different UUID to sdh3
-md: sdf1 has different UUID to sdh3
-md: sde1 has different UUID to sdh3
-md: sdd1 has different UUID to sdh3
-md: sdc1 has different UUID to sdh3
-md: sdb1 has different UUID to sdh3
-md: sda1 has different UUID to sdh3
+md: considering sdf3 ...
+md:  adding sdf3 ...
+md: sdf1 has different UUID to sdf3
+md:  adding sde3 ...
+md: sde1 has different UUID to sdf3
+md: sdd1 has different UUID to sdf3
+md: sdc1 has different UUID to sdf3
+md: sdb1 has different UUID to sdf3
+md: sda1 has different UUID to sdf3
 md: created md1
-md: bind<sdg3>
-md: bind<sdh3>
-md: running: <sdh3><sdg3>
+md: bind<sde3>
+md: bind<sdf3>
+md: running: <sdf3><sde3>
 raid1: raid set md1 active with 2 out of 2 mirrors
-md1: bitmap initialized from disk: read 10/10 pages, set 16 bits
+md1: bitmap initialized from disk: read 10/10 pages, set 22 bits
 created bitmap (152 pages) for device md1
-md: considering sdh1 ...
-md:  adding sdh1 ...
-md:  adding sdg1 ...
-md: sdf1 has different UUID to sdh1
-md: sde1 has different UUID to sdh1
-md: sdd1 has different UUID to sdh1
-md: sdc1 has different UUID to sdh1
-md: sdb1 has different UUID to sdh1
-md: sda1 has different UUID to sdh1
+md: considering sdf1 ...
+md:  adding sdf1 ...
+md:  adding sde1 ...
+md: sdd1 has different UUID to sdf1
+md: sdc1 has different UUID to sdf1
+md: sdb1 has different UUID to sdf1
+md: sda1 has different UUID to sdf1
 md: created md0
-md: bind<sdg1>
-md: bind<sdh1>
-md: running: <sdh1><sdg1>
+md: bind<sde1>
+md: bind<sdf1>
+md: running: <sdf1><sde1>
 raid1: raid set md0 active with 2 out of 2 mirrors
 md0: bitmap initialized from disk: read 1/1 pages, set 0 bits
 created bitmap (6 pages) for device md0
-md: considering sdf1 ...
-md:  adding sdf1 ...
-md:  adding sde1 ...
+md: considering sdd1 ...
 md:  adding sdd1 ...
 md:  adding sdc1 ...
-md: sdb1 has different UUID to sdf1
-md: sda1 has different UUID to sdf1
+md: sdb1 has different UUID to sdd1
+md: sda1 has different UUID to sdd1
 md: created md4
 md: bind<sdc1>
 md: bind<sdd1>
-md: bind<sde1>
-md: bind<sdf1>
-md: running: <sdf1><sde1><sdd1><sdc1>
-raid5: device sdf1 operational as raid disk 3
-raid5: device sde1 operational as raid disk 2
+md: running: <sdd1><sdc1>
 raid5: device sdd1 operational as raid disk 1
 raid5: device sdc1 operational as raid disk 0
-raid5: allocated 4210kB for md4
-raid5: raid level 5 set md4 active with 4 out of 4 devices, algorithm 2
+raid5: not enough operational devices for md4 (2/4 failed)
 RAID5 conf printout:
- --- rd:4 wd:4
+ --- rd:4 wd:2
  disk 0, o:1, dev:sdc1
  disk 1, o:1, dev:sdd1
- disk 2, o:1, dev:sde1
- disk 3, o:1, dev:sdf1
-md4: bitmap initialized from disk: read 15/15 pages, set 0 bits
-created bitmap (233 pages) for device md4
+raid5: failed to run raid set md4
+md: pers->run() failed ...
+md: do_md_run() returned -5
+md: md4 stopped.
+md: unbind<sdd1>
+md: export_rdev(sdd1)
+md: unbind<sdc1>
+md: export_rdev(sdc1)
 md: considering sdb1 ...
 md:  adding sdb1 ...
 md:  adding sda1 ...
@@ -538,9 +330,10 @@ VFS: Mounted root (ext3 filesystem) read
 Freeing unused kernel memory: 232k freed
 ath_hal: module license 'Proprietary' taints kernel.
 ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416, RF5111, RF5112,
RF2413, RF5413, RF2133)
+ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 21
 wlan: 0.8.4.2 (0.9.4)
 ath_pci: 0.9.4.5 (0.9.4)
-ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 17 (level, low) -> IRQ 21
+ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 17 (level, low) -> IRQ 22
 ath_pci: switching rfkill capability off
 ath_rate_sample: 1.2 (0.9.4)
 ath_pci: switching per-packet transmit power control off
@@ -555,29 +348,8 @@ wifi0: Use hw queue 2 for WME_AC_VI traf
 wifi0: Use hw queue 3 for WME_AC_VO traffic
 wifi0: Use hw queue 8 for CAB traffic
 wifi0: Use hw queue 9 for beacons
-wifi0: Atheros 5212: mem=0xf7fe0000, irq=21
-ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 22
+wifi0: Atheros 5212: mem=0xf7fe0000, irq=22
 EXT3 FS on md1, internal journal
-kjournald starting.  Commit interval 5 seconds
-EXT3 FS on md3, internal journal
-EXT3-fs: mounted filesystem with ordered data mode.
-kjournald starting.  Commit interval 5 seconds
-EXT3 FS on md4, internal journal
-EXT3-fs: mounted filesystem with ordered data mode.
-Adding 996020k swap on /dev/sdg2.  Priority:-1 extents:1 across:996020k
-Adding 996020k swap on /dev/sdh2.  Priority:-2 extents:1 across:996020k
-r8169: eth0: link up
-eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
-NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
-NFSD: starting 90-second grace period
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=137 DPT=137 LEN=76
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=221 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=138 DPT=138 LEN=201
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=137 DPT=137 LEN=76
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=137 DPT=137 LEN=76
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=221 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=138 DPT=138 LEN=201
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=221 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=138 DPT=138 LEN=201
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=137 DPT=137 LEN=76
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=248 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=138 DPT=138 LEN=228
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=239 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=138 DPT=138 LEN=219
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=248 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=138 DPT=138 LEN=228
-Shorewall:dmz2fw:reject:IN=ath0 OUT= MAC= SRC=10.3.123.1
DST=10.3.123.255 LEN=239 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP
SPT=138 DPT=138 LEN=219
+md: md4 stopped.
+md: bind<sdd1>
+md: bind<sdc1>
