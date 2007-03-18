Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbXCRKKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbXCRKKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 06:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbXCRKKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 06:10:03 -0400
Received: from tag.witbe.net ([81.88.96.48]:35410 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbXCRKJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 06:09:59 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Sun, 18 Mar 2007 11:09:19 +0100
Organization: AS2917.net
Message-ID: <00e001c76945$7f2157e0$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <45FCC575.4080902@gmail.com>
Thread-Index: AcdpGT/eCB+LqvMYSL6vcXK35/688wAKw9Gw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Can you put the harddisk under high load and see what happens?  How
> often do those errors occur?  Care to post full dmesg?

I started again a stock 2.6.21-rc4, and ran that :
while (/bin/true); do tar jxf linux-2.6.19.1.tar.bz2; rm -rf linux-2.6.19.1;
echo -n "."; done      

After several minutes (I waited more than 300 loops to be completed), and
a lot of errors, I finally managed to see :
Mar 18 10:32:47 riri kernel: ata1.00: NCQ disabled due to excessive errors

/var/log/messages contains :
Mar 18 10:15:04 riri syslogd 1.4.1#17ubuntu7: restart.
Mar 18 10:15:04 riri kernel: Inspecting /boot/System.map-2.6.21-rc4
Mar 18 10:15:04 riri kernel: Loaded 39327 symbols from
/boot/System.map-2.6.21-rc4.
Mar 18 10:15:04 riri kernel: Symbols match kernel version 2.6.21.
Mar 18 10:15:04 riri kernel: No module symbols loaded - kernel modules not
enabled. 
Mar 18 10:15:04 riri kernel: Linux version 2.6.21-rc4 (root@riri.as2917.net)
(gcc version 4.0.3 (Ubuntu 4.0.3-1ubuntu5)) #1 SMP PREEMPT Sat Mar 17 18:50:10
CET 2007
Mar 18 10:15:04 riri kernel: Command line: root=/dev/sde1 ro ata2=noprobe
console=ttyS0,9600 console=tty0 vga=extended irqpoll
Mar 18 10:15:04 riri kernel: BIOS-provided physical RAM map:
Mar 18 10:15:04 riri kernel:  BIOS-e820: 0000000000000000 - 000000000009fc00
(usable)
Mar 18 10:15:04 riri kernel:  BIOS-e820: 000000000009fc00 - 00000000000a0000
(reserved)
Mar 18 10:15:04 riri kernel:  BIOS-e820: 00000000000e4000 - 0000000000100000
(reserved)
Mar 18 10:15:04 riri kernel:  BIOS-e820: 0000000000100000 - 00000000c7f80000
(usable)
Mar 18 10:15:04 riri kernel:  BIOS-e820: 00000000c7f80000 - 00000000c7f8e000
(ACPI data)
Mar 18 10:15:04 riri kernel:  BIOS-e820: 00000000c7f8e000 - 00000000c7fe0000
(ACPI NVS)
Mar 18 10:15:04 riri kernel:  BIOS-e820: 00000000c7fe0000 - 00000000c8000000
(reserved)
Mar 18 10:15:04 riri kernel:  BIOS-e820: 00000000ffb00000 - 0000000100000000
(reserved)
Mar 18 10:15:04 riri kernel: end_pfn_map = 1048576
Mar 18 10:15:04 riri kernel: DMI 2.4 present.
Mar 18 10:15:04 riri kernel: ACPI: RSDP 000FAF20, 0024 (r2 ACPIAM)
Mar 18 10:15:04 riri kernel: ACPI: XSDT C7F80100, 005C (r1 A_M_I_ OEMXSDT
12000608 MSFT       97)
Mar 18 10:15:04 riri kernel: ACPI: FACP C7F80290, 00F4 (r3 A_M_I_ OEMFACP
12000608 MSFT       97)
Mar 18 10:15:04 riri kernel: ACPI: DSDT C7F80410, 8FC4 (r1  A0543 A0543000
0 INTL 20060113)
Mar 18 10:15:04 riri kernel: ACPI: FACS C7F8E000, 0040
Mar 18 10:15:04 riri kernel: ACPI: APIC C7F80390, 0080 (r1 A_M_I_ OEMAPIC
12000608 MSFT       97)
Mar 18 10:15:04 riri kernel: ACPI: OEMB C7F8E040, 0066 (r1 A_M_I_ AMI_OEM
12000608 MSFT       97)
Mar 18 10:15:04 riri kernel: ACPI: HPET C7F893E0, 0038 (r1 A_M_I_ OEMHPET
12000608 MSFT       97)
Mar 18 10:15:04 riri kernel: ACPI: MCFG C7F89420, 003C (r1 A_M_I_ OEMMCFG
12000608 MSFT       97)
Mar 18 10:15:04 riri kernel: ACPI: SSDT C7F8E0B0, 01C6 (r1    AMI   CPU1PM
1 INTL 20060113)
Mar 18 10:15:04 riri kernel: ACPI: SSDT C7F8E280, 013A (r1    AMI   CPU2PM
1 INTL 20060113)
Mar 18 10:15:04 riri kernel: Zone PFN ranges:
Mar 18 10:15:04 riri kernel:   DMA             0 ->     4096
Mar 18 10:15:04 riri kernel:   DMA32        4096 ->  1048576
Mar 18 10:15:04 riri kernel:   Normal    1048576 ->  1048576
Mar 18 10:15:04 riri kernel: early_node_map[2] active PFN ranges
Mar 18 10:15:04 riri kernel:     0:        0 ->      159
Mar 18 10:15:04 riri kernel:     0:      256 ->   819072
Mar 18 10:15:04 riri kernel: ACPI: PM-Timer IO Port: 0x808
Mar 18 10:15:04 riri kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00]
enabled)
Mar 18 10:15:04 riri kernel: Processor #0 (Bootup-CPU)
Mar 18 10:15:04 riri kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01]
enabled)
Mar 18 10:15:04 riri kernel: Processor #1
Mar 18 10:15:04 riri kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82]
disabled)
Mar 18 10:15:04 riri kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83]
disabled)
Mar 18 10:15:04 riri kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000]
gsi_base[0])
Mar 18 10:15:04 riri kernel: IOAPIC[0]: apic_id 2, address 0xfec00000, GSI
0-23
Mar 18 10:15:04 riri kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2
dfl dfl)
Mar 18 10:15:04 riri kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9
high level)
Mar 18 10:15:04 riri kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2
dfl dfl)
Mar 18 10:15:04 riri kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9
high level)
Mar 18 10:15:04 riri kernel: Setting APIC routing to flat
Mar 18 10:15:04 riri kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Mar 18 10:15:04 riri kernel: Using ACPI (MADT) for SMP configuration
information
Mar 18 10:15:04 riri kernel: Nosave address range: 000000000009f000 -
00000000000a0000
Mar 18 10:15:04 riri kernel: Nosave address range: 00000000000a0000 -
00000000000e4000
Mar 18 10:15:04 riri kernel: Nosave address range: 00000000000e4000 -
0000000000100000
Mar 18 10:15:04 riri kernel: Allocating PCI resources starting at cc000000
(gap: c8000000:37b00000)
Mar 18 10:15:04 riri kernel: PERCPU: Allocating 34368 bytes of per cpu data
Mar 18 10:15:04 riri kernel: Built 1 zonelists.  Total pages: 805789
Mar 18 10:15:04 riri kernel: Kernel command line: root=/dev/sde1 ro
ata2=noprobe console=ttyS0,9600 console=tty0 vga=extended irqpoll
Mar 18 10:15:04 riri kernel: Misrouted IRQ fixup and polling support enabled
Mar 18 10:15:04 riri kernel: This may significantly impact system performance
Mar 18 10:15:04 riri kernel: Initializing CPU#0
Mar 18 10:15:04 riri kernel: PID hash table entries: 4096 (order: 12, 32768
bytes)
Mar 18 10:15:04 riri kernel: time.c: Detected 2400.081 MHz processor.
Mar 18 10:15:04 riri kernel: Console: colour VGA+ 80x50
Mar 18 10:15:04 riri kernel: Dentry cache hash table entries: 524288 (order:
10, 4194304 bytes)
Mar 18 10:15:04 riri kernel: Inode-cache hash table entries: 262144 (order: 9,
2097152 bytes)
Mar 18 10:15:04 riri kernel: Checking aperture...
Mar 18 10:15:04 riri kernel: Memory: 3216492k/3276288k available (4569k kernel
code, 59180k reserved, 2320k data, 296k init)
Mar 18 10:15:04 riri kernel: Calibrating delay using timer specific routine..
4817.93 BogoMIPS (lpj=2408969)
Mar 18 10:15:04 riri kernel: Security Framework v1.0.0 initialized
Mar 18 10:15:04 riri kernel: Capability LSM initialized
Mar 18 10:15:04 riri kernel: Failure registering Root Plug module with the
kernel
Mar 18 10:15:04 riri kernel: Failure registering Root Plug  module with
primary security module.
Mar 18 10:15:04 riri kernel: Mount-cache hash table entries: 256
Mar 18 10:15:04 riri kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar 18 10:15:04 riri kernel: CPU: L2 cache: 4096K
Mar 18 10:15:04 riri kernel: using mwait in idle threads.
Mar 18 10:15:04 riri kernel: CPU: Physical Processor ID: 0
Mar 18 10:15:04 riri kernel: CPU: Processor Core ID: 0
Mar 18 10:15:04 riri kernel: CPU0: Thermal monitoring enabled (TM2)
Mar 18 10:15:04 riri kernel: Freeing SMP alternatives: 40k freed
Mar 18 10:15:04 riri kernel: ACPI: Core revision 20070126
Mar 18 10:15:04 riri kernel: Using local APIC timer interrupts.
Mar 18 10:15:04 riri kernel: result 16667212
Mar 18 10:15:04 riri kernel: Detected 16.667 MHz APIC timer.
Mar 18 10:15:04 riri kernel: Booting processor 1/2 APIC 0x1
Mar 18 10:15:04 riri kernel: Initializing CPU#1
Mar 18 10:15:04 riri kernel: Calibrating delay using timer specific routine..
4800.10 BogoMIPS (lpj=2400050)
Mar 18 10:15:04 riri kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Mar 18 10:15:04 riri kernel: CPU: L2 cache: 4096K
Mar 18 10:15:04 riri kernel: CPU: Physical Processor ID: 0
Mar 18 10:15:04 riri kernel: CPU: Processor Core ID: 1
Mar 18 10:15:04 riri kernel: CPU1: Thermal monitoring enabled (TM2)
Mar 18 10:15:04 riri kernel: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
stepping 06
Mar 18 10:15:04 riri kernel: checking TSC synchronization [CPU#0 -> CPU#1]:
passed.
Mar 18 10:15:04 riri kernel: Brought up 2 CPUs
Mar 18 10:15:04 riri kernel: migration_cost=26
Mar 18 10:15:04 riri kernel: NET: Registered protocol family 16
Mar 18 10:15:04 riri kernel: ACPI: bus type pci registered
Mar 18 10:15:04 riri kernel: PCI: Using configuration type 1
Mar 18 10:15:04 riri kernel: ACPI: Interpreter enabled
Mar 18 10:15:04 riri kernel: ACPI: Using IOAPIC for interrupt routing
Mar 18 10:15:04 riri kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Mar 18 10:15:04 riri kernel: PCI quirk: region 0800-087f claimed by ICH6
ACPI/GPIO/TCO
Mar 18 10:15:04 riri kernel: PCI quirk: region 0480-04bf claimed by ICH6 GPIO
Mar 18 10:15:04 riri kernel: 0000:00:1f.1: trying to change BAR0 from 0000 to
01F0
Mar 18 10:15:04 riri kernel: 0000:00:1f.1: trying to change BAR1 from 0000 to
03F4
Mar 18 10:15:04 riri kernel: 0000:00:1f.1: trying to change BAR2 from 0000 to
0170
Mar 18 10:15:04 riri kernel: 0000:00:1f.1: trying to change BAR3 from 0000 to
0374
Mar 18 10:15:04 riri kernel: PCI: Transparent bridge - 0000:00:1e.0
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7
10 *11 12 14 15)
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7
*10 11 12 14 15)
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7
10 11 12 14 15)
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7
10 11 12 14 15)
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7
10 11 12 14 15)
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7
10 11 12 14 15)
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7
10 *11 12 14 15)
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7
*10 11 12 14 15)
Mar 18 10:15:04 riri kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
Mar 18 10:15:04 riri kernel: pnp: PnP ACPI init
Mar 18 10:15:04 riri kernel: pnp: PnP ACPI: found 16 devices
Mar 18 10:15:04 riri kernel: SCSI subsystem initialized
Mar 18 10:15:04 riri kernel: usbcore: registered new interface driver usbfs
Mar 18 10:15:04 riri kernel: usbcore: registered new interface driver hub
Mar 18 10:15:04 riri kernel: usbcore: registered new device driver usb
Mar 18 10:15:04 riri kernel: PCI: Using ACPI for IRQ routing
Mar 18 10:15:04 riri kernel: PCI: If a device doesn't work, try
"pci=routeirq".  If it helps, post a report
Mar 18 10:15:04 riri kernel: PCI-GART: No AMD northbridge found.
Mar 18 10:15:04 riri kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Mar 18 10:15:04 riri kernel: hpet0: 3 64-bit timers, 14318180 Hz
Mar 18 10:15:04 riri kernel: pnp: 00:01: iomem range 0xfed13000-0xfed19fff has
been reserved
Mar 18 10:15:04 riri kernel: Time: tsc clocksource has been installed.
Mar 18 10:15:04 riri kernel: pnp: 00:07: ioport range 0x290-0x297 has been
reserved
Mar 18 10:15:04 riri kernel: pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has
been reserved
Mar 18 10:15:04 riri kernel: pnp: 00:08: iomem range 0xfed20000-0xfed3ffff has
been reserved
Mar 18 10:15:04 riri kernel: pnp: 00:08: iomem range 0xfed50000-0xfed8ffff has
been reserved
Mar 18 10:15:04 riri kernel: pnp: 00:08: iomem range 0xffb00000-0xffbfffff has
been reserved
Mar 18 10:15:04 riri kernel: pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has
been reserved
Mar 18 10:15:04 riri kernel: pnp: 00:0c: iomem range 0xfee00000-0xfee00fff has
been reserved
Mar 18 10:15:04 riri kernel: pnp: 00:0e: iomem range 0xf0000000-0xf3ffffff has
been reserved
Mar 18 10:15:04 riri kernel: pnp: 00:0f: iomem range 0x0-0x9ffff could not be
reserved
Mar 18 10:15:04 riri kernel: pnp: 00:0f: iomem range 0xc0000-0xdffff has been
reserved
Mar 18 10:15:04 riri kernel: pnp: 00:0f: iomem range 0xe0000-0xfffff could not
be reserved
Mar 18 10:15:04 riri kernel: pnp: 00:0f: iomem range 0x100000-0xc7ffffff could
not be reserved
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 21
(level, low) -> IRQ 21
Mar 18 10:15:04 riri kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]
MMIO=[ff5ef800-ff5effff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Mar 18 10:15:04 riri kernel: PCI: Bridge: 0000:00:01.0
Mar 18 10:15:04 riri kernel:   IO window: c000-cfff
Mar 18 10:15:04 riri kernel:   MEM window: ff900000-ff9fffff
Mar 18 10:15:04 riri kernel:   PREFETCH window: cff00000-efefffff
Mar 18 10:15:04 riri kernel: PCI: Bridge: 0000:00:1c.0
Mar 18 10:15:04 riri kernel:   IO window: disabled.
Mar 18 10:15:04 riri kernel:   MEM window: disabled.
Mar 18 10:15:04 riri kernel:   PREFETCH window: cfe00000-cfefffff
Mar 18 10:15:04 riri kernel: PCI: Bridge: 0000:00:1c.3
Mar 18 10:15:04 riri kernel:   IO window: b000-bfff
Mar 18 10:15:04 riri kernel:   MEM window: ff800000-ff8fffff
Mar 18 10:15:04 riri kernel:   PREFETCH window: disabled.
Mar 18 10:15:04 riri kernel: PCI: Bridge: 0000:00:1c.4
Mar 18 10:15:04 riri kernel:   IO window: a000-afff
Mar 18 10:15:04 riri kernel:   MEM window: ff700000-ff7fffff
Mar 18 10:15:04 riri kernel:   PREFETCH window: disabled.
Mar 18 10:15:04 riri kernel: PCI: Bridge: 0000:00:1c.5
Mar 18 10:15:04 riri kernel:   IO window: 9000-9fff
Mar 18 10:15:04 riri kernel:   MEM window: ff600000-ff6fffff
Mar 18 10:15:04 riri kernel:   PREFETCH window: disabled.
Mar 18 10:15:04 riri kernel: PCI: Bridge: 0000:00:1e.0
Mar 18 10:15:04 riri kernel:   IO window: 8000-8fff
Mar 18 10:15:04 riri kernel:   MEM window: ff500000-ff5fffff
Mar 18 10:15:04 riri kernel:   PREFETCH window: disabled.
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16
(level, low) -> IRQ 16
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16
(level, low) -> IRQ 16
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19
(level, low) -> IRQ 19
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16
(level, low) -> IRQ 16
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17
(level, low) -> IRQ 17
Mar 18 10:15:04 riri kernel: NET: Registered protocol family 2
Mar 18 10:15:04 riri kernel: IP route cache hash table entries: 131072 (order:
8, 1048576 bytes)
Mar 18 10:15:04 riri kernel: TCP established hash table entries: 131072
(order: 9, 3145728 bytes)
Mar 18 10:15:04 riri kernel: TCP bind hash table entries: 65536 (order: 8,
1048576 bytes)
Mar 18 10:15:04 riri kernel: TCP: Hash tables configured (established 131072
bind 65536)
Mar 18 10:15:04 riri kernel: TCP reno registered
Mar 18 10:15:04 riri kernel: IA-32 Microcode Update Driver: v1.14a
<tigran@aivazian.fsnet.co.uk>
Mar 18 10:15:04 riri kernel: VFS: Disk quotas dquot_6.5.1
Mar 18 10:15:04 riri kernel: Dquot-cache hash table entries: 512 (order 0,
4096 bytes)
Mar 18 10:15:04 riri kernel: NTFS driver 2.1.28 [Flags: R/W].
Mar 18 10:15:04 riri kernel: fuse init (API version 7.8)
Mar 18 10:15:04 riri kernel: io scheduler noop registered
Mar 18 10:15:04 riri kernel: io scheduler anticipatory registered (default)
Mar 18 10:15:04 riri kernel: io scheduler deadline registered
Mar 18 10:15:04 riri kernel: io scheduler cfq registered
Mar 18 10:15:04 riri kernel: assign_interrupt_mode Found MSI capability
Mar 18 10:15:04 riri last message repeated 4 times
Mar 18 10:15:04 riri kernel: input: Power Button (FF) as /class/input/input0
Mar 18 10:15:04 riri kernel: ACPI: Power Button (FF) [PWRF]
Mar 18 10:15:04 riri kernel: input: Power Button (CM) as /class/input/input1
Mar 18 10:15:04 riri kernel: ACPI: Power Button (CM) [PWRB]
Mar 18 10:15:04 riri kernel: ACPI Warning (tbutils-0158): Incorrect checksum
in table [OEMB] -  78, should be 6F [20070126]
Mar 18 10:15:04 riri kernel: ACPI Error (psparse-0537): Method parse/execution
failed [\_PR_.CPU1._OSC] (Node ffff81000424cb30), AE_ALREADY_EXISTS
Mar 18 10:15:04 riri kernel: ACPI: Marking method _OSC as Serialized
Mar 18 10:15:04 riri kernel: ACPI Error (psparse-0537): Method parse/execution
failed [\_PR_.CPU1._PDC] (Node ffff81000424cb50), AE_ALREADY_EXISTS
Mar 18 10:15:04 riri kernel: ACPI: Marking method _PDC as Serialized
Mar 18 10:15:04 riri kernel: ACPI: Processor [CPU1] (supports 8 throttling
states)
Mar 18 10:15:04 riri kernel: ACPI Error (psparse-0537): Method parse/execution
failed [\_PR_.CPU2._OSC] (Node ffff81000424ca10), AE_ALREADY_EXISTS
Mar 18 10:15:04 riri kernel: ACPI: Marking method _OSC as Serialized
Mar 18 10:15:04 riri kernel: ACPI Error (psparse-0537): Method parse/execution
failed [\_PR_.CPU2._PDC] (Node ffff81000424ca30), AE_ALREADY_EXISTS
Mar 18 10:15:04 riri kernel: ACPI: Marking method _PDC as Serialized
Mar 18 10:15:04 riri kernel: ACPI: Processor [CPU2] (supports 8 throttling
states)
Mar 18 10:15:04 riri kernel: Real Time Clock Driver v1.12ac
Mar 18 10:15:04 riri kernel: Non-volatile memory driver v1.2
Mar 18 10:15:04 riri kernel: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01
(21-Jan-2007)
Mar 18 10:15:04 riri kernel: iTCO_wdt: Found a ICH7 or ICH7R TCO device
(Version=2, TCOBASE=0x0860)
Mar 18 10:15:04 riri kernel: iTCO_wdt: initialized. heartbeat=30 sec
(nowayout=0)
Mar 18 10:15:04 riri kernel: iTCO_vendor_support: vendor-support=0
Mar 18 10:15:04 riri kernel: Linux agpgart interface v0.102 (c) Dave Jones
Mar 18 10:15:04 riri kernel: [drm] Initialized drm 1.1.0 20060810
Mar 18 10:15:04 riri kernel: Hangcheck: starting hangcheck timer 0.9.0 (tick
is 180 seconds, margin is 60 seconds).
Mar 18 10:15:04 riri kernel: Hangcheck: Using get_cycles().
Mar 18 10:15:04 riri kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 4
ports, IRQ sharing disabled
Mar 18 10:15:04 riri kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a
16550A
Mar 18 10:15:04 riri kernel: 00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Mar 18 10:15:04 riri kernel: Floppy drive(s): fd0 is 1.44M
Mar 18 10:15:04 riri kernel: FDC 0 is a post-1991 82077
Mar 18 10:15:04 riri kernel: RAMDISK driver initialized: 16 RAM disks of
65536K size 1024 blocksize
Mar 18 10:15:04 riri kernel: loop: loaded (max 8 devices)
Mar 18 10:15:04 riri kernel: nbd: registered device at major 43
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19
(level, low) -> IRQ 19
Mar 18 10:15:04 riri kernel: sky2 0000:04:00.0: v1.13 addr 0xff8fc000 irq 19
Yukon-EC (0xb6) rev 2
Mar 18 10:15:04 riri kernel: sky2 eth0: addr 00:18:f3:e0:5d:d4
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16
(level, low) -> IRQ 16
Mar 18 10:15:04 riri kernel: sky2 0000:03:00.0: v1.13 addr 0xff7fc000 irq 16
Yukon-EC (0xb6) rev 2
Mar 18 10:15:04 riri kernel: sky2 eth1: addr 00:18:f3:e0:36:fd
Mar 18 10:15:04 riri kernel: PPP generic driver version 2.4.2
Mar 18 10:15:04 riri kernel: PPP Deflate Compression module registered
Mar 18 10:15:04 riri kernel: PPP BSD Compression module registered
Mar 18 10:15:04 riri kernel: PPP MPPE Compression module registered
Mar 18 10:15:04 riri kernel: Equalizer2002: Simon Janes (simon@ncm.com) and
David S. Miller (davem@redhat.com)
Mar 18 10:15:04 riri kernel: tun: Universal TUN/TAP device driver, 1.6
Mar 18 10:15:04 riri kernel: tun: (C) 1999-2004 Max Krasnyansky
<maxk@qualcomm.com>
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23
(level, low) -> IRQ 23
Mar 18 10:15:04 riri kernel: ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4
ports 3 Gbps 0xf impl SATA mode
Mar 18 10:15:04 riri kernel: ahci 0000:00:1f.2: flags: 64bit ncq led clo pio
slum part 
Mar 18 10:15:04 riri kernel: ata1: SATA max UDMA/133 cmd 0xffffc2000008e900
ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 504
Mar 18 10:15:04 riri kernel: ata2: SATA max UDMA/133 cmd 0xffffc2000008e980
ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 504
Mar 18 10:15:04 riri kernel: ata3: SATA max UDMA/133 cmd 0xffffc2000008ea00
ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 504
Mar 18 10:15:04 riri kernel: ata4: SATA max UDMA/133 cmd 0xffffc2000008ea80
ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 504
Mar 18 10:15:04 riri kernel: scsi0 : ahci
Mar 18 10:15:04 riri kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl
300)
Mar 18 10:15:04 riri kernel: ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max
UDMA/133
Mar 18 10:15:04 riri kernel: ata1.00: 490234752 sectors, multi 0: LBA48 NCQ
(depth 31/32)
Mar 18 10:15:04 riri kernel: ata1.00: configured for UDMA/133
Mar 18 10:15:04 riri kernel: scsi1 : ahci
Mar 18 10:15:04 riri kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl
300)
Mar 18 10:15:04 riri kernel: ata2.00: qc timeout (cmd 0xec)
Mar 18 10:15:04 riri kernel: ata2.00: failed to IDENTIFY (I/O error,
err_mask=0x104)
Mar 18 10:15:04 riri kernel: ata2: port is slow to respond, please be patient
(Status 0x80)
Mar 18 10:15:04 riri kernel: ata2: hardreset failed, retrying in 5 secs
Mar 18 10:15:04 riri kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl
300)
Mar 18 10:15:04 riri kernel: ata2.00: ATA-6: Config  Disk, RGL10364, max
UDMA/133
Mar 18 10:15:04 riri kernel: ata2.00: 640 sectors, multi 1: LBA 
Mar 18 10:15:04 riri kernel: ata2.00: configured for UDMA/133
Mar 18 10:15:04 riri kernel: scsi2 : ahci
Mar 18 10:15:04 riri kernel: ata3: SATA link up 1.5 Gbps (SStatus 113 SControl
300)
Mar 18 10:15:04 riri kernel: ata3.00: ATA-7: Maxtor 6L250S0, BANC1G10, max
UDMA/133
Mar 18 10:15:04 riri kernel: ata3.00: 490234752 sectors, multi 0: LBA48 NCQ
(depth 31/32)
Mar 18 10:15:04 riri kernel: ata3.00: configured for UDMA/133
Mar 18 10:15:04 riri kernel: scsi3 : ahci
Mar 18 10:15:04 riri kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl
300)
Mar 18 10:15:04 riri kernel: ata4.00: ATA-7: ST3500641AS, 3.AAB, max UDMA/133
Mar 18 10:15:04 riri kernel: ata4.00: 976773168 sectors, multi 16: LBA48 NCQ
(depth 31/32)
Mar 18 10:15:04 riri kernel: ata4.00: configured for UDMA/133
Mar 18 10:15:04 riri kernel: scsi 0:0:0:0: Direct-Access     ATA      Maxtor
6L250S0   BANC PQ: 0 ANSI: 5
Mar 18 10:15:04 riri kernel: SCSI device sda: 490234752 512-byte hdwr sectors
(251000 MB)
Mar 18 10:15:04 riri kernel: sda: Write Protect is off
Mar 18 10:15:04 riri kernel: SCSI device sda: write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:15:04 riri kernel: SCSI device sda: 490234752 512-byte hdwr sectors
(251000 MB)
Mar 18 10:15:04 riri kernel: sda: Write Protect is off
Mar 18 10:15:04 riri kernel: SCSI device sda: write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:15:04 riri kernel:  sda: sda1 sda2 sda3
Mar 18 10:15:04 riri kernel: sd 0:0:0:0: Attached scsi disk sda
Mar 18 10:15:04 riri kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Mar 18 10:15:04 riri kernel: scsi 1:0:0:0: Direct-Access     ATA      Config
Disk     RGL1 PQ: 0 ANSI: 5
Mar 18 10:15:04 riri kernel: SCSI device sdb: 640 512-byte hdwr sectors (0 MB)
Mar 18 10:15:04 riri kernel: sdb: Write Protect is off
Mar 18 10:15:04 riri kernel: SCSI device sdb: write cache: disabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:15:04 riri kernel: SCSI device sdb: 640 512-byte hdwr sectors (0 MB)
Mar 18 10:15:04 riri kernel: sdb: Write Protect is off
Mar 18 10:15:04 riri kernel: SCSI device sdb: write cache: disabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:15:04 riri kernel:  sdb: unknown partition table
Mar 18 10:15:04 riri kernel: sd 1:0:0:0: Attached scsi disk sdb
Mar 18 10:15:04 riri kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Mar 18 10:15:04 riri kernel: scsi 2:0:0:0: Direct-Access     ATA      Maxtor
6L250S0   BANC PQ: 0 ANSI: 5
Mar 18 10:15:04 riri kernel: SCSI device sdc: 490234752 512-byte hdwr sectors
(251000 MB)
Mar 18 10:15:04 riri kernel: sdc: Write Protect is off
Mar 18 10:15:04 riri kernel: SCSI device sdc: write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:15:04 riri kernel: SCSI device sdc: 490234752 512-byte hdwr sectors
(251000 MB)
Mar 18 10:15:04 riri kernel: sdc: Write Protect is off
Mar 18 10:15:04 riri kernel: SCSI device sdc: write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:15:04 riri kernel:  sdc: sdc1 sdc2
Mar 18 10:15:04 riri kernel: sd 2:0:0:0: Attached scsi disk sdc
Mar 18 10:15:04 riri kernel: sd 2:0:0:0: Attached scsi generic sg2 type 0
Mar 18 10:15:04 riri kernel: scsi 3:0:0:0: Direct-Access     ATA
ST3500641AS      3.AA PQ: 0 ANSI: 5
Mar 18 10:15:04 riri kernel: SCSI device sdd: 976773168 512-byte hdwr sectors
(500108 MB)
Mar 18 10:15:04 riri kernel: sdd: Write Protect is off
Mar 18 10:15:04 riri kernel: SCSI device sdd: write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:15:04 riri kernel: SCSI device sdd: 976773168 512-byte hdwr sectors
(500108 MB)
Mar 18 10:15:04 riri kernel: sdd: Write Protect is off
Mar 18 10:15:04 riri kernel: SCSI device sdd: write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:15:04 riri kernel:  sdd: sdd1 sdd2 sdd3
Mar 18 10:15:04 riri kernel: sd 3:0:0:0: Attached scsi disk sdd
Mar 18 10:15:04 riri kernel: sd 3:0:0:0: Attached scsi generic sg3 type 0
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17
(level, low) -> IRQ 17
Mar 18 10:15:04 riri kernel: ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2
ports 3 Gbps 0x3 impl SATA mode
Mar 18 10:15:04 riri kernel: ahci 0000:02:00.0: flags: 64bit ncq pm led clo
pmp pio slum part 
Mar 18 10:15:04 riri kernel: ata5: SATA max UDMA/133 cmd 0xffffc20000098100
ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 17
Mar 18 10:15:04 riri kernel: ata6: SATA max UDMA/133 cmd 0xffffc20000098180
ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 17
Mar 18 10:15:04 riri kernel: scsi4 : ahci
Mar 18 10:15:04 riri kernel: ata5: SATA link down (SStatus 0 SControl 300)
Mar 18 10:15:04 riri kernel: scsi5 : ahci
Mar 18 10:15:04 riri kernel: ata6: SATA link down (SStatus 0 SControl 300)
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22
(level, low) -> IRQ 22
Mar 18 10:15:04 riri kernel: ata7: PATA max UDMA/133 cmd 0x00000000000101f0
ctl 0x00000000000103f6 bmdma 0x000000000001ffa0 irq 14
Mar 18 10:15:04 riri kernel: ata8: PATA max UDMA/133 cmd 0x0000000000010170
ctl 0x0000000000010376 bmdma 0x000000000001ffa8 irq 15
Mar 18 10:15:04 riri kernel: scsi6 : ata_piix
Mar 18 10:15:04 riri kernel: ata7.00: ATA-7: Maxtor 6L200P0, BAH41E00, max
UDMA/133
Mar 18 10:15:04 riri kernel: ata7.00: 398297088 sectors, multi 16: LBA48 
Mar 18 10:15:04 riri kernel: ata7.01: ATAPI, max UDMA/33
Mar 18 10:15:04 riri kernel: ata7.00: configured for UDMA/33
Mar 18 10:15:04 riri kernel: ata7.01: configured for UDMA/33
Mar 18 10:15:04 riri kernel: scsi7 : ata_piix
Mar 18 10:15:04 riri kernel: ATA: abnormal status 0x7F on port
0x0000000000010177
Mar 18 10:15:04 riri kernel: scsi 6:0:0:0: Direct-Access     ATA      Maxtor
6L200P0   BAH4 PQ: 0 ANSI: 5
Mar 18 10:15:04 riri kernel: SCSI device sde: 398297088 512-byte hdwr sectors
(203928 MB)
Mar 18 10:15:04 riri kernel: sde: Write Protect is off
Mar 18 10:15:04 riri kernel: SCSI device sde: write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:15:04 riri kernel: SCSI device sde: 398297088 512-byte hdwr sectors
(203928 MB)
Mar 18 10:15:04 riri kernel: sde: Write Protect is off
Mar 18 10:15:04 riri kernel: SCSI device sde: write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:15:04 riri kernel:  sde: sde1 sde2 sde3 sde4 < sde5 sde6 >
Mar 18 10:15:04 riri kernel: sd 6:0:0:0: Attached scsi disk sde
Mar 18 10:15:04 riri kernel: sd 6:0:0:0: Attached scsi generic sg4 type 0
Mar 18 10:15:04 riri kernel: scsi 6:0:1:0: CD-ROM            ASUS
CRW-5232A3       1.00 PQ: 0 ANSI: 5
Mar 18 10:15:04 riri kernel: sr0: scsi3-mmc drive: 52x/52x writer cd/rw
xa/form2 cdda tray
Mar 18 10:15:04 riri kernel: Uniform CD-ROM driver Revision: 3.20
Mar 18 10:15:04 riri kernel: sr 6:0:1:0: Attached scsi generic sg5 type 5
Mar 18 10:15:04 riri kernel: PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 16
(level, low) -> IRQ 16
Mar 18 10:15:04 riri kernel: ata9: PATA max UDMA/100 cmd 0x0000000000019c00
ctl 0x0000000000019882 bmdma 0x0000000000019400 irq 16
Mar 18 10:15:04 riri kernel: ata10: PATA max UDMA/100 cmd 0x0000000000019800
ctl 0x0000000000019482 bmdma 0x0000000000019408 irq 16
Mar 18 10:15:04 riri kernel: scsi8 : pata_jmicron
Mar 18 10:15:04 riri kernel: ata9.00: ATAPI, max UDMA/66
Mar 18 10:15:04 riri kernel: ata9.00: configured for UDMA/66
Mar 18 10:15:04 riri kernel: scsi9 : pata_jmicron
Mar 18 10:15:04 riri kernel: ATA: abnormal status 0x7F on port
0x0000000000019807
Mar 18 10:15:04 riri kernel: scsi 8:0:0:0: CD-ROM            ASUS
DRW-1608P        1.40 PQ: 0 ANSI: 5
Mar 18 10:15:04 riri kernel: sr1: scsi3-mmc drive: 40x/40x writer cd/rw
xa/form2 cdda tray
Mar 18 10:15:04 riri kernel: sr 8:0:0:0: Attached scsi generic sg6 type 5
Mar 18 10:15:04 riri kernel: video1394: Installed video1394 module
Mar 18 10:15:04 riri kernel: ieee1394: raw1394: /dev/raw1394 device
initialized
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20
(level, low) -> IRQ 20
Mar 18 10:15:04 riri kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Mar 18 10:15:04 riri kernel: ehci_hcd 0000:00:1d.7: new USB bus registered,
assigned bus number 1
Mar 18 10:15:04 riri kernel: ehci_hcd 0000:00:1d.7: debug port 1
Mar 18 10:15:04 riri kernel: ehci_hcd 0000:00:1d.7: irq 20, io mem 0xffafbc00
Mar 18 10:15:04 riri kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI
1.00, driver 10 Dec 2004
Mar 18 10:15:04 riri kernel: usb usb1: configuration #1 chosen from 1 choice
Mar 18 10:15:04 riri kernel: hub 1-0:1.0: USB hub found
Mar 18 10:15:04 riri kernel: hub 1-0:1.0: 8 ports detected
Mar 18 10:15:04 riri kernel: USB Universal Host Controller Interface driver
v3.0
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20
(level, low) -> IRQ 20
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.0: new USB bus registered,
assigned bus number 2
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000e480
Mar 18 10:15:04 riri kernel: usb usb2: configuration #1 chosen from 1 choice
Mar 18 10:15:04 riri kernel: hub 2-0:1.0: USB hub found
Mar 18 10:15:04 riri kernel: hub 2-0:1.0: 2 ports detected
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17
(level, low) -> IRQ 17
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.1: new USB bus registered,
assigned bus number 3
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000e800
Mar 18 10:15:04 riri kernel: usb usb3: configuration #1 chosen from 1 choice
Mar 18 10:15:04 riri kernel: hub 3-0:1.0: USB hub found
Mar 18 10:15:04 riri kernel: hub 3-0:1.0: 2 ports detected
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18
(level, low) -> IRQ 18
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.2: new USB bus registered,
assigned bus number 4
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e880
Mar 18 10:15:04 riri kernel: usb usb4: configuration #1 chosen from 1 choice
Mar 18 10:15:04 riri kernel: hub 4-0:1.0: USB hub found
Mar 18 10:15:04 riri kernel: hub 4-0:1.0: 2 ports detected
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19
(level, low) -> IRQ 19
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.3: new USB bus registered,
assigned bus number 5
Mar 18 10:15:04 riri kernel: uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000ec00
Mar 18 10:15:04 riri kernel: usb usb5: configuration #1 chosen from 1 choice
Mar 18 10:15:04 riri kernel: hub 5-0:1.0: USB hub found
Mar 18 10:15:04 riri kernel: hub 5-0:1.0: 2 ports detected
Mar 18 10:15:04 riri kernel: usb 1-7: new high speed USB device using ehci_hcd
and address 3
Mar 18 10:15:04 riri kernel: usb 1-7: configuration #1 chosen from 1 choice
Mar 18 10:15:04 riri kernel: hub 1-7:1.0: USB hub found
Mar 18 10:15:04 riri kernel: hub 1-7:1.0: 4 ports detected
Mar 18 10:15:04 riri kernel: usb 2-2: new full speed USB device using uhci_hcd
and address 2
Mar 18 10:15:04 riri kernel: usb 2-2: configuration #1 chosen from 1 choice
Mar 18 10:15:04 riri kernel: usb 1-7.3: new high speed USB device using
ehci_hcd and address 4
Mar 18 10:15:04 riri kernel: usb 1-7.3: configuration #1 chosen from 1 choice
Mar 18 10:15:04 riri kernel: usbcore: registered new interface driver usblp
Mar 18 10:15:04 riri kernel: drivers/usb/class/usblp.c: v0.13: USB Printer
Device Class driver
Mar 18 10:15:04 riri kernel: Initializing USB Mass Storage driver...
Mar 18 10:15:04 riri kernel: usbcore: registered new interface driver
usb-storage
Mar 18 10:15:04 riri kernel: USB Mass Storage support registered.
Mar 18 10:15:04 riri kernel: usbcore: registered new interface driver hiddev
Mar 18 10:15:04 riri kernel: usbcore: registered new interface driver usbhid
Mar 18 10:15:04 riri kernel: drivers/usb/input/hid-core.c: v2.6:USB HID core
driver
Mar 18 10:15:04 riri kernel: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M]
at 0x60,0x64 irq 1,12
Mar 18 10:15:04 riri kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Mar 18 10:15:04 riri kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Mar 18 10:15:04 riri kernel: mice: PS/2 mouse device common for all mice
Mar 18 10:15:04 riri kernel: input: AT Translated Set 2 keyboard as
/class/input/input2
Mar 18 10:15:04 riri kernel: input: PC Speaker as /class/input/input3
Mar 18 10:15:04 riri kernel: input: ImExPS/2 Logitech MX Mouse as
/class/input/input4
Mar 18 10:15:04 riri kernel: I2O subsystem v1.325
Mar 18 10:15:04 riri kernel: i2o: max drivers = 8
Mar 18 10:15:04 riri kernel: I2O Configuration OSM v1.323
Mar 18 10:15:04 riri kernel: I2O Bus Adapter OSM v1.317
Mar 18 10:15:04 riri kernel: I2O Block Device OSM v1.325
Mar 18 10:15:04 riri kernel: I2O ProcFS OSM v1.316
Mar 18 10:15:04 riri kernel: i2c /dev entries driver
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 23
(level, low) -> IRQ 23
Mar 18 10:15:04 riri kernel: md: linear personality registered for level -1
Mar 18 10:15:04 riri kernel: md: raid0 personality registered for level 0
Mar 18 10:15:04 riri kernel: md: raid1 personality registered for level 1
Mar 18 10:15:04 riri kernel: Advanced Linux Sound Architecture Driver Version
1.0.14rc3 (Tue Mar 06 13:10:00 2007 UTC).
Mar 18 10:15:04 riri kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 19
(level, low) -> IRQ 19
Mar 18 10:15:04 riri kernel: ALSA device list:
Mar 18 10:15:04 riri kernel:   #0: HDA Intel at 0xffafc000 irq 19
Mar 18 10:15:04 riri kernel: netem: version 1.2
Mar 18 10:15:04 riri kernel: u32 classifier
Mar 18 10:15:04 riri kernel:     Performance counters on
Mar 18 10:15:04 riri kernel:     OLD policer on 
Mar 18 10:15:04 riri kernel: Netfilter messages via NETLINK v0.30.
Mar 18 10:15:04 riri kernel: IPv4 over IPv4 tunneling driver
Mar 18 10:15:04 riri kernel: GRE over IPv4 tunneling driver
Mar 18 10:15:04 riri kernel: TCP cubic registered
Mar 18 10:15:04 riri kernel: Initializing XFRM netlink socket
Mar 18 10:15:04 riri kernel: NET: Registered protocol family 1
Mar 18 10:15:04 riri kernel: NET: Registered protocol family 10
Mar 18 10:15:04 riri kernel: lo: Disabled Privacy Extensions
Mar 18 10:15:04 riri kernel: IPv6: add_dev failed for eql
Mar 18 10:15:04 riri kernel: tunl0: Disabled Privacy Extensions
Mar 18 10:15:04 riri kernel: IPv6 over IPv4 tunneling driver
Mar 18 10:15:04 riri kernel: sit0: Disabled Privacy Extensions
Mar 18 10:15:04 riri kernel: NET: Registered protocol family 17
Mar 18 10:15:04 riri kernel: NET: Registered protocol family 15
Mar 18 10:15:04 riri kernel: 802.1Q VLAN Support v1.8 Ben Greear
<greearb@candelatech.com>
Mar 18 10:15:04 riri kernel: All bugs added by David S. Miller
<davem@redhat.com>
Mar 18 10:15:04 riri kernel: ieee80211: 802.11 data/management/control stack,
git-1.1.13
Mar 18 10:15:04 riri kernel: ieee80211: Copyright (C) 2004-2005 Intel
Corporation <jketreno@linux.intel.com>
Mar 18 10:15:04 riri kernel: drivers/rtc/hctosys.c: unable to open rtc device
(rtc0)
Mar 18 10:15:04 riri kernel: md: Autodetecting RAID arrays.
Mar 18 10:15:04 riri kernel: md: autorun ...
Mar 18 10:15:04 riri kernel: md: ... autorun DONE.
Mar 18 10:15:04 riri kernel: kjournald starting.  Commit interval 5 seconds
Mar 18 10:15:04 riri kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 18 10:15:04 riri kernel: VFS: Mounted root (ext3 filesystem) readonly.
Mar 18 10:15:04 riri kernel: Freeing unused kernel memory: 296k freed
Mar 18 10:15:04 riri kernel: EXT3 FS on sde1, internal journal
Mar 18 10:15:04 riri kernel: sky2 eth0: enabling interface
Mar 18 10:15:04 riri kernel: sky2 eth0: ram buffer 48K
Mar 18 10:15:04 riri kernel: ADDRCONF(NETDEV_UP): eth0: link is not ready
Mar 18 10:15:04 riri kernel: sky2 eth0: Link is up at 100 Mbps, full duplex,
flow control both
Mar 18 10:15:04 riri kernel: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Mar 18 10:15:04 riri kernel: kjournald starting.  Commit interval 5 seconds
Mar 18 10:15:04 riri kernel: EXT3 FS on sde6, internal journal
Mar 18 10:15:04 riri kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 18 10:15:04 riri kernel: kjournald starting.  Commit interval 5 seconds
Mar 18 10:15:04 riri kernel: EXT3 FS on sde3, internal journal
Mar 18 10:15:04 riri kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 18 10:15:04 riri kernel: Adding 2096436k swap on /dev/sde5.  Priority:-1
extents:1 across:2096436k
Mar 18 10:15:04 riri kernel: Adding 4192956k swap on /dev/sda3.  Priority:-2
extents:1 across:4192956k
Mar 18 10:15:04 riri kernel: ttyS1: LSR safety check engaged!
Mar 18 10:15:04 riri kernel: ttyS1: LSR safety check engaged!
Mar 18 10:15:04 riri hpiod: 0.9.7 accepting connections at 39909... 
Mar 18 10:15:06 riri kernel: ttyS1: LSR safety check engaged!
Mar 18 10:15:37 riri kernel: kjournald starting.  Commit interval 5 seconds
Mar 18 10:15:37 riri kernel: EXT3 FS on sda2, internal journal
Mar 18 10:15:37 riri kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Mar 18 10:23:10 riri exiting on signal 15
Mar 18 10:23:11 riri syslogd 1.4.1#17ubuntu7: restart.
Mar 18 10:23:26 riri kernel:          res 40/00:58:53:6e:31/00:00:0d:00:00/40
Emask 0x2 (HSM violation)
Mar 18 10:23:31 riri last message repeated 28 times
Mar 18 10:23:31 riri kernel: ata1: soft resetting port
Mar 18 10:23:32 riri kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl
300)
Mar 18 10:23:32 riri kernel: ata1.00: configured for UDMA/133
Mar 18 10:23:32 riri kernel: ata1: EH complete
Mar 18 10:23:32 riri kernel: SCSI device sda: 490234752 512-byte hdwr sectors
(251000 MB)
Mar 18 10:23:32 riri kernel: sda: Write Protect is off
Mar 18 10:23:32 riri kernel: SCSI device sda: write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:25:07 riri kernel:          res 40/00:d8:db:b0:2e/00:00:0d:00:00/40
Emask 0x2 (HSM violation)
Mar 18 10:25:11 riri last message repeated 26 times
Mar 18 10:25:12 riri kernel: ata1: soft resetting port
Mar 18 10:25:12 riri kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl
300)
Mar 18 10:25:12 riri kernel: ata1.00: configured for UDMA/133
Mar 18 10:25:12 riri kernel: ata1: EH complete
Mar 18 10:25:12 riri kernel: SCSI device sda: 490234752 512-byte hdwr sectors
(251000 MB)
Mar 18 10:25:12 riri kernel: sda: Write Protect is off
Mar 18 10:25:12 riri kernel: SCSI device sda: write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Mar 18 10:25:13 riri exiting on signal 15
Mar 18 10:25:14 riri syslogd 1.4.1#17ubuntu7: restart.
Mar 18 10:32:42 riri kernel:          res 40/00:c0:7b:6a:2a/00:00:0d:00:00/40
Em
ask 0x2 (HSM violation)
Mar 18 10:32:46 riri last message repeated 26 times
Mar 18 10:32:46 riri kernel: ata1: soft resetting port
Mar 18 10:32:47 riri kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl
3
00)
Mar 18 10:32:47 riri kernel: ata1.00: configured for UDMA/133
Mar 18 10:32:47 riri kernel: ata1: EH complete
Mar 18 10:32:47 riri kernel: SCSI device sda: 490234752 512-byte hdwr sectors
(2
51000 MB)
Mar 18 10:32:47 riri kernel: sda: Write Protect is off
Mar 18 10:32:47 riri kernel: SCSI device sda: write cache: enabled, read
cache:
enabled, doesn't support DPO or FUA
Mar 18 10:32:47 riri kernel: ata1.00: NCQ disabled due to excessive errors
Mar 18 10:32:47 riri kernel:          res 40/00:b8:63:0d:2d/00:00:0d:00:00/40
Em
ask 0x2 (HSM violation)
Mar 18 10:32:52 riri last message repeated 26 times
Mar 18 10:32:52 riri kernel: ata1: soft resetting port
Mar 18 10:32:52 riri kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl
3
00)
Mar 18 10:32:52 riri kernel: ata1.00: configured for UDMA/133
Mar 18 10:32:52 riri kernel: ata1: EH complete
Mar 18 10:32:52 riri kernel: SCSI device sda: 490234752 512-byte hdwr sectors
(2
51000 MB)
Mar 18 10:32:52 riri kernel: sda: Write Protect is off
Mar 18 10:32:53 riri kernel: SCSI device sda: write cache: enabled, read
cache:
enabled, doesn't support DPO or FUA
Mar 18 10:45:14 riri -- MARK --


Is this what you were expecting ?
Regards,
Paul

