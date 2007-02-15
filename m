Return-Path: <linux-kernel-owner+w=401wt.eu-S1161554AbXBOW3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161554AbXBOW3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161556AbXBOW3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:29:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:47807 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161554AbXBOW3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:29:31 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, auke-jan.h.kok@intel.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: e1000_intr in request_irq faults in 2.6.20-git
Date: Thu, 15 Feb 2007 17:28:06 -0500
User-Agent: KMail/1.9.5
Cc: "lkml - Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_35N1FFzRvdwGiYr"
Message-Id: <200702151728.07726.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_35N1FFzRvdwGiYr
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

e1000 faults in 2.6.20-git, while 2.6.20 worked fine.

System is a D875PBZ with LOM.

clues?

thanks,
-Len


Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
*pde = 3747c001
Oops: 0000 [#1]
SMP
Modules linked in: dm_mod video thermal sbs i2c_ec fan button dock battery asus_acpi ac lp intel_agp agpgart ehci_hcd parport_serial parpt
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010246   (2.6.20-g724339d7 #32)
EIP is at _stext+0x3fefed10/0x14
eax: c21cd3a0   ebx: f8840000   ecx: 00000000   edx: c22d2e44
esi: c21cd3a0   edi: 00000000   ebp: c21cd564   esp: f755de6c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process ip (pid: 2975, ti=f755d000 task=f75590b0 task.ti=f755d000)
Stack: c02a2077 fffffff4 f7987404 00000000 c02a1fc3 c0140cb5 00000010 012321b4
       c21cd3a0 c21cd000 c21cd000 00000000 c02a1a71 c21cd000 c21cd000 c21cd3a0
       00000000 c21cd3a0 00000000 c02a4916 c21cd000 00001003 00001002 c03b3751
Call Trace:
 [<c02a2077>] e1000_intr+0xb4/0x107
 [<c02a1fc3>] e1000_intr+0x0/0x107
 [<c0140cb5>] request_irq+0xa5/0xcc
 [<c02a1a71>] e1000_request_irq+0xad/0xe6
 [<c02a4916>] e1000_open+0x43/0xbd
 [<c03b3751>] dev_open+0x2b/0x62
 [<c03b224d>] dev_change_flags+0x47/0xe4
 [<c03eb20e>] devinet_ioctl+0x250/0x56d
 [<c03b3348>] dev_ifsioc+0x113/0x38d
 [<c021f4ee>] copy_to_user+0x2d/0x43
 [<c03a9a28>] sock_ioctl+0x19f/0x1be
 [<c03a9889>] sock_ioctl+0x0/0x1be
 [<c0168767>] do_ioctl+0x1f/0x62
 [<c01689ee>] vfs_ioctl+0x244/0x256
 [<c0168a33>] sys_ioctl+0x33/0x4c
 [<c0103d88>] sysenter_past_esp+0x5d/0x81
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] _stext+0x3fefed10/0x14 SS:ESP 0068:f755de6c
/etc/sysconfig/network-scripts/ifup-eth: line 272:  2975 Segmentation fault      ip link set dev ${REALDEVICE} up
Failed to bring up eth0.
[FAILED]

--Boundary-00=_35N1FFzRvdwGiYr
Content-Type: text/x-log;
  charset="us-ascii";
  name="console.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="console.log"

kernel /boot/vmlinuz-linus root=/dev/sda1 console=tty0 console=ttyS0,115200n8 d ebug
   [Linux-bzImage, setup=0x1c00, size=0x262f50]

Linux version 2.6.20-g724339d7 (lenb@s5000vsa) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #32 SMP Thu Feb 15 11:30:22 EST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000e6000 size: 000000000001a000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000007fd30000 end: 000000007fe30000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000007fe30000 size: 000000000000f3d1 end: 000000007fe3f3d1 type: 4
copy_e820_map() start: 000000007ff10000 size: 0000000000020000 end: 000000007ff30000 type: 2
copy_e820_map() start: 000000007ff30000 size: 0000000000010000 end: 000000007ff40000 type: 3
copy_e820_map() start: 000000007ff40000 size: 00000000000b0000 end: 000000007fff0000 type: 4
copy_e820_map() start: 000000007fff0000 size: 0000000000010000 end: 0000000080000000 type: 2
copy_e820_map() start: 00000000fecf0000 size: 0000000000001000 end: 00000000fecf1000 type: 2
copy_e820_map() start: 00000000fed20000 size: 0000000000080000 end: 00000000feda0000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe30000 (usable)
 BIOS-e820: 000000007fe30000 - 000000007fe3f3d1 (ACPI NVS)
 BIOS-e820: 000000007ff10000 - 000000007ff30000 (reserved)
 BIOS-e820: 000000007ff30000 - 000000007ff40000 (ACPI data)
 BIOS-e820: 000000007ff40000 - 000000007fff0000 (ACPI NVS)
 BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fecf0000 - 00000000fecf1000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
1150MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 523824) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   523824
early_node_map[1] active PFN ranges
    0:        0 ->   523824
On node 0 totalpages: 523824
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2300 pages used for memmap
  HighMem zone: 292148 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000F61B0, 0014 (r0 ACPIAM)
ACPI: RSDT 7FF30000, 0034 (r1 INTEL  D875BZLK 20050331 MSFT       97)
ACPI: FACP 7FF30200, 0081 (r2 INTEL  D875BZLK 20050331 MSFT       97)
ACPI: DSDT 7FF30370, 4118 (r1 INTEL  D875BZLK        1 MSFT  100000D)
ACPI: FACS 7FF40000, 0040
ACPI: APIC 7FF30300, 0068 (r1 INTEL  D875BZLK 20050331 MSFT       97)
ACPI: ASF! 7FF34490, 0099 (r16 LEGEND I865PASF        1 MSFT  100000D)
ACPI: WDDT 7FF34529, 0040 (r1 INTEL  OEMWDDT         1 MSFT  100000D)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ecf0000)
Detected 2992.669 MHz processor.
Built 1 zonelists.  Total pages: 519732
Kernel command line: root=/dev/sda1 console=tty0 console=ttyS0,115200n8 debug
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c05c8000 soft=c05c0000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2071604k/2095296k available (3312k kernel code, 22520k reserved, 1264k data, 240k init, 1177792k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc057f000 - 0xc05bb000   ( 240 kB)
      .data : 0xc043c3f3 - 0xc05787b0   (1264 kB)
      .text : 0xc0100000 - 0xc043c3f3   (3312 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 5989.41 BogoMIPS (lpj=11978830)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 621 Objects with 51 Devices 170 Methods 22 Regions
 tbxface-0586 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c05c9000 soft=c05c1000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5985.46 BogoMIPS (lpj=11970932)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
Total of 2 processors activated (11974.88 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
migration_cost=42
PM: Adding info for No Bus:platform
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 9 Wake, Enabled 0 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:....................................................................................
Initialized 21/22 Regions 29/29 Fields 47/47 Buffers 17/17 Packages (630 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 0 _STA executions (examined 55 objects)
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
PM: Adding info for acpi:acpi_system:00
PM: Adding info for acpi:button_power:00
PM: Adding info for acpi:ACPI0007:00
PM: Adding info for acpi:ACPI0007:01
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0A03:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:PNP0F03:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0700:00
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:PNP0400:00
PM: Adding info for acpi:power_resource:00
PM: Adding info for acpi:power_resource:01
PM: Adding info for acpi:power_resource:02
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:INT0800:00
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
PM: Adding info for acpi:device:19
PM: Adding info for acpi:PNP0C01:00
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0C0E:00
PM: Adding info for acpi:thermal:00
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PM: Adding info for No Bus:pci0000:00
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH4 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:01.0
PM: Adding info for pci:0000:00:03.0
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.3
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.1
PM: Adding info for pci:0000:00:1f.2
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:01:00.0
PM: Adding info for pci:0000:02:01.0
PM: Adding info for pci:0000:03:02.0
PM: Adding info for pci:0000:03:04.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:09
PM: Adding info for pnp:00:0a
PM: Adding info for pnp:00:0b
PM: Adding info for pnp:00:0c
PM: Adding info for pnp:00:0d
pnp: PnP ACPI: found 14 devices
PnPBIOS: Disabled by ACPI PNP
SCSI subsystem initialized
libata version 2.10 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:0c: ioport range 0x400-0x47f has been reserved
pnp: 00:0c: ioport range 0x680-0x6ff has been reserved
pnp: 00:0c: ioport range 0x500-0x53f has been reserved
pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
pnp: 00:0c: iomem range 0xfed20000-0xfed9ffff has been reserved
pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0d: iomem range 0xc0000-0xdffff could not be reserved
pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0d: iomem range 0x100000-0x7fffffff could not be reserved
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PCI: Bridge: 0000:00:01.0
  IO window: 8000-8fff
  MEM window: ff800000-ff8fffff
  PREFETCH window: f0000000-f7ffffff
PCI: Bridge: 0000:00:03.0
  IO window: 9000-9fff
  MEM window: ff900000-ff9fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: a000-bfff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
PM: Adding info for No Bus:microcode
PM: Adding info for platform:microcode
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
PM: Adding info for platform:pcspkr
PM: Adding info for No Bus:snapshot
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PM: Adding info for platform:vesafb.0
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports 8 throttling states)
PM: Adding info for No Bus:pnp1
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:ptyp0
PM: Adding info for No Bus:ptyp1
PM: Adding info for No Bus:ptyp2
PM: Adding info for No Bus:ptyp3
PM: Adding info for No Bus:ptyp4
PM: Adding info for No Bus:ptyp5
PM: Adding info for No Bus:ptyp6
PM: Adding info for No Bus:ptyp7
PM: Adding info for No Bus:ptyp8
PM: Adding info for No Bus:ptyp9
PM: Adding info for No Bus:ptypa
PM: Adding info for No Bus:ptypb
PM: Adding info for No Bus:ptypc
PM: Adding info for No Bus:ptypd
PM: Adding info for No Bus:ptype
PM: Adding info for No Bus:ptypf
PM: Adding info for No Bus:ptyq0
PM: Adding info for No Bus:ptyq1
PM: Adding info for No Bus:ptyq2
PM: Adding info for No Bus:ptyq3
PM: Adding info for No Bus:ptyq4
PM: Adding info for No Bus:ptyq5
PM: Adding info for No Bus:ptyq6
PM: Adding info for No Bus:ptyq7
PM: Adding info for No Bus:ptyq8
PM: Adding info for No Bus:ptyq9
PM: Adding info for No Bus:ptyqa
PM: Adding info for No Bus:ptyqb
PM: Adding info for No Bus:ptyqc
PM: Adding info for No Bus:ptyqd
PM: Adding info for No Bus:ptyqe
PM: Adding info for No Bus:ptyqf
PM: Adding info for No Bus:ptyr0
PM: Adding info for No Bus:ptyr1
PM: Adding info for No Bus:ptyr2
PM: Adding info for No Bus:ptyr3
PM: Adding info for No Bus:ptyr4
PM: Adding info for No Bus:ptyr5
PM: Adding info for No Bus:ptyr6
PM: Adding info for No Bus:ptyr7
PM: Adding info for No Bus:ptyr8
PM: Adding info for No Bus:ptyr9
PM: Adding info for No Bus:ptyra
PM: Adding info for No Bus:ptyrb
PM: Adding info for No Bus:ptyrc
PM: Adding info for No Bus:ptyrd
PM: Adding info for No Bus:ptyre
PM: Adding info for No Bus:ptyrf
PM: Adding info for No Bus:ptys0
PM: Adding info for No Bus:ptys1
PM: Adding info for No Bus:ptys2
PM: Adding info for No Bus:ptys3
PM: Adding info for No Bus:ptys4
PM: Adding info for No Bus:ptys5
PM: Adding info for No Bus:ptys6
PM: Adding info for No Bus:ptys7
PM: Adding info for No Bus:ptys8
PM: Adding info for No Bus:ptys9
PM: Adding info for No Bus:ptysa
PM: Adding info for No Bus:ptysb
PM: Adding info for No Bus:ptysc
PM: Adding info for No Bus:ptysd
PM: Adding info for No Bus:ptyse
PM: Adding info for No Bus:ptysf
PM: Adding info for No Bus:ptyt0
PM: Adding info for No Bus:ptyt1
PM: Adding info for No Bus:ptyt2
PM: Adding info for No Bus:ptyt3
PM: Adding info for No Bus:ptyt4
PM: Adding info for No Bus:ptyt5
PM: Adding info for No Bus:ptyt6
PM: Adding info for No Bus:ptyt7
PM: Adding info for No Bus:ptyt8
PM: Adding info for No Bus:ptyt9
PM: Adding info for No Bus:ptyta
PM: Adding info for No Bus:ptytb
PM: Adding info for No Bus:ptytc
PM: Adding info for No Bus:ptytd
PM: Adding info for No Bus:ptyte
PM: Adding info for No Bus:ptytf
PM: Adding info for No Bus:ptyu0
PM: Adding info for No Bus:ptyu1
PM: Adding info for No Bus:ptyu2
PM: Adding info for No Bus:ptyu3
PM: Adding info for No Bus:ptyu4
PM: Adding info for No Bus:ptyu5
PM: Adding info for No Bus:ptyu6
PM: Adding info for No Bus:ptyu7
PM: Adding info for No Bus:ptyu8
PM: Adding info for No Bus:ptyu9
PM: Adding info for No Bus:ptyua
PM: Adding info for No Bus:ptyub
PM: Adding info for No Bus:ptyuc
PM: Adding info for No Bus:ptyud
PM: Adding info for No Bus:ptyue
PM: Adding info for No Bus:ptyuf
PM: Adding info for No Bus:ptyv0
PM: Adding info for No Bus:ptyv1
PM: Adding info for No Bus:ptyv2
PM: Adding info for No Bus:ptyv3
PM: Adding info for No Bus:ptyv4
PM: Adding info for No Bus:ptyv5
PM: Adding info for No Bus:ptyv6
PM: Adding info for No Bus:ptyv7
PM: Adding info for No Bus:ptyv8
PM: Adding info for No Bus:ptyv9
PM: Adding info for No Bus:ptyva
PM: Adding info for No Bus:ptyvb
PM: Adding info for No Bus:ptyvc
PM: Adding info for No Bus:ptyvd
PM: Adding info for No Bus:ptyve
PM: Adding info for No Bus:ptyvf
PM: Adding info for No Bus:ptyw0
PM: Adding info for No Bus:ptyw1
PM: Adding info for No Bus:ptyw2
PM: Adding info for No Bus:ptyw3
PM: Adding info for No Bus:ptyw4
PM: Adding info for No Bus:ptyw5
PM: Adding info for No Bus:ptyw6
PM: Adding info for No Bus:ptyw7
PM: Adding info for No Bus:ptyw8
PM: Adding info for No Bus:ptyw9
PM: Adding info for No Bus:ptywa
PM: Adding info for No Bus:ptywb
PM: Adding info for No Bus:ptywc
PM: Adding info for No Bus:ptywd
PM: Adding info for No Bus:ptywe
PM: Adding info for No Bus:ptywf
PM: Adding info for No Bus:ptyx0
PM: Adding info for No Bus:ptyx1
PM: Adding info for No Bus:ptyx2
PM: Adding info for No Bus:ptyx3
PM: Adding info for No Bus:ptyx4
PM: Adding info for No Bus:ptyx5
PM: Adding info for No Bus:ptyx6
PM: Adding info for No Bus:ptyx7
PM: Adding info for No Bus:ptyx8
PM: Adding info for No Bus:ptyx9
PM: Adding info for No Bus:ptyxa
PM: Adding info for No Bus:ptyxb
PM: Adding info for No Bus:ptyxc
PM: Adding info for No Bus:ptyxd
PM: Adding info for No Bus:ptyxe
PM: Adding info for No Bus:ptyxf
PM: Adding info for No Bus:ptyy0
PM: Adding info for No Bus:ptyy1
PM: Adding info for No Bus:ptyy2
PM: Adding info for No Bus:ptyy3
PM: Adding info for No Bus:ptyy4
PM: Adding info for No Bus:ptyy5
PM: Adding info for No Bus:ptyy6
PM: Adding info for No Bus:ptyy7
PM: Adding info for No Bus:ptyy8
PM: Adding info for No Bus:ptyy9
PM: Adding info for No Bus:ptyya
PM: Adding info for No Bus:ptyyb
PM: Adding info for No Bus:ptyyc
PM: Adding info for No Bus:ptyyd
PM: Adding info for No Bus:ptyye
PM: Adding info for No Bus:ptyyf
PM: Adding info for No Bus:ptyz0
PM: Adding info for No Bus:ptyz1
PM: Adding info for No Bus:ptyz2
PM: Adding info for No Bus:ptyz3
PM: Adding info for No Bus:ptyz4
PM: Adding info for No Bus:ptyz5
PM: Adding info for No Bus:ptyz6
PM: Adding info for No Bus:ptyz7
PM: Adding info for No Bus:ptyz8
PM: Adding info for No Bus:ptyz9
PM: Adding info for No Bus:ptyza
PM: Adding info for No Bus:ptyzb
PM: Adding info for No Bus:ptyzc
PM: Adding info for No Bus:ptyzd
PM: Adding info for No Bus:ptyze
PM: Adding info for No Bus:ptyzf
PM: Adding info for No Bus:ptya0
PM: Adding info for No Bus:ptya1
PM: Adding info for No Bus:ptya2
PM: Adding info for No Bus:ptya3
PM: Adding info for No Bus:ptya4
PM: Adding info for No Bus:ptya5
PM: Adding info for No Bus:ptya6
PM: Adding info for No Bus:ptya7
PM: Adding info for No Bus:ptya8
PM: Adding info for No Bus:ptya9
PM: Adding info for No Bus:ptyaa
PM: Adding info for No Bus:ptyab
PM: Adding info for No Bus:ptyac
PM: Adding info for No Bus:ptyad
PM: Adding info for No Bus:ptyae
PM: Adding info for No Bus:ptyaf
PM: Adding info for No Bus:ptyb0
PM: Adding info for No Bus:ptyb1
PM: Adding info for No Bus:ptyb2
PM: Adding info for No Bus:ptyb3
PM: Adding info for No Bus:ptyb4
PM: Adding info for No Bus:ptyb5
PM: Adding info for No Bus:ptyb6
PM: Adding info for No Bus:ptyb7
PM: Adding info for No Bus:ptyb8
PM: Adding info for No Bus:ptyb9
PM: Adding info for No Bus:ptyba
PM: Adding info for No Bus:ptybb
PM: Adding info for No Bus:ptybc
PM: Adding info for No Bus:ptybd
PM: Adding info for No Bus:ptybe
PM: Adding info for No Bus:ptybf
PM: Adding info for No Bus:ptyc0
PM: Adding info for No Bus:ptyc1
PM: Adding info for No Bus:ptyc2
PM: Adding info for No Bus:ptyc3
PM: Adding info for No Bus:ptyc4
PM: Adding info for No Bus:ptyc5
PM: Adding info for No Bus:ptyc6
PM: Adding info for No Bus:ptyc7
PM: Adding info for No Bus:ptyc8
PM: Adding info for No Bus:ptyc9
PM: Adding info for No Bus:ptyca
PM: Adding info for No Bus:ptycb
PM: Adding info for No Bus:ptycc
PM: Adding info for No Bus:ptycd
PM: Adding info for No Bus:ptyce
PM: Adding info for No Bus:ptycf
PM: Adding info for No Bus:ptyd0
PM: Adding info for No Bus:ptyd1
PM: Adding info for No Bus:ptyd2
PM: Adding info for No Bus:ptyd3
PM: Adding info for No Bus:ptyd4
PM: Adding info for No Bus:ptyd5
PM: Adding info for No Bus:ptyd6
PM: Adding info for No Bus:ptyd7
PM: Adding info for No Bus:ptyd8
PM: Adding info for No Bus:ptyd9
PM: Adding info for No Bus:ptyda
PM: Adding info for No Bus:ptydb
PM: Adding info for No Bus:ptydc
PM: Adding info for No Bus:ptydd
PM: Adding info for No Bus:ptyde
PM: Adding info for No Bus:ptydf
PM: Adding info for No Bus:ptye0
PM: Adding info for No Bus:ptye1
PM: Adding info for No Bus:ptye2
PM: Adding info for No Bus:ptye3
PM: Adding info for No Bus:ptye4
PM: Adding info for No Bus:ptye5
PM: Adding info for No Bus:ptye6
PM: Adding info for No Bus:ptye7
PM: Adding info for No Bus:ptye8
PM: Adding info for No Bus:ptye9
PM: Adding info for No Bus:ptyea
PM: Adding info for No Bus:ptyeb
PM: Adding info for No Bus:ptyec
PM: Adding info for No Bus:ptyed
PM: Adding info for No Bus:ptyee
PM: Adding info for No Bus:ptyef
PM: Adding info for No Bus:ttyp0
PM: Adding info for No Bus:ttyp1
PM: Adding info for No Bus:ttyp2
PM: Adding info for No Bus:ttyp3
PM: Adding info for No Bus:ttyp4
PM: Adding info for No Bus:ttyp5
PM: Adding info for No Bus:ttyp6
PM: Adding info for No Bus:ttyp7
PM: Adding info for No Bus:ttyp8
PM: Adding info for No Bus:ttyp9
PM: Adding info for No Bus:ttypa
PM: Adding info for No Bus:ttypb
PM: Adding info for No Bus:ttypc
PM: Adding info for No Bus:ttypd
PM: Adding info for No Bus:ttype
PM: Adding info for No Bus:ttypf
PM: Adding info for No Bus:ttyq0
PM: Adding info for No Bus:ttyq1
PM: Adding info for No Bus:ttyq2
PM: Adding info for No Bus:ttyq3
PM: Adding info for No Bus:ttyq4
PM: Adding info for No Bus:ttyq5
PM: Adding info for No Bus:ttyq6
PM: Adding info for No Bus:ttyq7
PM: Adding info for No Bus:ttyq8
PM: Adding info for No Bus:ttyq9
PM: Adding info for No Bus:ttyqa
PM: Adding info for No Bus:ttyqb
PM: Adding info for No Bus:ttyqc
PM: Adding info for No Bus:ttyqd
PM: Adding info for No Bus:ttyqe
PM: Adding info for No Bus:ttyqf
PM: Adding info for No Bus:ttyr0
PM: Adding info for No Bus:ttyr1
PM: Adding info for No Bus:ttyr2
PM: Adding info for No Bus:ttyr3
PM: Adding info for No Bus:ttyr4
PM: Adding info for No Bus:ttyr5
PM: Adding info for No Bus:ttyr6
PM: Adding info for No Bus:ttyr7
PM: Adding info for No Bus:ttyr8
PM: Adding info for No Bus:ttyr9
PM: Adding info for No Bus:ttyra
PM: Adding info for No Bus:ttyrb
PM: Adding info for No Bus:ttyrc
PM: Adding info for No Bus:ttyrd
PM: Adding info for No Bus:ttyre
PM: Adding info for No Bus:ttyrf
PM: Adding info for No Bus:ttys0
PM: Adding info for No Bus:ttys1
PM: Adding info for No Bus:ttys2
PM: Adding info for No Bus:ttys3
PM: Adding info for No Bus:ttys4
PM: Adding info for No Bus:ttys5
PM: Adding info for No Bus:ttys6
PM: Adding info for No Bus:ttys7
PM: Adding info for No Bus:ttys8
PM: Adding info for No Bus:ttys9
PM: Adding info for No Bus:ttysa
PM: Adding info for No Bus:ttysb
PM: Adding info for No Bus:ttysc
PM: Adding info for No Bus:ttysd
PM: Adding info for No Bus:ttyse
PM: Adding info for No Bus:ttysf
PM: Adding info for No Bus:ttyt0
PM: Adding info for No Bus:ttyt1
PM: Adding info for No Bus:ttyt2
PM: Adding info for No Bus:ttyt3
PM: Adding info for No Bus:ttyt4
PM: Adding info for No Bus:ttyt5
PM: Adding info for No Bus:ttyt6
PM: Adding info for No Bus:ttyt7
PM: Adding info for No Bus:ttyt8
PM: Adding info for No Bus:ttyt9
PM: Adding info for No Bus:ttyta
PM: Adding info for No Bus:ttytb
PM: Adding info for No Bus:ttytc
PM: Adding info for No Bus:ttytd
PM: Adding info for No Bus:ttyte
PM: Adding info for No Bus:ttytf
PM: Adding info for No Bus:ttyu0
PM: Adding info for No Bus:ttyu1
PM: Adding info for No Bus:ttyu2
PM: Adding info for No Bus:ttyu3
PM: Adding info for No Bus:ttyu4
PM: Adding info for No Bus:ttyu5
PM: Adding info for No Bus:ttyu6
PM: Adding info for No Bus:ttyu7
PM: Adding info for No Bus:ttyu8
PM: Adding info for No Bus:ttyu9
PM: Adding info for No Bus:ttyua
PM: Adding info for No Bus:ttyub
PM: Adding info for No Bus:ttyuc
PM: Adding info for No Bus:ttyud
PM: Adding info for No Bus:ttyue
PM: Adding info for No Bus:ttyuf
PM: Adding info for No Bus:ttyv0
PM: Adding info for No Bus:ttyv1
PM: Adding info for No Bus:ttyv2
PM: Adding info for No Bus:ttyv3
PM: Adding info for No Bus:ttyv4
PM: Adding info for No Bus:ttyv5
PM: Adding info for No Bus:ttyv6
PM: Adding info for No Bus:ttyv7
PM: Adding info for No Bus:ttyv8
PM: Adding info for No Bus:ttyv9
PM: Adding info for No Bus:ttyva
PM: Adding info for No Bus:ttyvb
PM: Adding info for No Bus:ttyvc
PM: Adding info for No Bus:ttyvd
PM: Adding info for No Bus:ttyve
PM: Adding info for No Bus:ttyvf
PM: Adding info for No Bus:ttyw0
PM: Adding info for No Bus:ttyw1
PM: Adding info for No Bus:ttyw2
PM: Adding info for No Bus:ttyw3
PM: Adding info for No Bus:ttyw4
PM: Adding info for No Bus:ttyw5
PM: Adding info for No Bus:ttyw6
PM: Adding info for No Bus:ttyw7
PM: Adding info for No Bus:ttyw8
PM: Adding info for No Bus:ttyw9
PM: Adding info for No Bus:ttywa
PM: Adding info for No Bus:ttywb
PM: Adding info for No Bus:ttywc
PM: Adding info for No Bus:ttywd
PM: Adding info for No Bus:ttywe
PM: Adding info for No Bus:ttywf
PM: Adding info for No Bus:ttyx0
PM: Adding info for No Bus:ttyx1
PM: Adding info for No Bus:ttyx2
PM: Adding info for No Bus:ttyx3
PM: Adding info for No Bus:ttyx4
PM: Adding info for No Bus:ttyx5
PM: Adding info for No Bus:ttyx6
PM: Adding info for No Bus:ttyx7
PM: Adding info for No Bus:ttyx8
PM: Adding info for No Bus:ttyx9
PM: Adding info for No Bus:ttyxa
PM: Adding info for No Bus:ttyxb
PM: Adding info for No Bus:ttyxc
PM: Adding info for No Bus:ttyxd
PM: Adding info for No Bus:ttyxe
PM: Adding info for No Bus:ttyxf
PM: Adding info for No Bus:ttyy0
PM: Adding info for No Bus:ttyy1
PM: Adding info for No Bus:ttyy2
PM: Adding info for No Bus:ttyy3
PM: Adding info for No Bus:ttyy4
PM: Adding info for No Bus:ttyy5
PM: Adding info for No Bus:ttyy6
PM: Adding info for No Bus:ttyy7
PM: Adding info for No Bus:ttyy8
PM: Adding info for No Bus:ttyy9
PM: Adding info for No Bus:ttyya
PM: Adding info for No Bus:ttyyb
PM: Adding info for No Bus:ttyyc
PM: Adding info for No Bus:ttyyd
PM: Adding info for No Bus:ttyye
PM: Adding info for No Bus:ttyyf
PM: Adding info for No Bus:ttyz0
PM: Adding info for No Bus:ttyz1
PM: Adding info for No Bus:ttyz2
PM: Adding info for No Bus:ttyz3
PM: Adding info for No Bus:ttyz4
PM: Adding info for No Bus:ttyz5
PM: Adding info for No Bus:ttyz6
PM: Adding info for No Bus:ttyz7
PM: Adding info for No Bus:ttyz8
PM: Adding info for No Bus:ttyz9
PM: Adding info for No Bus:ttyza
PM: Adding info for No Bus:ttyzb
PM: Adding info for No Bus:ttyzc
PM: Adding info for No Bus:ttyzd
PM: Adding info for No Bus:ttyze
PM: Adding info for No Bus:ttyzf
PM: Adding info for No Bus:ttya0
PM: Adding info for No Bus:ttya1
PM: Adding info for No Bus:ttya2
PM: Adding info for No Bus:ttya3
PM: Adding info for No Bus:ttya4
PM: Adding info for No Bus:ttya5
PM: Adding info for No Bus:ttya6
PM: Adding info for No Bus:ttya7
PM: Adding info for No Bus:ttya8
PM: Adding info for No Bus:ttya9
PM: Adding info for No Bus:ttyaa
PM: Adding info for No Bus:ttyab
PM: Adding info for No Bus:ttyac
PM: Adding info for No Bus:ttyad
PM: Adding info for No Bus:ttyae
PM: Adding info for No Bus:ttyaf
PM: Adding info for No Bus:ttyb0
PM: Adding info for No Bus:ttyb1
PM: Adding info for No Bus:ttyb2
PM: Adding info for No Bus:ttyb3
PM: Adding info for No Bus:ttyb4
PM: Adding info for No Bus:ttyb5
PM: Adding info for No Bus:ttyb6
PM: Adding info for No Bus:ttyb7
PM: Adding info for No Bus:ttyb8
PM: Adding info for No Bus:ttyb9
PM: Adding info for No Bus:ttyba
PM: Adding info for No Bus:ttybb
PM: Adding info for No Bus:ttybc
PM: Adding info for No Bus:ttybd
PM: Adding info for No Bus:ttybe
PM: Adding info for No Bus:ttybf
PM: Adding info for No Bus:ttyc0
PM: Adding info for No Bus:ttyc1
PM: Adding info for No Bus:ttyc2
PM: Adding info for No Bus:ttyc3
PM: Adding info for No Bus:ttyc4
PM: Adding info for No Bus:ttyc5
PM: Adding info for No Bus:ttyc6
PM: Adding info for No Bus:ttyc7
PM: Adding info for No Bus:ttyc8
PM: Adding info for No Bus:ttyc9
PM: Adding info for No Bus:ttyca
PM: Adding info for No Bus:ttycb
PM: Adding info for No Bus:ttycc
PM: Adding info for No Bus:ttycd
PM: Adding info for No Bus:ttyce
PM: Adding info for No Bus:ttycf
PM: Adding info for No Bus:ttyd0
PM: Adding info for No Bus:ttyd1
PM: Adding info for No Bus:ttyd2
PM: Adding info for No Bus:ttyd3
PM: Adding info for No Bus:ttyd4
PM: Adding info for No Bus:ttyd5
PM: Adding info for No Bus:ttyd6
PM: Adding info for No Bus:ttyd7
PM: Adding info for No Bus:ttyd8
PM: Adding info for No Bus:ttyd9
PM: Adding info for No Bus:ttyda
PM: Adding info for No Bus:ttydb
PM: Adding info for No Bus:ttydc
PM: Adding info for No Bus:ttydd
PM: Adding info for No Bus:ttyde
PM: Adding info for No Bus:ttydf
PM: Adding info for No Bus:ttye0
PM: Adding info for No Bus:ttye1
PM: Adding info for No Bus:ttye2
PM: Adding info for No Bus:ttye3
PM: Adding info for No Bus:ttye4
PM: Adding info for No Bus:ttye5
PM: Adding info for No Bus:ttye6
PM: Adding info for No Bus:ttye7
PM: Adding info for No Bus:ttye8
PM: Adding info for No Bus:ttye9
PM: Adding info for No Bus:ttyea
PM: Adding info for No Bus:ttyeb
PM: Adding info for No Bus:ttyec
PM: Adding info for No Bus:ttyed
PM: Adding info for No Bus:ttyee
PM: Adding info for No Bus:ttyef
PM: Adding info for No Bus:rtc
Real Time Clock Driver v1.12ac
PM: Adding info for No Bus:hpet
PM: Adding info for No Bus:nvram
Non-volatile memory driver v1.2
toshiba: not a supported Toshiba laptop
PM: Adding info for No Bus:watchdog
i8xx TCO timer: initialized (0x0460). heartbeat=30 sec (nowayout=1)
ipmi message handler version 39.1
ipmi device interface
IPMI Watchdog: driver initialized
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
PM: Removing info for No Bus:ttyS0
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 18 (level, low) -> IRQ 16
PM: Removing info for No Bus:ttyS1
0000:03:04.0: ttyS1 at I/O 0xbc00 (irq = 16) is a 16550A
PM: Adding info for No Bus:ttyS1
PM: Removing info for No Bus:ttyS2
0000:03:04.0: ttyS2 at I/O 0xb400 (irq = 16) is a 16550A
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:isa
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
PM: Adding info for platform:floppy.0
RAMDISK driver initialized: 16 RAM disks of 128000K size 1024 blocksize
loop: loaded (max 8 devices)
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:01.0 to 64
e1000: 0000:02:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:07:e9:64:13:d5
PM: Adding info for No Bus:eth0
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
PM: Adding info for No Bus:lo
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
orinoco_plx 0.15 (Pavel Roskin <proski@gnu.org>, David Gibson <hermes@gibson.dropbear.id.au>, Daniel Barlow <dan@telent.net>)
orinoco_tmd 0.15 (Joerg Dorchain <joerg@dorchain.net>)
airo(): Probing for PCI adapters
airo(): Finished probing for PCI adapters
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH5: IDE controller at PCI slot 0000:00:1f.1
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
ICH5: chipset revision 2
ICH5: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
Probing IDE interface ide0...
Probing IDE interface ide1...
ide-floppy driver 0.99.newide
ata_piix 0000:00:1f.2: version 2.00ac7
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ata1: SATA max UDMA/133 cmd 0x0001ec00 ctl 0x0001e802 bmdma 0x0001dc00 irq 16
ata2: SATA max UDMA/133 cmd 0x0001e400 ctl 0x0001e002 bmdma 0x0001dc08 irq 16
scsi0 : ata_piix
PM: Adding info for No Bus:host0
ata1.00: ATA-6: ST380013AS, 3.05, max UDMA/133
ata1.00: 156301488 sectors, multi 16: LBA48
ata1.00: configured for UDMA/133
scsi1 : ata_piix
PM: Adding info for No Bus:host1
ata2.00: ATAPI, max UDMA/100
ata2.00: configured for UDMA/100
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      ST380013AS       3.05 PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
PM: Adding info for No Bus:target1:0:0
scsi 1:0:0:0: CD-ROM            LITE-ON  COMBO SHC-52S7K  VK03 PQ: 0 ANSI: 5
PM: Adding info for scsi:1:0:0:0
sr0: scsi3-mmc drive: 0x/52x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 17, io base 0x0000cc00
PM: Adding info for usb:usb1
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev1.1_ep81
PM: Adding info for No Bus:usbdev1.1
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 18, io base 0x0000d000
PM: Adding info for usb:usb2
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev2.1_ep81
PM: Adding info for No Bus:usbdev2.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 16, io base 0x0000d400
PM: Adding info for usb:usb3
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev3.1_ep81
PM: Adding info for No Bus:usbdev3.1
ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 17, io base 0x0000d800
PM: Adding info for usb:usb4
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev4.1_ep81
PM: Adding info for No Bus:usbdev4.1
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
usbcore: registered new interface driver belkin
drivers/usb/serial/belkin_sa.c: USB Belkin Serial converter driver v1.2
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
PM: Adding info for serio:serio0
PM: Adding info for serio:serio1
PM: Adding info for No Bus:psaux
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
input: ImExPS/2 Generic Explorer Mouse as /class/input/input2
i2c /dev entries driver
Advanced Linux Sound Architecture Driver Version 1.0.14rc2 (Wed Feb 14 07:42:13 2007 UTC).
PM: Adding info for No Bus:timer
PM: Adding info for platform:snd_dummy.0
PM: Adding info for No Bus:pcmC0D0p
PM: Adding info for No Bus:pcmC0D0c
PM: Adding info for No Bus:controlC0
ALSA device list:
  #0: Dummy 1
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
PM: Adding info for No Bus:sit0
NET: Registered protocol family 17
Starting balanced_irq
Using IPI No-Shortcut mode
ACPI: (supports S0 S1 S3 S4 S5)
Time: tsc clocksource has been installed.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 240k freed
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
INIT: version 2.86 booting
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
                Welcome to Red Hat Enterprise Linux Server
                Press 'I' to enter interactive startup.
Setting clock  (utc): Thu Feb 15 17:17:08 EST 2007 [  OK  ]
Starting udev: [  OK  ]
Loading default keymap (us): [  OK  ]
Setting hostname d875pbz:  [  OK  ]
raidautorun: failed to open /dev/md0: No such device or address
Setting up Logical Volume Management:   No volume groups found
[  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda1
/: clean, 117919/19281504 files, 1228168/19273983 blocks
[  OK  ]
Remounting root filesystem in read-write mode:  [  OK  ]
Mounting local filesystems:  [  OK  ]
Enabling local filesystem quotas:  [  OK  ]
Enabling /etc/fstab swaps:  [  OK  ]
INIT: Entering runlevel: 5
Entering non-interactive startup
Applying Intel CPU microcode update: FATAL: Module microcode not found.
ERROR: Module microcode does not exist in /proc/modules

Starting background readahead: [  OK  ]
Checking for hardware changes [  OK  ]
Applying ip6tables firewall rules: modprobe: FATAL: Module ip6_tables not found.

ip6tables-restore v1.3.5: ip6tables-restore: unable to initializetable 'filter'

Error occurred at line: 3
Try `ip6tables-restore -h' or 'ip6tables-restore --help' for more information.
[FAILED]
Applying iptables firewall rules: modprobe: FATAL: Module ip_tables not found.

iptables-restore v1.3.5: iptables-restore: unable to initializetable 'filter'

Error occurred at line: 3
Try `iptables-restore -h' or 'iptables-restore --help' for more information.
[FAILED]
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
*pde = 3747c001
Oops: 0000 [#1]
SMP
Modules linked in: dm_mod video thermal sbs i2c_ec fan button dock battery asus_acpi ac lp intel_agp agpgart ehci_hcd parport_serial parpt
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010246   (2.6.20-g724339d7 #32)
EIP is at _stext+0x3fefed10/0x14
eax: c21cd3a0   ebx: f8840000   ecx: 00000000   edx: c22d2e44
esi: c21cd3a0   edi: 00000000   ebp: c21cd564   esp: f755de6c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process ip (pid: 2975, ti=f755d000 task=f75590b0 task.ti=f755d000)
Stack: c02a2077 fffffff4 f7987404 00000000 c02a1fc3 c0140cb5 00000010 012321b4
       c21cd3a0 c21cd000 c21cd000 00000000 c02a1a71 c21cd000 c21cd000 c21cd3a0
       00000000 c21cd3a0 00000000 c02a4916 c21cd000 00001003 00001002 c03b3751
Call Trace:
 [<c02a2077>] e1000_intr+0xb4/0x107
 [<c02a1fc3>] e1000_intr+0x0/0x107
 [<c0140cb5>] request_irq+0xa5/0xcc
 [<c02a1a71>] e1000_request_irq+0xad/0xe6
 [<c02a4916>] e1000_open+0x43/0xbd
 [<c03b3751>] dev_open+0x2b/0x62
 [<c03b224d>] dev_change_flags+0x47/0xe4
 [<c03eb20e>] devinet_ioctl+0x250/0x56d
 [<c03b3348>] dev_ifsioc+0x113/0x38d
 [<c021f4ee>] copy_to_user+0x2d/0x43
 [<c03a9a28>] sock_ioctl+0x19f/0x1be
 [<c03a9889>] sock_ioctl+0x0/0x1be
 [<c0168767>] do_ioctl+0x1f/0x62
 [<c01689ee>] vfs_ioctl+0x244/0x256
 [<c0168a33>] sys_ioctl+0x33/0x4c
 [<c0103d88>] sysenter_past_esp+0x5d/0x81
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] _stext+0x3fefed10/0x14 SS:ESP 0068:f755de6c
/etc/sysconfig/network-scripts/ifup-eth: line 272:  2975 Segmentation fault      ip link set dev ${REALDEVICE} up
Failed to bring up eth0.
[FAILED]

 CTRL-A Z for help |115200 8N1 | NOR | Minicom 2.2    | VT102 | Online 00:02

--Boundary-00=_35N1FFzRvdwGiYr--
