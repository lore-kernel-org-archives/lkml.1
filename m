Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbXLGWyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbXLGWyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbXLGWyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:54:10 -0500
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:35284
	"EHLO QMTA02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067AbXLGWyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:54:06 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2007 17:54:05 EST
X-Authority-Analysis: v=1.0 c=1 a=0Pfyxz07QesA:10 a=AYO8yypLQsKQpaYcgEkA:9 a=r-vKLApgcS-ewRuMYPoA:7 a=AYsH0hMqpGUfNS1aopOkgiXW2-cA:4 a=qtLaBCzOg2kA:10
Message-ID: <4759CD65.3030208@comcast.net>
Date: Fri, 07 Dec 2007 17:47:01 -0500
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re:  x86_64 dynticks not working   prev: cpuidle, dynticks compatible
 or no? 
References: <4758DC68.4090303@comcast.net>
In-Reply-To: <4758DC68.4090303@comcast.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System is idle now, previously it was doing something i couldn't halt at 
the time.  
I'm looking at "Local timer interrupts" in the "Loc:" section of 
/proc/interrupts.
Across 1 second while the system is pretty much idle, i still get 300 
interrupts. My HZ variable is set to 300 in the kernel config, so this 
is expected but I was under the assumption that dynticks/tickless being 
compiled in would cause that to be much lower.

Am I reading the wrong section of /proc/interrupts  to verify if 
dynticks is working or not? Again, i see no difference in cpu temp at all.

In case it helps, this is an athlon64 x2 with apic functioning and both 
cores active in 64bit mode. dmesg is below. 

not related :
Some additional notes:  it87 is my lm_sensor, it doesn't work in this 
kernel, yet it did in 2.6.22.  Perhaps enabling high precision timers 
changed something in acpi land.

I enabled tcp dma offloading in this kernel, i get debugging output 
related to it, error is at the last line.  No corruption or otherwise 
bad behavior.   Transferring via cifs at 9.7MB/sec "incoming" took about 
15% of one cpu...  I never bothered to check if that is the norm but i 
suspect i'll be removing that feature as it seems to not play nice with 
the kernel.



 kernel: klogd 1.5.0#1, log source = /proc/kmsg started.
) (gcc version 4.2.3 20071123 (prerelease) (Debian 4.2.2-4)) #1 SMP 
PREEMPT Wed Dec 5 21:49:34 EST 2007
 kernel: Command line: root=/dev/sda1 ro console=tty0 libata.atapi_enabled=1
 kernel: BIOS-provided physical RAM map:
 kernel:  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 kernel:  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 kernel:  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 kernel:  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 kernel:  BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 kernel:  BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 kernel:  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 kernel:  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 kernel: end_pfn_map = 1048576
 kernel: DMI 2.3 present.
 kernel: ACPI: RSDP 000F7580, 0014 (r0 Nvidia)
 kernel: ACPI: RSDT 7FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 
AWRD        0)
 kernel: ACPI: FACP 7FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 
AWRD        0)
 kernel: ACPI: DSDT 7FFF3180, 65F2 (r1 NVIDIA AWRDACPI     1000 MSFT  
100000E)
 kernel: ACPI: FACS 7FFF0000, 0040
 kernel: ACPI: SSDT 7FFF9880, 0188 (r1 PTLTD  POWERNOW        1  
LTP        1)
 kernel: ACPI: MCFG 7FFF9A80, 003C (r1 Nvidia AWRDACPI 42302E31 
AWRD        0)
 kernel: ACPI: APIC 7FFF97C0, 007C (r1 Nvidia AWRDACPI 42302E31 
AWRD        0)
 kernel: Zone PFN ranges:
 kernel:   DMA             0 ->     4096
 kernel:   DMA32        4096 ->  1048576
 kernel:   Normal    1048576 ->  1048576
 kernel: Movable zone start PFN for each node
 kernel: early_node_map[2] active PFN ranges
 kernel:     0:        0 ->      159
 kernel:     0:      256 ->   524272
 kernel: Nvidia board detected. Ignoring ACPI timer override.
 kernel: If you got timer trouble try acpi_use_timer_override
 kernel: ACPI: PM-Timer IO Port: 0x4008
 kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
 kernel: Processor #0 (Bootup-CPU)
 kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
 kernel: Processor #1
 kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
 kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
 kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
 kernel: IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
 kernel: ACPI: BIOS IRQ0 pin2 override ignored.
 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
 kernel: Setting APIC routing to flat
 kernel: Using ACPI (MADT) for SMP configuration information
 kernel: Allocating PCI resources starting at 88000000 (gap: 
80000000:60000000)
 kernel: SMP: Allowing 2 CPUs, 0 hotplug CPUs
 kernel: PERCPU: Allocating 32696 bytes of per cpu data
 kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 515935
 kernel: Kernel command line: root=/dev/sda1 ro console=tty0 
libata.atapi_enabled=1
 kernel: Initializing CPU#0
 kernel: PID hash table entries: 4096 (order: 12, 32768 bytes)
 kernel: TSC calibrated against PM_TIMER
 kernel: Marking TSC unstable due to TSCs unsynchronized
 kernel: time.c: Detected 2010.305 MHz processor.
 kernel: Console: colour VGA+ 80x25
 kernel: console [tty0] enabled
 kernel: Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
 kernel: Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
 kernel: Checking aperture...
 kernel: CPU 0: aperture @ 8640000000 size 32 MB
 kernel: No AGP bridge found
 kernel: Memory: 2059736k/2097088k available (2695k kernel code, 36256k 
reserved, 1069k data, 204k init)
 kernel: SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, 
Nodes=1
 kernel: Calibrating delay using timer specific routine.. 4023.79 
BogoMIPS (lpj=6703675)
 kernel: Mount-cache hash table entries: 256
 kernel: CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
 kernel: CPU: L2 Cache: 512K (64 bytes/line)
 kernel: CPU: Physical Processor ID: 0
 kernel: CPU: Processor Core ID: 0
 kernel: SMP alternatives: switching to UP code
 kernel: ACPI: Core revision 20070126
 kernel: Using local APIC timer interrupts.
 kernel: Detected 12.564 MHz APIC timer.
 kernel: SMP alternatives: switching to SMP code
 kernel: Booting processor 1/2 APIC 0x1
 kernel: Initializing CPU#1
 kernel: Calibrating delay using timer specific routine.. 4022.15 
BogoMIPS (lpj=6701043)
 kernel: CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
 kernel: CPU: L2 Cache: 512K (64 bytes/line)
 kernel: CPU: Physical Processor ID: 0
 kernel: CPU: Processor Core ID: 1
 kernel: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
 kernel: Brought up 2 CPUs
 kernel: net_namespace: 176 bytes
 kernel: NET: Registered protocol family 16
 kernel: ACPI: bus type pci registered
 kernel: PCI: Using configuration type 1
 kernel: ACPI: Interpreter enabled
 kernel: ACPI: (supports S0 S5)
 kernel: ACPI: Using IOAPIC for interrupt routing
 kernel: PCI: MCFG configuration 0: base 3758096384 segment 0 buses 0 - 255
 kernel: PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
 kernel: PCI: Using MMCONFIG at e0000000 - efffffff
 kernel: PCI: No mmconfig possible on device 00:18
 kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
 kernel: PCI: Transparent bridge - 0000:00:09.0
 kernel: ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 7 9 *10 11 12 14 15)
 kernel: ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 *7 9 10 11 12 14 15)
 kernel: ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 *5 7 9 10 11 12 14 15)
 kernel: ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
 kernel: ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) 
*0, disabled.
 kernel: ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
 kernel: ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
 kernel: ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
 kernel: ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
 kernel: ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
 kernel: ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
 kernel: ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
 kernel: ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
 kernel: ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
 kernel: ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
 kernel: ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
 kernel: ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
 kernel: ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
 kernel: ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
 kernel: ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
 kernel: ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
 kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
 kernel: pnp: PnP ACPI init
 kernel: ACPI: bus type pnp registered
 kernel: pnp: PnP ACPI: found 9 devices
 kernel: ACPI: ACPI bus type pnp unregistered
 kernel: SCSI subsystem initialized
 kernel: usbcore: registered new interface driver usbfs
 kernel: usbcore: registered new interface driver hub
 kernel: usbcore: registered new device driver usb
 kernel: PCI: Using ACPI for IRQ routing
 kernel: PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
 kernel: ACPI: RTC can wake from S4
 kernel: system 00:01: ioport range 0x4000-0x407f has been reserved
 kernel: system 00:01: ioport range 0x4080-0x40ff has been reserved
 kernel: system 00:01: ioport range 0x4400-0x447f has been reserved
 kernel: system 00:01: ioport range 0x4480-0x44ff has been reserved
 kernel: system 00:01: ioport range 0x4800-0x487f has been reserved
 kernel: system 00:01: ioport range 0x4880-0x48ff has been reserved
 kernel: system 00:02: ioport range 0x4d0-0x4d1 has been reserved
 kernel: system 00:02: ioport range 0x800-0x87f has been reserved
 kernel: system 00:02: ioport range 0x290-0x297 has been reserved
 kernel: system 00:07: iomem range 0xe0000000-0xefffffff could not be 
reserved
 kernel: system 00:08: iomem range 0xf0000-0xf3fff could not be reserved
 kernel: system 00:08: iomem range 0xf4000-0xf7fff could not be reserved
 kernel: system 00:08: iomem range 0xf8000-0xfbfff could not be reserved
 kernel: system 00:08: iomem range 0xfc000-0xfffff could not be reserved
 kernel: system 00:08: iomem range 0x7fff0000-0x7fffffff could not be 
reserved
 kernel: system 00:08: iomem range 0xffff0000-0xffffffff has been reserved
 kernel: system 00:08: iomem range 0x0-0x9ffff could not be reserved
 kernel: system 00:08: iomem range 0x100000-0x7ffeffff could not be reserved
 kernel: system 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
 kernel: system 00:08: iomem range 0xfee00000-0xfeefffff could not be 
reserved
 kernel: system 00:08: iomem range 0xfefff000-0xfeffffff has been reserved
 kernel: system 00:08: iomem range 0xfff80000-0xfff80fff has been reserved
 kernel: PCI: Bridge: 0000:00:09.0
 kernel:   IO window: disabled.
 kernel:   MEM window: disabled.
 kernel:   PREFETCH window: c8000000-c80fffff
 kernel: PCI: Bridge: 0000:00:0b.0
 kernel:   IO window: disabled.
 kernel:   MEM window: disabled.
 kernel:   PREFETCH window: disabled.
 kernel: PCI: Bridge: 0000:00:0c.0
 kernel:   IO window: disabled.
 kernel:   MEM window: disabled.
 kernel:   PREFETCH window: disabled.
 kernel: PCI: Bridge: 0000:00:0d.0
 kernel:   IO window: disabled.
 kernel:   MEM window: disabled.
 kernel:   PREFETCH window: disabled.
 kernel: PCI: Bridge: 0000:00:0e.0
 kernel:   IO window: disabled.
 kernel:   MEM window: c0000000-c7ffffff
 kernel:   PREFETCH window: b0000000-bfffffff
 kernel: NET: Registered protocol family 2
 kernel: Time: acpi_pm clocksource has been installed.
 kernel: IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
 kernel: TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
 kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
 kernel: TCP: Hash tables configured (established 262144 bind 65536)
 kernel: TCP reno registered
 kernel: fuse init (API version 7.9)
 kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
 kernel: io scheduler noop registered
 kernel: io scheduler cfq registered (default)
 kernel: PCI: Found disabled HT MSI Mapping on 0000:00:0b.0
 kernel: PCI: Found enabled HT MSI Mapping on 0000:00:00.0
 kernel: PCI: Linking AER extended capability on 0000:00:0b.0
 kernel: PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
 kernel: PCI: Found enabled HT MSI Mapping on 0000:00:00.0
 kernel: PCI: Linking AER extended capability on 0000:00:0c.0
 kernel: PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
 kernel: PCI: Found enabled HT MSI Mapping on 0000:00:00.0
 kernel: PCI: Linking AER extended capability on 0000:00:0d.0
 kernel: PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
 kernel: PCI: Found enabled HT MSI Mapping on 0000:00:00.0
 kernel: PCI: Linking AER extended capability on 0000:00:0e.0
 kernel: assign_interrupt_mode Found MSI capability
 last message repeated 3 times
 kernel: ACPI: Thermal Zone [THRM] (40 C)
 kernel: Real Time Clock Driver v1.12ac
 kernel: Linux agpgart interface v0.103
 kernel: forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
 kernel: ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
 kernel: ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 
(level, low) -> IRQ 23
 kernel: forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, addr 
00:13:d4:d4:66:e8
 kernel: forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
 kernel: ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
 kernel: ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 22 
(level, low) -> IRQ 22
 kernel: sata_nv 0000:00:08.0: Using ADMA mode
 kernel: scsi0 : sata_nv
 kernel: scsi1 : sata_nv
 kernel: ata1: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xd400 irq 22
 kernel: ata2: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xd408 irq 22
 kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 kernel: ata1.00: ATA-7: Maxtor 6L200S0, BACE1G10, max UDMA/133
 kernel: ata1.00: 398297088 sectors, multi 1: LBA48 NCQ (depth 31/32)
 kernel: ata1.00: configured for UDMA/133
 kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 kernel: ata2.00: ATA-7: Maxtor 6L200S0, BACE1G10, max UDMA/133
 kernel: ata2.00: 398297088 sectors, multi 1: LBA48 NCQ (depth 31/32)
 kernel: ata2.00: configured for UDMA/133
 kernel: scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L200S0   BACE 
PQ: 0 ANSI: 5
 kernel: ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 
0xFFFFFFFF, hw segs 61
 kernel: sd 0:0:0:0: [sda] 398297088 512-byte hardware sectors (203928 MB)
 kernel: sd 0:0:0:0: [sda] Write Protect is off
 kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
 kernel: sd 0:0:0:0: [sda] 398297088 512-byte hardware sectors (203928 MB)
 kernel: sd 0:0:0:0: [sda] Write Protect is off
 kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
 kernel:  sda: sda1 sda2
 kernel: sd 0:0:0:0: [sda] Attached SCSI disk
 kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
 kernel: scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6L200S0   BACE 
PQ: 0 ANSI: 5
 kernel: ata2: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 
0xFFFFFFFF, hw segs 61
 kernel: sd 1:0:0:0: [sdb] 398297088 512-byte hardware sectors (203928 MB)
 kernel: sd 1:0:0:0: [sdb] Write Protect is off
 kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
 kernel: sd 1:0:0:0: [sdb] 398297088 512-byte hardware sectors (203928 MB)
 kernel: sd 1:0:0:0: [sdb] Write Protect is off
 kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
 kernel:  sdb: sdb1 sdb2
 kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
 kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
 kernel: scsi2 : pata_amd
 kernel: scsi3 : pata_amd
 kernel: ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
 kernel: ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
 kernel: ata3.00: ATA-7: Maxtor 6Y120P0, YAR41VW0, max UDMA/133
 kernel: ata3.00: 240121728 sectors, multi 1: LBA
 kernel: ata3.00: configured for UDMA/133
 kernel: ata4.00: ATAPI: PLEXTOR DVDR   PX-712A, 1.09, max MWDMA2
 kernel: ata4.00: configured for MWDMA2
 kernel: scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6Y120P0   YAR4 
PQ: 0 ANSI: 5
 kernel: sd 2:0:0:0: [sdc] 240121728 512-byte hardware sectors (122942 MB)
 kernel: sd 2:0:0:0: [sdc] Write Protect is off
 kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
 kernel: sd 2:0:0:0: [sdc] 240121728 512-byte hardware sectors (122942 MB)
 kernel: sd 2:0:0:0: [sdc] Write Protect is off
 kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
 kernel:  sdc: sdc1
 kernel: sd 2:0:0:0: [sdc] Attached SCSI disk
 kernel: sd 2:0:0:0: Attached scsi generic sg2 type 0
 kernel: scsi 3:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-712A   1.09 
PQ: 0 ANSI: 5
 kernel: sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
 kernel: Uniform CD-ROM driver Revision: 3.20
 kernel: sr 3:0:0:0: Attached scsi generic sg3 type 5
 kernel: ACPI: PCI Interrupt Link [APCL] enabled at IRQ 21
 kernel: ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 21 
(level, low) -> IRQ 21
 kernel: ehci_hcd 0000:00:02.1: EHCI Host Controller
 kernel: ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus 
number 1
 kernel: ehci_hcd 0000:00:02.1: debug port 1
 kernel: ehci_hcd 0000:00:02.1: irq 21, io mem 0xfeb00000
 kernel: ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 
Dec 2004
 kernel: usb usb1: configuration #1 chosen from 1 choice
 kernel: hub 1-0:1.0: USB hub found
 kernel: hub 1-0:1.0: 10 ports detected
 kernel: ACPI: PCI Interrupt Link [APCF] enabled at IRQ 20
 kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 20 
(level, low) -> IRQ 20
 kernel: ohci_hcd 0000:00:02.0: OHCI Host Controller
 kernel: ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus 
number 2
 kernel: ohci_hcd 0000:00:02.0: irq 20, io mem 0xc8103000
 kernel: usb usb2: configuration #1 chosen from 1 choice
 kernel: hub 2-0:1.0: USB hub found
 kernel: hub 2-0:1.0: 10 ports detected
 kernel: PNP: No PS/2 controller found. Probing ports directly.
 kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
 kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
 kernel: mice: PS/2 mouse device common for all mice
 kernel: rtc_cmos: probe of 00:04 failed with error -16
 kernel: Software Watchdog Timer: 0.07 initialized. soft_noboot=0 
soft_margin=60 sec (nowayout= 0)
 kernel: md: raid0 personality registered for level 0
 kernel: cpuidle: using governor ladder
 kernel: cpuidle: using governor menu
 kernel: usb 2-2: new low speed USB device using ohci_hcd and address 2
 kernel: usb 2-2: configuration #1 chosen from 1 choice
 kernel: usb 2-4: new low speed USB device using ohci_hcd and address 3
 kernel: usb 2-4: configuration #1 chosen from 1 choice
 kernel: input: Logitech Optical USB Mouse as 
/devices/pci0000:00/0000:00:02.0/usb2/2-2/2-2:1.0/input/input0
 kernel: input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on 
usb-0000:00:02.0-2
 kernel: input: HID 1267:0103 as 
/devices/pci0000:00/0000:00:02.0/usb2/2-4/2-4:1.0/input/input1
 kernel: input: USB HID v1.10 Keyboard [HID 1267:0103] on usb-0000:00:02.0-4
 kernel: input: HID 1267:0103 as 
/devices/pci0000:00/0000:00:02.0/usb2/2-4/2-4:1.1/input/input2
 kernel: input: USB HID v1.10 Device [HID 1267:0103] on usb-0000:00:02.0-4
 kernel: usbcore: registered new interface driver usbhid
 kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
 kernel: Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue 
Nov 20 19:16:42 2007 UTC).
 kernel: ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 23
 kernel: ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 23 
(level, low) -> IRQ 23
 kernel: intel8x0_measure_ac97_clock: measured 49914 usecs
 kernel: intel8x0: clocking to 46825
 kernel: ALSA device list:
 kernel:   #0: NVidia CK804 with ALC850 at irq 23
 kernel: TCP cubic registered
 kernel: powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
3800+ processors (2 cpu cores) (version 2.20.00)
 kernel: powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
 kernel: powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
 kernel: powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
 kernel: drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
 kernel: md: Autodetecting RAID arrays.
 kernel: md: Scanned 2 and added 2 devices.
 kernel: md: autorun ...
 kernel: md: considering sdb2 ...
 kernel: md:  adding sdb2 ...
 kernel: md:  adding sda2 ...
 kernel: md: created md0
 kernel: md: bind<sda2>
 kernel: md: bind<sdb2>
 kernel: md: running: <sdb2><sda2>
 kernel: md0: setting max_sectors to 128, segment boundary to 32767
 kernel: raid0: looking at sdb2
 kernel: raid0:   comparing sdb2(195237824) with sdb2(195237824)
 kernel: raid0:   END
 kernel: raid0:   ==> UNIQUE
 kernel: raid0: 1 zones
 kernel: raid0: looking at sda2
 kernel: raid0:   comparing sda2(195237824) with sdb2(195237824)
 kernel: raid0:   EQUAL
 kernel: raid0: FINAL 1 zones
 kernel: raid0: done.
 kernel: raid0 : md_size is 390475648 blocks.
 kernel: raid0 : conf->hash_spacing is 390475648 blocks.
 kernel: raid0 : nb_zone is 1.
 kernel: raid0 : Allocating 8 bytes for hash.
 kernel: md: ... autorun DONE.
 kernel: kjournald starting.  Commit interval 5 seconds
 kernel: EXT3-fs: mounted filesystem with ordered data mode.
 kernel: VFS: Mounted root (ext3 filesystem) readonly.
 kernel: Freeing unused kernel memory: 204k freed
 kernel: NET: Registered protocol family 1
 kernel: i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
 kernel: i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
 kernel: EXT3 FS on sda1, internal journal
 kernel: it87: Found IT8712F chip at 0x290, revision 7
 kernel: it87: in3 is VCC (+5V)
 kernel: it87: in7 is VCCH (+5V Stand-By)
 kernel: ACPI: Device needs an ACPI driver
 kernel: kjournald starting.  Commit interval 5 seconds
 kernel: EXT3 FS on sdb1, internal journal
 kernel: EXT3-fs: mounted filesystem with ordered data mode.
 kernel: kjournald starting.  Commit interval 5 seconds
 kernel: EXT3 FS on md0, internal journal
 kernel: EXT3-fs: mounted filesystem with ordered data mode.
 kernel: kjournald starting.  Commit interval 5 seconds
 kernel: EXT3-fs warning: maximal mount count reached, running e2fsck is 
recommended
 kernel: EXT3 FS on sdc1, internal journal
 kernel: EXT3-fs: mounted filesystem with ordered data mode.
 kernel: eth0: no link during initialization.
 kernel: eth0: link up.
 lpd[3227]: restarted
 kernel: warning: `ntpd' uses 32-bit capabilities (legacy support in use)
 kernel: Clocksource tsc unstable (delta = -76657464 ns)
 kernel: warning: process `nvidia-installe' used the deprecated sysctl 
system call with 1.23.
 kernel: warning: process `nvidia-installe' used the deprecated sysctl 
system call with 1.23.
 kernel: nvidia: module license 'NVIDIA' taints kernel.
 kernel: ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
 kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [APC3] -> GSI 18 
(level, low) -> IRQ 18
 kernel: NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.19  Wed 
Sep 12 14:08:38 PDT 2007
 kernel: warning: process `nvidia-installe' used the deprecated sysctl 
system call with 1.23.
 kernel: WARNING: at net/ipv4/tcp_input.c:2518 tcp_fastretrans_alert()

