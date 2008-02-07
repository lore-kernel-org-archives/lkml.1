Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYBGKfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYBGKfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759301AbYBGKfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:35:32 -0500
Received: from mailrelay.cs.kuleuven.be ([134.58.40.3]:58283 "EHLO
	hermes.cs.kuleuven.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266AbYBGKf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:35:26 -0500
X-Greylist: delayed 1430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2008 05:35:26 EST
Message-ID: <47AAD92D.7040601@huygens.biz>
Date: Thu, 07 Feb 2008 11:10:53 +0100
From: Christophe Huygens <xtof@huygens.biz>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Cardbus/Yenta/PCI/2.6.24 help
Content-Type: multipart/mixed;
 boundary="------------080900010101010900050603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080900010101010900050603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have a problem getting a PCI to Cardbus adapter to work on a dell
1550 server. I have been truying for days to get this going but
I cannot figure out what is wrong. As far as I understand, all
should be ok in terms ok irqs, and resource windows., PCI..
This machine has 2G memory and 2 CPUs.
Running 2.6.22-14-generic, same problem on 2.6.24.

But upon card insertion... nil happens. PCI slot, adapter
and cards are ganuaranteed healthy.

None of the kernel boot options help imho.

Yenta reports a troublesome (?) socket status:

[  170.575520] Yenta: CardBus bridge found at 0000:02:06.0 [0000:0000]
[  170.707652] Yenta: ISA IRQ mask 0x0000, PCI irq 16
[  170.707708] Socket status: ffffffff

Thanks for any assistance, I am running out of steam here!
Attached lspci, dmesg, io*

Christophe


xtof@rover1:~$ lspci
00:00.0 Host bridge: Broadcom CNB20HE Host Bridge (rev 23)
00:00.1 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
00:00.2 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
00:00.3 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
00:01.0 Ethernet controller: Intel Corporation 82557/8/9 Ethernet Pro 
100 (rev 08)
00:03.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
00:0f.0 ISA bridge: Broadcom OSB4 South Bridge (rev 50)
00:0f.1 IDE interface: Broadcom OSB4 IDE Controller
02:05.0 SCSI storage controller: Adaptec AIC-7899P U160/m (rev 01)
02:05.1 SCSI storage controller: Adaptec AIC-7899P U160/m (rev 01)
02:06.0 CardBus bridge: Ricoh Co Ltd RL5c475 (rev 81)



xtof@rover1:~$ lspci -v
00:00.0 Host bridge: Broadcom CNB20HE Host Bridge (rev 23)
       Flags: fast devsel

00:00.1 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
       Flags: bus master, medium devsel, latency 32

00:00.2 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
       Flags: medium devsel

00:00.3 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
       Flags: medium devsel

00:01.0 Ethernet controller: Intel Corporation 82557/8/9 Ethernet Pro 
100 (rev 08)
       Subsystem: Dell Unknown device 00da
       Flags: bus master, medium devsel, latency 32, IRQ 17
       Memory at fe1ff000 (32-bit, non-prefetchable) [size=4K]
       I/O ports at ecc0 [size=64]
       Memory at fe000000 (32-bit, non-prefetchable) [size=1M]
       Capabilities: <access denied>

00:03.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27) 
(prog-if 00 [VGA])
       Subsystem: Dell Unknown device 00df
       Flags: bus master, VGA palette snoop, stepping, medium devsel, 
latency 32
       Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
       I/O ports at e800 [size=256]
       Memory at fe1fe000 (32-bit, non-prefetchable) [size=4K]
       [virtual] Expansion ROM at 80000000 [disabled] [size=128K]
       Capabilities: <access denied>

00:0f.0 ISA bridge: Broadcom OSB4 South Bridge (rev 50)
       Subsystem: Broadcom OSB4 South Bridge
       Flags: bus master, medium devsel, latency 0

00:0f.1 IDE interface: Broadcom OSB4 IDE Controller (prog-if 8a [Master 
SecP PriP])
       Flags: bus master, medium devsel, latency 64
       [virtual] Memory at 000001f0 (32-bit, non-prefetchable) 
[disabled] [size=8]
       [virtual] Memory at 000003f0 (type 3, non-prefetchable) 
[disabled] [size=1]
       [virtual] Memory at 00000170 (32-bit, non-prefetchable) 
[disabled] [size=8]
       [virtual] Memory at 00000370 (type 3, non-prefetchable) 
[disabled] [size=1]
       I/O ports at 08b0 [size=16]

02:05.0 SCSI storage controller: Adaptec AIC-7899P U160/m (rev 01)
       Subsystem: Dell Unknown device 00df
       Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
       BIST result: 00
       I/O ports at dc00 [disabled] [size=256]
       Memory at feaff000 (64-bit, non-prefetchable) [size=4K]
       Expansion ROM at feb00000 [disabled] [size=128K]
       Capabilities: <access denied>

02:05.1 SCSI storage controller: Adaptec AIC-7899P U160/m (rev 01)
       Subsystem: Dell Unknown device 00df
       Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 19
       BIST result: 00
       I/O ports at d800 [disabled] [size=256]
       Memory at feafe000 (64-bit, non-prefetchable) [size=4K]
       Expansion ROM at 80020000 [disabled] [size=128K]
       Capabilities: <access denied>

02:06.0 CardBus bridge: Ricoh Co Ltd RL5c475 (rev 81)
       Flags: bus master, medium devsel, latency 168, IRQ 16
       Memory at 80040000 (32-bit, non-prefetchable) [size=4K]
       Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
       Memory window 0: 84000000-87fff000 (prefetchable)
       Memory window 1: 88000000-8bfff000
       I/O window 0: 00001000-000010ff
       I/O window 1: 00001400-000014ff
       16-bit legacy interface ports at 0001

xtof@rover1:~$ dmesg
[    0.000000] Linux version 2.6.22-14-generic (buildd@terranova) (gcc 
version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Fri 
Feb 1 04:59:50 UTC 2008 (Ubuntu 2.6.22-14.51-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  BIOS-e820: 000000007fff0000 - 000000007fffec00 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fffec00 - 000000007ffff000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000fe710
[    0.000000] Entering add_active_range(0, 0, 524272) 0 entries of 256 
used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   524272
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   524272
[    0.000000] On node 0 totalpages: 524272
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2303 pages used for memmap
[    0.000000]   HighMem zone: 292593 pages, LIFO batch:31
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP signature @ 0xC00FDCD0 checksum 0
[    0.000000] ACPI: RSDP 000FDCD0, 0014 (r0 DELL  )
[    0.000000] ACPI: RSDT 000FDCE4, 002C (r1 DELL   PA1550          1 
MSFT  100000A)
[    0.000000] ACPI: FACP 000FDD10, 0074 (r1 DELL   PA1550          1 
MSFT  100000A)
[    0.000000] ACPI: DSDT 7FFF0000, 2400 (r1 DELL   PA1550          1 
MSFT  100000A)
[    0.000000] ACPI: FACS 7FFFFC00, 0040
[    0.000000] ACPI: APIC 000FDD84, 0060 (r1 DELL   PA1550          1 
MSFT  100000A)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:11 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:11 APIC version 17
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 
0-15
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 
16-31
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 2 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 
7ffff000:7ec01000)
[    0.000000] Built 1 zonelists.  Total pages: 520177
[    0.000000] Kernel command line: 
root=UUID=8c6817e8-b0da-4d4b-8864-107903f1a6e9 ro reserve=00001000,000014ff
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] mapped IOAPIC to ffffb000 (fec01000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1130.491 MHz processor.
[  127.524123] Console: colour VGA+ 80x25
[  127.527198] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[  127.528892] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[  127.729679] Memory: 2067712k/2097088k available (2015k kernel code, 
28008k reserved, 916k data, 364k init, 1179584k highmem)
[  127.729771] virtual kernel memory layout:
[  127.729773]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[  127.729776]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[  127.729778]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[  127.729781]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[  127.729784]       .init : 0xc03e3000 - 0xc043e000   ( 364 kB)
[  127.729786]       .data : 0xc02f7e66 - 0xc03dce84   ( 916 kB)
[  127.729789]       .text : 0xc0100000 - 0xc02f7e66   (2015 kB)
[  127.730154] Checking if this processor honours the WP bit even in 
supervisor mode... Ok.
[  127.730339] SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, 
CPUs=2, Nodes=1
[  127.810362] Calibrating delay using timer specific routine.. 2262.30 
BogoMIPS (lpj=4524611)
[  127.810519] Security Framework v1.0.0 initialized
[  127.810586] SELinux:  Disabled at boot.
[  127.810665] Mount-cache hash table entries: 512
[  127.811030] CPU: After generic identify, caps: 0383fbff 00000000 
00000000 00000000 00000000 00000000 00000000
[  127.811054] CPU: L1 I cache: 16K, L1 D cache: 16K
[  127.811132] CPU: L2 cache: 512K
[  127.811181] CPU: After all inits, caps: 0383fbff 00000000 00000000 
00000040 00000000 00000000 00000000
[  127.811203] Compat vDSO mapped to ffffe000.
[  127.811271] Checking 'hlt' instruction... OK.
[  127.826526] SMP alternatives: switching to UP code
[  127.827293] Early unpacking initramfs... done
[  128.328834] ACPI: Core revision 20070126
[  128.329005] ACPI: Looking for DSDT in initramfs... error, file 
/DSDT.aml not found.
[  128.331555] CPU0: Intel(R) Pentium(R) III CPU family      1133MHz 
stepping 01
[  128.331699] SMP alternatives: switching to SMP code
[  128.331956] Booting processor 1/0 eip 3000
[  128.342237] Initializing CPU#1
[  128.421829] Calibrating delay using timer specific routine.. 2261.09 
BogoMIPS (lpj=4522189)
[  128.421842] CPU: After generic identify, caps: 0383fbff 00000000 
00000000 00000000 00000000 00000000 00000000
[  128.421857] CPU: L1 I cache: 16K, L1 D cache: 16K
[  128.421861] CPU: L2 cache: 512K
[  128.421866] CPU: After all inits, caps: 0383fbff 00000000 00000000 
00000040 00000000 00000000 00000000
[  128.422330] CPU1: Intel(R) Pentium(R) III CPU family      1133MHz 
stepping 01
[  128.422654] Total of 2 processors activated (4523.40 BogoMIPS).
[  128.423025] ENABLING IO-APIC IRQs
[  128.423321] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[  128.569915] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[  128.590006] Brought up 2 CPUs
[  128.889692] migration_cost=1199
[  128.890098] Booting paravirtualized kernel on bare hardware
[  128.890268] Time:  9:04:41  Date: 01/06/108
[  128.890355] NET: Registered protocol family 16
[  128.890571] EISA bus registered
[  128.890621] ACPI: bus type pci registered
[  128.891744] PCI: PCI BIOS revision 2.10 entry at 0xfcb7e, last bus=2
[  128.891796] PCI: Using configuration type 1
[  128.891841] Setting up standard PCI resources
[  128.894493] ACPI: EC: Look up EC in DSDT
[  128.897505] ACPI: Interpreter enabled
[  128.897555] ACPI: (supports S0 S4 S5)
[  128.897723] ACPI: Using IOAPIC for interrupt routing
[  128.905022] ACPI: PCI Root Bridge [PCI0] (0000:00)
[  128.905100] PCI: Probing PCI hardware (bus 00)
[  128.905298] PCI: Firmware left 0000:00:01.0 e100 interrupts enabled, 
disabling
[  128.905543] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[  128.906817] ACPI: PCI Root Bridge [PCI1] (0000:01)
[  128.906888] PCI: Probing PCI hardware (bus 01)
[  128.906999] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
[  128.907285] ACPI: PCI Root Bridge [PCI2] (0000:02)
[  128.907356] PCI: Probing PCI hardware (bus 02)
[  128.907632] ACPI: PCI Interrupt Routing Table [\_SB_.PCI2._PRT]
[  128.908383] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 *11 
12 14)
[  128.908953] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.909660] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.910294] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.910928] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.911564] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.912200] ACPI: PCI Interrupt Link [LNK6] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.912835] ACPI: PCI Interrupt Link [LNK7] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.913513] ACPI: PCI Interrupt Link [LNK8] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.914147] ACPI: PCI Interrupt Link [LNK9] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.914779] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.915413] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 
12 14)
[  128.915984] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11 
12 14)
[  128.916551] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.917197] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.917835] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 
12 14) *0, disabled.
[  128.918470] ACPI: PCI Interrupt Link [LUSB] (IRQs 3 4 5 6 7 10 11 12 
14) *0, disabled.
[  128.919055] Linux Plug and Play Support v0.97 (c) Adam Belay
[  128.919121] pnp: PnP ACPI init
[  128.919180] ACPI: bus type pnp registered
[  128.928058] pnp: PnP ACPI: found 13 devices
[  128.928108] ACPI: ACPI bus type pnp unregistered
[  128.928159] PnPBIOS: Disabled by ACPI PNP
[  128.928310] PCI: Using ACPI for IRQ routing
[  128.928360] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[  128.930898] NET: Registered protocol family 8
[  128.930947] NET: Registered protocol family 20
[  128.931132] pnp: 00:09: ioport range 0x800-0x87f has been reserved
[  128.931183] pnp: 00:09: ioport range 0x880-0x89f has been reserved
[  128.931234] pnp: 00:09: ioport range 0x500-0x501 has been reserved
[  128.931285] pnp: 00:09: ioport range 0x580-0x58f has been reserved
[  128.931336] pnp: 00:09: ioport range 0xc00-0xcd7 has been reserved
[  128.931387] pnp: 00:09: ioport range 0xf50-0xf58 has been reserved
[  128.931453] pnp: 00:0a: iomem range 0x0-0x9ffff could not be reserved
[  128.931504] pnp: 00:0a: iomem range 0x100000-0x7fffffff could not be 
reserved
[  128.931557] pnp: 00:0a: iomem range 0xf0000-0xfffff could not be 
reserved
[  128.931610] pnp: 00:0a: iomem range 0xfec00000-0xfec0ffff could not 
be reserved
[  128.933411] Time: tsc clocksource has been installed.
[  128.962366] PCI: Bus 3, cardbus bridge: 0000:02:06.0
[  128.962415]   IO window: 00001000-000010ff
[  128.962463]   IO window: 00001400-000014ff
[  128.962512]   PREFETCH window: 84000000-87ffffff
[  128.962561]   MEM window: 88000000-8bffffff
[  128.962619] PCI: Enabling device 0000:02:06.0 (0000 -> 0003)
[  128.962680] ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 29 (level, 
low) -> IRQ 16
[  128.962792] NET: Registered protocol family 2
[  129.005423] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[  129.005671] TCP established hash table entries: 131072 (order: 8, 
1572864 bytes)
[  129.011705] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[  129.014002] TCP: Hash tables configured (established 131072 bind 65536)
[  129.014065] TCP reno registered
[  129.025691] checking if image is initramfs...<6>Switched to high 
resolution mode on CPU 1
[  129.463015]  it is
[  129.464965] Switched to high resolution mode on CPU 0
[  129.984555] Freeing initrd memory: 6883k freed
[  129.985361] audit: initializing netlink socket (disabled)
[  129.985439] audit(1202288682.084:1): initialized
[  129.985668] highmem bounce pool size: 64 pages
[  129.990481] VFS: Disk quotas dquot_6.5.1
[  129.990648] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[  129.990916] io scheduler noop registered
[  129.990964] io scheduler anticipatory registered
[  129.991013] io scheduler deadline registered
[  129.991090] io scheduler cfq registered (default)
[  129.991174] Boot video device is 0000:00:03.0
[  129.991472] isapnp: Scanning for PnP cards...
[  130.344567] isapnp: No Plug & Play device found
[  130.399191] Real Time Clock Driver v1.12ac
[  130.400581] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing enabled
[  130.400811] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  130.402103] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[  130.403797] RAMDISK driver initialized: 16 RAM disks of 65536K size 
1024 blocksize
[  130.404356] input: Macintosh mouse button emulation as 
/class/input/input0
[  130.404586] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 
0x60,0x64 irq 1,12
[  130.406661] serio: i8042 KBD port at 0x60,0x64 irq 1
[  130.406714] serio: i8042 AUX port at 0x60,0x64 irq 12
[  130.407001] mice: PS/2 mouse device common for all mice
[  130.407276] EISA: Probing bus 0 at eisa.0
[  130.407330] EISA: Cannot allocate resource for mainboard
[  130.407379] Cannot allocate resource for EISA slot 1
[  130.407465] EISA: Detected 0 cards.
[  130.407712] TCP cubic registered
[  130.407787] NET: Registered protocol family 1
[  130.407882] Using IPI No-Shortcut mode
[  130.408242]   Magic number: 12:888:69
[  130.409027] Freeing unused kernel memory: 364k freed
[  130.436974] input: AT Translated Set 2 keyboard as /class/input/input1
[  130.693504] AppArmor: AppArmor 
initialized<5>audit(1202288682.584:2):  type=1505 info="AppArmor 
initialized" pid=1063
[  130.710134] fuse init (API version 7.8)
[  130.721797] Failure registering capabilities with primary security 
module.
[  131.493354] e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
[  131.493415] e100: Copyright(c) 1999-2006 Intel Corporation
[  131.493535] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, 
low) -> IRQ 17
[  131.515820] e100: eth0: e100_probe: addr 0xfe1ff000, irq 17, MAC addr 
00:06:5B:04:C9:DD
[  131.591319] SCSI subsystem initialized
[  131.608199] libata version 2.21 loaded.
[  131.612586] scsi0 : pata_serverworks
[  131.612722] scsi1 : pata_serverworks
[  131.612811] ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6 
bmdma 0x000108b0 irq 14
[  131.612878] ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376 
bmdma 0x000108b8 irq 15
[  131.672208] Floppy drive(s): fd0 is 1.44M
[  131.711686] FDC 0 is a National Semiconductor PC87306
[  132.042724] ata1.00: ATAPI: SAMSUNG CD-ROM SN-124, q009, max UDMA/33, 
CDB intr
[  132.214533] ata1.00: configured for UDMA/33
[  132.370687] scsi 0:0:0:0: CD-ROM            SAMSUNG  CD-ROM SN-124    
q009 PQ: 0 ANSI: 5
[  132.376963] ACPI: PCI Interrupt 0000:02:05.0[A] -> GSI 27 (level, 
low) -> IRQ 18
[  132.600062] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[  132.600125] Uniform CD-ROM driver Revision: 3.20
[  132.600495] sr 0:0:0:0: Attached scsi CD-ROM sr0
[  132.609339] sr 0:0:0:0: Attached scsi generic sg0 type 5
[  147.575842] scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 
7.0
[  147.575847]         <Adaptec aic7899 Ultra160 SCSI adapter>
[  147.575850]         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 
32/253 SCBs
[  147.575853] [  147.576332] ACPI: PCI Interrupt 0000:02:05.1[B] -> GSI 
28 (level, low) -> IRQ 19
[  147.577570] scsi 2:0:0:0: Direct-Access     SEAGATE  ST373307LC       
DS09 PQ: 0 ANSI: 3
[  147.577653] scsi2:A:0:0: Tagged Queuing enabled.  Depth 8
[  147.577742]  target2:0:0: Beginning Domain Validation
[  147.580778]  target2:0:0: wide asynchronous
[  147.583106]  target2:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, 
offset 63)
[  147.588290]  target2:0:0: Ending Domain Validation
[  148.879359] scsi 2:0:6:0: Processor         DELL     1x3 U2W SCSI BP  
1.19 PQ: 0 ANSI: 2
[  148.879449]  target2:0:6: Beginning Domain Validation
[  148.900738]  target2:0:6: Ending Domain Validation
[  150.961257] scsi 2:0:0:0: Attached scsi generic sg1 type 0
[  150.961424] scsi 2:0:6:0: Attached scsi generic sg2 type 3
[  162.773520] scsi3 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 
7.0
[  162.773525]         <Adaptec aic7899 Ultra160 SCSI adapter>
[  162.773528]         aic7899: Ultra160 Wide Channel B, SCSI Id=7, 
32/253 SCBs
[  162.773531] [  162.805958] sd 2:0:0:0: [sda] 143374650 512-byte 
hardware sectors (73408 MB)
[  162.807173] sd 2:0:0:0: [sda] Write Protect is off
[  162.807223] sd 2:0:0:0: [sda] Mode Sense: ab 00 10 08
[  162.810265] sd 2:0:0:0: [sda] Write cache: disabled, read cache: 
enabled, supports DPO and FUA
[  162.810945] sd 2:0:0:0: [sda] 143374650 512-byte hardware sectors 
(73408 MB)
[  162.812144] sd 2:0:0:0: [sda] Write Protect is off
[  162.812193] sd 2:0:0:0: [sda] Mode Sense: ab 00 10 08
[  162.817572] sd 2:0:0:0: [sda] Write cache: disabled, read cache: 
enabled, supports DPO and FUA
[  162.817651]  sda: sda1 sda2 sda3
[  162.834397] sd 2:0:0:0: [sda] Attached SCSI disk
[  163.100336] Attempting manual resume
[  163.100385] swsusp: Resume From Partition 8:2
[  163.100389] PM: Checking swsusp image.
[  163.100626] PM: Resume from disk failed.
[  163.152439] kjournald starting.  Commit interval 5 seconds
[  163.152463] EXT3-fs: mounted filesystem with ordered data mode.
[  168.568275] e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
[  170.408866] Linux agpgart interface v0.102 (c) Dave Jones
[  170.411747] agpgart: unable to determine aperture size.
[  170.411799] agpgart: agp_backend_initialize() failed.
[  170.411852] agpgart-serverworks: probe of 0000:00:00.0 failed with 
error -22
[  170.411914] agpgart: unable to determine aperture size.
[  170.411961] agpgart: agp_backend_initialize() failed.
[  170.412012] agpgart-serverworks: probe of 0000:00:00.1 failed with 
error -22
[  170.412071] agpgart: ServerWorks CNB20HE is unsupported due to lack 
of documentation.
[  170.412142] agpgart: ServerWorks CNB20HE is unsupported due to lack 
of documentation.
[  170.426419] input: PC Speaker as /class/input/input2
[  170.575520] Yenta: CardBus bridge found at 0000:02:06.0 [0000:0000]
[  170.611315] NET: Registered protocol family 17
[  170.676177] piix4_smbus 0000:00:0f.0: Found 0000:00:0f.0 device
[  170.707652] Yenta: ISA IRQ mask 0x0000, PCI irq 16
[  170.707708] Socket status: ffffffff
[  171.049320] cs: IO port probe 0x100-0x3af: clean.
[  171.052136] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f 
0x4d0-0x4d7
[  171.053414] cs: IO port probe 0x820-0x8ff: clean.
[  171.053880] cs: IO port probe 0xc00-0xcf7: clean.
[  171.054279] cs: IO port probe 0xa00-0xaff: clean.
[  171.360284] input: PS/2 Generic Mouse as /class/input/input3
[  172.029205] loop: module loaded
[  172.100731] lp: driver loaded but no devices found
[  172.265169] Adding 4008208k swap on /dev/sda2.  Priority:-1 extents:1 
across:4008208k
[  172.646431] EXT3 FS on sda1, internal journal
[  173.042473] NET: Registered protocol family 10
[  173.042748] lo: Disabled Privacy Extensions
[  173.266347] kjournald starting.  Commit interval 5 seconds
[  173.273261] EXT3 FS on sda3, internal journal
[  173.273276] EXT3-fs: mounted filesystem with ordered data mode.
[  175.236478] input: Power Button (FF) as /class/input/input4
[  175.237017] ACPI: Power Button (FF) [PWRF]
[  175.366116] No dock devices found.
[  183.445294] eth0: no IPv6 routers present

xtof@rover1:~$ cat /proc/iomem
00000000-0009ffff : System RAM
 00000000-00000000 : Crash kernel
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000cdfff : Adapter ROM
000f0000-000fffff : System ROM
00100000-7ffeffff : System RAM
 00100000-002f7e65 : Kernel code
 002f7e66-003dce83 : Kernel data
7fff0000-7fffebff : ACPI Tables
7fffec00-7fffefff : reserved
80000000-8001ffff : 0000:00:03.0
80020000-8003ffff : 0000:02:05.1
80040000-80040fff : 0000:02:06.0
 80040000-80040fff : yenta_socket
84000000-87ffffff : PCI CardBus #03
88000000-8bffffff : PCI CardBus #03
fd000000-fdffffff : 0000:00:03.0
fe000000-fe0fffff : 0000:00:01.0
 fe000000-fe0fffff : e100
fe1fe000-fe1fefff : 0000:00:03.0
fe1ff000-fe1fffff : 0000:00:01.0
 fe1ff000-fe1fffff : e100
feafe000-feafefff : 0000:02:05.1
 feafe000-feafefff : aic7xxx
feaff000-feafffff : 0000:02:05.0
 feaff000-feafffff : aic7xxx
feb00000-feb1ffff : 0000:02:05.0
fec00000-fec1ffff : reserved
fee00000-fee1ffff : reserved
fff80000-ffffffff : reserved

xtof@rover1:~$ cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:0f.1
 0170-0177 : libata
01f0-01f7 : 0000:00:0f.1
 01f0-01f7 : libata
0200-020b : reserved
0376-0376 : 0000:00:0f.1
 0376-0376 : libata
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:0f.1
 03f6-03f6 : libata
03f7-03f7 : floppy DIR
03f8-03ff : serial
0500-0501 : pnp 00:09
0580-058f : pnp 00:09
 0580-0587 : piix4_smbus
0800-087f : pnp 00:09
 0800-0803 : ACPI PM1b_EVT_BLK
 0808-080b : ACPI PM_TMR
 080c-0813 : ACPI GPE0_BLK
 0844-0847 : ACPI PM1a_EVT_BLK
 0848-0849 : ACPI PM1a_CNT_BLK
 0850-0857 : ACPI GPE1_BLK
0880-089f : pnp 00:09
08b0-08bf : 0000:00:0f.1
 08b0-08bf : libata
0c00-0cd7 : pnp 00:09
0cf8-0cff : PCI conf1
0f50-0f58 : pnp 00:09
1000-10ff : PCI CardBus #03
1400-14ff : PCI CardBus #03
d800-d8ff : 0000:02:05.1
dc00-dcff : 0000:02:05.0
e800-e8ff : 0000:00:03.0
ecc0-ecff : 0000:00:01.0
 ecc0-ecff : e100


--------------080900010101010900050603
Content-Type: text/x-vcard; charset=utf-8;
 name="xtof.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xtof.vcf"

begin:vcard
fn:Christophe Huygens
n:Huygens;Christophe
org:Huygens Consulting, P.S. 23 BVBA
adr:;;Kroegberg 3;Leuven;;3000;Belgium
email;internet:xtof@huygens.biz
tel;cell:+32 496 47 55 64
x-mozilla-html:FALSE
url:www.huygens.biz
version:2.1
end:vcard


--------------080900010101010900050603--
