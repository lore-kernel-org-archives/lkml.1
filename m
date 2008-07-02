Return-Path: <linux-kernel-owner+w=401wt.eu-S1762801AbYGBLTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801AbYGBLTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbYGBLTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:19:35 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:53028 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbYGBLTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:19:34 -0400
To: linux-kernel@vger.kernel.org
Subject: [2.6.24] CPU offline warning at shutdown.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200807022019.CBB86900.JFLOOFHQtOMSFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 2 Jul 2008 20:19:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I sometimes encounter WARN_ON() when the system is about to restart.

  static void native_smp_send_reschedule(int cpu)
  {
          WARN_ON(cpu_is_offline(cpu));
          send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
  }

  void send_IPI_mask_bitmask(cpumask_t cpumask, int vector)
  {
          unsigned long mask = cpus_addr(cpumask)[0];
          unsigned long flags;
  
          local_irq_save(flags);
          WARN_ON(mask & ~cpus_addr(cpu_online_map)[0]);
          __send_IPI_dest_field(mask, vector);
          local_irq_restore(flags);
  }

Since these warrnings appear only when about to restart,
they are harmless, aren't they?

Regards.
----------------------------------------
Initializing cgroup subsys cpuset
Linux version 2.6.24-1-686 (Debian 2.6.24-7) (dannf@debian.org) (gcc version 4.1.3 20080114 (prerelease) (Debian 4.1.2-19)) #1 SMP Thu May 8 02:16:39 UTC 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fef0000 (usable)
 BIOS-e820: 000000003fef0000 - 000000003feff000 (ACPI data)
 BIOS-e820: 000000003feff000 - 000000003ff00000 (ACPI NVS)
 BIOS-e820: 000000003ff00000 - 0000000040000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
128MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f6cd0
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262144
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   262144
DMI present.
ACPI: RSDP 000F6C60, 0014 (r0 PTLTD )
ACPI: RSDT 3FEFAB5A, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 3FEFEF06, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
ACPI: DSDT 3FEFAB8A, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
ACPI: FACS 3FEFFFC0, 0040
ACPI: APIC 3FEFEF7A, 005E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 3FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: PM-Timer IO Port: 0x1008
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: INTEL    Product ID: 440BX        APIC at: 0xFEE00000
Processor #0 6:6 APIC version 17
Processor #1 6:6 APIC version 17
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000ca000
swsusp: Registered nosave memory region: 00000000000ca000 - 00000000000cc000
swsusp: Registered nosave memory region: 00000000000cc000 - 00000000000dc000
swsusp: Registered nosave memory region: 00000000000dc000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260096
Kernel command line: root=/dev/sda1 ro noapic nolapic console=ttyS0,115200n8 console=tty 
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1995.001 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1030280k/1048576k available (1786k kernel code, 17532k reserved, 714k data, 248k init, 131008k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0377000 - 0xc03b5000   ( 248 kB)
      .data : 0xc02beaf9 - 0xc0371384   ( 714 kB)
      .text : 0xc0100000 - 0xc02beaf9   (1786 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3995.28 BogoMIPS (lpj=7990564)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0c00)
CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3991.36 BogoMIPS (lpj=7982729)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
Total of 2 processors activated (7986.64 BogoMIPS).
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
net_namespace: 64 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-103f claimed by PIIX4 ACPI
PCI quirk: region 1040-104f claimed by PIIX4 SMB
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
Time: tsc clocksource has been installed.
system 00:01: ioport range 0x1000-0x103f has been reserved
system 00:01: ioport range 0x1040-0x104f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 5374k freed
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
audit(1214986442.876:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 248k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0816): AE_NOT_FOUND, Processor Device is not present [20070126]
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:07.1
PIIX4: not 100% native mode: will probe irqs later
PIIX4: IDE port disabled
    ide1: BM-DMA at 0x1058-0x105f, BIOS settings: hdc:DMA, hdd:pio
pcnet32.c:v1.34-NAPI 14.Aug.2007 tsbogend@alpha.franken.de
SCSI subsystem initialized
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
Floppy drive(s): fd0 is 1.44M
scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
scsi0:   Firmware Version: 5.07B, I/O Address: 0x1060, IRQ Channel: 11/Level
FDC 0 is a post-1991 82077
scsi0:   PCI Bus: 0, Device: 16, Address: 0xE8800000, Host Adapter SCSI ID: 7
scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
scsi0: *** BusLogic BT-958 Initialized Successfully ***
hdc: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
pcnet32: PCnet/PCI II 79C970A at 0x1080, 00 0c 29 e2 c6 1b assigned IRQ 10.
eth0: registered as PCnet/PCI II 79C970A
pcnet32: 1 cards_found.
scsi0 : BusLogic BT-958
scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
hdc: ATAPI 1X CD-ROM drive, 32kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
Linux agpgart interface v0.102
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 256M @ 0x0
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
ACPI: AC Adapter [ACAD] (on-line)
Real Time Clock Driver v1.12ac
input: PC Speaker as /class/input/input2
input: ImPS/2 Generic Wheel Mouse as /class/input/input3
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
EXT3 FS on sda1, internal journal
loop: module loaded
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
eth0: link up
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
No dock devices found.
Restarting system.
WARNING: at arch/x86/kernel/smp_32.c:474 native_smp_send_reschedule()
Pid: 2216, comm: reboot Not tainted 2.6.24-1-686 #1
 [<c0113ea9>] native_smp_send_reschedule+0x3c/0x53
 [<c011de9e>] resched_task+0x52/0x54
 [<c011efee>] resched_cpu+0x59/0x66
 [<c01210bb>] scheduler_tick+0x126/0x19e
 [<c012c88a>] update_process_times+0x3a/0x44
 [<c013d10d>] tick_sched_timer+0x78/0xbb
 [<c01384e9>] hrtimer_interrupt+0x136/0x1c1
 [<c013d095>] tick_sched_timer+0x0/0xbb
 [<c0115e67>] smp_apic_timer_interrupt+0x6c/0x7d
 [<c0115366>] lapic_get_maxlvt+0xa/0x1d
 [<c01155e3>] clear_local_APIC+0x15c/0x164
 [<c0104980>] apic_timer_interrupt+0x28/0x30
 [<c01139f8>] native_smp_send_stop+0xd2/0xe1
 [<c01137a6>] stop_this_cpu+0x0/0x40
 [<c011353e>] native_machine_shutdown+0x4b/0x5a
 [<c011340b>] machine_shutdown+0x6/0x7
 [<c011342d>] native_machine_restart+0x5/0xa
 [<c0113438>] machine_restart+0x6/0x7
 [<c01302db>] sys_reboot+0x147/0x1ba
 [<c02bdbbe>] _spin_lock_bh+0x8/0x18
 [<c025de43>] dev_set_rx_mode+0x24/0x37
 [<c02604c1>] netdev_run_todo+0x1f5/0x1fc
 [<c025ebad>] dev_change_flags+0xaa/0x149
 [<c025d61c>] __dev_get_by_name+0x68/0x73
 [<c029bf90>] devinet_ioctl+0x4da/0x53c
 [<c025fd97>] dev_ioctl+0x54f/0x595
 [<c02bdbbe>] _spin_lock_bh+0x8/0x18
 [<c029d3a3>] inet_sock_destruct+0x16a/0x1af
 [<c02bdbbe>] _spin_lock_bh+0x8/0x18
 [<c018698f>] d_kill+0x37/0x46
 [<c0186bc8>] dput+0x15/0xdc
 [<c01795a9>] __fput+0x122/0x14c
 [<c018a9be>] mntput_no_expire+0x11/0x66
 [<c0176da1>] filp_close+0x51/0x58
 [<c0177f38>] sys_close+0x62/0x96
 [<c0103e5e>] sysenter_past_esp+0x6b/0xa1
 =======================
WARNING: at arch/x86/kernel/smp_32.c:209 send_IPI_mask_bitmask()
Pid: 2216, comm: reboot Not tainted 2.6.24-1-686 #1
 [<c0113861>] send_IPI_mask_bitmask+0x54/0xa3
 [<c011de9e>] resched_task+0x52/0x54
 [<c011efee>] resched_cpu+0x59/0x66
 [<c01210bb>] scheduler_tick+0x126/0x19e
 [<c012c88a>] update_process_times+0x3a/0x44
 [<c013d10d>] tick_sched_timer+0x78/0xbb
 [<c01384e9>] hrtimer_interrupt+0x136/0x1c1
 [<c013d095>] tick_sched_timer+0x0/0xbb
 [<c0115e67>] smp_apic_timer_interrupt+0x6c/0x7d
 [<c0115366>] lapic_get_maxlvt+0xa/0x1d
 [<c01155e3>] clear_local_APIC+0x15c/0x164
 [<c0104980>] apic_timer_interrupt+0x28/0x30
 [<c01139f8>] native_smp_send_stop+0xd2/0xe1
 [<c01137a6>] stop_this_cpu+0x0/0x40
 [<c011353e>] native_machine_shutdown+0x4b/0x5a
 [<c011340b>] machine_shutdown+0x6/0x7
 [<c011342d>] native_machine_restart+0x5/0xa
 [<c0113438>] machine_restart+0x6/0x7
 [<c01302db>] sys_reboot+0x147/0x1ba
 [<c02bdbbe>] _spin_lock_bh+0x8/0x18
 [<c025de43>] dev_set_rx_mode+0x24/0x37
 [<c02604c1>] netdev_run_todo+0x1f5/0x1fc
 [<c025ebad>] dev_change_flags+0xaa/0x149
 [<c025d61c>] __dev_get_by_name+0x68/0x73
 [<c029bf90>] devinet_ioctl+0x4da/0x53c
 [<c025fd97>] dev_ioctl+0x54f/0x595
 [<c02bdbbe>] _spin_lock_bh+0x8/0x18
 [<c029d3a3>] inet_sock_destruct+0x16a/0x1af
 [<c02bdbbe>] _spin_lock_bh+0x8/0x18
 [<c018698f>] d_kill+0x37/0x46
 [<c0186bc8>] dput+0x15/0xdc
 [<c01795a9>] __fput+0x122/0x14c
 [<c018a9be>] mntput_no_expire+0x11/0x66
 [<c0176da1>] filp_close+0x51/0x58
 [<c0177f38>] sys_close+0x62/0x96
 [<c0103e5e>] sysenter_past_esp+0x6b/0xa1
 =======================
