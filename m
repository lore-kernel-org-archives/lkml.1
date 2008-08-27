Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYH0Voe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYH0Voe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYH0VoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:44:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43520 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbYH0VoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:44:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: jurriaan <thunder7@xs4all.nl>
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with software-raid1
Date: Wed, 27 Aug 2008 23:47:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>
References: <20080827170538.GA24393@amd64.of.nowhere>
In-Reply-To: <20080827170538.GA24393@amd64.of.nowhere>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808272347.43577.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs]

On Wednesday, 27 of August 2008, jurriaan wrote:
> After returning from my holidays, I proceeded to test 2.6.27-rc4. 2.6.26
> works fine, but 2.6.27-rc4 gives me lots of:
> 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff803a30f1>] ? rb_insert_color+0x101/0x130
> Aug 27 18:03:10 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:10 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> Aug 27 18:03:10 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> 
> I was able to reboot into 2.6.26 without further trouble. I wasn't able
> to find this reported earlier on lkml.
> 
> Kind regards,
> Jurriaan
> 
> Below is my dmesg and my .config.
> 
> 
> Aug 27 18:03:10 middle kernel: Linux version 2.6.27-rc4 (jurriaan@middle) (gcc version 4.3.1 (Debian 4.3.1-9) ) #2 SMP PREEMPT Mon Aug 25 14:09:45 CEST 2008
> Aug 27 18:03:10 middle kernel: Command line: root=/dev/md2
> Aug 27 18:03:10 middle kernel: KERNEL supported cpus:
> Aug 27 18:03:10 middle kernel:   Intel GenuineIntel
> Aug 27 18:03:10 middle kernel:   AMD AuthenticAMD
> Aug 27 18:03:10 middle kernel:   Centaur CentaurHauls
> Aug 27 18:03:10 middle kernel: BIOS-provided physical RAM map:
> Aug 27 18:03:10 middle kernel:  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> Aug 27 18:03:10 middle kernel:  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> Aug 27 18:03:10 middle kernel:  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> Aug 27 18:03:10 middle kernel:  BIOS-e820: 0000000000100000 - 00000000bfff0000 (usable)
> Aug 27 18:03:10 middle kernel:  BIOS-e820: 00000000bfff0000 - 00000000bfff3000 (ACPI NVS)
> Aug 27 18:03:10 middle kernel:  BIOS-e820: 00000000bfff3000 - 00000000c0000000 (ACPI data)
> Aug 27 18:03:10 middle kernel:  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> Aug 27 18:03:10 middle kernel:  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> Aug 27 18:03:10 middle kernel:  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
> Aug 27 18:03:10 middle kernel: last_pfn = 0x140000 max_arch_pfn = 0x3ffffffff
> Aug 27 18:03:10 middle kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> Aug 27 18:03:10 middle kernel: last_pfn = 0xbfff0 max_arch_pfn = 0x3ffffffff
> Aug 27 18:03:10 middle kernel: init_memory_mapping
> Aug 27 18:03:10 middle kernel: last_map_addr: bfff0000 end: bfff0000
> Aug 27 18:03:10 middle kernel: init_memory_mapping
> Aug 27 18:03:10 middle kernel: last_map_addr: 140000000 end: 140000000
> Aug 27 18:03:10 middle kernel: DMI 2.3 present.
> Aug 27 18:03:10 middle kernel: ACPI: RSDP 000F7D30, 0014 (r0 Nvidia)
> Aug 27 18:03:10 middle kernel: ACPI: RSDT BFFF3040, 0038 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
> Aug 27 18:03:10 middle kernel: ACPI: FACP BFFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
> Aug 27 18:03:10 middle kernel: ACPI: DSDT BFFF3180, 6678 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
> Aug 27 18:03:10 middle kernel: ACPI: FACS BFFF0000, 0040
> Aug 27 18:03:10 middle kernel: ACPI: SSDT BFFF9900, 020C (r1 PTLTD  POWERNOW        1  LTP        1)
> Aug 27 18:03:10 middle kernel: ACPI: SRAT BFFF9B80, 00C8 (r1 AMD    HAMMER          1 AMD         1)
> Aug 27 18:03:10 middle kernel: ACPI: MCFG BFFF9CC0, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
> Aug 27 18:03:10 middle kernel: ACPI: APIC BFFF9840, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
> Aug 27 18:03:10 middle kernel: (6 early reservations) ==> bootmem [0000000000 - 0140000000]
> Aug 27 18:03:10 middle kernel:   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> Aug 27 18:03:10 middle kernel:   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
> Aug 27 18:03:10 middle kernel:   #2 [0000200000 - 00009e0894]    TEXT DATA BSS ==> [0000200000 - 00009e0894]
> Aug 27 18:03:10 middle kernel:   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
> Aug 27 18:03:10 middle kernel:   #4 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
> Aug 27 18:03:10 middle kernel:   #5 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
> Aug 27 18:03:10 middle kernel: found SMP MP-table at [ffff8800000f5980] 000f5980
> Aug 27 18:03:10 middle kernel: Zone PFN ranges:
> Aug 27 18:03:10 middle kernel:   DMA      0x00000000 -> 0x00001000
> Aug 27 18:03:10 middle kernel:   DMA32    0x00001000 -> 0x00100000
> Aug 27 18:03:10 middle kernel:   Normal   0x00100000 -> 0x00140000
> Aug 27 18:03:10 middle kernel: Movable zone start PFN for each node
> Aug 27 18:03:10 middle kernel: early_node_map[3] active PFN ranges
> Aug 27 18:03:10 middle kernel:     0: 0x00000000 -> 0x0000009f
> Aug 27 18:03:10 middle kernel:     0: 0x00000100 -> 0x000bfff0
> Aug 27 18:03:10 middle kernel:     0: 0x00100000 -> 0x00140000
> Aug 27 18:03:10 middle kernel: Nvidia board detected. Ignoring ACPI timer override.
> Aug 27 18:03:10 middle kernel: If you got timer trouble try acpi_use_timer_override
> Aug 27 18:03:10 middle kernel: ACPI: PM-Timer IO Port: 0x4008
> Aug 27 18:03:10 middle kernel: ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> Aug 27 18:03:10 middle kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> Aug 27 18:03:10 middle kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> Aug 27 18:03:10 middle kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> Aug 27 18:03:10 middle kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> Aug 27 18:03:10 middle kernel: IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
> Aug 27 18:03:10 middle kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> Aug 27 18:03:10 middle kernel: ACPI: BIOS IRQ0 pin2 override ignored.
> Aug 27 18:03:10 middle kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> Aug 27 18:03:10 middle kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> Aug 27 18:03:10 middle kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
> Aug 27 18:03:10 middle kernel: Setting APIC routing to flat
> Aug 27 18:03:10 middle kernel: Using ACPI (MADT) for SMP configuration information
> Aug 27 18:03:10 middle kernel: SMP: Allowing 2 CPUs, 0 hotplug CPUs
> Aug 27 18:03:10 middle kernel: Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
> Aug 27 18:03:10 middle kernel: PERCPU: Allocating 42600 bytes of per cpu data
> Aug 27 18:03:10 middle kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1028422
> Aug 27 18:03:10 middle kernel: Kernel command line: root=/dev/md2
> Aug 27 18:03:10 middle kernel: Initializing CPU#0
> Aug 27 18:03:10 middle kernel: PID hash table entries: 4096 (order: 12, 32768 bytes)
> Aug 27 18:03:10 middle kernel: TSC calibrated against PM_TIMER
> Aug 27 18:03:10 middle kernel: Detected 2412.359 MHz processor.
> Aug 27 18:03:10 middle kernel: Console: colour VGA+ 80x25
> Aug 27 18:03:10 middle kernel: console [tty0] enabled
> Aug 27 18:03:10 middle kernel: Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Aug 27 18:03:10 middle kernel: Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Aug 27 18:03:10 middle kernel: Checking aperture...
> Aug 27 18:03:10 middle kernel: No AGP bridge found
> Aug 27 18:03:10 middle kernel: Node 0: aperture @ 827c000000 size 32 MB
> Aug 27 18:03:10 middle kernel: Mapping aperture over 65536 KB of RAM @ 20000000
> Aug 27 18:03:10 middle kernel: Memory: 4041164k/5242880k available (5202k kernel code, 151744k reserved, 1893k data, 340k init)
> Aug 27 18:03:10 middle kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 4824.71 BogoMIPS (lpj=2412359)
> Aug 27 18:03:10 middle kernel: Mount-cache hash table entries: 256
> Aug 27 18:03:10 middle kernel: CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> Aug 27 18:03:10 middle kernel: CPU: L2 Cache: 512K (64 bytes/line)
> Aug 27 18:03:10 middle kernel: CPU: Physical Processor ID: 0
> Aug 27 18:03:10 middle kernel: CPU: Processor Core ID: 0
> Aug 27 18:03:10 middle kernel: ACPI: Core revision 20080609
> Aug 27 18:03:10 middle kernel: ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
> Aug 27 18:03:10 middle kernel: CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4600+ stepping 01
> Aug 27 18:03:10 middle kernel: Using local APIC timer interrupts.
> Aug 27 18:03:10 middle kernel: Detected 12.564 MHz APIC timer.
> Aug 27 18:03:10 middle kernel: Booting processor 1/1 ip 6000
> Aug 27 18:03:10 middle kernel: Initializing CPU#1
> Aug 27 18:03:10 middle kernel: Calibrating delay using timer specific routine.. 4824.67 BogoMIPS (lpj=2412335)
> Aug 27 18:03:10 middle kernel: CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> Aug 27 18:03:10 middle kernel: CPU: L2 Cache: 512K (64 bytes/line)
> Aug 27 18:03:10 middle kernel: CPU: Physical Processor ID: 0
> Aug 27 18:03:10 middle kernel: CPU: Processor Core ID: 1
> Aug 27 18:03:10 middle kernel: x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> Aug 27 18:03:10 middle kernel: CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4600+ stepping 01
> Aug 27 18:03:10 middle kernel: Brought up 2 CPUs
> Aug 27 18:03:10 middle kernel: Total of 2 processors activated (9649.38 BogoMIPS).
> Aug 27 18:03:10 middle kernel: net_namespace: 1152 bytes
> Aug 27 18:03:10 middle kernel: xor: automatically using best checksumming function: generic_sse
> Aug 27 18:03:10 middle kernel:    generic_sse:  7196.000 MB/sec
> Aug 27 18:03:10 middle kernel: xor: using function: generic_sse (7196.000 MB/sec)
> Aug 27 18:03:10 middle kernel: NET: Registered protocol family 16
> Aug 27 18:03:10 middle kernel: No dock devices found.
> Aug 27 18:03:10 middle kernel: TOM: 00000000c0000000 aka 3072M
> Aug 27 18:03:10 middle kernel: TOM2: 0000000140000000 aka 5120M
> Aug 27 18:03:10 middle kernel: ACPI: bus type pci registered
> Aug 27 18:03:10 middle kernel: PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> Aug 27 18:03:10 middle kernel: PCI: MCFG area at e0000000 reserved in E820
> Aug 27 18:03:10 middle kernel: PCI: Using MMCONFIG at e0000000 - efffffff
> Aug 27 18:03:10 middle kernel: PCI: Using configuration type 1 for base access
> Aug 27 18:03:10 middle kernel: ACPI: Interpreter enabled
> Aug 27 18:03:10 middle kernel: ACPI: (supports S0 S1 S3 S5)
> Aug 27 18:03:10 middle kernel: ACPI: Using IOAPIC for interrupt routing
> Aug 27 18:03:10 middle kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
> Aug 27 18:03:10 middle kernel: HPET not enabled in BIOS. You might try hpet=force boot option
> Aug 27 18:03:10 middle kernel: pci 0000:00:01.1: PME# supported from D3hot D3cold
> Aug 27 18:03:10 middle kernel: pci 0000:00:01.1: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> Aug 27 18:03:10 middle kernel: pci 0000:00:02.0: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
> Aug 27 18:03:10 middle kernel: pci 0000:00:02.1: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> Aug 27 18:03:10 middle kernel: pci 0000:00:0a.0: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
> Aug 27 18:03:10 middle kernel: pci 0000:00:0b.0: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
> Aug 27 18:03:10 middle kernel: pci 0000:00:0c.0: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
> Aug 27 18:03:10 middle kernel: pci 0000:00:0d.0: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
> Aug 27 18:03:10 middle kernel: pci 0000:00:0e.0: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:05:06.2: PME# supported from D0 D1 D2 D3hot
> Aug 27 18:03:10 middle kernel: pci 0000:05:06.2: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:05:0b.0: PME# supported from D0 D1 D2 D3hot
> Aug 27 18:03:10 middle kernel: pci 0000:05:0b.0: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:05:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
> Aug 27 18:03:10 middle kernel: pci 0000:05:0c.0: PME# disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:09.0: transparent bridge
> Aug 27 18:03:10 middle kernel: PCI: bridge 0000:00:09.0 io port: [a000, afff]
> Aug 27 18:03:10 middle kernel: PCI: bridge 0000:00:09.0 32bit mmio: [d3000000, d4ffffff]
> Aug 27 18:03:10 middle kernel: PCI: bridge 0000:00:0e.0 io port: [9000, 9fff]
> Aug 27 18:03:10 middle kernel: PCI: bridge 0000:00:0e.0 32bit mmio: [d0000000, d2ffffff]
> Aug 27 18:03:10 middle kernel: PCI: bridge 0000:00:0e.0 64bit mmio pref: [c0000000, cfffffff]
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 7 9 10 11 12 14 15)
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LNK2] (IRQs *3 4 5 7 9 10 11 12 14 15)
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 7 9 10 *11 12 14 15)
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 *11 12 14 15)
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LUB2] (IRQs *3 4 5 7 9 10 11 12 14 15)
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
> Aug 27 18:03:10 middle kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
> Aug 27 18:03:10 middle kernel: pnp: PnP ACPI init
> Aug 27 18:03:10 middle kernel: ACPI: bus type pnp registered
> Aug 27 18:03:10 middle kernel: pnp: PnP ACPI: found 16 devices
> Aug 27 18:03:10 middle kernel: ACPI: ACPI bus type pnp unregistered
> Aug 27 18:03:10 middle kernel: SCSI subsystem initialized
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver usbfs
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver hub
> Aug 27 18:03:10 middle kernel: usbcore: registered new device driver usb
> Aug 27 18:03:10 middle kernel: PCI: Using ACPI for IRQ routing
> Aug 27 18:03:10 middle kernel: DMAR:parse DMAR table failure.
> Aug 27 18:03:10 middle kernel: PCI-DMA: Disabling AGP.
> Aug 27 18:03:10 middle kernel: PCI-DMA: aperture base @ 20000000 size 65536 KB
> Aug 27 18:03:10 middle kernel: PCI-DMA: using GART IOMMU.
> Aug 27 18:03:10 middle kernel: PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> Aug 27 18:03:10 middle kernel: ACPI: RTC can wake from S4
> Aug 27 18:03:10 middle kernel: system 00:01: ioport range 0x4000-0x407f has been reserved
> Aug 27 18:03:10 middle kernel: system 00:01: ioport range 0x4080-0x40ff has been reserved
> Aug 27 18:03:10 middle kernel: system 00:01: ioport range 0x4400-0x447f has been reserved
> Aug 27 18:03:10 middle kernel: system 00:01: ioport range 0x4480-0x44ff has been reserved
> Aug 27 18:03:10 middle kernel: system 00:01: ioport range 0x4800-0x487f has been reserved
> Aug 27 18:03:10 middle kernel: system 00:01: ioport range 0x4880-0x48ff has been reserved
> Aug 27 18:03:10 middle kernel: system 00:02: ioport range 0x4d0-0x4d1 has been reserved
> Aug 27 18:03:10 middle kernel: system 00:02: ioport range 0x800-0x87f has been reserved
> Aug 27 18:03:10 middle kernel: system 00:02: ioport range 0x290-0x297 has been reserved
> Aug 27 18:03:10 middle kernel: system 00:0e: iomem range 0xe0000000-0xefffffff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xf0000-0xf3fff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xf4000-0xf7fff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xfc000-0xfffff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xbfff0000-0xbfffffff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xffff0000-0xffffffff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0x0-0x9ffff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0x100000-0xbffeffff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xfec00000-0xfec00fff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xfee00000-0xfeefffff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xfefff000-0xfeffffff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xfff80000-0xfff80fff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xfff90000-0xfffbffff could not be reserved
> Aug 27 18:03:10 middle kernel: system 00:0f: iomem range 0xfffed000-0xfffeffff could not be reserved
> Aug 27 18:03:10 middle kernel: pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
> Aug 27 18:03:10 middle kernel: pci 0000:00:09.0:   IO window: 0xa000-0xafff
> Aug 27 18:03:10 middle kernel: pci 0000:00:09.0:   MEM window: 0xd3000000-0xd4ffffff
> Aug 27 18:03:10 middle kernel: pci 0000:00:09.0:   PREFETCH window: 0x000000d5100000-0x000000d51fffff
> Aug 27 18:03:10 middle kernel: pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
> Aug 27 18:03:10 middle kernel: pci 0000:00:0b.0:   IO window: disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0b.0:   MEM window: disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0b.0:   PREFETCH window: disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
> Aug 27 18:03:10 middle kernel: pci 0000:00:0c.0:   IO window: disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0c.0:   MEM window: disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0c.0:   PREFETCH window: disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
> Aug 27 18:03:10 middle kernel: pci 0000:00:0d.0:   IO window: disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0d.0:   MEM window: disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0d.0:   PREFETCH window: disabled
> Aug 27 18:03:10 middle kernel: pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
> Aug 27 18:03:10 middle kernel: pci 0000:00:0e.0:   IO window: 0x9000-0x9fff
> Aug 27 18:03:10 middle kernel: pci 0000:00:0e.0:   MEM window: 0xd0000000-0xd2ffffff
> Aug 27 18:03:10 middle kernel: pci 0000:00:0e.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
> Aug 27 18:03:10 middle kernel: bus: 00 index 0 io port: [0, ffff]
> Aug 27 18:03:10 middle kernel: bus: 00 index 1 mmio: [0, ffffffffffffffff]
> Aug 27 18:03:10 middle kernel: bus: 05 index 0 io port: [a000, afff]
> Aug 27 18:03:10 middle kernel: bus: 05 index 1 mmio: [d3000000, d4ffffff]
> Aug 27 18:03:10 middle kernel: bus: 05 index 2 mmio: [d5100000, d51fffff]
> Aug 27 18:03:10 middle kernel: bus: 05 index 3 io port: [0, ffff]
> Aug 27 18:03:10 middle kernel: bus: 05 index 4 mmio: [0, ffffffffffffffff]
> Aug 27 18:03:10 middle kernel: bus: 04 index 0 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 04 index 1 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 04 index 2 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 04 index 3 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 03 index 0 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 03 index 1 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 03 index 2 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 03 index 3 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 02 index 0 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 02 index 1 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 02 index 2 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 02 index 3 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: bus: 01 index 0 io port: [9000, 9fff]
> Aug 27 18:03:10 middle kernel: bus: 01 index 1 mmio: [d0000000, d2ffffff]
> Aug 27 18:03:10 middle kernel: bus: 01 index 2 mmio: [c0000000, cfffffff]
> Aug 27 18:03:10 middle kernel: bus: 01 index 3 mmio: [0, 0]
> Aug 27 18:03:10 middle kernel: NET: Registered protocol family 2
> Aug 27 18:03:10 middle kernel: IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> Aug 27 18:03:10 middle kernel: TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> Aug 27 18:03:10 middle kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> Aug 27 18:03:10 middle kernel: TCP: Hash tables configured (established 262144 bind 65536)
> Aug 27 18:03:10 middle kernel: TCP reno registered
> Aug 27 18:03:10 middle kernel: NET: Registered protocol family 1
> Aug 27 18:03:10 middle kernel: NTFS driver 2.1.29 [Flags: R/O].
> Aug 27 18:03:10 middle kernel: msgmni has been set to 7894
> Aug 27 18:03:10 middle kernel: async_tx: api initialized (sync-only)
> Aug 27 18:03:10 middle kernel: io scheduler noop registered
> Aug 27 18:03:10 middle kernel: io scheduler anticipatory registered (default)
> Aug 27 18:03:10 middle kernel: io scheduler deadline registered
> Aug 27 18:03:10 middle kernel: io scheduler cfq registered
> Aug 27 18:03:10 middle kernel: pci 0000:00:00.0: Enabling HT MSI Mapping
> Aug 27 18:03:10 middle kernel: pci 0000:00:0b.0: Enabling HT MSI Mapping
> Aug 27 18:03:10 middle kernel: pci 0000:00:0b.0: Found enabled HT MSI Mapping
> Aug 27 18:03:10 middle kernel: pci 0000:00:0b.0: Linking AER extended capability
> Aug 27 18:03:10 middle kernel: pci 0000:00:0c.0: Enabling HT MSI Mapping
> Aug 27 18:03:10 middle kernel: pci 0000:00:0c.0: Found enabled HT MSI Mapping
> Aug 27 18:03:10 middle kernel: pci 0000:00:0c.0: Linking AER extended capability
> Aug 27 18:03:10 middle kernel: pci 0000:00:0d.0: Enabling HT MSI Mapping
> Aug 27 18:03:10 middle kernel: pci 0000:00:0d.0: Found enabled HT MSI Mapping
> Aug 27 18:03:10 middle kernel: pci 0000:00:0d.0: Linking AER extended capability
> Aug 27 18:03:10 middle kernel: pci 0000:00:0e.0: Enabling HT MSI Mapping
> Aug 27 18:03:10 middle kernel: pci 0000:00:0e.0: Found enabled HT MSI Mapping
> Aug 27 18:03:10 middle kernel: pci 0000:00:0e.0: Linking AER extended capability
> Aug 27 18:03:10 middle kernel: pcieport-driver 0000:00:0b.0: found MSI capability
> Aug 27 18:03:10 middle kernel: pcieport-driver 0000:00:0c.0: found MSI capability
> Aug 27 18:03:10 middle kernel: pcieport-driver 0000:00:0d.0: found MSI capability
> Aug 27 18:03:10 middle kernel: pcieport-driver 0000:00:0e.0: found MSI capability
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
> Aug 27 18:03:10 middle kernel: nvidiafb 0000:01:00.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
> Aug 27 18:03:10 middle kernel: nvidiafb: Device ID: 10de0392 
> Aug 27 18:03:10 middle kernel: nvidiafb: CRTC0 analog not found
> Aug 27 18:03:10 middle kernel: nvidiafb: CRTC1 analog not found
> Aug 27 18:03:10 middle kernel: i2c-adapter i2c-0: unable to read EDID block.
> Aug 27 18:03:10 middle last message repeated 2 times
> Aug 27 18:03:10 middle kernel: nvidiafb: EDID found from BUS2
> Aug 27 18:03:10 middle kernel: nvidiafb: CRTC 0 is currently programmed for DFP
> Aug 27 18:03:10 middle kernel: nvidiafb: Using DFP on CRTC 0
> Aug 27 18:03:10 middle kernel: nvidiafb: Panel size is 2560 x 1600
> Aug 27 18:03:10 middle kernel: nvidiafb: Panel is TMDS
> Aug 27 18:03:10 middle kernel: nvidiafb: MTRR set to ON
> Aug 27 18:03:10 middle kernel: nvidiafb: Flat panel dithering disabled
> Aug 27 18:03:10 middle kernel: Console: switching to colour frame buffer device 256x88
> Aug 27 18:03:10 middle kernel: nvidiafb: PCI nVidia NV39 framebuffer (64MB @ 0xC0000000)
> Aug 27 18:03:10 middle kernel: input: Power Button (FF) as /class/input/input0
> Aug 27 18:03:10 middle kernel: ACPI: Power Button (FF) [PWRF]
> Aug 27 18:03:10 middle kernel: input: Power Button (CM) as /class/input/input1
> Aug 27 18:03:10 middle kernel: ACPI: Power Button (CM) [PWRB]
> Aug 27 18:03:10 middle kernel: fan PNP0C0B:00: registered as cooling_device0
> Aug 27 18:03:10 middle kernel: ACPI: Fan [FAN] (on)
> Aug 27 18:03:10 middle kernel: processor ACPI0007:00: registered as cooling_device1
> Aug 27 18:03:10 middle kernel: processor ACPI0007:01: registered as cooling_device2
> Aug 27 18:03:10 middle kernel: thermal LNXTHERM:01: registered as thermal_zone0
> Aug 27 18:03:10 middle kernel: ACPI: Thermal Zone [THRM] (40 C)
> Aug 27 18:03:10 middle kernel: Non-volatile memory driver v1.2
> Aug 27 18:03:10 middle kernel: Linux agpgart interface v0.103
> Aug 27 18:03:10 middle kernel: Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
> Aug 27 18:03:10 middle kernel: Hangcheck: Using get_cycles().
> Aug 27 18:03:10 middle kernel: Serial: 8250/16550 driver4 ports, IRQ sharing enabled
> Aug 27 18:03:10 middle kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Aug 27 18:03:10 middle kernel: 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Aug 27 18:03:10 middle kernel: Floppy drive(s): fd0 is 1.44M
> Aug 27 18:03:10 middle kernel: FDC 0 is a post-1991 82077
> Aug 27 18:03:10 middle kernel: loop: module loaded
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
> Aug 27 18:03:10 middle kernel: skge 0000:05:0c.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
> Aug 27 18:03:10 middle kernel: skge 1.13 addr 0xd4004000 irq 17 chip Yukon-Lite rev 9
> Aug 27 18:03:10 middle kernel: skge eth0: addr 00:13:d4:d7:86:39
> Aug 27 18:03:10 middle kernel: forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
> Aug 27 18:03:10 middle kernel: forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
> Aug 27 18:03:10 middle kernel: forcedeth 0000:00:0a.0: ifname eth1, PHY OUI 0x5043 @ 9, addr 00:13:d4:d7:7d:a1
> Aug 27 18:03:10 middle kernel: forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver asix
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver cdc_ether
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver net1080
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver rndis_host
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver cdc_subset
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver zaurus
> Aug 27 18:03:10 middle kernel: ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
> Aug 27 18:03:10 middle kernel: ipw2100: Copyright(c) 2003-2006 Intel Corporation
> Aug 27 18:03:10 middle kernel: ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2k
> Aug 27 18:03:10 middle kernel: ipw2200: Copyright(c) 2003-2006 Intel Corporation
> Aug 27 18:03:10 middle kernel: airo(): Probing for PCI adapters
> Aug 27 18:03:10 middle kernel: airo(): Finished probing for PCI adapters
> Aug 27 18:03:10 middle kernel: Loaded prism54 driver, version 1.2
> Aug 27 18:03:10 middle kernel: Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
> Aug 27 18:03:10 middle kernel: Broadcom 43xx-legacy driver loaded [ Features: PLID, Firmware-ID: FW10 ]
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver zd1211rw
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver rndis_wlan
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver zd1201
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver usb8xxx
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver rtl8187
> Aug 27 18:03:10 middle kernel: iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26k
> Aug 27 18:03:10 middle kernel: iwl3945: Copyright(c) 2003-2008 Intel Corporation
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver rt2500usb
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver prism54usb
> Aug 27 18:03:10 middle kernel: Uniform Multi-Platform E-IDE driver
> Aug 27 18:03:10 middle kernel: amd74xx 0000:00:06.0: UDMA133 controller
> Aug 27 18:03:10 middle kernel: amd74xx 0000:00:06.0: IDE controller (0x10de:0x0053 rev 0xf2)
> Aug 27 18:03:10 middle kernel: amd74xx 0000:00:06.0: BIOS didn't set cable bits correctly. Enabling workaround.
> Aug 27 18:03:10 middle kernel: amd74xx 0000:00:06.0: not 100% native mode: will probe irqs later
> Aug 27 18:03:10 middle kernel:     ide0: BM-DMA at 0xf000-0xf007
> Aug 27 18:03:10 middle kernel:     ide1: BM-DMA at 0xf008-0xf00f
> Aug 27 18:03:10 middle kernel: hda: WDC WD2000JB-32EVA0, ATA DISK drive
> Aug 27 18:03:10 middle kernel: hdb: _NEC DVD_RW ND-3540A, ATAPI CD/DVD-ROM drive
> Aug 27 18:03:10 middle kernel: hda: UDMA/100 mode selected
> Aug 27 18:03:10 middle kernel: hdb: UDMA/33 mode selected
> Aug 27 18:03:10 middle kernel: hdc: WDC WD2000JB-00FUA0, ATA DISK drive
> Aug 27 18:03:10 middle kernel: hdc: UDMA/100 mode selected
> Aug 27 18:03:10 middle kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Aug 27 18:03:10 middle kernel: ide1 at 0x170-0x177,0x376 on irq 15
> Aug 27 18:03:10 middle kernel: hda: max request size: 512KiB
> Aug 27 18:03:10 middle kernel: hda: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63
> Aug 27 18:03:10 middle kernel: hda: cache flushes supported
> Aug 27 18:03:10 middle kernel:  hda: hda1 hda2 < hda5 hda6 hda7 hda8 hda9 >
> Aug 27 18:03:10 middle kernel: hdc: max request size: 512KiB
> Aug 27 18:03:10 middle kernel: hdc: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63
> Aug 27 18:03:10 middle kernel: hdc: cache flushes supported
> Aug 27 18:03:10 middle kernel:  hdc: hdc1 hdc2 < hdc5 hdc6 hdc7 hdc8 hdc9 >
> Aug 27 18:03:10 middle kernel: hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
> Aug 27 18:03:10 middle kernel: Uniform CD-ROM driver Revision: 3.20
> Aug 27 18:03:10 middle kernel: Driver 'sd' needs updating - please use bus_type methods
> Aug 27 18:03:10 middle kernel: Driver 'sr' needs updating - please use bus_type methods
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
> Aug 27 18:03:10 middle kernel: sata_nv 0000:00:07.0: PCI INT A -> Link[APSI] -> GSI 22 (level, low) -> IRQ 22
> Aug 27 18:03:10 middle kernel: scsi0 : sata_nv
> Aug 27 18:03:10 middle kernel: scsi1 : sata_nv
> Aug 27 18:03:10 middle kernel: ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 irq 22
> Aug 27 18:03:10 middle kernel: ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808 irq 22
> Aug 27 18:03:10 middle kernel: ata1: SATA link down (SStatus 0 SControl 300)
> Aug 27 18:03:10 middle kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> Aug 27 18:03:10 middle kernel: ata2.00: ATA-7: ST3500630AS, 3.AAK, max UDMA/133
> Aug 27 18:03:10 middle kernel: ata2.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 0/32)
> Aug 27 18:03:10 middle kernel: ata2.00: configured for UDMA/133
> Aug 27 18:03:10 middle kernel: scsi 1:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
> Aug 27 18:03:10 middle kernel: sd 1:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
> Aug 27 18:03:10 middle kernel: sd 1:0:0:0: [sda] Write Protect is off
> Aug 27 18:03:10 middle kernel: sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 27 18:03:10 middle kernel: sd 1:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
> Aug 27 18:03:10 middle kernel: sd 1:0:0:0: [sda] Write Protect is off
> Aug 27 18:03:10 middle kernel: sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 27 18:03:10 middle kernel:  sda: sda1
> Aug 27 18:03:10 middle kernel: sd 1:0:0:0: [sda] Attached SCSI disk
> Aug 27 18:03:10 middle kernel: sd 1:0:0:0: Attached scsi generic sg0 type 0
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
> Aug 27 18:03:10 middle kernel: sata_nv 0000:00:08.0: PCI INT A -> Link[APSJ] -> GSI 21 (level, low) -> IRQ 21
> Aug 27 18:03:10 middle kernel: scsi2 : sata_nv
> Aug 27 18:03:10 middle kernel: scsi3 : sata_nv
> Aug 27 18:03:10 middle kernel: ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400 irq 21
> Aug 27 18:03:10 middle kernel: ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408 irq 21
> Aug 27 18:03:10 middle kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Aug 27 18:03:10 middle kernel: ata3.00: ATA-7: ST3750640AS, 3.AAE, max UDMA/133
> Aug 27 18:03:10 middle kernel: ata3.00: 1465149168 sectors, multi 1: LBA48 NCQ (depth 0/32)
> Aug 27 18:03:10 middle kernel: ata3.00: configured for UDMA/133
> Aug 27 18:03:10 middle kernel: ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Aug 27 18:03:10 middle kernel: ata4.00: ATA-7: ST3750640AS, 3.AAE, max UDMA/133
> Aug 27 18:03:10 middle kernel: ata4.00: 1465149168 sectors, multi 1: LBA48 NCQ (depth 0/32)
> Aug 27 18:03:10 middle kernel: ata4.00: configured for UDMA/133
> Aug 27 18:03:10 middle kernel: scsi 2:0:0:0: Direct-Access     ATA      ST3750640AS      3.AA PQ: 0 ANSI: 5
> Aug 27 18:03:10 middle kernel: sd 2:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
> Aug 27 18:03:10 middle kernel: sd 2:0:0:0: [sdb] Write Protect is off
> Aug 27 18:03:10 middle kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 27 18:03:10 middle kernel: sd 2:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
> Aug 27 18:03:10 middle kernel: sd 2:0:0:0: [sdb] Write Protect is off
> Aug 27 18:03:10 middle kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 27 18:03:10 middle kernel:  sdb: sdb1
> Aug 27 18:03:10 middle kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
> Aug 27 18:03:10 middle kernel: sd 2:0:0:0: Attached scsi generic sg1 type 0
> Aug 27 18:03:10 middle kernel: scsi 3:0:0:0: Direct-Access     ATA      ST3750640AS      3.AA PQ: 0 ANSI: 5
> Aug 27 18:03:10 middle kernel: sd 3:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
> Aug 27 18:03:10 middle kernel: sd 3:0:0:0: [sdc] Write Protect is off
> Aug 27 18:03:10 middle kernel: sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 27 18:03:10 middle kernel: sd 3:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
> Aug 27 18:03:10 middle kernel: sd 3:0:0:0: [sdc] Write Protect is off
> Aug 27 18:03:10 middle kernel: sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug 27 18:03:10 middle kernel:  sdc: sdc1
> Aug 27 18:03:10 middle kernel: sd 3:0:0:0: [sdc] Attached SCSI disk
> Aug 27 18:03:10 middle kernel: sd 3:0:0:0: Attached scsi generic sg2 type 0
> Aug 27 18:03:10 middle kernel: ohci1394 0000:05:06.2: PCI INT B -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
> Aug 27 18:03:10 middle kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[d400d000-d400d7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> Aug 27 18:03:10 middle kernel: ohci1394 0000:05:0b.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
> Aug 27 18:03:10 middle kernel: ohci1394: fw-host1: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[d400c000-d400c7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> Aug 27 18:03:10 middle kernel: video1394: Installed video1394 module
> Aug 27 18:03:10 middle kernel: ieee1394: raw1394: /dev/raw1394 device initialized
> Aug 27 18:03:10 middle kernel: NOTE: The dv1394 driver is unsupported and may be removed in a future Linux release. Use raw1394 instead.
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
> Aug 27 18:03:10 middle kernel: ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 20 (level, low) -> IRQ 20
> Aug 27 18:03:10 middle kernel: ehci_hcd 0000:00:02.1: EHCI Host Controller
> Aug 27 18:03:10 middle kernel: ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
> Aug 27 18:03:10 middle kernel: ehci_hcd 0000:00:02.1: debug port 1
> Aug 27 18:03:10 middle kernel: ehci_hcd 0000:00:02.1: irq 20, io mem 0xfeb00000
> Aug 27 18:03:10 middle kernel: ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> Aug 27 18:03:10 middle kernel: usb usb1: configuration #1 chosen from 1 choice
> Aug 27 18:03:10 middle kernel: hub 1-0:1.0: USB hub found
> Aug 27 18:03:10 middle kernel: hub 1-0:1.0: 10 ports detected
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
> Aug 27 18:03:10 middle kernel: ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 23 (level, low) -> IRQ 23
> Aug 27 18:03:10 middle kernel: ohci_hcd 0000:00:02.0: OHCI Host Controller
> Aug 27 18:03:10 middle kernel: ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
> Aug 27 18:03:10 middle kernel: ohci_hcd 0000:00:02.0: irq 23, io mem 0xd5004000
> Aug 27 18:03:10 middle kernel: usb usb2: configuration #1 chosen from 1 choice
> Aug 27 18:03:10 middle kernel: hub 2-0:1.0: USB hub found
> Aug 27 18:03:10 middle kernel: hub 2-0:1.0: 10 ports detected
> Aug 27 18:03:10 middle kernel: usb 1-2: new high speed USB device using ehci_hcd and address 2
> Aug 27 18:03:10 middle kernel: usb 1-2: configuration #1 chosen from 1 choice
> Aug 27 18:03:10 middle kernel: hub 1-2:1.0: USB hub found
> Aug 27 18:03:10 middle kernel: hub 1-2:1.0: 3 ports detected
> Aug 27 18:03:10 middle kernel: usb 1-2.1: new high speed USB device using ehci_hcd and address 3
> Aug 27 18:03:10 middle kernel: usb 1-2.1: configuration #1 chosen from 1 choice
> Aug 27 18:03:10 middle kernel: hub 1-2.1:1.0: USB hub found
> Aug 27 18:03:10 middle kernel: hub 1-2.1:1.0: 3 ports detected
> Aug 27 18:03:10 middle kernel: usb 1-2.1.1: new high speed USB device using ehci_hcd and address 4
> Aug 27 18:03:10 middle kernel: usb 1-2.1.1: configuration #1 chosen from 1 choice
> Aug 27 18:03:10 middle kernel: usbcore: registered new interface driver usblp
> Aug 27 18:03:10 middle kernel: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> Aug 27 18:03:10 middle kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
> Aug 27 18:03:10 middle kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
> Aug 27 18:03:10 middle kernel: mice: PS/2 mouse device common for all mice
> Aug 27 18:03:10 middle kernel: input: AT Translated Set 2 keyboard as /class/input/input2
> Aug 27 18:03:10 middle kernel: input: PC Speaker as /class/input/input3
> Aug 27 18:03:10 middle kernel: input: ImExPS/2 Generic Explorer Mouse as /class/input/input4
> Aug 27 18:03:10 middle kernel: rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
> Aug 27 18:03:10 middle kernel: rtc0: alarms up to one year, y3k
> Aug 27 18:03:10 middle kernel: i2c /dev entries driver
> Aug 27 18:03:10 middle kernel: md: linear personality registered for level -1
> Aug 27 18:03:10 middle kernel: md: raid0 personality registered for level 0
> Aug 27 18:03:10 middle kernel: md: raid1 personality registered for level 1
> Aug 27 18:03:10 middle kernel: md: raid10 personality registered for level 10
> Aug 27 18:03:10 middle kernel: raid6: int64x1   2371 MB/s
> Aug 27 18:03:10 middle kernel: raid6: int64x2   3011 MB/s
> Aug 27 18:03:10 middle kernel: raid6: int64x4   2914 MB/s
> Aug 27 18:03:10 middle kernel: raid6: int64x8   2085 MB/s
> Aug 27 18:03:10 middle kernel: raid6: sse2x1    2285 MB/s
> Aug 27 18:03:10 middle kernel: raid6: sse2x2    3480 MB/s
> Aug 27 18:03:10 middle kernel: raid6: sse2x4    4000 MB/s
> Aug 27 18:03:10 middle kernel: raid6: using algorithm sse2x4 (4000 MB/s)
> Aug 27 18:03:10 middle kernel: md: raid6 personality registered for level 6
> Aug 27 18:03:10 middle kernel: md: raid5 personality registered for level 5
> Aug 27 18:03:10 middle kernel: md: raid4 personality registered for level 4
> Aug 27 18:03:10 middle kernel: EDAC MC: Ver: 2.1.0 Aug 25 2008
> Aug 27 18:03:10 middle kernel: cpuidle: using governor ladder
> Aug 27 18:03:10 middle kernel: GACT probability on
> Aug 27 18:03:10 middle kernel: Mirror/redirect action on
> Aug 27 18:03:10 middle kernel: IPv4 over IPv4 tunneling driver
> Aug 27 18:03:10 middle kernel: GRE over IPv4 tunneling driver
> Aug 27 18:03:10 middle kernel: TCP cubic registered
> Aug 27 18:03:10 middle kernel: NET: Registered protocol family 17
> Aug 27 18:03:10 middle kernel: NET: Registered protocol family 15
> Aug 27 18:03:10 middle kernel: ieee80211: 802.11 data/management/control stack, git-1.1.13
> Aug 27 18:03:10 middle kernel: ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
> Aug 27 18:03:10 middle kernel: powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4600+ processors (2 cpu cores) (version 2.20.00)
> Aug 27 18:03:10 middle kernel: powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x8
> Aug 27 18:03:10 middle kernel: powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xa
> Aug 27 18:03:10 middle kernel: powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xc
> Aug 27 18:03:10 middle kernel: powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xe
> Aug 27 18:03:10 middle kernel: powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
> Aug 27 18:03:10 middle kernel: rtc_cmos 00:04: setting system clock to 2008-08-27 16:02:10 UTC (1219852930)
> Aug 27 18:03:10 middle kernel: md: Autodetecting RAID arrays.
> Aug 27 18:03:10 middle kernel: md: Scanned 10 and added 10 devices.
> Aug 27 18:03:10 middle kernel: md: autorun ...
> Aug 27 18:03:10 middle kernel: md: considering hdc9 ...
> Aug 27 18:03:10 middle kernel: md:  adding hdc9 ...
> Aug 27 18:03:10 middle kernel: md: hdc8 has different UUID to hdc9
> Aug 27 18:03:10 middle kernel: md: hdc7 has different UUID to hdc9
> Aug 27 18:03:10 middle kernel: md: hdc6 has different UUID to hdc9
> Aug 27 18:03:10 middle kernel: md: hdc5 has different UUID to hdc9
> Aug 27 18:03:10 middle kernel: md:  adding hda9 ...
> Aug 27 18:03:10 middle kernel: md: hda8 has different UUID to hdc9
> Aug 27 18:03:10 middle kernel: md: hda7 has different UUID to hdc9
> Aug 27 18:03:10 middle kernel: md: hda6 has different UUID to hdc9
> Aug 27 18:03:10 middle kernel: md: hda5 has different UUID to hdc9
> Aug 27 18:03:10 middle kernel: md: created md4
> Aug 27 18:03:10 middle kernel: md: bind<hda9>
> Aug 27 18:03:10 middle kernel: md: bind<hdc9>
> Aug 27 18:03:10 middle kernel: md: running: <hdc9><hda9>
> Aug 27 18:03:10 middle kernel: raid1: raid set md4 active with 2 out of 2 mirrors
> Aug 27 18:03:10 middle kernel: md4: bitmap initialized from disk: read 10/10 pages, set 3 bits
> Aug 27 18:03:10 middle kernel: created bitmap (156 pages) for device md4
> Aug 27 18:03:10 middle kernel: md: considering hdc8 ...
> Aug 27 18:03:10 middle kernel: md:  adding hdc8 ...
> Aug 27 18:03:10 middle kernel: md: hdc7 has different UUID to hdc8
> Aug 27 18:03:10 middle kernel: md: hdc6 has different UUID to hdc8
> Aug 27 18:03:10 middle kernel: md: hdc5 has different UUID to hdc8
> Aug 27 18:03:10 middle kernel: md:  adding hda8 ...
> Aug 27 18:03:10 middle kernel: md: hda7 has different UUID to hdc8
> Aug 27 18:03:10 middle kernel: md: hda6 has different UUID to hdc8
> Aug 27 18:03:10 middle kernel: md: hda5 has different UUID to hdc8
> Aug 27 18:03:10 middle kernel: md: created md3
> Aug 27 18:03:10 middle kernel: md: bind<hda8>
> Aug 27 18:03:10 middle kernel: md: bind<hdc8>
> Aug 27 18:03:10 middle kernel: md: running: <hdc8><hda8>
> Aug 27 18:03:10 middle kernel: raid1: raid set md3 active with 2 out of 2 mirrors
> Aug 27 18:03:10 middle kernel: md3: bitmap initialized from disk: read 8/8 pages, set 4 bits
> Aug 27 18:03:10 middle kernel: created bitmap (123 pages) for device md3
> Aug 27 18:03:10 middle kernel: md: considering hdc7 ...
> Aug 27 18:03:10 middle kernel: md:  adding hdc7 ...
> Aug 27 18:03:10 middle kernel: md: hdc6 has different UUID to hdc7
> Aug 27 18:03:10 middle kernel: md: hdc5 has different UUID to hdc7
> Aug 27 18:03:10 middle kernel: md:  adding hda7 ...
> Aug 27 18:03:10 middle kernel: md: hda6 has different UUID to hdc7
> Aug 27 18:03:10 middle kernel: md: hda5 has different UUID to hdc7
> Aug 27 18:03:10 middle kernel: md: created md2
> Aug 27 18:03:10 middle kernel: md: bind<hda7>
> Aug 27 18:03:10 middle kernel: md: bind<hdc7>
> Aug 27 18:03:10 middle kernel: md: running: <hdc7><hda7>
> Aug 27 18:03:10 middle kernel: raid1: raid set md2 active with 2 out of 2 mirrors
> Aug 27 18:03:10 middle kernel: md2: bitmap initialized from disk: read 8/8 pages, set 55 bits
> Aug 27 18:03:10 middle kernel: created bitmap (123 pages) for device md2
> Aug 27 18:03:10 middle kernel: md: considering hdc6 ...
> Aug 27 18:03:10 middle kernel: md:  adding hdc6 ...
> Aug 27 18:03:10 middle kernel: md: hdc5 has different UUID to hdc6
> Aug 27 18:03:10 middle kernel: md:  adding hda6 ...
> Aug 27 18:03:10 middle kernel: md: hda5 has different UUID to hdc6
> Aug 27 18:03:10 middle kernel: md: created md1
> Aug 27 18:03:10 middle kernel: md: bind<hda6>
> Aug 27 18:03:10 middle kernel: md: bind<hdc6>
> Aug 27 18:03:10 middle kernel: md: running: <hdc6><hda6>
> Aug 27 18:03:10 middle kernel: raid1: raid set md1 active with 2 out of 2 mirrors
> Aug 27 18:03:10 middle kernel: md1: bitmap initialized from disk: read 12/12 pages, set 54 bits
> Aug 27 18:03:10 middle kernel: created bitmap (184 pages) for device md1
> Aug 27 18:03:10 middle kernel: md: considering hdc5 ...
> Aug 27 18:03:10 middle kernel: md:  adding hdc5 ...
> Aug 27 18:03:10 middle kernel: md:  adding hda5 ...
> Aug 27 18:03:10 middle kernel: md: created md5
> Aug 27 18:03:10 middle kernel: md: bind<hda5>
> Aug 27 18:03:10 middle kernel: md: bind<hdc5>
> Aug 27 18:03:10 middle kernel: md: running: <hdc5><hda5>
> Aug 27 18:03:10 middle kernel: raid1: raid set md5 active with 2 out of 2 mirrors
> Aug 27 18:03:10 middle kernel: md5: bitmap initialized from disk: read 9/9 pages, set 0 bits
> Aug 27 18:03:10 middle kernel: created bitmap (129 pages) for device md5
> Aug 27 18:03:10 middle kernel: md: ... autorun DONE.
> Aug 27 18:03:10 middle kernel: kjournald starting.  Commit interval 5 seconds
> Aug 27 18:03:10 middle kernel: EXT3-fs: mounted filesystem with ordered data mode.
> Aug 27 18:03:10 middle kernel: VFS: Mounted root (ext3 filesystem) readonly.
> Aug 27 18:03:10 middle kernel: Freeing unused kernel memory: 340k freed
> Aug 27 18:03:10 middle kernel: Clocksource tsc unstable (delta = -291716323 ns)
> Aug 27 18:03:10 middle kernel: udev: renamed network interface eth0 to eth1
> Aug 27 18:03:10 middle kernel: udev: renamed network interface eth1_rename to eth0
> Aug 27 18:03:10 middle kernel: i2c-adapter i2c-3: nForce2 SMBus adapter at 0x4c00
> Aug 27 18:03:10 middle kernel: i2c-adapter i2c-4: nForce2 SMBus adapter at 0x4c40
> Aug 27 18:03:10 middle kernel: EMU10K1_Audigy 0000:05:06.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> IRQ 16
> Aug 27 18:03:10 middle kernel: Installing spdif_bug patch: Audigy 2 ZS [2001]
> Aug 27 18:03:10 middle kernel: ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 22
> Aug 27 18:03:10 middle kernel: Intel ICH 0000:00:04.0: PCI INT A -> Link[APCJ] -> GSI 22 (level, low) -> IRQ 22
> Aug 27 18:03:10 middle kernel: intel8x0_measure_ac97_clock: measured 50574 usecs
> Aug 27 18:03:10 middle kernel: intel8x0: clocking to 46834
> Aug 27 18:03:10 middle kernel: Adding 4200888k swap on /dev/md5.  Priority:-1 extents:1 across:4200888k
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff803a30f1>] ? rb_insert_color+0x101/0x130
> Aug 27 18:03:10 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:10 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> Aug 27 18:03:10 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: EXT3 FS on md2, internal journal
> Aug 27 18:03:10 middle kernel: it87: Found IT8712F chip at 0x290, revision 7
> Aug 27 18:03:10 middle kernel: it87: in3 is VCC (+5V)
> Aug 27 18:03:10 middle kernel: it87: in7 is VCCH (+5V Stand-By)
> Aug 27 18:03:10 middle kernel: it87 it87.656: Detected broken BIOS defaults, disabling PWM interface
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1191, comm: md1_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:10 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> Aug 27 18:03:10 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:10 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1173, comm: md4_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff80256172>] ? enqueue_hrtimer+0x82/0x130
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624c0b>] bitmap_daemon_work+0x1fb/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802304f6>] ? __dequeue_entity+0x36/0x90
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1173, comm: md4_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff803a30f1>] ? rb_insert_color+0x101/0x130
> Aug 27 18:03:10 middle kernel:  [<ffffffff80256172>] ? enqueue_hrtimer+0x82/0x130
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8023022e>] ? __wake_up+0x4e/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff803a30f1>] ? rb_insert_color+0x101/0x130
> Aug 27 18:03:10 middle kernel:  [<ffffffff80256172>] ? enqueue_hrtimer+0x82/0x130
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff803a30f1>] ? rb_insert_color+0x101/0x130
> Aug 27 18:03:10 middle kernel:  [<ffffffff80256172>] ? enqueue_hrtimer+0x82/0x130
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80711081>] ? _spin_unlock_irq+0x11/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> Aug 27 18:03:10 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: kjournald starting.  Commit interval 5 seconds
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1191, comm: md1_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff80390623>] ? __make_request+0xe3/0x3a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8038ec9d>] ? generic_make_request+0x1fd/0x2f0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:10 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> Aug 27 18:03:10 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: EXT3 FS on md1, internal journal
> Aug 27 18:03:10 middle kernel: EXT3-fs: mounted filesystem with ordered data mode.
> Aug 27 18:03:10 middle kernel: kjournald starting.  Commit interval 5 seconds
> Aug 27 18:03:10 middle kernel: EXT3 FS on md3, internal journal
> Aug 27 18:03:10 middle kernel: EXT3-fs: mounted filesystem with ordered data mode.
> Aug 27 18:03:10 middle kernel: ReiserFS: md4: found reiserfs format "3.6" with standard journal
> Aug 27 18:03:10 middle kernel: ReiserFS: md4: using ordered data mode
> Aug 27 18:03:10 middle kernel: ReiserFS: md4: journal params: device md4, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> Aug 27 18:03:10 middle kernel: ReiserFS: md4: checking transaction log (md4)
> Aug 27 18:03:10 middle kernel: ReiserFS: md4: Using r5 hash to sort names
> Aug 27 18:03:10 middle kernel: kjournald starting.  Commit interval 5 seconds
> Aug 27 18:03:10 middle kernel: EXT3 FS on sdc1, internal journal
> Aug 27 18:03:10 middle kernel: EXT3-fs: mounted filesystem with ordered data mode.
> Aug 27 18:03:10 middle kernel: kjournald starting.  Commit interval 5 seconds
> Aug 27 18:03:10 middle kernel: EXT3 FS on sdb1, internal journal
> Aug 27 18:03:10 middle kernel: EXT3-fs: mounted filesystem with ordered data mode.
> Aug 27 18:03:10 middle kernel: ReiserFS: sda1: found reiserfs format "3.6" with standard journal
> Aug 27 18:03:10 middle kernel: ReiserFS: sda1: using ordered data mode
> Aug 27 18:03:10 middle kernel: ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> Aug 27 18:03:10 middle kernel: ReiserFS: sda1: checking transaction log (sda1)
> Aug 27 18:03:10 middle kernel: ReiserFS: sda1: Using r5 hash to sort names
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1173, comm: md4_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80711081>] ? _spin_unlock_irq+0x11/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> Aug 27 18:03:10 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1191, comm: md1_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:10 middle kernel: Pid: 1191, comm: md1_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:10 middle kernel: Call Trace:
> Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff8055ff6c>] ? do_rw_taskfile+0x1fc/0x280
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:10 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> Aug 27 18:03:10 middle kernel:  [<ffffffff806241a8>] bitmap_unplug+0xc8/0x1c0
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024753c>] ? del_timer+0x5c/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff8060753b>] flush_pending_writes+0x5b/0xb0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8060768c>] raid1d+0x5c/0x10a0
> Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:10 middle kernel: 
> Aug 27 18:03:11 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:11 middle kernel: Pid: 1191, comm: md1_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:11 middle kernel: 
> Aug 27 18:03:11 middle kernel: Call Trace:
> Aug 27 18:03:11 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:11 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:11 middle kernel:  [<ffffffff80711081>] ? _spin_unlock_irq+0x11/0x40
> Aug 27 18:03:11 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:11 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:11 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:11 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:11 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:11 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:11 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:11 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:11 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:11 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:11 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:11 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:11 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:11 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:11 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:11 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:11 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:11 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:11 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:11 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:11 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:11 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:11 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:11 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:11 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:11 middle kernel: 
> Aug 27 18:03:12 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:12 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:12 middle kernel: 
> Aug 27 18:03:12 middle kernel: Call Trace:
> Aug 27 18:03:12 middle kernel:  [<ffffffff80298755>] ? kmem_cache_alloc+0xa5/0xf0
> Aug 27 18:03:12 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:12 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:12 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:12 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:12 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:12 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:12 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> Aug 27 18:03:12 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> Aug 27 18:03:12 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:12 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:12 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:12 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:12 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:12 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:12 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:12 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:12 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:12 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:12 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:12 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:12 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:12 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:12 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:12 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:12 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:12 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:12 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:12 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:12 middle kernel: 
> Aug 27 18:03:13 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:13 middle kernel: Pid: 1173, comm: md4_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:13 middle kernel: 
> Aug 27 18:03:13 middle kernel: Call Trace:
> Aug 27 18:03:13 middle kernel:  [<ffffffff802304f6>] ? __dequeue_entity+0x36/0x90
> Aug 27 18:03:13 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:13 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:13 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:13 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:13 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:13 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:13 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:13 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:13 middle kernel:  [<ffffffff8023022e>] ? __wake_up+0x4e/0x70
> Aug 27 18:03:13 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:13 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:13 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:13 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:13 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:13 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:13 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:13 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:13 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:13 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:13 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:13 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:13 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:13 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:13 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:13 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:13 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:13 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:13 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:13 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:13 middle kernel: 
> Aug 27 18:03:15 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:15 middle kernel: Pid: 1191, comm: md1_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:15 middle kernel: 
> Aug 27 18:03:15 middle kernel: Call Trace:
> Aug 27 18:03:15 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:15 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:15 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:15 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:15 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:15 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:15 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:15 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:15 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:15 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:15 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:15 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:15 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:15 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:15 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:15 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:15 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:15 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:15 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:15 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:15 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:15 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:15 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:15 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:15 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:15 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:15 middle kernel: 
> Aug 27 18:03:15 middle lpd[4261]: restarted
> Aug 27 18:03:16 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:16 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:16 middle kernel: 
> Aug 27 18:03:16 middle kernel: Call Trace:
> Aug 27 18:03:16 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:16 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:16 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:16 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:16 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:16 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:16 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:16 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:16 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:16 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:16 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:16 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:16 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:16 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:16 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:16 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:16 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:16 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:16 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:16 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:16 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:16 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:16 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:16 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:16 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:16 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:16 middle kernel: 
> Aug 27 18:03:17 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:17 middle kernel: Pid: 1191, comm: md1_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:17 middle kernel: 
> Aug 27 18:03:17 middle kernel: Call Trace:
> Aug 27 18:03:17 middle kernel:  [<ffffffff80298755>] ? kmem_cache_alloc+0xa5/0xf0
> Aug 27 18:03:17 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:17 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:17 middle kernel:  [<ffffffff80562900>] ? ide_dma_exec_cmd+0x20/0x30
> Aug 27 18:03:17 middle kernel:  [<ffffffff8055ff6c>] ? do_rw_taskfile+0x1fc/0x280
> Aug 27 18:03:17 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:17 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:17 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:17 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:17 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> Aug 27 18:03:17 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> Aug 27 18:03:17 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:17 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:17 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:17 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:17 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:17 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:17 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:17 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:17 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:17 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:17 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:17 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:17 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:17 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:17 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:17 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:17 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:17 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:17 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:17 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:17 middle kernel: 
> Aug 27 18:03:20 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:20 middle kernel: Pid: 1191, comm: md1_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:20 middle kernel: 
> Aug 27 18:03:20 middle kernel: Call Trace:
> Aug 27 18:03:20 middle kernel:  [<ffffffff802304f6>] ? __dequeue_entity+0x36/0x90
> Aug 27 18:03:20 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:20 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:20 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:20 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:20 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:20 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:20 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:20 middle kernel:  [<ffffffff80624d75>] bitmap_daemon_work+0x365/0x4b0
> Aug 27 18:03:20 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:20 middle kernel:  [<ffffffff80620aa0>] md_check_recovery+0x30/0x640
> Aug 27 18:03:20 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:20 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:20 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:20 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:20 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:20 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:20 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:20 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:20 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:20 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:20 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:20 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:20 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:20 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:20 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:20 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:20 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:20 middle kernel: 
> Aug 27 18:03:21 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:21 middle kernel: Pid: 1179, comm: md3_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:21 middle kernel: 
> Aug 27 18:03:21 middle kernel: Call Trace:
> Aug 27 18:03:21 middle kernel:  [<ffffffff80390623>] ? __make_request+0xe3/0x3a0
> Aug 27 18:03:21 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:21 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:21 middle kernel:  [<ffffffff8038ec9d>] ? generic_make_request+0x1fd/0x2f0
> Aug 27 18:03:21 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:21 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:21 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:21 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:21 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:21 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:21 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> Aug 27 18:03:21 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:21 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:21 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:21 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:21 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:21 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:21 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:21 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:21 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:21 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:21 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:21 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:21 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:21 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:21 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:21 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:21 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:21 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:21 middle kernel: 
> Aug 27 18:03:22 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:22 middle kernel: Pid: 1191, comm: md1_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:22 middle kernel: 
> Aug 27 18:03:22 middle kernel: Call Trace:
> Aug 27 18:03:22 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:22 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:22 middle kernel:  [<ffffffff80711081>] ? _spin_unlock_irq+0x11/0x40
> Aug 27 18:03:22 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:22 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:22 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:22 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:22 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:22 middle kernel:  [<ffffffff8070f3ec>] ? preempt_schedule+0x3c/0x50
> Aug 27 18:03:22 middle kernel:  [<ffffffff807110db>] ? _spin_unlock_irqrestore+0x2b/0x40
> Aug 27 18:03:22 middle kernel:  [<ffffffff8023022e>] ? __wake_up+0x4e/0x70
> Aug 27 18:03:22 middle kernel:  [<ffffffff806241a8>] bitmap_unplug+0xc8/0x1c0
> Aug 27 18:03:22 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:22 middle kernel:  [<ffffffff8024753c>] ? del_timer+0x5c/0x70
> Aug 27 18:03:22 middle kernel:  [<ffffffff8060753b>] flush_pending_writes+0x5b/0xb0
> Aug 27 18:03:22 middle kernel:  [<ffffffff8060768c>] raid1d+0x5c/0x10a0
> Aug 27 18:03:22 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:22 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:22 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:22 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:22 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:22 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:22 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:22 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:22 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:22 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:22 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:22 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:22 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:22 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:22 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:22 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> Aug 27 18:03:22 middle kernel: 
> Aug 27 18:03:24 middle kernel: in_atomic():1, irqs_disabled():0
> Aug 27 18:03:24 middle kernel: Pid: 1191, comm: md1_raid1 Not tainted 2.6.27-rc4 #2
> Aug 27 18:03:24 middle kernel: 
> Aug 27 18:03:24 middle kernel: Call Trace:
> Aug 27 18:03:24 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> Aug 27 18:03:24 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> Aug 27 18:03:24 middle kernel:  [<ffffffff80711081>] ? _spin_unlock_irq+0x11/0x40
> Aug 27 18:03:24 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:24 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> Aug 27 18:03:24 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> Aug 27 18:03:24 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> Aug 27 18:03:24 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> Aug 27 18:03:24 middle kernel:  [<ffffffff803a30f1>] ? rb_insert_color+0x101/0x130
> Aug 27 18:03:24 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> Aug 27 18:03:24 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> Aug 27 18:03:24 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> Aug 27 18:03:24 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> Aug 27 18:03:24 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> Aug 27 18:03:24 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> Aug 27 18:03:24 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> Aug 27 18:03:24 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> Aug 27 18:03:24 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:24 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> Aug 27 18:03:24 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:24 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> Aug 27 18:03:24 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> Aug 27 18:03:24 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> Aug 27 18:03:24 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> Aug 27 18:03:24 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> Aug 27 18:03:24 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> Aug 27 18:03:24 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> Aug 27 18:03:24 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> Aug 27 18:03:24 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> Aug 27 18:03:24 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> Aug 27 18:03:24 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> 
> 
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.27-rc4
> # Mon Aug 25 14:02:40 2008
> #
> CONFIG_64BIT=y
> # CONFIG_X86_32 is not set
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> # CONFIG_GENERIC_LOCKBREAK is not set
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_FAST_CMPXCHG_LOCAL=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> # CONFIG_GENERIC_GPIO is not set
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_GENERIC_SPINLOCK=y
> # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ZONE_DMA32=y
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_AOUT=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_X86_SMP=y
> CONFIG_X86_64_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_BIOS_REBOOT=y
> CONFIG_X86_TRAMPOLINE=y
> # CONFIG_KTIME_SCALAR is not set
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> 
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=18
> # CONFIG_CGROUPS is not set
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_GROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_USER_SCHED=y
> # CONFIG_CGROUP_SCHED is not set
> CONFIG_SYSFS_DEPRECATED=y
> CONFIG_SYSFS_DEPRECATED_V2=y
> # CONFIG_RELAY is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> # CONFIG_IPC_NS is not set
> # CONFIG_USER_NS is not set
> # CONFIG_PID_NS is not set
> # CONFIG_BLK_DEV_INITRD is not set
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_ALL is not set
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_COMPAT_BRK=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> # CONFIG_PROFILING is not set
> # CONFIG_MARKERS is not set
> CONFIG_HAVE_OPROFILE=y
> # CONFIG_KPROBES is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> # CONFIG_HAVE_ARCH_TRACEHOOK is not set
> # CONFIG_HAVE_DMA_ATTRS is not set
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> # CONFIG_HAVE_CLK is not set
> CONFIG_PROC_PAGE_MONITOR=y
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> CONFIG_MODULE_FORCE_UNLOAD=y
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> CONFIG_KMOD=y
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> # CONFIG_BLK_DEV_IO_TRACE is not set
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
> CONFIG_BLOCK_COMPAT=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_AS=y
> # CONFIG_DEFAULT_DEADLINE is not set
> # CONFIG_DEFAULT_CFQ is not set
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="anticipatory"
> CONFIG_CLASSIC_RCU=y
> 
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> # CONFIG_NO_HZ is not set
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_SMP=y
> CONFIG_X86_FIND_SMP_CONFIG=y
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_PC=y
> # CONFIG_X86_ELAN is not set
> # CONFIG_X86_VOYAGER is not set
> # CONFIG_X86_GENERICARCH is not set
> # CONFIG_X86_VSMP is not set
> # CONFIG_PARAVIRT_GUEST is not set
> CONFIG_MEMTEST=y
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> CONFIG_MK8=y
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP2 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_GENERIC_CPU is not set
> CONFIG_X86_CPU=y
> CONFIG_X86_L1_CACHE_BYTES=64
> CONFIG_X86_INTERNODE_CACHE_BYTES=64
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> CONFIG_GART_IOMMU=y
> # CONFIG_CALGARY_IOMMU is not set
> CONFIG_AMD_IOMMU=y
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> # CONFIG_MAXSMP is not set
> CONFIG_NR_CPUS=2
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_MCE=y
> # CONFIG_X86_MCE_INTEL is not set
> CONFIG_X86_MCE_AMD=y
> # CONFIG_I8K is not set
> # CONFIG_MICROCODE is not set
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> # CONFIG_NUMA is not set
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_SELECT_MEMORY_MODEL=y
> # CONFIG_FLATMEM_MANUAL is not set
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> # CONFIG_SPARSEMEM_STATIC is not set
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_RESOURCES_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x200000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_HOTPLUG_CPU=y
> CONFIG_COMPAT_VDSO=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management options
> #
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_PM_SLEEP_SMP=y
> CONFIG_PM_SLEEP=y
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> # CONFIG_HIBERNATION is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set
> CONFIG_ACPI_PROCFS_POWER=y
> CONFIG_ACPI_SYSFS_POWER=y
> CONFIG_ACPI_PROC_EVENT=y
> CONFIG_ACPI_AC=y
> # CONFIG_ACPI_BATTERY is not set
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_DOCK=y
> # CONFIG_ACPI_BAY is not set
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_WMI is not set
> # CONFIG_ACPI_ASUS is not set
> # CONFIG_ACPI_TOSHIBA is not set
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=y
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> # CONFIG_CPU_FREQ_DEBUG is not set
> CONFIG_CPU_FREQ_STAT=y
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> # CONFIG_CPU_FREQ_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
> 
> #
> # CPUFreq processor drivers
> #
> CONFIG_X86_ACPI_CPUFREQ=m
> CONFIG_X86_POWERNOW_K8=y
> CONFIG_X86_POWERNOW_K8_ACPI=y
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> # CONFIG_X86_P4_CLOCKMOD is not set
> 
> #
> # shared options
> #
> # CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
> # CONFIG_X86_SPEEDSTEP_LIB is not set
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_DMAR=y
> CONFIG_DMAR_GFX_WA=y
> CONFIG_DMAR_FLOPPY_WA=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_PCIEAER=y
> # CONFIG_PCIEASPM is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> CONFIG_PCI_LEGACY=y
> # CONFIG_PCI_DEBUG is not set
> CONFIG_HT_IRQ=y
> CONFIG_ISA_DMA_API=y
> CONFIG_K8_NB=y
> # CONFIG_PCCARD is not set
> # CONFIG_HOTPLUG_PCI is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> # CONFIG_BINFMT_MISC is not set
> CONFIG_IA32_EMULATION=y
> # CONFIG_IA32_AOUT is not set
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_SYSVIPC_COMPAT=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_MMAP=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> # CONFIG_XFRM_USER is not set
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=y
> CONFIG_NET_KEY=y
> # CONFIG_NET_KEY_MIGRATE is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> # CONFIG_IP_MULTIPLE_TABLES is not set
> # CONFIG_IP_ROUTE_MULTIPATH is not set
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=y
> CONFIG_NET_IPGRE=y
> CONFIG_NET_IPGRE_BROADCAST=y
> # CONFIG_IP_MROUTE is not set
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_AH=y
> CONFIG_INET_ESP=y
> CONFIG_INET_IPCOMP=y
> CONFIG_INET_XFRM_TUNNEL=y
> CONFIG_INET_TUNNEL=y
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> CONFIG_INET_XFRM_MODE_BEET=y
> # CONFIG_INET_LRO is not set
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_TCP_MD5SIG is not set
> CONFIG_IP_VS=m
> # CONFIG_IP_VS_DEBUG is not set
> CONFIG_IP_VS_TAB_BITS=12
> 
> #
> # IPVS transport protocol load balancing support
> #
> CONFIG_IP_VS_PROTO_TCP=y
> CONFIG_IP_VS_PROTO_UDP=y
> CONFIG_IP_VS_PROTO_ESP=y
> CONFIG_IP_VS_PROTO_AH=y
> 
> #
> # IPVS scheduler
> #
> CONFIG_IP_VS_RR=m
> CONFIG_IP_VS_WRR=m
> CONFIG_IP_VS_LC=m
> CONFIG_IP_VS_WLC=m
> CONFIG_IP_VS_LBLC=m
> CONFIG_IP_VS_LBLCR=m
> CONFIG_IP_VS_DH=m
> CONFIG_IP_VS_SH=m
> CONFIG_IP_VS_SED=m
> CONFIG_IP_VS_NQ=m
> 
> #
> # IPVS application helper
> #
> CONFIG_IP_VS_FTP=m
> # CONFIG_IPV6 is not set
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> 
> #
> # Core Netfilter Configuration
> #
> # CONFIG_NETFILTER_NETLINK_QUEUE is not set
> # CONFIG_NETFILTER_NETLINK_LOG is not set
> # CONFIG_NF_CONNTRACK is not set
> CONFIG_NETFILTER_XTABLES=m
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> CONFIG_NETFILTER_XT_TARGET_DSCP=m
> CONFIG_NETFILTER_XT_TARGET_MARK=m
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> # CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
> CONFIG_NETFILTER_XT_TARGET_TRACE=m
> # CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
> # CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> CONFIG_NETFILTER_XT_MATCH_DSCP=m
> CONFIG_NETFILTER_XT_MATCH_ESP=m
> # CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> CONFIG_NETFILTER_XT_MATCH_LIMIT=m
> CONFIG_NETFILTER_XT_MATCH_MAC=m
> CONFIG_NETFILTER_XT_MATCH_MARK=m
> # CONFIG_NETFILTER_XT_MATCH_OWNER is not set
> CONFIG_NETFILTER_XT_MATCH_POLICY=m
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> # CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
> CONFIG_NETFILTER_XT_MATCH_REALM=m
> CONFIG_NETFILTER_XT_MATCH_SCTP=m
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> CONFIG_NETFILTER_XT_MATCH_STRING=m
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
> # CONFIG_NETFILTER_XT_MATCH_TIME is not set
> CONFIG_NETFILTER_XT_MATCH_U32=m
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_IP_NF_QUEUE=m
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_MATCH_RECENT=m
> CONFIG_IP_NF_MATCH_ECN=m
> CONFIG_IP_NF_MATCH_AH=m
> CONFIG_IP_NF_MATCH_TTL=m
> CONFIG_IP_NF_MATCH_ADDRTYPE=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_LOG=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_TARGET_ECN=m
> CONFIG_IP_NF_TARGET_TTL=m
> CONFIG_IP_NF_RAW=m
> CONFIG_IP_NF_ARPTABLES=m
> CONFIG_IP_NF_ARPFILTER=m
> CONFIG_IP_NF_ARP_MANGLE=m
> # CONFIG_IP_DCCP is not set
> CONFIG_IP_SCTP=m
> # CONFIG_SCTP_DBG_MSG is not set
> # CONFIG_SCTP_DBG_OBJCNT is not set
> # CONFIG_SCTP_HMAC_NONE is not set
> # CONFIG_SCTP_HMAC_SHA1 is not set
> CONFIG_SCTP_HMAC_MD5=y
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=m
> CONFIG_NET_SCH_HTB=m
> CONFIG_NET_SCH_HFSC=m
> CONFIG_NET_SCH_PRIO=m
> CONFIG_NET_SCH_RED=m
> CONFIG_NET_SCH_SFQ=m
> CONFIG_NET_SCH_TEQL=m
> CONFIG_NET_SCH_TBF=m
> CONFIG_NET_SCH_GRED=m
> CONFIG_NET_SCH_DSMARK=m
> CONFIG_NET_SCH_NETEM=m
> CONFIG_NET_SCH_INGRESS=m
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> # CONFIG_NET_CLS_BASIC is not set
> CONFIG_NET_CLS_TCINDEX=m
> CONFIG_NET_CLS_ROUTE4=m
> CONFIG_NET_CLS_ROUTE=y
> CONFIG_NET_CLS_FW=m
> CONFIG_NET_CLS_U32=m
> # CONFIG_CLS_U32_PERF is not set
> # CONFIG_CLS_U32_MARK is not set
> CONFIG_NET_CLS_RSVP=m
> CONFIG_NET_CLS_RSVP6=m
> # CONFIG_NET_CLS_FLOW is not set
> # CONFIG_NET_EMATCH is not set
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=y
> CONFIG_NET_ACT_GACT=y
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=y
> CONFIG_NET_ACT_IPT=m
> # CONFIG_NET_ACT_NAT is not set
> # CONFIG_NET_ACT_PEDIT is not set
> # CONFIG_NET_ACT_SIMP is not set
> # CONFIG_NET_CLS_IND is not set
> CONFIG_NET_SCH_FIFO=y
> 
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=m
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> 
> #
> # Wireless
> #
> CONFIG_CFG80211=y
> CONFIG_NL80211=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_WIRELESS_EXT_SYSFS=y
> CONFIG_MAC80211=y
> 
> #
> # Rate control algorithm selection
> #
> CONFIG_MAC80211_RC_PID=y
> CONFIG_MAC80211_RC_DEFAULT_PID=y
> CONFIG_MAC80211_RC_DEFAULT="pid"
> CONFIG_MAC80211_MESH=y
> CONFIG_MAC80211_LEDS=y
> # CONFIG_MAC80211_DEBUG_MENU is not set
> CONFIG_IEEE80211=y
> # CONFIG_IEEE80211_DEBUG is not set
> CONFIG_IEEE80211_CRYPT_WEP=y
> # CONFIG_IEEE80211_CRYPT_CCMP is not set
> # CONFIG_IEEE80211_CRYPT_TKIP is not set
> CONFIG_RFKILL=y
> CONFIG_RFKILL_INPUT=y
> CONFIG_RFKILL_LEDS=y
> # CONFIG_NET_9P is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG is not set
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=y
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> # CONFIG_BLK_DEV_RAM is not set
> CONFIG_CDROM_PKTCDVD=y
> CONFIG_CDROM_PKTCDVD_BUFFERS=32
> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_MISC_DEVICES=y
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> CONFIG_EEPROM_93CX6=y
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_ACER_WMI is not set
> # CONFIG_ASUS_LAPTOP is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_MSI_LAPTOP is not set
> # CONFIG_COMPAL_LAPTOP is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_INTEL_MENLOW is not set
> # CONFIG_EEEPC_LAPTOP is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_SGI_XP is not set
> # CONFIG_HP_ILO is not set
> # CONFIG_SGI_GRU is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> CONFIG_BLK_DEV_IDE=y
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> # CONFIG_BLK_DEV_IDE_SATA is not set
> CONFIG_BLK_DEV_IDEDISK=y
> # CONFIG_IDEDISK_MULTI_MODE is not set
> CONFIG_BLK_DEV_IDECD=y
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_BLK_DEV_IDEFLOPPY is not set
> CONFIG_BLK_DEV_IDESCSI=y
> # CONFIG_BLK_DEV_IDEACPI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> CONFIG_IDE_PROC_FS=y
> 
> #
> # IDE chipset support/bugfixes
> #
> # CONFIG_IDE_GENERIC is not set
> # CONFIG_BLK_DEV_PLATFORM is not set
> # CONFIG_BLK_DEV_CMD640 is not set
> # CONFIG_BLK_DEV_IDEPNP is not set
> CONFIG_BLK_DEV_IDEDMA_SFF=y
> 
> #
> # PCI IDE chipsets support
> #
> CONFIG_BLK_DEV_IDEPCI=y
> CONFIG_IDEPCI_PCIBUS_ORDER=y
> # CONFIG_BLK_DEV_OFFBOARD is not set
> # CONFIG_BLK_DEV_GENERIC is not set
> # CONFIG_BLK_DEV_OPTI621 is not set
> # CONFIG_BLK_DEV_RZ1000 is not set
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> CONFIG_BLK_DEV_AMD74XX=y
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> CONFIG_BLK_DEV_HPT366=y
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> # CONFIG_BLK_DEV_PIIX is not set
> # CONFIG_BLK_DEV_IT8213 is not set
> # CONFIG_BLK_DEV_IT821X is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_PDC202XX_OLD is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> # CONFIG_BLK_DEV_TRM290 is not set
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> # CONFIG_BLK_DEV_TC86C001 is not set
> CONFIG_BLK_DEV_IDEDMA=y
> 
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=y
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> CONFIG_CHR_DEV_SG=y
> # CONFIG_CHR_DEV_SCH is not set
> 
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> # CONFIG_SCSI_SCAN_ASYNC is not set
> CONFIG_SCSI_WAIT_SCAN=m
> 
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_DH is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_PMP=y
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> # CONFIG_SATA_SVW is not set
> # CONFIG_ATA_PIIX is not set
> # CONFIG_SATA_MV is not set
> CONFIG_SATA_NV=y
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SX4 is not set
> CONFIG_SATA_SIL=y
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_PATA_ACPI is not set
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> # CONFIG_ATA_GENERIC is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> # CONFIG_PATA_SCH is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_LINEAR=y
> CONFIG_MD_RAID0=y
> CONFIG_MD_RAID1=y
> CONFIG_MD_RAID10=y
> CONFIG_MD_RAID456=y
> CONFIG_MD_RAID5_RESHAPE=y
> # CONFIG_MD_MULTIPATH is not set
> # CONFIG_MD_FAULTY is not set
> # CONFIG_BLK_DEV_DM is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> 
> #
> # Enable only one of the two stacks, unless you know what you are doing
> #
> # CONFIG_FIREWIRE is not set
> CONFIG_IEEE1394=y
> CONFIG_IEEE1394_OHCI1394=y
> # CONFIG_IEEE1394_PCILYNX is not set
> CONFIG_IEEE1394_SBP2=y
> # CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
> # CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
> # CONFIG_IEEE1394_ETH1394 is not set
> CONFIG_IEEE1394_RAWIO=y
> CONFIG_IEEE1394_VIDEO1394=y
> CONFIG_IEEE1394_DV1394=y
> # CONFIG_IEEE1394_VERBOSEDEBUG is not set
> # CONFIG_I2O is not set
> CONFIG_MACINTOSH_DRIVERS=y
> # CONFIG_MAC_EMUMOUSEBTN is not set
> CONFIG_NETDEVICES=y
> # CONFIG_IFB is not set
> CONFIG_DUMMY=y
> # CONFIG_BONDING is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_TUN is not set
> # CONFIG_VETH is not set
> # CONFIG_NET_SB1000 is not set
> CONFIG_ARCNET=m
> CONFIG_ARCNET_1201=m
> CONFIG_ARCNET_1051=m
> CONFIG_ARCNET_RAW=m
> # CONFIG_ARCNET_CAP is not set
> CONFIG_ARCNET_COM90xx=m
> CONFIG_ARCNET_COM90xxIO=m
> CONFIG_ARCNET_RIM_I=m
> CONFIG_ARCNET_COM20020=m
> CONFIG_ARCNET_COM20020_PCI=m
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> CONFIG_MARVELL_PHY=y
> CONFIG_DAVICOM_PHY=y
> CONFIG_QSEMI_PHY=y
> CONFIG_LXT_PHY=y
> CONFIG_CICADA_PHY=y
> # CONFIG_VITESSE_PHY is not set
> # CONFIG_SMSC_PHY is not set
> # CONFIG_BROADCOM_PHY is not set
> # CONFIG_ICPLUS_PHY is not set
> # CONFIG_REALTEK_PHY is not set
> # CONFIG_FIXED_PHY is not set
> # CONFIG_MDIO_BITBANG is not set
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NET_VENDOR_3COM is not set
> CONFIG_NET_TULIP=y
> # CONFIG_DE2104X is not set
> CONFIG_TULIP=y
> # CONFIG_TULIP_MWI is not set
> # CONFIG_TULIP_MMIO is not set
> # CONFIG_TULIP_NAPI is not set
> # CONFIG_DE4X5 is not set
> # CONFIG_WINBOND_840 is not set
> # CONFIG_DM9102 is not set
> # CONFIG_ULI526X is not set
> # CONFIG_HP100 is not set
> # CONFIG_IBM_NEW_EMAC_ZMII is not set
> # CONFIG_IBM_NEW_EMAC_RGMII is not set
> # CONFIG_IBM_NEW_EMAC_TAH is not set
> # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
> CONFIG_NET_PCI=y
> # CONFIG_PCNET32 is not set
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_ADAPTEC_STARFIRE is not set
> # CONFIG_B44 is not set
> CONFIG_FORCEDETH=y
> CONFIG_FORCEDETH_NAPI=y
> # CONFIG_EEPRO100 is not set
> # CONFIG_E100 is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NATSEMI is not set
> # CONFIG_NE2K_PCI is not set
> # CONFIG_8139CP is not set
> # CONFIG_8139TOO is not set
> # CONFIG_R6040 is not set
> # CONFIG_SIS900 is not set
> # CONFIG_EPIC100 is not set
> # CONFIG_SUNDANCE is not set
> # CONFIG_TLAN is not set
> # CONFIG_VIA_RHINE is not set
> # CONFIG_SC92031 is not set
> CONFIG_NETDEV_1000=y
> # CONFIG_ACENIC is not set
> # CONFIG_DL2K is not set
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_IP1000 is not set
> # CONFIG_IGB is not set
> # CONFIG_NS83820 is not set
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> # CONFIG_R8169 is not set
> # CONFIG_SIS190 is not set
> CONFIG_SKGE=y
> # CONFIG_SKY2 is not set
> # CONFIG_VIA_VELOCITY is not set
> # CONFIG_TIGON3 is not set
> # CONFIG_BNX2 is not set
> # CONFIG_QLA3XXX is not set
> # CONFIG_ATL1 is not set
> # CONFIG_ATL1E is not set
> # CONFIG_NETDEV_10000 is not set
> # CONFIG_TR is not set
> 
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> CONFIG_WLAN_80211=y
> CONFIG_IPW2100=y
> # CONFIG_IPW2100_MONITOR is not set
> # CONFIG_IPW2100_DEBUG is not set
> CONFIG_IPW2200=y
> # CONFIG_IPW2200_MONITOR is not set
> # CONFIG_IPW2200_QOS is not set
> # CONFIG_IPW2200_DEBUG is not set
> CONFIG_LIBERTAS=y
> CONFIG_LIBERTAS_USB=y
> # CONFIG_LIBERTAS_DEBUG is not set
> CONFIG_AIRO=y
> CONFIG_HERMES=y
> CONFIG_PLX_HERMES=y
> CONFIG_TMD_HERMES=y
> CONFIG_NORTEL_HERMES=y
> CONFIG_PCI_HERMES=y
> CONFIG_ATMEL=y
> CONFIG_PCI_ATMEL=y
> CONFIG_PRISM54=y
> CONFIG_USB_ZD1201=y
> CONFIG_USB_NET_RNDIS_WLAN=y
> CONFIG_RTL8180=y
> CONFIG_RTL8187=y
> CONFIG_ADM8211=y
> # CONFIG_MAC80211_HWSIM is not set
> CONFIG_P54_COMMON=y
> CONFIG_P54_USB=y
> # CONFIG_P54_PCI is not set
> CONFIG_ATH5K=y
> # CONFIG_ATH5K_DEBUG is not set
> # CONFIG_ATH9K is not set
> CONFIG_IWLWIFI=y
> CONFIG_IWLCORE=y
> # CONFIG_IWLWIFI_LEDS is not set
> CONFIG_IWLWIFI_RFKILL=y
> # CONFIG_IWLWIFI_DEBUG is not set
> # CONFIG_IWLAGN is not set
> CONFIG_IWL3945=y
> # CONFIG_IWL3945_RFKILL is not set
> # CONFIG_IWL3945_SPECTRUM_MEASUREMENT is not set
> # CONFIG_IWL3945_LEDS is not set
> # CONFIG_IWL3945_DEBUG is not set
> CONFIG_HOSTAP=y
> CONFIG_HOSTAP_FIRMWARE=y
> CONFIG_HOSTAP_FIRMWARE_NVRAM=y
> CONFIG_HOSTAP_PLX=y
> CONFIG_HOSTAP_PCI=y
> CONFIG_B43=y
> CONFIG_B43_PCI_AUTOSELECT=y
> CONFIG_B43_PCICORE_AUTOSELECT=y
> CONFIG_B43_LEDS=y
> # CONFIG_B43_DEBUG is not set
> CONFIG_B43LEGACY=y
> CONFIG_B43LEGACY_PCI_AUTOSELECT=y
> CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
> CONFIG_B43LEGACY_LEDS=y
> CONFIG_B43LEGACY_DEBUG=y
> CONFIG_B43LEGACY_DMA=y
> CONFIG_B43LEGACY_PIO=y
> CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
> # CONFIG_B43LEGACY_DMA_MODE is not set
> # CONFIG_B43LEGACY_PIO_MODE is not set
> CONFIG_ZD1211RW=y
> # CONFIG_ZD1211RW_DEBUG is not set
> CONFIG_RT2X00=y
> CONFIG_RT2X00_LIB=y
> CONFIG_RT2X00_LIB_USB=y
> # CONFIG_RT2400PCI is not set
> # CONFIG_RT2500PCI is not set
> # CONFIG_RT61PCI is not set
> CONFIG_RT2500USB=y
> # CONFIG_RT2500USB_LEDS is not set
> # CONFIG_RT73USB is not set
> CONFIG_RT2X00_DEBUG=y
> 
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> CONFIG_USB_USBNET=y
> CONFIG_USB_NET_AX8817X=y
> CONFIG_USB_NET_CDCETHER=y
> # CONFIG_USB_NET_DM9601 is not set
> # CONFIG_USB_NET_GL620A is not set
> CONFIG_USB_NET_NET1080=y
> # CONFIG_USB_NET_PLUSB is not set
> # CONFIG_USB_NET_MCS7830 is not set
> CONFIG_USB_NET_RNDIS_HOST=y
> CONFIG_USB_NET_CDC_SUBSET=y
> # CONFIG_USB_ALI_M5632 is not set
> # CONFIG_USB_AN2720 is not set
> CONFIG_USB_BELKIN=y
> CONFIG_USB_ARMLINUX=y
> # CONFIG_USB_EPSON2888 is not set
> # CONFIG_USB_KC2190 is not set
> CONFIG_USB_NET_ZAURUS=y
> # CONFIG_USB_HSO is not set
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> # CONFIG_NET_FC is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1600
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1200
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_EVDEV is not set
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_PCSPKR=y
> # CONFIG_INPUT_APANEL is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_UINPUT is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> # CONFIG_SERIO_SERPORT is not set
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> # CONFIG_DEVKMEM is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> CONFIG_SERIAL_8250_RSA=y
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_UNIX98_PTYS=y
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=y
> # CONFIG_HW_RANDOM_INTEL is not set
> CONFIG_HW_RANDOM_AMD=y
> CONFIG_NVRAM=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_HANGCHECK_TIMER=y
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_CHARDEV=y
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_ALGOBIT=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_PIIX4 is not set
> CONFIG_I2C_NFORCE2=m
> # CONFIG_I2C_NFORCE2_S4985 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_SIMTEC is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
> 
> #
> # Graphics adapter I2C/DDC channel drivers
> #
> # CONFIG_I2C_VOODOO3 is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_STUB is not set
> 
> #
> # Miscellaneous I2C Chip support
> #
> # CONFIG_DS1682 is not set
> # CONFIG_AT24 is not set
> CONFIG_SENSORS_EEPROM=m
> # CONFIG_SENSORS_PCF8574 is not set
> # CONFIG_PCF8575 is not set
> # CONFIG_SENSORS_PCA9539 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_SENSORS_MAX6875 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_I2C_DEBUG_CHIP is not set
> # CONFIG_SPI is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_BATTERY_DS2760 is not set
> CONFIG_HWMON=m
> CONFIG_HWMON_VID=m
> # CONFIG_SENSORS_ABITUGURU is not set
> # CONFIG_SENSORS_ABITUGURU3 is not set
> # CONFIG_SENSORS_AD7414 is not set
> # CONFIG_SENSORS_AD7418 is not set
> # CONFIG_SENSORS_ADM1021 is not set
> # CONFIG_SENSORS_ADM1025 is not set
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7473 is not set
> CONFIG_SENSORS_K8TEMP=m
> # CONFIG_SENSORS_ASB100 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_FSCHER is not set
> # CONFIG_SENSORS_FSCPOS is not set
> # CONFIG_SENSORS_FSCHMD is not set
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_CORETEMP is not set
> CONFIG_SENSORS_IT87=m
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM75 is not set
> # CONFIG_SENSORS_LM77 is not set
> # CONFIG_SENSORS_LM78 is not set
> # CONFIG_SENSORS_LM80 is not set
> # CONFIG_SENSORS_LM83 is not set
> # CONFIG_SENSORS_LM85 is not set
> # CONFIG_SENSORS_LM87 is not set
> # CONFIG_SENSORS_LM90 is not set
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> # CONFIG_SENSORS_MAX1619 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_DME1737 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47M192 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_ADS7828 is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> # CONFIG_SENSORS_W83781D is not set
> CONFIG_SENSORS_W83791D=m
> # CONFIG_SENSORS_W83792D is not set
> # CONFIG_SENSORS_W83793 is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_SENSORS_APPLESMC is not set
> # CONFIG_HWMON_DEBUG_CHIP is not set
> CONFIG_THERMAL=y
> CONFIG_WATCHDOG=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=m
> CONFIG_ACQUIRE_WDT=m
> CONFIG_ADVANTECH_WDT=m
> CONFIG_ALIM1535_WDT=m
> CONFIG_ALIM7101_WDT=m
> CONFIG_SC520_WDT=m
> CONFIG_EUROTECH_WDT=m
> CONFIG_IB700_WDT=m
> # CONFIG_IBMASR is not set
> CONFIG_WAFER_WDT=m
> # CONFIG_I6300ESB_WDT is not set
> # CONFIG_ITCO_WDT is not set
> # CONFIG_IT8712F_WDT is not set
> # CONFIG_HP_WATCHDOG is not set
> CONFIG_SC1200_WDT=m
> # CONFIG_PC87413_WDT is not set
> CONFIG_60XX_WDT=m
> # CONFIG_SBC8360_WDT is not set
> CONFIG_CPU5_WDT=m
> # CONFIG_SMSC37B787_WDT is not set
> CONFIG_W83627HF_WDT=m
> # CONFIG_W83697HF_WDT is not set
> CONFIG_W83877F_WDT=m
> # CONFIG_W83977F_WDT is not set
> CONFIG_MACHZ_WDT=m
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> 
> #
> # PCI-based Watchdog Cards
> #
> CONFIG_PCIPCWATCHDOG=m
> CONFIG_WDTPCI=m
> CONFIG_WDT_501_PCI=y
> 
> #
> # USB-based Watchdog Cards
> #
> CONFIG_USBPCWATCHDOG=m
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB_POSSIBLE=y
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> CONFIG_SSB_B43_PCI_BRIDGE=y
> # CONFIG_SSB_DEBUG is not set
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> 
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_CORE is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_MFD_TMIO is not set
> 
> #
> # Multimedia devices
> #
> 
> #
> # Multimedia core support
> #
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_DVB_CORE is not set
> # CONFIG_VIDEO_MEDIA is not set
> 
> #
> # Multimedia drivers
> #
> # CONFIG_DAB is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_AMD64=y
> # CONFIG_AGP_INTEL is not set
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_VIA is not set
> # CONFIG_DRM is not set
> CONFIG_VGASTATE=y
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> CONFIG_FB=y
> # CONFIG_FIRMWARE_EDID is not set
> CONFIG_FB_DDC=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> # CONFIG_FB_SYS_FOPS is not set
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> # CONFIG_FB_TILEBLITTING is not set
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> # CONFIG_FB_ARC is not set
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_EFI is not set
> # CONFIG_FB_N411 is not set
> # CONFIG_FB_HGA is not set
> # CONFIG_FB_S1D13XXX is not set
> CONFIG_FB_NVIDIA=y
> CONFIG_FB_NVIDIA_I2C=y
> # CONFIG_FB_NVIDIA_DEBUG is not set
> CONFIG_FB_NVIDIA_BACKLIGHT=y
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_INTEL is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_VIRTUAL is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> # CONFIG_LCD_ILI9320 is not set
> # CONFIG_LCD_PLATFORM is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_CORGI is not set
> # CONFIG_BACKLIGHT_PROGEAR is not set
> # CONFIG_BACKLIGHT_MBP_NVIDIA is not set
> 
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> CONFIG_VIDEO_SELECT=y
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> CONFIG_FONTS=y
> # CONFIG_FONT_8x8 is not set
> # CONFIG_FONT_8x16 is not set
> # CONFIG_FONT_6x11 is not set
> # CONFIG_FONT_7x14 is not set
> # CONFIG_FONT_PEARL_8x8 is not set
> # CONFIG_FONT_ACORN_8x8 is not set
> # CONFIG_FONT_MINI_4x6 is not set
> # CONFIG_FONT_SUN8x16 is not set
> # CONFIG_FONT_SUN12x22 is not set
> CONFIG_FONT_10x18=y
> CONFIG_LOGO=y
> CONFIG_LOGO_LINUX_MONO=y
> CONFIG_LOGO_LINUX_VGA16=y
> CONFIG_LOGO_LINUX_CLUT224=y
> CONFIG_SOUND=m
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_HWDEP=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_SEQUENCER=m
> CONFIG_SND_SEQ_DUMMY=m
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> CONFIG_SND_PCM_OSS=m
> CONFIG_SND_PCM_OSS_PLUGINS=y
> CONFIG_SND_SEQUENCER_OSS=y
> # CONFIG_SND_DYNAMIC_MINORS is not set
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
> CONFIG_SND_AC97_CODEC=m
> CONFIG_SND_DRIVERS=y
> # CONFIG_SND_PCSP is not set
> CONFIG_SND_DUMMY=m
> CONFIG_SND_VIRMIDI=m
> # CONFIG_SND_MTPAV is not set
> # CONFIG_SND_SERIAL_U16550 is not set
> # CONFIG_SND_MPU401 is not set
> # CONFIG_SND_AC97_POWER_SAVE is not set
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> CONFIG_SND_EMU10K1=m
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> # CONFIG_SND_HDA_INTEL is not set
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_HIFIER is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> CONFIG_SND_INTEL8X0=m
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> CONFIG_SND_USB=y
> # CONFIG_SND_USB_AUDIO is not set
> # CONFIG_SND_USB_USX2Y is not set
> # CONFIG_SND_USB_CAIAQ is not set
> # CONFIG_SND_SOC is not set
> # CONFIG_SOUND_PRIME is not set
> CONFIG_AC97_BUS=m
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> # CONFIG_HID_DEBUG is not set
> # CONFIG_HIDRAW is not set
> 
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=m
> # CONFIG_USB_HIDINPUT_POWERBOOK is not set
> # CONFIG_HID_FF is not set
> # CONFIG_USB_HIDDEV is not set
> 
> #
> # USB HID Boot Protocol drivers
> #
> CONFIG_USB_KBD=m
> CONFIG_USB_MOUSE=m
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> # CONFIG_USB_DEVICE_CLASS is not set
> # CONFIG_USB_DYNAMIC_MINORS is not set
> # CONFIG_USB_SUSPEND is not set
> # CONFIG_USB_OTG is not set
> # CONFIG_USB_MON is not set
> 
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> CONFIG_USB_OHCI_HCD=y
> # CONFIG_USB_OHCI_HCD_SSB is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> # CONFIG_USB_UHCI_HCD is not set
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> 
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> CONFIG_USB_PRINTER=y
> # CONFIG_USB_WDM is not set
> 
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
> 
> #
> # may also be needed; see USB_STORAGE Help for more information
> #
> # CONFIG_USB_STORAGE is not set
> # CONFIG_USB_LIBUSUAL is not set
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_BERRY_CHARGE is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_PHIDGET is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_PCA9532 is not set
> # CONFIG_LEDS_CLEVO_MAIL is not set
> # CONFIG_LEDS_PCA955X is not set
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> # CONFIG_LEDS_TRIGGER_TIMER is not set
> # CONFIG_LEDS_TRIGGER_IDE_DISK is not set
> # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> CONFIG_EDAC=y
> 
> #
> # Reporting subsystems
> #
> # CONFIG_EDAC_DEBUG is not set
> CONFIG_EDAC_MM_EDAC=y
> # CONFIG_EDAC_E752X is not set
> # CONFIG_EDAC_I82975X is not set
> # CONFIG_EDAC_I3000 is not set
> # CONFIG_EDAC_I5000 is not set
> # CONFIG_EDAC_I5100 is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> CONFIG_RTC_DEBUG=y
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> CONFIG_RTC_INTF_DEV_UIE_EMUL=y
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS1307=y
> CONFIG_RTC_DRV_DS1374=y
> CONFIG_RTC_DRV_DS1672=y
> CONFIG_RTC_DRV_MAX6900=y
> CONFIG_RTC_DRV_RS5C372=y
> CONFIG_RTC_DRV_ISL1208=y
> CONFIG_RTC_DRV_X1205=y
> CONFIG_RTC_DRV_PCF8563=y
> CONFIG_RTC_DRV_PCF8583=y
> CONFIG_RTC_DRV_M41T80=y
> CONFIG_RTC_DRV_M41T80_WDT=y
> # CONFIG_RTC_DRV_S35390A is not set
> # CONFIG_RTC_DRV_FM3130 is not set
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1511 is not set
> CONFIG_RTC_DRV_DS1553=y
> CONFIG_RTC_DRV_DS1742=y
> CONFIG_RTC_DRV_STK17TA8=y
> CONFIG_RTC_DRV_M48T86=y
> CONFIG_RTC_DRV_M48T59=y
> CONFIG_RTC_DRV_V3020=y
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> # CONFIG_UIO is not set
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> CONFIG_FIRMWARE_MEMMAP=y
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> CONFIG_DMIID=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> 
> #
> # File systems
> #
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> # CONFIG_EXT4DEV_FS is not set
> CONFIG_JBD=y
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> # CONFIG_REISERFS_FS_XATTR is not set
> # CONFIG_JFS_FS is not set
> CONFIG_FS_POSIX_ACL=y
> # CONFIG_XFS_FS is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_QUOTA is not set
> # CONFIG_AUTOFS_FS is not set
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=y
> # CONFIG_NTFS_DEBUG is not set
> # CONFIG_NTFS_RW is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> # CONFIG_CONFIGFS_FS is not set
> 
> #
> # Miscellaneous filesystems
> #
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_CRAMFS is not set
> # CONFIG_VXFS_FS is not set
> CONFIG_MINIX_FS=y
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> # CONFIG_NFS_FS is not set
> # CONFIG_NFSD is not set
> # CONFIG_SMB_FS is not set
> # CONFIG_CIFS is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="cp437"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> CONFIG_NLS_CODEPAGE_850=y
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_UTF8 is not set
> # CONFIG_DLM is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> # CONFIG_PRINTK_TIME is not set
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=2048
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> CONFIG_DETECT_SOFTLOCKUP=y
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_DEBUG_SLAB=y
> CONFIG_DEBUG_SLAB_LEAK=y
> CONFIG_DEBUG_PREEMPT=y
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_WRITECOUNT is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_SG is not set
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_SYSCTL_SYSCALL_CHECK=y
> CONFIG_HAVE_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> # CONFIG_FTRACE is not set
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_PREEMPT_TRACER is not set
> # CONFIG_SYSPROF_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_CONTEXT_SWITCH_TRACER is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_STRICT_DEVMEM is not set
> # CONFIG_X86_VERBOSE_BOOTUP is not set
> CONFIG_EARLY_PRINTK=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> # CONFIG_X86_PTDUMP is not set
> # CONFIG_DEBUG_RODATA is not set
> # CONFIG_DIRECT_GBPAGES is not set
> # CONFIG_DEBUG_NX_TEST is not set
> # CONFIG_IOMMU_DEBUG is not set
> # CONFIG_MMIOTRACE is not set
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> 
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> CONFIG_XOR_BLOCKS=y
> CONFIG_ASYNC_CORE=y
> CONFIG_ASYNC_MEMCPY=y
> CONFIG_ASYNC_XOR=y
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_MANAGER=y
> # CONFIG_CRYPTO_GF128MUL is not set
> # CONFIG_CRYPTO_NULL is not set
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_AUTHENC=y
> # CONFIG_CRYPTO_TEST is not set
> 
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_SEQIV is not set
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=y
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_XTS is not set
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_HMAC=y
> # CONFIG_CRYPTO_XCBC is not set
> 
> #
> # Digest
> #
> # CONFIG_CRYPTO_CRC32C is not set
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_RMD128 is not set
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> # CONFIG_CRYPTO_RMD320 is not set
> CONFIG_CRYPTO_SHA1=y
> # CONFIG_CRYPTO_SHA256 is not set
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> # CONFIG_CRYPTO_AES_X86_64 is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=y
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SALSA20_X86_64 is not set
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> # CONFIG_CRYPTO_TWOFISH_X86_64 is not set
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> # CONFIG_CRYPTO_LZO is not set
> CONFIG_CRYPTO_HW=y
> # CONFIG_CRYPTO_DEV_HIFN_795X is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_FIND_NEXT_BIT=y
> CONFIG_CRC_CCITT=y
> # CONFIG_CRC16 is not set
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_PLIST=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y


