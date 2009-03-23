Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbZCWIaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbZCWIaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZCWIaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:30:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbZCWIaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:30:09 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: ftrace not working?
Date: Mon, 23 Mar 2009 13:57:40 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc8-default; KDE/4.1.3; x86_64; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
References: <200903231208.03723.knikanth@suse.de> <20090323170234.6A12.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090323170234.6A12.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231357.41130.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009 13:38:53 KOSAKI Motohiro wrote:
> Hi
>
> > I tried ftrace with the linus git 2.6.29 rc-6, & rc-8, but I always seem
> > to get empty trace! Am I doing something wrong?
> >
> > This is what I did.
> >
> > linux-glcc:/data/git/linux-2.6 # cd /sys/kernel/debug/tracing/
> > linux-glcc:/sys/kernel/debug/tracing # cat available_tracers
> > function_graph function sysprof sched_switch nop
> > linux-glcc:/sys/kernel/debug/tracing # echo sched_switch > current_tracer
> > linux-glcc:/sys/kernel/debug/tracing # echo 1 > tracing_enabled
> > linux-glcc:/sys/kernel/debug/tracing # cat tracing_enabled
> > 1
> > linux-glcc:/sys/kernel/debug/tracing # cat trace
> > # tracer: sched_switch
> > #
> > #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > #              | |       |          |         |
>
> your operation seems fine and your .config seems fine too.
> but my box works ftrace well on 2.6.29-rc8.
>
> hmm...
>
> Could you post followin operation result and dmesg?
>
> # cat failures
> # cat current_tracer
> # cat trace_options
> # cat buffer_size_kb
> # cat dyn_ftrace_total_info
> # cat trace_options
> # cat set_ftrace_filter
> # cat tracing_cpumask
> # cat tracing_enabled
> # cat tracing_on
linux-glcc:/sys/kernel/debug/tracing # cat failures 
linux-glcc:/sys/kernel/debug/tracing # cat current_tracer 
sched_switch
linux-glcc:/sys/kernel/debug/tracing # cat trace_options 
print-parent nosym-offset nosym-addr noverbose noraw nohex nobin noblock nostacktrace nosched-tree ftrace_printk noftrace_preempt nobranch annotate nouserstacktrace nosym-
userobj noprintk-msg-only 
linux-glcc:/sys/kernel/debug/tracing # cat buffer_size_kb 
1410
linux-glcc:/sys/kernel/debug/tracing # cat dyn_ftrace_total_info 
14102 0 0
linux-glcc:/sys/kernel/debug/tracing # cat trace_options 
print-parent nosym-offset nosym-addr noverbose noraw nohex nobin noblock nostacktrace nosched-tree ftrace_printk noftrace_preempt nobranch annotate nouserstacktrace nosym-
userobj noprintk-msg-only 
linux-glcc:/sys/kernel/debug/tracing # cat set_ftrace_filter 
linux-glcc:/sys/kernel/debug/tracing # cat tracing_cpumask 
0001
linux-glcc:/sys/kernel/debug/tracing # cat tracing_enabled 
0
linux-glcc:/sys/kernel/debug/tracing # cat tracing_on
1
linux-glcc:/sys/kernel/debug/tracing # echo 1 > tracing_enabled 
linux-glcc:/sys/kernel/debug/tracing # cat tracing_on
1
linux-glcc:/sys/kernel/debug/tracing # cat trace
# tracer: sched_switch
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |

And the dmesg is attached.

Thanks
Nikanth

Initializing cgroup subsys cpuset
Linux version 2.6.29-rc8-9-default (knikanth@linux-glcc) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #88 SMP Mon Mar 23 11:04:19 IST 2009
Command line: root=/dev/disk/by-id/ata-QEMU_HARDDISK_QM00001-part2 resume=/dev/disk/by-id/ata-QEMU_HARDDISK_QM00001-part1 splash=silent vga=0x314
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
PAT WC disabled due to known CPU erratum.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 0000000020000000 (ACPI data)
 BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x1fff0 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-000000001fff0000
 0000000000 - 001fe00000 page 2M
 001fe00000 - 001fff0000 page 4k
kernel direct mapping tables up to 1fff0000 @ 8000-b000
last_map_addr: 1fff0000 end: 1fff0000
RAMDISK: 1f70c000 - 1ffdfb2d
ACPI: RSDP 000FBC80, 0014 (r0 QEMU  )
ACPI: RSDT 1FFF0000, 002C (r1 QEMU   QEMURSDT        1 QEMU        1)
ACPI: FACP 1FFF002C, 0074 (r1 QEMU   QEMUFACP        1 QEMU        1)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 1FFF0100, 24A4 (r1   BXPC   BXDSDT        1 INTL 20081031)
ACPI: FACS 1FFF00C0, 0040
ACPI: APIC 1FFF25A8, 00E0 (r1 QEMU   QEMUAPIC        1 QEMU        1)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000001fff0000
Bootmem setup node 0 0000000000000000-000000001fff0000
  NODE_DATA [0000000000009000 - 000000000003cfff]
  bootmap [000000000003d000 -  0000000000040fff] pages 4
(6 early reservations) ==> bootmem [0000000000 - 001fff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00017fce00]    TEXT DATA BSS ==> [0000200000 - 00017fce00]
  #3 [001f70c000 - 001ffdfb2d]          RAMDISK ==> [001f70c000 - 001ffdfb2d]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
found SMP MP-table at [ffff8800000fbb60] 000fbb60
kvm-clock: cpu 0, msr 0:f8df81, boot clock
 [ffffe20000000000-ffffe20000dfffff] PMD -> [ffff880001a00000-ffff8800027fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001fff0
On node 0 totalpages: 130959
  DMA zone: 104 pages used for memmap
  DMA zone: 102 pages reserved
  DMA zone: 3793 pages, LIFO batch:0
  DMA32 zone: 3224 pages used for memmap
  DMA32 zone: 123736 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0xb008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
ACPI: IRQ5 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ10 used by override.
ACPI: IRQ11 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 16 CPUs, 15 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
Allocating PCI resources starting at 30000000 (gap: 20000000:dffbc000)
NR_CPUS:4096 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
PERCPU: Allocating 1908736 bytes of per cpu data
kvm-clock: cpu 0, msr 0:29cef81, primary cpu clock
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 127529
Policy zone: DMA32
Kernel command line: root=/dev/disk/by-id/ata-QEMU_HARDDISK_QM00001-part2 resume=/dev/disk/by-id/ata-QEMU_HARDDISK_QM00001-part1 splash=silent vga=0x314
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 16384 bytes)
Detected 2327.418 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 4351 kB
 per task-struct memory footprint: 2688 bytes
allocated 5242880 bytes of page_cgroup
please try cgroup_disable=memory option if you don't want
Checking aperture...
No AGP bridge found
Memory: 438260k/524224k available (2862k kernel code, 388k absent, 85576k reserved, 2107k data, 3412k init)
Calibrating delay loop (skipped) preset value.. 4654.83 BogoMIPS (lpj=9309672)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys debug
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 0/0x0 -> Node 0
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
ACPI: Core revision 20081204
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 12627 entries in 100 pages
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: Intel QEMU Virtual CPU version 0.9.1 stepping 03
Testing tracer nop: PASSED
Brought up 1 CPUs
Total of 1 processors activated (4654.83 BogoMIPS).
CPU0 attaching NULL sched-domain.
net_namespace: 1048 bytes
Booting paravirtualized kernel on KVM
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.1: reg 20 io port: [0xc000-0xc00f]
pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
pci 0000:00:02.0: reg 10 32bit mmio: [0xf0000000-0xf1ffffff]
pci 0000:00:02.0: reg 14 32bit mmio: [0xf2000000-0xf2000fff]
pci 0000:00:03.0: reg 10 io port: [0xc100-0xc1ff]
pci 0000:00:03.0: reg 14 32bit mmio: [0xf2001000-0xf20010ff]
pci 0000:00:04.0: reg 10 io port: [0xc200-0xc21f]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 7 devices
ACPI: ACPI bus type pnp unregistered
Switched to high resolution mode on CPU 0
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
TCP established hash table entries: 16384 (order: 6, 262144 bytes)
TCP bind hash table entries: 16384 (order: 8, 1179648 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 9038k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1237788676.716:1): initialized
Testing tracer sched_switch: PASSED
Testing tracer sysprof: PASSED
Testing tracer function: PASSED
Testing dynamic ftrace: PASSED
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 873
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
pci 0000:00:02.0: Boot video device
vesafb: framebuffer at 0xf0000000, mapped to 0xffffc20000280000, using 1875k, total 4096k
vesafb: mode is 800x600x16, linelength=1600, pages=3
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
registered taskstats version 1
Freeing unused kernel memory: 3412k freed
Write protecting the kernel read-only data: 1532k
SCSI subsystem initialized
libata version 3.00 loaded.
ata_piix 0000:00:01.1: version 2.12
ata_piix 0000:00:01.1: setting latency timer to 64
scsi0 : ata_piix
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input1
scsi1 : ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
ata1.00: ATA-7: QEMU HARDDISK, 0.9.1, max UDMA/100
ata1.00: 8388608 sectors, multi 16: LBA48 
ata1.01: ATA-7: QEMU HARDDISK, 0.9.1, max UDMA/100
ata1.01: 8388608 sectors, multi 16: LBA48 
ata1.00: configured for MWDMA2
ata1.01: configured for MWDMA2
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.9. PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     ATA      QEMU HARDDISK    0.9. PQ: 0 ANSI: 5
ata2.00: ATAPI: QEMU DVD-ROM, 0.9.1, max UDMA/100
ata2.00: configured for MWDMA2
scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     0.9. PQ: 0 ANSI: 5
Uniform Multi-Platform E-IDE driver
udevd version 128 started
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors: (4.29 GB/4.00 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors: (4.29 GB/4.00 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:1:0: [sdb] 8388608 512-byte hardware sectors: (4.29 GB/4.00 GiB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: [sdb] 8388608 512-byte hardware sectors: (4.29 GB/4.00 GiB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 0:0:1:0: [sdb] Attached SCSI disk
PM: Starting manual resume from disk
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 128 started
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
8139cp 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, high) -> IRQ 11
eth0: RTL-8139C+ at 0xffffc2000171a000, f2:0d:21:47:b3:16, IRQ 11
8139cp 0000:00:03.0: setting latency timer to 64
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 4x/4x xa/form2 tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
swap_cgroup: uses 1984 bytes of vmalloc for pointer array space and 1015808 bytes to hold mem_cgroup pointers on swap
swap_cgroup can be disabled by noswapaccount boot option.
Adding 506008k swap on /dev/sda1.  Priority:-1 extents:1 across:506008k 
loop: module loaded
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
eth0: link up, 100Mbps, full-duplex, lpa 0x05E1

