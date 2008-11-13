Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYKMVqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYKMVqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYKMVqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:46:09 -0500
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:33635
	"EHLO QMTA06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbYKMVqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:46:07 -0500
X-Authority-Analysis: v=1.0 c=1 a=uN5rVKJYuLL_r6RFAQ0A:9
 a=Q24SSzjlTxBsCVEvDXQA:7 a=5A-zAlc1j2IHDz7NXccIQw5uHwYA:4 a=u4KF2iOpL1cA:10
 a=50e4U0PicR4A:10
Date: Thu, 13 Nov 2008 21:46:00 +0000 (UTC)
From: "dave_sperry%40ieee.org" <dasperry@comcast.net>
To: linux-kernel@vger.kernel.org
Message-ID: <1225382817.431431226612760562.JavaMail.root@sz0036a.westchester.pa.mail.comcast.net>
Subject: no hrtimer with 6300ESB
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [199.46.198.231]
X-Mailer: Zimbra 5.0.9_GA_2533.RHEL5_64 (ZimbraWebClient - FF3.0 (Win)/5.0.9_GA_2533.RHEL5_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi I'm having trouble getting hrtimers to work on a compact PCI board with and 6300ESB and 2.6.26.6-rt11 #1 SMP PREEMPT RT.

Any thoughts on how to get this to work?

Thanks Dave

Here's the problem
# cat /proc/timer_list
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 150830360789 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 999848 nsecs
  .get_time:   ktime_get_real
  .offset:     0 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 999848 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs

The pci
# lspci
00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
00:02.1 Display controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
00:1c.0 PCI bridge: Intel Corporation 6300ESB 64-bit PCI-X Bridge (rev 02)
00:1d.0 USB Controller: Intel Corporation 6300ESB USB Universal Host Controller (rev 02)
00:1d.4 System peripheral: Intel Corporation 6300ESB Watchdog Timer (rev 02)
00:1d.5 PIC: Intel Corporation 6300ESB I/O Advanced Programmable Interrupt Controller (rev 02)
00:1d.7 USB Controller: Intel Corporation 6300ESB USB2 Enhanced Host Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 0a)
00:1f.0 ISA bridge: Intel Corporation 6300ESB LPC Interface Controller (rev 02)
00:1f.1 IDE interface: Intel Corporation 6300ESB PATA Storage Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 6300ESB SMBus Controller (rev 02)
02:01.0 Mass storage controller: Promise Technology, Inc. 20269 (rev 02)
02:05.0 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev 01)
02:05.1 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev 01)

and the dmesg
Linux version 2.6.26.6-rt11 (root@l71046943) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)) #1 SMP PREEMPT RT Tue Oct 28 19:05:47 EDT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001f800000 (usable)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
504MB LOWMEM available.
Entering add_active_range(0, 0, 129024) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   129024
  HighMem    129024 ->   129024
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   129024
On node 0 totalpages: 129024
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4040 pages, LIFO batch:0
  Normal zone: 1708 pages used for memmap
  Normal zone: 123220 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
DMI not present or invalid.
Using APIC driver default
ACPI Error (tbxfroot-0218): A valid RSDP was not found [20080321]
ACPI: no DMI BIOS year, acpi=force is required to enable ACPI
ACPI: acpi=force override
Allocating PCI resources starting at 20000000 (gap: 1f800000:df600000)
SMP: Allowing 0 CPUs, 0 hotplug CPUs
PERCPU: Allocating 40836 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 1
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127260
Kernel command line: ro root=LABEL=/ acpi=force  quiet
Found and enabled local APIC!
mapped APIC to ffffb000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
CPU 0 irqstacks, hard=c078f000 soft=c076f000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1600.097 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 501304k/516096k available (2229k kernel code, 14128k reserved, 1012k data, 244k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc54000 - 0xfffff000   (3756 kB)
    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
    vmalloc : 0xe0000000 - 0xff3fe000   ( 499 MB)
    lowmem  : 0xc0000000 - 0xdf800000   ( 504 MB)
      .init : 0xc072f000 - 0xc076c000   ( 244 kB)
      .data : 0xc062d7c3 - 0xc072a920   (1012 kB)
      .text : 0xc0400000 - 0xc062d7c3   (2229 kB)


CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 10k freed
ACPI: Core revision 20080321
ACPI Exception (tbxface-0629): AE_NO_ACPI_TABLES, While loading namespace from ACPI tables [20080321]
ACPI: Unable to load the System Description Tables
weird, boot CPU (#0) not listedby the BIOS.
SMP motherboard not detected.
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (3201.50 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0
  groups: 0
khelper used greatest stack depth: 3244 bytes left
net_namespace: 752 bytes
NET: Registered protocol family 16
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Using IRQ router PIIX/ICH [8086/25a1] at 0000:00:1f.0
PCI: setting IRQ 7 as level-triggered
PCI: Found IRQ 7 for device 0000:00:02.0
PCI: Sharing IRQ 7 with 0000:00:1d.0
PCI: Sharing IRQ 7 with 0000:02:05.0
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
P
