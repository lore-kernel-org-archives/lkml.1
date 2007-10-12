Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbXJLVSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbXJLVSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 17:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932453AbXJLVSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 17:18:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49600 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758528AbXJLVRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 17:17:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-mm1
Date: Fri, 12 Oct 2007 23:32:40 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Mark Gross <mgross@linux.intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_5f+DHaD0ZsmeLAj"
Message-Id: <200710122332.41944.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_5f+DHaD0ZsmeLAj
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday, 12 October 2007 06:31, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> 
> - I've been largely avoiding applying anything since rc8-mm2 in an attempt
>   to stabilise things for the 2.6.23 merge.
> 
>   But that didn't stop all the subsystem maintainers from going nuts, with
>   the usual accuracy.  We're up to a 37MB diff now, but it seems to be working
>   a bit better.

I get many traces similar to the one below from it (w/ hotfixes):

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

Full dmesg attached.

Greetings,
Rafael

--Boundary-00=_5f+DHaD0ZsmeLAj
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dmesg.log"

Linux version 2.6.23-mm1 (rafael@albercik) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #26 SMP Fri Oct 12 22:59:33 CEST 2007
Command line: root=/dev/sda3 vga=792 resume=/dev/sda1 no_console_suspend
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077fd0000 (usable)
 BIOS-e820: 0000000077fd0000 - 0000000077fe5600 (reserved)
 BIOS-e820: 0000000077fe5600 - 0000000077ff8000 (ACPI NVS)
 BIOS-e820: 0000000077ff8000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
 BIOS-e820: 00000000ffbc0000 - 00000000ffcc0000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 491472) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000F7D30, 0024 (r2 HP    )
ACPI: XSDT 77FE57B4, 0054 (r1 HP     0944      6070620 HP          1)
ACPI: FACP 77FE5684, 00F4 (r4 HP     0944            3 HP          1)
ACPI: DSDT 77FE58DC, EE7A (r1 HP        SB400    10000 MSFT  100000E)
ACPI: FACS 77FF7E80, 0040
ACPI: APIC 77FE5808, 0062 (r1 HP     0944            1 HP          1)
ACPI: MCFG 77FE586C, 003C (r1 HP     0944            1 HP          1)
ACPI: TCPA 77FE58A8, 0032 (r2 HP     0944            1 HP          1)
ACPI: SSDT 77FF4756, 0059 (r1 HP       HPQNLP        1 MSFT  100000E)
ACPI: SSDT 77FF47AF, 0206 (r1 HP     PSSTBLID        1 HP          1)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 491472) 1 entries of 256 used
No mptable found.
sizeof(struct page) = 56
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   491472
On node 0 totalpages: 491375
Node 0 memmap at 0xffff810001000000 size 27525120 first pfn 0xffff810001000000
  DMA zone: 56 pages used for memmap
  DMA zone: 1481 pages reserved
  DMA zone: 2462 pages, LIFO batch:0
  DMA32 zone: 6663 pages used for memmap
  DMA32 zone: 480713 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 46704 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 483175
Kernel command line: root=/dev/sda3 vga=792 resume=/dev/sda1 no_console_suspend
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 1995.006 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
CPU 0: aperture @ 108000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1923916k/1965888k available (2285k kernel code, 41360k reserved, 1517k data, 252k init)
Calibrating delay using timer specific routine.. 3994.14 BogoMIPS (lpj=7988280)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 1153 Objects with 113 Devices 337 Methods 33 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 2 Objects with 0 Devices 2 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 8 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
..MP-BIOS bug: 8254 timer not connected to IO-APIC
Disabling APIC timer
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.29 BogoMIPS (lpj=7980587)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 02
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000001 00000000,00000000,00000000,00000002
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000002 00000000,00000000,00000000,00000001
net_namespace: 120 bytes
Time: 21:13:03  Date: 10/12/07
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x15
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 3 Wake, Enabled 11 Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:................................................................................................................................................................
Initialized 29/33 Regions 0/0 Fields 63/64 Buffers 68/78 Packages (1172 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.......
Executed 7 _INI methods requiring 2 _STA executions (examined 120 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base 3758096384 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: No mmconfig possible on device 00:18
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: PCI Root Bridge [C074] (0000:00)
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.C074._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C074.C075._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C074.C0DF._PRT]
ACPI: PCI Interrupt Link [C125] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C126] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C127] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C128] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C129] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12A] (IRQs 9) *0, disabled.
ACPI: PCI Interrupt Link [C12B] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12C] (IRQs *10 11)
ACPI: Power Resource [C223] (off)
ACPI: Power Resource [C1FE] (off)
ACPI: Power Resource [C217] (on)
ACPI: Power Resource [C34B] (off)
ACPI: Power Resource [C34C] (off)
ACPI: Power Resource [C34D] (off)
ACPI: Power Resource [C34E] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 0 of device 0000:00:14.2
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMAR:No DMAR devices found
ACPI: RTC can wake from S4
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x77ffffff could not be reserved
system 00:0a: ioport range 0x40b-0x40b has been reserved
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
system 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0b: ioport range 0x8000-0x802f has been reserved
system 00:0b: ioport range 0x8100-0x811f has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0c: iomem range 0xcf000-0xcffff has been reserved
system 00:0c: iomem range 0x78000000-0x7fffffff could not be reserved
system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 6000-6fff
  MEM window: d4300000-d43fffff
  PREFETCH window: c0000000-c7ffffff
PCI: Bridge: 0000:00:04.0
  IO window: 4000-5fff
  MEM window: d0000000-d3ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: 2000-3fff
  MEM window: cc000000-cfffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: c8000000-c80fffff
  PREFETCH window: disabled.
PCI: Bus 3, cardbus bridge: 0000:02:04.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 8c000000-8fffffff
  MEM window: 90000000-93ffffff
PCI: Bridge: 0000:00:14.4
  IO window: disabled.
  MEM window: d4000000-d42fffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
NET: Registered protocol family 2
Time: acpi_pm clocksource has been installed.
Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1
 lapic is not functional.
Could not switch to high resolution mode on CPU 0
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 5282k freed
audit: initializing netlink socket (disabled)
audit(1192223582.968:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. MSI deactivated.
Boot video device is 0000:01:05.0
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
Allocate Port Service[0000:00:04.0:pcie03]
PCI: Setting latency timer of device 0000:00:05.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
Allocate Port Service[0000:00:05.0:pcie03]
PCI: Setting latency timer of device 0000:00:06.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
Allocate Port Service[0000:00:06.0:pcie03]
AER service couldn't init device 0000:00:04.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:05.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:06.0:pcie01 - no _OSC support
vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20010100000, using 4608k, total 16384k
vesafb: mode is 1024x768x24, linelength=3072, pages=6
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
RAMDISK driver initialized: 16 RAM disks of 128000K size 1024 blocksize
sata_sil 0000:00:12.0: version 2.3
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xd4409000 tf 0xd4409080 irq 16
ata2: SATA max UDMA/100 mmio m512@0xd4409000 tf 0xd44090c0 irq 16
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: FUJITSU MHV2080BH, 892C, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080B 892C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:C214,PNP0f13:C215] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1
NET: Registered protocol family 1
swsusp: Resume From Partition /dev/sda1
PM: Checking swsusp image.
PM: Resume from disk failed.
registered taskstats version 1
  Magic number: 11:322:247
Freeing unused kernel memory: 252k freed
Write protecting the kernel read-only data: 1124k
sd 0:0:0:0: Attached scsi generic sg0 type 0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ATIIXP: IDE controller (0x1002:0x4376 rev 0x80) at  PCI slot 0000:00:14.1
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
ATIIXP: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x7040-0x7047, BIOS settings: hda:DMA, hdb:pio
ATIIXP: simplex device: DMA disabled
ide1: ATIIXP Bus-Master DMA disabled (BIOS)
Probing IDE interface ide0...
hda: HL-DT-ST DVDRAM GMA-4082N, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: selected mode 0x22
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
Attempting manual resume
swsusp: Resume From Partition 8:1
PM: Checking swsusp image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ieee80211_crypt: registered algorithm 'NULL'
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
Floppy drive(s): fd0 is 1.44M
bcm43xx driver
ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:30:00.0 to 64
bcm43xx: Chip ID 0x4311, rev 0x1
bcm43xx: Number of cores: 4
bcm43xx: Core 0: ID 0x800, rev 0x11, vendor 0x4243
bcm43xx: Core 1: ID 0x812, rev 0xa, vendor 0x4243
bcm43xx: Core 2: ID 0x817, rev 0x3, vendor 0x4243
bcm43xx: Core 3: ID 0x820, rev 0x1, vendor 0x4243
bcm43xx: PHY connected
bcm43xx: Detected PHY: Analog: 4, Type 2, Revision 8
bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
bcm43xx: Radio initialized
bcm43xx: Radio initialized
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
tg3.c:v3.82 (October 5, 2007)
eth0 renamed to eth1
sysfs: duplicate filename 'eth1' can not be created
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/fs/sysfs/dir.c:416 sysfs_add_one()

Call Trace:
 [<ffffffff802da54e>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802db415>] sysfs_create_link+0xd1/0x12c
 [<ffffffff80382e0a>] device_rename+0x17a/0x1db
 [<ffffffff803d6c9d>] dev_change_name+0x13c/0x234
 [<ffffffff803d6f99>] dev_ifsioc+0x204/0x2d0
 [<ffffffff803d7585>] dev_ioctl+0x520/0x633
 [<ffffffff8027ef6a>] handle_mm_fault+0x1f6/0x6e5
 [<ffffffff8030cb16>] __up_read+0x8f/0x97
 [<ffffffff803c9d4d>] sock_ioctl+0x1fe/0x20c
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

net eth1: device_rename: sysfs_create_symlink failed (-17)
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:17:08:2e:2e:f3
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
sdhci: SDHCI controller found at 0000:02:04.3 [104c:803c] (rev 0)
ACPI: PCI Interrupt 0000:02:04.3[A] -> GSI 20 (level, low) -> IRQ 20
mmc0: SDHCI at 0xd4019000 irq 20 PIO
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt 0000:02:04.1[A] -> GSI 20 (level, low) -> IRQ 20
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[d4011000-d40117ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file 'devices'
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:13.2: reset hcs_params 0x2408 dbg=0 cc=2 pcc=4 ordered !ppc ports=8
ehci_hcd 0000:00:13.2: reset hcc_params a012 thresh 1 uframes 256/512/1024
ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:13.2: MWI active
ehci_hcd 0000:00:13.2: irq 19, io mem 0xd4403000
ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: Single TT
hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '001'
usb usb1: new device found, idVendor=0000, idProduct=0000
ehci_hcd 0000:00:13.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.23-mm1 ehci_hcd
usb usb1: SerialNumber: 0000:00:13.2
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
ACPI: PCI Interrupt 0000:02:04.2[A] -> GSI 20 (level, low) -> IRQ 20
Yenta: CardBus bridge found at 0000:02:04.0 [103c:30b0]
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
Yenta: Enabling burst memory read transactions
ohci_hcd 0000:00:13.0: OHCI Host Controller
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '002'
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:13.0: created debug files
ohci_hcd 0000:00:13.0: irq 19, io mem 0xd4401000
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:04.0, mfunc 0x01a11002, devctl 0x64
ehci_hcd 0000:00:13.2: port 2 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 2 not reset yet, waiting 50ms
ohci_hcd 0000:00:13.0: OHCI controller state
ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:13.0: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.0: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.0: hcca frame #0005
ohci_hcd 0000:00:13.0: roothub.a 02000204 POTPGT=2 NPS NDP=4(4)
ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00010100 CSC PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [3] 0x00000100 PPS
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: global over-current protection
hub 2-0:1.0: power on to power good time: 4ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: no over-current condition exists
hub 2-0:1.0: trying to enable port power on non-switchable hub
rtc_cmos: probe of 00:07 failed with error -16
hub 1-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501
Yenta: ISA IRQ mask 0x0eb8, PCI irq 20
ehci_hcd 0000:00:13.2: port 3 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 3 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 3 not reset yet, waiting 50ms
Socket status: 30000006
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '001'
usb usb2: new device found, idVendor=0000, idProduct=0000
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.23-mm1 ohci_hcd
usb usb2: SerialNumber: 0000:00:13.0
ehci_hcd 0000:00:13.2: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
hub 1-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 6 low speed --> companion
pcmcia: parent PCI bridge Memory window: 0xd4000000 - 0xd42fffff
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.1: OHCI Host Controller
ehci_hcd 0000:00:13.2: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0040
hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '003'
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: created debug files
ohci_hcd 0000:00:13.1: irq 19, io mem 0xd4402000
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:13.1: OHCI controller state
ohci_hcd 0000:00:13.1: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:13.1: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.1: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.1: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.1: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.1: hcca frame #0005
ohci_hcd 0000:00:13.1: roothub.a 02000204 POTPGT=2 NPS NDP=4(4)
ohci_hcd 0000:00:13.1: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.1: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.1: roothub.portstatus [0] 0x00010100 CSC PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [2] 0x00010100 CSC PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [3] 0x00000100 PPS
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: global over-current protection
hub 3-0:1.0: power on to power good time: 4ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: no over-current condition exists
hub 3-0:1.0: trying to enable port power on non-switchable hub
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f9929613f0c]
usb 2-2: new full speed USB device using ohci_hcd and address 2
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '001'
usb usb3: new device found, idVendor=0000, idProduct=0000
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.23-mm1 ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
usb 2-2: skipped 1 descriptor after interface
usb 2-2: default language 0x0409
usb 2-2: uevent
usb 2-2: usb_probe_device
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
usb 2-2:1.0: uevent
usb 2-2:1.0: uevent
usb 2-2: adding 2-2:1.1 (config #1, interface 1)
usb 2-2:1.1: uevent
usb 2-2:1.1: uevent
usb 2-2: adding 2-2:1.2 (config #1, interface 2)
usb 2-2:1.2: uevent
usb 2-2:1.2: uevent
usb 2-2: adding 2-2:1.3 (config #1, interface 3)
usb 2-2:1.3: uevent
usb 2-2:1.3: uevent
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '002'
usb 2-2: new device found, idVendor=03f0, idProduct=171d
usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: HP Integrated Module
usb 2-2: Manufacturer: Broadcom Corp
floppy0: no floppy controllers found
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0044
ehci_hcd 0000:00:13.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
Bluetooth: HCI USB driver ver 2.9
ehci_hcd 0000:00:13.2: port 2 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 2 not reset yet, waiting 50ms
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
hub 1-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 6 low speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
hub 3-0:1.0: state 7 ports 4 chg 0000 evt 000a
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
hci_usb 2-2:1.0: usb_probe_interface
hci_usb 2-2:1.0: usb_probe_interface - got id
hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
hci_usb 2-2:1.2: usb_probe_interface
hci_usb 2-2:1.2: usb_probe_interface - got id
hci_usb 2-2:1.3: usb_probe_interface
hci_usb 2-2:1.3: usb_probe_interface - got id
usbcore: registered new interface driver hci_usb
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
usb 3-1: new full speed USB device using ohci_hcd and address 2
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
Bluetooth: RFCOMM socket layer initialized
usb 3-1: ep0 maxpacket = 8
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
usb 3-1: default language 0x0409
usb 3-1: uevent
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: uevent
usb 3-1:1.0: uevent
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '002'
usb 3-1: new device found, idVendor=08ff, idProduct=2580
usb 3-1: new device strings: Mfr=0, Product=1, SerialNumber=0
usb 3-1: Product: Fingerprint Sensor
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00010301 CSC LSDA PPS CCS
hub 3-0:1.0: port 3, status 0301, change 0001, 1.5 Mb/s
hub 3-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x301
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
usb 3-3: new low speed USB device using ohci_hcd and address 3
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
usb 3-3: skipped 1 descriptor after interface
usb 3-3: skipped 1 descriptor after interface
usb 3-3: default language 0x0409
usb 3-3: uevent
usb 3-3: usb_probe_device
usb 3-3: configuration #1 chosen from 1 choice
usb 3-3: adding 3-3:1.0 (config #1, interface 0)
usb 3-3:1.0: uevent
usb 3-3:1.0: uevent
usb 3-3: adding 3-3:1.1 (config #1, interface 1)
usb 3-3:1.1: uevent
usb 3-3:1.1: uevent
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '003'
usb 3-3: new device found, idVendor=046d, idProduct=c521
usb 3-3: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-3: Product: USB Receiver
usb 3-3: Manufacturer: Logitech
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0040
hub 3-0:1.0: state 7 ports 4 chg 0000 evt 0000
usbcore: registered new interface driver hiddev
usbhid 3-3:1.0: usb_probe_interface
usbhid 3-3:1.0: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input2
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-3
usbhid 3-3:1.1: usb_probe_interface
usbhid 3-3:1.1: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input3
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/file.c: looking for a minor, starting at 96
input,hiddev96: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:13.1-3
usbcore: registered new interface driver usbhid
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x25a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input4
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:13.2: suspend root hub
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
Adding 1052216k swap on /dev/sda1.  Priority:-1 extents:1 across:1052216k
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ACPI: AC Adapter [C1BD] (on-line)
ACPI: Battery Slot [C1BF] (battery present)
ACPI: Battery Slot [C1BE] (battery absent)
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [C25A]
input: Lid Switch as /class/input/input7
ACPI: Lid Switch [C25B]
ACPI: Transitioning device [C34F] to D3
ACPI: Transitioning device [C34F] to D3
ACPI: Fan [C34F] (off)
ACPI: Transitioning device [C350] to D3
ACPI: Transitioning device [C350] to D3
ACPI: Fan [C350] (off)
ACPI: Transitioning device [C351] to D3
ACPI: Transitioning device [C351] to D3
ACPI: Fan [C351] (off)
ACPI: Transitioning device [C352] to D3
ACPI: Transitioning device [C352] to D3
ACPI: Fan [C352] (off)
ACPI: Processor [C000] (supports 8 throttling states)
ACPI: Processor [C001] (supports 8 throttling states)
ACPI: Thermal Zone [TZ1] (62 C)
ACPI: Thermal Zone [TZ2] (52 C)
ACPI: Thermal Zone [TZ3] (32 C)
powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-60 processors (2 cpu cores) (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x13
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x15
powernow-k8:    2 : fid 0x8 (1600 MHz), vid 0x17
powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x1e
powernow-k8: ph2 null fid transition 0xc
mtrr: no more MTRRs available
APIC error on CPU1: 00(40)
APIC error on CPU0: 00(40)
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff80270cbe>] find_lock_page+0x2a/0xa6
 [<ffffffff80272bce>] filemap_fault+0x1d3/0x35b
 [<ffffffff80270bab>] unlock_page+0x2d/0x31
 [<ffffffff8027d6ec>] __do_fault+0x38e/0x3c4
 [<ffffffff8027ef6a>] handle_mm_fault+0x1f6/0x6e5
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8024e56b>] up_read+0x9/0xb
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

hda-intel: Invalid position buffer, using LPIB read method instead.
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

ACPI: PCI interrupt for device 0000:30:00.0 disabled
bcm43xx driver
ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:30:00.0 to 64
bcm43xx: Chip ID 0x4311, rev 0x1
bcm43xx: Number of cores: 4
bcm43xx: Core 0: ID 0x800, rev 0x11, vendor 0x4243
bcm43xx: Core 1: ID 0x812, rev 0xa, vendor 0x4243
bcm43xx: Core 2: ID 0x817, rev 0x3, vendor 0x4243
bcm43xx: Core 3: ID 0x820, rev 0x1, vendor 0x4243
bcm43xx: PHY connected
bcm43xx: Detected PHY: Analog: 4, Type 2, Revision 8
bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
bcm43xx: Radio initialized
bcm43xx: Radio initialized
bcm43xx: PHY connected
bcm43xx: Microcode rev 0x127, pl 0xe (2005-04-18  02:36:27)
bcm43xx: Radio turned on
bcm43xx: Radio enabled by hardware
bcm43xx: Chip initialized
bcm43xx: 32-bit DMA initialized
bcm43xx: Keys cleared
bcm43xx: Selected 802.11 core (phytype 2)
ADDRCONF(NETDEV_UP): eth1: link is not ready
SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
SoftMAC: Associate: Scanning for networks first.
SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
SoftMAC: Queueing Authentication Request to 00:17:9a:f3:b5:75
SoftMAC: Cannot associate without being authenticated, requested authentication
SoftMAC: Sent Authentication Request to 00:17:9a:f3:b5:75.
SoftMAC: Open Authentication completed with 00:17:9a:f3:b5:75
SoftMAC: sent association request!
SoftMAC: associated!
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
SFW2-OUT-ERROR IN= OUT=eth1 SRC=0000:0000:0000:0000:0000:0000:0000:0000 DST=ff02:0000:0000:0000:0000:0000:0000:0016 LEN=76 TC=0 HOPLIMIT=1 FLOWLBL=0 OPT ( ) PROTO=ICMPv6 TYPE=143 CODE=0 
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=0000:0000:0000:0000:0000:0000:0000:0000 DST=ff02:0000:0000:0000:0000:0001:ffbe:9531 LEN=64 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=135 CODE=0 
NET: Registered protocol family 17
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0002 LEN=56 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=133 CODE=0 
SoftMAC: Getting essid from req_essid
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=7883 PROTO=2 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0002 LEN=56 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=133 CODE=0 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0002 LEN=56 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=133 CODE=0 
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0016 LEN=76 TC=0 HOPLIMIT=1 FLOWLBL=0 OPT ( ) PROTO=ICMPv6 TYPE=143 CODE=0 
SoftMAC: Getting essid from req_essid
eth1: no IPv6 routers present
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
bcm43xx: Radio initialized
bcm43xx: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx: DMA-32 0x02A0 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0280 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0260 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0240 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0220 (TX) max used slots: 2/512
bcm43xx: DMA-32 0x0200 (TX) max used slots: 0/512
ACPI: PCI interrupt for device 0000:30:00.0 disabled
Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
Suspending device vcsa10
Suspending device vcs10
Suspending device vcsa4
Suspending device vcs4
Suspending device vcsa2
Suspending device vcs2
Suspending device vcsa6
Suspending device vcs6
Suspending device vcsa5
Suspending device vcs5
Suspending device vcsa3
Suspending device vcs3
Suspending device vcsa7
Suspending device vcs7
Suspending device audio
Suspending device dsp
Suspending device mixer
Suspending device event7
Suspending device input7
Suspending device event6
Suspending device input6
Suspending device event5
Suspending device input5
Suspending device seq
Suspending device C1BE
Suspending device C1BF
Suspending device C1BD
Suspending device device-mapper
Suspending device serio5
Suspending device event4
Suspending device mouse1
Suspending device input4
Suspending device hiddev0
Suspending device event3
Suspending device input3
Suspending device event2
Suspending device mouse0
Suspending device input2
Suspending device usbdev3.3
Suspending device usbdev3.3_ep82
Suspending device 3-3:1.1
Suspending device usbdev3.3_ep81
Suspending device 3-3:1.0
Suspending device usbdev3.3_ep00
Suspending device 3-3
usb 3-3: usb suspend
Suspending device usbdev3.2
Suspending device usbdev3.2_ep02
Suspending device usbdev3.2_ep81
Suspending device 3-1:1.0
Suspending device usbdev3.2_ep00
Suspending device 3-1
usb 3-1: usb suspend
Suspending device hci0
Suspending device usbdev2.2_ep03
Suspending device usbdev2.2_ep83
Suspending device bluetooth
Suspending device usbdev2.2
Suspending device 2-2:1.3
Suspending device usbdev2.2_ep04
Suspending device usbdev2.2_ep84
Suspending device 2-2:1.2
Suspending device 2-2:1.1
Suspending device usbdev2.2_ep02
Suspending device usbdev2.2_ep82
Suspending device usbdev2.2_ep81
Suspending device 2-2:1.0
Suspending device usbdev2.2_ep00
Suspending device 2-2
usb 2-2: usb suspend
Suspending device usbdev3.1
Suspending device usbdev3.1_ep81
Suspending device 00023f9929613f0c
Suspending device 00023f9929613f0c
Suspending device 3-0:1.0
Suspending device usbdev3.1_ep00
Suspending device usb3
hub 3-0:1.0: hub_suspend
usb usb3: bus suspend
ohci_hcd 0000:00:13.1: suspend root hub
Suspending device pcmcia_socket0
Suspending device usbdev2.1
Suspending device usbdev2.1_ep81
Suspending device 2-0:1.0
Suspending device usbdev2.1_ep00
Suspending device usb2
hub 2-0:1.0: hub_suspend
usb usb2: bus suspend
ohci_hcd 0000:00:13.0: suspend root hub
Suspending device hwmon0
Suspending device usbdev1.1
Suspending device usbdev1.1_ep81
Suspending device 1-0:1.0
Suspending device usbdev1.1_ep00
Suspending device usb1
Suspending device fw-host0
Suspending device fw-host0
Suspending device mmc0
Suspending device i2c-0
Suspending device eth0
Suspending device controlC0
Suspending device hwC0D0
Suspending device hwC0D1
Suspending device pcmC0D0c
Suspending device pcmC0D0p
Suspending device timer
Suspending device vcsa1
Suspending device vcs1
Suspending device 0.0
Suspending device ide0
Suspending device network_throughput
Suspending device network_latency
Suspending device cpu_dma_latency
Suspending device event1
Suspending device event0
Suspending device input1
Suspending device input0
Suspending device psaux
Suspending device mice
Suspending device serio4
Suspending device serio3
Suspending device serio2
Suspending device serio1
Suspending device serio0
Suspending device i8042
Suspending device 0:0:0:0
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
Suspending device target0:0:0
Suspending device host1
Suspending device host0
Suspending device ttyS3
Suspending device ttyS2
Suspending device ttyS1
Suspending device ttyS0
Suspending device serial8250
Suspending device nvram
Suspending device hpet
Suspending device rtc
Suspending device ttysf
Suspending device ttyse
Suspending device ttysd
Suspending device ttysc
Suspending device ttysb
Suspending device ttysa
Suspending device ttys9
Suspending device ttys8
Suspending device ttys7
Suspending device ttys6
Suspending device ttys5
Suspending device ttys4
Suspending device ttys3
Suspending device ttys2
Suspending device ttys1
Suspending device ttys0
Suspending device ttyrf
Suspending device ttyre
Suspending device ttyrd
Suspending device ttyrc
Suspending device ttyrb
Suspending device ttyra
Suspending device ttyr9
Suspending device ttyr8
Suspending device ttyr7
Suspending device ttyr6
Suspending device ttyr5
Suspending device ttyr4
Suspending device ttyr3
Suspending device ttyr2
Suspending device ttyr1
Suspending device ttyr0
Suspending device ttyqf
Suspending device ttyqe
Suspending device ttyqd
Suspending device ttyqc
Suspending device ttyqb
Suspending device ttyqa
Suspending device ttyq9
Suspending device ttyq8
Suspending device ttyq7
Suspending device ttyq6
Suspending device ttyq5
Suspending device ttyq4
Suspending device ttyq3
Suspending device ttyq2
Suspending device ttyq1
Suspending device ttyq0
Suspending device ttypf
Suspending device ttype
Suspending device ttypd
Suspending device ttypc
Suspending device ttypb
Suspending device ttypa
Suspending device ttyp9
Suspending device ttyp8
Suspending device ttyp7
Suspending device ttyp6
Suspending device ttyp5
Suspending device ttyp4
Suspending device ttyp3
Suspending device ttyp2
Suspending device ttyp1
Suspending device ttyp0
Suspending device ptysf
Suspending device ptyse
Suspending device ptysd
Suspending device ptysc
Suspending device ptysb
Suspending device ptysa
Suspending device ptys9
Suspending device ptys8
Suspending device ptys7
Suspending device ptys6
Suspending device ptys5
Suspending device ptys4
Suspending device ptys3
Suspending device ptys2
Suspending device ptys1
Suspending device ptys0
Suspending device ptyrf
Suspending device ptyre
Suspending device ptyrd
Suspending device ptyrc
Suspending device ptyrb
Suspending device ptyra
Suspending device ptyr9
Suspending device ptyr8
Suspending device ptyr7
Suspending device ptyr6
Suspending device ptyr5
Suspending device ptyr4
Suspending device ptyr3
Suspending device ptyr2
Suspending device ptyr1
Suspending device ptyr0
Suspending device ptyqf
Suspending device ptyqe
Suspending device ptyqd
Suspending device ptyqc
Suspending device ptyqb
Suspending device ptyqa
Suspending device ptyq9
Suspending device ptyq8
Suspending device ptyq7
Suspending device ptyq6
Suspending device ptyq5
Suspending device ptyq4
Suspending device ptyq3
Suspending device ptyq2
Suspending device ptyq1
Suspending device ptyq0
Suspending device ptypf
Suspending device ptype
Suspending device ptypd
Suspending device ptypc
Suspending device ptypb
Suspending device ptypa
Suspending device ptyp9
Suspending device ptyp8
Suspending device ptyp7
Suspending device ptyp6
Suspending device ptyp5
Suspending device ptyp4
Suspending device ptyp3
Suspending device ptyp2
Suspending device ptyp1
Suspending device ptyp0
Suspending device tty63
Suspending device tty62
Suspending device tty61
Suspending device tty60
Suspending device tty59
Suspending device tty58
Suspending device tty57
Suspending device tty56
Suspending device tty55
Suspending device tty54
Suspending device tty53
Suspending device tty52
Suspending device tty51
Suspending device tty50
Suspending device tty49
Suspending device tty48
Suspending device tty47
Suspending device tty46
Suspending device tty45
Suspending device tty44
Suspending device tty43
Suspending device tty42
Suspending device tty41
Suspending device tty40
Suspending device tty39
Suspending device tty38
Suspending device tty37
Suspending device tty36
Suspending device tty35
Suspending device tty34
Suspending device tty33
Suspending device tty32
Suspending device tty31
Suspending device tty30
Suspending device tty29
Suspending device tty28
Suspending device tty27
Suspending device tty26
Suspending device tty25
Suspending device tty24
Suspending device tty23
Suspending device tty22
Suspending device tty21
Suspending device tty20
Suspending device tty19
Suspending device tty18
Suspending device tty17
Suspending device tty16
Suspending device tty15
Suspending device tty14
Suspending device tty13
Suspending device tty12
Suspending device tty11
Suspending device tty10
Suspending device tty9
Suspending device tty8
Suspending device tty7
Suspending device tty6
Suspending device tty5
Suspending device tty4
Suspending device tty3
Suspending device tty2
Suspending device tty1
Suspending device vcsa
Suspending device vcs
Suspending device tty0
Suspending device ptmx
Suspending device console
Suspending device tty
Suspending device vtcon1
Suspending device fb0
Suspending device vesafb.0
Suspending device fbcon
Suspending device 0000:00:06.0:pcie03
Suspending device 0000:00:06.0:pcie01
Suspending device 0000:00:06.0:pcie00
Suspending device 0000:00:05.0:pcie03
Suspending device 0000:00:05.0:pcie01
Suspending device 0000:00:05.0:pcie00
Suspending device 0000:00:04.0:pcie03
Suspending device 0000:00:04.0:pcie01
Suspending device 0000:00:04.0:pcie00
Suspending device snapshot
Suspending device pcspkr
Suspending device mcelog
Suspending device lo
Suspending device kmsg
Suspending device urandom
Suspending device random
Suspending device full
Suspending device zero
Suspending device port
Suspending device null
Suspending device kmem
Suspending device mem
Suspending device 00:0c
ACPI handle has no context!
Suspending device 00:0b
Suspending device 00:0a
Suspending device 00:09
Suspending device 00:08
Suspending device 00:07
Suspending device 00:06
Suspending device 00:05
Suspending device 00:04
Suspending device 00:03
Suspending device 00:02
Suspending device 00:01
Suspending device 00:00
Suspending device pnp0
Suspending device 0000:02
Suspending device 0000:03
Suspending device 0000:02:04.3
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:02:04.3 disabled
ACPI handle has no context!
Suspending device 0000:02:04.2
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:02:04.2 disabled
ACPI handle has no context!
Suspending device 0000:02:04.1
ACPI handle has no context!
Suspending device 0000:02:04.0
Suspending device 0000:02:01.0
Suspending device 0000:30
Suspending device 0000:30:00.0
Suspending device 0000:20
Suspending device 0000:10
Suspending device 0000:01
Suspending device 0000:01:05.0
Suspending device 0000:00:18.3
Suspending device 0000:00:18.2
Suspending device 0000:00:18.1
Suspending device 0000:00:18.0
Suspending device 0000:00:14.4
Suspending device 0000:00:14.3
Suspending device 0000:00:14.2
ACPI: PCI interrupt for device 0000:00:14.2 disabled
Suspending device 0000:00:14.1
Suspending device 0000:00:14.0
Suspending device 0000:00:13.2
ACPI: PCI interrupt for device 0000:00:13.2 disabled
ehci_hcd 0000:00:13.2: --> PCI D3
Suspending device 0000:00:13.1
ACPI: PCI interrupt for device 0000:00:13.1 disabled
ohci_hcd 0000:00:13.1: --> PCI D0/legacy
Suspending device 0000:00:13.0
ACPI: PCI interrupt for device 0000:00:13.0 disabled
ohci_hcd 0000:00:13.0: --> PCI D0/legacy
Suspending device 0000:00:12.0
ACPI: PCI interrupt for device 0000:00:12.0 disabled
Suspending device 0000:00:06.0
Suspending device 0000:00:05.0
Suspending device 0000:00:04.0
Suspending device 0000:00:01.0
Suspending device 0000:00:00.0
Suspending device 0000:00
Suspending device pci0000:00
Suspending device LNXTHERM:03
Suspending device LNXTHERM:02
Suspending device LNXTHERM:01
Suspending device PNP0C0B:03
Suspending device PNP0C0B:02
ACPI: Transitioning device [C351] to D0
ACPI: Transitioning device [C351] to D0
Suspending device PNP0C0B:01
ACPI: Transitioning device [C350] to D0
ACPI: Transitioning device [C350] to D0
Suspending device PNP0C0B:00
ACPI: Transitioning device [C34F] to D0
ACPI: Transitioning device [C34F] to D0
Suspending device LNXPOWER:06
Suspending device LNXPOWER:05
Suspending device LNXPOWER:04
Suspending device LNXPOWER:03
Suspending device LNXTHERM:00
Suspending device PNP0C02:02
Suspending device PNP0C14:00
Suspending device PNP0C0D:00
Suspending device PNP0C0E:00
Suspending device ACPI0003:00
Suspending device PNP0C0A:01
Suspending device PNP0C0A:00
Suspending device HPQ0006:00
Suspending device PNP0C02:01
Suspending device device:49
Suspending device device:48
Suspending device device:47
Suspending device device:46
Suspending device device:45
Suspending device device:44
Suspending device device:43
Suspending device device:42
Suspending device device:41
Suspending device device:40
Suspending device device:3f
Suspending device device:3e
Suspending device device:3d
Suspending device device:3c
Suspending device device:3b
Suspending device device:3a
Suspending device device:39
Suspending device device:38
Suspending device device:37
Suspending device device:36
Suspending device device:35
Suspending device device:34
Suspending device device:33
Suspending device PNP0C0F:07
Suspending device PNP0C0F:06
Suspending device PNP0C0F:05
Suspending device PNP0C0F:04
Suspending device PNP0C0F:03
Suspending device PNP0C0F:02
Suspending device PNP0C0F:01
Suspending device PNP0C0F:00
Suspending device device:32
Suspending device device:31
Suspending device device:30
Suspending device device:2f
Suspending device device:2e
Suspending device device:2d
Suspending device device:2c
Suspending device device:2b
Suspending device device:2a
Suspending device device:29
Suspending device device:28
Suspending device device:27
Suspending device device:26
Suspending device device:25
Suspending device device:24
Suspending device device:23
Suspending device device:22
Suspending device device:21
Suspending device device:20
Suspending device device:1f
Suspending device device:1e
Suspending device device:1d
Suspending device device:1c
Suspending device device:1b
Suspending device device:1a
Suspending device device:19
Suspending device device:18
Suspending device device:17
Suspending device device:16
Suspending device device:15
Suspending device device:14
Suspending device device:13
Suspending device device:12
Suspending device device:11
Suspending device device:10
Suspending device PNP0C02:00
Suspending device PNP0000:00
Suspending device LNXPOWER:02
Suspending device SYN0118:00
Suspending device PNP0303:00
Suspending device PNP0B00:00
Suspending device PNP0800:00
Suspending device PNP0200:00
Suspending device PNP0100:00
Suspending device PNP0C04:00
Suspending device IFX0102:00
Suspending device LNXPOWER:01
Suspending device PNP0401:00
Suspending device PNP0A06:00
Suspending device PNP0C09:00
Suspending device device:0f
Suspending device device:0e
Suspending device LNXPOWER:00
Suspending device device:0d
Suspending device device:0c
Suspending device device:0b
Suspending device device:0a
Suspending device device:09
Suspending device device:08
Suspending device device:07
Suspending device device:06
Suspending device device:05
Suspending device device:04
Suspending device device:03
Suspending device device:02
Suspending device LNXVIDEO:00
Suspending device device:01
Suspending device PNP0A03:00
Suspending device PNP0C01:00
Suspending device device:00
Suspending device ACPI0007:01
Suspending device ACPI0007:00
Suspending device LNXPWRBN:00
Suspending device LNXSYSTM:00
Suspending device id
Suspending device vtcon0
Suspending device platform
Disabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
Cannot set affinity for irq 0
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
 hwsleep-0317 [00] enter_sleep_state     : Entering sleep state [S3]
Back to C!
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:427 smp_call_function_single()

Call Trace:
 [<ffffffff8022ecc6>] task_rq_lock+0x3d/0x6f
 [<ffffffff8021b51b>] smp_call_function_single+0x52/0xa0
 [<ffffffff80232f59>] set_cpus_allowed+0xbf/0xcc
 [<ffffffff80214c61>] sc_freq_event+0x71/0x75
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff803c1b1d>] cpufreq_resume+0x131/0x157
 [<ffffffff80383128>] __sysdev_resume+0x34/0x4a
 [<ffffffff8038366e>] sysdev_resume+0x1f/0x61
 [<ffffffff80388050>] device_power_up+0x9/0x10
 [<ffffffff8025bba4>] suspend_devices_and_enter+0xbf/0xf7
 [<ffffffff8025bd3f>] enter_state+0x163/0x1e5
 [<ffffffff8025be65>] state_store+0xa4/0xc2
 [<ffffffff802d98a1>] subsys_attr_store+0x31/0x33
 [<ffffffff802d9ccd>] sysfs_write_file+0xe0/0x11c
 [<ffffffff80294d07>] vfs_write+0xc7/0x150
 [<ffffffff80295288>] sys_write+0x47/0x70
 [<ffffffff8020bfde>] system_call+0x7e/0x83

Extended CMOS year: 2000
Enabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.28 BogoMIPS (lpj=7980574)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 02
Machine check events logged
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000001 00000000,00000000,00000000,00000002
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000002 00000000,00000000,00000000,00000001
CPU1 is up
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1
ACPI: Transitioning device [C34F] to D3
ACPI: Transitioning device [C34F] to D3
ACPI: Transitioning device [C350] to D3
ACPI: Transitioning device [C350] to D3
ACPI: Transitioning device [C351] to D3
ACPI: Transitioning device [C351] to D3
PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 22206161, writing 2206161)
PM: Writing back config space on device 0000:00:04.0 at offset 9 (was 10001, writing 1fff1)
PM: Writing back config space on device 0000:00:04.0 at offset 8 (was 0, writing d3f0d000)
PM: Writing back config space on device 0000:00:04.0 at offset 7 (was 101, writing 5141)
PM: Writing back config space on device 0000:00:04.0 at offset 3 (was 10000, writing 10010)
PM: Writing back config space on device 0000:00:04.0 at offset 1 (was 100000, writing 100007)
PCI: Setting latency timer of device 0000:00:04.0 to 64
PM: Writing back config space on device 0000:00:05.0 at offset 9 (was 10001, writing 1fff1)
PM: Writing back config space on device 0000:00:05.0 at offset 8 (was 0, writing cff0cc00)
PM: Writing back config space on device 0000:00:05.0 at offset 7 (was 101, writing 3121)
PM: Writing back config space on device 0000:00:05.0 at offset 3 (was 10000, writing 10010)
PM: Writing back config space on device 0000:00:05.0 at offset 1 (was 100000, writing 100007)
PCI: Setting latency timer of device 0000:00:05.0 to 64
PM: Writing back config space on device 0000:00:06.0 at offset 9 (was 10001, writing 1fff1)
PM: Writing back config space on device 0000:00:06.0 at offset 8 (was 0, writing c800c800)
PM: Writing back config space on device 0000:00:06.0 at offset 7 (was 101, writing 1f1)
PM: Writing back config space on device 0000:00:06.0 at offset 3 (was 10000, writing 10010)
PM: Writing back config space on device 0000:00:06.0 at offset 1 (was 100000, writing 100007)
PCI: Setting latency timer of device 0000:00:06.0 to 64
PM: Writing back config space on device 0000:00:12.0 at offset f (was 100, writing 10a)
PM: Writing back config space on device 0000:00:12.0 at offset 3 (was 0, writing 4010)
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:13.0: PCI legacy resume
PCI: Enabling device 0000:00:13.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:13.0 to 64
PM: Writing back config space on device 0000:00:13.0 at offset f (was 100, writing 10b)
PM: Writing back config space on device 0000:00:13.0 at offset 4 (was 0, writing d4401000)
PM: Writing back config space on device 0000:00:13.0 at offset 3 (was 804000, writing 804010)
PM: Writing back config space on device 0000:00:13.0 at offset 1 (was 2b00006, writing 2b00007)
ohci_hcd 0000:00:13.1: PCI legacy resume
PCI: Enabling device 0000:00:13.1 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:13.1 to 64
PM: Writing back config space on device 0000:00:13.1 at offset f (was 100, writing 10b)
PM: Writing back config space on device 0000:00:13.1 at offset 4 (was 0, writing d4402000)
PM: Writing back config space on device 0000:00:13.1 at offset 1 (was 2b00006, writing 2b00007)
ehci_hcd 0000:00:13.2: PCI D0, from previous PCI D3
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:13.2 to 64
PM: Writing back config space on device 0000:00:13.2 at offset f (was 100, writing 10b)
ehci_hcd 0000:00:13.2: lost power, restarting
usb usb1: root hub lost power or was reset
ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:13.2: MWI active
PM: Writing back config space on device 0000:00:14.1 at offset f (was 100, writing 10a)
PM: Writing back config space on device 0000:00:14.1 at offset 8 (was 1, writing 7041)
PM: Writing back config space on device 0000:00:14.1 at offset 3 (was 0, writing 4010)
PM: Writing back config space on device 0000:00:14.1 at offset 1 (was 2300000, writing 2300005)
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
PM: Writing back config space on device 0000:00:14.2 at offset f (was 10a, writing a)
PM: Writing back config space on device 0000:00:14.2 at offset 1 (was 4100000, writing 4100002)
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
PM: Writing back config space on device 0000:00:14.4 at offset 3 (was 816000, writing 814000)
PM: Writing back config space on device 0000:30:00.0 at offset f (was 100, writing 10a)
PM: Writing back config space on device 0000:30:00.0 at offset 4 (was 0, writing c8000000)
PM: Writing back config space on device 0000:30:00.0 at offset 3 (was 0, writing 10)
PM: Writing back config space on device 0000:30:00.0 at offset 1 (was 100000, writing 100003)
PM: Writing back config space on device 0000:02:01.0 at offset 3 (was 0, writing 4010)
PM: Writing back config space on device 0000:02:01.0 at offset 1 (was 2b00000, writing 2b00006)
PM: Writing back config space on device 0000:02:04.0 at offset f (was 34001ff, writing 5c0010a)
PM: Writing back config space on device 0000:02:04.0 at offset e (was 0, writing 14fc)
PM: Writing back config space on device 0000:02:04.0 at offset d (was 0, writing 1400)
PM: Writing back config space on device 0000:02:04.0 at offset c (was 0, writing 10fc)
PM: Writing back config space on device 0000:02:04.0 at offset b (was 0, writing 1000)
PM: Writing back config space on device 0000:02:04.0 at offset a (was 0, writing 93fff000)
PM: Writing back config space on device 0000:02:04.0 at offset 9 (was 0, writing 90000000)
PM: Writing back config space on device 0000:02:04.0 at offset 8 (was 0, writing 8ffff000)
PM: Writing back config space on device 0000:02:04.0 at offset 7 (was 0, writing 8c000000)
PM: Writing back config space on device 0000:02:04.0 at offset 6 (was 0, writing b0060302)
PM: Writing back config space on device 0000:02:04.0 at offset 4 (was 0, writing d4010000)
PM: Writing back config space on device 0000:02:04.0 at offset 3 (was 820000, writing 82a810)
PM: Writing back config space on device 0000:02:04.0 at offset 1 (was 2100000, writing 2100007)
PM: Writing back config space on device 0000:02:04.1 at offset f (was 4020100, writing 402010a)
PM: Writing back config space on device 0000:02:04.1 at offset 5 (was 0, writing d4014000)
PM: Writing back config space on device 0000:02:04.1 at offset 4 (was 0, writing d4011000)
PM: Writing back config space on device 0000:02:04.1 at offset 3 (was 800000, writing 804010)
PM: Writing back config space on device 0000:02:04.1 at offset 1 (was 2100000, writing 2100006)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[d4011000-d40117ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
PM: Writing back config space on device 0000:02:04.2 at offset f (was 40701ff, writing 407010a)
PM: Writing back config space on device 0000:02:04.2 at offset 4 (was 0, writing d4018000)
PM: Writing back config space on device 0000:02:04.2 at offset 3 (was 800000, writing 804010)
PM: Writing back config space on device 0000:02:04.2 at offset 1 (was 2100000, writing 2100006)
ACPI: PCI Interrupt 0000:02:04.2[A] -> GSI 20 (level, low) -> IRQ 20
PM: Writing back config space on device 0000:02:04.3 at offset f (was 40701ff, writing 407010a)
PM: Writing back config space on device 0000:02:04.3 at offset 4 (was 0, writing d4019000)
PM: Writing back config space on device 0000:02:04.3 at offset 3 (was 800000, writing 804010)
PM: Writing back config space on device 0000:02:04.3 at offset 1 (was 2100000, writing 2100006)
ACPI: PCI Interrupt 0000:02:04.3[A] -> GSI 20 (level, low) -> IRQ 20
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: selected mode 0x22
usb usb1: usb resume
ehci_hcd 0000:00:13.2: resume root hub after power loss
hub 1-0:1.0: trying to enable port power on non-switchable hub
usb usb2: usb resume
ohci_hcd 0000:00:13.0: lost power
ohci_hcd 0000:00:13.0: OHCI controller state
ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:13.0: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.0: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.0: hcca frame #0005
ohci_hcd 0000:00:13.0: roothub.a 02000204 POTPGT=2 NPS NDP=4(4)
ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [3] 0x00000100 PPS
ohci_hcd 0000:00:13.0: restart complete
usb usb2: root hub lost power or was reset
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 2-0:1.0: logical disconnect on port 2
usb usb3: usb resume
ohci_hcd 0000:00:13.1: lost power
ohci_hcd 0000:00:13.1: OHCI controller state
ohci_hcd 0000:00:13.1: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:13.1: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.1: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.1: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.1: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.1: hcca frame #000b
ohci_hcd 0000:00:13.1: roothub.a 02000204 POTPGT=2 NPS NDP=4(4)
ohci_hcd 0000:00:13.1: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.1: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.1: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [3] 0x00000100 PPS
ohci_hcd 0000:00:13.1: restart complete
usb usb3: root hub lost power or was reset
hub 3-0:1.0: trying to enable port power on non-switchable hub
hub 3-0:1.0: logical disconnect on port 1
hub 3-0:1.0: logical disconnect on port 3
PM: Finishing wakeup.
Restarting tasks ... done.
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 004c
ehci_hcd 0000:00:13.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 2 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 2 not reset yet, waiting 50ms
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 3 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 3 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 3 not reset yet, waiting 50ms
ehci_hcd 0000:00:13.2: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
hub 1-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 6 low speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0004
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
usb 2-2: USB disconnect, address 2
usb 2-2: unregistering device
usb 2-2: usb_disable_device nuking all URBs
usb 2-2: unregistering interface 2-2:1.0
usb 2-2:1.0: uevent
usb 2-2:1.0: uevent
usb 2-2: unregistering interface 2-2:1.1
usb 2-2:1.1: uevent
usb 2-2:1.1: uevent
usb 2-2: unregistering interface 2-2:1.2
usb 2-2:1.2: uevent
usb 2-2:1.2: uevent
usb 2-2: unregistering interface 2-2:1.3
usb 2-2:1.3: uevent
usb 2-2:1.3: uevent
usb 2-2: uevent
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
usb 2-2: new full speed USB device using ohci_hcd and address 3
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
usb 2-2: skipped 1 descriptor after interface
usb 2-2: default language 0x0409
usb 2-2: uevent
usb 2-2: usb_probe_device
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
usb 2-2:1.0: uevent
usb 2-2:1.0: uevent
hci_usb 2-2:1.0: usb_probe_interface
hci_usb 2-2:1.0: usb_probe_interface - got id
usb 2-2: adding 2-2:1.1 (config #1, interface 1)
usb 2-2:1.1: uevent
usb 2-2:1.1: uevent
usb 2-2: adding 2-2:1.2 (config #1, interface 2)
usb 2-2:1.2: uevent
usb 2-2:1.2: uevent
hci_usb 2-2:1.2: usb_probe_interface
hci_usb 2-2:1.2: usb_probe_interface - got id
usb 2-2: adding 2-2:1.3 (config #1, interface 3)
usb 2-2:1.3: uevent
usb 2-2:1.3: uevent
hci_usb 2-2:1.3: usb_probe_interface
hci_usb 2-2:1.3: usb_probe_interface - got id
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '003'
usb 2-2: new device found, idVendor=03f0, idProduct=171d
usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: HP Integrated Module
usb 2-2: Manufacturer: Broadcom Corp
hub 3-0:1.0: state 7 ports 4 chg 000a evt 000a
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
usb 3-1: USB disconnect, address 2
usb 3-1: unregistering device
usb 3-1: usb_disable_device nuking all URBs
usb 3-1: unregistering interface 3-1:1.0
usb 3-1:1.0: uevent
usb 3-1:1.0: uevent
usb 3-1: uevent
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
usb 3-1: new full speed USB device using ohci_hcd and address 4
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
usb 3-1: ep0 maxpacket = 8
usb 3-1: default language 0x0409
usb 3-1: uevent
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: uevent
usb 3-1:1.0: uevent
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '004'
usb 3-1: new device found, idVendor=08ff, idProduct=2580
usb 3-1: new device strings: Mfr=0, Product=1, SerialNumber=0
usb 3-1: Product: Fingerprint Sensor
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00010301 CSC LSDA PPS CCS
hub 3-0:1.0: port 3, status 0301, change 0001, 1.5 Mb/s
usb 3-3: USB disconnect, address 3
usb 3-3: unregistering device
usb 3-3: usb_disable_device nuking all URBs
usb 3-3: unregistering interface 3-3:1.0
usb 3-3:1.0: uevent
usb 3-3:1.0: uevent
usb 3-3: unregistering interface 3-3:1.1
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/file.c: removing 96 minor
usb 3-3:1.1: uevent
usb 3-3:1.1: uevent
usb 3-3: uevent
hub 3-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x301
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
usb 3-3: new low speed USB device using ohci_hcd and address 5
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
usb 3-3: skipped 1 descriptor after interface
usb 3-3: skipped 1 descriptor after interface
usb 3-3: default language 0x0409
usb 3-3: uevent
usb 3-3: usb_probe_device
usb 3-3: configuration #1 chosen from 1 choice
usb 3-3: adding 3-3:1.0 (config #1, interface 0)
usb 3-3:1.0: uevent
usb 3-3:1.0: uevent
usbhid 3-3:1.0: usb_probe_interface
usbhid 3-3:1.0: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input8
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-3
usb 3-3: adding 3-3:1.1 (config #1, interface 1)
usb 3-3:1.1: uevent
usb 3-3:1.1: uevent
usbhid 3-3:1.1: usb_probe_interface
usbhid 3-3:1.1: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input9
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/file.c: looking for a minor, starting at 96
input,hiddev96: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:13.1-3
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '005'
usb 3-3: new device found, idVendor=046d, idProduct=c521
usb 3-3: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-3: Product: USB Receiver
usb 3-3: Manufacturer: Logitech
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0040
hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
hub 3-0:1.0: state 7 ports 4 chg 0000 evt 0008
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:13.2: suspend root hub
bcm43xx driver
ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:30:00.0 to 64
bcm43xx: Chip ID 0x4311, rev 0x1
bcm43xx: Number of cores: 4
bcm43xx: Core 0: ID 0x800, rev 0x11, vendor 0x4243
bcm43xx: Core 1: ID 0x812, rev 0xa, vendor 0x4243
bcm43xx: Core 2: ID 0x817, rev 0x3, vendor 0x4243
bcm43xx: Core 3: ID 0x820, rev 0x1, vendor 0x4243
bcm43xx: PHY connected
bcm43xx: Detected PHY: Analog: 4, Type 2, Revision 8
bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
bcm43xx: Radio initialized
bcm43xx: Radio initialized
bcm43xx: PHY connected
bcm43xx: Microcode rev 0x127, pl 0xe (2005-04-18  02:36:27)
bcm43xx: Radio turned on
bcm43xx: Radio enabled by hardware
bcm43xx: Chip initialized
bcm43xx: 32-bit DMA initialized
bcm43xx: Keys cleared
bcm43xx: Selected 802.11 core (phytype 2)
ADDRCONF(NETDEV_UP): eth1: link is not ready
SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
SoftMAC: Associate: Scanning for networks first.
SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
SoftMAC: Queueing Authentication Request to 00:17:9a:f3:b5:75
SoftMAC: Cannot associate without being authenticated, requested authentication
SoftMAC: Sent Authentication Request to 00:17:9a:f3:b5:75.
SoftMAC: Open Authentication completed with 00:17:9a:f3:b5:75
SoftMAC: sent association request!
SoftMAC: associated!
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
SFW2-OUT-ERROR IN= OUT=eth1 SRC=0000:0000:0000:0000:0000:0000:0000:0000 DST=ff02:0000:0000:0000:0000:0000:0000:0016 LEN=76 TC=0 HOPLIMIT=1 FLOWLBL=0 OPT ( ) PROTO=ICMPv6 TYPE=143 CODE=0 
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=0000:0000:0000:0000:0000:0000:0000:0000 DST=ff02:0000:0000:0000:0000:0001:ffbe:9531 LEN=64 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=135 CODE=0 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0002 LEN=56 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=133 CODE=0 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0002 LEN=56 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=133 CODE=0 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0016 LEN=76 TC=0 HOPLIMIT=1 FLOWLBL=0 OPT ( ) PROTO=ICMPv6 TYPE=143 CODE=0 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0002 LEN=56 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=133 CODE=0 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
eth1: no IPv6 routers present
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
bcm43xx: Radio initialized
bcm43xx: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx: DMA-32 0x02A0 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0280 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0260 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0240 (TX) max used slots: 0/512
bcm43xx: DMA-32 0x0220 (TX) max used slots: 2/512
bcm43xx: DMA-32 0x0200 (TX) max used slots: 0/512
ACPI: PCI interrupt for device 0000:30:00.0 disabled
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.19 seconds) done.
Shrinking memory...  -\done (15072 pages freed)
Freed 60288 kbytes in 0.22 seconds (274.03 MB/s)
Suspending device vcsa8
Suspending device vcs8
Suspending device vcsa10
Suspending device vcs10
Suspending device usbdev3.5
Suspending device usbdev3.5_ep82
Suspending device hiddev0
Suspending device event3
Suspending device input9
Suspending device 3-3:1.1
Suspending device usbdev3.5_ep81
Suspending device event2
Suspending device mouse0
Suspending device input8
Suspending device 3-3:1.0
Suspending device usbdev3.5_ep00
Suspending device 3-3
Suspending device usbdev3.4
Suspending device usbdev3.4_ep02
Suspending device usbdev3.4_ep81
Suspending device 3-1:1.0
Suspending device usbdev3.4_ep00
Suspending device 3-1
Suspending device usbdev2.3
Suspending device 2-2:1.3
Suspending device usbdev2.3_ep04
Suspending device usbdev2.3_ep84
Suspending device 2-2:1.2
Suspending device usbdev2.3_ep03
Suspending device usbdev2.3_ep83
Suspending device 2-2:1.1
Suspending device usbdev2.3_ep02
Suspending device usbdev2.3_ep82
Suspending device usbdev2.3_ep81
Suspending device hci0
Suspending device 2-2:1.0
Suspending device usbdev2.3_ep00
Suspending device 2-2
Suspending device vcsa4
Suspending device vcs4
Suspending device vcsa2
Suspending device vcs2
Suspending device vcsa6
Suspending device vcs6
Suspending device vcsa5
Suspending device vcs5
Suspending device vcsa3
Suspending device vcs3
Suspending device vcsa7
Suspending device vcs7
Suspending device audio
Suspending device dsp
Suspending device mixer
Suspending device event7
Suspending device input7
Suspending device event6
Suspending device input6
Suspending device event5
Suspending device input5
Suspending device seq
Suspending device C1BE
Suspending device C1BF
Suspending device C1BD
Suspending device device-mapper
Suspending device serio5
Suspending device event4
Suspending device mouse1
Suspending device input4
Suspending device bluetooth
Suspending device usbdev3.1
Suspending device usbdev3.1_ep81
Suspending device 00023f9929613f0c
Suspending device 00023f9929613f0c
Suspending device 3-0:1.0
Suspending device usbdev3.1_ep00
Suspending device usb3
hub 3-0:1.0: hub_suspend
usb usb3: bus suspend
ohci_hcd 0000:00:13.1: suspend root hub
Suspending device pcmcia_socket0
Suspending device usbdev2.1
Suspending device usbdev2.1_ep81
Suspending device 2-0:1.0
Suspending device usbdev2.1_ep00
Suspending device usb2
hub 2-0:1.0: hub_suspend
usb usb2: bus suspend
ohci_hcd 0000:00:13.0: suspend root hub
Suspending device hwmon0
Suspending device usbdev1.1
Suspending device usbdev1.1_ep81
Suspending device 1-0:1.0
Suspending device usbdev1.1_ep00
Suspending device usb1
Suspending device fw-host0
Suspending device fw-host0
Suspending device mmc0
Suspending device i2c-0
Suspending device eth0
Suspending device controlC0
Suspending device hwC0D0
Suspending device hwC0D1
Suspending device pcmC0D0c
Suspending device pcmC0D0p
Suspending device timer
Suspending device vcsa1
Suspending device vcs1
Suspending device 0.0
Suspending device ide0
Suspending device network_throughput
Suspending device network_latency
Suspending device cpu_dma_latency
Suspending device event1
Suspending device event0
Suspending device input1
Suspending device input0
Suspending device psaux
Suspending device mice
Suspending device serio4
Suspending device serio3
Suspending device serio2
Suspending device serio1
Suspending device serio0
Suspending device i8042
Suspending device 0:0:0:0
sd 0:0:0:0: [sda] Synchronizing SCSI cache
Suspending device target0:0:0
Suspending device host1
Suspending device host0
Suspending device ttyS3
Suspending device ttyS2
Suspending device ttyS1
Suspending device ttyS0
Suspending device serial8250
Suspending device nvram
Suspending device hpet
Suspending device rtc
Suspending device ttysf
Suspending device ttyse
Suspending device ttysd
Suspending device ttysc
Suspending device ttysb
Suspending device ttysa
Suspending device ttys9
Suspending device ttys8
Suspending device ttys7
Suspending device ttys6
Suspending device ttys5
Suspending device ttys4
Suspending device ttys3
Suspending device ttys2
Suspending device ttys1
Suspending device ttys0
Suspending device ttyrf
Suspending device ttyre
Suspending device ttyrd
Suspending device ttyrc
Suspending device ttyrb
Suspending device ttyra
Suspending device ttyr9
Suspending device ttyr8
Suspending device ttyr7
Suspending device ttyr6
Suspending device ttyr5
Suspending device ttyr4
Suspending device ttyr3
Suspending device ttyr2
Suspending device ttyr1
Suspending device ttyr0
Suspending device ttyqf
Suspending device ttyqe
Suspending device ttyqd
Suspending device ttyqc
Suspending device ttyqb
Suspending device ttyqa
Suspending device ttyq9
Suspending device ttyq8
Suspending device ttyq7
Suspending device ttyq6
Suspending device ttyq5
Suspending device ttyq4
Suspending device ttyq3
Suspending device ttyq2
Suspending device ttyq1
Suspending device ttyq0
Suspending device ttypf
Suspending device ttype
Suspending device ttypd
Suspending device ttypc
Suspending device ttypb
Suspending device ttypa
Suspending device ttyp9
Suspending device ttyp8
Suspending device ttyp7
Suspending device ttyp6
Suspending device ttyp5
Suspending device ttyp4
Suspending device ttyp3
Suspending device ttyp2
Suspending device ttyp1
Suspending device ttyp0
Suspending device ptysf
Suspending device ptyse
Suspending device ptysd
Suspending device ptysc
Suspending device ptysb
Suspending device ptysa
Suspending device ptys9
Suspending device ptys8
Suspending device ptys7
Suspending device ptys6
Suspending device ptys5
Suspending device ptys4
Suspending device ptys3
Suspending device ptys2
Suspending device ptys1
Suspending device ptys0
Suspending device ptyrf
Suspending device ptyre
Suspending device ptyrd
Suspending device ptyrc
Suspending device ptyrb
Suspending device ptyra
Suspending device ptyr9
Suspending device ptyr8
Suspending device ptyr7
Suspending device ptyr6
Suspending device ptyr5
Suspending device ptyr4
Suspending device ptyr3
Suspending device ptyr2
Suspending device ptyr1
Suspending device ptyr0
Suspending device ptyqf
Suspending device ptyqe
Suspending device ptyqd
Suspending device ptyqc
Suspending device ptyqb
Suspending device ptyqa
Suspending device ptyq9
Suspending device ptyq8
Suspending device ptyq7
Suspending device ptyq6
Suspending device ptyq5
Suspending device ptyq4
Suspending device ptyq3
Suspending device ptyq2
Suspending device ptyq1
Suspending device ptyq0
Suspending device ptypf
Suspending device ptype
Suspending device ptypd
Suspending device ptypc
Suspending device ptypb
Suspending device ptypa
Suspending device ptyp9
Suspending device ptyp8
Suspending device ptyp7
Suspending device ptyp6
Suspending device ptyp5
Suspending device ptyp4
Suspending device ptyp3
Suspending device ptyp2
Suspending device ptyp1
Suspending device ptyp0
Suspending device tty63
Suspending device tty62
Suspending device tty61
Suspending device tty60
Suspending device tty59
Suspending device tty58
Suspending device tty57
Suspending device tty56
Suspending device tty55
Suspending device tty54
Suspending device tty53
Suspending device tty52
Suspending device tty51
Suspending device tty50
Suspending device tty49
Suspending device tty48
Suspending device tty47
Suspending device tty46
Suspending device tty45
Suspending device tty44
Suspending device tty43
Suspending device tty42
Suspending device tty41
Suspending device tty40
Suspending device tty39
Suspending device tty38
Suspending device tty37
Suspending device tty36
Suspending device tty35
Suspending device tty34
Suspending device tty33
Suspending device tty32
Suspending device tty31
Suspending device tty30
Suspending device tty29
Suspending device tty28
Suspending device tty27
Suspending device tty26
Suspending device tty25
Suspending device tty24
Suspending device tty23
Suspending device tty22
Suspending device tty21
Suspending device tty20
Suspending device tty19
Suspending device tty18
Suspending device tty17
Suspending device tty16
Suspending device tty15
Suspending device tty14
Suspending device tty13
Suspending device tty12
Suspending device tty11
Suspending device tty10
Suspending device tty9
Suspending device tty8
Suspending device tty7
Suspending device tty6
Suspending device tty5
Suspending device tty4
Suspending device tty3
Suspending device tty2
Suspending device tty1
Suspending device vcsa
Suspending device vcs
Suspending device tty0
Suspending device ptmx
Suspending device console
Suspending device tty
Suspending device vtcon1
Suspending device fb0
Suspending device vesafb.0
Suspending device fbcon
Suspending device 0000:00:06.0:pcie03
Suspending device 0000:00:06.0:pcie01
Suspending device 0000:00:06.0:pcie00
Suspending device 0000:00:05.0:pcie03
Suspending device 0000:00:05.0:pcie01
Suspending device 0000:00:05.0:pcie00
Suspending device 0000:00:04.0:pcie03
Suspending device 0000:00:04.0:pcie01
Suspending device 0000:00:04.0:pcie00
Suspending device snapshot
Suspending device pcspkr
Suspending device mcelog
Suspending device lo
Suspending device kmsg
Suspending device urandom
Suspending device random
Suspending device full
Suspending device zero
Suspending device port
Suspending device null
Suspending device kmem
Suspending device mem
Suspending device 00:0c
ACPI handle has no context!
Suspending device 00:0b
Suspending device 00:0a
Suspending device 00:09
Suspending device 00:08
Suspending device 00:07
Suspending device 00:06
Suspending device 00:05
Suspending device 00:04
Suspending device 00:03
Suspending device 00:02
Suspending device 00:01
Suspending device 00:00
Suspending device pnp0
Suspending device 0000:02
Suspending device 0000:03
Suspending device 0000:02:04.3
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:02:04.3 disabled
ACPI handle has no context!
Suspending device 0000:02:04.2
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:02:04.2 disabled
ACPI handle has no context!
Suspending device 0000:02:04.1
ACPI handle has no context!
Suspending device 0000:02:04.0
Suspending device 0000:02:01.0
Suspending device 0000:30
Suspending device 0000:30:00.0
Suspending device 0000:20
Suspending device 0000:10
Suspending device 0000:01
Suspending device 0000:01:05.0
Suspending device 0000:00:18.3
Suspending device 0000:00:18.2
Suspending device 0000:00:18.1
Suspending device 0000:00:18.0
Suspending device 0000:00:14.4
Suspending device 0000:00:14.3
Suspending device 0000:00:14.2
ACPI: PCI interrupt for device 0000:00:14.2 disabled
Suspending device 0000:00:14.1
Suspending device 0000:00:14.0
Suspending device 0000:00:13.2
ACPI: PCI interrupt for device 0000:00:13.2 disabled
ehci_hcd 0000:00:13.2: --> PCI D3
Suspending device 0000:00:13.1
ACPI: PCI interrupt for device 0000:00:13.1 disabled
ohci_hcd 0000:00:13.1: --> PCI D0/legacy
Suspending device 0000:00:13.0
ACPI: PCI interrupt for device 0000:00:13.0 disabled
ohci_hcd 0000:00:13.0: --> PCI D0/legacy
Suspending device 0000:00:12.0
ACPI: PCI interrupt for device 0000:00:12.0 disabled
Suspending device 0000:00:06.0
Suspending device 0000:00:05.0
Suspending device 0000:00:04.0
Suspending device 0000:00:01.0
Suspending device 0000:00:00.0
Suspending device 0000:00
Suspending device pci0000:00
Suspending device LNXTHERM:03
Suspending device LNXTHERM:02
Suspending device LNXTHERM:01
Suspending device PNP0C0B:03
Suspending device PNP0C0B:02
ACPI: Transitioning device [C351] to D0
ACPI: Transitioning device [C351] to D0
Suspending device PNP0C0B:01
ACPI: Transitioning device [C350] to D0
ACPI: Transitioning device [C350] to D0
Suspending device PNP0C0B:00
ACPI: Transitioning device [C34F] to D0
ACPI: Transitioning device [C34F] to D0
Suspending device LNXPOWER:06
Suspending device LNXPOWER:05
Suspending device LNXPOWER:04
Suspending device LNXPOWER:03
Suspending device LNXTHERM:00
Suspending device PNP0C02:02
Suspending device PNP0C14:00
Suspending device PNP0C0D:00
Suspending device PNP0C0E:00
Suspending device ACPI0003:00
Suspending device PNP0C0A:01
Suspending device PNP0C0A:00
Suspending device HPQ0006:00
Suspending device PNP0C02:01
Suspending device device:49
Suspending device device:48
Suspending device device:47
Suspending device device:46
Suspending device device:45
Suspending device device:44
Suspending device device:43
Suspending device device:42
Suspending device device:41
Suspending device device:40
Suspending device device:3f
Suspending device device:3e
Suspending device device:3d
Suspending device device:3c
Suspending device device:3b
Suspending device device:3a
Suspending device device:39
Suspending device device:38
Suspending device device:37
Suspending device device:36
Suspending device device:35
Suspending device device:34
Suspending device device:33
Suspending device PNP0C0F:07
Suspending device PNP0C0F:06
Suspending device PNP0C0F:05
Suspending device PNP0C0F:04
Suspending device PNP0C0F:03
Suspending device PNP0C0F:02
Suspending device PNP0C0F:01
Suspending device PNP0C0F:00
Suspending device device:32
Suspending device device:31
Suspending device device:30
Suspending device device:2f
Suspending device device:2e
Suspending device device:2d
Suspending device device:2c
Suspending device device:2b
Suspending device device:2a
Suspending device device:29
Suspending device device:28
Suspending device device:27
Suspending device device:26
Suspending device device:25
Suspending device device:24
Suspending device device:23
Suspending device device:22
Suspending device device:21
Suspending device device:20
Suspending device device:1f
Suspending device device:1e
Suspending device device:1d
Suspending device device:1c
Suspending device device:1b
Suspending device device:1a
Suspending device device:19
Suspending device device:18
Suspending device device:17
Suspending device device:16
Suspending device device:15
Suspending device device:14
Suspending device device:13
Suspending device device:12
Suspending device device:11
Suspending device device:10
Suspending device PNP0C02:00
Suspending device PNP0000:00
Suspending device LNXPOWER:02
Suspending device SYN0118:00
Suspending device PNP0303:00
Suspending device PNP0B00:00
Suspending device PNP0800:00
Suspending device PNP0200:00
Suspending device PNP0100:00
Suspending device PNP0C04:00
Suspending device IFX0102:00
Suspending device LNXPOWER:01
Suspending device PNP0401:00
Suspending device PNP0A06:00
Suspending device PNP0C09:00
Suspending device device:0f
Suspending device device:0e
Suspending device LNXPOWER:00
Suspending device device:0d
Suspending device device:0c
Suspending device device:0b
Suspending device device:0a
Suspending device device:09
Suspending device device:08
Suspending device device:07
Suspending device device:06
Suspending device device:05
Suspending device device:04
Suspending device device:03
Suspending device device:02
Suspending device LNXVIDEO:00
Suspending device device:01
Suspending device PNP0A03:00
Suspending device PNP0C01:00
Suspending device device:00
Suspending device ACPI0007:01
Suspending device ACPI0007:00
Suspending device LNXPWRBN:00
Suspending device LNXSYSTM:00
Suspending device id
Suspending device vtcon0
Suspending device platform
Disabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 is down
Extended CMOS year: 2000
swsusp: critical section: 
swsusp: Need to copy 149622 pages
swsusp: Normal pages needed: 149622 + 1024 + 36, available pages: 341743
evxfevnt-0079 [00] enable                : System is already in ACPI mode
Extended CMOS year: 2000
Enabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.20 BogoMIPS (lpj=7980408)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 02
Clockevents: could not switch to one-shot mode: lapic is not functional.
CPU0 attaching sched-domain:
Could not switch to high resolution mode on CPU 1
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000001 00000000,00000000,00000000,00000002
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000002 00000000,00000000,00000000,00000001
CPU1 is up
ACPI: Transitioning device [C34F] to D3
ACPI: Transitioning device [C34F] to D3
ACPI: Transitioning device [C350] to D3
ACPI: Transitioning device [C350] to D3
PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 2206161, writing 22206161)
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
PM: Writing back config space on device 0000:00:12.0 at offset 1 (was 2b00003, writing 2b00007)
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:13.0: PCI legacy resume
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:00:13.1: PCI legacy resume
ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: PCI D0, from previous PCI D3
ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
PM: Writing back config space on device 0000:00:13.2 at offset 1 (was 2b00007, writing 2b00017)
ehci_hcd 0000:00:13.2: lost power, restarting
usb usb1: root hub lost power or was reset
ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:13.2: MWI active
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
PM: Writing back config space on device 0000:00:14.2 at offset f (was 10a, writing a)
PM: Writing back config space on device 0000:00:14.2 at offset 1 (was 4100006, writing 4100002)
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
PM: Writing back config space on device 0000:00:14.4 at offset 6 (was 40030200, writing 40060200)
PM: Writing back config space on device 0000:30:00.0 at offset 1 (was 100007, writing 100003)
PM: Writing back config space on device 0000:02:04.0 at offset f (was 3c4010a, writing 5c0010a)
PM: Writing back config space on device 0000:02:04.0 at offset 3 (was 824010, writing 82a810)
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[d4011000-d40117ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ACPI: PCI Interrupt 0000:02:04.2[A] -> GSI 20 (level, low) -> IRQ 20
ACPI: PCI Interrupt 0000:02:04.3[A] -> GSI 20 (level, low) -> IRQ 20
sd 0:0:0:0: [sda] Starting disk
ata2: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: selected mode 0x22
usb usb1: usb resume
ehci_hcd 0000:00:13.2: resume root hub after power loss
hub 1-0:1.0: trying to enable port power on non-switchable hub
usb usb2: usb resume
ohci_hcd 0000:00:13.0: BIOS/SMM active, control 008
ohci_hcd 0000:00:13.0: OHCI controller state
ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:13.0: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.0: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.0: hcca frame #0005
ohci_hcd 0000:00:13.0: roothub.a 02000204 POTPGT=2 NPS NDP=4(4)
ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00010100 CSC PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:13.0: roothub.portstatus [3] 0x00000100 PPS
ohci_hcd 0000:00:13.0: restart complete
usb usb2: root hub lost power or was reset
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 2-0:1.0: logical disconnect on port 2
usb usb3: usb resume
ohci_hcd 0000:00:13.1: BIOS/SMM active, control 008
ohci_hcd 0000:00:13.1: OHCI controller state
ohci_hcd 0000:00:13.1: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:13.1: control 0x083 HCFS=operational CBSR=3
ohci_hcd 0000:00:13.1: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:13.1: intrstatus 0x00000004 SF
ohci_hcd 0000:00:13.1: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:13.1: hcca frame #0005
ohci_hcd 0000:00:13.1: roothub.a 02000204 POTPGT=2 NPS NDP=4(4)
ohci_hcd 0000:00:13.1: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:13.1: roothub.status 00008000 DRWE
ohci_hcd 0000:00:13.1: roothub.portstatus [0] 0x00010100 CSC PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [2] 0x00010100 CSC PPS
ohci_hcd 0000:00:13.1: roothub.portstatus [3] 0x00000100 PPS
ohci_hcd 0000:00:13.1: restart complete
usb usb3: root hub lost power or was reset
hub 3-0:1.0: trying to enable port power on non-switchable hub
hub 3-0:1.0: logical disconnect on port 1
hub 3-0:1.0: logical disconnect on port 3
Restarting tasks ... <7>hub 1-0:1.0: state 7 ports 8 chg 0000 evt 004c
ehci_hcd 0000:00:13.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
done.
swsusp: Basic memory bitmaps freed
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 2 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 2 not reset yet, waiting 50ms
ehci_hcd 0000:00:13.2: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 3 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 3 full speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 3 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 3 not reset yet, waiting 50ms
ehci_hcd 0000:00:13.2: GetStatus port 3 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:13.2: GetStatus port 6 status 001403 POWER sig=k CSC CONNECT
hub 1-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
hub 1-0:1.0: debounce: port 6: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:13.2: port 6 low speed --> companion
ehci_hcd 0000:00:13.2: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: state 7 ports 4 chg 0004 evt 0004
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
usb 2-2: USB disconnect, address 3
usb 2-2: unregistering device
usb 2-2: usb_disable_device nuking all URBs
usb 2-2: unregistering interface 2-2:1.0
usb 2-2:1.0: uevent
usb 2-2:1.0: uevent
usb 2-2: unregistering interface 2-2:1.1
usb 2-2:1.1: uevent
usb 2-2:1.1: uevent
usb 2-2: unregistering interface 2-2:1.2
usb 2-2:1.2: uevent
usb 2-2:1.2: uevent
usb 2-2: unregistering interface 2-2:1.3
usb 2-2:1.3: uevent
usb 2-2:1.3: uevent
usb 2-2: uevent
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
usb 2-2: new full speed USB device using ohci_hcd and address 4
ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
usb 2-2: skipped 1 descriptor after interface
usb 2-2: default language 0x0409
usb 2-2: uevent
usb 2-2: usb_probe_device
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
usb 2-2:1.0: uevent
usb 2-2:1.0: uevent
hci_usb 2-2:1.0: usb_probe_interface
hci_usb 2-2:1.0: usb_probe_interface - got id
usb 2-2: adding 2-2:1.1 (config #1, interface 1)
usb 2-2:1.1: uevent
usb 2-2:1.1: uevent
usb 2-2: adding 2-2:1.2 (config #1, interface 2)
usb 2-2:1.2: uevent
usb 2-2:1.2: uevent
hci_usb 2-2:1.2: usb_probe_interface
hci_usb 2-2:1.2: usb_probe_interface - got id
usb 2-2: adding 2-2:1.3 (config #1, interface 3)
usb 2-2:1.3: uevent
usb 2-2:1.3: uevent
hci_usb 2-2:1.3: usb_probe_interface
hci_usb 2-2:1.3: usb_probe_interface - got id
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '004'
usb 2-2: new device found, idVendor=03f0, idProduct=171d
usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: HP Integrated Module
usb 2-2: Manufacturer: Broadcom Corp
hub 3-0:1.0: state 7 ports 4 chg 000a evt 000a
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
usb 3-1: USB disconnect, address 4
usb 3-1: unregistering device
usb 3-1: usb_disable_device nuking all URBs
usb 3-1: unregistering interface 3-1:1.0
usb 3-1:1.0: uevent
usb 3-1:1.0: uevent
usb 3-1: uevent
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
usb 3-1: new full speed USB device using ohci_hcd and address 6
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
usb 3-1: ep0 maxpacket = 8
usb 3-1: default language 0x0409
usb 3-1: uevent
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: uevent
usb 3-1:1.0: uevent
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '006'
usb 3-1: new device found, idVendor=08ff, idProduct=2580
usb 3-1: new device strings: Mfr=0, Product=1, SerialNumber=0
usb 3-1: Product: Fingerprint Sensor
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00010301 CSC LSDA PPS CCS
hub 3-0:1.0: port 3, status 0301, change 0001, 1.5 Mb/s
usb 3-3: USB disconnect, address 5
usb 3-3: unregistering device
usb 3-3: usb_disable_device nuking all URBs
usb 3-3: unregistering interface 3-3:1.0
usb 3-3:1.0: uevent
usb 3-3:1.0: uevent
usb 3-3: unregistering interface 3-3:1.1
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/file.c: removing 96 minor
usb 3-3:1.1: uevent
usb 3-3:1.1: uevent
usb 3-3: uevent
hub 3-0:1.0: debounce: port 3: total 100ms stable 100ms status 0x301
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
usb 3-3: new low speed USB device using ohci_hcd and address 7
ohci_hcd 0000:00:13.1: GetStatus roothub.portstatus [2] = 0x00100303 PRSC LSDA PPS PES CCS
usb 3-3: skipped 1 descriptor after interface
usb 3-3: skipped 1 descriptor after interface
usb 3-3: default language 0x0409
usb 3-3: uevent
usb 3-3: usb_probe_device
usb 3-3: configuration #1 chosen from 1 choice
usb 3-3: adding 3-3:1.0 (config #1, interface 0)
usb 3-3:1.0: uevent
usb 3-3:1.0: uevent
usbhid 3-3:1.0: usb_probe_interface
usbhid 3-3:1.0: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input10
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-3
usb 3-3: adding 3-3:1.1 (config #1, interface 1)
usb 3-3:1.1: uevent
usb 3-3:1.1: uevent
usbhid 3-3:1.1: usb_probe_interface
usbhid 3-3:1.1: usb_probe_interface - got id
input: Logitech USB Receiver as /class/input/input11
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/file.c: looking for a minor, starting at 96
input,hiddev96: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:13.1-3
/home/rafael/src/mm/linux-2.6.23-mm1/drivers/usb/core/inode.c: creating file '007'
usb 3-3: new device found, idVendor=046d, idProduct=c521
usb 3-3: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-3: Product: USB Receiver
usb 3-3: Manufacturer: Logitech
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0040
hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0004
hub 3-0:1.0: state 7 ports 4 chg 0000 evt 0008
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:13.2: suspend root hub
bcm43xx driver
ACPI: PCI Interrupt 0000:30:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:30:00.0 to 64
bcm43xx: Chip ID 0x4311, rev 0x1
bcm43xx: Number of cores: 4
bcm43xx: Core 0: ID 0x800, rev 0x11, vendor 0x4243
bcm43xx: Core 1: ID 0x812, rev 0xa, vendor 0x4243
bcm43xx: Core 2: ID 0x817, rev 0x3, vendor 0x4243
bcm43xx: Core 3: ID 0x820, rev 0x1, vendor 0x4243
bcm43xx: PHY connected
bcm43xx: Detected PHY: Analog: 4, Type 2, Revision 8
bcm43xx: Detected Radio: ID: 2205017f (Manuf: 17f Ver: 2050 Rev: 2)
bcm43xx: Radio initialized
bcm43xx: Radio initialized
bcm43xx: PHY connected
bcm43xx: Microcode rev 0x127, pl 0xe (2005-04-18  02:36:27)
bcm43xx: Radio turned on
bcm43xx: Radio enabled by hardware
bcm43xx: Chip initialized
bcm43xx: 32-bit DMA initialized
bcm43xx: Keys cleared
bcm43xx: Selected 802.11 core (phytype 2)
ADDRCONF(NETDEV_UP): eth1: link is not ready
SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
SoftMAC: Associate: Scanning for networks first.
SoftMAC: Scanning finished: scanned 13 channels starting with channel 1
SoftMAC: Queueing Authentication Request to 00:17:9a:f3:b5:75
SoftMAC: Cannot associate without being authenticated, requested authentication
SoftMAC: Sent Authentication Request to 00:17:9a:f3:b5:75.
SoftMAC: Open Authentication completed with 00:17:9a:f3:b5:75
SoftMAC: sent association request!
SoftMAC: associated!
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
SFW2-OUT-ERROR IN= OUT=eth1 SRC=0000:0000:0000:0000:0000:0000:0000:0000 DST=ff02:0000:0000:0000:0000:0000:0000:0016 LEN=76 TC=0 HOPLIMIT=1 FLOWLBL=0 OPT ( ) PROTO=ICMPv6 TYPE=143 CODE=0 
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=0000:0000:0000:0000:0000:0000:0000:0000 DST=ff02:0000:0000:0000:0000:0001:ffbe:9531 LEN=64 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=135 CODE=0 
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0002 LEN=56 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=133 CODE=0 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0016 LEN=76 TC=0 HOPLIMIT=1 FLOWLBL=0 OPT ( ) PROTO=ICMPv6 TYPE=143 CODE=0 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0002 LEN=56 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=133 CODE=0 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=19492 PROTO=2 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-OUT-ERROR IN= OUT=eth1 SRC=fe80:0000:0000:0000:0214:a5ff:febe:9531 DST=ff02:0000:0000:0000:0000:0000:0000:0002 LEN=56 TC=0 HOPLIMIT=255 FLOWLBL=0 PROTO=ICMPv6 TYPE=133 CODE=0 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
eth1: no IPv6 routers present
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=21260 PROTO=2 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=23324 PROTO=2 
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=25180 PROTO=2 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=26892 PROTO=2 
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff88160769>] :snd_pcm:snd_pcm_hw_refine+0x292/0x3d9
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024eef4>] pm_qos_remove_requirement+0x82/0xc0
 [<ffffffff88160bbe>] :snd_pcm:snd_pcm_hw_params+0x30e/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()

Call Trace:
 [<ffffffff8021b2b2>] smp_call_function_mask+0x6d/0x82
 [<ffffffff8021b290>] smp_call_function_mask+0x4b/0x82
 [<ffffffff8021b2ea>] smp_call_function+0x23/0x25
 [<ffffffff884a0b80>] :processor:acpi_processor_latency_notify+0x19/0x20
 [<ffffffff80437ace>] notifier_call_chain+0x33/0x65
 [<ffffffff8024f32f>] __srcu_notifier_call_chain+0x4b/0x69
 [<ffffffff8024f07c>] pm_qos_add_requirement+0x24/0xd2
 [<ffffffff8024f35c>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff8024ee6d>] update_target+0x71/0x76
 [<ffffffff8024f101>] pm_qos_add_requirement+0xa9/0xd2
 [<ffffffff88160bf9>] :snd_pcm:snd_pcm_hw_params+0x349/0x382
 [<ffffffff80291110>] kmem_cache_alloc+0x8a/0xbc
 [<ffffffff88160d75>] :snd_pcm:snd_pcm_hw_params_user+0x50/0x87
 [<ffffffff88160fe1>] :snd_pcm:snd_pcm_common_ioctl1+0x1ae/0xd4f
 [<ffffffff8815f755>] :snd_pcm:snd_pcm_open+0xd6/0x1f2
 [<ffffffff8028fc17>] cache_alloc_debugcheck_after+0x11a/0x199
 [<ffffffff8024b514>] remove_wait_queue+0x40/0x45
 [<ffffffff8815f7bd>] :snd_pcm:snd_pcm_open+0x13e/0x1f2
 [<ffffffff8022f18e>] default_wake_function+0x0/0xf
 [<ffffffff8030b24d>] prio_tree_insert+0x18c/0x231
 [<ffffffff8027b5fb>] vma_prio_tree_insert+0x23/0x39
 [<ffffffff80282e91>] vma_link+0xdd/0x10b
 [<ffffffff8816206f>] :snd_pcm:snd_pcm_playback_ioctl1+0x24d/0x26a
 [<ffffffff8816292c>] :snd_pcm:snd_pcm_playback_ioctl+0x2e/0x36
 [<ffffffff802a0896>] do_ioctl+0x2a/0x77
 [<ffffffff802a0b34>] vfs_ioctl+0x251/0x26e
 [<ffffffff802a0ba8>] sys_ioctl+0x57/0x7b
 [<ffffffff8020bfde>] system_call+0x7e/0x83

SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid
SoftMAC: Getting essid from req_essid

--Boundary-00=_5f+DHaD0ZsmeLAj--
