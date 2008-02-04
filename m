Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYBDHCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYBDHCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 02:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYBDHCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 02:02:45 -0500
Received: from relay1.bcons.ru ([77.105.137.253]:37459 "EHLO relay1.bcons.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYBDHCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 02:02:42 -0500
Message-ID: <47A6B882.9070908@b-k.ru>
Date: Mon, 04 Feb 2008 10:02:26 +0300
From: Evgen L <evgen@b-k.ru>
User-Agent: Mozilla/5.0 (X11; U; FreeBSD i386; en-US; rv:1.8.1.8) Gecko/20071106 SeaMonkey/1.1.5
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: intel ahci problem
References: <479F41BB.5020800@b-k.ru> <47A430DA.7000104@gmail.com>
In-Reply-To: <47A430DA.7000104@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040704050701050803040506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040704050701050803040506
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> Evgen L wrote:
>   
>> Hi all
>>
>> I have a problem with my Intel SR1550 server (S5000PAL motheboard,
>> SATA/SAS controller, 5 SATA HDD Seagate ST9120822AS ).
>> The four drivers are in two md raid1, which striping by lvm and one
>> drive used separately. I have problem like below with two different
>> drives (ata3 or ata4) and ata5. I look problem like this with RedHat 
>> 2.6.18-53 kernel, 2.6.24-rc8, and today 2.6.24-git5. I reading about any
>> problems like this in lkml.org. There can be this message will help to
>> fix this issue.
>> The complete dmesg in attachment.
>>     
>
> Please post full dmesg including boot log and errors and the result
> "lspci -nn".
>
>   
It's the result of mirror recovery, the next result mkfs.xfs /dev/sde1. 
After that errors, the disks will be find after reset server by power.
The complete dmesg and lspci  in attachments.

md: bind<sdd1>
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sdc1
 disk 1, wo:1, o:1, dev:sdd1
md: recovery of RAID array md2
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for recovery.
md: using 128k window, over a total of 117218176 blocks.
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: softreset failed (device not ready)
ata4: hard resetting link
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: softreset failed (device not ready)
ata4: hard resetting link
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: softreset failed (device not ready)
ata4: limiting SATA link speed to 1.5 Gbps
ata4: hard resetting link
ata4: softreset failed (device not ready)
ata4: reset failed, giving up
ata4.00: disabled
ata4: EH complete
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET 
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234436415
md: super_written gets error=-5, uptodate=0
raid1: Disk failure on sdd1, disabling device.
        Operation continuing on 1 devices
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET 
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 1764415
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET 
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 1765439
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET 
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 1766463
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET 
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 1767487
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET 
driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 1767615
md: md2: recovery done.
RAID1 conf printout:

+++++++++++++++++++++++

SGI XFS with ACLs, security attributes, realtime, large block numbers, 
no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sde1
Ending clean XFS mount for filesystem: sde1
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 839735
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 841783
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 842807
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 845879
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 902223
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 908367
Buffer I/O error on device sde1, logical block 104703
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104704
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104705
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104706
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104707
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104708
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104709
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104710
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104711
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104712
lost page write due to I/O error on sde1



--------------040704050701050803040506
Content-Type: text/plain;
 name="lspci_nn"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci_nn"

00:00.0 0600: 8086:25d8 (rev 93)
00:02.0 0604: 8086:25f7 (rev 93)
00:03.0 0604: 8086:25e3 (rev 93)
00:04.0 0604: 8086:25f8 (rev 93)
00:05.0 0604: 8086:25e5 (rev 93)
00:06.0 0604: 8086:25f9 (rev 93)
00:07.0 0604: 8086:25e7 (rev 93)
00:08.0 0880: 8086:1a38 (rev 93)
00:10.0 0600: 8086:25f0 (rev 93)
00:10.1 0600: 8086:25f0 (rev 93)
00:10.2 0600: 8086:25f0 (rev 93)
00:11.0 0600: 8086:25f1 (rev 93)
00:13.0 0600: 8086:25f3 (rev 93)
00:15.0 0600: 8086:25f5 (rev 93)
00:16.0 0600: 8086:25f6 (rev 93)
00:1d.0 0c03: 8086:2688 (rev 09)
00:1d.1 0c03: 8086:2689 (rev 09)
00:1d.2 0c03: 8086:268a (rev 09)
00:1d.3 0c03: 8086:268b (rev 09)
00:1d.7 0c03: 8086:268c (rev 09)
00:1e.0 0604: 8086:244e (rev d9)
00:1f.0 0601: 8086:2670 (rev 09)
00:1f.2 0106: 8086:2681 (rev 09)
00:1f.3 0c05: 8086:269b (rev 09)
01:00.0 0604: 8086:3500 (rev 01)
01:00.3 0604: 8086:350c (rev 01)
02:00.0 0604: 8086:3510 (rev 01)
02:01.0 0604: 8086:3514 (rev 01)
02:02.0 0604: 8086:3518 (rev 01)
05:00.0 0200: 8086:1096 (rev 01)
05:00.1 0200: 8086:1096 (rev 01)
0c:0c.0 0300: 1002:515e (rev 02)

--------------040704050701050803040506
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

Linux version 2.6.24-rc8-BConsole (root@clerk.b-k.ru) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)) #1 SMP Mon Jan 28 16:39:43 MSK 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000006e275000 (usable)
 BIOS-e820: 000000006e275000 - 000000006e337000 (ACPI NVS)
 BIOS-e820: 000000006e337000 - 000000006fa3b000 (usable)
 BIOS-e820: 000000006fa3b000 - 000000006fa9a000 (reserved)
 BIOS-e820: 000000006fa9a000 - 000000006faac000 (usable)
 BIOS-e820: 000000006faac000 - 000000006fb1a000 (ACPI NVS)
 BIOS-e820: 000000006fb1a000 - 000000006fb29000 (usable)
 BIOS-e820: 000000006fb29000 - 000000006fb3a000 (ACPI data)
 BIOS-e820: 000000006fb3a000 - 000000006fc00000 (usable)
 BIOS-e820: 000000006fc00000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000ffc00000 - 00000000ffc0c000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000110000000 (usable)
Warning only 4GB will be used.
Use a HIGHMEM64G enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fd190
Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->  1048576
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->  1048576
On node 0 totalpages: 1048576
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 6400 pages used for memmap
  HighMem zone: 812800 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.5 present.
Using APIC driver default
ACPI: RSDP 000F03C0, 0024 (r2 INTEL )
ACPI: XSDT 6FB39120, 006C (r1 INTEL  S5000PAL        0 INTL  1000013)
ACPI: FACP 6FB37000, 00F4 (r3 INTEL  S5000PAL        0 INTL  1000013)
ACPI: DSDT 6FB30000, 5DC3 (r2 INTEL  S5000PAL        8 INTL  1000013)
ACPI: FACS 6FAAC000, 0040
ACPI: APIC 6FB36000, 00C8 (r1 INTEL  S5000PAL        0 INTL  1000013)
ACPI: SPCR 6FB2F000, 0050 (r1 INTEL  S5000PAL        0 INTL  1000013)
ACPI: HPET 6FB2E000, 0038 (r1 INTEL  S5000PAL        1 INTL  1000013)
ACPI: MCFG 6FB2D000, 003C (r1 INTEL  S5000PAL        1 INTL  1000013)
ACPI: HEST 6FB2C000, 00A8 (r1 INTEL  S5000PAL        1 INTL        1)
ACPI: BERT 6FB2B000, 0030 (r1 INTEL  S5000PAL        1 INTL        1)
ACPI: ERST 6FB2A000, 0230 (r1 INTEL  S5000PAL        1 INTL        1)
ACPI: EINJ 6FB29000, 0130 (r1 INTEL  S5000PAL        1 INTL        1)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:6 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
Processor #2 15:6 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x84] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x85] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x86] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x87] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7fc00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1040384
Kernel command line: root=/dev/mapper/vg0-root rhgb quiet
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (fec80000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 3192.106 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1786964k/4194304k available (2753k kernel code, 40980k reserved, 1004k data, 280k init, 911744k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc07b2000 - 0xc07f8000   ( 280 kB)
      .data : 0xc06b0540 - 0xc07ab624   (1004 kB)
      .text : 0xc0400000 - 0xc06b0540   (2753 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 6389.45 BogoMIPS (lpj=12778904)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000e43d 00000000 00000001 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20000000 00000000 0000b180 0000e43d 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 15k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Xeon(TM) CPU 3.20GHz stepping 04
Booting processor 1/2 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6383.80 BogoMIPS (lpj=12767619)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000e43d 00000000 00000001 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20000000 00000000 0000b180 0000e43d 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 3.20GHz stepping 04
Total of 2 processors activated (12773.26 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 624 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXPC._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIO._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE.PCIW.PCIQ._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs *5 7 10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 *10 11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs *5 7 10 11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 5 7 10 *11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Time: hpet clocksource has been installed.
system 00:01: iomem range 0x70000000-0x7fffffff could not be reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:01: iomem range 0xfec00000-0xfecfffff has been reserved
system 00:01: iomem range 0xfee00000-0xfeefffff has been reserved
system 00:01: iomem range 0xfe600000-0xfe6fffff has been reserved
system 00:01: iomem range 0xfe000000-0xfe01ffff has been reserved
system 00:06: ioport range 0x500-0x53f has been reserved
system 00:06: ioport range 0x400-0x47f has been reserved
system 00:06: ioport range 0x800-0x87f has been reserved
system 00:06: ioport range 0xca2-0xca7 has been reserved
system 00:06: ioport range 0xca8-0xcaf has been reserved
system 00:06: ioport range 0x161-0x161 has been reserved
system 00:06: ioport range 0x162-0x162 has been reserved
PCI: Bridge: 0000:02:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:02.0
  IO window: 2000-2fff
  MEM window: 88000000-888fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:01:00.0
  IO window: 2000-2fff
  MEM window: 88000000-888fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:01:00.3
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: 2000-2fff
  MEM window: 88000000-889fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 1000-1fff
  MEM window: 88a00000-88afffff
  PREFETCH window: 80000000-87ffffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:01.0 to 64
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:02.0 to 64
PCI: Setting latency timer of device 0000:01:00.3 to 64
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:03.0 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:07.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2772k freed
audit: initializing netlink socket (disabled)
audit(1201610228.600:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
0000:00:1d.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
Boot video device is 0000:0c:0c.0
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
Linux agpgart interface v0.102
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 20 (level, low) -> IRQ 17
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led pmp slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m1024@0x88b00000 port 0x88b00100 irq 17
ata2: SATA max UDMA/133 abar m1024@0x88b00000 port 0x88b00180 irq 17
ata3: SATA max UDMA/133 abar m1024@0x88b00000 port 0x88b00200 irq 17
ata4: SATA max UDMA/133 abar m1024@0x88b00000 port 0x88b00280 irq 17
ata5: SATA max UDMA/133 abar m1024@0x88b00000 port 0x88b00300 irq 17
ata6: SATA max UDMA/133 abar m1024@0x88b00000 port 0x88b00380 irq 17
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST9120822AS, 3.ALC, max UDMA/133
ata1.00: 234441648 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: ST9120822AS, 3.ALC, max UDMA/133
ata2.00: 234441648 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: ST9120822AS, 3.ALC, max UDMA/133
ata3.00: 234441648 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7: ST9120822AS, 3.ALC, max UDMA/133
ata4.00: 234441648 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATA-7: ST9120822AS, 3.ALC, max UDMA/133
ata5.00: 234441648 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/133
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 234441648 512-byte hardware sectors (120034 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 234441648 512-byte hardware sectors (120034 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
sd 3:0:0:0: [sdd] 234441648 512-byte hardware sectors (120034 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdd] 234441648 512-byte hardware sectors (120034 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 3:0:0:0: [sdd] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
scsi 4:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
sd 4:0:0:0: [sde] 234441648 512-byte hardware sectors (120034 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sde] 234441648 512-byte hardware sectors (120034 MB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 4:0:0:0: [sde] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg4 type 0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
/usr/src/linux-2.6.24-rc8/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 280k freed
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 18, io base 0x000030a0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 23 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 22 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00003040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 18, io mem 0x88b00400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
md: Autodetecting RAID arrays.
md: Scanned 6 and added 6 devices.
md: autorun ...
md: considering sdd1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md: sdb2 has different UUID to sdd1
md: sdb1 has different UUID to sdd1
md: sda2 has different UUID to sdd1
md: sda1 has different UUID to sdd1
md: created md2
md: bind<sdc1>
md: bind<sdd1>
md: running: <sdd1><sdc1>
md: kicking non-fresh sdd1 from array!
md: unbind<sdd1>
md: export_rdev(sdd1)
raid1: raid set md2 active with 1 out of 2 mirrors
md: considering sdb2 ...
md:  adding sdb2 ...
md: sdb1 has different UUID to sdb2
md:  adding sda2 ...
md: sda1 has different UUID to sdb2
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: Scanned 1 and added 1 devices.
md: autorun ...
md: considering sdd1 ...
md:  adding sdd1 ...
md: md2 already running, cannot run sdd1
md: export_rdev(sdd1)
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1201610252.148:2): selinux=0 auid=4294967295
input: PC Speaker as /class/input/input2
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: Power Button (FF) as /class/input/input3
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 20 (level, low) -> IRQ 17
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 18 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:05:00.0 to 64
e1000: 0000:05:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 00:04:23:d6:86:ee
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:05:00.1[B] -> GSI 19 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:05:00.1 to 64
e1000: 0000:05:00.1: e1000_probe: (PCI Express:2.5Gb/s:Width x4) 00:04:23:d6:86:ef
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
floppy0: no floppy controllers found
lp: driver loaded but no devices found
md: Autodetecting RAID arrays.
md: Scanned 1 and added 1 devices.
md: autorun ...
md: considering sdd1 ...
md:  adding sdd1 ...
md: md2 already running, cannot run sdd1
md: export_rdev(sdd1)
md: ... autorun DONE.
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on dm-1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1048568k swap on /dev/mapper/vg0-swap.  Priority:-1 extents:1 across:1048568k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
md: bind<sdd1>
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sdc1
 disk 1, wo:1, o:1, dev:sdd1
md: recovery of RAID array md2
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 117218176 blocks.
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: softreset failed (device not ready)
ata4: hard resetting link
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: softreset failed (device not ready)
ata4: hard resetting link
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: softreset failed (device not ready)
ata4: limiting SATA link speed to 1.5 Gbps
ata4: hard resetting link
ata4: softreset failed (device not ready)
ata4: reset failed, giving up
ata4.00: disabled
ata4: EH complete
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234436415
md: super_written gets error=-5, uptodate=0
raid1: Disk failure on sdd1, disabling device. 
	Operation continuing on 1 devices
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 1764415
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 1765439
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 1766463
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 1767487
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 1767615
md: md2: recovery done.
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sdc1
 disk 1, wo:1, o:0, dev:sdd1
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sdc1
SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sde1
Ending clean XFS mount for filesystem: sde1
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 839735
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 841783
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 842807
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 845879
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 902223
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
end_request: I/O error, dev sde, sector 908367
Buffer I/O error on device sde1, logical block 104703
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104704
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104705
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104706
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104707
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104708
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104709
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104710
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104711
lost page write due to I/O error on sde1
Buffer I/O error on device sde1, logical block 104712
lost page write due to I/O error on sde1
md: unbind<sdd1>
md: export_rdev(sdd1)
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234436415
printk: 1783 messages suppressed.
Buffer I/O error on device sdd1, logical block 117218176
Buffer I/O error on device sdd1, logical block 117218177
Buffer I/O error on device sdd1, logical block 117218178
Buffer I/O error on device sdd1, logical block 117218179
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234436415
Buffer I/O error on device sdd1, logical block 117218176
Buffer I/O error on device sdd1, logical block 117218177
Buffer I/O error on device sdd1, logical block 117218178
Buffer I/O error on device sdd1, logical block 117218179
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234436415
Buffer I/O error on device sdd1, logical block 117218176
lost page write due to I/O error on sdd1
Buffer I/O error on device sdd1, logical block 117218177
lost page write due to I/O error on sdd1
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234436415
md: disabled device sdd1, could not read superblock.
md: sdd1 does not have a valid v0.90 superblock, not importing!
md: md_import_device returned -22
printk: 2 messages suppressed.
TCP: Treason uncloaked! Peer 80.72.21.226:15069/80 shrinks window 3350387135:3350387136. Repaired.
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234436415
Buffer I/O error on device sdd1, logical block 117218176
Buffer I/O error on device sdd1, logical block 117218177
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234436415
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234436415
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234436415
md: disabled device sdd1, could not read superblock.
md: sdd1 does not have a valid v0.90 superblock, not importing!
md: md_import_device returned -22
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
printk: 10 messages suppressed.
Buffer I/O error on device sdd, logical block 0
Buffer I/O error on device sdd, logical block 1
Buffer I/O error on device sdd, logical block 2
Buffer I/O error on device sdd, logical block 3
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234441640
Buffer I/O error on device sdd, logical block 29305205
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234441640
Buffer I/O error on device sdd, logical block 29305205
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
Buffer I/O error on device sdd, logical block 1
Buffer I/O error on device sdd, logical block 2
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
printk: 2 messages suppressed.
Buffer I/O error on device sdd, logical block 0
Buffer I/O error on device sdd, logical block 1
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234441640
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234441640
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
loop: module loaded
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
printk: 10 messages suppressed.
Buffer I/O error on device sdd, logical block 0
Buffer I/O error on device sdd, logical block 1
Buffer I/O error on device sdd, logical block 2
Buffer I/O error on device sdd, logical block 3
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234441640
Buffer I/O error on device sdd, logical block 29305205
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 234441640
Buffer I/O error on device sdd, logical block 29305205
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
Buffer I/O error on device sdd, logical block 1
Buffer I/O error on device sdd, logical block 2
sd 3:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdd, sector 0

--------------040704050701050803040506--
