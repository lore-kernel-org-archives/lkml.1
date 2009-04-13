Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZDMSYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZDMSYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZDMSYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:24:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44537 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbZDMSX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:23:59 -0400
Message-ID: <49E38331.3090808@garzik.org>
Date: Mon, 13 Apr 2009 14:23:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: microcode driver newly spews warnings
Content-Type: multipart/mixed;
 boundary="------------040602020605060709060206"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040602020605060709060206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Kernel: 2.6.30-rc1-00306-g8371f87
Hardware: ICH10 x86-64

This is a regression from 2.6.29.  Microcode spews the following WARNING 
multiple times during boot:

> ------------[ cut here ]------------
> WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
> Hardware name:         
> sysfs group ffffffffa0209700 not found for kobject 'cpu0'
> Modules linked in: microcode(-) kvm_intel kvm uinput sr_mod i2c_i801 cdrom i2c_c
> ore ata_generic sg firewire_ohci snd_hda_codec_realtek pata_marvell snd_hda_inte
> l snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc e1000e ahci lib
> ata sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ehci_hcd [last unloaded: scsi_w
> ait_scan]
> Pid: 2161, comm: rmmod Not tainted 2.6.30-rc1-00306-g8371f87 #1
> Call Trace:
>  [<ffffffff80241a2f>] warn_slowpath+0xaf/0x110
>  [<ffffffff80324046>] ? sysfs_addrm_finish+0x1a6/0x250
>  [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
>  [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
>  [<ffffffff8036c49d>] ? kobject_release+0x5d/0xa0
>  [<ffffffff802ba7c2>] ? __vunmap+0x12/0x110
>  [<ffffffff80325a8b>] sysfs_remove_group+0xeb/0xf0
>  [<ffffffffa0207468>] mc_sysdev_remove+0x38/0x50 [microcode]
>  [<ffffffff803fc2f8>] sysdev_driver_unregister+0x68/0xa0
>  [<ffffffffa0207eed>] microcode_exit+0x39/0x65 [microcode]
>  [<ffffffff8026c511>] sys_delete_module+0x191/0x250
>  [<ffffffff8020b5bb>] system_call_fastpath+0x16/0x1b
> ---[ end trace 0a72bfd99e89dde6 ]---
> ------------[ cut here ]------------


Full dmesg and lspci attached.

	Jeff




--------------040602020605060709060206
Content-Type: text/plain;
 name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci.txt"

00:00.0 Host bridge: Intel Corporation X58 I/O Hub to ESI Port (rev 12)
00:01.0 PCI bridge: Intel Corporation X58 I/O Hub PCI Express Root Port 1 (rev 12)
00:03.0 PCI bridge: Intel Corporation X58 I/O Hub PCI Express Root Port 3 (rev 12)
00:07.0 PCI bridge: Intel Corporation X58 I/O Hub PCI Express Root Port 7 (rev 12)
00:10.0 PIC: Intel Corporation X58 Physical and Link Layer Registers Port 0 (rev 12)
00:10.1 PIC: Intel Corporation X58 Routing and Protocol Layer Registers Port 0 (rev 12)
00:14.0 PIC: Intel Corporation X58 I/O Hub System Management Registers (rev 12)
00:14.1 PIC: Intel Corporation X58 I/O Hub GPIO and Scratch Pad Registers (rev 12)
00:14.2 PIC: Intel Corporation X58 I/O Hub Control Status and RAS Registers (rev 12)
00:14.3 PIC: Intel Corporation X58 I/O Hub Throttle Registers (rev 12)
00:19.0 Ethernet controller: Intel Corporation 82567LM-2 Gigabit Network Connection
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 1
00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 2
00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 5
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI Controller
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
02:00.0 PCI bridge: nVidia Corporation Tesla S870 (rev a2)
03:00.0 PCI bridge: nVidia Corporation Tesla S870 (rev a2)
03:02.0 PCI bridge: nVidia Corporation Tesla S870 (rev a2)
04:00.0 3D controller: nVidia Corporation GeForce 9800 GX2 (rev a2)
05:00.0 VGA compatible controller: nVidia Corporation GeForce 9800 GX2 (rev a2)
09:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II Controller (rev b2)
0a:02.0 Ethernet controller: Intel Corporation 82541PI Gigabit Ethernet Controller (rev 05)
0a:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link)

--------------040602020605060709060206
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.30-rc1-00306-g8371f87 (jgarzik@bd.yyz.us) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #1 SMP Mon Apr 13 14:01:37 EDT 2009
Command line: ro root=UUID=f12abe85-327f-4e7d-9b06-5bb07624196d nogui
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bcdbf000 (usable)
 BIOS-e820: 00000000bcdbf000 - 00000000bcfd8000 (ACPI NVS)
 BIOS-e820: 00000000bcfd8000 - 00000000bf6bd000 (usable)
 BIOS-e820: 00000000bf6bd000 - 00000000bf6bf000 (reserved)
 BIOS-e820: 00000000bf6bf000 - 00000000bf714000 (usable)
 BIOS-e820: 00000000bf714000 - 00000000bf7bf000 (ACPI NVS)
 BIOS-e820: 00000000bf7bf000 - 00000000bf7e7000 (usable)
 BIOS-e820: 00000000bf7e7000 - 00000000bf7ff000 (ACPI data)
 BIOS-e820: 00000000bf7ff000 - 00000000bf800000 (usable)
 BIOS-e820: 00000000bf800000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fd000000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
DMI 2.5 present.
last_pfn = 0x140000 max_arch_pfn = 0x100000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-DFFFF write-protect
  E0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 080000000 mask FC0000000 write-back
  2 base 100000000 mask FC0000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbf800 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-00000000bf800000
 0000000000 - 00bf800000 page 2M
kernel direct mapping tables up to bf800000 @ 8000-c000
init_memory_mapping: 0000000100000000-0000000140000000
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ a000-10000
RAMDISK: 37c54000 - 37fef6ce
ACPI: RSDP 00000000000fe020 00024 (v02 INTEL )
ACPI: XSDT 00000000bf7fe120 0006C (v01 INTEL  DX58SO   0000084F      01000013)
ACPI: FACP 00000000bf7fd000 000F4 (v03 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI Warning (tbfadt-0562): Optional field Pm2ControlBlock has zero address or length: 0000000000000450/0 [20090320]
ACPI Warning (tbfadt-0612): Invalid length for Pm2ControlBlock: 0, using default 8 [20090320]
ACPI: DSDT 00000000bf7f8000 043CE (v02 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: FACS 00000000bf726000 00040
ACPI: APIC 00000000bf7f7000 00138 (v02 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: WDDT 00000000bf7f6000 00040 (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: MCFG 00000000bf7f5000 0003C (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: ASF! 00000000bf7f4000 000AC (v32 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: SSDT 00000000bf7ea000 070AC (v01 INTEL  SSDT  PM 0000084F MSFT 0100000D)
ACPI: DMAR 00000000bf7e7000 00140 (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: WDTT 00000000bf7f2000 0020C (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
ACPI: ASPT 00000000bf7f3000 00034 (v04 INTEL  PerfTune 0000084F MSFT 0100000D)
ACPI: Local APIC address 0xfee00000
(8 early reservations) ==> bootmem [0000000000 - 0140000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0004d9aaa4]    TEXT DATA BSS ==> [0000200000 - 0004d9aaa4]
  #3 [0037c54000 - 0037fef6ce]          RAMDISK ==> [0037c54000 - 0037fef6ce]
  #4 [000009cc00 - 0000100000]    BIOS reserved ==> [000009cc00 - 0000100000]
  #5 [0004d9b000 - 0004d9b15e]              BRK ==> [0004d9b000 - 0004d9b15e]
  #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
  #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
 [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002c7fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000000 -> 0x0000009c
    0: 0x00000100 -> 0x000bcdbf
    0: 0x000bcfd8 -> 0x000bf6bd
    0: 0x000bf6bf -> 0x000bf714
    0: 0x000bf7bf -> 0x000bf7e7
    0: 0x000bf7ff -> 0x000bf800
    0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1045694
  DMA zone: 56 pages used for memmap
  DMA zone: 105 pages reserved
  DMA zone: 3835 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 765274 pages, LIFO batch:31
  Normal zone: 3584 pages used for memmap
  Normal zone: 258560 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 16 CPUs, 8 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at c4000000 (gap: c0000000:38000000)
NR_CPUS:4096 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
PERCPU: Embedded 25 pages at ffff88002c800000, static data 70880 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1027669
Kernel command line: ro root=UUID=f12abe85-327f-4e7d-9b06-5bb07624196d nogui
Initializing CPU#0
NR_IRQS:4352
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 3200.228 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
software IO TLB at phys 0x20000000 - 0x24000000
Memory: 3946404k/5242880k available (3288k kernel code, 1060104k absent, 235496k reserved, 2494k data, 400k init)
Calibrating delay loop (skipped), value calculated using timer frequency.. 6400.45 BogoMIPS (lpj=12800912)
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU0: Thermal monitoring enabled (TM1)
CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
using mwait in idle threads.
ACPI: Core revision 20090320
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Booting processor 1 APIC 0x2 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800733)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU1: Thermal monitoring enabled (TM1)
CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 2 APIC 0x4 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800730)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU2: Thermal monitoring enabled (TM1)
CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 3 APIC 0x6 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800730)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU3: Thermal monitoring enabled (TM1)
CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 4 APIC 0x1 ip 0x6000
Initializing CPU#4
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800731)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU4: Thermal monitoring enabled (TM1)
CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
CPU4: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 5 APIC 0x3 ip 0x6000
Initializing CPU#5
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800729)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU5: Thermal monitoring enabled (TM1)
CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
CPU5: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 6 APIC 0x5 ip 0x6000
Initializing CPU#6
Calibrating delay using timer specific routine.. 6400.36 BogoMIPS (lpj=12800733)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU6: Thermal monitoring enabled (TM1)
CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
CPU6: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Booting processor 7 APIC 0x7 ip 0x6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 6400.35 BogoMIPS (lpj=12800718)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU7: Thermal monitoring enabled (TM1)
CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU7: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
Skipping synchronization checks as TSC is reliable.
Brought up 8 CPUs
Total of 8 processors activated (51203.00 BogoMIPS).
net_namespace: 1720 bytes
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
dca service started, version 1.8
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in E820
PCI: Using MMCONFIG at f8000000 - fbffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:19.0: reg 10 32bit mmio: [0xc7200000-0xc721ffff]
pci 0000:00:19.0: reg 14 32bit mmio: [0xc7223000-0xc7223fff]
pci 0000:00:19.0: reg 18 io port: [0x5100-0x511f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x50e0-0x50ff]
pci 0000:00:1a.1: reg 20 io port: [0x50c0-0x50df]
pci 0000:00:1a.2: reg 20 io port: [0x50a0-0x50bf]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xc7222000-0xc72223ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xf0000000-0xf0003fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x5080-0x509f]
pci 0000:00:1d.1: reg 20 io port: [0x5060-0x507f]
pci 0000:00:1d.2: reg 20 io port: [0x5040-0x505f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xc7221000-0xc72213ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
pci 0000:00:1f.2: reg 10 io port: [0x5128-0x512f]
pci 0000:00:1f.2: reg 14 io port: [0x5134-0x5137]
pci 0000:00:1f.2: reg 18 io port: [0x5120-0x5127]
pci 0000:00:1f.2: reg 1c io port: [0x5130-0x5133]
pci 0000:00:1f.2: reg 20 io port: [0x5020-0x503f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xc7220000-0xc72207ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 64bit mmio: [0xf0004000-0xf00040ff]
pci 0000:00:1f.3: reg 20 io port: [0x5000-0x501f]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:03.0: bridge io port: [0x3000-0x4fff]
pci 0000:00:03.0: bridge 32bit mmio: [0xc0000000-0xc6ffffff]
pci 0000:00:03.0: bridge 64bit mmio pref: [0xd0000000-0xefffffff]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:03:02.0: PME# supported from D0 D3hot D3cold
pci 0000:03:02.0: PME# disabled
pci 0000:02:00.0: bridge io port: [0x3000-0x4fff]
pci 0000:02:00.0: bridge 32bit mmio: [0xc0000000-0xc6ffffff]
pci 0000:02:00.0: bridge 64bit mmio pref: [0xd0000000-0xefffffff]
pci 0000:04:00.0: reg 10 32bit mmio: [0xc6000000-0xc6ffffff]
pci 0000:04:00.0: reg 14 64bit mmio: [0xe0000000-0xefffffff]
pci 0000:04:00.0: reg 1c 64bit mmio: [0xc4000000-0xc5ffffff]
pci 0000:04:00.0: reg 24 io port: [0x4000-0x407f]
pci 0000:04:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:03:00.0: bridge io port: [0x4000-0x4fff]
pci 0000:03:00.0: bridge 32bit mmio: [0xc4000000-0xc6ffffff]
pci 0000:03:00.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
pci 0000:05:00.0: reg 10 32bit mmio: [0xc2000000-0xc2ffffff]
pci 0000:05:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
pci 0000:05:00.0: reg 1c 64bit mmio: [0xc0000000-0xc1ffffff]
pci 0000:05:00.0: reg 24 io port: [0x3000-0x307f]
pci 0000:05:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:03:02.0: bridge io port: [0x3000-0x3fff]
pci 0000:03:02.0: bridge 32bit mmio: [0xc0000000-0xc2ffffff]
pci 0000:03:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
pci 0000:09:00.0: reg 10 io port: [0x2018-0x201f]
pci 0000:09:00.0: reg 14 io port: [0x2024-0x2027]
pci 0000:09:00.0: reg 18 io port: [0x2010-0x2017]
pci 0000:09:00.0: reg 1c io port: [0x2020-0x2023]
pci 0000:09:00.0: reg 20 io port: [0x2000-0x200f]
pci 0000:09:00.0: reg 24 32bit mmio: [0xc7100000-0xc71003ff]
pci 0000:09:00.0: supports D1
pci 0000:09:00.0: PME# supported from D0 D1 D3hot
pci 0000:09:00.0: PME# disabled
pci 0000:00:1c.4: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.4: bridge 32bit mmio: [0xc7100000-0xc71fffff]
pci 0000:0a:02.0: reg 10 32bit mmio: [0xc7020000-0xc703ffff]
pci 0000:0a:02.0: reg 14 32bit mmio: [0xc7000000-0xc701ffff]
pci 0000:0a:02.0: reg 18 io port: [0x1000-0x103f]
pci 0000:0a:02.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:0a:02.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:02.0: PME# disabled
pci 0000:0a:03.0: reg 10 32bit mmio: [0xc7044000-0xc70447ff]
pci 0000:0a:03.0: reg 14 32bit mmio: [0xc7040000-0xc7043fff]
pci 0000:0a:03.0: supports D1 D2
pci 0000:0a:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:0a:03.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x1000-0x1fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xc7000000-0xc70fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
DMAR:Host address width 39
DMAR:DRHD (flags: 0x00000000)base: 0x00000000fe711000
DMAR:DRHD (flags: 0x00000001)base: 0x00000000fe710000
DMAR:RMRR base: 0x00000000000e9000 end: 0x00000000000e9fff
DMAR:RMRR base: 0x00000000000ea000 end: 0x00000000000eafff
DMAR:RMRR base: 0x00000000000eb000 end: 0x00000000000ebfff
DMAR:RMRR base: 0x00000000000e6000 end: 0x00000000000e6fff
DMAR:RMRR base: 0x00000000000e7000 end: 0x00000000000e7fff
DMAR:RMRR base: 0x00000000000e8000 end: 0x00000000000e8fff
DMAR:RMRR base: 0x00000000000ec000 end: 0x00000000000eefff
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 7
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
system 00:05: ioport range 0x500-0x53f has been reserved
system 00:05: ioport range 0x400-0x47f has been reserved
system 00:05: ioport range 0x680-0x6ff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:04:00.0: BAR 6: can't allocate mem resource [0xf0000000-0xefffffff]
pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
pci 0000:03:00.0:   IO window: 0x4000-0x4fff
pci 0000:03:00.0:   MEM window: 0xc4000000-0xc6ffffff
pci 0000:03:00.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
pci 0000:05:00.0: BAR 6: can't allocate mem resource [0xe0000000-0xdfffffff]
pci 0000:03:02.0: PCI bridge, secondary bus 0000:05
pci 0000:03:02.0:   IO window: 0x3000-0x3fff
pci 0000:03:02.0:   MEM window: 0xc0000000-0xc2ffffff
pci 0000:03:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:02:00.0: PCI bridge, secondary bus 0000:03
pci 0000:02:00.0:   IO window: 0x3000-0x4fff
pci 0000:02:00.0:   MEM window: 0xc0000000-0xc6ffffff
pci 0000:02:00.0:   PREFETCH window: 0x000000d0000000-0x000000efffffff
pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
pci 0000:00:03.0:   IO window: 0x3000-0x4fff
pci 0000:00:03.0:   MEM window: 0xc0000000-0xc6ffffff
pci 0000:00:03.0:   PREFETCH window: 0x000000d0000000-0x000000efffffff
pci 0000:00:07.0: PCI bridge, secondary bus 0000:06
pci 0000:00:07.0:   IO window: disabled
pci 0000:00:07.0:   MEM window: disabled
pci 0000:00:07.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:07
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: disabled
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:09
pci 0000:00:1c.4:   IO window: 0x2000-0x2fff
pci 0000:00:1c.4:   MEM window: 0xc7100000-0xc71fffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0a
pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
pci 0000:00:1e.0:   MEM window: 0xc7000000-0xc70fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000c7300000-0x000000c73fffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:03.0: setting latency timer to 64
pci 0000:02:00.0: setting latency timer to 64
pci 0000:03:00.0: setting latency timer to 64
pci 0000:03:02.0: setting latency timer to 64
pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 mem: [0x0-0x0]
pci_bus 0000:01: resource 1 mem: [0x0-0x0]
pci_bus 0000:01: resource 2 mem: [0x0-0x0]
pci_bus 0000:01: resource 3 mem: [0x0-0x0]
pci_bus 0000:02: resource 0 io:  [0x3000-0x4fff]
pci_bus 0000:02: resource 1 mem: [0xc0000000-0xc6ffffff]
pci_bus 0000:02: resource 2 mem: [0xd0000000-0xefffffff]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:03: resource 0 io:  [0x3000-0x4fff]
pci_bus 0000:03: resource 1 mem: [0xc0000000-0xc6ffffff]
pci_bus 0000:03: resource 2 mem: [0xd0000000-0xefffffff]
pci_bus 0000:03: resource 3 mem: [0x0-0x0]
pci_bus 0000:04: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:04: resource 1 mem: [0xc4000000-0xc6ffffff]
pci_bus 0000:04: resource 2 mem: [0xe0000000-0xefffffff]
pci_bus 0000:04: resource 3 mem: [0x0-0x0]
pci_bus 0000:05: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:05: resource 1 mem: [0xc0000000-0xc2ffffff]
pci_bus 0000:05: resource 2 mem: [0xd0000000-0xdfffffff]
pci_bus 0000:05: resource 3 mem: [0x0-0x0]
pci_bus 0000:06: resource 0 mem: [0x0-0x0]
pci_bus 0000:06: resource 1 mem: [0x0-0x0]
pci_bus 0000:06: resource 2 mem: [0x0-0x0]
pci_bus 0000:06: resource 3 mem: [0x0-0x0]
pci_bus 0000:07: resource 0 mem: [0x0-0x0]
pci_bus 0000:07: resource 1 mem: [0x0-0x0]
pci_bus 0000:07: resource 2 mem: [0x0-0x0]
pci_bus 0000:07: resource 3 mem: [0x0-0x0]
pci_bus 0000:08: resource 0 mem: [0x0-0x0]
pci_bus 0000:08: resource 1 mem: [0x0-0x0]
pci_bus 0000:08: resource 2 mem: [0x0-0x0]
pci_bus 0000:08: resource 3 mem: [0x0-0x0]
pci_bus 0000:09: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:09: resource 1 mem: [0xc7100000-0xc71fffff]
pci_bus 0000:09: resource 2 mem: [0x0-0x0]
pci_bus 0000:09: resource 3 mem: [0x0-0x0]
pci_bus 0000:0a: resource 0 io:  [0x1000-0x1fff]
pci_bus 0000:0a: resource 1 mem: [0xc7000000-0xc70fffff]
pci_bus 0000:0a: resource 2 mem: [0xc7300000-0xc73fffff]
pci_bus 0000:0a: resource 3 io:  [0x00-0xffff]
pci_bus 0000:0a: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...
rootfs image is initramfs; unpacking...
Freeing initrd memory: 3693k freed
Intel AES-NI instructions are not detected.
audit: initializing netlink socket (disabled)
type=2000 audit(1239645826.884:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 7716
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:05:00.0: Boot video device
pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:07.0: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:07.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: irq 27 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.1: irq 28 for MSI/MSI-X
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.4: irq 29 for MSI/MSI-X
pcieport-driver 0000:00:1c.4: setting latency timer to 64
aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button (CM) [SLPB]
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: CPU1 (power states: C1[C1] C2[C3])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: CPU2 (power states: C1[C1] C2[C3])
processor ACPI_CPU:02: registered as cooling_device2
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: CPU3 (power states: C1[C1] C2[C3])
processor ACPI_CPU:03: registered as cooling_device3
ACPI: Processor [CPU3] (supports 8 throttling states)
ACPI: CPU4 (power states: C1[C1] C2[C3])
processor ACPI_CPU:04: registered as cooling_device4
ACPI: Processor [CPU4] (supports 8 throttling states)
ACPI: CPU5 (power states: C1[C1] C2[C3])
processor ACPI_CPU:05: registered as cooling_device5
ACPI: Processor [CPU5] (supports 8 throttling states)
ACPI: CPU6 (power states: C1[C1] C2[C3])
processor ACPI_CPU:06: registered as cooling_device6
ACPI: Processor [CPU6] (supports 8 throttling states)
ACPI: CPU7 (power states: C1[C1] C2[C3])
processor ACPI_CPU:07: registered as cooling_device7
ACPI: Processor [CPU7] (supports 8 throttling states)
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
brd: module loaded
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input2
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.19.
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Freeing unused kernel memory: 400k freed
Write protecting the kernel read-only data: 4284k
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xc7222000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.30-rc1-00306-g8371f87 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xc7221000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.30-rc1-00306-g8371f87 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000050e0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.30-rc1-00306-g8371f87 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x000050c0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.30-rc1-00306-g8371f87 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x000050a0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.30-rc1-00306-g8371f87 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00005080
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.30-rc1-00306-g8371f87 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00005060
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.30-rc1-00306-g8371f87 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00005040
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.30-rc1-00306-g8371f87 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: irq 30 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 30
ata2: SATA max UDMA/133 abar m2048@0xc7220000 port 0xc7220180 irq 30
ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 30
ata4: SATA max UDMA/133 abar m2048@0xc7220000 port 0xc7220280 irq 30
ata5: SATA max UDMA/133 abar m2048@0xc7220000 port 0xc7220300 irq 30
ata6: SATA max UDMA/133 irq_stat 0x00400040
ata2: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: New USB device found, idVendor=045e, idProduct=0047
usb 4-1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
usb 4-1: Product: Microsoft 5-Button Mouse with IntelliEye(TM)
usb 4-1: Manufacturer: Microsoft
usb 4-1: configuration #1 chosen from 1 choice
input: Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.0/input/input3
generic-usb 0003:045E:0047.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on usb-0000:00:1a.1-1/input0
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-8: G.SKILL 128GB SSD, 02.10104, max UDMA/100
ata3.00: 250445824 sectors, multi 0: LBA 
ata1.00: ATA-8: ST3500320AS, SD15, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/100
ata6.00: ATAPI: PIONEER BD-ROM  BDC-202, 1.04, max UDMA/66
ata1.00: configured for UDMA/133
ata6.00: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      G.SKILL 128GB SS 02.1 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<5>sd 2:0:0:0: [sdb] 250445824 512-byte hardware sectors: (128 GB/119 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sda1 sda2 sda3 sda4 < sda5<5>scsi 5:0:0:0: CD-ROM            PIONEER  BD-ROM  BDC-202  1.04 PQ: 0 ANSI: 5
 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
usb 4-2: new low speed USB device using uhci_hcd and address 3
usb 4-2: New USB device found, idVendor=045e, idProduct=000b
usb 4-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 4-2: Product: Microsoft Natural Keyboard Elite
usb 4-2: configuration #1 chosen from 1 choice
input: Microsoft Natural Keyboard Elite as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/input/input4
generic-usb 0003:045E:000B.0002: input,hidraw1: USB HID v1.10 Keyboard [Microsoft Natural Keyboard Elite] on usb-0000:00:1a.1-2/input0
 sdb1
sd 2:0:0:0: [sdb] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
udevd version 127 started
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:c0:79:c8:c2
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
pata_marvell 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_marvell 0000:09:00.0: setting latency timer to 64
scsi6 : pata_marvell
scsi7 : pata_marvell
ata7: PATA max UDMA/100 cmd 0x2018 ctl 0x2024 bmdma 0x2000 irq 16
ata8: PATA max UDMA/133 cmd 0x2010 ctl 0x2020 bmdma 0x2008 irq 16
firewire_ohci 0000:0a:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:0a:03.0, OHCI version 1.10
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 2:0:0:0: Attached scsi generic sg1 type 0
scsi 5:0:0:0: Attached scsi generic sg2 type 5
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 32x/32x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
firewire_core: created device fw0: GUID 0090270002258426, S400
EXT3 FS on sda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
Adding 6144820k swap on /dev/sda5.  Priority:-1 extents:1 across:6144820k 
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
platform microcode: firmware: requesting intel-ucode/06-1a-04
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
Hardware name:         
sysfs group ffffffffa0209700 not found for kobject 'cpu0'
Modules linked in: microcode(-) kvm_intel kvm uinput sr_mod i2c_i801 cdrom i2c_core ata_generic sg firewire_ohci snd_hda_codec_realtek pata_marvell snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc e1000e ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2161, comm: rmmod Not tainted 2.6.30-rc1-00306-g8371f87 #1
Call Trace:
 [<ffffffff80241a2f>] warn_slowpath+0xaf/0x110
 [<ffffffff80324046>] ? sysfs_addrm_finish+0x1a6/0x250
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff8036c49d>] ? kobject_release+0x5d/0xa0
 [<ffffffff802ba7c2>] ? __vunmap+0x12/0x110
 [<ffffffff80325a8b>] sysfs_remove_group+0xeb/0xf0
 [<ffffffffa0207468>] mc_sysdev_remove+0x38/0x50 [microcode]
 [<ffffffff803fc2f8>] sysdev_driver_unregister+0x68/0xa0
 [<ffffffffa0207eed>] microcode_exit+0x39/0x65 [microcode]
 [<ffffffff8026c511>] sys_delete_module+0x191/0x250
 [<ffffffff8020b5bb>] system_call_fastpath+0x16/0x1b
---[ end trace 0a72bfd99e89dde6 ]---
------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
Hardware name:         
sysfs group ffffffffa0209700 not found for kobject 'cpu1'
Modules linked in: microcode(-) kvm_intel kvm uinput sr_mod i2c_i801 cdrom i2c_core ata_generic sg firewire_ohci snd_hda_codec_realtek pata_marvell snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc e1000e ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2161, comm: rmmod Tainted: G        W  2.6.30-rc1-00306-g8371f87 #1
Call Trace:
 [<ffffffff80241a2f>] warn_slowpath+0xaf/0x110
 [<ffffffff80324046>] ? sysfs_addrm_finish+0x1a6/0x250
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff8036c49d>] ? kobject_release+0x5d/0xa0
 [<ffffffff802ba7c2>] ? __vunmap+0x12/0x110
 [<ffffffff80325a8b>] sysfs_remove_group+0xeb/0xf0
 [<ffffffffa0207468>] mc_sysdev_remove+0x38/0x50 [microcode]
 [<ffffffff803fc2f8>] sysdev_driver_unregister+0x68/0xa0
 [<ffffffffa0207eed>] microcode_exit+0x39/0x65 [microcode]
 [<ffffffff8026c511>] sys_delete_module+0x191/0x250
 [<ffffffff8020b5bb>] system_call_fastpath+0x16/0x1b
---[ end trace 0a72bfd99e89dde7 ]---
------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
Hardware name:         
sysfs group ffffffffa0209700 not found for kobject 'cpu2'
Modules linked in: microcode(-) kvm_intel kvm uinput sr_mod i2c_i801 cdrom i2c_core ata_generic sg firewire_ohci snd_hda_codec_realtek pata_marvell snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc e1000e ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2161, comm: rmmod Tainted: G        W  2.6.30-rc1-00306-g8371f87 #1
Call Trace:
 [<ffffffff80241a2f>] warn_slowpath+0xaf/0x110
 [<ffffffff80324046>] ? sysfs_addrm_finish+0x1a6/0x250
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff8036c49d>] ? kobject_release+0x5d/0xa0
 [<ffffffff802ba7c2>] ? __vunmap+0x12/0x110
 [<ffffffff80325a8b>] sysfs_remove_group+0xeb/0xf0
 [<ffffffffa0207468>] mc_sysdev_remove+0x38/0x50 [microcode]
 [<ffffffff803fc2f8>] sysdev_driver_unregister+0x68/0xa0
 [<ffffffffa0207eed>] microcode_exit+0x39/0x65 [microcode]
 [<ffffffff8026c511>] sys_delete_module+0x191/0x250
 [<ffffffff8020b5bb>] system_call_fastpath+0x16/0x1b
---[ end trace 0a72bfd99e89dde8 ]---
------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
Hardware name:         
sysfs group ffffffffa0209700 not found for kobject 'cpu3'
Modules linked in: microcode(-) kvm_intel kvm uinput sr_mod i2c_i801 cdrom i2c_core ata_generic sg firewire_ohci snd_hda_codec_realtek pata_marvell snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc e1000e ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2161, comm: rmmod Tainted: G        W  2.6.30-rc1-00306-g8371f87 #1
Call Trace:
 [<ffffffff80241a2f>] warn_slowpath+0xaf/0x110
 [<ffffffff80324046>] ? sysfs_addrm_finish+0x1a6/0x250
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff8036c49d>] ? kobject_release+0x5d/0xa0
 [<ffffffff802ba7c2>] ? __vunmap+0x12/0x110
 [<ffffffff80325a8b>] sysfs_remove_group+0xeb/0xf0
 [<ffffffffa0207468>] mc_sysdev_remove+0x38/0x50 [microcode]
 [<ffffffff803fc2f8>] sysdev_driver_unregister+0x68/0xa0
 [<ffffffffa0207eed>] microcode_exit+0x39/0x65 [microcode]
 [<ffffffff8026c511>] sys_delete_module+0x191/0x250
 [<ffffffff8020b5bb>] system_call_fastpath+0x16/0x1b
---[ end trace 0a72bfd99e89dde9 ]---
------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
Hardware name:         
sysfs group ffffffffa0209700 not found for kobject 'cpu4'
Modules linked in: microcode(-) kvm_intel kvm uinput sr_mod i2c_i801 cdrom i2c_core ata_generic sg firewire_ohci snd_hda_codec_realtek pata_marvell snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc e1000e ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2161, comm: rmmod Tainted: G        W  2.6.30-rc1-00306-g8371f87 #1
Call Trace:
 [<ffffffff80241a2f>] warn_slowpath+0xaf/0x110
 [<ffffffff80324046>] ? sysfs_addrm_finish+0x1a6/0x250
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff8036c49d>] ? kobject_release+0x5d/0xa0
 [<ffffffff802ba7c2>] ? __vunmap+0x12/0x110
 [<ffffffff80325a8b>] sysfs_remove_group+0xeb/0xf0
 [<ffffffffa0207468>] mc_sysdev_remove+0x38/0x50 [microcode]
 [<ffffffff803fc2f8>] sysdev_driver_unregister+0x68/0xa0
 [<ffffffffa0207eed>] microcode_exit+0x39/0x65 [microcode]
 [<ffffffff8026c511>] sys_delete_module+0x191/0x250
 [<ffffffff8020b5bb>] system_call_fastpath+0x16/0x1b
---[ end trace 0a72bfd99e89ddea ]---
------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
Hardware name:         
sysfs group ffffffffa0209700 not found for kobject 'cpu5'
Modules linked in: microcode(-) kvm_intel kvm uinput sr_mod i2c_i801 cdrom i2c_core ata_generic sg firewire_ohci snd_hda_codec_realtek pata_marvell snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc e1000e ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2161, comm: rmmod Tainted: G        W  2.6.30-rc1-00306-g8371f87 #1
Call Trace:
 [<ffffffff80241a2f>] warn_slowpath+0xaf/0x110
 [<ffffffff80324046>] ? sysfs_addrm_finish+0x1a6/0x250
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff8036c49d>] ? kobject_release+0x5d/0xa0
 [<ffffffff802ba7c2>] ? __vunmap+0x12/0x110
 [<ffffffff80325a8b>] sysfs_remove_group+0xeb/0xf0
 [<ffffffffa0207468>] mc_sysdev_remove+0x38/0x50 [microcode]
 [<ffffffff803fc2f8>] sysdev_driver_unregister+0x68/0xa0
 [<ffffffffa0207eed>] microcode_exit+0x39/0x65 [microcode]
 [<ffffffff8026c511>] sys_delete_module+0x191/0x250
 [<ffffffff8020b5bb>] system_call_fastpath+0x16/0x1b
---[ end trace 0a72bfd99e89ddeb ]---
------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
Hardware name:         
sysfs group ffffffffa0209700 not found for kobject 'cpu6'
Modules linked in: microcode(-) kvm_intel kvm uinput sr_mod i2c_i801 cdrom i2c_core ata_generic sg firewire_ohci snd_hda_codec_realtek pata_marvell snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc e1000e ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2161, comm: rmmod Tainted: G        W  2.6.30-rc1-00306-g8371f87 #1
Call Trace:
 [<ffffffff80241a2f>] warn_slowpath+0xaf/0x110
 [<ffffffff80324046>] ? sysfs_addrm_finish+0x1a6/0x250
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff8036c49d>] ? kobject_release+0x5d/0xa0
 [<ffffffff802ba7c2>] ? __vunmap+0x12/0x110
 [<ffffffff80325a8b>] sysfs_remove_group+0xeb/0xf0
 [<ffffffffa0207468>] mc_sysdev_remove+0x38/0x50 [microcode]
 [<ffffffff803fc2f8>] sysdev_driver_unregister+0x68/0xa0
 [<ffffffffa0207eed>] microcode_exit+0x39/0x65 [microcode]
 [<ffffffff8026c511>] sys_delete_module+0x191/0x250
 [<ffffffff8020b5bb>] system_call_fastpath+0x16/0x1b
---[ end trace 0a72bfd99e89ddec ]---
------------[ cut here ]------------
WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
Hardware name:         
sysfs group ffffffffa0209700 not found for kobject 'cpu7'
Modules linked in: microcode(-) kvm_intel kvm uinput sr_mod i2c_i801 cdrom i2c_core ata_generic sg firewire_ohci snd_hda_codec_realtek pata_marvell snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc e1000e ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 2161, comm: rmmod Tainted: G        W  2.6.30-rc1-00306-g8371f87 #1
Call Trace:
 [<ffffffff80241a2f>] warn_slowpath+0xaf/0x110
 [<ffffffff80324046>] ? sysfs_addrm_finish+0x1a6/0x250
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff802294d9>] ? __phys_addr+0x9/0x50
 [<ffffffff8036c49d>] ? kobject_release+0x5d/0xa0
 [<ffffffff802ba7c2>] ? __vunmap+0x12/0x110
 [<ffffffff80325a8b>] sysfs_remove_group+0xeb/0xf0
 [<ffffffffa0207468>] mc_sysdev_remove+0x38/0x50 [microcode]
 [<ffffffff803fc2f8>] sysdev_driver_unregister+0x68/0xa0
 [<ffffffffa0207eed>] microcode_exit+0x39/0x65 [microcode]
 [<ffffffff8026c511>] sys_delete_module+0x191/0x250
 [<ffffffff8020b5bb>] system_call_fastpath+0x16/0x1b
---[ end trace 0a72bfd99e89dded ]---
Microcode Update Driver: v2.00 removed.
e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
e1000e 0000:00:19.0: irq 31 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
NET: Registered protocol family 17
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Bridge firewalling registered
virbr0: starting userspace STP failed, starting kernel STP
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
virbr0: no IPv6 routers present
fuse init (API version 7.11)

--------------040602020605060709060206--
