Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYFKVwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYFKVwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 17:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYFKVwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 17:52:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:52672 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYFKVwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 17:52:07 -0400
Subject: Lenovo ThinkCentre A55: parport_pc 00:0a: disabled;  probe of
	00:0a failed with error -22
From: Malte Cornils <malte@cornils.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 11 Jun 2008 23:52:01 +0200
Message-Id: <1213221122.20453.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/9tsUIREkxLABB3czeigxAS8vxm9nvQiht4AP
 lGu7UsBeDmZx10h651/uYZ2yX41uf5gViCyfg4DqKktyi10Hxl
 tjJHYcjyTQVFDJCmHbIYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello LKML readers,

a friend of mine is unable to print on her system. I could trace that to
the kernel not finding the parallel port on the system. Windows Vista,
for whatever that's worth, prints fine.

dmesg says:
[   40.935843] parport_pc 00:0a: disabled
[   40.935850] parport_pc: probe of 00:0a failed with error -22

rmmod parport_pc ; modprobe parport_pc io=0x378 irq=none
did not work either, the detection failed and echoing some bytes to
the /dev/lp0 device fails, too.

Booting with noapic or pci=routeirq did not help, booting with noacpi
nolapic generated in the system grinding to a halt, which made getting
information out of it difficult due to the remote telephone debugging.

The parallel port is activated in the BIOS normally (IO=0x378, IRQ=7,
ECP/EPP DMA channel 3)

On a related note, the sound card does not work either, but this is not
so important for her at the moment.

This is on a Ubuntu hardy system with kernel 2.6.24-18-generic.

Unfortunately, I was not able to run through the full gamut of debugging
information with her via phone support (dmidecode, lspci -vvv, ...), but
I'll be able and happy to fetch specific information. The full dmesg
output of the system bootup can be found below.

Any hints, workarounds, debug possibilities? Should we try a 2.6.25 or
better a kernel from current Linus git?

Does
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/103098 look relevant?

Something else:
Lenovo provides a somewhat more recent BIOS, but the Flash ISO image
didn't work because I was unable to change the boot priority via phone
(does anyone have a screenshot of the specific BIOS option? *sigh*) and
the Windows-.exe-Flasher errored out under Vista. And the box doesn't
have a floppy disk drive, of course. Well.

http://www-307.ibm.com/pc/support/site.wss/document.do?sitestyle=lenovo&lndocid=MIGR-66778
http://www-307.ibm.com/pc/support/site.wss/document.do?lndocid=MIGR-68943

We have BIOS version 23A IIRC.

Any ideas?

Yours 
-Malte Cornils

---- snip ----
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.24-18-generic (buildd@terranova) (gcc
version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #1 SMP Wed May 28 20:27:26 UTC
2008 (Ubuntu 2.6.24-18.32-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
[    0.000000]  BIOS-e820: 000000000009e000 - 00000000000a0000
(reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 00000000000e0000
(reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f680000 (usable)
[    0.000000]  BIOS-e820: 000000007f680000 - 000000007f68f000 (ACPI
data)
[    0.000000]  BIOS-e820: 000000007f68f000 - 000000007f700000 (ACPI
NVS)
[    0.000000]  BIOS-e820: 000000007f700000 - 0000000080000000
(reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000
(reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000
(reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000
(reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000
(reserved)
[    0.000000] 1142MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f7070
[    0.000000] Entering add_active_range(0, 0, 521856) 0 entries of 256
used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   521856
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   521856
[    0.000000] On node 0 totalpages: 521856
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2285 pages used for memmap
[    0.000000]   HighMem zone: 290195 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP signature @ 0xC00F6EC0 checksum 0
[    0.000000] ACPI: RSDP 000F6EC0, 0014 (r0 LENOVO)
[    0.000000] ACPI: RSDT 7F68763F, 0040 (r1 LENOVO TC-2O          43
LTP        0)
[    0.000000] ACPI: FACP 7F68ED18, 0074 (r1 LENOVO TC-2O          43
PTL         3)
[    0.000000] ACPI: DSDT 7F688EB1, 5E67 (r1  INTEL BR_2OTER       43
MSFT  100000E)
[    0.000000] ACPI: FACS 7F691FC0, 0040
[    0.000000] ACPI: TCPA 7F68ED8C, 0032 (r2 LENOVO THI2OCEN       43
PTL         1)
[    0.000000] ACPI: SLIC 7F68EDBE, 0176 (r1 LENOVO TC-2O          43
LTP        0)
[    0.000000] ACPI: MCFG 7F68EF34, 003C (r1 PTLTD    M2OG         43
LTP        0)
[    0.000000] ACPI: APIC 7F68EF70, 0068 (r1 PTLTD  	 A2OC         43
LTP        0)
[    0.000000] ACPI: BOOT 7F68EFD8, 0028 (r1 PTLTD  $SB2OBL$       43
LTP        1)
[    0.000000] ACPI: SSDT 7F68767F, 13EC (r1  PmRef    CpuPm     3000
INTL 20050228)
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high
edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap:
80000000:7ec00000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009e000
- 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000
- 00000000000dc000
[    0.000000] swsusp: Registered nosave memory region: 00000000000dc000
- 00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000
- 00000000000e4000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e4000
- 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 517779
[    0.000000] Kernel command line:
root=UUID=f87fbec5-b40d-4b7e-b61d-33c93e54d860 ro quiet splash
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1596.028 MHz processor.
[   27.144951] Console: colour VGA+ 80x25
[   27.144955] console [tty0] enabled
[   27.145186] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[   27.145451] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[   27.245628] Memory: 2057516k/2087424k available (2176k kernel code,
28628k reserved, 1006k data, 368k init, 1169920k highmem)
[   27.245636] virtual kernel memory layout:
[   27.245638]     fixmap  : 0xfff4b000 - 0xfffff000   ( 720 kB)
[   27.245639]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   27.245640]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   27.245641]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   27.245642]       .init : 0xc0421000 - 0xc047d000   ( 368 kB)
[   27.245643]       .data : 0xc03201f4 - 0xc041bdc4   (1006 kB)
[   27.245644]       .text : 0xc0100000 - 0xc03201f4   (2176 kB)
[   27.245648] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   27.245691] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4,
CPUs=2, Nodes=1
[   27.325641] Calibrating delay using timer specific routine.. 3194.87
BogoMIPS (lpj=6389744)
[   27.325667] Security Framework initialized
[   27.325673] SELinux:  Disabled at boot.
[   27.325686] AppArmor: AppArmor initialized
[   27.325691] Failure registering capabilities with primary security
module.
[   27.325700] Mount-cache hash table entries: 512
[   27.325827] Initializing cgroup subsys ns
[   27.325832] Initializing cgroup subsys cpuacct
[   27.325842] CPU: After generic identify, caps: bfebfbff 20100000
00000000 00000000 0000e39d 00000000 00000001 00000000
[   27.325851] monitor/mwait feature present.
[   27.325853] using mwait in idle threads.
[   27.325857] CPU: L1 I cache: 32K, L1 D cache: 32K
[   27.325859] CPU: L2 cache: 1024K
[   27.325862] CPU: Physical Processor ID: 0
[   27.325863] CPU: Processor Core ID: 0
[   27.325865] CPU: After all inits, caps: bfebfbff 20100000 00000000
00003940 0000e39d 00000000 00000001 00000000
[   27.325874] Compat vDSO mapped to ffffe000.
[   27.325888] Checking 'hlt' instruction... OK.
[   27.342073] SMP alternatives: switching to UP code
[   27.343806] Early unpacking initramfs... done
[   27.701170] ACPI: Core revision 20070126
[   27.701217] ACPI: Looking for DSDT in initramfs... error,
file /DSDT.aml not found.
[   27.705896] CPU0: Intel(R) Pentium(R) Dual  CPU  E2140  @ 1.60GHz
stepping 0d
[   27.705914] SMP alternatives: switching to SMP code
[   27.706680] Booting processor 1/1 eip 3000
[   27.716742] Initializing CPU#1
[   27.797222] Calibrating delay using timer specific routine.. 3192.22
BogoMIPS (lpj=6384448)
[   27.797229] CPU: After generic identify, caps: bfebfbff 20100000
00000000 00000000 0000e39d 00000000 00000001 00000000
[   27.797234] monitor/mwait feature present.
[   27.797237] CPU: L1 I cache: 32K, L1 D cache: 32K
[   27.797239] CPU: L2 cache: 1024K
[   27.797241] CPU: Physical Processor ID: 0
[   27.797243] CPU: Processor Core ID: 1
[   27.797244] CPU: After all inits, caps: bfebfbff 20100000 00000000
00003940 0000e39d 00000000 00000001 00000000
[   27.797721] CPU1: Intel(R) Pentium(R) Dual  CPU  E2140  @ 1.60GHz
stepping 0d
[   27.797742] Total of 2 processors activated (6387.09 BogoMIPS).
[   27.797888] ENABLING IO-APIC IRQs
[   27.798056] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   27.945213] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   27.965212] Brought up 2 CPUs
[   27.965236] CPU0 attaching sched-domain:
[   27.965239]  domain 0: span 03
[   27.965241]   groups: 01 02
[   27.965244] CPU1 attaching sched-domain:
[   27.965246]  domain 0: span 03
[   27.965248]   groups: 02 01
[   27.965481] net_namespace: 64 bytes
[   27.965488] Booting paravirtualized kernel on bare hardware
[   27.965957] Time: 22:59:22  Date: 06/11/08
[   27.965983] NET: Registered protocol family 16
[   27.966172] EISA bus registered
[   27.966177] ACPI: bus type pci registered
[   27.972198] PCI: BIOS BUG #81[49435000] found
[   27.972235] PCI: Using configuration type 1
[   27.972237] Setting up standard PCI resources
[   27.977555] ACPI: EC: Look up EC in DSDT
[   27.980681] ACPI: Interpreter enabled
[   27.980687] ACPI: (supports S0 S1 S3 S4 S5)
[   27.980702] ACPI: Using IOAPIC for interrupt routing
[   27.985866] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   27.986471] Force enabled HPET at base address 0xfed00000
[   27.986477] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[   27.986481] PCI quirk: region 1180-11bf claimed by ICH6 GPIO
[   27.986953] PCI: Transparent bridge - 0000:00:1e.0
[   27.986983] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   27.987254] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG_._PRT]
[   27.987372] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[   27.987489] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[   27.987605] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[   27.994783] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 10 *11 14 15)
[   27.994877] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 10 *11 14 15)
[   27.994967] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 10 11 14 15) *5
[   27.995057] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *10 11 14 15)
[   27.995149] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 10 11 14 15) *0,
disabled.
[   27.995243] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 10 11 14 15) *0,
disabled.
[   27.995336] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 10 11 14 15)
[   27.995428] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *10 11 14 15)
[   27.995569] Linux Plug and Play Support v0.97 (c) Adam Belay
[   27.995599] pnp: PnP ACPI init
[   27.995607] ACPI: bus type pnp registered
[   27.999731] pnp: PnP ACPI: found 12 devices
[   27.999734] ACPI: ACPI bus type pnp unregistered
[   27.999738] PnPBIOS: Disabled by ACPI PNP
[   27.999964] PCI: Using ACPI for IRQ routing
[   27.999967] PCI: If a device doesn't work, try "pci=routeirq".  If it
helps, post a report
[   27.999971] PCI: Cannot allocate resource region 7 of bridge
0000:00:01.0
[   27.999973] PCI: Cannot allocate resource region 8 of bridge
0000:00:01.0
[   27.999975] PCI: Cannot allocate resource region 9 of bridge
0000:00:01.0
[   27.999982] PCI: Cannot allocate resource region 7 of bridge
0000:00:1c.0
[   27.999984] PCI: Cannot allocate resource region 8 of bridge
0000:00:1c.0
[   27.999987] PCI: Cannot allocate resource region 9 of bridge
0000:00:1c.0
[   28.021117] NET: Registered protocol family 8
[   28.021120] NET: Registered protocol family 20
[   28.021292] hpet clockevent registered
[   28.021297] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   28.021302] hpet0: 3 64-bit timers, 14318180 Hz
[   28.022339] AppArmor: AppArmor Filesystem Enabled
[   28.025102] Time: tsc clocksource has been installed.
[   28.041177] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[   28.041181] system 00:01: ioport range 0x290-0x29f has been reserved
[   28.041185] system 00:01: ioport range 0x800-0x87f has been reserved
[   28.041190] system 00:01: ioport range 0x880-0x88f has been reserved
[   28.041194] system 00:01: ioport range 0x400-0x4bf has been reserved
[   28.041198] system 00:01: ioport range 0x600-0x63f has been reserved
[   28.041201] system 00:01: ioport range 0x900-0x90f has been reserved
[   28.041205] system 00:01: ioport range 0x1000-0x107f has been
reserved
[   28.041208] system 00:01: ioport range 0x1180-0x11bf has been
reserved
[   28.041212] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[   28.041216] system 00:01: ioport range 0xfe00-0xfe00 has been
reserved
[   28.041220] system 00:01: iomem range 0xfed14000-0xfed17fff has been
reserved
[   28.041224] system 00:01: iomem range 0xfed13000-0xfed13fff has been
reserved
[   28.041228] system 00:01: iomem range 0xe0000000-0xefffffff has been
reserved
[   28.041231] system 00:01: iomem range 0xfed20000-0xfed8ffff has been
reserved
[   28.041235] system 00:01: iomem range 0xfef00000-0xfeffffff has been
reserved
[   28.071640] PCI: Bridge: 0000:00:01.0
[   28.071642]   IO window: disabled.
[   28.071646]   MEM window: disabled.
[   28.071648]   PREFETCH window: disabled.
[   28.071652] PCI: Bridge: 0000:00:1c.0
[   28.071653]   IO window: disabled.
[   28.071657]   MEM window: disabled.
[   28.071660]   PREFETCH window: disabled.
[   28.071665] PCI: Bridge: 0000:00:1c.1
[   28.071666]   IO window: disabled.
[   28.071671]   MEM window: d0100000-d01fffff
[   28.071674]   PREFETCH window: disabled.
[   28.071679] PCI: Bridge: 0000:00:1e.0
[   28.071680]   IO window: disabled.
[   28.071684]   MEM window: disabled.
[   28.071688]   PREFETCH window: disabled.
[   28.071705] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   28.071711] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   28.071729] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   28.071735] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   28.071752] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level,
low) -> IRQ 16
[   28.071757] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   28.071767] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   28.071779] NET: Registered protocol family 2
[   28.113255] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[   28.113501] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[   28.113986] TCP bind hash table entries: 65536 (order: 7, 524288
bytes)
[   28.114312] TCP: Hash tables configured (established 131072 bind
65536)
[   28.114315] TCP reno registered
[   28.125389] checking if image is initramfs... it is
[   28.596904] Switched to high resolution mode on CPU 1
[   28.600780] Switched to high resolution mode on CPU 0
[   28.909796] Freeing initrd memory: 7309k freed
[   28.909949] Simple Boot Flag at 0x35 set to 0x1
[   28.910560] audit: initializing netlink socket (disabled)
[   28.910574] audit(1213225162.544:1): initialized
[   28.910777] highmem bounce pool size: 64 pages
[   28.912749] VFS: Disk quotas dquot_6.5.1
[   28.912826] Dquot-cache hash table entries: 1024 (order 0, 4096
bytes)
[   28.912954] io scheduler noop registered
[   28.912956] io scheduler anticipatory registered
[   28.912958] io scheduler deadline registered
[   28.912969] io scheduler cfq registered (default)
[   28.912981] Boot video device is 0000:00:02.0
[   28.913149] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   28.913187] assign_interrupt_mode Found MSI capability
[   28.913217] Allocate Port Service[0000:00:01.0:pcie00]
[   28.913296] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   28.913336] assign_interrupt_mode Found MSI capability
[   28.913369] Allocate Port Service[0000:00:1c.0:pcie00]
[   28.913401] Allocate Port Service[0000:00:1c.0:pcie02]
[   28.913479] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   28.913519] assign_interrupt_mode Found MSI capability
[   28.913552] Allocate Port Service[0000:00:1c.1:pcie00]
[   28.913584] Allocate Port Service[0000:00:1c.1:pcie02]
[   28.913815] isapnp: Scanning for PnP cards...
[   29.266840] isapnp: No Plug & Play device found
[   29.292687] Real Time Clock Driver v1.12ac
[   29.292794] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ
sharing enabled
[   29.292914] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   29.293595] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   29.294353] RAMDISK driver initialized: 16 RAM disks of 65536K size
1024 blocksize
[   29.294431] input: Macintosh mouse button emulation
as /devices/virtual/input/input0
[   29.294535] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at
0x60,0x64 irq 1,12
[   29.294840] serio: i8042 KBD port at 0x60,0x64 irq 1
[   29.294844] serio: i8042 AUX port at 0x60,0x64 irq 12
[   29.323947] mice: PS/2 mouse device common for all mice
[   29.324079] EISA: Probing bus 0 at eisa.0
[   29.324085] Cannot allocate resource for EISA slot 1
[   29.324110] EISA: Detected 0 cards.
[   29.324112] cpuidle: using governor ladder
[   29.324114] cpuidle: using governor menu
[   29.324196] NET: Registered protocol family 1
[   29.324226] Using IPI No-Shortcut mode
[   29.324253] registered taskstats version 1
[   29.324341]   Magic number: 12:602:1007
[   29.324346]   hash matches device ttye6
[   29.324398]   hash matches device 00:09
[   29.324411] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   29.324413] EDD information not available.
[   29.324557] Freeing unused kernel memory: 368k freed
[   29.344221] input: AT Translated Set 2 keyboard
as /devices/platform/i8042/serio0/input/input1
[   30.569463] fuse init (API version 7.9)
[   30.592178] ACPI: SSDT 7F688A6B, 017C (r1  PmRef  Cpu0Ist     3000
INTL 20050228)
[   30.592667] ACPI: SSDT 7F688BE7, 0066 (r1  PmRef  Cpu1Ist     3000
INTL 20050228)
[   30.592849] ACPI Exception (processor_core-0816): AE_NOT_FOUND,
Processor Device is not present [20070126]
[   30.592860] ACPI Exception (processor_core-0816): AE_NOT_FOUND,
Processor Device is not present [20070126]
[   30.592872] ACPI Exception (processor_core-0816): AE_NOT_FOUND,
Processor Device is not present [20070126]
[   30.592882] ACPI Exception (processor_core-0816): AE_NOT_FOUND,
Processor Device is not present [20070126]
[   30.592891] ACPI Exception (processor_core-0816): AE_NOT_FOUND,
Processor Device is not present [20070126]
[   30.592902] ACPI Exception (processor_core-0816): AE_NOT_FOUND,
Processor Device is not present [20070126]
[   30.967157] usbcore: registered new interface driver usbfs
[   30.967181] usbcore: registered new interface driver hub
[   30.967847] tg3.c:v3.86 (November 9, 2007)
[   30.967870] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   30.967881] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   30.971293] usbcore: registered new device driver usb
[   30.987726] eth0: Tigon3 [partno(BCM95786) rev b002 PHY(5787)] (PCI
Express) 10/100/1000Base-T Ethernet 00:01:6c:9a:91:c0
[   30.987734] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0]
WireSpeed[1] TSOcap[1]
[   30.987737] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[   30.987805] USB Universal Host Controller Interface driver v3.0
[   30.987858] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level,
low) -> IRQ 18
[   30.987867] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   30.987871] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   30.988082] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[   30.988112] uhci_hcd 0000:00:1d.0: irq 18, io base 0x00001800
[   30.988254] usb usb1: configuration #1 chosen from 1 choice
[   30.988280] hub 1-0:1.0: USB hub found
[   30.988286] hub 1-0:1.0: 2 ports detected
[   31.005806] SCSI subsystem initialized
[   31.080463] libata version 3.00 loaded.
[   31.091215] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level,
low) -> IRQ 19
[   31.091227] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   31.091231] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   31.091260] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[   31.091286] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[   31.091411] usb usb2: configuration #1 chosen from 1 choice
[   31.091435] hub 2-0:1.0: USB hub found
[   31.091440] hub 2-0:1.0: 2 ports detected
[   31.145689] FDC 0 is a post-1991 82077
[   31.195090] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 20
[   31.195102] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   31.195106] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   31.195131] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[   31.195158] uhci_hcd 0000:00:1d.2: irq 20, io base 0x00001840
[   31.195275] usb usb3: configuration #1 chosen from 1 choice
[   31.195301] hub 3-0:1.0: USB hub found
[   31.195306] hub 3-0:1.0: 2 ports detected
[   31.298984] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level,
low) -> IRQ 16
[   31.298996] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   31.299001] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   31.299027] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 4
[   31.299056] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001860
[   31.299171] usb usb4: configuration #1 chosen from 1 choice
[   31.299195] hub 4-0:1.0: USB hub found
[   31.299200] hub 4-0:1.0: 2 ports detected
[   31.402928] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level,
low) -> IRQ 18
[   31.402943] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   31.402947] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   31.402974] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 5
[   31.406871] ehci_hcd 0000:00:1d.7: debug port 1
[   31.406877] PCI: cache line size of 32 is not supported by device
0000:00:1d.7
[   31.406885] ehci_hcd 0000:00:1d.7: irq 18, io mem 0xd0404000
[   31.434758] usb 2-2: new full speed USB device using uhci_hcd and
address 2
[   31.446741] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver
10 Dec 2004
[   31.446867] usb usb5: configuration #1 chosen from 1 choice
[   31.446895] hub 5-0:1.0: USB hub found
[   31.446902] hub 5-0:1.0: 8 ports detected
[   31.567782] ata_piix 0000:00:1f.2: version 2.12
[   31.567790] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[   31.721506] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level,
low) -> IRQ 19
[   31.721544] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   31.721635] scsi0 : ata_piix
[   31.721835] scsi1 : ata_piix
[   31.722619] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x18b0
irq 14
[   31.722622] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18b8
irq 15
[   31.797412] usb 5-4: new high speed USB device using ehci_hcd and
address 2
[   31.902967] ata1.00: ATA-7: WDC WD1600AAJS-08PSA0, 05.06H05, max
UDMA/133
[   31.902974] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth
0/32)
[   31.918693] ata1.00: configured for UDMA/133
[   31.928683] usb 5-4: configuration #1 chosen from 1 choice
[   31.943573] usbcore: registered new interface driver libusual
[   31.949130] Initializing USB Mass Storage driver...
[   31.949210] scsi2 : SCSI emulation for USB Mass Storage devices
[   31.949274] usbcore: registered new interface driver usb-storage
[   31.949277] USB Mass Storage support registered.
[   31.949373] usb-storage: device found at 2
[   31.949375] usb-storage: waiting for device to settle before scanning
[   32.253294] ata2.00: ATAPI: ATAPI   DVD A  DH16A1P, RL33, max UDMA/33
[   32.441050] ata2.00: configured for UDMA/33
[   32.441177] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-0
05.0 PQ: 0 ANSI: 5
[   32.442277] scsi 1:0:0:0: CD-ROM            ATAPI    DVD A  DH16A1P
RL33 PQ: 0 ANSI: 5
[   32.451696] Driver 'sd' needs updating - please use bus_type methods
[   32.451782] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors
(160042 MB)
[   32.451795] sd 0:0:0:0: [sda] Write Protect is off
[   32.451797] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   32.451815] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   32.451863] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors
(160042 MB)
[   32.451874] sd 0:0:0:0: [sda] Write Protect is off
[   32.451876] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   32.451893] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   32.451896]  sda:<4>Driver 'sr' needs updating - please use bus_type
methods
[   32.460631]  sda1 sda2 sda3 sda4 < sda5 >
[   32.498549] sd 0:0:0:0: [sda] Attached SCSI disk
[   32.502155] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw
xa/form2 cdda tray
[   32.502159] Uniform CD-ROM driver Revision: 3.20
[   32.502215] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   32.503986] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   32.504009] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   32.943889] Attempting manual resume
[   32.943892] swsusp: Resume From Partition 8:5
[   32.943894] PM: Checking swsusp image.
[   32.944072] PM: Resume from disk failed.
[   32.987094] kjournald starting.  Commit interval 5 seconds
[   32.987104] EXT3-fs: mounted filesystem with ordered data mode.
[   36.944620] usb-storage: device scan complete
[   36.947995] scsi 2:0:0:0: Direct-Access     TOSHIBA  MK1637GSX
PQ: 0 ANSI: 2
[   36.969446] sd 2:0:0:0: [sdb] 312581808 512-byte hardware sectors
(160042 MB)
[   36.971690] sd 2:0:0:0: [sdb] Write Protect is off
[   36.971693] sd 2:0:0:0: [sdb] Mode Sense: 38 00 00 00
[   36.971697] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   36.992796] sd 2:0:0:0: [sdb] 312581808 512-byte hardware sectors
(160042 MB)
[   36.995043] sd 2:0:0:0: [sdb] Write Protect is off
[   36.995046] sd 2:0:0:0: [sdb] Mode Sense: 38 00 00 00
[   36.995048] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   36.995052]  sdb: sdb1
[   37.295236] sd 2:0:0:0: [sdb] Attached SCSI disk
[   37.295291] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   40.108482] input: PC Speaker
as /devices/platform/pcspkr/input/input2
[   40.344721] iTCO_vendor_support: vendor-support=0
[   40.374572] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02
(26-Jul-2007)
[   40.395256] Linux agpgart interface v0.102
[   40.414026] agpgart: Detected an Intel 946GZ Chipset.
[   40.414599] agpgart: Detected 7676K stolen memory.
[   40.426983] agpgart: AGP aperture is 256M @ 0xc0000000
[   40.430938] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   40.449098] shpchp: Standard Hot Plug PCI Controller Driver version:
0.4
[   40.490266] input: Power Button (FF) as /devices/virtual/input/input3
[   40.533862] ACPI: Power Button (FF) [PWRF]
[   40.533949] input: Power Button (CM) as /devices/virtual/input/input4
[   40.589808] ACPI: Power Button (CM) [PWRB]
[   40.875181] input: ImPS/2 Generic Wheel Mouse
as /devices/platform/i8042/serio1/input/input5
[   40.935555] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2,
TCOBASE=0x1060)
[   40.935588] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   40.935843] parport_pc 00:0a: disabled
[   40.935850] parport_pc: probe of 00:0a failed with error -22
[   41.005505] intel_rng: FWH not detected
[   41.528989] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level,
low) -> IRQ 21
[   41.529017] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   42.567818] lp: driver loaded but no devices found
[   42.629986] Adding 1791208k swap on /dev/sda5.  Priority:-1 extents:1
across:1791208k
[   43.180329] EXT3 FS on sda3, internal journal
[   44.346624] ip_tables: (C) 2000-2006 Netfilter Core Team
[   44.866759] No dock devices found.
[   45.969512] ppdev: user-space parallel port driver
[   46.140803] audit(1213217979.687:2): type=1503
operation="inode_permission" requested_mask="a::" denied_mask="a::"
name="/dev/tty" pid=4884 profile="/usr/sbin/cupsd" namespace="default"
[   46.379333] apm: BIOS not found.
[   51.040277] Bluetooth: Core ver 2.11
[   51.040536] NET: Registered protocol family 31
[   51.040540] Bluetooth: HCI device and connection manager initialized
[   51.040545] Bluetooth: HCI socket layer initialized
[   51.091238] Bluetooth: L2CAP ver 2.9
[   51.091244] Bluetooth: L2CAP socket layer initialized
[   51.161509] Bluetooth: RFCOMM socket layer initialized
[   51.161524] Bluetooth: RFCOMM TTY layer initialized
[   51.161526] Bluetooth: RFCOMM ver 1.8
[   52.657237] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   52.657243] tg3: eth0: Flow control is on for TX and on for RX.
[   53.788824] [drm] Initialized drm 1.1.0 20060810
[   53.791207] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   53.791217] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   53.791283] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   54.828010] NET: Registered protocol family 17
[   57.350332] NET: Registered protocol family 10
[   57.350841] lo: Disabled Privacy Extensions
[   67.735107] eth0: no IPv6 routers present
[   80.747421] UDF-fs: No VRS found

