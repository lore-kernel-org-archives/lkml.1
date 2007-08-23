Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbXHWLCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbXHWLCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbXHWLCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:02:13 -0400
Received: from mx1.of.net-lab.net ([80.69.37.105]:35400 "EHLO
	imap.internetcave.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbXHWLCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:02:10 -0400
Message-ID: <46CD692D.3070508@aj.net-lab.net>
Date: Thu, 23 Aug 2007 13:02:05 +0200
From: Andreas John <lists@aj.net-lab.net>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Conke Hu <conke.hu@gmail.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>	 <45F7E7E9.6010703@gmail.com>	 <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>	 <45F93888.1080207@gmail.com> <5767b9100703270253j2ac3b543y499323b42c6402b@mail.gmail.com> <46CCA483.4080105@aj.net-lab.net> <46CCB23E.1000506@aj.net-lab.net>
In-Reply-To: <46CCB23E.1000506@aj.net-lab.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
as requested by Tejun here comes dmesg and lspci -nn. Additionally I
found something dmesg (See 1.), probably caused by the low-level error.

Best Regards,
Andreas

1.)
[81739.060000] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK,SUGGEST_OK
[81739.060000] end_request: I/O error, dev sdb, sector 0

2.) lspci -nn
root@derjohn-host:~# lspci -nn
00:00.0 Host bridge [0600]: ATI Technologies Inc Unknown device [1002:7910]
00:01.0 PCI bridge [0604]: ATI Technologies Inc Unknown device [1002:7912]
00:12.0 SATA controller [0106]: ATI Technologies Inc SB600 Non-Raid-5
SATA [1002:4380]
00:13.0 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI0)
[1002:4387]
00:13.1 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI1)
[1002:4388]
00:13.2 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI2)
[1002:4389]
00:13.3 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI3)
[1002:438a]
00:13.4 USB Controller [0c03]: ATI Technologies Inc SB600 USB (OHCI4)
[1002:438b]
00:13.5 USB Controller [0c03]: ATI Technologies Inc SB600 USB Controller
(EHCI) [1002:4386]
00:14.0 SMBus [0c05]: ATI Technologies Inc SB600 SMBus [1002:4385] (rev 14)
00:14.1 IDE interface [0101]: ATI Technologies Inc SB600 IDE [1002:438c]
00:14.2 Audio device [0403]: ATI Technologies Inc SB600 Azalia [1002:4383]
00:14.3 ISA bridge [0601]: ATI Technologies Inc SB600 PCI to LPC Bridge
[1002:438d]
00:14.4 PCI bridge [0604]: ATI Technologies Inc SB600 PCI to PCI Bridge
[1002:4384]
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control [1022:1103]
01:05.0 VGA compatible controller [0300]: ATI Technologies Inc Unknown
device [1002:791e]
02:0f.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL-8169SC Gigabit Ethernet [10ec:8167] (rev 10)


3.) A "fresh" dmesg
root@derjohn-host:~# dmesg
[    0.000000] Linux version 2.6.22-9-server (buildd@palmer) (gcc
version 4.1.3 20070718 (prerelease) (Ubuntu 4.1.2-14ubuntu1)) #1 SMP Fri
Aug 3 01:19:51 GMT 2007 (Ubuntu 2.6.22-9.25-server)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007dee0000 (usable)
[    0.000000]  BIOS-e820: 000000007dee0000 - 000000007dee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007dee3000 - 000000007def0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007def0000 - 000000007df00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] 1118MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f4fa0
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Entering add_active_range(0, 0, 515808) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   515808
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   515808
[    0.000000] On node 0 totalpages: 515808
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2237 pages used for memmap
[    0.000000]   HighMem zone: 284195 pages, LIFO batch:31
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F6940, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT 7DEE3000, 0034 (r1 GBT    GBTUACPI 42302E31
GBTU  1010101)
[    0.000000] ACPI: FACP 7DEE3040, 0074 (r1 GBT    GBTUACPI 42302E31
GBTU  1010101)
[    0.000000] ACPI: DSDT 7DEE30C0, 39B1 (r1 GBT    AWRDACPI     1000
MSFT  100000C)
[    0.000000] ACPI: FACS 7DEE0000, 0040
[    0.000000] ACPI: SSDT 7DEE6B00, 01C4 (r1 PTLTD  POWERNOW        1
LTP        1)
[    0.000000] ACPI: MCFG 7DEE6D00, 003C (r1 GBT    GBTUACPI 42302E31
GBTU  1010101)
[    0.000000] ACPI: APIC 7DEE6A80, 0068 (r1 GBT    GBTUACPI 42302E31
GBTU  1010101)
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:11 APIC version 16
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:11 APIC version 16
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 80000000 (gap:
7df00000:62100000)
[    0.000000] Built 1 zonelists.  Total pages: 511779
[    0.000000] Kernel command line: root=/dev/md0 ro quiet splash
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2000.252 MHz processor.
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.000000] Memory: 2033820k/2063232k available (2041k kernel code,
28080k reserved, 922k data, 368k init, 1145728k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.000000]       .init : 0xc03eb000 - 0xc0447000   ( 368 kB)
[    0.000000]       .data : 0xc02fe6d6 - 0xc03e4ee4   ( 922 kB)
[    0.000000]       .text : 0xc0100000 - 0xc02fe6d6   (2041 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[    0.000000] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4,
CPUs=2, Nodes=1
[    0.160000] Calibrating delay using timer specific routine.. 4002.62
BogoMIPS (lpj=20013136)
[    0.160000] Security Framework v1.0.0 initialized
[    0.160000] SELinux:  Disabled at boot.
[    0.160000] Mount-cache hash table entries: 512
[    0.160000] CPU: After generic identify, caps: 178bfbff ebd3fbff
00000000 00000000 00002001 00000000 0000001f
[    0.160000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
[    0.160000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.160000] CPU 0(2) -> Core 0
[    0.160000] CPU: After all inits, caps: 178bfbff ebd3fbff 00000000
00000410 00002001 00000000 0000001f
[    0.160000] Compat vDSO mapped to ffffe000.
[    0.160000] Checking 'hlt' instruction... OK.
[    0.200000] SMP alternatives: switching to UP code
[    0.200000] Early unpacking initramfs... done
[    0.470000] ACPI: Core revision 20070126
[    0.470000] ACPI: Looking for DSDT in initramfs... error, file
/DSDT.aml not found.
[    0.480000] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping 02
[    0.480000] SMP alternatives: switching to SMP code
[    0.480000] Booting processor 1/1 eip 3000
[    0.490000] Initializing CPU#1
[    0.640000] Calibrating delay using timer specific routine.. 4000.22
BogoMIPS (lpj=20001140)
[    0.640000] CPU: After generic identify, caps: 178bfbff ebd3fbff
00000000 00000000 00002001 00000000 0000001f
[    0.640000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
[    0.640000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.640000] CPU 1(2) -> Core 1
[    0.640000] CPU: After all inits, caps: 178bfbff ebd3fbff 00000000
00000410 00002001 00000000 0000001f
[    0.640000] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping 02
[    0.640000] Total of 2 processors activated (8002.85 BogoMIPS).
[    0.640000] ENABLING IO-APIC IRQs
[    0.640000] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.740000] Brought up 2 CPUs
[    0.770000] migration_cost=10000
[    0.770000] Booting paravirtualized kernel on bare hardware
[    0.770000] Time: 10:58:47  Date: 07/23/107
[    0.770000] NET: Registered protocol family 16
[    0.770000] EISA bus registered
[    0.770000] ACPI: bus type pci registered
[    0.880000] PCI: PCI BIOS revision 3.00 entry at 0xfb490, last bus=2
[    0.880000] PCI: Using configuration type 1
[    0.880000] Setting up standard PCI resources
[    0.880000] ACPI: EC: Look up EC in DSDT
[    0.890000] ACPI: Interpreter enabled
[    0.890000] ACPI: (supports S0 S1 S4 S5)
[    0.890000] ACPI: Using IOAPIC for interrupt routing
[    0.890000] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.890000] PCI: Probing PCI hardware (bus 00)
[    0.890000] PCI: Transparent bridge - 0000:00:14.4
[    0.890000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.890000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.890000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.900000] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.900000] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.910000] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.910000] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.910000] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.910000] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.910000] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.910000] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11)
*0, disabled.
[    0.910000] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.910000] pnp: PnP ACPI init
[    0.910000] ACPI: bus type pnp registered
[    0.910000] pnp: PnP ACPI: found 13 devices
[    0.910000] ACPI: ACPI bus type pnp unregistered
[    0.910000] PnPBIOS: Disabled by ACPI PNP
[    0.910000] PCI: Using ACPI for IRQ routing
[    0.910000] PCI: If a device doesn't work, try "pci=routeirq".  If it
helps, post a report
[    0.950000] NET: Registered protocol family 8
[    0.950000] NET: Registered protocol family 20
[    0.950000] NetLabel: Initializing
[    0.950000] NetLabel:  domain hash size = 128
[    0.950000] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.950000] NetLabel:  unlabeled traffic allowed by default
[    0.950000] pnp: 00:01: ioport range 0x4100-0x411f has been reserved
[    0.950000] pnp: 00:01: ioport range 0x228-0x22f has been reserved
[    0.950000] pnp: 00:01: ioport range 0x40b-0x40b has been reserved
[    0.950000] pnp: 00:01: ioport range 0x4d6-0x4d6 has been reserved
[    0.950000] pnp: 00:01: ioport range 0xc00-0xc01 has been reserved
[    0.950000] pnp: 00:01: ioport range 0xc14-0xc14 has been reserved
[    0.950000] pnp: 00:01: ioport range 0xc50-0xc52 has been reserved
[    0.950000] pnp: 00:01: ioport range 0xc6c-0xc6d has been reserved
[    0.950000] pnp: 00:0b: iomem range 0xe0000000-0xefffffff could not
be reserved
[    0.950000] pnp: 00:0c: iomem range 0xd1000-0xd3fff has been reserved
[    0.950000] pnp: 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
[    0.950000] pnp: 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[    0.950000] pnp: 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[    0.980000] PCI: Bridge: 0000:00:01.0
[    0.980000]   IO window: e000-efff
[    0.980000]   MEM window: fde00000-fdffffff
[    0.980000]   PREFETCH window: fa000000-fbffffff
[    0.980000] PCI: Bridge: 0000:00:14.4
[    0.980000]   IO window: d000-dfff
[    0.980000]   MEM window: fdd00000-fddfffff
[    0.980000]   PREFETCH window: fdc00000-fdcfffff
[    0.980000] NET: Registered protocol family 2
[    0.990000] Time: acpi_pm clocksource has been installed.
[    0.990000] Switched to high resolution mode on CPU 0
[    0.990000] Switched to high resolution mode on CPU 1
[    1.080000] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[    1.080000] TCP established hash table entries: 131072 (order: 8,
1572864 bytes)
[    1.080000] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.080000] TCP: Hash tables configured (established 131072 bind 65536)
[    1.080000] TCP reno registered
[    1.120000] checking if image is initramfs... it is
[    1.660000] Freeing initrd memory: 7173k freed
[    1.660000] audit: initializing netlink socket (disabled)
[    1.660000] audit(1187866727.490:1): initialized
[    1.660000] highmem bounce pool size: 64 pages
[    1.660000] VFS: Disk quotas dquot_6.5.1
[    1.660000] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.660000] io scheduler noop registered
[    1.660000] io scheduler anticipatory registered
[    1.660000] io scheduler deadline registered (default)
[    1.660000] io scheduler cfq registered
[    1.820000] Boot video device is 0000:01:05.0
[    1.820000] isapnp: Scanning for PnP cards...
[    2.170000] isapnp: No Plug & Play device found
[    2.190000] Real Time Clock Driver v1.12ac
[    2.190000] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ
sharing enabled
[    2.190000] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.190000] 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.190000] RAMDISK driver initialized: 16 RAM disks of 65536K size
1024 blocksize
[    2.190000] input: Macintosh mouse button emulation as
/class/input/input0
[    2.190000] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.190000] PNP: PS/2 controller doesn't have AUX irq; using default 12
[    2.200000] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.200000] mice: PS/2 mouse device common for all mice
[    2.200000] EISA: Probing bus 0 at eisa.0
[    2.200000] Cannot allocate resource for EISA slot 4
[    2.200000] EISA: Detected 0 cards.
[    2.200000] TCP cubic registered
[    2.200000] NET: Registered protocol family 1
[    2.200000] Using IPI No-Shortcut mode
[    2.200000]   Magic number: 3:243:983
[    2.200000] Freeing unused kernel memory: 368k freed
[    2.240000] input: AT Translated Set 2 keyboard as /class/input/input1
[    2.360000] AppArmor: AppArmor initialized
[    2.360000] audit(1187866727.990:2): AppArmor initialized
[    2.360000]
[    2.360000] AppArmor: Registered secondary security module: capability.
[    2.360000] Capability LSM initialized as secondary
[    2.380000] md: linear personality registered for level -1
[    2.390000] md: multipath personality registered for level -4
[    2.390000] md: raid0 personality registered for level 0
[    2.390000] md: raid1 personality registered for level 1
[    2.400000] raid5: automatically using best checksumming function:
pIII_sse
[    2.450000]    pIII_sse  :  6094.400 MB/sec
[    2.450000] raid5: using function: pIII_sse (6094.400 MB/sec)
[    2.620000] raid6: int32x1    853 MB/s
[    2.790000] raid6: int32x2    869 MB/s
[    2.960000] raid6: int32x4    732 MB/s
[    3.130000] raid6: int32x8    525 MB/s
[    3.300000] raid6: mmxx1     1615 MB/s
[    3.470000] raid6: mmxx2     2973 MB/s
[    3.640000] raid6: sse1x1    1608 MB/s
[    3.810000] raid6: sse1x2    2689 MB/s
[    3.980000] raid6: sse2x1    2705 MB/s
[    4.150000] raid6: sse2x2    3714 MB/s
[    4.150000] raid6: using algorithm sse2x2 (3714 MB/s)
[    4.150000] md: raid6 personality registered for level 6
[    4.150000] md: raid5 personality registered for level 5
[    4.150000] md: raid4 personality registered for level 4
[    4.170000] md: raid10 personality registered for level 10
[    4.650000] SCSI subsystem initialized
[    4.660000] libata version 2.21 loaded.
[    4.660000] ahci 0000:00:12.0: version 2.2
[    4.660000] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level,
low) -> IRQ 16
[    4.660000] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing
32bit
[    4.660000] usbcore: registered new interface driver usbfs
[    4.660000] usbcore: registered new interface driver hub
[    4.660000] usbcore: registered new device driver usb
[    4.660000] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller
(OHCI) Driver
[    5.670000] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps
0xf impl SATA mode
[    5.670000] ahci 0000:00:12.0: flags: ncq ilck pm led clo pmp pio
slum part
[    5.670000] scsi0 : ahci
[    5.670000] scsi1 : ahci
[    5.670000] scsi2 : ahci
[    5.670000] scsi3 : ahci
[    5.670000] ata1: SATA max UDMA/133 cmd 0xf885a100 ctl 0x00000000
bmdma 0x00000000 irq 16
[    5.670000] ata2: SATA max UDMA/133 cmd 0xf885a180 ctl 0x00000000
bmdma 0x00000000 irq 16
[    5.670000] ata3: SATA max UDMA/133 cmd 0xf885a200 ctl 0x00000000
bmdma 0x00000000 irq 16
[    5.670000] ata4: SATA max UDMA/133 cmd 0xf885a280 ctl 0x00000000
bmdma 0x00000000 irq 16
[    6.200000] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.200000] ata1.00: Host Protected Area detected:
[    6.200000]  current size: 781420655 sectors
[    6.200000]  native size: 781422768 sectors
[    6.200000] ata1.00: ATA-7: SAMSUNG HD401LJ, ZZ100-15, max UDMA7
[    6.200000] ata1.00: 781420655 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    6.200000] ata1.00: Host Protected Area detected:
[    6.200000]  current size: 781420655 sectors
[    6.200000]  native size: 781422768 sectors
[    6.200000] ata1.00: configured for UDMA/133
[    6.730000] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.730000] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x1)
[    7.750000] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.750000] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x1)
[    7.750000] ata2: limiting SATA link speed to 1.5 Gbps
[    7.750000] ata2.00: limiting speed to UDMA7:PIO5
[    8.770000] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    8.770000] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x1)
[    9.790000] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   10.120000] ata3: SATA link down (SStatus 0 SControl 300)
[   10.450000] ata4: SATA link down (SStatus 0 SControl 300)
[   10.450000] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD401LJ
 ZZ10 PQ: 0 ANSI: 5
[   10.450000] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level,
low) -> IRQ 17
[   10.450000] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   10.450000] ohci_hcd 0000:00:13.0: new USB bus registered, assigned
bus number 1
[   10.450000] ohci_hcd 0000:00:13.0: irq 17, io mem 0xfe02e000
[   10.450000] sd 0:0:0:0: [sda] 781420655 512-byte hardware sectors
(400087 MB)
[   10.450000] sd 0:0:0:0: [sda] Write Protect is off
[   10.450000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   10.450000] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   10.450000] sd 0:0:0:0: [sda] 781420655 512-byte hardware sectors
(400087 MB)
[   10.450000] sd 0:0:0:0: [sda] Write Protect is off
[   10.450000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   10.450000] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   10.450000]  sda: sda1 sda2 sda3
[   10.470000] sd 0:0:0:0: [sda] Attached SCSI disk
[   10.470000] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.510000] usb usb1: configuration #1 chosen from 1 choice
[   10.510000] hub 1-0:1.0: USB hub found
[   10.510000] hub 1-0:1.0: 2 ports detected
[   10.570000] md: md0 stopped.
[   10.620000] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level,
low) -> IRQ 18
[   10.620000] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   10.620000] ohci_hcd 0000:00:13.1: new USB bus registered, assigned
bus number 2
[   10.620000] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02d000
[   10.630000] md: md1 stopped.
[   10.630000] md: bind<sda2>
[   10.640000] raid1: raid set md1 active with 1 out of 2 mirrors
[   10.640000] md: md2 stopped.
[   10.660000] md: md0 stopped.
[   10.660000] md: bind<sda1>
[   10.670000] raid1: raid set md0 active with 1 out of 2 mirrors
[   10.670000] md: md2 stopped.
[   10.680000] usb usb2: configuration #1 chosen from 1 choice
[   10.680000] hub 2-0:1.0: USB hub found
[   10.680000] hub 2-0:1.0: 2 ports detected
[   10.680000] md: bind<sda3>
[   10.690000] raid1: raid set md2 active with 1 out of 2 mirrors
[   10.720000] Attempting manual resume
[   10.720000] swsusp: Resume From Partition 9:1
[   10.720000] PM: Checking swsusp image.
[   10.720000] PM: Resume from disk failed.
[   10.740000] kjournald starting.  Commit interval 5 seconds
[   10.740000] EXT3-fs: mounted filesystem with ordered data mode.
[   10.790000] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level,
low) -> IRQ 19
[   10.790000] ohci_hcd 0000:00:13.2: OHCI Host Controller
[   10.790000] ohci_hcd 0000:00:13.2: new USB bus registered, assigned
bus number 3
[   10.790000] ohci_hcd 0000:00:13.2: irq 19, io mem 0xfe02c000
[   10.850000] usb usb3: configuration #1 chosen from 1 choice
[   10.850000] hub 3-0:1.0: USB hub found
[   10.850000] hub 3-0:1.0: 2 ports detected
[   10.960000] ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level,
low) -> IRQ 18
[   10.960000] ohci_hcd 0000:00:13.3: OHCI Host Controller
[   10.960000] ohci_hcd 0000:00:13.3: new USB bus registered, assigned
bus number 4
[   10.960000] ohci_hcd 0000:00:13.3: irq 18, io mem 0xfe02b000
[   11.020000] usb usb4: configuration #1 chosen from 1 choice
[   11.020000] hub 4-0:1.0: USB hub found
[   11.020000] hub 4-0:1.0: 2 ports detected
[   11.130000] ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level,
low) -> IRQ 19
[   11.130000] ohci_hcd 0000:00:13.4: OHCI Host Controller
[   11.130000] ohci_hcd 0000:00:13.4: new USB bus registered, assigned
bus number 5
[   11.130000] ohci_hcd 0000:00:13.4: irq 19, io mem 0xfe02a000
[   11.190000] usb usb5: configuration #1 chosen from 1 choice
[   11.190000] hub 5-0:1.0: USB hub found
[   11.190000] hub 5-0:1.0: 2 ports detected
[   11.300000] ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level,
low) -> IRQ 20
[   11.300000] ehci_hcd 0000:00:13.5: EHCI Host Controller
[   11.300000] ehci_hcd 0000:00:13.5: new USB bus registered, assigned
bus number 6
[   11.300000] ehci_hcd 0000:00:13.5: debug port 1
[   11.300000] ehci_hcd 0000:00:13.5: irq 20, io mem 0xfe029000
[   11.300000] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver
10 Dec 2004
[   11.300000] usb usb6: configuration #1 chosen from 1 choice
[   11.300000] hub 6-0:1.0: USB hub found
[   11.300000] hub 6-0:1.0: 10 ports detected
[   11.410000] r8169 Gigabit Ethernet driver 2.2LK loaded
[   11.410000] ACPI: PCI Interrupt 0000:02:0f.0[A] -> GSI 23 (level,
low) -> IRQ 21
[   11.410000] eth0: RTL8169sc/8110sc at 0xf885e000, 00:1a:4d:73:3b:c7,
IRQ 21
[   12.430000] r8169: eth0: link down
[   13.420000] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   13.440000] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.530000] input: PC Speaker as /class/input/input2
[   13.570000] Linux agpgart interface v0.102 (c) Dave Jones
[   13.770000] parport_pc 00:09: reported by Plug and Play ACPI
[   13.770000] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   13.860000] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   13.860000] ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
[   13.880000] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[   13.900000] SB600_PATA: IDE controller at PCI slot 0000:00:14.1
[   13.900000] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level,
low) -> IRQ 17
[   13.900000] SB600_PATA: chipset revision 0
[   13.900000] SB600_PATA: not 100% native mode: will probe irqs later
[   13.900000]     ide0: BM-DMA at 0xf900-0xf907, BIOS settings:
hda:DMA, hdb:pio
[   13.900000] Probing IDE interface ide0...
[   13.990000] NET: Registered protocol family 17
[   14.480000] r8169: eth0: link up
[   14.690000] hda: TSSTcorpDVD-ROM SH-D162C, ATAPI CD/DVD-ROM drive
[   15.410000] hda: selected mode 0x42
[   15.410000] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   15.430000] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level,
low) -> IRQ 17
[   15.470000] hda: ATAPI 48X DVD-ROM drive, 256kB Cache, UDMA(33)
[   15.470000] Uniform CD-ROM driver Revision: 3.20
[   16.570000] lp0: using parport0 (interrupt-driven).
[   16.610000] fuse init (API version 7.8)
[   16.740000] Adding 1951800k swap on /dev/md1.  Priority:-1 extents:1
across:1951800k
[   17.150000] EXT3 FS on md0, internal journal
[   17.670000] NET: Registered protocol family 10
[   17.670000] lo: Disabled Privacy Extensions
[   17.790000] AppArmor: Unregistered secondary security module: capability
[   28.390000] eth0: no IPv6 routers present




Andreas John schrieb:
> Hm,
> I should add that on 2.6.22-amd64 (ubuntu gutsy) the log entry is as
> follows:
> 
> ----8<------
> ata2.00 excetion Emask 0x40 SAct 0x0 SErr 0x800 action 0x2 frozen
> ata2.00 tag 0 cmd 0xea Emask 0x44 stat 0x40 err 0x0 timeout
> 1st FIS failed
> ----8<------
> 
> rgds,
> Andreas
