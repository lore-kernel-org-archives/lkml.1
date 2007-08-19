Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbXHSE0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbXHSE0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 00:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXHSE0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 00:26:06 -0400
Received: from risingsoftware01.propagation.net ([66.221.33.65]:3597 "EHLO
	risingsoftware01.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbXHSEZ7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 00:25:59 -0400
X-Greylist: delayed 2393 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2007 00:25:59 EDT
Date: Sun, 19 Aug 2007 13:45:58 +1000
From: Hamish Moffatt <hamish@cloud.net.au>
To: linux-kernel@vger.kernel.org
Subject: general protection fault with powernow-k8 frequency scaling on
	x86-64
Message-ID: <20070819034558.GB9431@cloud.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Warning: cloud.net.au is listed at whois.rfc-ignorant.org (127.0.0.7: TLD has no WHOIS server or incomplete data in server)
X-HELO-Warning: Remote host 220.237.181.46 (c220-237-181-46.eburwd3.vic.optusnet.com.au) incorrectly presented itself as noddy.cloud.net.au
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running an Athlon64 x2 system which regularly issues general
protection faults and later crashes whenever frequency scaling is
enabled.

If the system runs at full frequency all the time (eg "performance"
govenor), even with powernow-k8 and other governors loaded, it is
perfectly stable. 

When ondemand or userspace is loaded and the system switches down, 
it will crash within the next few hours. It is generally idle; I can't
see anything in particular that causes it to crash. The crashes seem to
occur in pretty much random processes.

I'm running 2.6.22.1 (Debian's package) although this started happening
at first with about 2.6.17. I've seen other reports on lkml about this
problem occasionally but no solution. eg this one from 2.6.13, although
I never saw it that early:
http://lkml.org/lkml/2005/9/2/131

Here's an example fault; a few more occur a few minutes after that, then
the whole system locks up soon after. The complete kernel log is below.

Any ideas?

thanks
Hamish


Aug 19 06:25:32 noddy kernel: stack segment: 0000 [1] SMP 
Aug 19 06:25:32 noddy kernel: CPU 1 
Aug 19 06:25:32 noddy kernel: Modules linked in: tcp_diag inet_diag binfmt_misc rfcomm l2cap bluetooth lirc_dev tun powernow_k8 processor cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative ipt_ULOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables mkiss ax25 crc16 ipv6 parport_serial parport_pc dm_snapshot dm_mirror dm_mod it87 hwmon_vid i2c_isa lp parport ide_disk ide_generic snd_ens1371 snd_seq_dummy snd_seq_oss firewire_ohci snd_seq_midi snd_seq_midi_event snd_seq firewire_core crc_itu_t snd_rawmidi skge sata_sil snd_seq_device ide_cd cdrom snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore shpchp pci_hotplug forcedeth k8temp snd_page_alloc i2c_nforce2 ehci_hcd ohci_hcd psmouse i2c_core amd74xx serio_raw analog gameport joydev tsdev pcspkr floppy ext3 jbd mbcache raid1 md_mod sd_mod ata_generic sata_nv libata scsi_mod generic ide_core evdev
Aug 19 06:25:32 noddy kernel: Pid: 5200, comm: find Not tainted 2.6.22-1-amd64 #1
Aug 19 06:25:32 noddy kernel: RIP: 0010:[<ffffffff802943f1>]  [<ffffffff802943f1>] __d_lookup+0xdb/0x100
Aug 19 06:25:32 noddy kernel: RSP: 0018:ffff810065a47bf8  EFLAGS: 00010286
Aug 19 06:25:32 noddy kernel: RAX: ffffc20000000000 RBX: ffff81007fd041ed RCX: 0000000000000012
Aug 19 06:25:32 noddy kernel: RDX: 000000000003e761 RSI: 00c3b74333bfe761 RDI: ffff8100611c87d0
Aug 19 06:25:32 noddy kernel: RBP: ccff810064d7f578 R08: 0000000000000000 R09: 0000000000000000
Aug 19 06:25:32 noddy kernel: R10: 2f53454741535345 R11: ffffffff802d3f8e R12: ffff8100611c87d0
Aug 19 06:25:32 noddy kernel: R13: ffff810065a47cb8 R14: 000000002941d172 R15: 0000000000000009
Aug 19 06:25:32 noddy kernel: FS:  00002afa831016e0(0000) GS:ffff81007fd06cc0(0000) knlGS:0000000000000000
Aug 19 06:25:32 noddy kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 19 06:25:32 noddy kernel: CR2: 00002b9c5c009236 CR3: 0000000065a74000 CR4: 00000000000006e0
Aug 19 06:25:32 noddy kernel: Process find (pid: 5200, threadinfo ffff810065a46000, task ffff81006f896200)
Aug 19 06:25:32 noddy kernel: Stack:  ffff810065ae6000 ffff81007fd041ed ffff810065a47e48 ffff8100611ca448
Aug 19 06:25:32 noddy kernel:  ffff81007fcca680 ffff810065a47e48 ffff810065a47cb8 ffffffff8028ae0e
Aug 19 06:25:32 noddy kernel:  ffff8100611c41ed ffff810065a47cc8 ffff81007fcca680 ffff81007fd041ed
Aug 19 06:25:32 noddy kernel: Call Trace:
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028ae0e>] do_lookup+0x2a/0x1ae
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028cfff>] __link_path_walk+0x8ec/0xd9d
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028d508>] link_path_walk+0x58/0xe0
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028d875>] do_path_lookup+0x1a0/0x1c3
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028c38e>] getname+0x14c/0x190
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028e0a5>] __user_walk_fd+0x37/0x53
Aug 19 06:25:32 noddy kernel:  [<ffffffff802870d5>] vfs_lstat_fd+0x18/0x47
Aug 19 06:25:32 noddy kernel:  [<ffffffff802872c9>] sys_newlstat+0x19/0x31
Aug 19 06:25:32 noddy kernel:  [<ffffffff80283cc7>] sys_close+0x8c/0xc9
Aug 19 06:25:32 noddy kernel:  [<ffffffff80209d8e>] system_call+0x7e/0x83
Aug 19 06:25:32 noddy kernel: 
Aug 19 06:25:32 noddy kernel: 
Aug 19 06:25:32 noddy kernel: Code: 48 8b 45 00 0f 18 08 48 8d 5d e8 44 39 73 30 75 e6 e9 70 ff 
Aug 19 06:25:32 noddy kernel: RIP  [<ffffffff802943f1>] __d_lookup+0xdb/0x100
Aug 19 06:25:32 noddy kernel:  RSP <ffff810065a47bf8>


And the complete log..

Aug 19 01:43:28 noddy kernel: klogd 1.5.0#1, log source = /proc/kmsg started.
Aug 19 01:43:28 noddy kernel: Linux version 2.6.22-1-amd64 (Debian 2.6.22-trunk.1~snapshot.9252) (waldi@debian.org) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14+1)) #1 SMP Sat Aug 4 00:40:03 UTC 2007
Aug 19 01:43:28 noddy kernel: Command line: root=/dev/md1 ro console=tty0 8250.nr_uarts=6 vga=795 3
Aug 19 01:43:28 noddy kernel: BIOS-provided physical RAM map:
Aug 19 01:43:28 noddy kernel:  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
Aug 19 01:43:28 noddy kernel:  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
Aug 19 01:43:28 noddy kernel:  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Aug 19 01:43:28 noddy kernel:  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
Aug 19 01:43:28 noddy kernel:  BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
Aug 19 01:43:28 noddy kernel:  BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
Aug 19 01:43:28 noddy kernel:  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Aug 19 01:43:28 noddy kernel: Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Aug 19 01:43:28 noddy kernel: Entering add_active_range(0, 256, 524272) 1 entries of 3200 used
Aug 19 01:43:28 noddy kernel: end_pfn_map = 1048576
Aug 19 01:43:28 noddy kernel: DMI 2.3 present.
Aug 19 01:43:28 noddy kernel: ACPI: RSDP 000F6C90, 0014 (r0 Nvidia)
Aug 19 01:43:28 noddy kernel: ACPI: RSDT 7FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
Aug 19 01:43:28 noddy kernel: ACPI: FACP 7FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
Aug 19 01:43:28 noddy kernel: ACPI: DSDT 7FFF30C0, 4AC4 (r1 NVIDIA AWRDACPI     1000 MSFT  100000C)
Aug 19 01:43:28 noddy kernel: ACPI: FACS 7FFF0000, 0040
Aug 19 01:43:28 noddy kernel: ACPI: APIC 7FFF7BC0, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD  1010101)
Aug 19 01:43:28 noddy kernel: Scanning NUMA topology in Northbridge 24
Aug 19 01:43:28 noddy kernel: No NUMA configuration found
Aug 19 01:43:28 noddy kernel: Faking a node at 0000000000000000-000000007fff0000
Aug 19 01:43:28 noddy kernel: Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Aug 19 01:43:28 noddy kernel: Entering add_active_range(0, 256, 524272) 1 entries of 3200 used
Aug 19 01:43:28 noddy kernel: Bootmem setup node 0 0000000000000000-000000007fff0000
Aug 19 01:43:28 noddy kernel: Zone PFN ranges:
Aug 19 01:43:28 noddy kernel:   DMA             0 ->     4096
Aug 19 01:43:28 noddy kernel:   DMA32        4096 ->  1048576
Aug 19 01:43:28 noddy kernel:   Normal    1048576 ->  1048576
Aug 19 01:43:28 noddy kernel: early_node_map[2] active PFN ranges
Aug 19 01:43:28 noddy kernel:     0:        0 ->      159
Aug 19 01:43:28 noddy kernel:     0:      256 ->   524272
Aug 19 01:43:28 noddy kernel: On node 0 totalpages: 524175
Aug 19 01:43:28 noddy kernel:   DMA zone: 56 pages used for memmap
Aug 19 01:43:28 noddy kernel:   DMA zone: 1024 pages reserved
Aug 19 01:43:28 noddy kernel:   DMA zone: 2919 pages, LIFO batch:0
Aug 19 01:43:28 noddy kernel:   DMA32 zone: 7111 pages used for memmap
Aug 19 01:43:28 noddy kernel:   DMA32 zone: 513065 pages, LIFO batch:31
Aug 19 01:43:28 noddy kernel:   Normal zone: 0 pages used for memmap
Aug 19 01:43:28 noddy kernel: Nvidia board detected. Ignoring ACPI timer override.
Aug 19 01:43:28 noddy kernel: If you got timer trouble try acpi_use_timer_override
Aug 19 01:43:28 noddy kernel: ACPI: PM-Timer IO Port: 0x1008
Aug 19 01:43:28 noddy kernel: ACPI: Local APIC address 0xfee00000
Aug 19 01:43:28 noddy kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Aug 19 01:43:28 noddy kernel: Processor #0 (Bootup-CPU)
Aug 19 01:43:28 noddy kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Aug 19 01:43:28 noddy kernel: Processor #1
Aug 19 01:43:28 noddy kernel: ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
Aug 19 01:43:28 noddy kernel: ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
Aug 19 01:43:28 noddy kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Aug 19 01:43:28 noddy kernel: IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
Aug 19 01:43:28 noddy kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Aug 19 01:43:28 noddy kernel: ACPI: BIOS IRQ0 pin2 override ignored.
Aug 19 01:43:28 noddy kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Aug 19 01:43:28 noddy kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
Aug 19 01:43:28 noddy kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
Aug 19 01:43:28 noddy kernel: ACPI: IRQ9 used by override.
Aug 19 01:43:28 noddy kernel: ACPI: IRQ14 used by override.
Aug 19 01:43:28 noddy kernel: ACPI: IRQ15 used by override.
Aug 19 01:43:28 noddy kernel: Setting APIC routing to flat
Aug 19 01:43:28 noddy kernel: Using ACPI (MADT) for SMP configuration information
Aug 19 01:43:28 noddy kernel: swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
Aug 19 01:43:28 noddy kernel: swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
Aug 19 01:43:28 noddy kernel: swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
Aug 19 01:43:28 noddy kernel: Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Aug 19 01:43:28 noddy kernel: SMP: Allowing 2 CPUs, 0 hotplug CPUs
Aug 19 01:43:28 noddy kernel: PERCPU: Allocating 37896 bytes of per cpu data
Aug 19 01:43:28 noddy kernel: Built 1 zonelists.  Total pages: 515984
Aug 19 01:43:28 noddy kernel: Kernel command line: root=/dev/md1 ro console=tty0 8250.nr_uarts=6 vga=795 3
Aug 19 01:43:28 noddy kernel: Initializing CPU#0
Aug 19 01:43:28 noddy kernel: PID hash table entries: 4096 (order: 12, 32768 bytes)
Aug 19 01:43:28 noddy kernel: Marking TSC unstable due to TSCs unsynchronized
Aug 19 01:43:28 noddy kernel: time.c: Detected 2210.126 MHz processor.
Aug 19 01:43:28 noddy kernel: Console: colour dummy device 80x25
Aug 19 01:43:28 noddy kernel: Checking aperture...
Aug 19 01:43:28 noddy kernel: CPU 0: aperture @ f0000000 size 128 MB
Aug 19 01:43:28 noddy kernel: Memory: 2062332k/2097088k available (2017k kernel code, 34368k reserved, 950k data, 296k init)
Aug 19 01:43:28 noddy kernel: Calibrating delay using timer specific routine.. 4422.87 BogoMIPS (lpj=8845758)
Aug 19 01:43:28 noddy kernel: Security Framework v1.0.0 initialized
Aug 19 01:43:28 noddy kernel: SELinux:  Disabled at boot.
Aug 19 01:43:28 noddy kernel: Capability LSM initialized
Aug 19 01:43:28 noddy kernel: Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Aug 19 01:43:28 noddy kernel: Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Aug 19 01:43:28 noddy kernel: Mount-cache hash table entries: 256
Aug 19 01:43:28 noddy kernel: CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Aug 19 01:43:28 noddy kernel: CPU: L2 Cache: 512K (64 bytes/line)
Aug 19 01:43:28 noddy kernel: CPU 0/0 -> Node 0
Aug 19 01:43:28 noddy kernel: CPU: Physical Processor ID: 0
Aug 19 01:43:28 noddy kernel: CPU: Processor Core ID: 0
Aug 19 01:43:28 noddy kernel: SMP alternatives: switching to UP code
Aug 19 01:43:28 noddy kernel: ACPI: Core revision 20070126
Aug 19 01:43:28 noddy kernel: Using local APIC timer interrupts.
Aug 19 01:43:28 noddy kernel: result 12557558
Aug 19 01:43:28 noddy kernel: Detected 12.557 MHz APIC timer.
Aug 19 01:43:28 noddy kernel: SMP alternatives: switching to SMP code
Aug 19 01:43:28 noddy kernel: Booting processor 1/2 APIC 0x1
Aug 19 01:43:28 noddy kernel: Initializing CPU#1
Aug 19 01:43:28 noddy kernel: Calibrating delay using timer specific routine.. 4420.50 BogoMIPS (lpj=8841007)
Aug 19 01:43:28 noddy kernel: CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Aug 19 01:43:28 noddy kernel: CPU: L2 Cache: 512K (64 bytes/line)
Aug 19 01:43:28 noddy kernel: CPU 1/1 -> Node 0
Aug 19 01:43:28 noddy kernel: CPU: Physical Processor ID: 0
Aug 19 01:43:28 noddy kernel: CPU: Processor Core ID: 1
Aug 19 01:43:28 noddy kernel: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 01
Aug 19 01:43:28 noddy kernel: Brought up 2 CPUs
Aug 19 01:43:28 noddy kernel: migration_cost=322
Aug 19 01:43:28 noddy kernel: NET: Registered protocol family 16
Aug 19 01:43:28 noddy kernel: ACPI: bus type pci registered
Aug 19 01:43:28 noddy kernel: PCI: Using configuration type 1
Aug 19 01:43:28 noddy kernel: ACPI: Interpreter enabled
Aug 19 01:43:28 noddy kernel: ACPI: (supports S0 S1 S4 S5)
Aug 19 01:43:28 noddy kernel: ACPI: Using IOAPIC for interrupt routing
Aug 19 01:43:28 noddy kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Aug 19 01:43:28 noddy kernel: PCI: Probing PCI hardware (bus 00)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APC5] (IRQs *16)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCS] (IRQs *23)
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22) *0, disabled.
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22) *0
Aug 19 01:43:28 noddy kernel: ACPI: Power Resource [ISAV] (on)
Aug 19 01:43:28 noddy kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
Aug 19 01:43:28 noddy kernel: pnp: PnP ACPI init
Aug 19 01:43:28 noddy kernel: ACPI: bus type pnp registered
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0C02
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0C01
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0A03
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0C02
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0200
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0B00
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0800
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0C04
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0700
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0501
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0501
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0400
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0F13
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNP0303
Aug 19 01:43:28 noddy kernel: pnp: ACPI device : hid PNPB02F
Aug 19 01:43:28 noddy kernel: pnp: PnP ACPI: found 15 devices
Aug 19 01:43:28 noddy kernel: ACPI: ACPI bus type pnp unregistered
Aug 19 01:43:28 noddy kernel: usbcore: registered new interface driver usbfs
Aug 19 01:43:28 noddy kernel: usbcore: registered new interface driver hub
Aug 19 01:43:28 noddy kernel: usbcore: registered new device driver usb
Aug 19 01:43:28 noddy kernel: PCI: Using ACPI for IRQ routing
Aug 19 01:43:28 noddy kernel: PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Aug 19 01:43:28 noddy kernel: PCI: Cannot allocate resource region 0 of device 0000:00:00.0
Aug 19 01:43:28 noddy kernel: NET: Registered protocol family 8
Aug 19 01:43:28 noddy kernel: NET: Registered protocol family 20
Aug 19 01:43:28 noddy kernel: agpgart: Detected AGP bridge 0
Aug 19 01:43:28 noddy kernel: agpgart: Setting up Nforce3 AGP.
Aug 19 01:43:28 noddy kernel: agpgart: AGP aperture is 128M @ 0xf0000000
Aug 19 01:43:28 noddy kernel: ACPI: RTC can wake from S4
Aug 19 01:43:28 noddy kernel: pnp: the driver 'system' has been registered
Aug 19 01:43:28 noddy kernel: pnp: match found with the PnP device '00:00' and the driver 'system'
Aug 19 01:43:28 noddy kernel: pnp: 00:00: ioport range 0x1000-0x107f has been reserved
Aug 19 01:43:28 noddy kernel: pnp: 00:00: ioport range 0x1080-0x10ff has been reserved
Aug 19 01:43:28 noddy kernel: pnp: 00:00: ioport range 0x1400-0x147f has been reserved
Aug 19 01:43:28 noddy kernel: pnp: 00:00: ioport range 0x1480-0x14ff has been reserved
Aug 19 01:43:28 noddy kernel: pnp: 00:00: ioport range 0x1800-0x187f has been reserved
Aug 19 01:43:28 noddy kernel: pnp: 00:00: ioport range 0x1880-0x18ff has been reserved
Aug 19 01:43:28 noddy kernel: pnp: match found with the PnP device '00:01' and the driver 'system'
Aug 19 01:43:28 noddy kernel: pnp: 00:01: iomem range 0xd4800-0xd7fff has been reserved
Aug 19 01:43:28 noddy kernel: pnp: 00:01: iomem range 0xf0000-0xf7fff could not be reserved
Aug 19 01:43:28 noddy kernel: pnp: 00:01: iomem range 0xf8000-0xfbfff could not be reserved
Aug 19 01:43:28 noddy kernel: pnp: 00:01: iomem range 0xfc000-0xfffff could not be reserved
Aug 19 01:43:28 noddy kernel: pnp: match found with the PnP device '00:03' and the driver 'system'
Aug 19 01:43:28 noddy kernel: PCI: Bridge: 0000:00:0b.0
Aug 19 01:43:28 noddy kernel:   IO window: disabled.
Aug 19 01:43:28 noddy kernel:   MEM window: f8000000-faffffff
Aug 19 01:43:28 noddy kernel:   PREFETCH window: e0000000-efffffff
Aug 19 01:43:28 noddy kernel: PCI: Bridge: 0000:00:0e.0
Aug 19 01:43:28 noddy kernel:   IO window: 7000-afff
Aug 19 01:43:28 noddy kernel:   MEM window: fb000000-fcffffff
Aug 19 01:43:28 noddy kernel:   PREFETCH window: 88000000-880fffff
Aug 19 01:43:28 noddy kernel: PCI: Setting latency timer of device 0000:00:0e.0 to 64
Aug 19 01:43:28 noddy kernel: NET: Registered protocol family 2
Aug 19 01:43:28 noddy kernel: Time: acpi_pm clocksource has been installed.
Aug 19 01:43:28 noddy kernel: IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
Aug 19 01:43:28 noddy kernel: TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
Aug 19 01:43:28 noddy kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Aug 19 01:43:28 noddy kernel: TCP: Hash tables configured (established 262144 bind 65536)
Aug 19 01:43:28 noddy kernel: TCP reno registered
Aug 19 01:43:28 noddy kernel: checking if image is initramfs... it is
Aug 19 01:43:28 noddy kernel: Freeing initrd memory: 1403k freed
Aug 19 01:43:28 noddy kernel: audit: initializing netlink socket (disabled)
Aug 19 01:43:28 noddy kernel: audit(1187487781.592:1): initialized
Aug 19 01:43:28 noddy kernel: VFS: Disk quotas dquot_6.5.1
Aug 19 01:43:28 noddy kernel: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Aug 19 01:43:28 noddy kernel: io scheduler noop registered
Aug 19 01:43:28 noddy kernel: io scheduler anticipatory registered
Aug 19 01:43:28 noddy kernel: io scheduler deadline registered
Aug 19 01:43:28 noddy kernel: io scheduler cfq registered (default)
Aug 19 01:43:28 noddy kernel: Boot video device is 0000:01:00.0
Aug 19 01:43:28 noddy kernel: vesafb: framebuffer at 0xe0000000, mapped to 0xffffc20000b80000, using 10240k, total 131072k
Aug 19 01:43:28 noddy kernel: vesafb: mode is 1280x1024x32, linelength=5120, pages=0
Aug 19 01:43:28 noddy kernel: vesafb: scrolling: redraw
Aug 19 01:43:28 noddy kernel: vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
Aug 19 01:43:28 noddy kernel: Console: switching to colour frame buffer device 160x64
Aug 19 01:43:28 noddy kernel: fb0: VESA VGA frame buffer device
Aug 19 01:43:28 noddy kernel: Real Time Clock Driver v1.12ac
Aug 19 01:43:28 noddy kernel: Linux agpgart interface v0.102 (c) Dave Jones
Aug 19 01:43:28 noddy kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 6 ports, IRQ sharing enabled
Aug 19 01:43:28 noddy kernel: pnp: the driver 'serial' has been registered
Aug 19 01:43:28 noddy kernel: pnp: match found with the PnP device '00:09' and the driver 'serial'
Aug 19 01:43:28 noddy kernel: 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Aug 19 01:43:28 noddy kernel: pnp: match found with the PnP device '00:0a' and the driver 'serial'
Aug 19 01:43:28 noddy kernel: 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
Aug 19 01:43:28 noddy kernel: 0000:02:09.0: ttyS2 at I/O 0x7400 (irq = 17) is a 16550A
Aug 19 01:43:28 noddy kernel: 0000:02:09.0: ttyS3 at I/O 0x7408 (irq = 17) is a 16550A
Aug 19 01:43:28 noddy kernel: RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
Aug 19 01:43:28 noddy kernel: pnp: the driver 'i8042 kbd' has been registered
Aug 19 01:43:28 noddy kernel: pnp: match found with the PnP device '00:0d' and the driver 'i8042 kbd'
Aug 19 01:43:28 noddy kernel: pnp: the driver 'i8042 aux' has been registered
Aug 19 01:43:28 noddy kernel: pnp: match found with the PnP device '00:0c' and the driver 'i8042 aux'
Aug 19 01:43:28 noddy kernel: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Aug 19 01:43:28 noddy kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Aug 19 01:43:28 noddy kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Aug 19 01:43:28 noddy kernel: mice: PS/2 mouse device common for all mice
Aug 19 01:43:28 noddy kernel: TCP bic registered
Aug 19 01:43:28 noddy kernel: NET: Registered protocol family 1
Aug 19 01:43:28 noddy kernel: NET: Registered protocol family 17
Aug 19 01:43:28 noddy kernel: Freeing unused kernel memory: 296k freed
Aug 19 01:43:28 noddy kernel: Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Aug 19 01:43:28 noddy kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Aug 19 01:43:28 noddy kernel: pnp: the driver 'ide' has been registered
Aug 19 01:43:28 noddy kernel: SCSI subsystem initialized
Aug 19 01:43:28 noddy kernel: input: AT Translated Set 2 keyboard as /class/input/input0
Aug 19 01:43:28 noddy kernel: libata version 2.21 loaded.
Aug 19 01:43:28 noddy kernel: sata_nv 0000:00:0a.0: version 3.4
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APSJ] -> GSI 22 (level, high) -> IRQ 22
Aug 19 01:43:28 noddy kernel: PCI: Setting latency timer of device 0000:00:0a.0 to 64
Aug 19 01:43:28 noddy kernel: scsi0 : sata_nv
Aug 19 01:43:28 noddy kernel: scsi1 : sata_nv
Aug 19 01:43:28 noddy kernel: ata1: SATA max UDMA/133 cmd 0x00000000000109f0 ctl 0x0000000000010bf2 bmdma 0x000000000001dc00 irq 22
Aug 19 01:43:28 noddy kernel: ata2: SATA max UDMA/133 cmd 0x0000000000010970 ctl 0x0000000000010b72 bmdma 0x000000000001dc08 irq 22
Aug 19 01:43:28 noddy kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 19 01:43:28 noddy kernel: ata1.00: ATA-7: WDC WD2000JS-00MHB0, 02.01C03, max UDMA/133
Aug 19 01:43:28 noddy kernel: ata1.00: 390721968 sectors, multi 16: LBA48 
Aug 19 01:43:28 noddy kernel: ata1.00: configured for UDMA/133
Aug 19 01:43:28 noddy kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Aug 19 01:43:28 noddy kernel: ata2.00: ATA-7: WDC WD2000JS-00MHB0, 02.01C03, max UDMA/133
Aug 19 01:43:28 noddy kernel: ata2.00: 390721968 sectors, multi 16: LBA48 
Aug 19 01:43:28 noddy kernel: ata2.00: configured for UDMA/133
Aug 19 01:43:28 noddy kernel: scsi 0:0:0:0: Direct-Access     ATA      WDC WD2000JS-00M 02.0 PQ: 0 ANSI: 5
Aug 19 01:43:28 noddy kernel: scsi 1:0:0:0: Direct-Access     ATA      WDC WD2000JS-00M 02.0 PQ: 0 ANSI: 5
Aug 19 01:43:28 noddy kernel: sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
Aug 19 01:43:28 noddy kernel: sd 0:0:0:0: [sda] Write Protect is off
Aug 19 01:43:28 noddy kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 19 01:43:28 noddy kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 19 01:43:28 noddy kernel: sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
Aug 19 01:43:28 noddy kernel: sd 0:0:0:0: [sda] Write Protect is off
Aug 19 01:43:28 noddy kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Aug 19 01:43:28 noddy kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 19 01:43:28 noddy kernel:  sda: sda1 sda2
Aug 19 01:43:28 noddy kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Aug 19 01:43:28 noddy kernel: sd 1:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
Aug 19 01:43:28 noddy kernel: sd 1:0:0:0: [sdb] Write Protect is off
Aug 19 01:43:28 noddy kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 19 01:43:28 noddy kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 19 01:43:28 noddy kernel: sd 1:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
Aug 19 01:43:28 noddy kernel: sd 1:0:0:0: [sdb] Write Protect is off
Aug 19 01:43:28 noddy kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Aug 19 01:43:28 noddy kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 19 01:43:28 noddy kernel:  sdb: sdb1 sdb2
Aug 19 01:43:28 noddy kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
Aug 19 01:43:28 noddy kernel: md: raid1 personality registered for level 1
Aug 19 01:43:28 noddy kernel: md: md1 stopped.
Aug 19 01:43:28 noddy kernel: md: bind<sda2>
Aug 19 01:43:28 noddy kernel: md: bind<sdb2>
Aug 19 01:43:28 noddy kernel: raid1: raid set md1 active with 2 out of 2 mirrors
Aug 19 01:43:28 noddy kernel: kjournald starting.  Commit interval 5 seconds
Aug 19 01:43:28 noddy kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug 19 01:43:28 noddy kernel: Floppy drive(s): fd0 is 1.44M
Aug 19 01:43:28 noddy kernel: input: PC Speaker as /class/input/input1
Aug 19 01:43:28 noddy kernel: FDC 0 is a post-1991 82077
Aug 19 01:43:28 noddy kernel: NFORCE3-250: IDE controller at PCI slot 0000:00:08.0
Aug 19 01:43:28 noddy kernel: NFORCE3-250: chipset revision 162
Aug 19 01:43:28 noddy kernel: NFORCE3-250: not 100% native mode: will probe irqs later
Aug 19 01:43:28 noddy kernel: NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
Aug 19 01:43:28 noddy kernel: NFORCE3-250: 0000:00:08.0 (rev a2) UDMA133 controller
Aug 19 01:43:28 noddy kernel:     ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
Aug 19 01:43:28 noddy kernel:     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Aug 19 01:43:28 noddy kernel: Probing IDE interface ide0...
Aug 19 01:43:28 noddy kernel: ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
Aug 19 01:43:28 noddy kernel: forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
Aug 19 01:43:28 noddy kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Aug 19 01:43:28 noddy kernel: Probing IDE interface ide1...
Aug 19 01:43:28 noddy kernel: input: ImPS/2 Generic Wheel Mouse as /class/input/input2
Aug 19 01:43:28 noddy kernel: hdc: PIONEER DVD-RW DVR-111D, ATAPI CD/DVD-ROM drive
Aug 19 01:43:28 noddy kernel: ide1 at 0x170-0x177,0x376 on irq 15
Aug 19 01:43:28 noddy kernel: i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
Aug 19 01:43:28 noddy kernel: i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2000
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCL] enabled at IRQ 21
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [APCL] -> GSI 21 (level, high) -> IRQ 21
Aug 19 01:43:28 noddy kernel: PCI: Setting latency timer of device 0000:00:02.2 to 64
Aug 19 01:43:28 noddy kernel: ehci_hcd 0000:00:02.2: EHCI Host Controller
Aug 19 01:43:28 noddy kernel: ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
Aug 19 01:43:28 noddy kernel: ehci_hcd 0000:00:02.2: debug port 1
Aug 19 01:43:28 noddy kernel: PCI: cache line size of 64 is not supported by device 0000:00:02.2
Aug 19 01:43:28 noddy kernel: ehci_hcd 0000:00:02.2: irq 21, io mem 0xfd005000
Aug 19 01:43:28 noddy kernel: ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Aug 19 01:43:28 noddy kernel: usb usb1: configuration #1 chosen from 1 choice
Aug 19 01:43:28 noddy kernel: hub 1-0:1.0: USB hub found
Aug 19 01:43:28 noddy kernel: hub 1-0:1.0: 8 ports detected
Aug 19 01:43:28 noddy kernel: hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2000kB Cache, UDMA(66)
Aug 19 01:43:28 noddy kernel: Uniform CD-ROM driver Revision: 3.20
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCH] enabled at IRQ 20
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APCH] -> GSI 20 (level, high) -> IRQ 20
Aug 19 01:43:28 noddy kernel: PCI: Setting latency timer of device 0000:00:05.0 to 64
Aug 19 01:43:28 noddy kernel: eth0: forcedeth.c: subsystem: 01458:e000 bound to 0000:00:05.0
Aug 19 01:43:28 noddy kernel: shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, high) -> IRQ 22
Aug 19 01:43:28 noddy kernel: PCI: Setting latency timer of device 0000:00:02.0 to 64
Aug 19 01:43:28 noddy kernel: ohci_hcd 0000:00:02.0: OHCI Host Controller
Aug 19 01:43:28 noddy kernel: ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
Aug 19 01:43:28 noddy kernel: ohci_hcd 0000:00:02.0: irq 22, io mem 0xfd003000
Aug 19 01:43:28 noddy kernel: usb usb2: configuration #1 chosen from 1 choice
Aug 19 01:43:28 noddy kernel: hub 2-0:1.0: USB hub found
Aug 19 01:43:28 noddy kernel: hub 2-0:1.0: 4 ports detected
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCG] enabled at IRQ 21
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCG] -> GSI 21 (level, high) -> IRQ 21
Aug 19 01:43:28 noddy kernel: PCI: Setting latency timer of device 0000:00:02.1 to 64
Aug 19 01:43:28 noddy kernel: ohci_hcd 0000:00:02.1: OHCI Host Controller
Aug 19 01:43:28 noddy kernel: ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
Aug 19 01:43:28 noddy kernel: ohci_hcd 0000:00:02.1: irq 21, io mem 0xfd004000
Aug 19 01:43:28 noddy kernel: usb usb3: configuration #1 chosen from 1 choice
Aug 19 01:43:28 noddy kernel: hub 3-0:1.0: USB hub found
Aug 19 01:43:28 noddy kernel: hub 3-0:1.0: 4 ports detected
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 20
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [APCJ] -> GSI 20 (level, high) -> IRQ 20
Aug 19 01:43:28 noddy kernel: PCI: Setting latency timer of device 0000:00:06.0 to 64
Aug 19 01:43:28 noddy kernel: intel8x0_measure_ac97_clock: measured 58689 usecs
Aug 19 01:43:28 noddy kernel: intel8x0: clocking to 46951
Aug 19 01:43:28 noddy kernel: sata_sil 0000:02:0d.0: version 2.2
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:02:0d.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
Aug 19 01:43:28 noddy kernel: scsi2 : sata_sil
Aug 19 01:43:28 noddy kernel: scsi3 : sata_sil
Aug 19 01:43:28 noddy kernel: ata3: SATA max UDMA/100 cmd 0xffffc2000032a080 ctl 0xffffc2000032a08a bmdma 0xffffc2000032a000 irq 17
Aug 19 01:43:28 noddy kernel: ata4: SATA max UDMA/100 cmd 0xffffc2000032a0c0 ctl 0xffffc2000032a0ca bmdma 0xffffc2000032a008 irq 17
Aug 19 01:43:28 noddy kernel: ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
Aug 19 01:43:28 noddy kernel: ata3.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
Aug 19 01:43:28 noddy kernel: ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
Aug 19 01:43:28 noddy kernel: ata3.00: configured for UDMA/100
Aug 19 01:43:28 noddy kernel: ata4: SATA link down (SStatus 0 SControl 310)
Aug 19 01:43:28 noddy kernel: scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
Aug 19 01:43:28 noddy kernel: sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
Aug 19 01:43:28 noddy kernel: sd 2:0:0:0: [sdc] Write Protect is off
Aug 19 01:43:28 noddy kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Aug 19 01:43:28 noddy kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 19 01:43:28 noddy kernel: sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
Aug 19 01:43:28 noddy kernel: sd 2:0:0:0: [sdc] Write Protect is off
Aug 19 01:43:28 noddy kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Aug 19 01:43:28 noddy kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Aug 19 01:43:28 noddy kernel:  sdc: sdc1 sdc2
Aug 19 01:43:28 noddy kernel: sd 2:0:0:0: [sdc] Attached SCSI disk
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:02:0b.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
Aug 19 01:43:28 noddy kernel: skge 1.11 addr 0xfc000000 irq 19 chip Yukon-Lite rev 9
Aug 19 01:43:28 noddy kernel: skge eth1: addr 00:0f:ea:73:e2:5f
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
Aug 19 01:43:28 noddy kernel: firewire_ohci: Added fw-ohci device 0000:02:0e.0, OHCI version 1.10
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:02:08.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
Aug 19 01:43:28 noddy kernel: firewire_core: created new fw device fw0 (0 config rom retries)
Aug 19 01:43:28 noddy kernel: EXT3 FS on md1, internal journal
Aug 19 01:43:28 noddy kernel: Probing IDE interface ide0...
Aug 19 01:43:28 noddy kernel: lp: driver loaded but no devices found
Aug 19 01:43:28 noddy kernel: it87: Found IT8712F chip at 0x290, revision 5
Aug 19 01:43:28 noddy kernel: device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Aug 19 01:43:28 noddy kernel: md: md0 stopped.
Aug 19 01:43:28 noddy kernel: md: bind<sda1>
Aug 19 01:43:28 noddy kernel: md: bind<sdb1>
Aug 19 01:43:28 noddy kernel: raid1: raid set md0 active with 2 out of 2 mirrors
Aug 19 01:43:28 noddy kernel: Adding 995896k swap on /dev/md0.  Priority:-1 extents:1 across:995896k
Aug 19 01:43:28 noddy kernel: pnp: the driver 'parport_pc' has been registered
Aug 19 01:43:28 noddy kernel: pnp: match found with the PnP device '00:0b' and the driver 'parport_pc'
Aug 19 01:43:28 noddy kernel: parport_pc 00:0b: reported by Plug and Play ACPI
Aug 19 01:43:28 noddy kernel: parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Aug 19 01:43:28 noddy kernel: parport0: Printer, Hewlett-Packard HP LaserJet 5L
Aug 19 01:43:28 noddy kernel: lp0: using parport0 (interrupt-driven).
Aug 19 01:43:28 noddy kernel: ACPI: PCI Interrupt 0000:02:0a.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
Aug 19 01:43:28 noddy kernel: parport1: PC-style at 0x8000 [PCSPP,TRISTATE,EPP]
Aug 19 01:43:28 noddy kernel: lp1: using parport1 (polling).
Aug 19 01:43:28 noddy kernel: 0000:02:0a.0: ttyS4 at I/O 0x7800 (irq = 18) is a 16550A
Aug 19 01:43:28 noddy kernel: 0000:02:0a.0: ttyS5 at I/O 0x7c00 (irq = 18) is a 16550A
Aug 19 01:43:28 noddy kernel: skge eth1: enabling interface
Aug 19 01:43:28 noddy kernel: NET: Registered protocol family 10
Aug 19 01:43:28 noddy kernel: lo: Disabled Privacy Extensions
Aug 19 01:43:28 noddy kernel: ADDRCONF(NETDEV_UP): eth1: link is not ready
Aug 19 01:43:28 noddy kernel: NET: Registered protocol family 3
Aug 19 01:43:28 noddy kernel: mkiss: AX.25 Multikiss, Hans Albas PE1AYX
Aug 19 01:43:28 noddy kernel: mkiss: ax0: crc mode is auto.
Aug 19 01:43:28 noddy kernel: ADDRCONF(NETDEV_CHANGE): ax0: link becomes ready
Aug 19 01:43:28 noddy kernel: skge eth1: Link is up at 1000 Mbps, full duplex, flow control both
Aug 19 01:43:28 noddy kernel: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
Aug 19 01:43:28 noddy kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Aug 19 01:43:28 noddy kernel: Netfilter messages via NETLINK v0.30.
Aug 19 01:43:28 noddy kernel: nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
Aug 19 01:43:28 noddy kernel: powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ processors (version 2.00.00)
Aug 19 01:43:28 noddy kernel: powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x8
Aug 19 01:43:28 noddy kernel: powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x12
Aug 19 01:43:31 noddy kernel: tun: Universal TUN/TAP device driver, 1.6
Aug 19 01:43:31 noddy kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Aug 19 01:43:31 noddy kernel: tun0: Disabled Privacy Extensions
Aug 19 01:43:32 noddy kernel: tun1: Disabled Privacy Extensions
Aug 19 01:43:32 noddy kernel: lirc_dev: IR Remote Control driver registered, at major 61 
Aug 19 01:43:32 noddy kernel: lirc_igorplugusb: disagrees about version of symbol struct_module
Aug 19 01:43:34 noddy kernel: eth1: no IPv6 routers present
Aug 19 01:43:58 noddy kernel: Bluetooth: Core ver 2.11
Aug 19 01:43:58 noddy kernel: NET: Registered protocol family 31
Aug 19 01:43:58 noddy kernel: Bluetooth: HCI device and connection manager initialized
Aug 19 01:43:58 noddy kernel: Bluetooth: HCI socket layer initialized
Aug 19 01:43:58 noddy kernel: Bluetooth: L2CAP ver 2.8
Aug 19 01:43:58 noddy kernel: Bluetooth: L2CAP socket layer initialized
Aug 19 01:43:59 noddy kernel: Bluetooth: RFCOMM socket layer initialized
Aug 19 01:43:59 noddy kernel: Bluetooth: RFCOMM TTY layer initialized
Aug 19 01:43:59 noddy kernel: Bluetooth: RFCOMM ver 1.8
Aug 19 01:46:17 noddy kernel: atkbd.c: Unknown key pressed (translated set 2, code 0xbc on isa0060/serio0).
Aug 19 01:46:17 noddy kernel: atkbd.c: Use 'setkeycodes e03c <keycode>' to make it known.
Aug 19 01:46:17 noddy kernel: atkbd.c: Unknown key released (translated set 2, code 0xbc on isa0060/serio0).
Aug 19 01:46:17 noddy kernel: atkbd.c: Use 'setkeycodes e03c <keycode>' to make it known.
Aug 19 06:25:32 noddy kernel: stack segment: 0000 [1] SMP 
Aug 19 06:25:32 noddy kernel: CPU 1 
Aug 19 06:25:32 noddy kernel: Modules linked in: tcp_diag inet_diag binfmt_misc rfcomm l2cap bluetooth lirc_dev tun powernow_k8 processor cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative ipt_ULOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables mkiss ax25 crc16 ipv6 parport_serial parport_pc dm_snapshot dm_mirror dm_mod it87 hwmon_vid i2c_isa lp parport ide_disk ide_generic snd_ens1371 snd_seq_dummy snd_seq_oss firewire_ohci snd_seq_midi snd_seq_midi_event snd_seq firewire_core crc_itu_t snd_rawmidi skge sata_sil snd_seq_device ide_cd cdrom snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore shpchp pci_hotplug forcedeth k8temp snd_page_alloc i2c_nforce2 ehci_hcd ohci_hcd psmouse i2c_core amd74xx serio_raw analog gameport joydev tsdev pcspkr floppy ext3 jbd mbcache raid1 md_mod sd_mod ata_generic sata_nv libata scsi_mod generic ide_core evdev
Aug 19 06:25:32 noddy kernel: Pid: 5200, comm: find Not tainted 2.6.22-1-amd64 #1
Aug 19 06:25:32 noddy kernel: RIP: 0010:[<ffffffff802943f1>]  [<ffffffff802943f1>] __d_lookup+0xdb/0x100
Aug 19 06:25:32 noddy kernel: RSP: 0018:ffff810065a47bf8  EFLAGS: 00010286
Aug 19 06:25:32 noddy kernel: RAX: ffffc20000000000 RBX: ffff81007fd041ed RCX: 0000000000000012
Aug 19 06:25:32 noddy kernel: RDX: 000000000003e761 RSI: 00c3b74333bfe761 RDI: ffff8100611c87d0
Aug 19 06:25:32 noddy kernel: RBP: ccff810064d7f578 R08: 0000000000000000 R09: 0000000000000000
Aug 19 06:25:32 noddy kernel: R10: 2f53454741535345 R11: ffffffff802d3f8e R12: ffff8100611c87d0
Aug 19 06:25:32 noddy kernel: R13: ffff810065a47cb8 R14: 000000002941d172 R15: 0000000000000009
Aug 19 06:25:32 noddy kernel: FS:  00002afa831016e0(0000) GS:ffff81007fd06cc0(0000) knlGS:0000000000000000
Aug 19 06:25:32 noddy kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 19 06:25:32 noddy kernel: CR2: 00002b9c5c009236 CR3: 0000000065a74000 CR4: 00000000000006e0
Aug 19 06:25:32 noddy kernel: Process find (pid: 5200, threadinfo ffff810065a46000, task ffff81006f896200)
Aug 19 06:25:32 noddy kernel: Stack:  ffff810065ae6000 ffff81007fd041ed ffff810065a47e48 ffff8100611ca448
Aug 19 06:25:32 noddy kernel:  ffff81007fcca680 ffff810065a47e48 ffff810065a47cb8 ffffffff8028ae0e
Aug 19 06:25:32 noddy kernel:  ffff8100611c41ed ffff810065a47cc8 ffff81007fcca680 ffff81007fd041ed
Aug 19 06:25:32 noddy kernel: Call Trace:
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028ae0e>] do_lookup+0x2a/0x1ae
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028cfff>] __link_path_walk+0x8ec/0xd9d
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028d508>] link_path_walk+0x58/0xe0
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028d875>] do_path_lookup+0x1a0/0x1c3
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028c38e>] getname+0x14c/0x190
Aug 19 06:25:32 noddy kernel:  [<ffffffff8028e0a5>] __user_walk_fd+0x37/0x53
Aug 19 06:25:32 noddy kernel:  [<ffffffff802870d5>] vfs_lstat_fd+0x18/0x47
Aug 19 06:25:32 noddy kernel:  [<ffffffff802872c9>] sys_newlstat+0x19/0x31
Aug 19 06:25:32 noddy kernel:  [<ffffffff80283cc7>] sys_close+0x8c/0xc9
Aug 19 06:25:32 noddy kernel:  [<ffffffff80209d8e>] system_call+0x7e/0x83
Aug 19 06:25:32 noddy kernel: 
Aug 19 06:25:32 noddy kernel: 
Aug 19 06:25:32 noddy kernel: Code: 48 8b 45 00 0f 18 08 48 8d 5d e8 44 39 73 30 75 e6 e9 70 ff 
Aug 19 06:25:32 noddy kernel: RIP  [<ffffffff802943f1>] __d_lookup+0xdb/0x100
Aug 19 06:25:32 noddy kernel:  RSP <ffff810065a47bf8>
Aug 19 06:48:29 noddy kernel: general protection fault: 0000 [2] SMP 
Aug 19 06:48:29 noddy kernel: CPU 1 
Aug 19 06:48:29 noddy kernel: Modules linked in: tcp_diag inet_diag binfmt_misc rfcomm l2cap bluetooth lirc_dev tun powernow_k8 processor cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative ipt_ULOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables mkiss ax25 crc16 ipv6 parport_serial parport_pc dm_snapshot dm_mirror dm_mod it87 hwmon_vid i2c_isa lp parport ide_disk ide_generic snd_ens1371 snd_seq_dummy snd_seq_oss firewire_ohci snd_seq_midi snd_seq_midi_event snd_seq firewire_core crc_itu_t snd_rawmidi skge sata_sil snd_seq_device ide_cd cdrom snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore shpchp pci_hotplug forcedeth k8temp snd_page_alloc i2c_nforce2 ehci_hcd ohci_hcd psmouse i2c_core amd74xx serio_raw analog gameport joydev tsdev pcspkr floppy ext3 jbd mbcache raid1 md_mod sd_mod ata_generic sata_nv libata scsi_mod generic ide_core evdev
Aug 19 06:48:29 noddy kernel: Pid: 5532, comm: exim4 Not tainted 2.6.22-1-amd64 #1
Aug 19 06:48:29 noddy kernel: RIP: 0010:[<ffffffff8026c454>]  [<ffffffff8026c454>] unmap_vmas+0x138/0x6fe
Aug 19 06:48:29 noddy kernel: RSP: 0018:ffff810030dc7bf8  EFLAGS: 00010206
Aug 19 06:48:29 noddy kernel: RAX: ccff810030dcba80 RBX: ffff8100010a48e0 RCX: ffff810030dd8088
Aug 19 06:48:29 noddy kernel: RDX: 00000000000002b8 RSI: ffff810030dd81e8 RDI: ffff8100010a78d8
Aug 19 06:48:29 noddy kernel: RBP: 000000007ef8e020 R08: 0000000100000101 R09: ffff81007fd06d85
Aug 19 06:48:29 noddy kernel: R10: 00000000d9bb7a34 R11: 00000000e7a19eac R12: 00002b9e0a832000
Aug 19 06:48:29 noddy kernel: R13: ffff810030ddf188 R14: ffff810002213720 R15: 00002b9e0a832000
Aug 19 06:48:29 noddy kernel: FS:  00002b9e0a00c550(0000) GS:ffff81007fd06cc0(0000) knlGS:0000000000000000
Aug 19 06:48:29 noddy kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 19 06:48:29 noddy kernel: CR2: 00002b9d299f4b80 CR3: 0000000030e64000 CR4: 00000000000006e0
Aug 19 06:48:29 noddy kernel: Process exim4 (pid: 5532, threadinfo ffff810030dc6000, task ffff81006f9641c0)
Aug 19 06:48:29 noddy kernel: Stack:  0000000000000000 ffff810030dc7cc8 ffffffffffffffff 0000000000000000
Aug 19 06:48:29 noddy kernel:  ffff810030dd8088 ffff810030dc7cd0 000000000037de16 0000000000000000
Aug 19 06:48:29 noddy kernel:  000000017ee3c380 00002b9e0a832000 00000000000002b8 ffff810030dc43c0
Aug 19 06:48:29 noddy kernel: Call Trace:
Aug 19 06:48:29 noddy kernel:  [<ffffffff80270486>] exit_mmap+0x76/0xeb
Aug 19 06:48:29 noddy kernel:  [<ffffffff8022f8d1>] mmput+0x2c/0x9d
Aug 19 06:48:29 noddy kernel:  [<ffffffff80288663>] flush_old_exec+0x65c/0x93c
Aug 19 06:48:29 noddy kernel:  [<ffffffff80284ad5>] vfs_read+0x13f/0x153
Aug 19 06:48:29 noddy kernel:  [<ffffffff802b2e94>] load_elf_binary+0x450/0x1971
Aug 19 06:48:29 noddy kernel:  [<ffffffff802439d2>] autoremove_wake_function+0x0/0x2e
Aug 19 06:48:29 noddy kernel:  [<ffffffff80265388>] __alloc_pages+0x5a/0x2bc
Aug 19 06:48:29 noddy kernel:  [<ffffffff80287a1a>] search_binary_handler+0xa8/0x1d3
Aug 19 06:48:29 noddy kernel:  [<ffffffff8028945d>] do_execve+0x188/0x231
Aug 19 06:48:29 noddy kernel:  [<ffffffff80208c2c>] sys_execve+0x36/0x8f
Aug 19 06:48:29 noddy kernel:  [<ffffffff8020a157>] stub_execve+0x67/0xb0
Aug 19 06:48:29 noddy kernel: 
Aug 19 06:48:29 noddy kernel: 
Aug 19 06:48:29 noddy kernel: Code: 48 8b 48 48 48 01 ca 48 89 54 24 50 48 b8 00 00 00 00 80 00 
Aug 19 06:48:29 noddy kernel: RIP  [<ffffffff8026c454>] unmap_vmas+0x138/0x6fe
Aug 19 06:48:29 noddy kernel:  RSP <ffff810030dc7bf8>
Aug 19 06:48:36 noddy kernel: general protection fault: 0000 [3] SMP 
Aug 19 06:48:36 noddy kernel: CPU 1 
Aug 19 06:48:36 noddy kernel: Modules linked in: tcp_diag inet_diag binfmt_misc rfcomm l2cap bluetooth lirc_dev tun powernow_k8 processor cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative ipt_ULOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables mkiss ax25 crc16 ipv6 parport_serial parport_pc dm_snapshot dm_mirror dm_mod it87 hwmon_vid i2c_isa lp parport ide_disk ide_generic snd_ens1371 snd_seq_dummy snd_seq_oss firewire_ohci snd_seq_midi snd_seq_midi_event snd_seq firewire_core crc_itu_t snd_rawmidi skge sata_sil snd_seq_device ide_cd cdrom snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore shpchp pci_hotplug forcedeth k8temp snd_page_alloc i2c_nforce2 ehci_hcd ohci_hcd psmouse i2c_core amd74xx serio_raw analog gameport joydev tsdev pcspkr floppy ext3 jbd mbcache raid1 md_mod sd_mod ata_generic sata_nv libata scsi_mod generic ide_core evdev
Aug 19 06:48:36 noddy kernel: Pid: 5539, comm: spamc Not tainted 2.6.22-1-amd64 #1
Aug 19 06:48:36 noddy kernel: RIP: 0010:[<ffffffff8026c454>]  [<ffffffff8026c454>] unmap_vmas+0x138/0x6fe
Aug 19 06:48:36 noddy kernel: RSP: 0018:ffff81002f5c5e08  EFLAGS: 00010202
Aug 19 06:48:36 noddy kernel: RAX: ccff81007edc1740 RBX: ffff810001053238 RCX: ffff81002f5be348
Aug 19 06:48:36 noddy kernel: RDX: 00000000000002b0 RSI: 0000000000000003 RDI: ffff81000000c400
Aug 19 06:48:36 noddy kernel: RBP: 000000007c35b020 R08: 000000007c35b020 R09: ffff81007fd06d85
Aug 19 06:48:36 noddy kernel: R10: 0000000000000286 R11: 0000000000000246 R12: 00002b24d88c9000
Aug 19 06:48:36 noddy kernel: R13: ffff81002f5c0640 R14: ffff810002213720 R15: 00002b24d88c9000
Aug 19 06:48:36 noddy kernel: FS:  00002b24d93b76e0(0000) GS:ffff81007fd06cc0(0000) knlGS:0000000000000000
Aug 19 06:48:36 noddy kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 19 06:48:36 noddy kernel: CR2: 00002b24d90fa4e0 CR3: 000000002f5fc000 CR4: 00000000000006e0
Aug 19 06:48:36 noddy kernel: Process spamc (pid: 5539, threadinfo ffff81002f5c4000, task ffff81006f88c240)
Aug 19 06:48:36 noddy kernel: Stack:  0000000000000000 ffff81002f5c5ed8 ffffffffffffffff 0000000000000000
Aug 19 06:48:36 noddy kernel:  ffff81002f5be348 ffff81002f5c5ee0 00000000003c2da8 0000000000000000
Aug 19 06:48:36 noddy kernel:  0000000100000206 00002b24d88c9000 00000000000002b0 ffff81002f5cd498
Aug 19 06:48:36 noddy kernel: Call Trace:
Aug 19 06:48:36 noddy kernel:  [<ffffffff80270486>] exit_mmap+0x76/0xeb
Aug 19 06:48:36 noddy kernel:  [<ffffffff8022f8d1>] mmput+0x2c/0x9d
Aug 19 06:48:36 noddy kernel:  [<ffffffff80234c3b>] do_exit+0x22c/0x7e8
Aug 19 06:48:36 noddy kernel:  [<ffffffff80235276>] sys_exit_group+0x0/0xe
Aug 19 06:48:36 noddy kernel:  [<ffffffff80209d8e>] system_call+0x7e/0x83
Aug 19 06:48:36 noddy kernel: 
Aug 19 06:48:36 noddy kernel: 
Aug 19 06:48:36 noddy kernel: Code: 48 8b 48 48 48 01 ca 48 89 54 24 50 48 b8 00 00 00 00 80 00 
Aug 19 06:48:36 noddy kernel: RIP  [<ffffffff8026c454>] unmap_vmas+0x138/0x6fe
Aug 19 06:48:36 noddy kernel:  RSP <ffff81002f5c5e08>
Aug 19 06:48:36 noddy kernel: Fixing recursive fault but reboot is needed!
Aug 19 06:51:10 noddy kernel: general protection fault: 0000 [4] SMP 
Aug 19 06:51:10 noddy kernel: CPU 1 
Aug 19 06:51:10 noddy kernel: Modules linked in: tcp_diag inet_diag binfmt_misc rfcomm l2cap bluetooth lirc_dev tun powernow_k8 processor cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative ipt_ULOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables mkiss ax25 crc16 ipv6 parport_serial parport_pc dm_snapshot dm_mirror dm_mod it87 hwmon_vid i2c_isa lp parport ide_disk ide_generic snd_ens1371 snd_seq_dummy snd_seq_oss firewire_ohci snd_seq_midi snd_seq_midi_event snd_seq firewire_core crc_itu_t snd_rawmidi skge sata_sil snd_seq_device ide_cd cdrom snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore shpchp pci_hotplug forcedeth k8temp snd_page_alloc i2c_nforce2 ehci_hcd ohci_hcd psmouse i2c_core amd74xx serio_raw analog gameport joydev tsdev pcspkr floppy ext3 jbd mbcache raid1 md_mod sd_mod ata_generic sata_nv libata scsi_mod generic ide_core evdev
Aug 19 06:51:10 noddy kernel: Pid: 5633, comm: sysklogd Not tainted 2.6.22-1-amd64 #1
Aug 19 06:51:10 noddy kernel: RIP: 0010:[<ffffffff8026a184>]  [<ffffffff8026a184>] vma_prio_tree_remove+0x29/0xe1
Aug 19 06:51:10 noddy kernel: RSP: 0018:ffff81003e299e58  EFLAGS: 00010246
Aug 19 06:51:10 noddy kernel: RAX: ccff81006e6a75a0 RBX: 0000000000000000 RCX: 00002b824daee000
Aug 19 06:51:10 noddy kernel: RDX: ffff81006cf16230 RSI: ffff81002f5c9180 RDI: ffff81002f5c9138
Aug 19 06:51:10 noddy kernel: RBP: ffff810065dc5780 R08: ffff81007dc41e60 R09: ffff81007fd06d8c
Aug 19 06:51:10 noddy kernel: R10: ffff81002f5c9138 R11: ffff81002f5bee48 R12: ffff81002f5c9138
Aug 19 06:51:10 noddy kernel: R13: 00002b824d117000 R14: 0000000000000000 R15: 0000000000000000
Aug 19 06:51:10 noddy kernel: FS:  00002b824daeaaf0(0000) GS:ffff81007fd06cc0(0000) knlGS:0000000000000000
Aug 19 06:51:10 noddy kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 19 06:51:10 noddy kernel: CR2: 00002b824dae44a8 CR3: 0000000040edd000 CR4: 00000000000006e0
Aug 19 06:51:10 noddy kernel: Process sysklogd (pid: 5633, threadinfo ffff81003e298000, task ffff81007fdd0ea0)
Aug 19 06:51:10 noddy kernel: Stack:  00000000005ccfff ffff81007dc41e40 ffff810065dc5780 ffffffff802707b9
Aug 19 06:51:10 noddy kernel:  ffff81006e85d6b8 ffff81002f5c9138 ffff81006e85d6b8 ffffffff8026f20f
Aug 19 06:51:10 noddy kernel:  ffff81003e299ee0 ffff81003e299ee0 ffff810030e0d4a8 ffff81005995d140
Aug 19 06:51:10 noddy kernel: Call Trace:
Aug 19 06:51:10 noddy kernel:  [<ffffffff802707b9>] unlink_file_vma+0x31/0x3d
Aug 19 06:51:10 noddy kernel:  [<ffffffff8026f20f>] free_pgtables+0x69/0x98
Aug 19 06:51:10 noddy kernel:  [<ffffffff802704a1>] exit_mmap+0x91/0xeb
Aug 19 06:51:10 noddy kernel:  [<ffffffff8022f8d1>] mmput+0x2c/0x9d
Aug 19 06:51:10 noddy kernel:  [<ffffffff80234c3b>] do_exit+0x22c/0x7e8
Aug 19 06:51:10 noddy kernel:  [<ffffffff80235276>] sys_exit_group+0x0/0xe
Aug 19 06:51:10 noddy kernel:  [<ffffffff80209d8e>] system_call+0x7e/0x83
Aug 19 06:51:10 noddy kernel: 
Aug 19 06:51:10 noddy kernel: 
Aug 19 06:51:10 noddy kernel: Code: 48 89 10 48 89 76 08 48 89 77 48 e9 a3 00 00 00 4c 89 c7 41 
Aug 19 06:51:10 noddy kernel: RIP  [<ffffffff8026a184>] vma_prio_tree_remove+0x29/0xe1
Aug 19 06:51:10 noddy kernel:  RSP <ffff81003e299e58>
Aug 19 06:51:10 noddy kernel: Fixing recursive fault but reboot is needed!
Aug 19 06:53:30 noddy kernel: general protection fault: 0000 [5] SMP 
Aug 19 06:53:30 noddy kernel: CPU 1 
Aug 19 06:53:30 noddy kernel: Modules linked in: tcp_diag inet_diag binfmt_misc rfcomm l2cap bluetooth lirc_dev tun powernow_k8 processor cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative ipt_ULOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables mkiss ax25 crc16 ipv6 parport_serial parport_pc dm_snapshot dm_mirror dm_mod it87 hwmon_vid i2c_isa lp parport ide_disk ide_generic snd_ens1371 snd_seq_dummy snd_seq_oss firewire_ohci snd_seq_midi snd_seq_midi_event snd_seq firewire_core crc_itu_t snd_rawmidi skge sata_sil snd_seq_device ide_cd cdrom snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore shpchp pci_hotplug forcedeth k8temp snd_page_alloc i2c_nforce2 ehci_hcd ohci_hcd psmouse i2c_core amd74xx serio_raw analog gameport joydev tsdev pcspkr floppy ext3 jbd mbcache raid1 md_mod sd_mod ata_generic sata_nv libata scsi_mod generic ide_core evdev
Aug 19 06:53:30 noddy kernel: Pid: 5529, comm: exim4 Not tainted 2.6.22-1-amd64 #1
Aug 19 06:53:30 noddy kernel: RIP: 0010:[<ffffffff8026c454>]  [<ffffffff8026c454>] unmap_vmas+0x138/0x6fe
Aug 19 06:53:30 noddy kernel: RSP: 0018:ffff810030d43e08  EFLAGS: 00010206
Aug 19 06:53:30 noddy kernel: RAX: ccff81007e1cf5c0 RBX: ffff8100010a3798 RCX: ffff810030d35088
Aug 19 06:53:30 noddy kernel: RDX: 00000000000002b8 RSI: 0000000000000003 RDI: ffff81000000c400
Aug 19 06:53:30 noddy kernel: RBP: 000000007ea2d020 R08: 000000000000000a R09: ffff81007fd06d85
Aug 19 06:53:30 noddy kernel: R10: 0000000000000286 R11: 0000000000000246 R12: 00002b9e0a62c000
Aug 19 06:53:30 noddy kernel: R13: ffff810030d3b158 R14: ffff810002213720 R15: 00002b9e0a62c000
Aug 19 06:53:30 noddy kernel: FS:  00002b9e0a00c550(0000) GS:ffff81007fd06cc0(0000) knlGS:0000000000000000
Aug 19 06:53:30 noddy kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 19 06:53:30 noddy kernel: CR2: 00000000006b6680 CR3: 0000000030d23000 CR4: 00000000000006e0
Aug 19 06:53:30 noddy kernel: Process exim4 (pid: 5529, threadinfo ffff810030d42000, task ffff81007f1fd160)
Aug 19 06:53:30 noddy kernel: Stack:  0000000000000000 ffff810030d43ed8 ffffffffffffffff 0000000000000000
Aug 19 06:53:30 noddy kernel:  ffff810030d35088 ffff810030d43ee0 00000000002f9ea2 0000000000000000
Aug 19 06:53:30 noddy kernel:  0000000100000202 00002b9e0a62c000 00000000000002b8 ffff810030d273c0
Aug 19 06:53:30 noddy kernel: Call Trace:
Aug 19 06:53:30 noddy kernel:  [<ffffffff80270486>] exit_mmap+0x76/0xeb
Aug 19 06:53:30 noddy kernel:  [<ffffffff8022f8d1>] mmput+0x2c/0x9d
Aug 19 06:53:30 noddy kernel:  [<ffffffff80234c3b>] do_exit+0x22c/0x7e8
Aug 19 06:53:30 noddy kernel:  [<ffffffff80235276>] sys_exit_group+0x0/0xe
Aug 19 06:53:30 noddy kernel:  [<ffffffff80209d8e>] system_call+0x7e/0x83
Aug 19 06:53:30 noddy kernel: 
Aug 19 06:53:30 noddy kernel: 
Aug 19 06:53:30 noddy kernel: Code: 48 8b 48 48 48 01 ca 48 89 54 24 50 48 b8 00 00 00 00 80 00 
Aug 19 06:53:30 noddy kernel: RIP  [<ffffffff8026c454>] unmap_vmas+0x138/0x6fe
Aug 19 06:53:30 noddy kernel:  RSP <ffff810030d43e08>
Aug 19 06:53:30 noddy kernel: Fixing recursive fault but reboot is needed!
-- 
Hamish Moffatt VK3SB <hamish@debian.org> <hamish@cloud.net.au>
