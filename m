Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbZDHGsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbZDHGsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbZDHGsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:48:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41964 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZDHGsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:48:15 -0400
Date: Wed, 8 Apr 2009 08:47:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>, Arjan van de Ven <arjan@infradead.org>
Cc: Justin Madru <jdm64@gawab.com>, lkml <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc1: invalid opcode with call trace
Message-ID: <20090408064733.GA16984@elte.hu>
References: <49DC367A.90603@gawab.com> <20090408063240.GQ5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090408063240.GQ5178@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,FR_ALMOST_VIAG2 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 FR_ALMOST_VIAG2        RAW: Almost looks like viagra.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Apr 07 2009, Justin Madru wrote:
> > Hello,
> >
> > Testing 2.6.30-rc1,
> > While booting I get the following call trace about an invalid opcode.
> >
> > ACPI: SSDT 3f6d4134 00244 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
> > ACPI: SSDT 3f6d3ee9 001C6 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
> > ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> > processor ACPI_CPU:00: registered as cooling_device0
> > ACPI: Processor [CPU0] (supports 8 throttling states)
> > ACPI: SSDT 3f6d4378 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
> > ACPI: SSDT 3f6d40af 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
> > ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> > processor ACPI_CPU:01: registered as cooling_device1
> > ACPI: Processor [CPU1] (supports 8 throttling states)
> > input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
> > ACPI: Lid Switch [LID]
> > input: Power Button (CM) as  
> > /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
> > ACPI: Power Button (CM) [PBTN]
> > ACPI: AC Adapter [AC] (on-line)
> > input: Sleep Button (CM) as  
> > /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
> > ACPI: Sleep Button (CM) [SBTN]
> > ACPI: Battery Slot [BAT0] (battery present)
> > invalid opcode: 0000 [#1] PREEMPT SMP
> > last sysfs file: /sys/devices/virtual/vtconsole/vtcon0/uevent
> > Modules linked in: snd_pcm battery ac button processor intel_agp  
> > snd_page_alloc reiserfs crc32 sr_mod cdrom sg firewire_ohci  
> > firewire_core crc_itu_t ata_piix ehci_hcd uhci_hcd usbcore thermal fan
> >
> > Pid: 1760, comm: async/0 Not tainted (2.6.30-rc1-git #1) MM061            
> >                EIP: 0060:[<f80fb02c>] EFLAGS: 00010286 CPU: 1
> > EIP is at 0xf80fb02c
> > EAX: 00000000 EBX: 00000216 ECX: 00000000 EDX: 00000000
> > ESI: f68fb320 EDI: 00000001 EBP: f7117f88 ESP: f7117f88
> > DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process async/0 (pid: 1760, ti=f7117000 task=f6935390 task.ti=f7117000)
> > Stack:
> > f7117fd0 c015e612 f7117fa8 c0129cf9 f7073bb0 00000000 f693560c f6935390
> > 00000286 f7117fd0 00000000 f6935390 c012fb20 f704efbc c04f22dc 00000000
> > c015e540 00000000 f7117fe0 c015558c c0155550 00000000 00000000 c0103f5f
> > Call Trace:
> > [<c015e612>] ? async_thread+0xd2/0x240
> > [<c0129cf9>] ? schedule_tail+0xd9/0x110
> > [<c012fb20>] ? default_wake_function+0x0/0x10
> > [<c015e540>] ? async_thread+0x0/0x240
> > [<c015558c>] ? kthread+0x3c/0x70
> > [<c0155550>] ? kthread+0x0/0x70
> > [<c0103f5f>] ? kernel_thread_helper+0x7/0x18
> > Code: 00 00 89 5d f4 8d 9e 88 00 00 00 89 7d fc 89 4d e8 e8 fc ff ff ff  
> > 8b be 98 00 00 00 39 df 74 57 89 f8 e8 fc ff ff ff 89 d8 e8 fc <ff> ff  
> > ff 8b 4d e8 89 f2 8b 45 ec c7 04 24 01 00 00 00 e8 3d c9
> > EIP: [<f80fb02c>] 0xf80fb02c SS:ESP 0068:f7117f88
> > ---[ end trace fefef3dd1f6b4bcf ]---
> > sdhci: Secure Digital Host Controller Interface driver
> > sdhci: Copyright(c) Pierre Ossman
> 
> My x60 gets the exact same oops, 100% repeatable. I then added the 
> initcall_debug boot option to get a closer look at what was 
> crapping out, but then it works fine. So it smells like a race 
> somewhere. Didn't look further.

I too have an async hang/crash, on an old-style SCSI (aic7xxx) box - 
hang log attached below.

No other -tip testbox is showing async related crashes, so i think 
it's hardware (and driver) specific, not an async core problem.

( but then again, we never expected the async bootup code to be 
  problematic in the core, most of the complications were at the 
  driver level. )

Note that it's not a crash but a boot hang - so it might be two 
separate regressions.

( Full bootlog attached below as well - i'm sending the config as a 
  reply as this mail is close to lkml size limits already. )

	Ingo

[   30.471472] calling  ip_auto_config+0x0/0xc87 @ 1
[   30.476180] initcall ip_auto_config+0x0/0xc87 returned 0 after 25 usecs
[   30.482740] calling  initialize_hashrnd+0x0/0x16 @ 1
[   30.487690] initcall initialize_hashrnd+0x0/0x16 returned 0 after 11 usecs
[   30.494579] async_waiting @ 1
[   36.282035] CPA self-test:
[   36.284818]  4k 2046 large 219 gb 0 x 2265[c0000000-f73fd000] miss 0
[   36.324938]  4k 190462 large 35 gb 0 x 190497[c0000000-f73fd000] miss 0
[   36.357747]  4k 190462 large 35 gb 0 x 190497[c0000000-f73fd000] miss 0
[   36.364308] ok.
[  246.929049] INFO: task swapper:1 blocked for more than 120 seconds.
[  246.935271] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  246.943095] swapper       D fed30457     0     1      0
[  246.948292]  f6c81f60 00000046 f6c78000 fed30457 00000006 c0c69270 c0c69270 c0c69270
[  246.955984]  c0c63a00 f6c78000 f6c78288 c2065270 00000001 c0c69270 00000002 c01507b4
[  246.963698]  00000006 c0b1e170 c07ab1db fffbe336 00000000 c0150771 c0b2a5fc 00000286
[  246.971409] Call Trace:
[  246.973873]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  246.978891]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  246.984607]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  246.990586]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  246.995615]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  247.001939]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  247.007656]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  247.013288]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  247.018751]  [<c0413cd0>] wait_for_device_probe+0x6f/0x75
[  247.024120]  [<c01ab7b1>] ? sys_access+0x15/0x17
[  247.028714]  [<c0bf8c9f>] prepare_namespace+0x2d/0x138
[  247.033827]  [<c0bf8533>] kernel_init+0x140/0x14f
[  247.038504]  [<c0bf83f3>] ? kernel_init+0x0/0x14f
[  247.043185]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  247.048378] no locks held by swapper/1.
[  247.052232] INFO: task async/1:2842 blocked for more than 120 seconds.

-------------------------------->
[    0.000000] Linux version 2.6.29-tip-10645-g54ba01a-dirty (mingo@venus) (gcc version 4.2.2) #717 SMP Mon Apr 6 12:47:15 CEST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] DMI 2.3 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-F7FFF uncachable
[    0.000000]   F8000-FBFFF write-through
[    0.000000]   FC000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  modified: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  modified: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00373fe000 page 4k
[    0.000000] kernel direct mapping tables up to 373fe000 @ 10000-16000
[    0.000000] ACPI: RSDP 000f6c40 00014 (v00 IntelR)
[    0.000000] ACPI: RSDT 3fff3000 0002C (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 3fff3040 00074 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 3fff30c0 03B65 (v01 INTELR AWRDACPI 00001000 MSFT 0100000D)
[    0.000000] ACPI: FACS 3fff0000 00040
[    0.000000] ACPI: APIC 3fff6c40 0006C (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 139MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000]   node 0 low ram: 00000000 - 373fe000
[    0.000000]   node 0 bootmap 00011000 - 00017e80
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0001338108]    TEXT DATA BSS ==> [0000100000 - 0001338108]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #5 [0001339000 - 000133f0ae]              BRK ==> [0001339000 - 000133f0ae]
[    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000]   #7 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f4f90] f4f90
[    0.000000]   mpc: f1400-f1574
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0003fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000] free_area_init_node: node 0, pgdat c0b758b0, node_mem_map c1340340
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3931 pages, LIFO batch:0
[    0.000000]   Normal zone: 2821 pages used for memmap
[    0.000000]   Normal zone: 219385 pages, LIFO batch:31
[    0.000000]   HighMem zone: 455 pages used for memmap
[    0.000000]   HighMem zone: 35371 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 15 pages at c204c000, static data 38716 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258687
[    0.000000] Kernel command line: root=/dev/sda3 debug earlyprintk=serial,ttyS0,115200,keep initcall_debug apic=verbose ignore_loglevel selinux=0
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:1280
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2378.728 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000999] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000999] ... MAX_LOCK_DEPTH:          48
[    0.000999] ... MAX_LOCKDEP_KEYS:        8191
[    0.000999] ... CLASSHASH_SIZE:          4096
[    0.000999] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000999] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000999] ... CHAINHASH_SIZE:          8192
[    0.000999]  memory used by lock dependency info: 2847 kB
[    0.000999]  per task-struct memory footprint: 1152 bytes
[    0.000999] ------------------------
[    0.000999] | Locking API testsuite:
[    0.000999] ----------------------------------------------------------------------------
[    0.000999]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000999]   --------------------------------------------------------------------------
[    0.000999]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000999]   --------------------------------------------------------------------------
[    0.000999]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000999]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000999]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000999]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000999]   --------------------------------------------------------------------------
[    0.000999]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000999]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000999]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000999]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000999]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000999]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000999]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000999]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000999]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000999]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq read-recursion/123:  ok  |
[    0.000999]       soft-irq read-recursion/123:  ok  |
[    0.000999]       hard-irq read-recursion/132:  ok  |
[    0.000999]       soft-irq read-recursion/132:  ok  |
[    0.000999]       hard-irq read-recursion/213:  ok  |
[    0.000999]       soft-irq read-recursion/213:  ok  |
[    0.000999]       hard-irq read-recursion/231:  ok  |
[    0.000999]       soft-irq read-recursion/231:  ok  |
[    0.000999]       hard-irq read-recursion/312:  ok  |
[    0.000999]       soft-irq read-recursion/312:  ok  |
[    0.000999]       hard-irq read-recursion/321:  ok  |
[    0.000999]       soft-irq read-recursion/321:  ok  |
[    0.000999] -------------------------------------------------------
[    0.000999] Good, all 218 testcases passed! |
[    0.000999] ---------------------------------
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] allocated 5242240 bytes of page_cgroup
[    0.000999] please try cgroup_disable=memory option if you don't want
[    0.000999] Initializing HighMem for node 0 (000373fe:0003fff0)
[    0.000999] Memory: 1009376k/1048512k available (6844k kernel code, 38296k reserved, 4352k data, 456k init, 143304k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xffc58000 - 0xfffff000   (3740 kB)
[    0.000999]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000999]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.000999]       .init : 0xc0bf8000 - 0xc0c6a000   ( 456 kB)
[    0.000999]       .data : 0xc07af091 - 0xc0bef250   (4352 kB)
[    0.000999]       .text : 0xc0100000 - 0xc07af091   (6844 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=13, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.001088] Calibrating delay loop (skipped), value calculated using timer frequency.. 4757.45 BogoMIPS (lpj=2378728)
[    0.003107] Security Framework initialized
[    0.004202] Mount-cache hash table entries: 512
[    0.007460] Initializing cgroup subsys cpuacct
[    0.008026] Initializing cgroup subsys memory
[    0.009145] Initializing cgroup subsys devices
[    0.010013] Initializing cgroup subsys net_cls
[    0.011045] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.013007] CPU: L2 cache: 512K
[    0.014008] [ds] using Netburst configuration
[    0.015008] CPU: Physical Processor ID: 0
[    0.016007] CPU: Processor Core ID: 0
[    0.017058] Checking 'hlt' instruction... OK.
[    0.023307] ACPI: Core revision 20090320
[    0.056014] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.057008] ftrace: allocating 22138 entries in 44 pages
[    0.061178] enabled ExtINT on CPU#0
[    0.062170] ENABLING IO-APIC IRQs
[    0.062999] init IO_APIC IRQs
[    0.063999]  4-0 (apicid-pin) not connected
[    0.066015] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.067008] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.068006] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.069005] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.070005] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.071004] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.072004] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.073004] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.074004] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.075004] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.076004] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.077004] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.078004] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.079003] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.080003] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.080999]  4-16 4-17 4-18 4-19 4-20 4-21 4-22 4-23 (apicid-pin) not connected
[    0.087272] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.098216] CPU0: Intel(R) XEON(TM) CPU 2.40GHz stepping 04
[    0.100991] Using local APIC timer interrupts.
[    0.100994] calibrating APIC timer ...
[    0.102984] ... lapic delta = 619443
[    0.102984] ... PM-Timer delta = 357902
[    0.102984] ... PM-Timer result ok
[    0.102984] ..... delta 619443
[    0.102984] ..... mult: 26608918
[    0.102984] ..... calibration result: 99110
[    0.102984] ..... CPU clock speed is 2378.0675 MHz.
[    0.102984] ..... host bus clock speed is 99.0110 MHz.
[    0.103021] calling  migration_init+0x0/0x62 @ 1
[    0.104260] initcall migration_init+0x0/0x62 returned 1 after 0 usecs
[    0.104996] initcall migration_init+0x0/0x62 returned with error code 1 
[    0.105993] calling  spawn_ksoftirqd+0x0/0x5e @ 1
[    0.107117] initcall spawn_ksoftirqd+0x0/0x5e returned 0 after 0 usecs
[    0.107999] calling  init_call_single_data+0x0/0x62 @ 1
[    0.108997] initcall init_call_single_data+0x0/0x62 returned 0 after 0 usecs
[    0.109993] calling  spawn_softlockup_task+0x0/0x5f @ 1
[    0.111091] initcall spawn_softlockup_task+0x0/0x5f returned 0 after 0 usecs
[    0.111992] calling  relay_init+0x0/0x11 @ 1
[    0.113008] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.113992] calling  tracer_alloc_buffers+0x0/0x187 @ 1
[    0.115247] Testing tracer nop: PASSED
[    0.117023] initcall tracer_alloc_buffers+0x0/0x187 returned 0 after 1952 usecs
[    0.117991] calling  init_trace_printk+0x0/0xf @ 1
[    0.118993] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
[    0.119991] calling  perf_counter_init+0x0/0x27 @ 1
[    0.121015] initcall perf_counter_init+0x0/0x27 returned 0 after 0 usecs
[    0.122640] lockdep: fixing up alternatives.
[    0.123174] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] masked ExtINT on CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 4757.09 BogoMIPS (lpj=2378547)
[    0.000999] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.000999] CPU: L2 cache: 512K
[    0.000999] [ds] using Netburst configuration
[    0.000999] CPU: Physical Processor ID: 3
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.196297] CPU1: Intel(R) XEON(TM) CPU 2.40GHz stepping 04
[    0.198983] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.200638] lockdep: fixing up alternatives.
[    0.201029] Booting processor 2 APIC 0x2 ip 0x6000
[    0.000999] Initializing CPU#2
[    0.000999] masked ExtINT on CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 4757.14 BogoMIPS (lpj=2378570)
[    0.000999] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.000999] CPU: L2 cache: 512K
[    0.000999] [ds] using Netburst configuration
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.273984] CPU2: Intel(R) XEON(TM) CPU 2.40GHz stepping 04
[    0.276986] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.279711] lockdep: fixing up alternatives.
[    0.281006] Booting processor 3 APIC 0x3 ip 0x6000
[    0.000999] Initializing CPU#3
[    0.000999] masked ExtINT on CPU#3
[    0.000999] Calibrating delay using timer specific routine.. 4757.16 BogoMIPS (lpj=2378581)
[    0.000999] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.000999] CPU: L2 cache: 512K
[    0.000999] [ds] using Netburst configuration
[    0.000999] CPU: Physical Processor ID: 3
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.354457] CPU3: Intel(R) XEON(TM) CPU 2.40GHz stepping 04
[    0.357030] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.358173] Brought up 4 CPUs
[    0.359010] Total of 4 processors activated (19028.85 BogoMIPS).
[    0.360140] CPU0 attaching sched-domain:
[    0.361010]  domain 0: span 0-3 level CPU
[    0.363007]   groups: 0 (__cpu_power = 1024) 1 (__cpu_power = 1024) 2 (__cpu_power = 1024) 3 (__cpu_power = 1024)
[    0.368202] CPU1 attaching sched-domain:
[    0.369010]  domain 0: span 0-3 level CPU
[    0.371007]   groups: 1 (__cpu_power = 1024) 2 (__cpu_power = 1024) 3 (__cpu_power = 1024) 0 (__cpu_power = 1024)
[    0.376170] CPU2 attaching sched-domain:
[    0.377008]  domain 0: span 0-3 level CPU
[    0.379006]   groups: 2 (__cpu_power = 1024) 3 (__cpu_power = 1024) 0 (__cpu_power = 1024) 1 (__cpu_power = 1024)
[    0.384173] CPU3 attaching sched-domain:
[    0.385008]  domain 0: span 0-3 level CPU
[    0.387007]   groups: 3 (__cpu_power = 1024) 0 (__cpu_power = 1024) 1 (__cpu_power = 1024) 2 (__cpu_power = 1024)
[    0.394171] device: 'platform': device_add
[    0.395073] PM: Adding info for No Bus:platform
[    0.397055] bus: 'platform': registered
[    0.398027] Registering sysdev class 'cpu'
[    0.400695] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
[    0.401023] initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
[    0.402011] calling  net_ns_init+0x0/0xce @ 1
[    0.403008] net_namespace: 964 bytes
[    0.404153] initcall net_ns_init+0x0/0xce returned 0 after 976 usecs
[    0.405016] calling  cpufreq_tsc+0x0/0x25 @ 1
[    0.406012] initcall cpufreq_tsc+0x0/0x25 returned 0 after 0 usecs
[    0.407012] calling  reboot_init+0x0/0x11 @ 1
[    0.408018] initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.409014] calling  init_smp_flush+0x0/0x2f @ 1
[    0.410013] initcall init_smp_flush+0x0/0x2f returned 0 after 0 usecs
[    0.411012] calling  alloc_frozen_cpus+0x0/0xc @ 1
[    0.412011] initcall alloc_frozen_cpus+0x0/0xc returned 0 after 0 usecs
[    0.413013] calling  sysctl_init+0x0/0x29 @ 1
[    0.415197] initcall sysctl_init+0x0/0x29 returned 0 after 976 usecs
[    0.416010] calling  ksysfs_init+0x0/0x96 @ 1
[    0.417048] initcall ksysfs_init+0x0/0x96 returned 0 after 0 usecs
[    0.418010] calling  async_init+0x0/0x9c @ 1
[    0.419110] initcall async_init+0x0/0x9c returned 0 after 0 usecs
[    0.420012] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.421032] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    0.422011] calling  pm_init+0x0/0x2d @ 1
[    0.424061] initcall pm_init+0x0/0x2d returned 0 after 0 usecs
[    0.425011] calling  filelock_init+0x0/0x27 @ 1
[    0.426017] initcall filelock_init+0x0/0x27 returned 0 after 0 usecs
[    0.427010] calling  init_aout_binfmt+0x0/0xf @ 1
[    0.428039] initcall init_aout_binfmt+0x0/0xf returned 0 after 0 usecs
[    0.429010] calling  init_script_binfmt+0x0/0xf @ 1
[    0.430012] initcall init_script_binfmt+0x0/0xf returned 0 after 0 usecs
[    0.431010] calling  init_elf_binfmt+0x0/0xf @ 1
[    0.433010] initcall init_elf_binfmt+0x0/0xf returned 0 after 976 usecs
[    0.434011] calling  debugfs_init+0x0/0x4a @ 1
[    0.436027] initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
[    0.437011] calling  securityfs_init+0x0/0x41 @ 1
[    0.438023] initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
[    0.439011] calling  random32_init+0x0/0xa2 @ 1
[    0.440012] initcall random32_init+0x0/0xa2 returned 0 after 0 usecs
[    0.441013] calling  cpufreq_core_init+0x0/0x5f @ 1
[    0.442013] initcall cpufreq_core_init+0x0/0x5f returned 0 after 0 usecs
[    0.443010] calling  cpuidle_init+0x0/0x32 @ 1
[    0.444036] initcall cpuidle_init+0x0/0x32 returned 0 after 0 usecs
[    0.445013] calling  virtio_init+0x0/0x24 @ 1
[    0.446118] bus: 'virtio': registered
[    0.447015] initcall virtio_init+0x0/0x24 returned 0 after 976 usecs
[    0.448011] calling  sock_init+0x0/0x4c @ 1
[    0.450247] initcall sock_init+0x0/0x4c returned 0 after 976 usecs
[    0.451011] calling  net_inuse_init+0x0/0x1f @ 1
[    0.452038] initcall net_inuse_init+0x0/0x1f returned 0 after 0 usecs
[    0.453010] calling  netpoll_init+0x0/0x39 @ 1
[    0.454011] initcall netpoll_init+0x0/0x39 returned 0 after 0 usecs
[    0.455010] calling  netlink_proto_init+0x0/0x171 @ 1
[    0.456142] NET: Registered protocol family 16
[    0.457124] initcall netlink_proto_init+0x0/0x171 returned 0 after 976 usecs
[    0.458012] calling  olpc_init+0x0/0x103 @ 1
[    0.459011] initcall olpc_init+0x0/0x103 returned 0 after 0 usecs
[    0.460010] calling  bdi_class_init+0x0/0x35 @ 1
[    0.461010] device class 'bdi': registering
[    0.463222] initcall bdi_class_init+0x0/0x35 returned 0 after 1953 usecs
[    0.464014] calling  kobject_uevent_init+0x0/0x3f @ 1
[    0.465032] initcall kobject_uevent_init+0x0/0x3f returned 0 after 0 usecs
[    0.466010] calling  gpiolib_sysfs_init+0x0/0x74 @ 1
[    0.467008] device class 'gpio': registering
[    0.469083] initcall gpiolib_sysfs_init+0x0/0x74 returned 0 after 1953 usecs
[    0.470014] calling  pcibus_class_init+0x0/0x14 @ 1
[    0.471008] device class 'pci_bus': registering
[    0.472105] initcall pcibus_class_init+0x0/0x14 returned 0 after 976 usecs
[    0.473012] calling  pci_driver_init+0x0/0xf @ 1
[    0.475113] bus: 'pci': registered
[    0.476012] initcall pci_driver_init+0x0/0xf returned 0 after 1953 usecs
[    0.477010] calling  lcd_class_init+0x0/0x62 @ 1
[    0.478011] device class 'lcd': registering
[    0.479087] initcall lcd_class_init+0x0/0x62 returned 0 after 976 usecs
[    0.480012] calling  backlight_class_init+0x0/0x70 @ 1
[    0.481010] device class 'backlight': registering
[    0.482101] initcall backlight_class_init+0x0/0x70 returned 0 after 976 usecs
[    0.483012] calling  video_output_class_init+0x0/0x14 @ 1
[    0.484008] device class 'video_output': registering
[    0.485086] initcall video_output_class_init+0x0/0x14 returned 0 after 976 usecs
[    0.486014] calling  tty_class_init+0x0/0x40 @ 1
[    0.487010] device class 'tty': registering
[    0.488093] initcall tty_class_init+0x0/0x40 returned 0 after 976 usecs
[    0.489012] calling  vtconsole_class_init+0x0/0xf4 @ 1
[    0.490010] device class 'vtconsole': registering
[    0.491097] device: 'vtcon0': device_add
[    0.492088] PM: Adding info for No Bus:vtcon0
[    0.494024] initcall vtconsole_class_init+0x0/0xf4 returned 0 after 3906 usecs
[    0.495013] calling  spi_init+0x0/0xc3 @ 1
[    0.496120] bus: 'spi': registered
[    0.497009] device class 'spi_master': registering
[    0.498086] initcall spi_init+0x0/0xc3 returned 0 after 1953 usecs
[    0.499013] calling  i2c_init+0x0/0x54 @ 1
[    0.500114] bus: 'i2c': registered
[    0.501009] device class 'i2c-adapter': registering
[    0.502091] bus: 'i2c': add driver dummy
[    0.503144] i2c-core: driver [dummy] registered
[    0.504033] initcall i2c_init+0x0/0x54 returned 0 after 3906 usecs
[    0.505011] calling  amd_postcore_init+0x0/0x66 @ 1
[    0.506011] initcall amd_postcore_init+0x0/0x66 returned 0 after 0 usecs
[    0.507012] calling  arch_kdebugfs_init+0x0/0x2fc @ 1
[    0.508091] initcall arch_kdebugfs_init+0x0/0x2fc returned 0 after 0 usecs
[    0.509011] calling  init_pit_clocksource+0x0/0x88 @ 1
[    0.510011] initcall init_pit_clocksource+0x0/0x88 returned 0 after 0 usecs
[    0.511011] calling  mtrr_if_init+0x0/0x44 @ 1
[    0.512029] initcall mtrr_if_init+0x0/0x44 returned 0 after 0 usecs
[    0.513011] calling  kdump_buf_page_init+0x0/0x87 @ 1
[    0.514027] initcall kdump_buf_page_init+0x0/0x87 returned 0 after 0 usecs
[    0.515011] calling  acpi_pci_init+0x0/0x51 @ 1
[    0.516035] ACPI: bus type pci registered
[    0.517012] initcall acpi_pci_init+0x0/0x51 returned 0 after 976 usecs
[    0.518011] calling  dma_bus_init+0x0/0x32 @ 1
[    0.519009] device class 'dma': registering
[    0.520095] initcall dma_bus_init+0x0/0x32 returned 0 after 976 usecs
[    0.521014] calling  dma_channel_table_init+0x0/0xdf @ 1
[    0.522071] initcall dma_channel_table_init+0x0/0xdf returned 0 after 0 usecs
[    0.523011] calling  pci_arch_init+0x0/0x4e @ 1
[    0.528036] PCI: PCI BIOS revision 2.10 entry at 0xfb3b0, last bus=4
[    0.529008] PCI: Using configuration type 1 for base access
[    0.530026] initcall pci_arch_init+0x0/0x4e returned 0 after 5859 usecs
[    0.531010] calling  topology_init+0x0/0x36 @ 1
[    0.532009] Registering sys device of class 'cpu'
[    0.533021] Registering sys device 'cpu0'
[    0.534133] Registering sys device of class 'cpu'
[    0.535024] Registering sys device 'cpu1'
[    0.536075] Registering sys device of class 'cpu'
[    0.537021] Registering sys device 'cpu2'
[    0.538075] Registering sys device of class 'cpu'
[    0.539022] Registering sys device 'cpu3'
[    0.540082] initcall topology_init+0x0/0x36 returned 0 after 7812 usecs
[    0.541013] calling  mtrr_init_finialize+0x0/0x35 @ 1
[    0.542011] initcall mtrr_init_finialize+0x0/0x35 returned 0 after 0 usecs
[    0.543012] calling  mca_init+0x0/0x43a @ 1
[    0.544138] bus: 'MCA': registered
[    0.545014] initcall mca_init+0x0/0x43a returned -19 after 976 usecs
[    0.546012] calling  param_sysfs_init+0x0/0x216 @ 1
[    0.581628] initcall param_sysfs_init+0x0/0x216 returned 0 after 33203 usecs
[    0.582017] calling  pm_sysrq_init+0x0/0x1b @ 1
[    0.583053] initcall pm_sysrq_init+0x0/0x1b returned 0 after 0 usecs
[    0.584011] calling  default_bdi_init+0x0/0x2f @ 1
[    0.585038] device: 'default': device_add
[    0.586070] PM: Adding info for No Bus:default
[    0.587157] initcall default_bdi_init+0x0/0x2f returned 0 after 1953 usecs
[    0.588012] calling  init_bio+0x0/0xfd @ 1
[    0.589091] bio: create slab <bio-0> at 0
[    0.590092] initcall init_bio+0x0/0xfd returned 0 after 976 usecs
[    0.591011] calling  bio_integrity_init+0x0/0x9b @ 1
[    0.593566] initcall bio_integrity_init+0x0/0x9b returned 0 after 976 usecs
[    0.600039] calling  cryptomgr_init+0x0/0x29 @ 1
[    0.607490] initcall cryptomgr_init+0x0/0x29 returned 0 after 0 usecs
[    0.615166] calling  blk_settings_init+0x0/0x1d @ 1
[    0.620887] initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
[    0.627014] calling  blk_ioc_init+0x0/0x24 @ 1
[    0.632039] initcall blk_ioc_init+0x0/0x24 returned 0 after 0 usecs
[    0.638011] calling  blk_softirq_init+0x0/0x5b @ 1
[    0.643020] initcall blk_softirq_init+0x0/0x5b returned 0 after 0 usecs
[    0.649011] calling  genhd_device_init+0x0/0x69 @ 1
[    0.654009] device class 'block': registering
[    0.661260] initcall genhd_device_init+0x0/0x69 returned 0 after 6835 usecs
[    0.668341] calling  blk_dev_integrity_init+0x0/0x24 @ 1
[    0.673039] initcall blk_dev_integrity_init+0x0/0x24 returned 0 after 976 usecs
[    0.681014] calling  gpiolib_debugfs_init+0x0/0x1f @ 1
[    0.686118] initcall gpiolib_debugfs_init+0x0/0x1f returned 0 after 0 usecs
[    0.693012] calling  gpio_twl4030_init+0x0/0xf @ 1
[    0.698014] bus: 'platform': add driver twl4030_gpio
[    0.703151] initcall gpio_twl4030_init+0x0/0xf returned 0 after 4882 usecs
[    0.710018] calling  pci_slot_init+0x0/0x40 @ 1
[    0.714060] initcall pci_slot_init+0x0/0x40 returned 0 after 0 usecs
[    0.721011] calling  fbmem_init+0x0/0x96 @ 1
[    0.725098] device class 'graphics': registering
[    0.730014] initcall fbmem_init+0x0/0x96 returned 0 after 4882 usecs
[    0.736014] calling  acpi_init+0x0/0x25e @ 1
[    0.745274] ACPI: EC: Look up EC in DSDT
[    0.794013] ACPI: Interpreter enabled
[    0.797016] ACPI: (supports S0 S1 S3 S5)
[    0.801256] ACPI: Using IOAPIC for interrupt routing
[    0.806369] bus: 'acpi': registered
[    0.810145] device: 'LNXSYSTM:00': device_add
[    0.814049] bus: 'acpi': add device LNXSYSTM:00
[    0.819038] PM: Adding info for acpi:LNXSYSTM:00
[    0.823186] device: 'LNXPWRBN:00': device_add
[    0.828030] bus: 'acpi': add device LNXPWRBN:00
[    0.832035] PM: Adding info for acpi:LNXPWRBN:00
[    0.837237] device: 'ACPI_CPU:00': device_add
[    0.841036] bus: 'acpi': add device ACPI_CPU:00
[    0.846034] PM: Adding info for acpi:ACPI_CPU:00
[    0.851132] device: 'ACPI_CPU:01': device_add
[    0.855028] bus: 'acpi': add device ACPI_CPU:01
[    0.860034] PM: Adding info for acpi:ACPI_CPU:01
[    0.864231] device: 'ACPI_CPU:02': device_add
[    0.869028] bus: 'acpi': add device ACPI_CPU:02
[    0.873033] PM: Adding info for acpi:ACPI_CPU:02
[    0.878214] device: 'ACPI_CPU:03': device_add
[    0.882028] bus: 'acpi': add device ACPI_CPU:03
[    0.887036] PM: Adding info for acpi:ACPI_CPU:03
[    0.892082] device: 'device:00': device_add
[    0.896028] bus: 'acpi': add device device:00
[    0.900034] PM: Adding info for acpi:device:00
[    0.905032] device: 'device:00': dev_uevent: bus uevent() returned -12
[    0.912012] device: 'PNP0C0C:00': device_add
[    0.916028] bus: 'acpi': add device PNP0C0C:00
[    0.920036] PM: Adding info for acpi:PNP0C0C:00
[    0.925360] device: 'PNP0C01:00': device_add
[    0.929029] bus: 'acpi': add device PNP0C01:00
[    0.934036] PM: Adding info for acpi:PNP0C01:00
[    0.939014] device: 'INT0800:00': device_add
[    0.943028] bus: 'acpi': add device INT0800:00
[    0.947035] PM: Adding info for acpi:INT0800:00
[    0.953217] device: 'PNP0A03:00': device_add
[    0.957030] bus: 'acpi': add device PNP0A03:00
[    0.962035] PM: Adding info for acpi:PNP0A03:00
[    0.967232] device: 'device:01': device_add
[    0.971029] bus: 'acpi': add device device:01
[    0.975056] PM: Adding info for acpi:device:01
[    0.980033] device: 'device:01': dev_uevent: bus uevent() returned -12
[    0.987132] device: 'device:02': device_add
[    0.991028] bus: 'acpi': add device device:02
[    0.995036] PM: Adding info for acpi:device:02
[    1.000032] device: 'device:02': dev_uevent: bus uevent() returned -12
[    1.007012] device: 'device:03': device_add
[    1.011029] bus: 'acpi': add device device:03
[    1.015035] PM: Adding info for acpi:device:03
[    1.020031] device: 'device:03': dev_uevent: bus uevent() returned -12
[    1.026277] device: 'device:04': device_add
[    1.030027] bus: 'acpi': add device device:04
[    1.035035] PM: Adding info for acpi:device:04
[    1.039033] device: 'device:04': dev_uevent: bus uevent() returned -12
[    1.046537] device: 'device:05': device_add
[    1.050029] bus: 'acpi': add device device:05
[    1.055029] PM: Adding info for acpi:device:05
[    1.059032] device: 'device:05': dev_uevent: bus uevent() returned -12
[    1.066437] device: 'device:06': device_add
[    1.070029] bus: 'acpi': add device device:06
[    1.075035] PM: Adding info for acpi:device:06
[    1.079032] device: 'device:06': dev_uevent: bus uevent() returned -12
[    1.086197] device: 'device:07': device_add
[    1.090028] bus: 'acpi': add device device:07
[    1.094035] PM: Adding info for acpi:device:07
[    1.099032] device: 'device:07': dev_uevent: bus uevent() returned -12
[    1.105288] device: 'device:08': device_add
[    1.110026] bus: 'acpi': add device device:08
[    1.114036] PM: Adding info for acpi:device:08
[    1.118033] device: 'device:08': dev_uevent: bus uevent() returned -12
[    1.125247] device: 'device:09': device_add
[    1.129026] bus: 'acpi': add device device:09
[    1.134057] PM: Adding info for acpi:device:09
[    1.138043] device: 'device:09': dev_uevent: bus uevent() returned -12
[    1.145012] device: 'device:0a': device_add
[    1.149026] bus: 'acpi': add device device:0a
[    1.153036] PM: Adding info for acpi:device:0a
[    1.158033] device: 'device:0a': dev_uevent: bus uevent() returned -12
[    1.164248] device: 'device:0b': device_add
[    1.168026] bus: 'acpi': add device device:0b
[    1.173035] PM: Adding info for acpi:device:0b
[    1.177032] device: 'device:0b': dev_uevent: bus uevent() returned -12
[    1.184218] device: 'device:0c': device_add
[    1.188026] bus: 'acpi': add device device:0c
[    1.192036] PM: Adding info for acpi:device:0c
[    1.197032] device: 'device:0c': dev_uevent: bus uevent() returned -12
[    1.204012] device: 'device:0d': device_add
[    1.208028] bus: 'acpi': add device device:0d
[    1.212036] PM: Adding info for acpi:device:0d
[    1.216033] device: 'device:0d': dev_uevent: bus uevent() returned -12
[    1.223246] device: 'device:0e': device_add
[    1.227027] bus: 'acpi': add device device:0e
[    1.232036] PM: Adding info for acpi:device:0e
[    1.236032] device: 'device:0e': dev_uevent: bus uevent() returned -12
[    1.243290] device: 'device:0f': device_add
[    1.247029] bus: 'acpi': add device device:0f
[    1.251052] PM: Adding info for acpi:device:0f
[    1.256033] device: 'device:0f': dev_uevent: bus uevent() returned -12
[    1.263012] device: 'PNP0C02:00': device_add
[    1.267026] bus: 'acpi': add device PNP0C02:00
[    1.271035] PM: Adding info for acpi:PNP0C02:00
[    1.277015] device: 'PNP0C0F:00': device_add
[    1.281035] bus: 'acpi': add device PNP0C0F:00
[    1.285056] PM: Adding info for acpi:PNP0C0F:00
[    1.291089] device: 'PNP0C0F:01': device_add
[    1.295033] bus: 'acpi': add device PNP0C0F:01
[    1.299039] PM: Adding info for acpi:PNP0C0F:01
[    1.305206] device: 'PNP0C0F:02': device_add
[    1.309035] bus: 'acpi': add device PNP0C0F:02
[    1.314041] PM: Adding info for acpi:PNP0C0F:02
[    1.319251] device: 'PNP0C0F:03': device_add
[    1.323049] bus: 'acpi': add device PNP0C0F:03
[    1.328038] PM: Adding info for acpi:PNP0C0F:03
[    1.333306] device: 'PNP0C0F:04': device_add
[    1.337035] bus: 'acpi': add device PNP0C0F:04
[    1.342039] PM: Adding info for acpi:PNP0C0F:04
[    1.347358] device: 'PNP0C0F:05': device_add
[    1.351034] bus: 'acpi': add device PNP0C0F:05
[    1.356033] PM: Adding info for acpi:PNP0C0F:05
[    1.361411] device: 'PNP0C0F:06': device_add
[    1.365034] bus: 'acpi': add device PNP0C0F:06
[    1.370041] PM: Adding info for acpi:PNP0C0F:06
[    1.375454] device: 'PNP0C0F:07': device_add
[    1.381039] bus: 'acpi': add device PNP0C0F:07
[    1.385041] PM: Adding info for acpi:PNP0C0F:07
[    1.390185] device: 'PNP0C02:01': device_add
[    1.394031] bus: 'acpi': add device PNP0C02:01
[    1.399038] PM: Adding info for acpi:PNP0C02:01
[    1.403374] device: 'PNP0000:00': device_add
[    1.408031] bus: 'acpi': add device PNP0000:00
[    1.412041] PM: Adding info for acpi:PNP0000:00
[    1.417191] device: 'PNP0200:00': device_add
[    1.421031] bus: 'acpi': add device PNP0200:00
[    1.426038] PM: Adding info for acpi:PNP0200:00
[    1.430356] device: 'PNP0100:00': device_add
[    1.435030] bus: 'acpi': add device PNP0100:00
[    1.439038] PM: Adding info for acpi:PNP0100:00
[    1.444193] device: 'PNP0B00:00': device_add
[    1.448030] bus: 'acpi': add device PNP0B00:00
[    1.453056] PM: Adding info for acpi:PNP0B00:00
[    1.457355] device: 'PNP0800:00': device_add
[    1.462031] bus: 'acpi': add device PNP0800:00
[    1.466040] PM: Adding info for acpi:PNP0800:00
[    1.471195] device: 'PNP0C04:00': device_add
[    1.475031] bus: 'acpi': add device PNP0C04:00
[    1.480045] PM: Adding info for acpi:PNP0C04:00
[    1.486014] device: 'PNP0700:00': device_add
[    1.490037] bus: 'acpi': add device PNP0700:00
[    1.494043] PM: Adding info for acpi:PNP0700:00
[    1.500605] device: 'PNP0501:00': device_add
[    1.505037] bus: 'acpi': add device PNP0501:00
[    1.509059] PM: Adding info for acpi:PNP0501:00
[    1.515707] device: 'PNP0501:01': device_add
[    1.520038] bus: 'acpi': add device PNP0501:01
[    1.524042] PM: Adding info for acpi:PNP0501:01
[    1.531805] device: 'PNP0401:00': device_add
[    1.536040] bus: 'acpi': add device PNP0401:00
[    1.540062] PM: Adding info for acpi:PNP0401:00
[    1.546301] device: 'PNP0303:00': device_add
[    1.550037] bus: 'acpi': add device PNP0303:00
[    1.555046] PM: Adding info for acpi:PNP0303:00
[    1.560053] device: 'LNXTHERM:00': device_add
[    1.564033] bus: 'acpi': add device LNXTHERM:00
[    1.569041] PM: Adding info for acpi:LNXTHERM:00
[    1.574016] device: 'PNP0C0B:00': device_add
[    1.578031] bus: 'acpi': add device PNP0C0B:00
[    1.582056] PM: Adding info for acpi:PNP0C0B:00
[    1.587281] device: 'LNXTHERM:01': device_add
[    1.591032] bus: 'acpi': add device LNXTHERM:01
[    1.596040] PM: Adding info for acpi:LNXTHERM:01
[    1.601406] bus: 'acpi': add driver ec
[    1.605169] bus: 'acpi': add driver power
[    1.609489] initcall acpi_init+0x0/0x25e returned 0 after 848633 usecs
[    1.616015] calling  dock_init+0x0/0x7d @ 1
[    1.621104] ACPI: No dock devices found.
[    1.625016] initcall dock_init+0x0/0x7d returned 0 after 4882 usecs
[    1.631012] calling  acpi_pci_root_init+0x0/0x25 @ 1
[    1.636012] bus: 'acpi': add driver pci_root
[    1.640039] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    1.649010] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    1.656090] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.661102] device: 'pci0000:00': device_add
[    1.666012] PM: Adding info for No Bus:pci0000:00
[    1.670022] device: '0000:00': device_add
[    1.674057] PM: Adding info for No Bus:0000:00
[    1.679143] PCI: Scanning bus 0000:00
[    1.682078] pci 0000:00:00.0: found [8086:2531] class 000600 header type 00
[    1.689025] pci 0000:00:00.0: reg 10 32bit mmio: [0xd8000000-0xdbffffff]
[    1.696063] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x13d
[    1.703050] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    1.710041] pci 0000:00:01.0: found [8086:2532] class 000604 header type 01
[    1.717043] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x13d
[    1.723013] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    1.730036] pci 0000:00:02.0: found [8086:2533] class 000604 header type 01
[    1.737040] pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x13d
[    1.744013] pci 0000:00:02.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    1.751112] pci 0000:00:1e.0: found [8086:244e] class 000604 header type 01
[    1.758049] pci 0000:00:1e.0: calling quirk_resource_alignment+0x0/0x13d
[    1.764013] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    1.771041] pci 0000:00:1f.0: found [8086:2440] class 000601 header type 00
[    1.778093] pci 0000:00:1f.0: calling asus_hides_smbus_lpc+0x0/0xbf
[    1.785013] pci 0000:00:1f.0: calling quirk_ich4_lpc_acpi+0x0/0x6a
[    1.791017] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
[    1.798015] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH4 GPIO
[    1.805013] pci 0000:00:1f.0: calling quirk_resource_alignment+0x0/0x13d
[    1.812013] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    1.819043] pci 0000:00:1f.1: found [8086:244b] class 000101 header type 00
[    1.826065] pci 0000:00:1f.1: reg 20 io port: [0xf000-0xf00f]
[    1.832039] pci 0000:00:1f.1: calling quirk_resource_alignment+0x0/0x13d
[    1.838013] pci 0000:00:1f.1: calling pci_fixup_transparent_bridge+0x0/0x30
[    1.845042] pci 0000:00:1f.2: found [8086:2442] class 000c03 header type 00
[    1.852066] pci 0000:00:1f.2: reg 20 io port: [0xd000-0xd01f]
[    1.858038] pci 0000:00:1f.2: calling quirk_resource_alignment+0x0/0x13d
[    1.865018] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x30
[    1.871043] pci 0000:00:1f.3: found [8086:2443] class 000c05 header type 00
[    1.878066] pci 0000:00:1f.3: reg 20 io port: [0x500-0x50f]
[    1.884037] pci 0000:00:1f.3: calling quirk_resource_alignment+0x0/0x13d
[    1.891012] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x30
[    1.898042] pci 0000:00:1f.4: found [8086:2444] class 000c03 header type 00
[    1.905012] pci 0000:00:1f.4: reg 20 io port: [0xd800-0xd81f]
[    1.910038] pci 0000:00:1f.4: calling quirk_resource_alignment+0x0/0x13d
[    1.917013] pci 0000:00:1f.4: calling pci_fixup_transparent_bridge+0x0/0x30
[    1.924083] pci 0000:00:1f.5: found [8086:2445] class 000401 header type 00
[    1.931034] pci 0000:00:1f.5: reg 10 io port: [0xdc00-0xdcff]
[    1.937020] pci 0000:00:1f.5: reg 14 io port: [0xe000-0xe03f]
[    1.942065] pci 0000:00:1f.5: calling quirk_resource_alignment+0x0/0x13d
[    1.949013] pci 0000:00:1f.5: calling pci_fixup_transparent_bridge+0x0/0x30
[    1.956027] PCI: Fixups for bus 0000:00
[    1.960016] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 0
[    1.967022] PCI: Scanning bus 0000:01
[    1.970039] pci 0000:01:00.0: found [1002:5157] class 000300 header type 00
[    1.977037] pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x21
[    1.983024] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    1.990023] pci 0000:01:00.0: reg 14 io port: [0xa000-0xa0ff]
[    1.995019] pci 0000:01:00.0: reg 18 32bit mmio: [0xdd000000-0xdd00ffff]
[    2.002043] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.008019] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x13d
[    2.015048] pci 0000:01:00.0: supports D1 D2
[    2.019101] PCI: Fixups for bus 0000:01
[    2.023015] pci 0000:00:01.0: bridge io port: [0xa000-0xafff]
[    2.029014] pci 0000:00:01.0: bridge 32bit mmio: [0xdc000000-0xddffffff]
[    2.036014] pci 0000:00:01.0: bridge 32bit mmio pref: [0xd0000000-0xd7ffffff]
[    2.043015] PCI: Bus scan for 0000:01 returning with max=01
[    2.048016] pci 0000:00:02.0: scanning behind bridge, config 030200, pass 0
[    2.055022] PCI: Scanning bus 0000:02
[    2.059110] pci 0000:02:1f.0: found [8086:1360] class 000604 header type 01
[    2.066048] pci 0000:02:1f.0: calling quirk_resource_alignment+0x0/0x13d
[    2.072013] pci 0000:02:1f.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    2.079021] PCI: Fixups for bus 0000:02
[    2.083014] pci 0000:00:02.0: bridge io port: [0xb000-0xbfff]
[    2.089015] pci 0000:00:02.0: bridge 32bit mmio: [0xde000000-0xdfffffff]
[    2.096017] pci 0000:02:1f.0: scanning behind bridge, config 030302, pass 0
[    2.103022] PCI: Scanning bus 0000:03
[    2.106030] pci 0000:03:00.0: found [8086:1161] class 000800 header type 00
[    2.113029] pci 0000:03:00.0: reg 10 32bit mmio: [0xdf001000-0xdf001fff]
[    2.120073] pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x13d
[    2.126015] pci 0000:03:00.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    2.133075] pci 0000:03:04.0: found [9005:00cf] class 000100 header type 00
[    2.140043] pci 0000:03:04.0: reg 10 io port: [0xb000-0xb0ff]
[    2.146030] pci 0000:03:04.0: reg 14 64bit mmio: [0xdf000000-0xdf000fff]
[    2.153047] pci 0000:03:04.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.159019] pci 0000:03:04.0: calling quirk_resource_alignment+0x0/0x13d
[    2.166076] pci 0000:03:04.1: found [9005:00cf] class 000100 header type 00
[    2.173043] pci 0000:03:04.1: reg 10 io port: [0xb400-0xb4ff]
[    2.178030] pci 0000:03:04.1: reg 14 64bit mmio: [0xdf002000-0xdf002fff]
[    2.185047] pci 0000:03:04.1: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.191022] pci 0000:03:04.1: calling quirk_resource_alignment+0x0/0x13d
[    2.198136] PCI: Fixups for bus 0000:03
[    2.202015] pci 0000:02:1f.0: bridge io port: [0xb000-0xbfff]
[    2.208016] pci 0000:02:1f.0: bridge 32bit mmio: [0xde000000-0xdfffffff]
[    2.214016] PCI: Bus scan for 0000:03 returning with max=03
[    2.220018] pci 0000:02:1f.0: scanning behind bridge, config 030302, pass 1
[    2.227017] PCI: Bus scan for 0000:02 returning with max=03
[    2.232017] pci 0000:00:1e.0: scanning behind bridge, config 040400, pass 0
[    2.239023] PCI: Scanning bus 0000:04
[    2.243045] pci 0000:04:03.0: found [8086:1229] class 000200 header type 00
[    2.250044] pci 0000:04:03.0: reg 10 32bit mmio: [0xe1241000-0xe1241fff]
[    2.257020] pci 0000:04:03.0: reg 14 io port: [0xc000-0xc03f]
[    2.262021] pci 0000:04:03.0: reg 18 32bit mmio: [0xe1000000-0xe10fffff]
[    2.269046] pci 0000:04:03.0: reg 30 32bit mmio: [0x000000-0x0fffff]
[    2.275020] pci 0000:04:03.0: calling quirk_resource_alignment+0x0/0x13d
[    2.282013] pci 0000:04:03.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    2.289038] pci 0000:04:03.0: supports D1 D2
[    2.293011] pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.300015] pci 0000:04:03.0: PME# disabled
[    2.304047] pci 0000:04:04.0: found [8086:1229] class 000200 header type 00
[    2.311045] pci 0000:04:04.0: reg 10 32bit mmio: [0xe1240000-0xe1240fff]
[    2.318020] pci 0000:04:04.0: reg 14 io port: [0xc400-0xc43f]
[    2.323021] pci 0000:04:04.0: reg 18 32bit mmio: [0xe1100000-0xe11fffff]
[    2.330047] pci 0000:04:04.0: reg 30 32bit mmio: [0x000000-0x0fffff]
[    2.336020] pci 0000:04:04.0: calling quirk_resource_alignment+0x0/0x13d
[    2.343013] pci 0000:04:04.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    2.350038] pci 0000:04:04.0: supports D1 D2
[    2.354011] pci 0000:04:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.361015] pci 0000:04:04.0: PME# disabled
[    2.365062] pci 0000:04:07.0: found [8086:100c] class 000200 header type 00
[    2.372060] pci 0000:04:07.0: reg 10 32bit mmio: [0xe1200000-0xe121ffff]
[    2.379020] pci 0000:04:07.0: reg 14 32bit mmio: [0xe1220000-0xe123ffff]
[    2.385021] pci 0000:04:07.0: reg 18 io port: [0xc800-0xc81f]
[    2.391049] pci 0000:04:07.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.398020] pci 0000:04:07.0: calling quirk_resource_alignment+0x0/0x13d
[    2.405013] pci 0000:04:07.0: calling pci_fixup_transparent_bridge+0x0/0x30
[    2.412053] pci 0000:04:07.0: PME# supported from D0 D3hot D3cold
[    2.418015] pci 0000:04:07.0: PME# disabled
[    2.422097] PCI: Fixups for bus 0000:04
[    2.426010] pci 0000:00:1e.0: transparent bridge
[    2.431016] pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
[    2.436017] pci 0000:00:1e.0: bridge 32bit mmio: [0xe0000000-0xe1ffffff]
[    2.443016] PCI: Bus scan for 0000:04 returning with max=04
[    2.449018] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 1
[    2.456018] pci 0000:00:02.0: scanning behind bridge, config 030200, pass 1
[    2.463025] pci 0000:00:1e.0: scanning behind bridge, config 040400, pass 1
[    2.469018] PCI: Bus scan for 0000:00 returning with max=04
[    2.475011] pci_bus 0000:00: on NUMA node 0
[    2.479051] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.486715] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    2.494786] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUBA.HUBB._PRT]
[    2.503015] device: '0000:00:00.0': device_add
[    2.517014] bus: 'pci': add device 0000:00:00.0
[    2.521115] PM: Adding info for pci:0000:00:00.0
[    2.526134] device: '0000:00:01.0': device_add
[    2.540249] bus: 'pci': add device 0000:00:01.0
[    2.545013] PM: Adding info for pci:0000:00:01.0
[    2.549109] device: '0000:00:02.0': device_add
[    2.563446] bus: 'pci': add device 0000:00:02.0
[    2.568094] PM: Adding info for pci:0000:00:02.0
[    2.572126] device: '0000:00:1e.0': device_add
[    2.586569] bus: 'pci': add device 0000:00:1e.0
[    2.591096] PM: Adding info for pci:0000:00:1e.0
[    2.595115] device: '0000:00:1f.0': device_add
[    2.609596] bus: 'pci': add device 0000:00:1f.0
[    2.614094] PM: Adding info for pci:0000:00:1f.0
[    2.618110] device: '0000:00:1f.1': device_add
[    2.632680] bus: 'pci': add device 0000:00:1f.1
[    2.637112] PM: Adding info for pci:0000:00:1f.1
[    2.642123] device: '0000:00:1f.2': device_add
[    2.655762] bus: 'pci': add device 0000:00:1f.2
[    2.660097] PM: Adding info for pci:0000:00:1f.2
[    2.665115] device: '0000:00:1f.3': device_add
[    2.678771] bus: 'pci': add device 0000:00:1f.3
[    2.683114] PM: Adding info for pci:0000:00:1f.3
[    2.688116] device: '0000:00:1f.4': device_add
[    2.701801] bus: 'pci': add device 0000:00:1f.4
[    2.706102] PM: Adding info for pci:0000:00:1f.4
[    2.711089] device: '0000:00:1f.5': device_add
[    2.724763] bus: 'pci': add device 0000:00:1f.5
[    2.729114] PM: Adding info for pci:0000:00:1f.5
[    2.734128] device: '0000:01:00.0': device_add
[    2.738036] bus: 'pci': add device 0000:01:00.0
[    2.743070] PM: Adding info for pci:0000:01:00.0
[    2.747123] device: '0000:01': device_add
[    2.751063] PM: Adding info for No Bus:0000:01
[    2.756112] device: '0000:02:1f.0': device_add
[    2.761015] bus: 'pci': add device 0000:02:1f.0
[    2.765113] PM: Adding info for pci:0000:02:1f.0
[    2.770109] device: '0000:03:00.0': device_add
[    2.774042] bus: 'pci': add device 0000:03:00.0
[    2.779095] PM: Adding info for pci:0000:03:00.0
[    2.783104] device: '0000:03:04.0': device_add
[    2.788040] bus: 'pci': add device 0000:03:04.0
[    2.792109] PM: Adding info for pci:0000:03:04.0
[    2.797100] device: '0000:03:04.1': device_add
[    2.801044] bus: 'pci': add device 0000:03:04.1
[    2.806093] PM: Adding info for pci:0000:03:04.1
[    2.811077] device: '0000:03': device_add
[    2.815058] PM: Adding info for No Bus:0000:03
[    2.819134] device: '0000:02': device_add
[    2.823090] PM: Adding info for No Bus:0000:02
[    2.828093] device: '0000:04:03.0': device_add
[    2.832045] bus: 'pci': add device 0000:04:03.0
[    2.837095] PM: Adding info for pci:0000:04:03.0
[    2.841101] device: '0000:04:04.0': device_add
[    2.846039] bus: 'pci': add device 0000:04:04.0
[    2.850113] PM: Adding info for pci:0000:04:04.0
[    2.855103] device: '0000:04:07.0': device_add
[    2.860014] bus: 'pci': add device 0000:04:07.0
[    2.864096] PM: Adding info for pci:0000:04:07.0
[    2.869089] device: '0000:04': device_add
[    2.873081] PM: Adding info for No Bus:0000:04
[    2.877110] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    2.884014] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    2.892144] initcall acpi_pci_root_init+0x0/0x25 returned 0 after 1226563 usecs
[    2.899015] calling  acpi_pci_link_init+0x0/0x3f @ 1
[    2.904015] bus: 'acpi': add driver pci_link
[    2.908054] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    2.917014] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    2.925425] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    2.932720] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    2.939014] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    2.947017] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    2.955011] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    2.963433] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    2.971013] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    2.977014] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    2.985017] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    2.993011] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    3.002015] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    3.009212] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    3.016014] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    3.023017] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    3.032011] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    3.040184] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
[    3.047461] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    3.054014] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    3.061017] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    3.070011] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    3.078435] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    3.087015] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    3.093014] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    3.101018] bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
[    3.109011] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
[    3.118015] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    3.126201] driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
[    3.133014] bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
[    3.140018] bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
[    3.149011] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
[    3.157187] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    3.164447] driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
[    3.171014] bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
[    3.178017] bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
[    3.187011] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
[    3.195409] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    3.202450] driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
[    3.209014] bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
[    3.217116] initcall acpi_pci_link_init+0x0/0x3f returned 0 after 305664 usecs
[    3.224019] calling  pnp_init+0x0/0xf @ 1
[    3.228156] bus: 'pnp': registered
[    3.232015] initcall pnp_init+0x0/0xf returned 0 after 3906 usecs
[    3.238013] calling  misc_init+0x0/0x9c @ 1
[    3.242034] device class 'misc': registering
[    3.246134] initcall misc_init+0x0/0x9c returned 0 after 3906 usecs
[    3.252016] calling  tifm_init+0x0/0x75 @ 1
[    3.257119] bus: 'tifm': registered
[    3.260168] device class 'tifm_adapter': registering
[    3.265103] initcall tifm_init+0x0/0x75 returned 0 after 7812 usecs
[    3.272015] calling  twl4030_init+0x0/0x11 @ 1
[    3.276014] bus: 'i2c': add driver twl4030
[    3.280108] i2c-core: driver [twl4030] registered
[    3.285018] initcall twl4030_init+0x0/0x11 returned 0 after 8789 usecs
[    3.291013] calling  init_scsi+0x0/0x89 @ 1
[    3.296395] device class 'scsi_host': registering
[    3.301291] bus: 'scsi': registered
[    3.304013] device class 'scsi_device': registering
[    3.309261] SCSI subsystem initialized
[    3.313019] initcall init_scsi+0x0/0x89 returned 0 after 16601 usecs
[    3.321014] calling  ata_init+0x0/0x2a9 @ 1
[    3.325081] libata version 3.00 loaded.
[    3.329017] initcall ata_init+0x0/0x2a9 returned 0 after 3906 usecs
[    3.335212] calling  phy_init+0x0/0x29 @ 1
[    3.340136] device class 'mdio_bus': registering
[    3.345099] bus: 'mdio_bus': registered
[    3.349020] bus: 'mdio_bus': add driver Generic PHY
[    3.353139] initcall phy_init+0x0/0x29 returned 0 after 12695 usecs
[    3.360016] calling  init_pcmcia_cs+0x0/0x28 @ 1
[    3.364012] device class 'pcmcia_socket': registering
[    3.369097] initcall init_pcmcia_cs+0x0/0x28 returned 0 after 4882 usecs
[    3.376015] calling  nop_usb_xceiv_init+0x0/0xf @ 1
[    3.381014] bus: 'platform': add driver nop_usb_xceiv
[    3.386111] initcall nop_usb_xceiv_init+0x0/0xf returned 0 after 4882 usecs
[    3.393015] calling  usb_init+0x0/0x128 @ 1
[    3.397155] bus: 'usb': registered
[    3.401017] device class 'usb_host': registering
[    3.406002] bus: 'usb': add driver usbfs
[    3.410009] usbcore: registered new interface driver usbfs
[    3.415028] device class 'usb_device': registering
[    3.420091] bus: 'usb': add driver hub
[    3.424121] usbcore: registered new interface driver hub
[    3.429072] bus: 'usb': add driver usb
[    3.433105] usbcore: registered new device driver usb
[    3.438026] initcall usb_init+0x0/0x128 returned 0 after 40039 usecs
[    3.444014] calling  serio_init+0x0/0x9d @ 1
[    3.448147] bus: 'serio': registered
[    3.452068] initcall serio_init+0x0/0x9d returned 0 after 3906 usecs
[    3.459014] calling  gameport_init+0x0/0x9d @ 1
[    3.463147] bus: 'gameport': registered
[    3.467066] initcall gameport_init+0x0/0x9d returned 0 after 3906 usecs
[    3.474014] calling  input_init+0x0/0xdb @ 1
[    3.478011] device class 'input': registering
[    3.482210] initcall input_init+0x0/0xdb returned 0 after 3906 usecs
[    3.489013] calling  mmc_init+0x0/0x6e @ 1
[    3.493154] bus: 'mmc': registered
[    3.496013] device class 'mmc_host': registering
[    3.501259] bus: 'sdio': registered
[    3.505018] initcall mmc_init+0x0/0x6e returned 0 after 11718 usecs
[    3.511013] calling  acpi_wmi_init+0x0/0x4f @ 1
[    3.515015] bus: 'acpi': add driver wmi
[    3.519160] ACPI: WMI: Mapper loaded
[    3.523016] initcall acpi_wmi_init+0x0/0x4f returned 0 after 7812 usecs
[    3.529020] calling  pci_subsys_init+0x0/0xdf @ 1
[    3.534010] PCI: Using ACPI for IRQ routing
[    3.538371] initcall pci_subsys_init+0x0/0xdf returned 0 after 4882 usecs
[    3.545013] calling  proto_init+0x0/0xf @ 1
[    3.550033] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    3.556012] calling  net_dev_init+0x0/0x162 @ 1
[    3.560047] device class 'net': registering
[    3.564202] device: 'lo': device_add
[    3.568356] PM: Adding info for No Bus:lo
[    3.572421] initcall net_dev_init+0x0/0x162 returned 0 after 12695 usecs
[    3.579015] calling  neigh_init+0x0/0x66 @ 1
[    3.584014] initcall neigh_init+0x0/0x66 returned 0 after 0 usecs
[    3.590013] calling  pktsched_init+0x0/0xa9 @ 1
[    3.594049] initcall pktsched_init+0x0/0xa9 returned 0 after 0 usecs
[    3.600013] calling  tc_filter_init+0x0/0x43 @ 1
[    3.605013] initcall tc_filter_init+0x0/0x43 returned 0 after 0 usecs
[    3.611013] calling  tc_action_init+0x0/0x43 @ 1
[    3.616013] initcall tc_action_init+0x0/0x43 returned 0 after 0 usecs
[    3.622013] calling  genl_init+0x0/0xb0 @ 1
[    3.631106] initcall genl_init+0x0/0xb0 returned 0 after 3906 usecs
[    3.637016] calling  wanrouter_init+0x0/0x42 @ 1
[    3.642012] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    3.649043] initcall wanrouter_init+0x0/0x42 returned 0 after 6835 usecs
[    3.656013] calling  irda_init+0x0/0x88 @ 1
[    3.660106] NET: Registered protocol family 23
[    3.664195] initcall irda_init+0x0/0x88 returned 0 after 3906 usecs
[    3.671014] calling  atm_init+0x0/0x9c @ 1
[    3.675015] NET: Registered protocol family 8
[    3.679011] NET: Registered protocol family 20
[    3.683052] device class 'atm': registering
[    3.688106] initcall atm_init+0x0/0x9c returned 0 after 12695 usecs
[    3.694015] calling  wireless_nlevent_init+0x0/0x39 @ 1
[    3.699014] initcall wireless_nlevent_init+0x0/0x39 returned 0 after 0 usecs
[    3.706013] calling  sysctl_init+0x0/0x3b @ 1
[    3.710018] initcall sysctl_init+0x0/0x3b returned 0 after 0 usecs
[    3.717014] calling  pci_iommu_init+0x0/0x20 @ 1
[    3.776129] DMA-API: preallocated 32768 debug entries
[    3.781011] DMA-API: debugging enabled by kernel config
[    3.786024] initcall pci_iommu_init+0x0/0x20 returned 0 after 63476 usecs
[    3.793015] calling  print_all_ICs+0x0/0x425 @ 1
[    3.797011] 
[    3.797013] printing PIC contents
[    3.802013] ... PIC  IMR: ffff
[    3.803002] ... PIC  IRR: 1c21
[    3.808011] ... PIC  ISR: 0000
[    3.811012] ... PIC ELCR: 1e20
[    3.814009] 
[    3.814012] printing local APIC contents on CPU#0/0:
[    3.815002] ... APIC ID:      00000000 (0)
[    3.815002] ... APIC VERSION: 00050014
[    3.815002] ... APIC TASKPRI: 00000000 (00)
[    3.815002] ... APIC PROCPRI: 00000000
[    3.815002] ... APIC LDR: 01000000
[    3.815002] ... APIC DFR: ffffffff
[    3.815002] ... APIC SPIV: 000001ff
[    3.815002] ... APIC ISR field:
[    3.815002] 0123456789abcdef0123456789abcdef
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] ... APIC TMR field:
[    3.815002] 0123456789abcdef0123456789abcdef
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] ... APIC IRR field:
[    3.815002] 0123456789abcdef0123456789abcdef
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000010000000000000000
[    3.815002] ... APIC ESR: 00000000
[    3.815002] ... APIC ICR: 000008fd
[    3.815002] ... APIC ICR2: 02000000
[    3.815002] ... APIC LVTT: 000200ef
[    3.815002] ... APIC LVTPC: 00010000
[    3.815002] ... APIC LVT0: 00010700
[    3.815002] ... APIC LVT1: 00000400
[    3.815002] ... APIC LVTERR: 000000fe
[    3.815002] ... APIC TMICT: 00001832
[    3.815002] ... APIC TMCCT: 00000bc7
[    3.815002] ... APIC TDCR: 00000003
[    3.815002] 
[    3.814011] 
[    3.814013] printing local APIC contents on CPU#1/1:
[    3.815002] ... APIC ID:      01000000 (1)
[    3.815002] ... APIC VERSION: 00050014
[    3.815002] ... APIC TASKPRI: 00000000 (00)
[    3.815002] ... APIC PROCPRI: 00000000
[    3.815002] ... APIC LDR: 02000000
[    3.815002] ... APIC DFR: ffffffff
[    3.815002] ... APIC SPIV: 000001ff
[    3.815002] ... APIC ISR field:
[    3.815002] 0123456789abcdef0123456789abcdef
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] ... APIC TMR field:
[    3.815002] 0123456789abcdef0123456789abcdef
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 0000000000000000000000000000000<4>Clocksource tsc unstable (delta = 195924134 ns)
[    3.815002] 0
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] ... APIC IRR field:
[    3.815002] 0123456789abcdef0123456789abcdef
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000000000000000000000
[    3.815002] 00000000000000010000000000000000
[    3.815002] ... APIC ESR: 00000000
[    3.815002] ... APIC ICR: 000008fd
[    3.815002] ... APIC ICR2: 08000000
[    3.815002] ... APIC LVTT: 000200ef
[    3.815002] ... APIC LVTPC: 00010000
[    3.815002] ... APIC LVT0: 00010700
[    3.815002] ... APIC LVT1: 00010400
[    3.815002] ... APIC LVTERR: 000000fe
[    3.815002] ... APIC TMICT: 00001832
[    3.815002] ... APIC TMCCT: 00000ea0
[    3.815002] ... APIC TDCR: 00000003
[    3.815002] 
[    4.017901] 
[    4.017903] printing local APIC contents on CPU#2/2:
[    4.018002] ... APIC ID:      02000000 (2)
[    4.018002] ... APIC VERSION: 00050014
[    4.018002] ... APIC TASKPRI: 00000000 (00)
[    4.018002] ... APIC PROCPRI: 00000000
[    4.018002] ... APIC LDR: 04000000
[    4.018002] ... APIC DFR: ffffffff
[    4.018002] ... APIC SPIV: 000001ff
[    4.018002] ... APIC ISR field:
[    4.018002] 0123456789abcdef0123456789abcdef
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] ... APIC TMR field:
[    4.018002] 0123456789abcdef0123456789abcdef
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] ... APIC IRR field:
[    4.018002] 0123456789abcdef0123456789abcdef
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000000000000000000000
[    4.018002] 00000000000000010000000000000000
[    4.018002] ... APIC ESR: 00000000
[    4.018002] ... APIC ICR: 000008fb
[    4.018002] ... APIC ICR2: 02000000
[    4.018002] ... APIC LVTT: 000200ef
[    4.018002] ... APIC LVTPC: 00010000
[    4.018002] ... APIC LVT0: 00010700
[    4.018002] ... APIC LVT1: 00010400
[    4.018002] ... APIC LVTERR: 000000fe
[    4.018002] ... APIC TMICT: 00001832
[    4.018002] ... APIC TMCCT: 000008fd
[    4.018002] ... APIC TDCR: 00000003
[    4.018002] 
[    4.214008] 
[    4.214010] printing local APIC contents on CPU#3/3:
[    4.215003] ... APIC ID:      03000000 (3)
[    4.215003] ... APIC VERSION: 00050014
[    4.215003] ... APIC TASKPRI: 00000000 (00)
[    4.215003] ... APIC PROCPRI: 00000000
[    4.215003] ... APIC LDR: 08000000
[    4.215003] ... APIC DFR: ffffffff
[    4.215003] ... APIC SPIV: 000001ff
[    4.215003] ... APIC ISR field:
[    4.215003] 0123456789abcdef0123456789abcdef
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] ... APIC TMR field:
[    4.215003] 0123456789abcdef0123456789abcdef
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] ... APIC IRR field:
[    4.215003] 0123456789abcdef0123456789abcdef
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000000000000000000000
[    4.215003] 00000000000000010000000000000000
[    4.215003] ... APIC ESR: 00000000
[    4.215003] ... APIC ICR: 000008fd
[    4.215003] ... APIC ICR2: 02000000
[    4.215003] ... APIC LVTT: 000200ef
[    4.215003] ... APIC LVTPC: 00010000
[    4.215003] ... APIC LVT0: 00010700
[    4.215003] ... APIC LVT1: 00010400
[    4.215003] ... APIC LVTERR: 000000fe
[    4.215003] ... APIC TMICT: 00001832
[    4.215003] ... APIC TMCCT: 0000028d
[    4.215003] ... APIC TDCR: 00000003
[    4.215003] 
[    4.410349] number of MP IRQ sources: 15.
[    4.414012] number of IO-APIC #4 registers: 24.
[    4.419010] testing the IO APIC.......................
[    4.424017] 
[    4.425010] IO APIC #4......
[    4.428011] .... register #00: 04000000
[    4.432010] .......    : physical APIC id: 04
[    4.436010] .......    : Delivery Type: 0
[    4.440010] .......    : LTS          : 0
[    4.444010] .... register #01: 00178020
[    4.448011] .......     : max redirection entries: 0017
[    4.453010] .......     : PRQ implemented: 1
[    4.457011] .......     : IO APIC version: 0020
[    4.462011] .... register #02: 00000000
[    4.466011] .......     : arbitration: 00
[    4.470011] .... register #03: 00000001
[    4.474014] .......     : Boot DT    : 1
[    4.477010] .... IRQ redirection table:
[    4.481010]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    4.487014]  00 000 1    0    0   0   0    0    0    00
[    4.492014]  01 00F 0    0    0   0   0    1    1    31
[    4.497014]  02 00F 0    0    0   0   0    1    1    30
[    4.503013]  03 00F 0    0    0   0   0    1    1    33
[    4.508016]  04 00F 0    0    0   0   0    1    1    34
[    4.513014]  05 00F 0    0    0   0   0    1    1    35
[    4.518014]  06 00F 0    0    0   0   0    1    1    36
[    4.523014]  07 00F 0    0    0   0   0    1    1    37
[    4.529013]  08 00F 0    0    0   0   0    1    1    38
[    4.534014]  09 00F 0    1    0   0   0    1    1    39
[    4.539014]  0a 00F 0    0    0   0   0    1    1    3A
[    4.544014]  0b 00F 0    0    0   0   0    1    1    3B
[    4.549014]  0c 00F 0    0    0   0   0    1    1    3C
[    4.555013]  0d 00F 0    0    0   0   0    1    1    3D
[    4.560014]  0e 00F 0    0    0   0   0    1    1    3E
[    4.565014]  0f 00F 0    0    0   0   0    1    1    3F
[    4.570014]  10 000 1    0    0   0   0    0    0    00
[    4.575014]  11 000 1    0    0   0   0    0    0    00
[    4.581013]  12 000 1    0    0   0   0    0    0    00
[    4.586014]  13 000 1    0    0   0   0    0    0    00
[    4.591014]  14 000 1    0    0   0   0    0    0    00
[    4.596014]  15 000 1    0    0   0   0    0    0    00
[    4.601014]  16 000 1    0    0   0   0    0    0    00
[    4.607014]  17 000 1    0    0   0   0    0    0    00
[    4.612010] IRQ to pin mappings:
[    4.615011] IRQ0 -> 0:2
[    4.617520] IRQ1 -> 0:1
[    4.620011] IRQ3 -> 0:3
[    4.622522] IRQ4 -> 0:4
[    4.624692] IRQ5 -> 0:5
[    4.627173] IRQ6 -> 0:6
[    4.629695] IRQ7 -> 0:7
[    4.632173] IRQ8 -> 0:8
[    4.634520] IRQ9 -> 0:9
[    4.637011] IRQ10 -> 0:10
[    4.639608] IRQ11 -> 0:11
[    4.642173] IRQ12 -> 0:12
[    4.644779] IRQ13 -> 0:13
[    4.647174] IRQ14 -> 0:14
[    4.650011] IRQ15 -> 0:15
[    4.652608] .................................... done.
[    4.658018] initcall print_all_ICs+0x0/0x425 returned 0 after 840820 usecs
[    4.664015] calling  init_kmmio+0x0/0x23 @ 1
[    4.669040] initcall init_kmmio+0x0/0x23 returned 0 after 0 usecs
[    4.675015] calling  clocksource_done_booting+0x0/0x11 @ 1
[    4.681015] initcall clocksource_done_booting+0x0/0x11 returned 0 after 0 usecs
[    4.689014] calling  ftrace_init_debugfs+0x0/0x110 @ 1
[    4.694130] initcall ftrace_init_debugfs+0x0/0x110 returned 0 after 0 usecs
[    4.701014] calling  rb_init_debugfs+0x0/0x38 @ 1
[    4.705030] initcall rb_init_debugfs+0x0/0x38 returned 0 after 0 usecs
[    4.712014] calling  tracer_init_debugfs+0x0/0x377 @ 1
[    4.718184] initcall tracer_init_debugfs+0x0/0x377 returned 0 after 976 usecs
[    4.725015] calling  init_trace_printk_function_export+0x0/0x39 @ 1
[    4.731029] initcall init_trace_printk_function_export+0x0/0x39 returned 0 after 0 usecs
[    4.739014] calling  init_annotated_branch_stats+0x0/0x27 @ 1
[    4.745097] Warning: could not register annotated branches stats
[    4.751017] initcall init_annotated_branch_stats+0x0/0x27 returned 1 after 5859 usecs
[    4.759015] initcall init_annotated_branch_stats+0x0/0x27 returned with error code 1 
[    4.767015] calling  event_trace_init+0x0/0x356 @ 1
[    4.774225] initcall event_trace_init+0x0/0x356 returned 0 after 1953 usecs
[    4.781016] calling  init_pipe_fs+0x0/0x5a @ 1
[    4.785181] initcall init_pipe_fs+0x0/0x5a returned 0 after 0 usecs
[    4.792015] calling  init_mnt_writers+0x0/0x6a @ 1
[    4.796016] initcall init_mnt_writers+0x0/0x6a returned 0 after 0 usecs
[    4.803014] calling  eventpoll_init+0x0/0x84 @ 1
[    4.808066] initcall eventpoll_init+0x0/0x84 returned 0 after 0 usecs
[    4.814014] calling  anon_inode_init+0x0/0x121 @ 1
[    4.819141] initcall anon_inode_init+0x0/0x121 returned 0 after 0 usecs
[    4.825016] calling  acpi_event_init+0x0/0x46 @ 1
[    4.834070] initcall acpi_event_init+0x0/0x46 returned 0 after 3906 usecs
[    4.840022] calling  pnpacpi_init+0x0/0x7b @ 1
[    4.845011] pnp: PnP ACPI init
[    4.848046] device: 'pnp0': device_add
[    4.852039] PM: Adding info for No Bus:pnp0
[    4.856017] ACPI: bus type pnp registered
[    4.862212] pnp 00:00: mem resource (0xd5800-0xd7fff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.872015] pnp 00:00: mem resource (0xf0000-0xf7fff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.881014] pnp 00:00: mem resource (0xf8000-0xfbfff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.891014] pnp 00:00: mem resource (0xfc000-0xfffff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.900014] pnp 00:00: mem resource (0x0-0x9ffff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.910015] pnp 00:00: mem resource (0xe0000-0xeffff) overlaps 0000:04:03.0 BAR 6 (0x0-0xfffff), disabling
[    4.919028] pnp 00:00: mem resource (0xd5800-0xd7fff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.929014] pnp 00:00: mem resource (0xf0000-0xf7fff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.939015] pnp 00:00: mem resource (0xf8000-0xfbfff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.948014] pnp 00:00: mem resource (0xfc000-0xfffff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.958014] pnp 00:00: mem resource (0x0-0x9ffff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.967015] pnp 00:00: mem resource (0xe0000-0xeffff) overlaps 0000:04:04.0 BAR 6 (0x0-0xfffff), disabling
[    4.977034] device: '00:00': device_add
[    4.981067] bus: 'pnp': add device 00:00
[    4.985051] PM: Adding info for pnp:00:00
[    4.989347] device: '00:01': device_add
[    4.993075] bus: 'pnp': add device 00:01
[    4.997068] PM: Adding info for pnp:00:01
[    5.001817] device: '00:02': device_add
[    5.005129] bus: 'pnp': add device 00:02
[    5.009053] PM: Adding info for pnp:00:02
[    5.014687] device: '00:03': device_add
[    5.018093] bus: 'pnp': add device 00:03
[    5.022051] PM: Adding info for pnp:00:03
[    5.028884] device: '00:04': device_add
[    5.032113] bus: 'pnp': add device 00:04
[    5.036052] PM: Adding info for pnp:00:04
[    5.040303] device: '00:05': device_add
[    5.044115] bus: 'pnp': add device 00:05
[    5.048065] PM: Adding info for pnp:00:05
[    5.052252] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    5.060033] device: '00:06': device_add
[    5.064106] bus: 'pnp': add device 00:06
[    5.068052] PM: Adding info for pnp:00:06
[    5.072167] device: '00:07': device_add
[    5.076075] bus: 'pnp': add device 00:07
[    5.080051] PM: Adding info for pnp:00:07
[    5.084124] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    5.091041] device: '00:08': device_add
[    5.095121] bus: 'pnp': add device 00:08
[    5.099066] PM: Adding info for pnp:00:08
[    5.104894] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    5.112094] device: '00:09': device_add
[    5.116132] bus: 'pnp': add device 00:09
[    5.120068] PM: Adding info for pnp:00:09
[    5.126026] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    5.133123] device: '00:0a': device_add
[    5.137133] bus: 'pnp': add device 00:0a
[    5.141052] PM: Adding info for pnp:00:0a
[    5.147304] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    5.154126] device: '00:0b': device_add
[    5.158135] bus: 'pnp': add device 00:0b
[    5.162052] PM: Adding info for pnp:00:0b
[    5.170784] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    5.178138] device: '00:0c': device_add
[    5.182123] bus: 'pnp': add device 00:0c
[    5.186034] PM: Adding info for pnp:00:0c
[    5.190610] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    5.198031] device: '00:0d': device_add
[    5.201145] bus: 'pnp': add device 00:0d
[    5.205068] PM: Adding info for pnp:00:0d
[    5.210113] pnp: PnP ACPI: found 14 devices
[    5.214013] ACPI: ACPI bus type pnp unregistered
[    5.219020] initcall pnpacpi_init+0x0/0x7b returned 0 after 365234 usecs
[    5.225016] calling  pnp_system_init+0x0/0xf @ 1
[    5.230015] bus: 'pnp': add driver system
[    5.234035] bus: 'pnp': driver_probe_device: matched device 00:00 with driver system
[    5.242012] bus: 'pnp': really_probe: probing driver system with device 00:00
[    5.249046] system 00:00: iomem range 0x3fff0000-0x3fffffff could not be reserved
[    5.256023] system 00:00: iomem range 0x100000-0x3ffeffff could not be reserved
[    5.263018] system 00:00: iomem range 0xfec00000-0xfecfffff has been reserved
[    5.271017] system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
[    5.278017] system 00:00: iomem range 0xffb00000-0xffb7ffff has been reserved
[    5.285020] system 00:00: iomem range 0xfff00000-0xffffffff has been reserved
[    5.292013] driver: '00:00': driver_bound: bound to device 'system'
[    5.298013] bus: 'pnp': really_probe: bound device 00:00 to driver system
[    5.305022] bus: 'pnp': driver_probe_device: matched device 00:03 with driver system
[    5.313012] bus: 'pnp': really_probe: probing driver system with device 00:03
[    5.320036] system 00:03: ioport range 0x400-0x4bf could not be reserved
[    5.326013] driver: '00:03': driver_bound: bound to device 'system'
[    5.333013] bus: 'pnp': really_probe: bound device 00:03 to driver system
[    5.339018] bus: 'pnp': driver_probe_device: matched device 00:04 with driver system
[    5.347012] bus: 'pnp': really_probe: probing driver system with device 00:04
[    5.354034] system 00:04: ioport range 0xb78-0xb7b has been reserved
[    5.361017] system 00:04: ioport range 0xf78-0xf7b has been reserved
[    5.367017] system 00:04: ioport range 0xa78-0xa7b has been reserved
[    5.373018] system 00:04: ioport range 0xe78-0xe7b has been reserved
[    5.380017] system 00:04: ioport range 0xbbc-0xbbf has been reserved
[    5.386017] system 00:04: ioport range 0xfbc-0xfbf has been reserved
[    5.392017] system 00:04: ioport range 0x4d0-0x4d1 has been reserved
[    5.399021] system 00:04: ioport range 0x294-0x297 has been reserved
[    5.405013] driver: '00:04': driver_bound: bound to device 'system'
[    5.411013] bus: 'pnp': really_probe: bound device 00:04 to driver system
[    5.418121] initcall pnp_system_init+0x0/0xf returned 0 after 183593 usecs
[    5.425016] calling  chr_dev_init+0x0/0x8d @ 1
[    5.429052] device class 'mem': registering
[    5.433115] device: 'mem': device_add
[    5.437062] PM: Adding info for No Bus:mem
[    5.441194] device: 'kmem': device_add
[    5.445060] PM: Adding info for No Bus:kmem
[    5.449096] device: 'null': device_add
[    5.453058] PM: Adding info for No Bus:null
[    5.457094] device: 'port': device_add
[    5.461058] PM: Adding info for No Bus:port
[    5.465094] device: 'zero': device_add
[    5.469091] PM: Adding info for No Bus:zero
[    5.473095] device: 'full': device_add
[    5.477059] PM: Adding info for No Bus:full
[    5.481093] device: 'random': device_add
[    5.485059] PM: Adding info for No Bus:random
[    5.489096] device: 'urandom': device_add
[    5.493060] PM: Adding info for No Bus:urandom
[    5.498111] device: 'kmsg': device_add
[    5.502064] PM: Adding info for No Bus:kmsg
[    5.506096] device: 'oldmem': device_add
[    5.510043] PM: Adding info for No Bus:oldmem
[    5.514091] initcall chr_dev_init+0x0/0x8d returned 0 after 83007 usecs
[    5.521017] calling  firmware_class_init+0x0/0x61 @ 1
[    5.526013] device class 'firmware': registering
[    5.530110] initcall firmware_class_init+0x0/0x61 returned 0 after 3906 usecs
[    5.537023] calling  ieee1394_init+0x0/0x244 @ 1
[    5.542192] bus: 'ieee1394': registered
[    5.547027] device class 'ieee1394_host': registering
[    5.552095] device class 'ieee1394_protocol': registering
[    5.558195] device class 'ieee1394_node': registering
[    5.563099] device class 'ieee1394': registering
[    5.568094] bus: 'ieee1394': add driver nodemgr
[    5.572118] initcall ieee1394_init+0x0/0x244 returned 0 after 29296 usecs
[    5.579019] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    5.585049] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 0 usecs
[    5.592015] calling  cpufreq_gov_dbs_init+0x0/0x88 @ 1
[    5.598130] initcall cpufreq_gov_dbs_init+0x0/0x88 returned 0 after 976 usecs
[    5.605016] calling  init_acpi_pm_clocksource+0x0/0x193 @ 1
[    5.645512] initcall init_acpi_pm_clocksource+0x0/0x193 returned 0 after 33203 usecs
[    5.646077] Switched to NOHz mode on CPU #0
[    5.646197] Switched to NOHz mode on CPU #3
[    5.646240] Switched to NOHz mode on CPU #1
[    5.665925] Switched to NOHz mode on CPU #2
[    5.670088] calling  ssb_modinit+0x0/0x41 @ 1
[    5.674569] bus: 'ssb': registered
[    5.677981] initcall ssb_modinit+0x0/0x41 returned 0 after 3474 usecs
[    5.684376] calling  pcibios_assign_resources+0x0/0x76 @ 1
[    5.689994] pci 0000:01:00.0: BAR 6: got res [0xdc000000-0xdc01ffff] bus [0xdc000000-0xdc01ffff] flags 0x27200
[    5.700006] pci 0000:03:04.0: BAR 6: got res [0x50000000-0x5001ffff] bus [0x50000000-0x5001ffff] flags 0x27200
[    5.710002] pci 0000:03:04.1: BAR 6: got res [0x50020000-0x5003ffff] bus [0x50020000-0x5003ffff] flags 0x27200
[    5.719997] pci 0000:04:03.0: BAR 6: got res [0x50100000-0x501fffff] bus [0x50100000-0x501fffff] flags 0x27200
[    5.729992] pci 0000:04:04.0: BAR 6: got res [0x50200000-0x502fffff] bus [0x50200000-0x502fffff] flags 0x27200
[    5.739993] pci 0000:04:07.0: BAR 6: got res [0x50300000-0x5031ffff] bus [0x50300000-0x5031ffff] flags 0x27200
[    5.750049] pci 0000:02:1f.0: setting latency timer to 64
[    5.755399] pci 0000:00:1e.0: setting latency timer to 64
[    5.760762] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    5.766217] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    5.772369] pci_bus 0000:01: resource 0 io:  [0xa000-0xafff]
[    5.778002] pci_bus 0000:01: resource 1 mem: [0xdc000000-0xddffffff]
[    5.784327] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xd7ffffff]
[    5.790652] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    5.795765] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    5.801400] pci_bus 0000:02: resource 1 mem: [0xde000000-0xdfffffff]
[    5.807723] pci_bus 0000:02: resource 2 mem: [0x50000000-0x500fffff]
[    5.814058] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    5.819161] pci_bus 0000:03: resource 0 io:  [0xb000-0xbfff]
[    5.824793] pci_bus 0000:03: resource 1 mem: [0xde000000-0xdfffffff]
[    5.831118] pci_bus 0000:03: resource 2 mem: [0x50000000-0x500fffff]
[    5.837443] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    5.842557] pci_bus 0000:04: resource 0 io:  [0xc000-0xcfff]
[    5.848190] pci_bus 0000:04: resource 1 mem: [0xe0000000-0xe1ffffff]
[    5.854515] pci_bus 0000:04: resource 2 mem: [0x50100000-0x503fffff]
[    5.860839] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    5.866300] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffff]
[    5.872456] initcall pcibios_assign_resources+0x0/0x76 returned 0 after 178339 usecs
[    5.880183] calling  sysctl_core_init+0x0/0x2d @ 1
[    5.885118] initcall sysctl_core_init+0x0/0x2d returned 0 after 164 usecs
[    5.891846] calling  inet_init+0x0/0x195 @ 1
[    5.896132] NET: Registered protocol family 2
[    5.912330] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    5.921278] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    5.929985] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    5.946187] TCP: Hash tables configured (established 131072 bind 65536)
[    5.952827] TCP reno registered
[    5.959446] initcall inet_init+0x0/0x195 returned 0 after 61860 usecs
[    5.965832] calling  af_unix_init+0x0/0x47 @ 1
[    5.970278] NET: Registered protocol family 1
[    5.974652] initcall af_unix_init+0x0/0x47 returned 0 after 4297 usecs
[    5.981125] calling  populate_rootfs+0x0/0xa8 @ 1
[    5.986687] initcall populate_rootfs+0x0/0xa8 returned 0 after 861 usecs
[    5.993336] calling  i8259A_init_sysfs+0x0/0x1d @ 1
[    5.998185] Registering sysdev class 'i8259'
[    6.002543] Registering sys device of class 'i8259'
[    6.007398] Registering sys device 'i82590'
[    6.011618] initcall i8259A_init_sysfs+0x0/0x1d returned 0 after 13114 usecs
[    6.018633] calling  sbf_init+0x0/0xbd @ 1
[    6.022705] initcall sbf_init+0x0/0xbd returned 0 after 1 usecs
[    6.028596] calling  i8237A_init_sysfs+0x0/0x1d @ 1
[    6.033446] Registering sysdev class 'i8237'
[    6.037773] Registering sys device of class 'i8237'
[    6.042619] Registering sys device 'i82370'
[    6.046838] initcall i8237A_init_sysfs+0x0/0x1d returned 0 after 13073 usecs
[    6.053849] calling  add_rtc_cmos+0x0/0x7e @ 1
[    6.058279] initcall add_rtc_cmos+0x0/0x7e returned 0 after 7 usecs
[    6.064507] calling  cache_sysfs_init+0x0/0x55 @ 1
[    6.069272] initcall cache_sysfs_init+0x0/0x55 returned 0 after 1 usecs
[    6.075856] calling  cpu_debug_init+0x0/0x3e2 @ 1
[    6.089278] cpu0(4) debug files 171
[    6.100760] cpu1(4) debug files 171
[    6.110151] cpu2(4) debug files 171
[    6.121690] cpu3(4) debug files 171
[    6.125134] initcall cpu_debug_init+0x0/0x3e2 returned 0 after 43547 usecs
[    6.131972] calling  longrun_init+0x0/0x2d @ 1
[    6.136394] initcall longrun_init+0x0/0x2d returned -19 after 1 usecs
[    6.142804] calling  cpufreq_gx_init+0x0/0x17d @ 1
[    6.147572] initcall cpufreq_gx_init+0x0/0x17d returned -19 after 1 usecs
[    6.154329] calling  apm_init+0x0/0x397 @ 1
[    6.158520] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[    6.164810] apm: disabled - APM is not SMP safe.
[    6.169407] initcall apm_init+0x0/0x397 returned -19 after 10661 usecs
[    6.175904] calling  init_lapic_sysfs+0x0/0x28 @ 1
[    6.180669] Registering sysdev class 'lapic'
[    6.185066] Registering sys device of class 'lapic'
[    6.189919] Registering sys device 'lapic0'
[    6.194141] initcall init_lapic_sysfs+0x0/0x28 returned 0 after 13150 usecs
[    6.201072] calling  ioapic_init_sysfs+0x0/0x84 @ 1
[    6.205919] Registering sysdev class 'ioapic'
[    6.210333] Registering sys device of class 'ioapic'
[    6.215264] Registering sys device 'ioapic0'
[    6.219569] initcall ioapic_init_sysfs+0x0/0x84 returned 0 after 13325 usecs
[    6.226589] calling  add_pcspkr+0x0/0x40 @ 1
[    6.230838] Registering platform device 'pcspkr'. Parent at platform
[    6.237160] device: 'pcspkr': device_add
[    6.241081] bus: 'platform': add device pcspkr
[    6.245509] PM: Adding info for platform:pcspkr
[    6.250115] initcall add_pcspkr+0x0/0x40 returned 0 after 18827 usecs
[    6.256523] calling  start_periodic_check_for_corruption+0x0/0x37 @ 1
[    6.262927] Scanning for low memory corruption every 60 seconds
[    6.268831] initcall start_periodic_check_for_corruption+0x0/0x37 returned 0 after 5762 usecs
[    6.277341] calling  start_pageattr_test+0x0/0x62 @ 1
[    6.282605] initcall start_pageattr_test+0x0/0x62 returned 0 after 229 usecs
[    6.289605] calling  aes_init+0x0/0xf @ 1
[    6.294121] initcall aes_init+0x0/0xf returned 0 after 510 usecs
[    6.300084] calling  crc32c_intel_mod_init+0x0/0x1d @ 1
[    6.305279] initcall crc32c_intel_mod_init+0x0/0x1d returned -19 after 1 usecs
[    6.312485] calling  init_sched_debug_procfs+0x0/0x27 @ 1
[    6.317886] initcall init_sched_debug_procfs+0x0/0x27 returned 0 after 23 usecs
[    6.325188] calling  proc_schedstat_init+0x0/0x1c @ 1
[    6.330229] initcall proc_schedstat_init+0x0/0x1c returned 0 after 12 usecs
[    6.337146] calling  proc_execdomains_init+0x0/0x1c @ 1
[    6.342359] initcall proc_execdomains_init+0x0/0x1c returned 0 after 11 usecs
[    6.349450] calling  ioresources_init+0x0/0x31 @ 1
[    6.354239] initcall ioresources_init+0x0/0x31 returned 0 after 19 usecs
[    6.360889] calling  uid_cache_init+0x0/0x5e @ 1
[    6.365529] initcall uid_cache_init+0x0/0x5e returned 0 after 44 usecs
[    6.371999] calling  init_posix_timers+0x0/0xac @ 1
[    6.376862] initcall init_posix_timers+0x0/0xac returned 0 after 9 usecs
[    6.383523] calling  init_posix_cpu_timers+0x0/0x90 @ 1
[    6.388724] initcall init_posix_cpu_timers+0x0/0x90 returned 0 after 1 usecs
[    6.395741] calling  nsproxy_cache_init+0x0/0x27 @ 1
[    6.400688] initcall nsproxy_cache_init+0x0/0x27 returned 0 after 7 usecs
[    6.407440] calling  create_proc_profile+0x0/0x18a @ 1
[    6.412554] initcall create_proc_profile+0x0/0x18a returned 0 after 1 usecs
[    6.419483] calling  timekeeping_init_device+0x0/0x1d @ 1
[    6.424855] Registering sysdev class 'timekeeping'
[    6.429715] Registering sys device of class 'timekeeping'
[    6.435087] Registering sys device 'timekeeping0'
[    6.439826] initcall timekeeping_init_device+0x0/0x1d returned 0 after 14612 usecs
[    6.447405] calling  init_clocksource_sysfs+0x0/0x43 @ 1
[    6.452687] Registering sysdev class 'clocksource'
[    6.457526] Registering sys device of class 'clocksource'
[    6.462890] Registering sys device 'clocksource0'
[    6.467644] initcall init_clocksource_sysfs+0x0/0x43 returned 0 after 14600 usecs
[    6.475135] calling  init_timer_list_procfs+0x0/0x27 @ 1
[    6.480436] initcall init_timer_list_procfs+0x0/0x27 returned 0 after 17 usecs
[    6.487644] calling  init_tstats_procfs+0x0/0x27 @ 1
[    6.492595] initcall init_tstats_procfs+0x0/0x27 returned 0 after 11 usecs
[    6.499428] calling  lockdep_proc_init+0x0/0x4f @ 1
[    6.504312] initcall lockdep_proc_init+0x0/0x4f returned 0 after 27 usecs
[    6.511049] calling  futex_init+0x0/0x79 @ 1
[    6.515333] initcall futex_init+0x0/0x79 returned 0 after 45 usecs
[    6.521456] calling  init_rttest+0x0/0x134 @ 1
[    6.525876] Registering sysdev class 'rttest'
[    6.530454] Registering sys device of class 'rttest'
[    6.535386] Registering sys device 'rttest0'
[    6.539859] Registering sys device of class 'rttest'
[    6.544807] Registering sys device 'rttest1'
[    6.549335] Registering sys device of class 'rttest'
[    6.554277] Registering sys device 'rttest2'
[    6.558756] Registering sys device of class 'rttest'
[    6.563697] Registering sys device 'rttest3'
[    6.569313] Registering sys device of class 'rttest'
[    6.574274] Registering sys device 'rttest4'
[    6.578740] Registering sys device of class 'rttest'
[    6.583679] Registering sys device 'rttest5'
[    6.588183] Registering sys device of class 'rttest'
[    6.593124] Registering sys device 'rttest6'
[    6.597596] Registering sys device of class 'rttest'
[    6.602535] Registering sys device 'rttest7'
[    6.606852] Initializing RT-Tester: OK
[    6.610568] initcall init_rttest+0x0/0x134 returned 0 after 82702 usecs
[    6.617148] calling  proc_dma_init+0x0/0x1c @ 1
[    6.621677] initcall proc_dma_init+0x0/0x1c returned 0 after 22 usecs
[    6.628065] calling  proc_modules_init+0x0/0x1c @ 1
[    6.632929] initcall proc_modules_init+0x0/0x1c returned 0 after 11 usecs
[    6.639675] calling  kallsyms_init+0x0/0x1f @ 1
[    6.644194] initcall kallsyms_init+0x0/0x1f returned 0 after 10 usecs
[    6.650595] calling  backtrace_regression_test+0x0/0xd1 @ 1
[    6.656137] ====[ backtrace testing ]===========
[    6.660728] Testing a backtrace from process context.
[    6.665755] The following trace is a kernel self test and not a bug!
[    6.672084] Pid: 1, comm: swapper Not tainted 2.6.29-tip-10645-g54ba01a-dirty #717
[    6.679636] Call Trace:
[    6.682071]  [<c015dcfa>] backtrace_regression_test+0x2f/0xd1
[    6.687789]  [<c014590f>] ? ktime_get+0x16/0x34
[    6.692293]  [<c010113f>] ? do_one_initcall+0x45/0x116
[    6.697405]  [<c0101149>] do_one_initcall+0x4f/0x116
[    6.702345]  [<c015dccb>] ? backtrace_regression_test+0x0/0xd1
[    6.708154]  [<c016711a>] ? init_irq_proc+0x58/0x65
[    6.713008]  [<c0bf84ee>] kernel_init+0xfb/0x14f
[    6.717595]  [<c0bf83f3>] ? kernel_init+0x0/0x14f
[    6.722276]  [<c0103837>] kernel_thread_helper+0x7/0x10
[    6.727468] Testing a backtrace from irq context.
[    6.732148] The following trace is a kernel self test and not a bug!
[    6.738490] Pid: 10, comm: ksoftirqd/2 Not tainted 2.6.29-tip-10645-g54ba01a-dirty #717
[    6.746478] Call Trace:
[    6.748912]  [<c0150758>] ? trace_hardirqs_on_caller+0xfc/0x14d
[    6.754801]  [<c015dcbf>] backtrace_test_irq_callback+0xd/0x19
[    6.760608]  [<c01351da>] tasklet_action+0x64/0xab
[    6.765374]  [<c0134bbe>] __do_softirq+0xb9/0x1a1
[    6.770056]  [<c0134cd6>] do_softirq+0x30/0x48
[    6.774471]  [<c0135035>] ksoftirqd+0x63/0xbe
[    6.778803]  [<c0134fd2>] ? ksoftirqd+0x0/0xbe
[    6.783223]  [<c01429fd>] kthread+0x40/0x67
[    6.787381]  [<c01429bd>] ? kthread+0x0/0x67
[    6.791628]  [<c0103837>] kernel_thread_helper+0x7/0x10
[    6.796839] Testing a saved backtrace.
[    6.800551] The following trace is a kernel self test and not a bug!
[    6.806879]  [<c010bbaa>] save_stack_trace+0x22/0x40
[    6.811814]  [<c015dd81>] backtrace_regression_test+0xb6/0xd1
[    6.817533]  [<c0101149>] do_one_initcall+0x4f/0x116
[    6.822473]  [<c0bf84ee>] kernel_init+0xfb/0x14f
[    6.827065]  [<c0103837>] kernel_thread_helper+0x7/0x10
[    6.832267]  [<ffffffff>] 0xffffffff
[    6.835817] ====[ end of backtrace testing ]====
[    6.840415] initcall backtrace_regression_test+0x0/0xd1 returned 0 after 179956 usecs
[    6.848230] calling  pid_namespaces_init+0x0/0x27 @ 1
[    6.853279] initcall pid_namespaces_init+0x0/0x27 returned 0 after 21 usecs
[    6.860187] calling  init_kprobes+0x0/0x131 @ 1
[    6.879445] Kprobe smoke test started
[    6.913234] Kprobe smoke test passed successfully
[    6.917884] initcall init_kprobes+0x0/0x131 returned 0 after 51937 usecs
[    6.924549] calling  hung_task_init+0x0/0x5c @ 1
[    6.929295] initcall hung_task_init+0x0/0x5c returned 0 after 147 usecs
[    6.935849] calling  rcu_torture_init+0x0/0x69f @ 1
[    6.940734] rcu-torture:--- Start of test: nreaders=8 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
[    6.956290] initcall rcu_torture_init+0x0/0x69f returned 0 after 15218 usecs
[    6.963286] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    6.968399] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 84 usecs
[    6.975305] calling  init_markers+0x0/0x14 @ 1
[    6.979724] initcall init_markers+0x0/0x14 returned 0 after 1 usecs
[    6.985960] calling  init_tracepoints+0x0/0x14 @ 1
[    6.990730] initcall init_tracepoints+0x0/0x14 returned 0 after 1 usecs
[    6.997312] calling  init_lstats_procfs+0x0/0x1f @ 1
[    7.002281] initcall init_lstats_procfs+0x0/0x1f returned 0 after 27 usecs
[    7.009098] calling  ftrace_mod_cmd_init+0x0/0xf @ 1
[    7.014094] initcall ftrace_mod_cmd_init+0x0/0xf returned 0 after 47 usecs
[    7.020907] calling  init_events+0x0/0x5f @ 1
[    7.025255] initcall init_events+0x0/0x5f returned 0 after 12 usecs
[    7.031479] calling  init_sched_switch_trace+0x0/0xf @ 1
[    7.036772] Testing tracer sched_switch: PASSED
[    7.141812] initcall init_sched_switch_trace+0x0/0xf returned 0 after 102582 usecs
[    7.149385] calling  init_stack_trace+0x0/0xf @ 1
[    7.154054] Testing tracer sysprof: .. no entries found ..FAILED!
[    7.260725] initcall init_stack_trace+0x0/0xf returned -1 after 104170 usecs
[    7.267739] initcall init_stack_trace+0x0/0xf returned with error code -1 
[    7.274583] calling  init_function_trace+0x0/0x35 @ 1
[    7.279616] Testing tracer function: PASSED
[    7.407713] Testing dynamic ftrace: PASSED
[    7.662922] initcall init_function_trace+0x0/0x35 returned 0 after 374318 usecs
[    7.670239] calling  init_irqsoff_tracer+0x0/0x11 @ 1
[    7.675252] Testing tracer irqsoff: PASSED
[    7.701140] initcall init_irqsoff_tracer+0x0/0x11 returned 0 after 25273 usecs
[    7.708352] calling  init_mmio_trace+0x0/0xf @ 1
[    7.712951] initcall init_mmio_trace+0x0/0xf returned 0 after 4 usecs
[    7.719355] calling  init_graph_trace+0x0/0xf @ 1
[    7.724054] Testing tracer function_graph: PASSED
[    7.841612] initcall init_graph_trace+0x0/0xf returned 0 after 114801 usecs
[    7.848540] calling  init_branch_tracer+0x0/0x2f @ 1
[    7.853475] Testing tracer branch: PASSED
[    7.958867] initcall init_branch_tracer+0x0/0x2f returned 0 after 102923 usecs
[    7.966081] calling  init_bts_trace+0x0/0x19 @ 1
[    7.970682] initcall init_bts_trace+0x0/0x19 returned 0 after 7 usecs
[    7.977085] calling  init_blk_tracer+0x0/0x4b @ 1
[    7.981771] initcall init_blk_tracer+0x0/0x4b returned 0 after 5 usecs
[    7.988263] calling  perf_counter_sysfs_init+0x0/0x14 @ 1
[    7.993670] initcall perf_counter_sysfs_init+0x0/0x14 returned 0 after 31 usecs
[    8.000963] calling  init_per_zone_pages_min+0x0/0x80 @ 1
[    8.006405] initcall init_per_zone_pages_min+0x0/0x80 returned 0 after 63 usecs
[    8.013711] calling  pdflush_init+0x0/0x16 @ 1
[    8.018407] initcall pdflush_init+0x0/0x16 returned 0 after 273 usecs
[    8.024802] calling  kswapd_init+0x0/0x1d @ 1
[    8.029265] initcall kswapd_init+0x0/0x1d returned 0 after 124 usecs
[    8.035564] calling  init_tmpfs+0x0/0xd1 @ 1
[    8.040201] initcall init_tmpfs+0x0/0xd1 returned 0 after 376 usecs
[    8.046415] calling  setup_vmstat+0x0/0xa8 @ 1
[    8.050917] initcall setup_vmstat+0x0/0xa8 returned 0 after 78 usecs
[    8.057221] calling  mm_sysfs_init+0x0/0x22 @ 1
[    8.061748] initcall mm_sysfs_init+0x0/0x22 returned 0 after 19 usecs
[    8.068139] calling  proc_vmalloc_init+0x0/0x1f @ 1
[    8.073027] initcall proc_vmalloc_init+0x0/0x1f returned 0 after 33 usecs
[    8.079759] calling  init_emergency_pool+0x0/0x71 @ 1
[    8.084863] highmem bounce pool size: 64 pages
[    8.089258] initcall init_emergency_pool+0x0/0x71 returned 0 after 4366 usecs
[    8.096361] calling  hugetlb_init+0x0/0x272 @ 1
[    8.100869] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    8.107242] initcall hugetlb_init+0x0/0x272 returned 0 after 6224 usecs
[    8.113804] calling  slab_proc_init+0x0/0x1f @ 1
[    8.118412] initcall slab_proc_init+0x0/0x1f returned 0 after 12 usecs
[    8.124896] calling  slab_sysfs_init+0x0/0xb7 @ 1
[    8.157242] initcall slab_sysfs_init+0x0/0xb7 returned 0 after 27008 usecs
[    8.164095] calling  fasync_init+0x0/0x24 @ 1
[    8.168688] initcall fasync_init+0x0/0x24 returned 0 after 257 usecs
[    8.175034] calling  proc_filesystems_init+0x0/0x1c @ 1
[    8.180245] initcall proc_filesystems_init+0x0/0x1c returned 0 after 25 usecs
[    8.187330] calling  dnotify_init+0x0/0x24 @ 1
[    8.192002] initcall dnotify_init+0x0/0x24 returned 0 after 243 usecs
[    8.198417] calling  inotify_setup+0x0/0x11 @ 1
[    8.202927] initcall inotify_setup+0x0/0x11 returned 0 after 1 usecs
[    8.209248] calling  inotify_user_setup+0x0/0xd0 @ 1
[    8.215100] initcall inotify_user_setup+0x0/0xd0 returned 0 after 886 usecs
[    8.222065] calling  aio_setup+0x0/0xdd @ 1
[    8.227532] initcall aio_setup+0x0/0xdd returned 0 after 1283 usecs
[    8.233764] calling  proc_locks_init+0x0/0x1c @ 1
[    8.238466] initcall proc_locks_init+0x0/0x1c returned 0 after 26 usecs
[    8.245046] calling  init_mbcache+0x0/0x11 @ 1
[    8.249457] initcall init_mbcache+0x0/0x11 returned 0 after 3 usecs
[    8.255689] calling  dquot_init+0x0/0xdd @ 1
[    8.259933] VFS: Disk quotas dquot_6.5.2
[    8.264339] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    8.270886] initcall dquot_init+0x0/0xdd returned 0 after 10689 usecs
[    8.277275] calling  proc_cmdline_init+0x0/0x1c @ 1
[    8.282149] initcall proc_cmdline_init+0x0/0x1c returned 0 after 19 usecs
[    8.288886] calling  proc_cpuinfo_init+0x0/0x1c @ 1
[    8.293756] initcall proc_cpuinfo_init+0x0/0x1c returned 0 after 13 usecs
[    8.300497] calling  proc_devices_init+0x0/0x1c @ 1
[    8.305365] initcall proc_devices_init+0x0/0x1c returned 0 after 12 usecs
[    8.312108] calling  proc_interrupts_init+0x0/0x1c @ 1
[    8.317237] initcall proc_interrupts_init+0x0/0x1c returned 0 after 13 usecs
[    8.324239] calling  proc_loadavg_init+0x0/0x1c @ 1
[    8.329107] initcall proc_loadavg_init+0x0/0x1c returned 0 after 13 usecs
[    8.335852] calling  proc_meminfo_init+0x0/0x1c @ 1
[    8.340731] initcall proc_meminfo_init+0x0/0x1c returned 0 after 24 usecs
[    8.347463] calling  proc_stat_init+0x0/0x1c @ 1
[    8.352075] initcall proc_stat_init+0x0/0x1c returned 0 after 13 usecs
[    8.358554] calling  proc_uptime_init+0x0/0x1c @ 1
[    8.363335] initcall proc_uptime_init+0x0/0x1c returned 0 after 12 usecs
[    8.369993] calling  proc_version_init+0x0/0x1c @ 1
[    8.374862] initcall proc_version_init+0x0/0x1c returned 0 after 12 usecs
[    8.381604] calling  proc_kcore_init+0x0/0x40 @ 1
[    8.386298] initcall proc_kcore_init+0x0/0x40 returned 0 after 12 usecs
[    8.394005] calling  vmcore_init+0x0/0xa06 @ 1
[    8.398427] initcall vmcore_init+0x0/0xa06 returned 0 after 2 usecs
[    8.404662] calling  proc_kmsg_init+0x0/0x1f @ 1
[    8.409269] initcall proc_kmsg_init+0x0/0x1f returned 0 after 13 usecs
[    8.415753] calling  proc_page_init+0x0/0x37 @ 1
[    8.420370] initcall proc_page_init+0x0/0x37 returned 0 after 21 usecs
[    8.426845] calling  configfs_init+0x0/0xbb @ 1
[    8.431644] initcall configfs_init+0x0/0xbb returned 0 after 282 usecs
[    8.438141] calling  init_devpts_fs+0x0/0x4e @ 1
[    8.443150] initcall init_devpts_fs+0x0/0x4e returned 0 after 408 usecs
[    8.449713] calling  init_ext3_fs+0x0/0x5f @ 1
[    8.454817] initcall init_ext3_fs+0x0/0x5f returned 0 after 663 usecs
[    8.461233] calling  journal_init+0x0/0xce @ 1
[    8.466916] initcall journal_init+0x0/0xce returned 0 after 1233 usecs
[    8.473423] calling  journal_init+0x0/0xb0 @ 1
[    8.479213] initcall journal_init+0x0/0xb0 returned 0 after 1340 usecs
[    8.485721] calling  init_ramfs_fs+0x0/0xf @ 1
[    8.490147] initcall init_ramfs_fs+0x0/0xf returned 0 after 9 usecs
[    8.496374] calling  init_hugetlbfs_fs+0x0/0x9d @ 1
[    8.502058] initcall init_hugetlbfs_fs+0x0/0x9d returned 0 after 802 usecs
[    8.508888] calling  init_coda+0x0/0x129 @ 1
[    8.513436] device class 'coda': registering
[    8.517769] device: 'cfs0': device_add
[    8.521538] PM: Adding info for No Bus:cfs0
[    8.525894] device: 'cfs1': device_add
[    8.529704] PM: Adding info for No Bus:cfs1
[    8.533914] device: 'cfs2': device_add
[    8.537680] PM: Adding info for No Bus:cfs2
[    8.541885] device: 'cfs3': device_add
[    8.545650] PM: Adding info for No Bus:cfs3
[    8.549855] device: 'cfs4': device_add
[    8.553613] PM: Adding info for No Bus:cfs4
[    8.557949] initcall init_coda+0x0/0x129 returned 0 after 43757 usecs
[    8.564367] calling  init_minix_fs+0x0/0x4f @ 1
[    8.569190] initcall init_minix_fs+0x0/0x4f returned 0 after 312 usecs
[    8.575683] calling  init_bfs_fs+0x0/0x4f @ 1
[    8.580306] initcall init_bfs_fs+0x0/0x4f returned 0 after 267 usecs
[    8.586620] calling  init_iso9660_fs+0x0/0x4f @ 1
[    8.591526] initcall init_iso9660_fs+0x0/0x4f returned 0 after 224 usecs
[    8.598195] calling  init_hfs_fs+0x0/0x50 @ 1
[    8.602774] initcall init_hfs_fs+0x0/0x50 returned 0 after 242 usecs
[    8.609097] calling  ecryptfs_init+0x0/0x194 @ 1
[    8.618818] device: 'ecryptfs': device_add
[    8.623213] PM: Adding info for No Bus:ecryptfs
[    8.628291] initcall ecryptfs_init+0x0/0x194 returned 0 after 14249 usecs
[    8.635070] calling  vxfs_init+0x0/0x4d @ 1
[    8.639550] initcall vxfs_init+0x0/0x4d returned 0 after 316 usecs
[    8.645699] calling  init_nfsd+0x0/0xca @ 1
[    8.649850] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    8.659685] initcall init_nfsd+0x0/0xca returned 0 after 9594 usecs
[    8.665912] calling  init_nlm+0x0/0x1c @ 1
[    8.670152] initcall init_nlm+0x0/0x1c returned 0 after 163 usecs
[    8.676199] calling  init_nls_cp855+0x0/0xf @ 1
[    8.680743] initcall init_nls_cp855+0x0/0xf returned 0 after 39 usecs
[    8.687132] calling  init_nls_cp860+0x0/0xf @ 1
[    8.691642] initcall init_nls_cp860+0x0/0xf returned 0 after 1 usecs
[    8.697962] calling  init_nls_cp863+0x0/0xf @ 1
[    8.702473] initcall init_nls_cp863+0x0/0xf returned 0 after 2 usecs
[    8.708825] calling  init_nls_cp866+0x0/0xf @ 1
[    8.713304] initcall init_nls_cp866+0x0/0xf returned 0 after 2 usecs
[    8.719625] calling  init_nls_cp869+0x0/0xf @ 1
[    8.724135] initcall init_nls_cp869+0x0/0xf returned 0 after 2 usecs
[    8.730460] calling  init_nls_cp874+0x0/0xf @ 1
[    8.734966] initcall init_nls_cp874+0x0/0xf returned 0 after 1 usecs
[    8.741288] calling  init_nls_cp932+0x0/0xf @ 1
[    8.745798] initcall init_nls_cp932+0x0/0xf returned 0 after 1 usecs
[    8.752120] calling  init_nls_euc_jp+0x0/0x39 @ 1
[    8.756804] initcall init_nls_euc_jp+0x0/0x39 returned 0 after 3 usecs
[    8.763298] calling  init_nls_cp950+0x0/0xf @ 1
[    8.767807] initcall init_nls_cp950+0x0/0xf returned 0 after 1 usecs
[    8.774130] calling  init_nls_cp1251+0x0/0xf @ 1
[    8.778725] initcall init_nls_cp1251+0x0/0xf returned 0 after 1 usecs
[    8.785135] calling  init_nls_iso8859_1+0x0/0xf @ 1
[    8.789992] initcall init_nls_iso8859_1+0x0/0xf returned 0 after 1 usecs
[    8.796660] calling  init_nls_iso8859_2+0x0/0xf @ 1
[    8.801515] initcall init_nls_iso8859_2+0x0/0xf returned 0 after 1 usecs
[    8.808184] calling  init_nls_iso8859_3+0x0/0xf @ 1
[    8.813058] initcall init_nls_iso8859_3+0x0/0xf returned 0 after 2 usecs
[    8.819709] calling  init_nls_iso8859_5+0x0/0xf @ 1
[    8.824565] initcall init_nls_iso8859_5+0x0/0xf returned 0 after 1 usecs
[    8.831234] calling  init_nls_iso8859_6+0x0/0xf @ 1
[    8.836090] initcall init_nls_iso8859_6+0x0/0xf returned 0 after 1 usecs
[    8.842758] calling  init_nls_iso8859_7+0x0/0xf @ 1
[    8.847615] initcall init_nls_iso8859_7+0x0/0xf returned 0 after 1 usecs
[    8.854284] calling  init_nls_iso8859_9+0x0/0xf @ 1
[    8.859139] initcall init_nls_iso8859_9+0x0/0xf returned 0 after 1 usecs
[    8.865808] calling  init_nls_iso8859_14+0x0/0xf @ 1
[    8.870751] initcall init_nls_iso8859_14+0x0/0xf returned 0 after 1 usecs
[    8.877507] calling  init_sysv_fs+0x0/0x43 @ 1
[    8.882282] initcall init_sysv_fs+0x0/0x43 returned 0 after 344 usecs
[    8.888691] calling  init_ufs_fs+0x0/0x4f @ 1
[    8.893296] initcall init_ufs_fs+0x0/0x4f returned 0 after 248 usecs
[    8.899616] calling  init_affs_fs+0x0/0x4f @ 1
[    8.904330] initcall init_affs_fs+0x0/0x4f returned 0 after 270 usecs
[    8.910733] calling  init_romfs_fs+0x0/0x4f @ 1
[    8.915474] initcall init_romfs_fs+0x0/0x4f returned 0 after 228 usecs
[    8.921962] calling  init_autofs_fs+0x0/0xf @ 1
[    8.926474] initcall init_autofs_fs+0x0/0xf returned 0 after 6 usecs
[    8.932792] calling  init_autofs4_fs+0x0/0x1e @ 1
[    8.937477] initcall init_autofs4_fs+0x0/0x1e returned -16 after 4 usecs
[    8.944144] initcall init_autofs4_fs+0x0/0x1e returned with error code -16 
[    8.951074] calling  init_adfs_fs+0x0/0x4f @ 1
[    8.955748] initcall init_adfs_fs+0x0/0x4f returned 0 after 245 usecs
[    8.962154] calling  ocfs2_init+0x0/0x28c @ 1
[    8.966480] OCFS2 1.5.0
[    8.971424] initcall ocfs2_init+0x0/0x28c returned 0 after 4820 usecs
[    8.978046] calling  ocfs2_stack_glue_init+0x0/0x7c @ 1
[    8.983368] initcall ocfs2_stack_glue_init+0x0/0x7c returned 0 after 139 usecs
[    8.990585] calling  o2cb_stack_init+0x0/0xf @ 1
[    8.995171] ocfs2: Registered cluster interface o2cb
[    9.000114] initcall o2cb_stack_init+0x0/0xf returned 0 after 4824 usecs
[    9.006782] calling  init_o2nm+0x0/0x92 @ 1
[    9.010940] OCFS2 Node Manager 1.5.0
[    9.015916] initcall init_o2nm+0x0/0x92 returned 0 after 4848 usecs
[    9.022173] calling  dlm_init+0x0/0x275 @ 1
[    9.026323] OCFS2 DLM 1.5.0
[    9.030734] initcall dlm_init+0x0/0x275 returned 0 after 4298 usecs
[    9.036971] calling  init_dlmfs_fs+0x0/0xc3 @ 1
[    9.041469] OCFS2 DLMFS 1.5.0
[    9.044927] OCFS2 User DLM kernel interface loaded
[    9.049703] initcall init_dlmfs_fs+0x0/0xc3 returned 0 after 8035 usecs
[    9.056277] calling  ipc_init+0x0/0x20 @ 1
[    9.060392] msgmni has been set to 1692
[    9.064205] initcall ipc_init+0x0/0x20 returned 0 after 3767 usecs
[    9.070335] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    9.075219] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 180 usecs
[    9.081867] calling  init_mqueue_fs+0x0/0xd3 @ 1
[    9.087484] initcall init_mqueue_fs+0x0/0xd3 returned 0 after 995 usecs
[    9.094062] calling  key_proc_init+0x0/0x2c @ 1
[    9.098584] initcall key_proc_init+0x0/0x2c returned 0 after 24 usecs
[    9.104979] calling  crypto_wq_init+0x0/0x47 @ 1
[    9.110203] initcall crypto_wq_init+0x0/0x47 returned 0 after 616 usecs
[    9.116788] calling  crypto_algapi_init+0x0/0xc @ 1
[    9.121694] initcall crypto_algapi_init+0x0/0xc returned 0 after 66 usecs
[    9.128434] calling  chainiv_module_init+0x0/0xf @ 1
[    9.133411] initcall chainiv_module_init+0x0/0xf returned 0 after 33 usecs
[    9.140238] calling  eseqiv_module_init+0x0/0xf @ 1
[    9.145093] initcall eseqiv_module_init+0x0/0xf returned 0 after 3 usecs
[    9.151763] calling  md5_mod_init+0x0/0xf @ 1
[    9.156343] initcall md5_mod_init+0x0/0xf returned 0 after 240 usecs
[    9.162664] calling  tgr192_mod_init+0x0/0x52 @ 1
[    9.168086] initcall tgr192_mod_init+0x0/0x52 returned 0 after 729 usecs
[    9.174743] calling  crypto_cbc_module_init+0x0/0xf @ 1
[    9.179945] initcall crypto_cbc_module_init+0x0/0xf returned 0 after 3 usecs
[    9.186959] calling  crypto_module_init+0x0/0xf @ 1
[    9.191816] initcall crypto_module_init+0x0/0xf returned 0 after 3 usecs
[    9.198484] calling  crypto_module_init+0x0/0xf @ 1
[    9.203340] initcall crypto_module_init+0x0/0xf returned 0 after 3 usecs
[    9.210022] calling  cryptd_init+0x0/0xc1 @ 1
[    9.214354] initcall cryptd_init+0x0/0xc1 returned 0 after 12 usecs
[    9.220581] calling  des_generic_mod_init+0x0/0x33 @ 1
[    9.226267] initcall des_generic_mod_init+0x0/0x33 returned 0 after 559 usecs
[    9.233354] calling  twofish_mod_init+0x0/0xf @ 1
[    9.238448] initcall twofish_mod_init+0x0/0xf returned 0 after 388 usecs
[    9.245104] calling  aes_init+0x0/0xf @ 1
[    9.249352] initcall aes_init+0x0/0xf returned 0 after 252 usecs
[    9.255313] calling  salsa20_generic_mod_init+0x0/0xf @ 1
[    9.260905] initcall salsa20_generic_mod_init+0x0/0xf returned 0 after 189 usecs
[    9.268301] calling  zlib_mod_init+0x0/0xf @ 1
[    9.273956] initcall zlib_mod_init+0x0/0xf returned 0 after 1205 usecs
[    9.280454] calling  michael_mic_init+0x0/0xf @ 1
[    9.285405] initcall michael_mic_init+0x0/0xf returned 0 after 269 usecs
[    9.292061] calling  crypto_authenc_module_init+0x0/0xf @ 1
[    9.297610] initcall crypto_authenc_module_init+0x0/0xf returned 0 after 3 usecs
[    9.304997] calling  krng_mod_init+0x0/0xf @ 1
[    9.309577] alg: No test for stdrng (krng)
[    9.313696] initcall krng_mod_init+0x0/0xf returned 0 after 4178 usecs
[    9.320174] calling  proc_genhd_init+0x0/0x31 @ 1
[    9.324888] initcall proc_genhd_init+0x0/0x31 returned 0 after 32 usecs
[    9.331447] calling  bsg_init+0x0/0x120 @ 1
[    9.335925] device class 'bsg': registering
[    9.340173] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    9.347581] initcall bsg_init+0x0/0x120 returned 0 after 11689 usecs
[    9.353900] calling  noop_init+0x0/0x11 @ 1
[    9.358143] io scheduler noop registered (default)
[    9.362880] initcall noop_init+0x0/0x11 returned 0 after 4701 usecs
[    9.370234] calling  deadline_init+0x0/0x11 @ 1
[    9.374739] io scheduler deadline registered
[    9.378987] initcall deadline_init+0x0/0x11 returned 0 after 4146 usecs
[    9.385569] calling  percpu_counter_startup+0x0/0x16 @ 1
[    9.390864] initcall percpu_counter_startup+0x0/0x16 returned 0 after 6 usecs
[    9.397963] calling  dynamic_debug_init+0x0/0x107 @ 1
[    9.403564] initcall dynamic_debug_init+0x0/0x107 returned 0 after 560 usecs
[    9.410564] calling  pci_init+0x0/0x31 @ 1
[    9.414653] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x15e
[    9.420966] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.427201] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.433784] pci 0000:00:00.0: calling pci_fixup_video+0x0/0x97
[    9.439602] pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x15e
[    9.445917] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.452155] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.458739] pci 0000:00:01.0: calling pci_fixup_video+0x0/0x97
[    9.464558] pci 0000:00:02.0: calling quirk_e100_interrupt+0x0/0x15e
[    9.470873] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.477112] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.483695] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x97
[    9.489512] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x15e
[    9.495828] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.502069] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.508653] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0x97
[    9.514469] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x15e
[    9.520784] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.527044] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.533607] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0x97
[    9.539424] pci 0000:00:1f.1: calling quirk_e100_interrupt+0x0/0x15e
[    9.545741] pci 0000:00:1f.1: calling quirk_cardbus_legacy+0x0/0x26
[    9.551978] pci 0000:00:1f.1: calling quirk_usb_early_handoff+0x0/0x34c
[    9.558563] pci 0000:00:1f.1: calling pci_fixup_video+0x0/0x97
[    9.564381] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x15e
[    9.570695] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x26
[    9.576933] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x34c
[    9.583526] pci 0000:00:1f.2: uhci_check_and_reset_hc: legsup = 0x2f00
[    9.590023] pci 0000:00:1f.2: Performing full reset
[    9.594881] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0x97
[    9.600688] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x15e
[    9.607004] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x26
[    9.613241] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x34c
[    9.619825] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0x97
[    9.625644] pci 0000:00:1f.4: calling quirk_e100_interrupt+0x0/0x15e
[    9.631959] pci 0000:00:1f.4: calling quirk_cardbus_legacy+0x0/0x26
[    9.638197] pci 0000:00:1f.4: calling quirk_usb_early_handoff+0x0/0x34c
[    9.644786] pci 0000:00:1f.4: uhci_check_and_reset_hc: cmd = 0x0000
[    9.651034] pci 0000:00:1f.4: Performing full reset
[    9.655884] pci 0000:00:1f.4: calling pci_fixup_video+0x0/0x97
[    9.661691] pci 0000:00:1f.5: calling quirk_e100_interrupt+0x0/0x15e
[    9.668042] pci 0000:00:1f.5: calling quirk_cardbus_legacy+0x0/0x26
[    9.674253] pci 0000:00:1f.5: calling quirk_usb_early_handoff+0x0/0x34c
[    9.680838] pci 0000:00:1f.5: calling pci_fixup_video+0x0/0x97
[    9.686656] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.692884] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.699469] pci 0000:01:00.0: calling pci_fixup_video+0x0/0x97
[    9.705292] pci 0000:01:00.0: Boot video device
[    9.709794] pci 0000:02:1f.0: calling quirk_e100_interrupt+0x0/0x15e
[    9.716108] pci 0000:02:1f.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.722346] pci 0000:02:1f.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.728930] pci 0000:02:1f.0: calling pci_fixup_video+0x0/0x97
[    9.734750] pci 0000:03:00.0: calling quirk_e100_interrupt+0x0/0x15e
[    9.741081] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.747302] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.753887] pci 0000:03:00.0: calling pci_fixup_video+0x0/0x97
[    9.759705] pci 0000:03:04.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.765936] pci 0000:03:04.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.772518] pci 0000:03:04.0: calling pci_fixup_video+0x0/0x97
[    9.778336] pci 0000:03:04.1: calling quirk_cardbus_legacy+0x0/0x26
[    9.784563] pci 0000:03:04.1: calling quirk_usb_early_handoff+0x0/0x34c
[    9.791147] pci 0000:03:04.1: calling pci_fixup_video+0x0/0x97
[    9.796965] pci 0000:04:03.0: calling quirk_e100_interrupt+0x0/0x15e
[    9.803457] pci 0000:04:03.0: Firmware left e100 interrupts enabled; disabling
[    9.810706] pci 0000:04:03.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.816919] pci 0000:04:03.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.823503] pci 0000:04:03.0: calling pci_fixup_video+0x0/0x97
[    9.829323] pci 0000:04:04.0: calling quirk_e100_interrupt+0x0/0x15e
[    9.835692] pci 0000:04:04.0: Firmware left e100 interrupts enabled; disabling
[    9.842918] pci 0000:04:04.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.849145] pci 0000:04:04.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.855727] pci 0000:04:04.0: calling pci_fixup_video+0x0/0x97
[    9.861548] pci 0000:04:07.0: calling quirk_e100_interrupt+0x0/0x15e
[    9.867863] pci 0000:04:07.0: calling quirk_cardbus_legacy+0x0/0x26
[    9.874101] pci 0000:04:07.0: calling quirk_usb_early_handoff+0x0/0x34c
[    9.880685] pci 0000:04:07.0: calling pci_fixup_video+0x0/0x97
[    9.886504] initcall pci_init+0x0/0x31 returned 0 after 460809 usecs
[    9.892817] calling  pci_proc_init+0x0/0x5b @ 1
[    9.897740] initcall pci_proc_init+0x0/0x5b returned 0 after 408 usecs
[    9.904212] calling  pcie_portdrv_init+0x0/0x41 @ 1
[    9.909219] bus: 'pci_express': registered
[    9.913278] bus: 'pci': add driver pcieport-driver
[    9.918164] bus: 'pci': driver_probe_device: matched device 0000:00:01.0 with driver pcieport-driver
[    9.927285] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:01.0
[    9.935880] bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver pcieport-driver
[    9.945025] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:02.0
[    9.953590] bus: 'pci': driver_probe_device: matched device 0000:00:1e.0 with driver pcieport-driver
[    9.962709] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:1e.0
[    9.971277] bus: 'pci': driver_probe_device: matched device 0000:02:1f.0 with driver pcieport-driver
[    9.980395] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:02:1f.0
[    9.989122] initcall pcie_portdrv_init+0x0/0x41 returned 0 after 78169 usecs
[    9.996135] calling  aer_service_init+0x0/0x1d @ 1
[   10.000900] bus: 'pci_express': add driver aer
[   10.005420] initcall aer_service_init+0x0/0x1d returned 0 after 4413 usecs
[   10.012252] calling  pci_stub_init+0x0/0x16 @ 1
[   10.016756] bus: 'pci': add driver pci-stub
[   10.021106] initcall pci_stub_init+0x0/0x16 returned 0 after 4246 usecs
[   10.027685] calling  ltv350qv_init+0x0/0xf @ 1
[   10.032102] bus: 'spi': add driver ltv350qv
[   10.036362] initcall ltv350qv_init+0x0/0xf returned 0 after 4158 usecs
[   10.042850] calling  platform_lcd_init+0x0/0xf @ 1
[   10.047614] bus: 'platform': add driver platform-lcd
[   10.052657] initcall platform_lcd_init+0x0/0xf returned 0 after 4924 usecs
[   10.059487] calling  progearbl_init+0x0/0x61 @ 1
[   10.064080] bus: 'platform': add driver progear-bl
[   10.068949] Registering platform device 'progear-bl'. Parent at platform
[   10.075614] device: 'progear-bl': device_add
[   10.079881] bus: 'platform': add device progear-bl
[   10.084675] PM: Adding info for platform:progear-bl
[   10.089577] bus: 'platform': driver_probe_device: matched device progear-bl with driver progear-bl
[   10.098538] bus: 'platform': really_probe: probing driver progear-bl with device progear-bl
[   10.106923] ALI M7101 PMU not found.
[   10.110480] initcall progearbl_init+0x0/0x61 returned 0 after 45310 usecs
[   10.117211] calling  mbp_init+0x0/0xe9 @ 1
[   10.121289] initcall mbp_init+0x0/0xe9 returned -19 after 4 usecs
[   10.127349] calling  kb3886_init+0x0/0x35 @ 1
[   10.131684] initcall kb3886_init+0x0/0x35 returned -19 after 2 usecs
[   10.138028] calling  pm2fb_init+0x0/0x12f @ 1
[   10.142342] bus: 'pci': add driver pm2fb
[   10.146401] initcall pm2fb_init+0x0/0x12f returned 0 after 3963 usecs
[   10.152805] calling  aty128fb_init+0x0/0x11f @ 1
[   10.157393] bus: 'pci': add driver aty128fb
[   10.161700] initcall aty128fb_init+0x0/0x11f returned 0 after 4204 usecs
[   10.168367] calling  sisfb_init+0x0/0x702 @ 1
[   10.172697] bus: 'pci': add driver sisfb
[   10.176739] initcall sisfb_init+0x0/0x702 returned 0 after 3947 usecs
[   10.183140] calling  viafb_init+0x0/0xebd @ 1
[   10.187469] VIA Graphics Intergration Chipset framebuffer 2.4 initializing
[   10.194484] I2C adapter driver [via_i2c] forgot to specify physical device
[   10.201374] device: 'i2c-0': device_add
[   10.205393] PM: Adding info for No Bus:i2c-0
[   10.210075] i2c-adapter i2c-0: adapter [via_i2c] registered
[   10.215836] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[   10.221879] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[   10.248033] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.294041] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.340037] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.386034] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.391997] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[   10.400088] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[   10.426078] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[   10.432116] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[   10.458033] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.504024] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.550022] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.595022] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.600973] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[   10.609049] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[   10.634077] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[   10.640115] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[   10.666022] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.711024] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.756028] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.802024] i2c-adapter i2c-0: i2c_outb: 0x10, timeout at bit #7
[   10.807976] i2c-adapter i2c-0: Used 4 tries to write to client at 0x08: failed, timeout?
[   10.816061] i2c-adapter i2c-0: NAK from device addr 0x08 msg #0
[   10.841070] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   10.848244] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   10.874024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.919024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   10.964025] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.009025] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.014980] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   11.023063] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   11.048069] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   11.054104] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   11.080025] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.125025] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.171025] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.216024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.221974] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   11.230059] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   11.255069] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   11.261107] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   11.287024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.332024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.377024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.422024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.427973] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   11.436057] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   11.461071] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   11.467105] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   11.493024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.538025] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.583024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.628024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.633979] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   11.642064] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   11.667068] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   11.673104] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   11.699026] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.745025] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.790024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.835023] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.840975] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   11.849051] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   11.874067] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[   11.880108] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[   11.906022] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.951022] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   11.996023] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   12.041024] i2c-adapter i2c-0: i2c_outb: 0xa0, timeout at bit #7
[   12.046974] i2c-adapter i2c-0: Used 4 tries to write to client at 0x50: failed, timeout?
[   12.055050] i2c-adapter i2c-0: NAK from device addr 0x50 msg #0
[   12.080067] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   12.086107] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   12.112023] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.157023] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.202022] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.247024] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.252971] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   12.261048] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   12.286067] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   12.292105] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   12.318023] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.363023] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.408022] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.453022] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.458970] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   12.467047] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   12.492066] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   12.498103] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   12.524022] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.569022] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.614022] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.659021] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.664969] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   12.673045] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   12.698065] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[   12.704106] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[   12.730023] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.776025] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.821024] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.866022] i2c-adapter i2c-0: i2c_outb: 0x80, timeout at bit #7
[   12.871972] i2c-adapter i2c-0: Used 4 tries to write to client at 0x40: failed, timeout?
[   12.880049] i2c-adapter i2c-0: NAK from device addr 0x40 msg #0
[   12.905067] i2c-adapter i2c-0: master_xfer[0] W, addr=0x38, len=1
[   12.911105] i2c-adapter i2c-0: master_xfer[1] R, addr=0x38, len=1
[   12.937021] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   12.982023] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   13.027023] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   13.072022] i2c-adapter i2c-0: i2c_outb: 0x70, timeout at bit #7
[   13.077971] i2c-adapter i2c-0: Used 4 tries to write to client at 0x38: failed, timeout?
[   13.086047] i2c-adapter i2c-0: NAK from device addr 0x38 msg #0
[   13.111067] ioremap failed
[   13.113723] initcall viafb_init+0x0/0xebd returned -1 after 2857663 usecs
[   13.120477] initcall viafb_init+0x0/0xebd returned with error code -1 
[   13.126975] calling  savagefb_init+0x0/0x62 @ 1
[   13.131487] bus: 'pci': add driver savagefb
[   13.135885] initcall savagefb_init+0x0/0x62 returned 0 after 4299 usecs
[   13.142455] calling  imsttfb_init+0x0/0xec @ 1
[   13.146873] bus: 'pci': add driver imsttfb
[   13.151112] initcall imsttfb_init+0x0/0xec returned 0 after 4138 usecs
[   13.157599] calling  hecubafb_init+0x0/0xf @ 1
[   13.162033] bus: 'platform': add driver hecubafb
[   13.166717] initcall hecubafb_init+0x0/0xf returned 0 after 4574 usecs
[   13.173206] calling  n411_init+0x0/0x8a @ 1
[   13.177361] no IO addresses supplied
[   13.180918] initcall n411_init+0x0/0x8a returned -22 after 3469 usecs
[   13.187327] initcall n411_init+0x0/0x8a returned with error code -22 
[   13.193743] calling  sstfb_init+0x0/0x193 @ 1
[   13.198074] bus: 'pci': add driver sstfb
[   13.202138] initcall sstfb_init+0x0/0x193 returned 0 after 3966 usecs
[   13.208536] calling  s1d13xxxfb_init+0x0/0x28 @ 1
[   13.213214] bus: 'platform': add driver s1d13xxxfb
[   13.218103] initcall s1d13xxxfb_init+0x0/0x28 returned 0 after 4774 usecs
[   13.224850] calling  carminefb_init+0x0/0x31 @ 1
[   13.229442] bus: 'pci': add driver carminefb
[   13.233860] initcall carminefb_init+0x0/0x31 returned 0 after 4312 usecs
[   13.240516] calling  efifb_init+0x0/0x1b8 @ 1
[   13.244872] initcall efifb_init+0x0/0x1b8 returned -19 after 22 usecs
[   13.251260] calling  acpi_reserve_resources+0x0/0xc8 @ 1
[   13.256564] initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 16 usecs
[   13.263774] calling  irqrouter_init_sysfs+0x0/0x33 @ 1
[   13.268885] Registering sysdev class 'irqrouter'
[   13.273554] Registering sys device of class 'irqrouter'
[   13.278754] Registering sys device 'irqrouter0'
[   13.283320] initcall irqrouter_init_sysfs+0x0/0x33 returned 0 after 14092 usecs
[   13.290638] calling  acpi_ac_init+0x0/0x3d @ 1
[   13.295283] bus: 'acpi': add driver ac
[   13.299184] initcall acpi_ac_init+0x0/0x3d returned 0 after 4026 usecs
[   13.305673] calling  acpi_pci_slot_init+0x0/0x1b @ 1
[   13.312846] initcall acpi_pci_slot_init+0x0/0x1b returned 0 after 2181 usecs
[   13.319850] calling  rand_initialize+0x0/0x2a @ 1
[   13.324616] initcall rand_initialize+0x0/0x2a returned 0 after 86 usecs
[   13.331180] calling  tty_init+0x0/0xd5 @ 1
[   13.335274] device: 'tty': device_add
[   13.338972] PM: Adding info for No Bus:tty
[   13.343244] device: 'console': device_add
[   13.347281] PM: Adding info for No Bus:console
[   13.351764] device: 'tty0': device_add
[   13.355523] PM: Adding info for No Bus:tty0
[   13.359741] device class 'vc': registering
[   13.363895] device: 'vcs': device_add
[   13.367569] PM: Adding info for No Bus:vcs
[   13.371796] device: 'vcsa': device_add
[   13.375561] PM: Adding info for No Bus:vcsa
[   13.379846] device: 'tty1': device_add
[   13.383613] PM: Adding info for No Bus:tty1
[   13.387832] device: 'tty2': device_add
[   13.391591] PM: Adding info for No Bus:tty2
[   13.395800] device: 'tty3': device_add
[   13.399589] PM: Adding info for No Bus:tty3
[   13.403799] device: 'tty4': device_add
[   13.407560] PM: Adding info for No Bus:tty4
[   13.411768] device: 'tty5': device_add
[   13.415522] PM: Adding info for No Bus:tty5
[   13.419729] device: 'tty6': device_add
[   13.423486] PM: Adding info for No Bus:tty6
[   13.427694] device: 'tty7': device_add
[   13.431451] PM: Adding info for No Bus:tty7
[   13.435656] device: 'tty8': device_add
[   13.439412] PM: Adding info for No Bus:tty8
[   13.443619] device: 'tty9': device_add
[   13.447394] PM: Adding info for No Bus:tty9
[   13.451624] device: 'tty10': device_add
[   13.455482] PM: Adding info for No Bus:tty10
[   13.459786] device: 'tty11': device_add
[   13.463636] PM: Adding info for No Bus:tty11
[   13.467939] device: 'tty12': device_add
[   13.471789] PM: Adding info for No Bus:tty12
[   13.476113] device: 'tty13': device_add
[   13.479959] PM: Adding info for No Bus:tty13
[   13.484263] device: 'tty14': device_add
[   13.489277] PM: Adding info for No Bus:tty14
[   13.493576] device: 'tty15': device_add
[   13.497429] PM: Adding info for No Bus:tty15
[   13.501736] device: 'tty16': device_add
[   13.505600] PM: Adding info for No Bus:tty16
[   13.509894] device: 'tty17': device_add
[   13.513754] PM: Adding info for No Bus:tty17
[   13.518089] device: 'tty18': device_add
[   13.521946] PM: Adding info for No Bus:tty18
[   13.526257] device: 'tty19': device_add
[   13.530116] PM: Adding info for No Bus:tty19
[   13.534415] device: 'tty20': device_add
[   13.538260] PM: Adding info for No Bus:tty20
[   13.542552] device: 'tty21': device_add
[   13.546396] PM: Adding info for No Bus:tty21
[   13.550713] device: 'tty22': device_add
[   13.554586] PM: Adding info for No Bus:tty22
[   13.558887] device: 'tty23': device_add
[   13.562739] PM: Adding info for No Bus:tty23
[   13.567070] device: 'tty24': device_add
[   13.570928] PM: Adding info for No Bus:tty24
[   13.575231] device: 'tty25': device_add
[   13.579104] PM: Adding info for No Bus:tty25
[   13.583400] device: 'tty26': device_add
[   13.587253] PM: Adding info for No Bus:tty26
[   13.591544] device: 'tty27': device_add
[   13.595389] PM: Adding info for No Bus:tty27
[   13.599693] device: 'tty28': device_add
[   13.603568] PM: Adding info for No Bus:tty28
[   13.607860] device: 'tty29': device_add
[   13.611734] PM: Adding info for No Bus:tty29
[   13.616075] device: 'tty30': device_add
[   13.619933] PM: Adding info for No Bus:tty30
[   13.624236] device: 'tty31': device_add
[   13.628111] PM: Adding info for No Bus:tty31
[   13.632411] device: 'tty32': device_add
[   13.636266] PM: Adding info for No Bus:tty32
[   13.640562] device: 'tty33': device_add
[   13.644414] PM: Adding info for No Bus:tty33
[   13.648709] device: 'tty34': device_add
[   13.652555] PM: Adding info for No Bus:tty34
[   13.656854] device: 'tty35': device_add
[   13.660720] PM: Adding info for No Bus:tty35
[   13.665053] device: 'tty36': device_add
[   13.668900] PM: Adding info for No Bus:tty36
[   13.673198] device: 'tty37': device_add
[   13.677084] PM: Adding info for No Bus:tty37
[   13.681379] device: 'tty38': device_add
[   13.685245] PM: Adding info for No Bus:tty38
[   13.689539] device: 'tty39': device_add
[   13.693395] PM: Adding info for No Bus:tty39
[   13.697695] device: 'tty40': device_add
[   13.701561] PM: Adding info for No Bus:tty40
[   13.705858] device: 'tty41': device_add
[   13.709715] PM: Adding info for No Bus:tty41
[   13.714054] device: 'tty42': device_add
[   13.717919] PM: Adding info for No Bus:tty42
[   13.722215] device: 'tty43': device_add
[   13.726102] PM: Adding info for No Bus:tty43
[   13.730421] device: 'tty44': device_add
[   13.734271] PM: Adding info for No Bus:tty44
[   13.738569] device: 'tty45': device_add
[   13.742424] PM: Adding info for No Bus:tty45
[   13.746722] device: 'tty46': device_add
[   13.750623] PM: Adding info for No Bus:tty46
[   13.754919] device: 'tty47': device_add
[   13.758780] PM: Adding info for No Bus:tty47
[   13.763138] device: 'tty48': device_add
[   13.766994] PM: Adding info for No Bus:tty48
[   13.771295] device: 'tty49': device_add
[   13.775166] PM: Adding info for No Bus:tty49
[   13.779458] device: 'tty50': device_add
[   13.783309] PM: Adding info for No Bus:tty50
[   13.787606] device: 'tty51': device_add
[   13.791463] PM: Adding info for No Bus:tty51
[   13.795762] device: 'tty52': device_add
[   13.799627] PM: Adding info for No Bus:tty52
[   13.803923] device: 'tty53': device_add
[   13.807790] PM: Adding info for No Bus:tty53
[   13.812119] device: 'tty54': device_add
[   13.815978] PM: Adding info for No Bus:tty54
[   13.820280] device: 'tty55': device_add
[   13.824152] PM: Adding info for No Bus:tty55
[   13.828451] device: 'tty56': device_add
[   13.832304] PM: Adding info for No Bus:tty56
[   13.836600] device: 'tty57': device_add
[   13.840459] PM: Adding info for No Bus:tty57
[   13.844756] device: 'tty58': device_add
[   13.848612] PM: Adding info for No Bus:tty58
[   13.852907] device: 'tty59': device_add
[   13.856774] PM: Adding info for No Bus:tty59
[   13.861120] device: 'tty60': device_add
[   13.864981] PM: Adding info for No Bus:tty60
[   13.869283] device: 'tty61': device_add
[   13.873135] PM: Adding info for No Bus:tty61
[   13.877427] device: 'tty62': device_add
[   13.881298] PM: Adding info for No Bus:tty62
[   13.885592] device: 'tty63': device_add
[   13.889452] PM: Adding info for No Bus:tty63
[   13.894134] initcall tty_init+0x0/0xd5 returned 0 after 545773 usecs
[   13.900445] calling  pty_init+0x0/0x397 @ 1
[   13.904641] device: 'ptyp0': device_add
[   13.908523] PM: Adding info for No Bus:ptyp0
[   13.912826] device: 'ptyp1': device_add
[   13.916692] PM: Adding info for No Bus:ptyp1
[   13.920991] device: 'ptyp2': device_add
[   13.924860] PM: Adding info for No Bus:ptyp2
[   13.929160] device: 'ptyp3': device_add
[   13.933067] PM: Adding info for No Bus:ptyp3
[   13.937365] device: 'ptyp4': device_add
[   13.941237] PM: Adding info for No Bus:ptyp4
[   13.945540] device: 'ptyp5': device_add
[   13.949397] PM: Adding info for No Bus:ptyp5
[   13.953690] device: 'ptyp6': device_add
[   13.957543] PM: Adding info for No Bus:ptyp6
[   13.961850] device: 'ptyp7': device_add
[   13.965708] PM: Adding info for No Bus:ptyp7
[   13.970047] device: 'ptyp8': device_add
[   13.973903] PM: Adding info for No Bus:ptyp8
[   13.978205] device: 'ptyp9': device_add
[   13.982109] PM: Adding info for No Bus:ptyp9
[   13.986436] device: 'ptypa': device_add
[   13.990305] PM: Adding info for No Bus:ptypa
[   13.994604] device: 'ptypb': device_add
[   13.998497] PM: Adding info for No Bus:ptypb
[   14.002811] device: 'ptypc': device_add
[   14.006672] PM: Adding info for No Bus:ptypc
[   14.010968] device: 'ptypd': device_add
[   14.014831] PM: Adding info for No Bus:ptypd
[   14.019137] device: 'ptype': device_add
[   14.022995] PM: Adding info for No Bus:ptype
[   14.027303] device: 'ptypf': device_add
[   14.031164] PM: Adding info for No Bus:ptypf
[   14.035456] device: 'ptyq0': device_add
[   14.039326] PM: Adding info for No Bus:ptyq0
[   14.043619] device: 'ptyq1': device_add
[   14.047499] PM: Adding info for No Bus:ptyq1
[   14.051799] device: 'ptyq2': device_add
[   14.055651] PM: Adding info for No Bus:ptyq2
[   14.059968] device: 'ptyq3': device_add
[   14.063837] PM: Adding info for No Bus:ptyq3
[   14.068142] device: 'ptyq4': device_add
[   14.072052] PM: Adding info for No Bus:ptyq4
[   14.076349] device: 'ptyq5': device_add
[   14.080213] PM: Adding info for No Bus:ptyq5
[   14.084510] device: 'ptyq6': device_add
[   14.088376] PM: Adding info for No Bus:ptyq6
[   14.092673] device: 'ptyq7': device_add
[   14.096549] PM: Adding info for No Bus:ptyq7
[   14.100846] device: 'ptyq8': device_add
[   14.104728] PM: Adding info for No Bus:ptyq8
[   14.109066] device: 'ptyq9': device_add
[   14.112927] PM: Adding info for No Bus:ptyq9
[   14.117230] device: 'ptyqa': device_add
[   14.121116] PM: Adding info for No Bus:ptyqa
[   14.125412] device: 'ptyqb': device_add
[   14.129275] PM: Adding info for No Bus:ptyqb
[   14.133585] device: 'ptyqc': device_add
[   14.137448] PM: Adding info for No Bus:ptyqc
[   14.141744] device: 'ptyqd': device_add
[   14.145609] PM: Adding info for No Bus:ptyqd
[   14.149907] device: 'ptyqe': device_add
[   14.153846] PM: Adding info for No Bus:ptyqe
[   14.158150] device: 'ptyqf': device_add
[   14.162102] PM: Adding info for No Bus:ptyqf
[   14.166398] device: 'ptyr0': device_add
[   14.170269] PM: Adding info for No Bus:ptyr0
[   14.174569] device: 'ptyr1': device_add
[   14.178436] PM: Adding info for No Bus:ptyr1
[   14.182733] device: 'ptyr2': device_add
[   14.186602] PM: Adding info for No Bus:ptyr2
[   14.190921] device: 'ptyr3': device_add
[   14.194791] PM: Adding info for No Bus:ptyr3
[   14.199141] device: 'ptyr4': device_add
[   14.203057] PM: Adding info for No Bus:ptyr4
[   14.207358] device: 'ptyr5': device_add
[   14.211278] PM: Adding info for No Bus:ptyr5
[   14.215578] device: 'ptyr6': device_add
[   14.219452] PM: Adding info for No Bus:ptyr6
[   14.223752] device: 'ptyr7': device_add
[   14.228784] PM: Adding info for No Bus:ptyr7
[   14.233126] device: 'ptyr8': device_add
[   14.236998] PM: Adding info for No Bus:ptyr8
[   14.241309] device: 'ptyr9': device_add
[   14.245185] PM: Adding info for No Bus:ptyr9
[   14.249478] device: 'ptyra': device_add
[   14.253341] PM: Adding info for No Bus:ptyra
[   14.257643] device: 'ptyrb': device_add
[   14.261512] PM: Adding info for No Bus:ptyrb
[   14.265830] device: 'ptyrc': device_add
[   14.269730] PM: Adding info for No Bus:ptyrc
[   14.274077] device: 'ptyrd': device_add
[   14.277951] PM: Adding info for No Bus:ptyrd
[   14.282251] device: 'ptyre': device_add
[   14.286149] PM: Adding info for No Bus:ptyre
[   14.290451] device: 'ptyrf': device_add
[   14.294321] PM: Adding info for No Bus:ptyrf
[   14.298620] device: 'ptys0': device_add
[   14.302482] PM: Adding info for No Bus:ptys0
[   14.306783] device: 'ptys1': device_add
[   14.310657] PM: Adding info for No Bus:ptys1
[   14.314956] device: 'ptys2': device_add
[   14.318842] PM: Adding info for No Bus:ptys2
[   14.323150] device: 'ptys3': device_add
[   14.327081] PM: Adding info for No Bus:ptys3
[   14.331379] device: 'ptys4': device_add
[   14.335254] PM: Adding info for No Bus:ptys4
[   14.339559] device: 'ptys5': device_add
[   14.343424] PM: Adding info for No Bus:ptys5
[   14.347722] device: 'ptys6': device_add
[   14.351590] PM: Adding info for No Bus:ptys6
[   14.355908] device: 'ptys7': device_add
[   14.359806] PM: Adding info for No Bus:ptys7
[   14.364126] device: 'ptys8': device_add
[   14.368047] PM: Adding info for No Bus:ptys8
[   14.372343] device: 'ptys9': device_add
[   14.376235] PM: Adding info for No Bus:ptys9
[   14.380534] device: 'ptysa': device_add
[   14.384415] PM: Adding info for No Bus:ptysa
[   14.388716] device: 'ptysb': device_add
[   14.392585] PM: Adding info for No Bus:ptysb
[   14.396898] device: 'ptysc': device_add
[   14.400774] PM: Adding info for No Bus:ptysc
[   14.405108] device: 'ptysd': device_add
[   14.408978] PM: Adding info for No Bus:ptysd
[   14.413311] device: 'ptyse': device_add
[   14.417184] PM: Adding info for No Bus:ptyse
[   14.421503] device: 'ptysf': device_add
[   14.425396] PM: Adding info for No Bus:ptysf
[   14.429691] device: 'ptyt0': device_add
[   14.433567] PM: Adding info for No Bus:ptyt0
[   14.437863] device: 'ptyt1': device_add
[   14.441747] PM: Adding info for No Bus:ptyt1
[   14.446092] device: 'ptyt2': device_add
[   14.449969] PM: Adding info for No Bus:ptyt2
[   14.454275] device: 'ptyt3': device_add
[   14.458145] PM: Adding info for No Bus:ptyt3
[   14.462446] device: 'ptyt4': device_add
[   14.466319] PM: Adding info for No Bus:ptyt4
[   14.470618] device: 'ptyt5': device_add
[   14.474489] PM: Adding info for No Bus:ptyt5
[   14.478789] device: 'ptyt6': device_add
[   14.482680] PM: Adding info for No Bus:ptyt6
[   14.486980] device: 'ptyt7': device_add
[   14.490860] PM: Adding info for No Bus:ptyt7
[   14.495158] device: 'ptyt8': device_add
[   14.499085] PM: Adding info for No Bus:ptyt8
[   14.503394] device: 'ptyt9': device_add
[   14.507296] PM: Adding info for No Bus:ptyt9
[   14.511597] device: 'ptyta': device_add
[   14.515476] PM: Adding info for No Bus:ptyta
[   14.519777] device: 'ptytb': device_add
[   14.523652] PM: Adding info for No Bus:ptytb
[   14.527968] device: 'ptytc': device_add
[   14.531853] PM: Adding info for No Bus:ptytc
[   14.536153] device: 'ptytd': device_add
[   14.540103] PM: Adding info for No Bus:ptytd
[   14.544401] device: 'ptyte': device_add
[   14.548281] PM: Adding info for No Bus:ptyte
[   14.552582] device: 'ptytf': device_add
[   14.556469] PM: Adding info for No Bus:ptytf
[   14.560774] device: 'ptyu0': device_add
[   14.564655] PM: Adding info for No Bus:ptyu0
[   14.568952] device: 'ptyu1': device_add
[   14.572830] PM: Adding info for No Bus:ptyu1
[   14.577141] device: 'ptyu2': device_add
[   14.581056] PM: Adding info for No Bus:ptyu2
[   14.585353] device: 'ptyu3': device_add
[   14.589250] PM: Adding info for No Bus:ptyu3
[   14.593550] device: 'ptyu4': device_add
[   14.597430] PM: Adding info for No Bus:ptyu4
[   14.601731] device: 'ptyu5': device_add
[   14.605607] PM: Adding info for No Bus:ptyu5
[   14.609902] device: 'ptyu6': device_add
[   14.613788] PM: Adding info for No Bus:ptyu6
[   14.618122] device: 'ptyu7': device_add
[   14.622047] PM: Adding info for No Bus:ptyu7
[   14.626373] device: 'ptyu8': device_add
[   14.630258] PM: Adding info for No Bus:ptyu8
[   14.634556] device: 'ptyu9': device_add
[   14.638435] PM: Adding info for No Bus:ptyu9
[   14.642756] device: 'ptyua': device_add
[   14.646660] PM: Adding info for No Bus:ptyua
[   14.650973] device: 'ptyub': device_add
[   14.654857] PM: Adding info for No Bus:ptyub
[   14.659191] device: 'ptyuc': device_add
[   14.663111] PM: Adding info for No Bus:ptyuc
[   14.667414] device: 'ptyud': device_add
[   14.671301] PM: Adding info for No Bus:ptyud
[   14.675604] device: 'ptyue': device_add
[   14.679489] PM: Adding info for No Bus:ptyue
[   14.683793] device: 'ptyuf': device_add
[   14.687672] PM: Adding info for No Bus:ptyuf
[   14.691972] device: 'ptyv0': device_add
[   14.695895] PM: Adding info for No Bus:ptyv0
[   14.700201] device: 'ptyv1': device_add
[   14.704151] PM: Adding info for No Bus:ptyv1
[   14.708461] device: 'ptyv2': device_add
[   14.712344] PM: Adding info for No Bus:ptyv2
[   14.716642] device: 'ptyv3': device_add
[   14.720522] PM: Adding info for No Bus:ptyv3
[   14.724821] device: 'ptyv4': device_add
[   14.728712] PM: Adding info for No Bus:ptyv4
[   14.733052] device: 'ptyv5': device_add
[   14.736935] PM: Adding info for No Bus:ptyv5
[   14.741240] device: 'ptyv6': device_add
[   14.745141] PM: Adding info for No Bus:ptyv6
[   14.749440] device: 'ptyv7': device_add
[   14.753342] PM: Adding info for No Bus:ptyv7
[   14.757646] device: 'ptyv8': device_add
[   14.761532] PM: Adding info for No Bus:ptyv8
[   14.765833] device: 'ptyv9': device_add
[   14.769725] PM: Adding info for No Bus:ptyv9
[   14.774062] device: 'ptyva': device_add
[   14.777945] PM: Adding info for No Bus:ptyva
[   14.782255] device: 'ptyvb': device_add
[   14.786151] PM: Adding info for No Bus:ptyvb
[   14.790469] device: 'ptyvc': device_add
[   14.794359] PM: Adding info for No Bus:ptyvc
[   14.798657] device: 'ptyvd': device_add
[   14.802560] PM: Adding info for No Bus:ptyvd
[   14.806863] device: 'ptyve': device_add
[   14.810795] PM: Adding info for No Bus:ptyve
[   14.815121] device: 'ptyvf': device_add
[   14.819051] PM: Adding info for No Bus:ptyvf
[   14.823353] device: 'ptyw0': device_add
[   14.827237] PM: Adding info for No Bus:ptyw0
[   14.831535] device: 'ptyw1': device_add
[   14.835420] PM: Adding info for No Bus:ptyw1
[   14.839744] device: 'ptyw2': device_add
[   14.843642] PM: Adding info for No Bus:ptyw2
[   14.847951] device: 'ptyw3': device_add
[   14.851838] PM: Adding info for No Bus:ptyw3
[   14.856145] device: 'ptyw4': device_add
[   14.860095] PM: Adding info for No Bus:ptyw4
[   14.864393] device: 'ptyw5': device_add
[   14.868278] PM: Adding info for No Bus:ptyw5
[   14.872581] device: 'ptyw6': device_add
[   14.876467] PM: Adding info for No Bus:ptyw6
[   14.880788] device: 'ptyw7': device_add
[   14.884679] PM: Adding info for No Bus:ptyw7
[   14.888978] device: 'ptyw8': device_add
[   14.892871] PM: Adding info for No Bus:ptyw8
[   14.897174] device: 'ptyw9': device_add
[   14.901109] PM: Adding info for No Bus:ptyw9
[   14.905416] device: 'ptywa': device_add
[   14.909308] PM: Adding info for No Bus:ptywa
[   14.913612] device: 'ptywb': device_add
[   14.917516] PM: Adding info for No Bus:ptywb
[   14.921830] device: 'ptywc': device_add
[   14.925724] PM: Adding info for No Bus:ptywc
[   14.930085] device: 'ptywd': device_add
[   14.933978] PM: Adding info for No Bus:ptywd
[   14.938290] device: 'ptywe': device_add
[   14.942177] PM: Adding info for No Bus:ptywe
[   14.946480] device: 'ptywf': device_add
[   14.950367] PM: Adding info for No Bus:ptywf
[   14.954668] device: 'ptyx0': device_add
[   14.958592] PM: Adding info for No Bus:ptyx0
[   14.962898] device: 'ptyx1': device_add
[   14.967991] PM: Adding info for No Bus:ptyx1
[   14.972303] device: 'ptyx2': device_add
[   14.976201] PM: Adding info for No Bus:ptyx2
[   14.980500] device: 'ptyx3': device_add
[   14.984392] PM: Adding info for No Bus:ptyx3
[   14.988698] device: 'ptyx4': device_add
[   14.992586] PM: Adding info for No Bus:ptyx4
[   14.996884] device: 'ptyx5': device_add
[   15.000783] PM: Adding info for No Bus:ptyx5
[   15.005119] device: 'ptyx6': device_add
[   15.009066] PM: Adding info for No Bus:ptyx6
[   15.013368] device: 'ptyx7': device_add
[   15.017281] PM: Adding info for No Bus:ptyx7
[   15.021583] device: 'ptyx8': device_add
[   15.025504] PM: Adding info for No Bus:ptyx8
[   15.029806] device: 'ptyx9': device_add
[   15.033705] PM: Adding info for No Bus:ptyx9
[   15.038051] device: 'ptyxa': device_add
[   15.041947] PM: Adding info for No Bus:ptyxa
[   15.046253] device: 'ptyxb': device_add
[   15.050161] PM: Adding info for No Bus:ptyxb
[   15.054503] device: 'ptyxc': device_add
[   15.058409] PM: Adding info for No Bus:ptyxc
[   15.062716] device: 'ptyxd': device_add
[   15.066609] PM: Adding info for No Bus:ptyxd
[   15.070912] device: 'ptyxe': device_add
[   15.074840] PM: Adding info for No Bus:ptyxe
[   15.079150] device: 'ptyxf': device_add
[   15.083093] PM: Adding info for No Bus:ptyxf
[   15.087390] device: 'ptyy0': device_add
[   15.091284] PM: Adding info for No Bus:ptyy0
[   15.095579] device: 'ptyy1': device_add
[   15.099477] PM: Adding info for No Bus:ptyy1
[   15.103779] device: 'ptyy2': device_add
[   15.107697] PM: Adding info for No Bus:ptyy2
[   15.112062] device: 'ptyy3': device_add
[   15.115962] PM: Adding info for No Bus:ptyy3
[   15.120269] device: 'ptyy4': device_add
[   15.124169] PM: Adding info for No Bus:ptyy4
[   15.128474] device: 'ptyy5': device_add
[   15.132401] PM: Adding info for No Bus:ptyy5
[   15.136708] device: 'ptyy6': device_add
[   15.140612] PM: Adding info for No Bus:ptyy6
[   15.144916] device: 'ptyy7': device_add
[   15.148818] PM: Adding info for No Bus:ptyy7
[   15.153135] device: 'ptyy8': device_add
[   15.157080] PM: Adding info for No Bus:ptyy8
[   15.161385] device: 'ptyy9': device_add
[   15.165285] PM: Adding info for No Bus:ptyy9
[   15.169583] device: 'ptyya': device_add
[   15.173484] PM: Adding info for No Bus:ptyya
[   15.177793] device: 'ptyyb': device_add
[   15.181716] PM: Adding info for No Bus:ptyyb
[   15.186072] device: 'ptyyc': device_add
[   15.189984] PM: Adding info for No Bus:ptyyc
[   15.194300] device: 'ptyyd': device_add
[   15.198203] PM: Adding info for No Bus:ptyyd
[   15.202503] device: 'ptyye': device_add
[   15.206397] PM: Adding info for No Bus:ptyye
[   15.210701] device: 'ptyyf': device_add
[   15.214595] PM: Adding info for No Bus:ptyyf
[   15.218914] device: 'ptyz0': device_add
[   15.222819] PM: Adding info for No Bus:ptyz0
[   15.227137] device: 'ptyz1': device_add
[   15.231091] PM: Adding info for No Bus:ptyz1
[   15.235397] device: 'ptyz2': device_add
[   15.239315] PM: Adding info for No Bus:ptyz2
[   15.243619] device: 'ptyz3': device_add
[   15.247528] PM: Adding info for No Bus:ptyz3
[   15.251835] device: 'ptyz4': device_add
[   15.255740] PM: Adding info for No Bus:ptyz4
[   15.260111] device: 'ptyz5': device_add
[   15.264076] PM: Adding info for No Bus:ptyz5
[   15.268409] device: 'ptyz6': device_add
[   15.272323] PM: Adding info for No Bus:ptyz6
[   15.276633] device: 'ptyz7': device_add
[   15.280537] PM: Adding info for No Bus:ptyz7
[   15.284842] device: 'ptyz8': device_add
[   15.288745] PM: Adding info for No Bus:ptyz8
[   15.293088] device: 'ptyz9': device_add
[   15.297067] PM: Adding info for No Bus:ptyz9
[   15.301374] device: 'ptyza': device_add
[   15.305294] PM: Adding info for No Bus:ptyza
[   15.309602] device: 'ptyzb': device_add
[   15.313549] PM: Adding info for No Bus:ptyzb
[   15.317869] device: 'ptyzc': device_add
[   15.321801] PM: Adding info for No Bus:ptyzc
[   15.326132] device: 'ptyzd': device_add
[   15.330105] PM: Adding info for No Bus:ptyzd
[   15.334405] device: 'ptyze': device_add
[   15.338336] PM: Adding info for No Bus:ptyze
[   15.342653] device: 'ptyzf': device_add
[   15.346584] PM: Adding info for No Bus:ptyzf
[   15.350890] device: 'ptya0': device_add
[   15.354803] PM: Adding info for No Bus:ptya0
[   15.359139] device: 'ptya1': device_add
[   15.363112] PM: Adding info for No Bus:ptya1
[   15.367428] device: 'ptya2': device_add
[   15.371347] PM: Adding info for No Bus:ptya2
[   15.375654] device: 'ptya3': device_add
[   15.379559] PM: Adding info for No Bus:ptya3
[   15.383859] device: 'ptya4': device_add
[   15.387773] PM: Adding info for No Bus:ptya4
[   15.392117] device: 'ptya5': device_add
[   15.396086] PM: Adding info for No Bus:ptya5
[   15.400390] device: 'ptya6': device_add
[   15.404320] PM: Adding info for No Bus:ptya6
[   15.408627] device: 'ptya7': device_add
[   15.412568] PM: Adding info for No Bus:ptya7
[   15.416875] device: 'ptya8': device_add
[   15.420798] PM: Adding info for No Bus:ptya8
[   15.425142] device: 'ptya9': device_add
[   15.429109] PM: Adding info for No Bus:ptya9
[   15.433416] device: 'ptyaa': device_add
[   15.437332] PM: Adding info for No Bus:ptyaa
[   15.441640] device: 'ptyab': device_add
[   15.445555] PM: Adding info for No Bus:ptyab
[   15.449891] device: 'ptyac': device_add
[   15.453835] PM: Adding info for No Bus:ptyac
[   15.458151] device: 'ptyad': device_add
[   15.462128] PM: Adding info for No Bus:ptyad
[   15.466432] device: 'ptyae': device_add
[   15.470353] PM: Adding info for No Bus:ptyae
[   15.474655] device: 'ptyaf': device_add
[   15.478583] PM: Adding info for No Bus:ptyaf
[   15.482925] device: 'ptyb0': device_add
[   15.486844] PM: Adding info for No Bus:ptyb0
[   15.491153] device: 'ptyb1': device_add
[   15.495117] PM: Adding info for No Bus:ptyb1
[   15.499421] device: 'ptyb2': device_add
[   15.503339] PM: Adding info for No Bus:ptyb2
[   15.507661] device: 'ptyb3': device_add
[   15.511600] PM: Adding info for No Bus:ptyb3
[   15.515912] device: 'ptyb4': device_add
[   15.519825] PM: Adding info for No Bus:ptyb4
[   15.524143] device: 'ptyb5': device_add
[   15.528099] PM: Adding info for No Bus:ptyb5
[   15.532413] device: 'ptyb6': device_add
[   15.536335] PM: Adding info for No Bus:ptyb6
[   15.540645] device: 'ptyb7': device_add
[   15.544569] PM: Adding info for No Bus:ptyb7
[   15.548872] device: 'ptyb8': device_add
[   15.552777] PM: Adding info for No Bus:ptyb8
[   15.557124] device: 'ptyb9': device_add
[   15.561126] PM: Adding info for No Bus:ptyb9
[   15.565431] device: 'ptyba': device_add
[   15.569360] PM: Adding info for No Bus:ptyba
[   15.573678] device: 'ptybb': device_add
[   15.577599] PM: Adding info for No Bus:ptybb
[   15.581918] device: 'ptybc': device_add
[   15.585847] PM: Adding info for No Bus:ptybc
[   15.590157] device: 'ptybd': device_add
[   15.594136] PM: Adding info for No Bus:ptybd
[   15.598447] device: 'ptybe': device_add
[   15.602369] PM: Adding info for No Bus:ptybe
[   15.606678] device: 'ptybf': device_add
[   15.610603] PM: Adding info for No Bus:ptybf
[   15.614909] device: 'ptyc0': device_add
[   15.618854] PM: Adding info for No Bus:ptyc0
[   15.623162] device: 'ptyc1': device_add
[   15.627135] PM: Adding info for No Bus:ptyc1
[   15.631443] device: 'ptyc2': device_add
[   15.635368] PM: Adding info for No Bus:ptyc2
[   15.639676] device: 'ptyc3': device_add
[   15.643598] PM: Adding info for No Bus:ptyc3
[   15.647906] device: 'ptyc4': device_add
[   15.651838] PM: Adding info for No Bus:ptyc4
[   15.656154] device: 'ptyc5': device_add
[   15.660124] PM: Adding info for No Bus:ptyc5
[   15.664431] device: 'ptyc6': device_add
[   15.668361] PM: Adding info for No Bus:ptyc6
[   15.672674] device: 'ptyc7': device_add
[   15.676615] PM: Adding info for No Bus:ptyc7
[   15.680922] device: 'ptyc8': device_add
[   15.684842] PM: Adding info for No Bus:ptyc8
[   15.689149] device: 'ptyc9': device_add
[   15.693128] PM: Adding info for No Bus:ptyc9
[   15.697464] device: 'ptyca': device_add
[   15.701408] PM: Adding info for No Bus:ptyca
[   15.705720] device: 'ptycb': device_add
[   15.710868] PM: Adding info for No Bus:ptycb
[   15.715192] device: 'ptycc': device_add
[   15.719166] PM: Adding info for No Bus:ptycc
[   15.723479] device: 'ptycd': device_add
[   15.727422] PM: Adding info for No Bus:ptycd
[   15.731728] device: 'ptyce': device_add
[   15.735655] PM: Adding info for No Bus:ptyce
[   15.739959] device: 'ptycf': device_add
[   15.743884] PM: Adding info for No Bus:ptycf
[   15.748191] device: 'ptyd0': device_add
[   15.752163] PM: Adding info for No Bus:ptyd0
[   15.756474] device: 'ptyd1': device_add
[   15.760406] PM: Adding info for No Bus:ptyd1
[   15.764716] device: 'ptyd2': device_add
[   15.768652] PM: Adding info for No Bus:ptyd2
[   15.772962] device: 'ptyd3': device_add
[   15.776894] PM: Adding info for No Bus:ptyd3
[   15.781206] device: 'ptyd4': device_add
[   15.785202] PM: Adding info for No Bus:ptyd4
[   15.789512] device: 'ptyd5': device_add
[   15.793449] PM: Adding info for No Bus:ptyd5
[   15.797773] device: 'ptyd6': device_add
[   15.801708] PM: Adding info for No Bus:ptyd6
[   15.806077] device: 'ptyd7': device_add
[   15.810062] PM: Adding info for No Bus:ptyd7
[   15.814370] device: 'ptyd8': device_add
[   15.818299] PM: Adding info for No Bus:ptyd8
[   15.822611] device: 'ptyd9': device_add
[   15.826560] PM: Adding info for No Bus:ptyd9
[   15.830870] device: 'ptyda': device_add
[   15.834824] PM: Adding info for No Bus:ptyda
[   15.839147] device: 'ptydb': device_add
[   15.843120] PM: Adding info for No Bus:ptydb
[   15.847440] device: 'ptydc': device_add
[   15.851378] PM: Adding info for No Bus:ptydc
[   15.855685] device: 'ptydd': device_add
[   15.859614] PM: Adding info for No Bus:ptydd
[   15.863952] device: 'ptyde': device_add
[   15.867926] PM: Adding info for No Bus:ptyde
[   15.872248] device: 'ptydf': device_add
[   15.876205] PM: Adding info for No Bus:ptydf
[   15.880520] device: 'ptye0': device_add
[   15.884465] PM: Adding info for No Bus:ptye0
[   15.888782] device: 'ptye1': device_add
[   15.892744] PM: Adding info for No Bus:ptye1
[   15.897096] device: 'ptye2': device_add
[   15.901076] PM: Adding info for No Bus:ptye2
[   15.905390] device: 'ptye3': device_add
[   15.909324] PM: Adding info for No Bus:ptye3
[   15.913661] device: 'ptye4': device_add
[   15.917607] PM: Adding info for No Bus:ptye4
[   15.921914] device: 'ptye5': device_add
[   15.925857] PM: Adding info for No Bus:ptye5
[   15.930171] device: 'ptye6': device_add
[   15.934149] PM: Adding info for No Bus:ptye6
[   15.938463] device: 'ptye7': device_add
[   15.942425] PM: Adding info for No Bus:ptye7
[   15.946744] device: 'ptye8': device_add
[   15.950688] PM: Adding info for No Bus:ptye8
[   15.954999] device: 'ptye9': device_add
[   15.958946] PM: Adding info for No Bus:ptye9
[   15.963265] device: 'ptyea': device_add
[   15.967206] PM: Adding info for No Bus:ptyea
[   15.971513] device: 'ptyeb': device_add
[   15.975452] PM: Adding info for No Bus:ptyeb
[   15.979777] device: 'ptyec': device_add
[   15.983723] PM: Adding info for No Bus:ptyec
[   15.988081] device: 'ptyed': device_add
[   15.992063] PM: Adding info for No Bus:ptyed
[   15.996373] device: 'ptyee': device_add
[   16.000342] PM: Adding info for No Bus:ptyee
[   16.004658] device: 'ptyef': device_add
[   16.008602] PM: Adding info for No Bus:ptyef
[   16.012942] device: 'ttyp0': device_add
[   16.016911] PM: Adding info for No Bus:ttyp0
[   16.021228] device: 'ttyp1': device_add
[   16.025190] PM: Adding info for No Bus:ttyp1
[   16.029520] device: 'ttyp2': device_add
[   16.033451] PM: Adding info for No Bus:ttyp2
[   16.037761] device: 'ttyp3': device_add
[   16.041689] PM: Adding info for No Bus:ttyp3
[   16.046043] device: 'ttyp4': device_add
[   16.049976] PM: Adding info for No Bus:ttyp4
[   16.054294] device: 'ttyp5': device_add
[   16.058264] PM: Adding info for No Bus:ttyp5
[   16.062582] device: 'ttyp6': device_add
[   16.066519] PM: Adding info for No Bus:ttyp6
[   16.070828] device: 'ttyp7': device_add
[   16.074768] PM: Adding info for No Bus:ttyp7
[   16.079117] device: 'ttyp8': device_add
[   16.083098] PM: Adding info for No Bus:ttyp8
[   16.087428] device: 'ttyp9': device_add
[   16.091373] PM: Adding info for No Bus:ttyp9
[   16.095689] device: 'ttypa': device_add
[   16.099621] PM: Adding info for No Bus:ttypa
[   16.103936] device: 'ttypb': device_add
[   16.107895] PM: Adding info for No Bus:ttypb
[   16.112223] device: 'ttypc': device_add
[   16.116198] PM: Adding info for No Bus:ttypc
[   16.120516] device: 'ttypd': device_add
[   16.124455] PM: Adding info for No Bus:ttypd
[   16.128794] device: 'ttype': device_add
[   16.132740] PM: Adding info for No Bus:ttype
[   16.137102] device: 'ttypf': device_add
[   16.141096] PM: Adding info for No Bus:ttypf
[   16.145407] device: 'ttyq0': device_add
[   16.149352] PM: Adding info for No Bus:ttyq0
[   16.153667] device: 'ttyq1': device_add
[   16.157619] PM: Adding info for No Bus:ttyq1
[   16.161934] device: 'ttyq2': device_add
[   16.165948] PM: Adding info for No Bus:ttyq2
[   16.170275] device: 'ttyq3': device_add
[   16.174233] PM: Adding info for No Bus:ttyq3
[   16.178548] device: 'ttyq4': device_add
[   16.182498] PM: Adding info for No Bus:ttyq4
[   16.186811] device: 'ttyq5': device_add
[   16.190755] PM: Adding info for No Bus:ttyq5
[   16.195113] device: 'ttyq6': device_add
[   16.199101] PM: Adding info for No Bus:ttyq6
[   16.203411] device: 'ttyq7': device_add
[   16.207359] PM: Adding info for No Bus:ttyq7
[   16.211671] device: 'ttyq8': device_add
[   16.215631] PM: Adding info for No Bus:ttyq8
[   16.219948] device: 'ttyq9': device_add
[   16.223907] PM: Adding info for No Bus:ttyq9
[   16.228224] device: 'ttyqa': device_add
[   16.232205] PM: Adding info for No Bus:ttyqa
[   16.236519] device: 'ttyqb': device_add
[   16.240469] PM: Adding info for No Bus:ttyqb
[   16.244798] device: 'ttyqc': device_add
[   16.248751] PM: Adding info for No Bus:ttyqc
[   16.253110] device: 'ttyqd': device_add
[   16.257099] PM: Adding info for No Bus:ttyqd
[   16.261426] device: 'ttyqe': device_add
[   16.265376] PM: Adding info for No Bus:ttyqe
[   16.269687] device: 'ttyqf': device_add
[   16.273653] PM: Adding info for No Bus:ttyqf
[   16.277973] device: 'ttyr0': device_add
[   16.281926] PM: Adding info for No Bus:ttyr0
[   16.286247] device: 'ttyr1': device_add
[   16.290225] PM: Adding info for No Bus:ttyr1
[   16.294543] device: 'ttyr2': device_add
[   16.298491] PM: Adding info for No Bus:ttyr2
[   16.302810] device: 'ttyr3': device_add
[   16.306761] PM: Adding info for No Bus:ttyr3
[   16.311110] device: 'ttyr4': device_add
[   16.315133] PM: Adding info for No Bus:ttyr4
[   16.319451] device: 'ttyr5': device_add
[   16.323427] PM: Adding info for No Bus:ttyr5
[   16.327745] device: 'ttyr6': device_add
[   16.331701] PM: Adding info for No Bus:ttyr6
[   16.336063] device: 'ttyr7': device_add
[   16.340066] PM: Adding info for No Bus:ttyr7
[   16.344406] device: 'ttyr8': device_add
[   16.348374] PM: Adding info for No Bus:ttyr8
[   16.352699] device: 'ttyr9': device_add
[   16.356667] PM: Adding info for No Bus:ttyr9
[   16.360985] device: 'ttyra': device_add
[   16.364943] PM: Adding info for No Bus:ttyra
[   16.369269] device: 'ttyrb': device_add
[   16.373228] PM: Adding info for No Bus:ttyrb
[   16.377570] device: 'ttyrc': device_add
[   16.381548] PM: Adding info for No Bus:ttyrc
[   16.385864] device: 'ttyrd': device_add
[   16.389826] PM: Adding info for No Bus:ttyrd
[   16.394154] device: 'ttyre': device_add
[   16.398191] PM: Adding info for No Bus:ttyre
[   16.402506] device: 'ttyrf': device_add
[   16.406478] PM: Adding info for No Bus:ttyrf
[   16.410798] device: 'ttys0': device_add
[   16.414766] PM: Adding info for No Bus:ttys0
[   16.419120] device: 'ttys1': device_add
[   16.423132] PM: Adding info for No Bus:ttys1
[   16.427446] device: 'ttys2': device_add
[   16.431408] PM: Adding info for No Bus:ttys2
[   16.435721] device: 'ttys3': device_add
[   16.439699] PM: Adding info for No Bus:ttys3
[   16.444055] device: 'ttys4': device_add
[   16.448057] PM: Adding info for No Bus:ttys4
[   16.452367] device: 'ttys5': device_add
[   16.457488] PM: Adding info for No Bus:ttys5
[   16.461803] device: 'ttys6': device_add
[   16.465770] PM: Adding info for No Bus:ttys6
[   16.470168] device: 'ttys7': device_add
[   16.474190] PM: Adding info for No Bus:ttys7
[   16.478505] device: 'ttys8': device_add
[   16.482474] PM: Adding info for No Bus:ttys8
[   16.486786] device: 'ttys9': device_add
[   16.490828] PM: Adding info for No Bus:ttys9
[   16.495170] device: 'ttysa': device_add
[   16.499211] PM: Adding info for No Bus:ttysa
[   16.503529] device: 'ttysb': device_add
[   16.507511] PM: Adding info for No Bus:ttysb
[   16.511844] device: 'ttysc': device_add
[   16.515809] PM: Adding info for No Bus:ttysc
[   16.520142] device: 'ttysd': device_add
[   16.524157] PM: Adding info for No Bus:ttysd
[   16.528478] device: 'ttyse': device_add
[   16.532442] PM: Adding info for No Bus:ttyse
[   16.536759] device: 'ttysf': device_add
[   16.540713] PM: Adding info for No Bus:ttysf
[   16.545066] device: 'ttyt0': device_add
[   16.549111] PM: Adding info for No Bus:ttyt0
[   16.553423] device: 'ttyt1': device_add
[   16.557403] PM: Adding info for No Bus:ttyt1
[   16.561749] device: 'ttyt2': device_add
[   16.565724] PM: Adding info for No Bus:ttyt2
[   16.570088] device: 'ttyt3': device_add
[   16.574099] PM: Adding info for No Bus:ttyt3
[   16.578412] device: 'ttyt4': device_add
[   16.582383] PM: Adding info for No Bus:ttyt4
[   16.586699] device: 'ttyt5': device_add
[   16.590660] PM: Adding info for No Bus:ttyt5
[   16.594971] device: 'ttyt6': device_add
[   16.598954] PM: Adding info for No Bus:ttyt6
[   16.603284] device: 'ttyt7': device_add
[   16.607248] PM: Adding info for No Bus:ttyt7
[   16.611566] device: 'ttyt8': device_add
[   16.615533] PM: Adding info for No Bus:ttyt8
[   16.619851] device: 'ttyt9': device_add
[   16.623844] PM: Adding info for No Bus:ttyt9
[   16.628166] device: 'ttyta': device_add
[   16.632188] PM: Adding info for No Bus:ttyta
[   16.636503] device: 'ttytb': device_add
[   16.640488] PM: Adding info for No Bus:ttytb
[   16.644822] device: 'ttytc': device_add
[   16.648802] PM: Adding info for No Bus:ttytc
[   16.653141] device: 'ttytd': device_add
[   16.657180] PM: Adding info for No Bus:ttytd
[   16.661497] device: 'ttyte': device_add
[   16.665477] PM: Adding info for No Bus:ttyte
[   16.669813] device: 'ttytf': device_add
[   16.673797] PM: Adding info for No Bus:ttytf
[   16.678143] device: 'ttyu0': device_add
[   16.682155] PM: Adding info for No Bus:ttyu0
[   16.686470] device: 'ttyu1': device_add
[   16.690448] PM: Adding info for No Bus:ttyu1
[   16.694764] device: 'ttyu2': device_add
[   16.698745] PM: Adding info for No Bus:ttyu2
[   16.703107] device: 'ttyu3': device_add
[   16.707183] PM: Adding info for No Bus:ttyu3
[   16.711511] device: 'ttyu4': device_add
[   16.715503] PM: Adding info for No Bus:ttyu4
[   16.719821] device: 'ttyu5': device_add
[   16.723803] PM: Adding info for No Bus:ttyu5
[   16.728157] device: 'ttyu6': device_add
[   16.732179] PM: Adding info for No Bus:ttyu6
[   16.736494] device: 'ttyu7': device_add
[   16.740470] PM: Adding info for No Bus:ttyu7
[   16.744785] device: 'ttyu8': device_add
[   16.748760] PM: Adding info for No Bus:ttyu8
[   16.753124] device: 'ttyu9': device_add
[   16.757157] PM: Adding info for No Bus:ttyu9
[   16.761479] device: 'ttyua': device_add
[   16.765485] PM: Adding info for No Bus:ttyua
[   16.769803] device: 'ttyub': device_add
[   16.773814] PM: Adding info for No Bus:ttyub
[   16.778186] device: 'ttyuc': device_add
[   16.782229] PM: Adding info for No Bus:ttyuc
[   16.786547] device: 'ttyud': device_add
[   16.790530] PM: Adding info for No Bus:ttyud
[   16.794845] device: 'ttyue': device_add
[   16.798833] PM: Adding info for No Bus:ttyue
[   16.803154] device: 'ttyuf': device_add
[   16.807180] PM: Adding info for No Bus:ttyuf
[   16.811499] device: 'ttyv0': device_add
[   16.815487] PM: Adding info for No Bus:ttyv0
[   16.819809] device: 'ttyv1': device_add
[   16.823817] PM: Adding info for No Bus:ttyv1
[   16.828153] device: 'ttyv2': device_add
[   16.832188] PM: Adding info for No Bus:ttyv2
[   16.836508] device: 'ttyv3': device_add
[   16.840491] PM: Adding info for No Bus:ttyv3
[   16.844809] device: 'ttyv4': device_add
[   16.848790] PM: Adding info for No Bus:ttyv4
[   16.853134] device: 'ttyv5': device_add
[   16.857180] PM: Adding info for No Bus:ttyv5
[   16.861499] device: 'ttyv6': device_add
[   16.865488] PM: Adding info for No Bus:ttyv6
[   16.869807] device: 'ttyv7': device_add
[   16.873825] PM: Adding info for No Bus:ttyv7
[   16.878161] device: 'ttyv8': device_add
[   16.882194] PM: Adding info for No Bus:ttyv8
[   16.886515] device: 'ttyv9': device_add
[   16.890508] PM: Adding info for No Bus:ttyv9
[   16.894824] device: 'ttyva': device_add
[   16.898813] PM: Adding info for No Bus:ttyva
[   16.903149] device: 'ttyvb': device_add
[   16.907172] PM: Adding info for No Bus:ttyvb
[   16.911500] device: 'ttyvc': device_add
[   16.915492] PM: Adding info for No Bus:ttyvc
[   16.919809] device: 'ttyvd': device_add
[   16.923819] PM: Adding info for No Bus:ttyvd
[   16.928154] device: 'ttyve': device_add
[   16.932257] PM: Adding info for No Bus:ttyve
[   16.936583] device: 'ttyvf': device_add
[   16.940583] PM: Adding info for No Bus:ttyvf
[   16.944901] device: 'ttyw0': device_add
[   16.948895] PM: Adding info for No Bus:ttyw0
[   16.953212] device: 'ttyw1': device_add
[   16.957268] PM: Adding info for No Bus:ttyw1
[   16.961624] device: 'ttyw2': device_add
[   16.965630] PM: Adding info for No Bus:ttyw2
[   16.969953] device: 'ttyw3': device_add
[   16.973945] PM: Adding info for No Bus:ttyw3
[   16.978269] device: 'ttyw4': device_add
[   16.982279] PM: Adding info for No Bus:ttyw4
[   16.986601] device: 'ttyw5': device_add
[   16.990607] PM: Adding info for No Bus:ttyw5
[   16.994968] device: 'ttyw6': device_add
[   16.998984] PM: Adding info for No Bus:ttyw6
[   17.003316] device: 'ttyw7': device_add
[   17.007313] PM: Adding info for No Bus:ttyw7
[   17.011635] device: 'ttyw8': device_add
[   17.015634] PM: Adding info for No Bus:ttyw8
[   17.019952] device: 'ttyw9': device_add
[   17.023952] PM: Adding info for No Bus:ttyw9
[   17.028280] device: 'ttywa': device_add
[   17.032279] PM: Adding info for No Bus:ttywa
[   17.036597] device: 'ttywb': device_add
[   17.040616] PM: Adding info for No Bus:ttywb
[   17.044944] device: 'ttywc': device_add
[   17.048953] PM: Adding info for No Bus:ttywc
[   17.053285] device: 'ttywd': device_add
[   17.057285] PM: Adding info for No Bus:ttywd
[   17.061607] device: 'ttywe': device_add
[   17.065602] PM: Adding info for No Bus:ttywe
[   17.069926] device: 'ttywf': device_add
[   17.073934] PM: Adding info for No Bus:ttywf
[   17.078295] device: 'ttyx0': device_add
[   17.082305] PM: Adding info for No Bus:ttyx0
[   17.086624] device: 'ttyx1': device_add
[   17.090649] PM: Adding info for No Bus:ttyx1
[   17.094969] device: 'ttyx2': device_add
[   17.098985] PM: Adding info for No Bus:ttyx2
[   17.103313] device: 'ttyx3': device_add
[   17.107332] PM: Adding info for No Bus:ttyx3
[   17.111651] device: 'ttyx4': device_add
[   17.115671] PM: Adding info for No Bus:ttyx4
[   17.119995] device: 'ttyx5': device_add
[   17.124053] PM: Adding info for No Bus:ttyx5
[   17.128369] device: 'ttyx6': device_add
[   17.132372] PM: Adding info for No Bus:ttyx6
[   17.136691] device: 'ttyx7': device_add
[   17.140689] PM: Adding info for No Bus:ttyx7
[   17.145050] device: 'ttyx8': device_add
[   17.149128] PM: Adding info for No Bus:ttyx8
[   17.153448] device: 'ttyx9': device_add
[   17.157463] PM: Adding info for No Bus:ttyx9
[   17.161785] device: 'ttyxa': device_add
[   17.165810] PM: Adding info for No Bus:ttyxa
[   17.170160] device: 'ttyxb': device_add
[   17.174222] PM: Adding info for No Bus:ttyxb
[   17.178556] device: 'ttyxc': device_add
[   17.182580] PM: Adding info for No Bus:ttyxc
[   17.186900] device: 'ttyxd': device_add
[   17.190913] PM: Adding info for No Bus:ttyxd
[   17.195252] device: 'ttyxe': device_add
[   17.199282] PM: Adding info for No Bus:ttyxe
[   17.203604] device: 'ttyxf': device_add
[   17.208806] PM: Adding info for No Bus:ttyxf
[   17.213173] device: 'ttyy0': device_add
[   17.217248] PM: Adding info for No Bus:ttyy0
[   17.221567] device: 'ttyy1': device_add
[   17.225592] PM: Adding info for No Bus:ttyy1
[   17.229916] device: 'ttyy2': device_add
[   17.233958] PM: Adding info for No Bus:ttyy2
[   17.238293] device: 'ttyy3': device_add
[   17.242306] PM: Adding info for No Bus:ttyy3
[   17.246627] device: 'ttyy4': device_add
[   17.250654] PM: Adding info for No Bus:ttyy4
[   17.254989] device: 'ttyy5': device_add
[   17.259096] PM: Adding info for No Bus:ttyy5
[   17.263419] device: 'ttyy6': device_add
[   17.267441] PM: Adding info for No Bus:ttyy6
[   17.271765] device: 'ttyy7': device_add
[   17.275782] PM: Adding info for No Bus:ttyy7
[   17.280136] device: 'ttyy8': device_add
[   17.284200] PM: Adding info for No Bus:ttyy8
[   17.288526] device: 'ttyy9': device_add
[   17.292549] PM: Adding info for No Bus:ttyy9
[   17.296868] device: 'ttyya': device_add
[   17.300881] PM: Adding info for No Bus:ttyya
[   17.305202] device: 'ttyyb': device_add
[   17.309258] PM: Adding info for No Bus:ttyyb
[   17.313591] device: 'ttyyc': device_add
[   17.317635] PM: Adding info for No Bus:ttyyc
[   17.321953] device: 'ttyyd': device_add
[   17.325972] PM: Adding info for No Bus:ttyyd
[   17.330300] device: 'ttyye': device_add
[   17.334326] PM: Adding info for No Bus:ttyye
[   17.338646] device: 'ttyyf': device_add
[   17.342667] PM: Adding info for No Bus:ttyyf
[   17.346994] device: 'ttyz0': device_add
[   17.351073] PM: Adding info for No Bus:ttyz0
[   17.355389] device: 'ttyz1': device_add
[   17.359413] PM: Adding info for No Bus:ttyz1
[   17.363729] device: 'ttyz2': device_add
[   17.367763] PM: Adding info for No Bus:ttyz2
[   17.372125] device: 'ttyz3': device_add
[   17.376198] PM: Adding info for No Bus:ttyz3
[   17.380523] device: 'ttyz4': device_add
[   17.384570] PM: Adding info for No Bus:ttyz4
[   17.388894] device: 'ttyz5': device_add
[   17.392914] PM: Adding info for No Bus:ttyz5
[   17.397237] device: 'ttyz6': device_add
[   17.401284] PM: Adding info for No Bus:ttyz6
[   17.405614] device: 'ttyz7': device_add
[   17.409640] PM: Adding info for No Bus:ttyz7
[   17.413963] device: 'ttyz8': device_add
[   17.417987] PM: Adding info for No Bus:ttyz8
[   17.422323] device: 'ttyz9': device_add
[   17.426376] PM: Adding info for No Bus:ttyz9
[   17.430733] device: 'ttyza': device_add
[   17.434778] PM: Adding info for No Bus:ttyza
[   17.439135] device: 'ttyzb': device_add
[   17.443204] PM: Adding info for No Bus:ttyzb
[   17.447535] device: 'ttyzc': device_add
[   17.451570] PM: Adding info for No Bus:ttyzc
[   17.455894] device: 'ttyzd': device_add
[   17.459926] PM: Adding info for No Bus:ttyzd
[   17.464260] device: 'ttyze': device_add
[   17.468319] PM: Adding info for No Bus:ttyze
[   17.472642] device: 'ttyzf': device_add
[   17.476692] PM: Adding info for No Bus:ttyzf
[   17.481058] device: 'ttya0': device_add
[   17.485141] PM: Adding info for No Bus:ttya0
[   17.489461] device: 'ttya1': device_add
[   17.493490] PM: Adding info for No Bus:ttya1
[   17.497815] device: 'ttya2': device_add
[   17.501850] PM: Adding info for No Bus:ttya2
[   17.506172] device: 'ttya3': device_add
[   17.510244] PM: Adding info for No Bus:ttya3
[   17.514564] device: 'ttya4': device_add
[   17.518599] PM: Adding info for No Bus:ttya4
[   17.522925] device: 'ttya5': device_add
[   17.526962] PM: Adding info for No Bus:ttya5
[   17.531287] device: 'ttya6': device_add
[   17.535359] PM: Adding info for No Bus:ttya6
[   17.539677] device: 'ttya7': device_add
[   17.543714] PM: Adding info for No Bus:ttya7
[   17.548099] device: 'ttya8': device_add
[   17.552183] PM: Adding info for No Bus:ttya8
[   17.556503] device: 'ttya9': device_add
[   17.560554] PM: Adding info for No Bus:ttya9
[   17.564878] device: 'ttyaa': device_add
[   17.568923] PM: Adding info for No Bus:ttyaa
[   17.573247] device: 'ttyab': device_add
[   17.577297] PM: Adding info for No Bus:ttyab
[   17.581638] device: 'ttyac': device_add
[   17.585681] PM: Adding info for No Bus:ttyac
[   17.590051] device: 'ttyad': device_add
[   17.594159] PM: Adding info for No Bus:ttyad
[   17.598478] device: 'ttyae': device_add
[   17.602515] PM: Adding info for No Bus:ttyae
[   17.606842] device: 'ttyaf': device_add
[   17.610878] PM: Adding info for No Bus:ttyaf
[   17.615203] device: 'ttyb0': device_add
[   17.619280] PM: Adding info for No Bus:ttyb0
[   17.623600] device: 'ttyb1': device_add
[   17.627648] PM: Adding info for No Bus:ttyb1
[   17.631974] device: 'ttyb2': device_add
[   17.636085] PM: Adding info for No Bus:ttyb2
[   17.640411] device: 'ttyb3': device_add
[   17.644483] PM: Adding info for No Bus:ttyb3
[   17.648828] device: 'ttyb4': device_add
[   17.652886] PM: Adding info for No Bus:ttyb4
[   17.657217] device: 'ttyb5': device_add
[   17.661289] PM: Adding info for No Bus:ttyb5
[   17.665641] device: 'ttyb6': device_add
[   17.669711] PM: Adding info for No Bus:ttyb6
[   17.674076] device: 'ttyb7': device_add
[   17.678224] PM: Adding info for No Bus:ttyb7
[   17.682549] device: 'ttyb8': device_add
[   17.686613] PM: Adding info for No Bus:ttyb8
[   17.690967] device: 'ttyb9': device_add
[   17.695120] PM: Adding info for No Bus:ttyb9
[   17.699450] device: 'ttyba': device_add
[   17.703534] PM: Adding info for No Bus:ttyba
[   17.707865] device: 'ttybb': device_add
[   17.711921] PM: Adding info for No Bus:ttybb
[   17.716262] device: 'ttybc': device_add
[   17.720329] PM: Adding info for No Bus:ttybc
[   17.724658] device: 'ttybd': device_add
[   17.728712] PM: Adding info for No Bus:ttybd
[   17.733081] device: 'ttybe': device_add
[   17.737189] PM: Adding info for No Bus:ttybe
[   17.741509] device: 'ttybf': device_add
[   17.745560] PM: Adding info for No Bus:ttybf
[   17.749891] device: 'ttyc0': device_add
[   17.753972] PM: Adding info for No Bus:ttyc0
[   17.758316] device: 'ttyc1': device_add
[   17.762385] PM: Adding info for No Bus:ttyc1
[   17.766709] device: 'ttyc2': device_add
[   17.770756] PM: Adding info for No Bus:ttyc2
[   17.775120] device: 'ttyc3': device_add
[   17.779214] PM: Adding info for No Bus:ttyc3
[   17.783537] device: 'ttyc4': device_add
[   17.787580] PM: Adding info for No Bus:ttyc4
[   17.791906] device: 'ttyc5': device_add
[   17.795957] PM: Adding info for No Bus:ttyc5
[   17.800287] device: 'ttyc6': device_add
[   17.804337] PM: Adding info for No Bus:ttyc6
[   17.808664] device: 'ttyc7': device_add
[   17.812744] PM: Adding info for No Bus:ttyc7
[   17.817117] device: 'ttyc8': device_add
[   17.821220] PM: Adding info for No Bus:ttyc8
[   17.825547] device: 'ttyc9': device_add
[   17.829609] PM: Adding info for No Bus:ttyc9
[   17.833934] device: 'ttyca': device_add
[   17.837998] PM: Adding info for No Bus:ttyca
[   17.842360] device: 'ttycb': device_add
[   17.846449] PM: Adding info for No Bus:ttycb
[   17.850784] device: 'ttycc': device_add
[   17.854852] PM: Adding info for No Bus:ttycc
[   17.859180] device: 'ttycd': device_add
[   17.863300] PM: Adding info for No Bus:ttycd
[   17.867646] device: 'ttyce': device_add
[   17.871721] PM: Adding info for No Bus:ttyce
[   17.876091] device: 'ttycf': device_add
[   17.880200] PM: Adding info for No Bus:ttycf
[   17.884530] device: 'ttyd0': device_add
[   17.888582] PM: Adding info for No Bus:ttyd0
[   17.892910] device: 'ttyd1': device_add
[   17.896979] PM: Adding info for No Bus:ttyd1
[   17.901337] device: 'ttyd2': device_add
[   17.905400] PM: Adding info for No Bus:ttyd2
[   17.909732] device: 'ttyd3': device_add
[   17.913790] PM: Adding info for No Bus:ttyd3
[   17.918148] device: 'ttyd4': device_add
[   17.922281] PM: Adding info for No Bus:ttyd4
[   17.926611] device: 'ttyd5': device_add
[   17.930689] PM: Adding info for No Bus:ttyd5
[   17.935064] device: 'ttyd6': device_add
[   17.939179] PM: Adding info for No Bus:ttyd6
[   17.943504] device: 'ttyd7': device_add
[   17.947565] PM: Adding info for No Bus:ttyd7
[   17.951894] device: 'ttyd8': device_add
[   17.955965] PM: Adding info for No Bus:ttyd8
[   17.960301] device: 'ttyd9': device_add
[   17.965543] PM: Adding info for No Bus:ttyd9
[   17.969867] device: 'ttyda': device_add
[   17.973938] PM: Adding info for No Bus:ttyda
[   17.978274] device: 'ttydb': device_add
[   17.982364] PM: Adding info for No Bus:ttydb
[   17.986706] device: 'ttydc': device_add
[   17.990786] PM: Adding info for No Bus:ttydc
[   17.995149] device: 'ttydd': device_add
[   17.999299] PM: Adding info for No Bus:ttydd
[   18.003627] device: 'ttyde': device_add
[   18.007734] PM: Adding info for No Bus:ttyde
[   18.012101] device: 'ttydf': device_add
[   18.016232] PM: Adding info for No Bus:ttydf
[   18.020559] device: 'ttye0': device_add
[   18.024633] PM: Adding info for No Bus:ttye0
[   18.028965] device: 'ttye1': device_add
[   18.033134] PM: Adding info for No Bus:ttye1
[   18.037464] device: 'ttye2': device_add
[   18.041549] PM: Adding info for No Bus:ttye2
[   18.045880] device: 'ttye3': device_add
[   18.049966] PM: Adding info for No Bus:ttye3
[   18.054308] device: 'ttye4': device_add
[   18.058383] PM: Adding info for No Bus:ttye4
[   18.062715] device: 'ttye5': device_add
[   18.066793] PM: Adding info for No Bus:ttye5
[   18.071148] device: 'ttye6': device_add
[   18.075273] PM: Adding info for No Bus:ttye6
[   18.079605] device: 'ttye7': device_add
[   18.083682] PM: Adding info for No Bus:ttye7
[   18.088074] device: 'ttye8': device_add
[   18.092225] PM: Adding info for No Bus:ttye8
[   18.096554] device: 'ttye9': device_add
[   18.100641] PM: Adding info for No Bus:ttye9
[   18.104976] device: 'ttyea': device_add
[   18.109124] PM: Adding info for No Bus:ttyea
[   18.113455] device: 'ttyeb': device_add
[   18.117535] PM: Adding info for No Bus:ttyeb
[   18.121878] device: 'ttyec': device_add
[   18.125970] PM: Adding info for No Bus:ttyec
[   18.130317] device: 'ttyed': device_add
[   18.134396] PM: Adding info for No Bus:ttyed
[   18.138759] device: 'ttyee': device_add
[   18.142875] PM: Adding info for No Bus:ttyee
[   18.147204] device: 'ttyef': device_add
[   18.151363] PM: Adding info for No Bus:ttyef
[   18.155832] device: 'ptmx': device_add
[   18.159843] PM: Adding info for No Bus:ptmx
[   18.164125] initcall pty_init+0x0/0x397 returned 0 after 4159681 usecs
[   18.170625] calling  sysrq_init+0x0/0x1f @ 1
[   18.174901] initcall sysrq_init+0x0/0x1f returned 0 after 31 usecs
[   18.181047] calling  ip2_loadmain+0x0/0x113f @ 1
[   18.185619] Computone IntelliPort Plus multiport driver version 1.2.14
[   18.192168] device class 'ip2': registering
[   18.196422] initcall ip2_loadmain+0x0/0x113f returned 0 after 10542 usecs
[   18.203171] calling  synclinkmp_init+0x0/0x152 @ 1
[   18.207932] SyncLink MultiPort driver $Revision: 4.38 $
[   18.213134] bus: 'pci': add driver synclinkmp
[   18.217660] device: 'ttySLM0': device_add
[   18.221987] PM: Adding info for No Bus:ttySLM0
[   18.226497] device: 'ttySLM1': device_add
[   18.230758] PM: Adding info for No Bus:ttySLM1
[   18.235257] device: 'ttySLM2': device_add
[   18.239519] PM: Adding info for No Bus:ttySLM2
[   18.244069] device: 'ttySLM3': device_add
[   18.248371] PM: Adding info for No Bus:ttySLM3
[   18.252875] device: 'ttySLM4': device_add
[   18.257184] PM: Adding info for No Bus:ttySLM4
[   18.261686] device: 'ttySLM5': device_add
[   18.265951] PM: Adding info for No Bus:ttySLM5
[   18.270471] device: 'ttySLM6': device_add
[   18.274742] PM: Adding info for No Bus:ttySLM6
[   18.279241] device: 'ttySLM7': device_add
[   18.283503] PM: Adding info for No Bus:ttySLM7
[   18.288002] device: 'ttySLM8': device_add
[   18.292307] PM: Adding info for No Bus:ttySLM8
[   18.296819] device: 'ttySLM9': device_add
[   18.301162] PM: Adding info for No Bus:ttySLM9
[   18.305662] device: 'ttySLM10': device_add
[   18.310089] PM: Adding info for No Bus:ttySLM10
[   18.314680] device: 'ttySLM11': device_add
[   18.319095] PM: Adding info for No Bus:ttySLM11
[   18.323683] device: 'ttySLM12': device_add
[   18.328101] PM: Adding info for No Bus:ttySLM12
[   18.332692] device: 'ttySLM13': device_add
[   18.337110] PM: Adding info for No Bus:ttySLM13
[   18.341700] device: 'ttySLM14': device_add
[   18.346122] PM: Adding info for No Bus:ttySLM14
[   18.350710] device: 'ttySLM15': device_add
[   18.355117] PM: Adding info for No Bus:ttySLM15
[   18.359705] device: 'ttySLM16': device_add
[   18.364148] PM: Adding info for No Bus:ttySLM16
[   18.368758] device: 'ttySLM17': device_add
[   18.373185] PM: Adding info for No Bus:ttySLM17
[   18.377772] device: 'ttySLM18': device_add
[   18.382190] PM: Adding info for No Bus:ttySLM18
[   18.386793] device: 'ttySLM19': device_add
[   18.391226] PM: Adding info for No Bus:ttySLM19
[   18.395820] device: 'ttySLM20': device_add
[   18.400223] PM: Adding info for No Bus:ttySLM20
[   18.404834] device: 'ttySLM21': device_add
[   18.409242] PM: Adding info for No Bus:ttySLM21
[   18.413832] device: 'ttySLM22': device_add
[   18.418270] PM: Adding info for No Bus:ttySLM22
[   18.422862] device: 'ttySLM23': device_add
[   18.427288] PM: Adding info for No Bus:ttySLM23
[   18.431882] device: 'ttySLM24': device_add
[   18.436287] PM: Adding info for No Bus:ttySLM24
[   18.440904] device: 'ttySLM25': device_add
[   18.445320] PM: Adding info for No Bus:ttySLM25
[   18.449915] device: 'ttySLM26': device_add
[   18.454335] PM: Adding info for No Bus:ttySLM26
[   18.458947] device: 'ttySLM27': device_add
[   18.463368] PM: Adding info for No Bus:ttySLM27
[   18.467966] device: 'ttySLM28': device_add
[   18.472362] PM: Adding info for No Bus:ttySLM28
[   18.476950] device: 'ttySLM29': device_add
[   18.481373] PM: Adding info for No Bus:ttySLM29
[   18.485963] device: 'ttySLM30': device_add
[   18.490368] PM: Adding info for No Bus:ttySLM30
[   18.494959] device: 'ttySLM31': device_add
[   18.499355] PM: Adding info for No Bus:ttySLM31
[   18.503952] device: 'ttySLM32': device_add
[   18.508358] PM: Adding info for No Bus:ttySLM32
[   18.512954] device: 'ttySLM33': device_add
[   18.517356] PM: Adding info for No Bus:ttySLM33
[   18.521956] device: 'ttySLM34': device_add
[   18.526364] PM: Adding info for No Bus:ttySLM34
[   18.530951] device: 'ttySLM35': device_add
[   18.535360] PM: Adding info for No Bus:ttySLM35
[   18.539956] device: 'ttySLM36': device_add
[   18.544384] PM: Adding info for No Bus:ttySLM36
[   18.548978] device: 'ttySLM37': device_add
[   18.553376] PM: Adding info for No Bus:ttySLM37
[   18.557971] device: 'ttySLM38': device_add
[   18.562376] PM: Adding info for No Bus:ttySLM38
[   18.566966] device: 'ttySLM39': device_add
[   18.571379] PM: Adding info for No Bus:ttySLM39
[   18.575971] device: 'ttySLM40': device_add
[   18.580377] PM: Adding info for No Bus:ttySLM40
[   18.584991] device: 'ttySLM41': device_add
[   18.589399] PM: Adding info for No Bus:ttySLM41
[   18.593990] device: 'ttySLM42': device_add
[   18.598433] PM: Adding info for No Bus:ttySLM42
[   18.603100] device: 'ttySLM43': device_add
[   18.607499] PM: Adding info for No Bus:ttySLM43
[   18.612137] device: 'ttySLM44': device_add
[   18.616517] PM: Adding info for No Bus:ttySLM44
[   18.621155] device: 'ttySLM45': device_add
[   18.625534] PM: Adding info for No Bus:ttySLM45
[   18.630152] device: 'ttySLM46': device_add
[   18.634540] PM: Adding info for No Bus:ttySLM46
[   18.639179] device: 'ttySLM47': device_add
[   18.643579] PM: Adding info for No Bus:ttySLM47
[   18.648182] device: 'ttySLM48': device_add
[   18.652564] PM: Adding info for No Bus:ttySLM48
[   18.657167] device: 'ttySLM49': device_add
[   18.661577] PM: Adding info for No Bus:ttySLM49
[   18.666175] device: 'ttySLM50': device_add
[   18.670567] PM: Adding info for No Bus:ttySLM50
[   18.675168] device: 'ttySLM51': device_add
[   18.679552] PM: Adding info for No Bus:ttySLM51
[   18.684167] device: 'ttySLM52': device_add
[   18.688553] PM: Adding info for No Bus:ttySLM52
[   18.693169] device: 'ttySLM53': device_add
[   18.697556] PM: Adding info for No Bus:ttySLM53
[   18.702168] device: 'ttySLM54': device_add
[   18.706591] PM: Adding info for No Bus:ttySLM54
[   18.711198] device: 'ttySLM55': device_add
[   18.715612] PM: Adding info for No Bus:ttySLM55
[   18.720208] device: 'ttySLM56': device_add
[   18.724603] PM: Adding info for No Bus:ttySLM56
[   18.729206] device: 'ttySLM57': device_add
[   18.733608] PM: Adding info for No Bus:ttySLM57
[   18.738197] device: 'ttySLM58': device_add
[   18.742589] PM: Adding info for No Bus:ttySLM58
[   18.747182] device: 'ttySLM59': device_add
[   18.751609] PM: Adding info for No Bus:ttySLM59
[   18.756205] device: 'ttySLM60': device_add
[   18.760598] PM: Adding info for No Bus:ttySLM60
[   18.765188] device: 'ttySLM61': device_add
[   18.770765] PM: Adding info for No Bus:ttySLM61
[   18.775377] device: 'ttySLM62': device_add
[   18.779800] PM: Adding info for No Bus:ttySLM62
[   18.784392] device: 'ttySLM63': device_add
[   18.788815] PM: Adding info for No Bus:ttySLM63
[   18.793412] device: 'ttySLM64': device_add
[   18.797817] PM: Adding info for No Bus:ttySLM64
[   18.802408] device: 'ttySLM65': device_add
[   18.806805] PM: Adding info for No Bus:ttySLM65
[   18.811400] device: 'ttySLM66': device_add
[   18.815811] PM: Adding info for No Bus:ttySLM66
[   18.820403] device: 'ttySLM67': device_add
[   18.824804] PM: Adding info for No Bus:ttySLM67
[   18.829397] device: 'ttySLM68': device_add
[   18.833806] PM: Adding info for No Bus:ttySLM68
[   18.838443] device: 'ttySLM69': device_add
[   18.842875] PM: Adding info for No Bus:ttySLM69
[   18.847468] device: 'ttySLM70': device_add
[   18.851874] PM: Adding info for No Bus:ttySLM70
[   18.856468] device: 'ttySLM71': device_add
[   18.860869] PM: Adding info for No Bus:ttySLM71
[   18.865462] device: 'ttySLM72': device_add
[   18.869866] PM: Adding info for No Bus:ttySLM72
[   18.874472] device: 'ttySLM73': device_add
[   18.878889] PM: Adding info for No Bus:ttySLM73
[   18.883479] device: 'ttySLM74': device_add
[   18.887881] PM: Adding info for No Bus:ttySLM74
[   18.892492] device: 'ttySLM75': device_add
[   18.896929] PM: Adding info for No Bus:ttySLM75
[   18.901534] device: 'ttySLM76': device_add
[   18.905948] PM: Adding info for No Bus:ttySLM76
[   18.910549] device: 'ttySLM77': device_add
[   18.914959] PM: Adding info for No Bus:ttySLM77
[   18.919563] device: 'ttySLM78': device_add
[   18.923974] PM: Adding info for No Bus:ttySLM78
[   18.928584] device: 'ttySLM79': device_add
[   18.932994] PM: Adding info for No Bus:ttySLM79
[   18.937604] device: 'ttySLM80': device_add
[   18.942066] PM: Adding info for No Bus:ttySLM80
[   18.946661] device: 'ttySLM81': device_add
[   18.951133] PM: Adding info for No Bus:ttySLM81
[   18.955725] device: 'ttySLM82': device_add
[   18.960221] PM: Adding info for No Bus:ttySLM82
[   18.964816] device: 'ttySLM83': device_add
[   18.969335] PM: Adding info for No Bus:ttySLM83
[   18.973927] device: 'ttySLM84': device_add
[   18.978421] PM: Adding info for No Bus:ttySLM84
[   18.983098] device: 'ttySLM85': device_add
[   18.987522] PM: Adding info for No Bus:ttySLM85
[   18.992142] device: 'ttySLM86': device_add
[   18.996562] PM: Adding info for No Bus:ttySLM86
[   19.001165] device: 'ttySLM87': device_add
[   19.005582] PM: Adding info for No Bus:ttySLM87
[   19.010176] device: 'ttySLM88': device_add
[   19.014608] PM: Adding info for No Bus:ttySLM88
[   19.019213] device: 'ttySLM89': device_add
[   19.023645] PM: Adding info for No Bus:ttySLM89
[   19.028247] device: 'ttySLM90': device_add
[   19.032665] PM: Adding info for No Bus:ttySLM90
[   19.037262] device: 'ttySLM91': device_add
[   19.041681] PM: Adding info for No Bus:ttySLM91
[   19.046273] device: 'ttySLM92': device_add
[   19.050691] PM: Adding info for No Bus:ttySLM92
[   19.055287] device: 'ttySLM93': device_add
[   19.059703] PM: Adding info for No Bus:ttySLM93
[   19.064297] device: 'ttySLM94': device_add
[   19.068731] PM: Adding info for No Bus:ttySLM94
[   19.073351] device: 'ttySLM95': device_add
[   19.077831] PM: Adding info for No Bus:ttySLM95
[   19.082426] device: 'ttySLM96': device_add
[   19.086870] PM: Adding info for No Bus:ttySLM96
[   19.091486] device: 'ttySLM97': device_add
[   19.095913] PM: Adding info for No Bus:ttySLM97
[   19.100510] device: 'ttySLM98': device_add
[   19.104927] PM: Adding info for No Bus:ttySLM98
[   19.109530] device: 'ttySLM99': device_add
[   19.113960] PM: Adding info for No Bus:ttySLM99
[   19.118567] device: 'ttySLM100': device_add
[   19.123137] PM: Adding info for No Bus:ttySLM100
[   19.127816] device: 'ttySLM101': device_add
[   19.132395] PM: Adding info for No Bus:ttySLM101
[   19.137122] device: 'ttySLM102': device_add
[   19.141649] PM: Adding info for No Bus:ttySLM102
[   19.146352] device: 'ttySLM103': device_add
[   19.150884] PM: Adding info for No Bus:ttySLM103
[   19.155575] device: 'ttySLM104': device_add
[   19.160139] PM: Adding info for No Bus:ttySLM104
[   19.164836] device: 'ttySLM105': device_add
[   19.169393] PM: Adding info for No Bus:ttySLM105
[   19.174121] device: 'ttySLM106': device_add
[   19.178667] PM: Adding info for No Bus:ttySLM106
[   19.183354] device: 'ttySLM107': device_add
[   19.187876] PM: Adding info for No Bus:ttySLM107
[   19.192560] device: 'ttySLM108': device_add
[   19.197166] PM: Adding info for No Bus:ttySLM108
[   19.201847] device: 'ttySLM109': device_add
[   19.206416] PM: Adding info for No Bus:ttySLM109
[   19.211134] device: 'ttySLM110': device_add
[   19.215676] PM: Adding info for No Bus:ttySLM110
[   19.220368] device: 'ttySLM111': device_add
[   19.224897] PM: Adding info for No Bus:ttySLM111
[   19.229578] device: 'ttySLM112': device_add
[   19.234160] PM: Adding info for No Bus:ttySLM112
[   19.238839] device: 'ttySLM113': device_add
[   19.243409] PM: Adding info for No Bus:ttySLM113
[   19.248132] device: 'ttySLM114': device_add
[   19.252653] PM: Adding info for No Bus:ttySLM114
[   19.257337] device: 'ttySLM115': device_add
[   19.261912] PM: Adding info for No Bus:ttySLM115
[   19.266603] device: 'ttySLM116': device_add
[   19.271197] PM: Adding info for No Bus:ttySLM116
[   19.275875] device: 'ttySLM117': device_add
[   19.280436] PM: Adding info for No Bus:ttySLM117
[   19.285153] device: 'ttySLM118': device_add
[   19.289690] PM: Adding info for No Bus:ttySLM118
[   19.294369] device: 'ttySLM119': device_add
[   19.298915] PM: Adding info for No Bus:ttySLM119
[   19.303606] device: 'ttySLM120': device_add
[   19.308196] PM: Adding info for No Bus:ttySLM120
[   19.312904] device: 'ttySLM121': device_add
[   19.317487] PM: Adding info for No Bus:ttySLM121
[   19.322175] device: 'ttySLM122': device_add
[   19.326723] PM: Adding info for No Bus:ttySLM122
[   19.331406] device: 'ttySLM123': device_add
[   19.335946] PM: Adding info for No Bus:ttySLM123
[   19.340643] device: 'ttySLM124': device_add
[   19.345240] PM: Adding info for No Bus:ttySLM124
[   19.349929] device: 'ttySLM125': device_add
[   19.354468] PM: Adding info for No Bus:ttySLM125
[   19.359168] device: 'ttySLM126': device_add
[   19.363714] PM: Adding info for No Bus:ttySLM126
[   19.368401] device: 'ttySLM127': device_add
[   19.372960] PM: Adding info for No Bus:ttySLM127
[   19.377662] SyncLink MultiPort driver $Revision: 4.38 $, tty major#253
[   19.384160] initcall synclinkmp_init+0x0/0x152 returned 0 after 1148651 usecs
[   19.391256] calling  slgt_init+0x0/0x16a @ 1
[   19.395505] SyncLink GT
[   19.397958] SyncLink GT, tty major#252
[   19.401666] bus: 'pci': add driver synclink_gt
[   19.406273] SyncLink GT no devices found
[   19.410159] initcall slgt_init+0x0/0x16a returned 0 after 14306 usecs
[   19.416566] calling  rio_init+0x0/0xe94 @ 1
[   19.420741] device: 'rioctl': device_add
[   19.424816] PM: Adding info for No Bus:rioctl
[   19.433412] device: 'rioctl': device_unregister
[   19.437900] PM: Removing info for No Bus:rioctl
[   19.442972] device: 'rioctl': device_create_release
[   19.447851] initcall rio_init+0x0/0xe94 returned -5 after 26482 usecs
[   19.454244] initcall rio_init+0x0/0xe94 returned with error code -5 
[   19.460570] calling  init+0x0/0xf @ 1
[   19.464211] bus: 'virtio': add driver virtio_console
[   19.469276] initcall init+0x0/0xf returned 0 after 4946 usecs
[   19.474991] calling  hpet_init+0x0/0x57 @ 1
[   19.479160] device: 'hpet': device_add
[   19.483117] PM: Adding info for No Bus:hpet
[   19.487416] bus: 'acpi': add driver hpet
[   19.491466] initcall hpet_init+0x0/0x57 returned 0 after 12023 usecs
[   19.497782] calling  mod_init+0x0/0x91 @ 1
[   19.501995] initcall mod_init+0x0/0x91 returned -19 after 138 usecs
[   19.508219] calling  init+0x0/0x96 @ 1
[   19.511948] bus: 'virtio': add driver virtio_rng
[   19.516639] initcall init+0x0/0x96 returned 0 after 4582 usecs
[   19.522434] calling  nsc_gpio_init+0x0/0x11 @ 1
[   19.526934] nsc_gpio initializing
[   19.530229] initcall nsc_gpio_init+0x0/0x11 returned 0 after 3214 usecs
[   19.536815] calling  tlclk_init+0x0/0x1f7 @ 1
[   19.541170] telclk_interrup = 0xf non-mcpbl0010 hw.
[   19.546156] initcall tlclk_init+0x0/0x1f7 returned -6 after 4890 usecs
[   19.552639] initcall tlclk_init+0x0/0x1f7 returned with error code -6 
[   19.559135] calling  init_tis+0x0/0xa5 @ 1
[   19.563211] bus: 'pnp': add driver tpm_tis
[   19.567419] initcall init_tis+0x0/0xa5 returned 0 after 4109 usecs
[   19.573557] calling  init_inf+0x0/0xf @ 1
[   19.577541] bus: 'pnp': add driver tpm_inf_pnp
[   19.582139] initcall init_inf+0x0/0xf returned 0 after 4488 usecs
[   19.588194] calling  serial8250_init+0x0/0xf4 @ 1
[   19.592870] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   19.599168] Registering platform device 'serial8250'. Parent at platform
[   19.605830] device: 'serial8250': device_add
[   19.610088] bus: 'platform': add device serial8250
[   19.616073] PM: Adding info for platform:serial8250
[   19.621435] async_waiting @ 1
[   19.624424] async_continuing @ 1 after 62 usec
[   19.753877] async_waiting @ 1
[   19.756803] async_continuing @ 1 after 2 usec
�[   19.885868] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   19.891853] device: 'ttyS0': device_add
[   19.896494] PM: Adding info for No Bus:ttyS0
[   19.901300] async_waiting @ 1
[   19.904233] async_continuing @ 1 after 2 usec
[   20.032822] async_waiting @ 1
[   20.035742] async_continuing @ 1 after 2 usec
[   20.164864] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   20.170844] device: 'ttyS1': device_add
[   20.175188] PM: Adding info for No Bus:ttyS1
[   20.179579] device: 'ttyS2': device_add
[   20.183817] PM: Adding info for No Bus:ttyS2
[   20.188222] device: 'ttyS3': device_add
[   20.192471] PM: Adding info for No Bus:ttyS3
[   20.196818] bus: 'platform': add driver serial8250
[   20.201598] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   20.210550] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   20.218902] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   20.225905] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   20.234009] initcall serial8250_init+0x0/0xf4 returned 0 after 626099 usecs
[   20.240942] calling  serial8250_pnp_init+0x0/0xf @ 1
[   20.245875] bus: 'pnp': add driver serial
[   20.250120] bus: 'pnp': driver_probe_device: matched device 00:0a with driver serial
[   20.257855] bus: 'pnp': really_probe: probing driver serial with device 00:0a
[   20.265844] device: 'ttyS0': device_unregister
[   20.270237] PM: Removing info for No Bus:ttyS0
[   20.275908] device: 'ttyS0': device_create_release�[   20.280835] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   20.286370] device: 'ttyS0': device_add
[   20.290596] PM: Adding info for No Bus:ttyS0
[   20.294981] driver: '00:0a': driver_bound: bound to device 'serial'
[   20.301222] bus: 'pnp': really_probe: bound device 00:0a to driver serial
[   20.307992] bus: 'pnp': driver_probe_device: matched device 00:0b with driver serial
[   20.315727] bus: 'pnp': really_probe: probing driver serial with device 00:0b
[   20.323526] device: 'ttyS1': device_unregister
[   20.327920] PM: Removing info for No Bus:ttyS1
[   20.332831] device: 'ttyS1': device_create_release
[   20.337705] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   20.343239] device: 'ttyS1': device_add
[   20.347464] PM: Adding info for No Bus:ttyS1
[   20.351810] driver: '00:0b': driver_bound: bound to device 'serial'
[   20.358057] bus: 'pnp': really_probe: bound device 00:0b to driver serial
[   20.364941] initcall serial8250_pnp_init+0x0/0xf returned 0 after 116267 usecs
[   20.372179] calling  serial8250_pci_init+0x0/0x16 @ 1
[   20.377207] bus: 'pci': add driver serial
[   20.381395] initcall serial8250_pci_init+0x0/0x16 returned 0 after 4091 usecs
[   20.388491] calling  topology_sysfs_init+0x0/0x44 @ 1
[   20.393650] initcall topology_sysfs_init+0x0/0x44 returned 0 after 135 usecs
[   20.400650] calling  floppy_init+0x0/0xc86 @ 1
[   20.420444] FDC 0 is a post-1991 82077
[   20.425317] initcall floppy_init+0x0/0xc86 returned 0 after 19767 usecs
[   20.431876] calling  cpqarray_init+0x0/0x22a @ 1
[   20.436470] Compaq SMART2 Driver (v 2.6.0)
[   20.440547] bus: 'pci': add driver cpqarray
[   20.444976] bus: 'pci': remove driver cpqarray
[   20.449471] driver: 'cpqarray': driver_release
[   20.453888] initcall cpqarray_init+0x0/0x22a returned -19 after 17003 usecs
[   20.460805] calling  mm_init+0x0/0x154 @ 1
[   20.464879] bus: 'pci': add driver umem
[   20.468864] MM: desc_per_page = 128
[   20.472309] initcall mm_init+0x0/0x154 returned 0 after 7255 usecs
[   20.478455] calling  ub_init+0x0/0x71 @ 1
[   20.482450] bus: 'usb': add driver ub
[   20.486182] usbcore: registered new interface driver ub
[   20.491432] initcall ub_init+0x0/0x71 returned 0 after 8777 usecs
[   20.497477] calling  ibmasm_init+0x0/0x56 @ 1
[   20.501826] bus: 'pci': add driver ibmasm
[   20.505987] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   20.512568] initcall ibmasm_init+0x0/0x56 returned 0 after 10505 usecs
[   20.519064] calling  lkdtm_module_init+0x0/0x1bf @ 1
[   20.523998] lkdtm : Invalid command
[   20.527468] initcall lkdtm_module_init+0x0/0x1bf returned -22 after 3384 usecs
[   20.534683] initcall lkdtm_module_init+0x0/0x1bf returned with error code -22 
[   20.541894] calling  tifm_7xx1_init+0x0/0x16 @ 1
[   20.546486] bus: 'pci': add driver tifm_7xx1
[   20.550884] initcall tifm_7xx1_init+0x0/0x16 returned 0 after 4294 usecs
[   20.557547] calling  phantom_init+0x0/0xf7 @ 1
[   20.561962] device class 'phantom': registering
[   20.566572] bus: 'pci': add driver phantom
[   20.570766] Phantom Linux Driver, version n0.9.8, init OK
[   20.576127] initcall phantom_init+0x0/0xf7 returned 0 after 13832 usecs
[   20.582709] calling  ioc4_init+0x0/0x1b @ 1
[   20.586868] bus: 'pci': add driver IOC4
[   20.590821] initcall ioc4_init+0x0/0x1b returned 0 after 3858 usecs
[   20.597061] calling  at24_init+0x0/0x2b @ 1
[   20.601209] bus: 'i2c': add driver at24
[   20.605146] i2c-core: driver [at24] registered
[   20.609553] initcall at24_init+0x0/0x2b returned 0 after 8147 usecs
[   20.615781] calling  videodev_init+0x0/0x74 @ 1
[   20.620285] Linux video capture interface: v2.00
[   20.624883] device class 'video4linux': registering
[   20.629823] initcall videodev_init+0x0/0x74 returned 0 after 9309 usecs
[   20.636400] calling  si470x_module_init+0x0/0x20 @ 1
[   20.641334] USB radio driver for Si470x FM Radio Receivers, Version 1.0.9
[   20.648096] bus: 'usb': add driver radio-si470x
[   20.652730] usbcore: registered new interface driver radio-si470x
[   20.658792] initcall si470x_module_init+0x0/0x20 returned 0 after 17045 usecs
[   20.665885] calling  amradio_init+0x0/0x3a @ 1
[   20.670304] bus: 'usb': add driver radio-mr800
[   20.674822] usbcore: registered new interface driver radio-mr800
[   20.680815] radio_mr800: version 0.10 AverMedia MR 800 USB FM radio driver
[   20.687646] initcall amradio_init+0x0/0x3a returned 0 after 16934 usecs
[   20.694228] calling  mac_hid_init+0x0/0xb3 @ 1
[   20.698665] device: 'input0': device_add
[   20.702677] PM: Adding info for No Bus:input0
[   20.707288] input: Macintosh mouse button emulation as /class/input/input0
[   20.714263] initcall mac_hid_init+0x0/0xb3 returned 0 after 15245 usecs
[   20.720831] calling  raid_init+0x0/0xf @ 1
[   20.724903] device class 'raid_devices': registering
[   20.729940] initcall raid_init+0x0/0xf returned 0 after 4915 usecs
[   20.736084] calling  spi_transport_init+0x0/0x27 @ 1
[   20.741044] device class 'spi_transport': registering
[   20.746207] device class 'spi_host': registering
[   20.750884] initcall spi_transport_init+0x0/0x27 returned 0 after 9603 usecs
[   20.757896] calling  fc_transport_init+0x0/0x43 @ 1
[   20.762743] device class 'fc_host': registering
[   20.767332] device class 'fc_vports': registering
[   20.772119] device class 'fc_remote_ports': registering
[   20.777381] device class 'fc_transport': registering
[   20.782390] initcall fc_transport_init+0x0/0x43 returned 0 after 19180 usecs
[   20.789403] calling  iscsi_transport_init+0x0/0x125 @ 1
[   20.794596] Loading iSCSI transport class v2.0-870.
[   20.799447] device class 'iscsi_transport': registering
[   20.804730] device class 'iscsi_endpoint': registering
[   20.809903] device class 'iscsi_host': registering
[   20.814767] device class 'iscsi_connection': registering
[   20.820140] device class 'iscsi_session': registering
[   20.825642] initcall iscsi_transport_init+0x0/0x125 returned 0 after 30307 usecs
[   20.833061] calling  sas_transport_init+0x0/0x9f @ 1
[   20.837982] device class 'sas_host': registering
[   20.842689] device class 'sas_phy': registering
[   20.847263] device class 'sas_port': registering
[   20.851914] device class 'sas_device': registering
[   20.856748] device class 'sas_end_device': registering
[   20.861921] device class 'sas_expander': registering
[   20.866941] initcall sas_transport_init+0x0/0x9f returned 0 after 28274 usecs
[   20.874059] calling  sas_class_init+0x0/0x2c @ 1
[   20.878961] initcall sas_class_init+0x0/0x2c returned 0 after 318 usecs
[   20.885549] calling  scsi_dh_init+0x0/0x34 @ 1
[   20.889971] initcall scsi_dh_init+0x0/0x34 returned 0 after 4 usecs
[   20.896205] calling  rdac_init+0x0/0x26 @ 1
[   20.900451] rdac: device handler registered
[   20.904587] initcall rdac_init+0x0/0x26 returned 0 after 4121 usecs
[   20.910824] calling  clariion_init+0x0/0x2c @ 1
[   20.915329] emc: device handler registered
[   20.919403] initcall clariion_init+0x0/0x2c returned 0 after 3977 usecs
[   20.925986] calling  alua_init+0x0/0x2c @ 1
[   20.930147] alua: device handler registered
[   20.934307] initcall alua_init+0x0/0x2c returned 0 after 4060 usecs
[   20.940545] calling  NCR_700_init+0x0/0x1c @ 1
[   20.944976] initcall NCR_700_init+0x0/0x1c returned 0 after 10 usecs
[   20.951289] calling  sim710_init+0x0/0x11 @ 1
[   20.955624] initcall sim710_init+0x0/0x11 returned 0 after 1 usecs
[   20.961778] calling  ahc_linux_init+0x0/0x75 @ 1
[   20.966381] bus: 'pci': add driver aic7xxx
[   20.970493] bus: 'pci': driver_probe_device: matched device 0000:03:04.0 with driver aic7xxx
[   20.978921] bus: 'pci': really_probe: probing driver aic7xxx with device 0000:03:04.0
[   20.986820] IOAPIC[0]: Set routing entry (4-18 -> 0x49 -> IRQ 18 Mode:1 Active:1)
[   20.994301] aic7xxx 0000:03:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   22.213103] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   22.213107]         <Adaptec aic7899 Ultra160 SCSI adapter>
[   22.213110]         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   22.213113] 
[   22.236321] device: 'host0': device_add
[   22.240175] PM: Adding info for No Bus:host0
[   22.244400] device: 'host0': device_add
[   22.248350] PM: Adding info for No Bus:host0
[   22.252968] device: 'host0': device_add
[   22.257137] PM: Adding info for No Bus:host0
[   22.262474] driver: '0000:03:04.0': driver_bound: bound to device 'aic7xxx'
[   22.267922] scsi 0:0:0:0: Direct-Access     SEAGATE  ST336706LC       010A PQ: 0 ANSI: 3
[   22.267947] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
[   22.268189]  target0:0:0: Beginning Domain Validation
[   22.277894]  target0:0:0: wide asynchronous
[   22.284914]  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
[   22.297288]  target0:0:0: Ending Domain Validation
[   22.302145] scsi 0:0:1:0: Direct-Access     SEAGATE  ST336706LC       010A PQ: 0 ANSI: 3
[   22.302166] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
[   22.302215]  target0:0:1: Beginning Domain Validation
[   22.311446]  target0:0:1: wide asynchronous
[   22.318475]  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
[   22.330878]  target0:0:1: Ending Domain Validation
[   22.338795] bus: 'pci': really_probe: bound device 0000:03:04.0 to driver aic7xxx
[   22.346283] bus: 'pci': driver_probe_device: matched device 0000:03:04.1 with driver aic7xxx
[   22.354707] bus: 'pci': really_probe: probing driver aic7xxx with device 0000:03:04.1
[   22.362597] aic7xxx 0000:03:04.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
[   23.580057] scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   23.580061]         <Adaptec aic7899 Ultra160 SCSI adapter>
[   23.580064]         aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
[   23.580066] 
[   23.600855] device: 'host1': device_add
[   23.604692] PM: Adding info for No Bus:host1
[   23.608912] device: 'host1': device_add
[   23.612847] PM: Adding info for No Bus:host1
[   23.617191] device: 'host1': device_add
[   23.621088] PM: Adding info for No Bus:host1
[   23.625633] driver: '0000:03:04.1': driver_bound: bound to device 'aic7xxx'
[   23.632558] bus: 'pci': really_probe: bound device 0000:03:04.1 to driver aic7xxx
[   23.640223] initcall ahc_linux_init+0x0/0x75 returned 0 after 2611177 usecs
[   23.647150] calling  aic94xx_init+0x0/0x117 @ 1
[   23.651648] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   23.659139] bus: 'pci': add driver aic94xx
[   23.663388] initcall aic94xx_init+0x0/0x117 returned 0 after 11458 usecs
[   23.670061] calling  ips_module_init+0x0/0x170 @ 1
[   23.674815] bus: 'pci': add driver ips
[   23.678721] bus: 'pci': remove driver ips
[   23.682777] driver: 'ips': driver_release
[   23.686761] initcall ips_module_init+0x0/0x170 returned -19 after 11664 usecs
[   23.693850] calling  NCR_Q720_init+0x0/0x29 @ 1
[   23.698368] initcall NCR_Q720_init+0x0/0x29 returned 0 after 9 usecs
[   23.704681] calling  sym2_init+0x0/0xdf @ 1
[   23.708852] bus: 'pci': add driver sym53c8xx
[   23.713243] initcall sym2_init+0x0/0xdf returned 0 after 4296 usecs
[   23.719468] calling  init_this_scsi_driver+0x0/0xcb @ 1
[   23.763692] initcall init_this_scsi_driver+0x0/0xcb returned -19 after 38110 usecs
[   23.771256] calling  megasas_init+0x0/0x11b @ 1
[   23.775761] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[   23.781588] bus: 'pci': add driver megaraid_sas
[   23.786275] initcall megasas_init+0x0/0x11b returned 0 after 10263 usecs
[   23.792941] calling  scsih_init+0x0/0xcd @ 1
[   23.797181] mpt2sas version 00.100.11.16 loaded
[   23.801757] device: 'mpt2ctl': device_add
[   23.805956] PM: Adding info for No Bus:mpt2ctl
[   23.810459] bus: 'pci': add driver mpt2sas
[   23.814720] initcall scsih_init+0x0/0xcd returned 0 after 17120 usecs
[   23.821120] calling  inia100_init+0x0/0x16 @ 1
[   23.825538] bus: 'pci': add driver inia100
[   23.829760] initcall inia100_init+0x0/0x16 returned 0 after 4123 usecs
[   23.836250] calling  init_nsp32+0x0/0x2c @ 1
[   23.840491] nsp32: loading...
[   23.843439] bus: 'pci': add driver nsp32
[   23.847482] initcall init_nsp32+0x0/0x2c returned 0 after 6823 usecs
[   23.853797] calling  ipr_init+0x0/0x2a @ 1
[   23.857869] ipr: IBM Power RAID SCSI Device Driver version: 2.4.2 (January 21, 2009)
[   23.865605] bus: 'pci': add driver ipr
[   23.869552] initcall ipr_init+0x0/0x2a returned 0 after 11405 usecs
[   23.875781] calling  hptiop_module_init+0x0/0x2a @ 1
[   23.880714] RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
[   23.886696] bus: 'pci': add driver hptiop
[   23.890832] initcall hptiop_module_init+0x0/0x2a returned 0 after 9876 usecs
[   23.897842] calling  stex_init+0x0/0x25 @ 1
[   23.901995] stex: Promise SuperTrak EX Driver version: 4.6.0000.1
[   23.908064] bus: 'pci': add driver stex
[   23.912063] initcall stex_init+0x0/0x25 returned 0 after 9828 usecs
[   23.918290] calling  cxgb3i_ddp_init_module+0x0/0x29 @ 1
[   23.923574] cxgb3i_ddp: system PAGE_SIZE 4096, ddp idx 0.
[   23.928949] initcall cxgb3i_ddp_init_module+0x0/0x29 returned 0 after 5246 usecs
[   23.936338] calling  cxgb3i_init_module+0x0/0x31 @ 1
[   23.941278] cxgb3i: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
[   23.947120] device: 'cxgb3i': device_add
[   23.951074] PM: Adding info for No Bus:cxgb3i
[   23.955566] iscsi: registered transport (cxgb3i)
[   23.960219] initcall cxgb3i_init_module+0x0/0x31 returned 0 after 18493 usecs
[   23.967309] calling  init_sd+0x0/0xe9 @ 1
[   23.971334] device class 'scsi_disk': registering
[   23.976127] Driver 'sd' needs updating - please use bus_type methods
[   23.982438] bus: 'scsi': add driver sd
[   23.986265] initcall init_sd+0x0/0xe9 returned 0 after 14618 usecs
[   23.992405] calling  init_sr+0x0/0x3d @ 1
[   23.996391] Driver 'sr' needs updating - please use bus_type methods
[   24.002712] bus: 'scsi': add driver sr
[   24.006538] initcall init_sr+0x0/0x3d returned 0 after 9910 usecs
[   24.012595] calling  ahci_init+0x0/0x16 @ 1
[   24.016755] bus: 'pci': add driver ahci
[   24.020754] initcall ahci_init+0x0/0x16 returned 0 after 3907 usecs
[   24.026980] calling  piix_init+0x0/0x24 @ 1
[   24.031138] bus: 'pci': add driver ata_piix
[   24.035326] bus: 'pci': driver_probe_device: matched device 0000:00:1f.1 with driver ata_piix
[   24.043837] bus: 'pci': really_probe: probing driver ata_piix with device 0000:00:1f.1
[   24.051759] ata_piix 0000:00:1f.1: version 2.12
[   24.056467] ata_piix 0000:00:1f.1: setting latency timer to 64
[   24.062735] scsi2 : ata_piix
[   24.065587] device: 'host2': device_add
[   24.069422] PM: Adding info for No Bus:host2
[   24.073645] device: 'host2': device_add
[   24.077576] PM: Adding info for No Bus:host2
[   24.082159] scsi3 : ata_piix
[   24.085041] device: 'host3': device_add
[   24.088863] PM: Adding info for No Bus:host3
[   24.093088] device: 'host3': device_add
[   24.097041] PM: Adding info for No Bus:host3
[   24.110147] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   24.117066] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   24.124093] driver: '0000:00:1f.1': driver_bound: bound to device 'ata_piix'
[   24.131092] bus: 'pci': really_probe: bound device 0000:00:1f.1 to driver ata_piix
[   24.138848] initcall piix_init+0x0/0x24 returned 0 after 105178 usecs
[   24.145254] calling  pdc_ata_init+0x0/0x16 @ 1
[   24.149675] bus: 'pci': add driver sata_promise
[   24.154342] initcall pdc_ata_init+0x0/0x16 returned 0 after 4561 usecs
[   24.160833] calling  qs_ata_init+0x0/0x16 @ 1
[   24.165164] bus: 'pci': add driver sata_qstor
[   24.169661] initcall qs_ata_init+0x0/0x16 returned 0 after 4393 usecs
[   24.176066] calling  sil_init+0x0/0x16 @ 1
[   24.177306] calling  1_async_port_probe+0x0/0xaa @ 2841
[   24.177825] calling  2_async_port_probe+0x0/0xaa @ 2842
[   24.177833] async_waiting @ 2842
[   24.193744] bus: 'pci': add driver sata_sil
[   24.198121] initcall sil_init+0x0/0x16 returned 0 after 4275 usecs
[   24.204261] calling  svia_init+0x0/0x16 @ 1
[   24.208421] bus: 'pci': add driver sata_via
[   24.212746] initcall svia_init+0x0/0x16 returned 0 after 4223 usecs
[   24.218974] calling  nv_init+0x0/0x16 @ 1
[   24.222961] bus: 'pci': add driver sata_nv
[   24.227224] initcall nv_init+0x0/0x16 returned 0 after 4164 usecs
[   24.233272] calling  amd_init+0x0/0x16 @ 1
[   24.237344] bus: 'pci': add driver pata_amd
[   24.241646] initcall amd_init+0x0/0x16 returned 0 after 4202 usecs
[   24.247787] calling  atiixp_init+0x0/0x16 @ 1
[   24.252119] bus: 'pci': add driver pata_atiixp
[   24.256697] initcall atiixp_init+0x0/0x16 returned 0 after 4472 usecs
[   24.263099] calling  cs5520_init+0x0/0x16 @ 1
[   24.267432] bus: 'pci': add driver pata_cs5520
[   24.271992] initcall cs5520_init+0x0/0x16 returned 0 after 4454 usecs
[   24.278400] calling  hpt3x3_init+0x0/0x16 @ 1
[   24.282733] bus: 'pci': add driver pata_hpt3x3
[   24.287295] initcall hpt3x3_init+0x0/0x16 returned 0 after 4456 usecs
[   24.293696] calling  ninja32_init+0x0/0x16 @ 1
[   24.298114] bus: 'pci': add driver pata_ninja32
[   24.302763] initcall ninja32_init+0x0/0x16 returned 0 after 4541 usecs
[   24.309249] calling  opti_init+0x0/0x16 @ 1
[   24.313409] bus: 'pci': add driver pata_opti
[   24.317793] initcall opti_init+0x0/0x16 returned 0 after 4283 usecs
[   24.324051] calling  oldpiix_init+0x0/0x16 @ 1
[   24.328443] bus: 'pci': add driver pata_oldpiix
[   24.329191] async_waiting @ 2841
[   24.329202] async_continuing @ 2841 after 3 usec
[   24.329219] initcall 1_async_port_probe+0x0/0xaa returned 0 after 148335 usecs
[   24.329289] async_continuing @ 2842 after 147897 usec
[   24.354249] initcall oldpiix_init+0x0/0x16 returned 0 after 25202 usecs
[   24.360825] calling  radisys_init+0x0/0x16 @ 1
[   24.365244] bus: 'pci': add driver pata_radisys
[   24.369909] initcall radisys_init+0x0/0x16 returned 0 after 4557 usecs
[   24.376398] calling  sil680_init+0x0/0x16 @ 1
[   24.380729] bus: 'pci': add driver pata_sil680
[   24.385338] initcall sil680_init+0x0/0x16 returned 0 after 4503 usecs
[   24.391741] calling  via_init+0x0/0x16 @ 1
[   24.395819] bus: 'pci': add driver pata_via
[   24.400176] initcall via_init+0x0/0x16 returned 0 after 4257 usecs
[   24.406317] calling  e1000_init_module+0x0/0x53 @ 1
[   24.411163] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[   24.417227] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   24.423053] bus: 'pci': add driver e1000e
[   24.427330] initcall e1000_init_module+0x0/0x53 returned 0 after 15780 usecs
[   24.434342] calling  t1_init_module+0x0/0x16 @ 1
[   24.438934] bus: 'pci': add driver cxgb
[   24.442900] initcall t1_init_module+0x0/0x16 returned 0 after 3874 usecs
[   24.449565] calling  cxgb3_init_module+0x0/0x1b @ 1
[   24.454420] bus: 'pci': add driver cxgb3
[   24.458490] initcall cxgb3_init_module+0x0/0x1b returned 0 after 3979 usecs
[   24.465414] calling  jme_init_module+0x0/0x25 @ 1
[   24.470087] jme: JMicron JMC2XX ethernet driver version 1.0.4
[   24.475811] bus: 'pci': add driver jme
[   24.479676] initcall jme_init_module+0x0/0x25 returned 0 after 9359 usecs
[   24.486427] calling  be_init_module+0x0/0x6a @ 1
[   24.491043] bus: 'pci': add driver be2net
[   24.495211] initcall be_init_module+0x0/0x6a returned 0 after 4075 usecs
[   24.501876] calling  rr_init_module+0x0/0x16 @ 1
[   24.506469] bus: 'pci': add driver rrunner
[   24.507780] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-M1612, 1004, max UDMA/33
[   24.517291] initcall rr_init_module+0x0/0x16 returned 0 after 10570 usecs
[   24.524056] calling  vortex_init+0x0/0x9c @ 1
[   24.528377] bus: 'pci': add driver 3c59x
[   24.532418] initcall vortex_init+0x0/0x9c returned 0 after 3950 usecs
[   24.538816] calling  typhoon_init+0x0/0x16 @ 1
[   24.543236] bus: 'pci': add driver typhoon
[   24.544530] ata2.00: configured for UDMA/33
[   24.545355] async_waiting @ 2842
[   24.545368] async_continuing @ 2842 after 3 usec
[   24.545436] scsi: waiting for bus probes to complete ...
[   24.564698] initcall typhoon_init+0x0/0x16 returned 0 after 20961 usecs
[   24.571277] calling  e100_init_module+0x0/0x4d @ 1
[   24.576052] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   24.582101] e100: Copyright(c) 1999-2006 Intel Corporation
[   24.587565] bus: 'pci': add driver e100
[   24.591423] bus: 'pci': driver_probe_device: matched device 0000:04:03.0 with driver e100
[   24.599588] bus: 'pci': really_probe: probing driver e100 with device 0000:04:03.0
[   24.607219] IOAPIC[0]: Set routing entry (4-19 -> 0x51 -> IRQ 19 Mode:1 Active:1)
[   24.614700] e100 0000:04:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   24.646783] e100 0000:04:03.0: PME# disabled
[   24.651061] device: 'eth0': device_add
[   24.655082] PM: Adding info for No Bus:eth0
[   24.660652] e100: eth0: e100_probe: addr 0xe1241000, irq 19, MAC addr 00:90:27:8c:c4:9e
[   24.668652] driver: '0000:04:03.0': driver_bound: bound to device 'e100'
[   24.675325] bus: 'pci': really_probe: bound device 0000:04:03.0 to driver e100
[   24.682541] bus: 'pci': driver_probe_device: matched device 0000:04:04.0 with driver e100
[   24.690703] bus: 'pci': really_probe: probing driver e100 with device 0000:04:04.0
[   24.698330] IOAPIC[0]: Set routing entry (4-16 -> 0x59 -> IRQ 16 Mode:1 Active:1)
[   24.705817] e100 0000:04:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   24.737871] e100 0000:04:04.0: PME# disabled
[   24.742115] device: 'eth1': device_add
[   24.746123] PM: Adding info for No Bus:eth1
[   24.751608] e100: eth1: e100_probe: addr 0xe1240000, irq 16, MAC addr 00:30:48:23:0a:de
[   24.759603] driver: '0000:04:04.0': driver_bound: bound to device 'e100'
[   24.766277] bus: 'pci': really_probe: bound device 0000:04:04.0 to driver e100
[   24.773625] initcall e100_init_module+0x0/0x4d returned 0 after 192934 usecs
[   24.780639] calling  sis190_init_module+0x0/0x16 @ 1
[   24.785584] bus: 'pci': add driver sis190
[   24.789719] initcall sis190_init_module+0x0/0x16 returned 0 after 4047 usecs
[   24.796729] calling  sis900_init_module+0x0/0x16 @ 1
[   24.801669] bus: 'pci': add driver sis900
[   24.805846] initcall sis900_init_module+0x0/0x16 returned 0 after 4081 usecs
[   24.812855] calling  fealnx_init+0x0/0x16 @ 1
[   24.817187] bus: 'pci': add driver fealnx
[   24.821336] initcall fealnx_init+0x0/0x16 returned 0 after 4053 usecs
[   24.827741] calling  tg3_init+0x0/0x16 @ 1
[   24.831818] bus: 'pci': add driver tg3
[   24.835700] initcall tg3_init+0x0/0x16 returned 0 after 3797 usecs
[   24.841841] calling  skge_init_module+0x0/0x16 @ 1
[   24.846608] bus: 'pci': add driver skge
[   24.850572] initcall skge_init_module+0x0/0x16 returned 0 after 3872 usecs
[   24.857413] calling  sky2_init_module+0x0/0x20 @ 1
[   24.862172] sky2 driver version 1.22
[   24.865730] bus: 'pci': add driver sky2
[   24.869689] initcall sky2_init_module+0x0/0x20 returned 0 after 7336 usecs
[   24.876526] calling  skfd_init+0x0/0x16 @ 1
[   24.880689] bus: 'pci': add driver skfddi
[   24.884843] initcall skfd_init+0x0/0x16 returned 0 after 4060 usecs
[   24.891080] calling  rhine_init+0x0/0x54 @ 1
[   24.895320] via-rhine: Broken BIOS detected, avoid_D3 enabled.
[   24.901128] bus: 'pci': add driver via-rhine
[   24.905522] initcall rhine_init+0x0/0x54 returned 0 after 9962 usecs
[   24.911837] calling  davicom_init+0x0/0x4d @ 1
[   24.916255] bus: 'mdio_bus': add driver Davicom DM9161E
[   24.921550] bus: 'mdio_bus': add driver Davicom DM9161A
[   24.926826] bus: 'mdio_bus': add driver Davicom DM9131
[   24.932060] initcall davicom_init+0x0/0x4d returned 0 after 15434 usecs
[   24.938638] calling  qs6612_init+0x0/0xf @ 1
[   24.942882] bus: 'mdio_bus': add driver QS6612
[   24.947418] initcall qs6612_init+0x0/0xf returned 0 after 4426 usecs
[   24.953735] calling  fixed_mdio_bus_init+0x0/0xc2 @ 1
[   24.958764] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[   24.965977] device: 'Fixed MDIO bus.0': device_add
[   24.970766] bus: 'platform': add device Fixed MDIO bus.0
[   24.976084] PM: Adding info for platform:Fixed MDIO bus.0
[   24.981550] device: '0': device_add
[   24.985101] PM: Adding info for No Bus:0
[   24.989247] Fixed MDIO Bus: probed
[   24.992620] initcall fixed_mdio_bus_init+0x0/0xc2 returned 0 after 33066 usecs
[   24.999838] calling  mdio_gpio_init+0x0/0xf @ 1
[   25.004347] bus: 'platform': add driver mdio-gpio
[   25.009163] initcall mdio_gpio_init+0x0/0xf returned 0 after 4704 usecs
[   25.015743] calling  ns_init+0x0/0xf @ 1
[   25.019640] bus: 'mdio_bus': add driver NatSemi DP83865
[   25.024937] initcall ns_init+0x0/0xf returned 0 after 5172 usecs
[   25.030907] calling  hamachi_init+0x0/0x16 @ 1
[   25.035335] bus: 'pci': add driver hamachi
[   25.039559] initcall hamachi_init+0x0/0x16 returned 0 after 4135 usecs
[   25.046057] calling  net_olddevs_init+0x0/0x81 @ 1
[   25.050817] initcall net_olddevs_init+0x0/0x81 returned 0 after 9 usecs
[   25.057393] calling  b44_init+0x0/0x56 @ 1
[   25.061470] bus: 'pci': add driver b44
[   25.065337] bus: 'ssb': add driver b44
[   25.069156] initcall b44_init+0x0/0x56 returned 0 after 7509 usecs
[   25.075298] calling  init_nic+0x0/0x16 @ 1
[   25.079376] bus: 'pci': add driver forcedeth
[   25.083801] initcall init_nic+0x0/0x16 returned 0 after 4326 usecs
[   25.089944] calling  qlge_init_module+0x0/0x16 @ 1
[   25.094713] bus: 'pci': add driver qlge
[   25.098668] initcall qlge_init_module+0x0/0x16 returned 0 after 3865 usecs
[   25.105516] calling  ppp_init+0x0/0xdf @ 1
[   25.109582] PPP generic driver version 2.4.2
[   25.114048] device class 'ppp': registering
[   25.118288] device: 'ppp': device_add
[   25.122200] PM: Adding info for No Bus:ppp
[   25.126483] initcall ppp_init+0x0/0xdf returned 0 after 16494 usecs
[   25.132726] calling  ppp_async_init+0x0/0x2d @ 1
[   25.137317] initcall ppp_async_init+0x0/0x2d returned 0 after 3 usecs
[   25.143724] calling  deflate_init+0x0/0x30 @ 1
[   25.148206] PPP Deflate Compression module registered
[   25.153209] initcall deflate_init+0x0/0x30 returned 0 after 4942 usecs
[   25.159703] calling  slip_init+0x0/0x99 @ 1
[   25.163861] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[   25.170878] SLIP linefill/keepalive option.
[   25.175061] initcall slip_init+0x0/0x99 returned 0 after 10935 usecs
[   25.181364] calling  ifb_init_module+0x0/0x9a @ 1
[   25.186181] device: 'ifb0': device_add
[   25.190184] PM: Adding info for No Bus:ifb0
[   25.195789] device: 'ifb1': device_add
[   25.199726] PM: Adding info for No Bus:ifb1
[   25.205387] initcall ifb_init_module+0x0/0x9a returned 0 after 18876 usecs
[   25.212215] calling  ibmlana_init_module+0x0/0xf @ 1
[   25.217156] initcall ibmlana_init_module+0x0/0xf returned 0 after 1 usecs
[   25.223912] calling  cp_init+0x0/0x16 @ 1
[   25.227914] bus: 'pci': add driver 8139cp
[   25.232151] initcall cp_init+0x0/0x16 returned 0 after 4150 usecs
[   25.238214] calling  rtl8139_init_module+0x0/0x16 @ 1
[   25.243243] bus: 'pci': add driver 8139too
[   25.247466] initcall rtl8139_init_module+0x0/0x16 returned 0 after 4129 usecs
[   25.254565] calling  sc92031_init+0x0/0x16 @ 1
[   25.258985] bus: 'pci': add driver sc92031
[   25.263208] initcall sc92031_init+0x0/0x16 returned 0 after 4126 usecs
[   25.269704] calling  amd8111e_init+0x0/0x16 @ 1
[   25.274212] bus: 'pci': add driver amd8111e
[   25.278518] initcall amd8111e_init+0x0/0x16 returned 0 after 4208 usecs
[   25.285092] calling  dnet_init+0x0/0xf @ 1
[   25.289164] bus: 'platform': add driver dnet
[   25.294668] initcall dnet_init+0x0/0xf returned 0 after 5374 usecs
[   25.300802] calling  arcnet_init+0x0/0x50 @ 1
[   25.305130] arcnet loaded.
[   25.307819] initcall arcnet_init+0x0/0x50 returned 0 after 2622 usecs
[   25.314230] calling  com90xx_init+0x0/0xdb8 @ 1
[   25.318744] arcnet: COM90xx chipset support
[   25.624117] S3: No ARCnet cards found.
[   25.627829] initcall com90xx_init+0x0/0xdb8 returned -5 after 301847 usecs
[   25.634662] initcall com90xx_init+0x0/0xdb8 returned with error code -5 
[   25.641334] calling  com90io_init+0x0/0x40d @ 1
[   25.645860] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
[   25.653071] E-mail me if you actually test this driver, please!
[   25.658964]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
[   25.667072] initcall com90io_init+0x0/0x40d returned -19 after 20733 usecs
[   25.668855] device: 'target0:0:0': device_add
[   25.669065] PM: Adding info for No Bus:target0:0:0
[   25.669132] device: 'target0:0:0': device_add
[   25.669208] PM: Adding info for No Bus:target0:0:0
[   25.669615] device: '0:0:0:0': device_add
[   25.669715] bus: 'scsi': add device 0:0:0:0
[   25.669781] PM: Adding info for scsi:0:0:0:0
[   25.670096] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
[   25.670104] bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
[   25.670543] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[   25.670558] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[   25.670608] device: '0:0:0:0': device_add
[   25.670676] PM: Adding info for No Bus:0:0:0:0
[   25.671077] device: '0:0:0:0': device_add
[   25.671595] PM: Adding info for No Bus:0:0:0:0
[   25.672103] device: 'target0:0:1': device_add
[   25.672164] PM: Adding info for No Bus:target0:0:1
[   25.672181] device: 'target0:0:1': device_add
[   25.672243] PM: Adding info for No Bus:target0:0:1
[   25.672498] device: '0:0:1:0': device_add
[   25.672595] bus: 'scsi': add device 0:0:1:0
[   25.672635] PM: Adding info for scsi:0:0:1:0
[   25.672715] bus: 'scsi': driver_probe_device: matched device 0:0:1:0 with driver sd
[   25.672722] bus: 'scsi': really_probe: probing driver sd with device 0:0:1:0
[   25.672792] driver: '0:0:1:0': driver_bound: bound to device 'sd'
[   25.672805] bus: 'scsi': really_probe: bound device 0:0:1:0 to driver sd
[   25.672828] device: '0:0:1:0': device_add
[   25.672911] PM: Adding info for No Bus:0:0:1:0
[   25.673080] device: '0:0:1:0': device_add
[   25.673298] PM: Adding info for No Bus:0:0:1:0
[   25.674486] calling  3_sd_probe_async+0x0/0x240 @ 2952
[   25.674513] device: '0:0:0:0': device_add
[   25.674709] PM: Adding info for No Bus:0:0:0:0
[   25.674841] calling  4_sd_probe_async+0x0/0x240 @ 2964
[   25.674920] device: '0:0:1:0': device_add
[   25.675223] PM: Adding info for No Bus:0:0:1:0
[   25.676788] sd 0:0:0:0: [sda] 71687370 512-byte hardware sectors: (36.7 GB/34.1 GiB)
[   25.677249] sd 0:0:1:0: [sdb] 71687370 512-byte hardware sectors: (36.7 GB/34.1 GiB)
[   25.678119] sd 0:0:0:0: [sda] Write Protect is off
[   25.678127] sd 0:0:0:0: [sda] Mode Sense: 9f 00 10 08
[   25.678518] sd 0:0:1:0: [sdb] Write Protect is off
[   25.678526] sd 0:0:1:0: [sdb] Mode Sense: 9f 00 10 08
[   25.680151] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   25.680175] device: 'sda': device_add
[   25.680302] PM: Adding info for No Bus:sda
[   25.901725] calling  catc_init+0x0/0x2d @ 1
[   25.905872] bus: 'usb': add driver catc
[   25.909842] usbcore: registered new interface driver catc
[   25.915195] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[   25.921085] initcall catc_init+0x0/0x2d returned 0 after 14858 usecs
[   25.927409] calling  kaweth_init+0x0/0x16 @ 1
[   25.931742] bus: 'usb': add driver kaweth
[   25.935816] usbcore: registered new interface driver kaweth
[   25.941342] initcall kaweth_init+0x0/0x16 returned 0 after 9374 usecs
[   25.947746] calling  pegasus_init+0x0/0x121 @ 1
[   25.952249] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   25.959720] bus: 'usb': add driver pegasus
[   25.963880] usbcore: registered new interface driver pegasus
[   25.969495] initcall pegasus_init+0x0/0x121 returned 0 after 16838 usecs
[   25.976158] calling  asix_init+0x0/0x16 @ 1
[   25.980318] bus: 'usb': add driver asix
[   25.984219] usbcore: registered new interface driver asix
[   25.989573] initcall asix_init+0x0/0x16 returned 0 after 9036 usecs
[   25.995802] calling  cdc_init+0x0/0x16 @ 1
[   25.999876] bus: 'usb': add driver cdc_ether
[   26.004208] usbcore: registered new interface driver cdc_ether
[   26.009995] initcall cdc_init+0x0/0x16 returned 0 after 9882 usecs
[   26.016139] calling  usbnet_init+0x0/0x16 @ 1
[   26.020472] bus: 'usb': add driver gl620a
[   26.024555] usbcore: registered new interface driver gl620a
[   26.030083] initcall usbnet_init+0x0/0x16 returned 0 after 9384 usecs
[   26.036485] calling  zaurus_init+0x0/0x16 @ 1
[   26.040819] bus: 'usb': add driver zaurus
[   26.044892] usbcore: registered new interface driver zaurus
[   26.050419] initcall zaurus_init+0x0/0x16 returned 0 after 9375 usecs
[   26.056822] calling  usbnet_init+0x0/0x26 @ 1
[   26.061170] initcall usbnet_init+0x0/0x26 returned 0 after 13 usecs
[   26.067393] calling  de_init+0x0/0x16 @ 1
[   26.071395] bus: 'pci': add driver de2104x
[   26.075605] initcall de_init+0x0/0x16 returned 0 after 4123 usecs
[   26.081651] calling  de4x5_module_init+0x0/0x16 @ 1
[   26.086505] bus: 'pci': add driver de4x5
[   26.090530] initcall de4x5_module_init+0x0/0x16 returned 0 after 3932 usecs
[   26.097437] calling  uli526x_init_module+0x0/0x8d @ 1
[   26.102460] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   26.109311] bus: 'pci': add driver uli526x
[   26.113558] initcall uli526x_init_module+0x0/0x8d returned 0 after 10833 usecs
[   26.120772] calling  stir_init+0x0/0x16 @ 1
[   26.124933] bus: 'usb': add driver stir4200
[   26.129178] usbcore: registered new interface driver stir4200
[   26.134877] initcall stir_init+0x0/0x16 returned 0 after 9712 usecs
[   26.141109] calling  smsc_ircc_init+0x0/0x4ca @ 1
[   26.145790] bus: 'platform': add driver smsc-ircc2
[   26.150916] bus: 'platform': remove driver smsc-ircc2
[   26.155990] driver: 'smsc-ircc2': driver_release
[   26.160573] initcall smsc_ircc_init+0x0/0x4ca returned -19 after 14436 usecs
[   26.167580] calling  vlsi_mod_init+0x0/0xf6 @ 1
[   26.172119] bus: 'pci': add driver vlsi_ir
[   26.176306] initcall vlsi_mod_init+0x0/0xf6 returned 0 after 4119 usecs
[   26.182867] calling  ksdazzle_init+0x0/0x16 @ 1
[   26.187378] bus: 'usb': add driver ksdazzle-sir
[   26.191966] usbcore: registered new interface driver ksdazzle-sir
[   26.198049] initcall ksdazzle_init+0x0/0x16 returned 0 after 10419 usecs
[   26.204704] calling  init_netconsole+0x0/0x1d4 @ 1
[   26.209474] console [netcon0] enabled
[   26.213113] netconsole: network logging started
[   26.217616] initcall init_netconsole+0x0/0x1d4 returned 0 after 7955 usecs
[   26.224459] calling  init+0x0/0xf @ 1
[   26.228101] bus: 'virtio': add driver virtio_net
[   26.232781] initcall init+0x0/0xf returned 0 after 4569 usecs
[   26.238473] calling  zatm_init_module+0x0/0x16 @ 1
[   26.243244] bus: 'pci': add driver zatm
[   26.247195] initcall zatm_init_module+0x0/0x16 returned 0 after 3863 usecs
[   26.254043] calling  uPD98402_module_init+0x0/0x7 @ 1
[   26.259054] initcall uPD98402_module_init+0x0/0x7 returned 0 after 1 usecs
[   26.265888] calling  nicstar_init+0x0/0x61 @ 1
[   26.270311] bus: 'pci': add driver nicstar
[   26.274516] initcall nicstar_init+0x0/0x61 returned 0 after 4108 usecs
[   26.280993] calling  hrz_module_init+0x0/0xb1 @ 1
[   26.285669] Madge ATM Horizon [Ultra] driver version 1.2.1
[   26.291133] bus: 'pci': add driver horizon
[   26.295384] initcall hrz_module_init+0x0/0xb1 returned 0 after 9484 usecs
[   26.302118] calling  fore200e_module_init+0x0/0x20 @ 1
[   26.307228] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[   26.313905] bus: 'pci': add driver fore_200e
[   26.318284] initcall fore200e_module_init+0x0/0x20 returned 0 after 10791 usecs
[   26.325585] calling  adummy_init+0x0/0xe6 @ 1
[   26.329914] adummy: version 1.0
[   26.333273] device: 'adummy0': device_add
[   26.337494] PM: Adding info for No Bus:adummy0
[   26.342328] initcall adummy_init+0x0/0xe6 returned 0 after 12118 usecs
[   26.348807] calling  fusion_init+0x0/0xd5 @ 1
[   26.353138] Fusion MPT base driver 3.04.07
[   26.357207] Copyright (c) 1999-2008 LSI Corporation
[   26.362116] initcall fusion_init+0x0/0xd5 returned 0 after 8764 usecs
[   26.368502] calling  mptfc_init+0x0/0xcc @ 1
[   26.372747] Fusion MPT FC Host driver 3.04.07
[   26.377112] bus: 'pci': add driver mptfc
[   26.381190] initcall mptfc_init+0x0/0xcc returned 0 after 8241 usecs
[   26.387497] calling  mptsas_init+0x0/0xd1 @ 1
[   26.391827] Fusion MPT SAS Host driver 3.04.07
[   26.396274] bus: 'pci': add driver mptsas
[   26.400370] initcall mptsas_init+0x0/0xd1 returned 0 after 8339 usecs
[   26.406762] calling  mptctl_init+0x0/0xe1 @ 1
[   26.411090] Fusion MPT misc device (ioctl) driver 3.04.07
[   26.416474] device: 'mptctl': device_add
[   26.420611] PM: Adding info for No Bus:mptctl
[   26.425033] mptctl: Registered with Fusion MPT base driver
[   26.430473] mptctl: /dev/mptctl @ (major,minor=10,220)
[   26.435591] initcall mptctl_init+0x0/0xe1 returned 0 after 23922 usecs
[   26.442087] calling  ohci1394_init+0x0/0x16 @ 1
[   26.446608] bus: 'pci': add driver ohci1394
[   26.450938] initcall ohci1394_init+0x0/0x16 returned 0 after 4238 usecs
[   26.457511] calling  init_raw1394+0x0/0xe9 @ 1
[   26.461944] device: 'raw1394': device_add
[   26.466131] PM: Adding info for No Bus:raw1394
[   26.471890] ieee1394: raw1394: /dev/raw1394 device initialized
[   26.477675] bus: 'ieee1394': add driver raw1394
[   26.482288] initcall init_raw1394+0x0/0xe9 returned 0 after 19876 usecs
[   26.488855] calling  dv1394_init_module+0x0/0x85 @ 1
[   26.493803] bus: 'ieee1394': add driver dv1394
[   26.498312] initcall dv1394_init_module+0x0/0x85 returned 0 after 4412 usecs
[   26.505309] calling  cdrom_init+0x0/0xc @ 1
[   26.509672] initcall cdrom_init+0x0/0xc returned 0 after 196 usecs
[   26.515802] calling  tle62x0_init+0x0/0xf @ 1
[   26.520136] bus: 'spi': add driver tle62x0
[   26.524297] initcall tle62x0_init+0x0/0xf returned 0 after 4063 usecs
[   26.530690] calling  gpio_vbus_init+0x0/0x14 @ 1
[   26.535283] bus: 'platform': add driver gpio-vbus
[   26.540123] bus: 'platform': remove driver gpio-vbus
[   26.545127] driver: 'gpio-vbus': driver_release
[   26.549615] initcall gpio_vbus_init+0x0/0x14 returned -19 after 13996 usecs
[   26.556537] calling  ehci_hcd_init+0x0/0xbb @ 1
[   26.561052] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   26.567541] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[   26.573620] bus: 'pci': add driver ehci_hcd
[   26.577944] initcall ehci_hcd_init+0x0/0xbb returned 0 after 16492 usecs
[   26.584605] calling  isp116x_init+0x0/0x38 @ 1
[   26.589041] 116x: driver isp116x-hcd, 03 Nov 2005
[   26.593703] bus: 'platform': add driver isp116x-hcd
[   26.598650] initcall isp116x_init+0x0/0x38 returned 0 after 9382 usecs
[   26.605124] calling  ohci_hcd_mod_init+0x0/0xb0 @ 1
[   26.609974] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   26.616125] ohci_hcd: block sizes: ed 64 td 64
[   26.620572] bus: 'pci': add driver ohci_hcd
[   26.624839] bus: 'ssb': add driver ohci_hcd
[   26.629106] initcall ohci_hcd_mod_init+0x0/0xb0 returned 0 after 18679 usecs
[   26.636101] calling  uhci_hcd_init+0x0/0x124 @ 1
[   26.640691] uhci_hcd: USB Universal Host Controller Interface driver
[   26.647369] bus: 'pci': add driver uhci_hcd
[   26.651536] bus: 'pci': driver_probe_device: matched device 0000:00:1f.2 with driver uhci_hcd
[   26.660055] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1f.2
[   26.668038] uhci_hcd 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   26.675149] uhci_hcd 0000:00:1f.2: setting latency timer to 64
[   26.680936] uhci_hcd 0000:00:1f.2: UHCI Host Controller
[   26.686476] device: 'usb_host1': device_add
[   26.690885] PM: Adding info for No Bus:usb_host1
[   26.696067] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
[   26.703481] uhci_hcd 0000:00:1f.2: detected 2 ports
[   26.708320] uhci_hcd 0000:00:1f.2: uhci_check_and_reset_hc: cmd = 0x0000
[   26.714986] uhci_hcd 0000:00:1f.2: Performing full reset
[   26.720285] uhci_hcd 0000:00:1f.2: supports USB remote wakeup
[   26.726112] uhci_hcd 0000:00:1f.2: irq 19, io base 0x0000d000
[   26.732547] usb usb1: default language 0x0409
[   26.736921] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   26.743661] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   26.750870] usb usb1: Product: UHCI Host Controller
[   26.755722] usb usb1: Manufacturer: Linux 2.6.29-tip-10645-g54ba01a-dirty uhci_hcd
[   26.763278] usb usb1: SerialNumber: 0000:00:1f.2
[   26.767873] device: 'usb1': device_add
[   26.772002] bus: 'usb': add device usb1
[   26.775839] PM: Adding info for usb:usb1
[   26.779937] usb usb1: uevent
[   26.782892] bus: 'usb': driver_probe_device: matched device usb1 with driver usb
[   26.790289] bus: 'usb': really_probe: probing driver usb with device usb1
[   26.797071] usb usb1: usb_probe_device
[   26.800775] usb usb1: configuration #1 chosen from 1 choice
[   26.806709] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   26.812407] device: '1-0:1.0': device_add
[   26.816450] bus: 'usb': add device 1-0:1.0
[   26.820544] PM: Adding info for usb:1-0:1.0
[   26.824699] usb 1-0:1.0: uevent
[   26.828050] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
[   26.835702] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
[   26.842739] hub 1-0:1.0: usb_probe_interface
[   26.846967] hub 1-0:1.0: usb_probe_interface - got id
[   26.851996] hub 1-0:1.0: USB hub found
[   26.856153] hub 1-0:1.0: 2 ports detected
[   26.860111] hub 1-0:1.0: standalone hub
[   26.863925] hub 1-0:1.0: no power switching (usb 1.0)
[   26.868950] hub 1-0:1.0: individual port over-current protection
[   26.874930] hub 1-0:1.0: power on to power good time: 2ms
[   26.880745] hub 1-0:1.0: local power source is good
[   26.885575] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   26.892520] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[   26.898649] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[   26.905387] device class 'usb_endpoint': registering
[   26.910834] device: 'usbdev1.1_ep81': device_add
[   26.915663] PM: Adding info for No Bus:usbdev1.1_ep81
[   26.921146] device: 'usbdev1.1': device_add
[   26.925665] PM: Adding info for No Bus:usbdev1.1
[   26.930934] driver: 'usb1': driver_bound: bound to device 'usb'
[   26.936813] bus: 'usb': really_probe: bound device usb1 to driver usb
[   26.943247] device: 'usbdev1.1_ep00': device_add
[   26.948118] PM: Adding info for No Bus:usbdev1.1_ep00
[   26.953242] driver: '0000:00:1f.2': driver_bound: bound to device 'uhci_hcd'
[   26.960491] bus: 'pci': really_probe: bound device 0000:00:1f.2 to driver uhci_hcd
[   26.968072] bus: 'pci': driver_probe_device: matched device 0000:00:1f.4 with driver uhci_hcd
[   26.976590] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1f.4
[   26.984545] IOAPIC[0]: Set routing entry (4-23 -> 0x61 -> IRQ 23 Mode:1 Active:1)
[   26.992233] uhci_hcd 0000:00:1f.4: PCI INT C -> GSI 23 (level, low) -> IRQ 23
[   26.999343] uhci_hcd 0000:00:1f.4: setting latency timer to 64
[   27.005129] uhci_hcd 0000:00:1f.4: UHCI Host Controller
[   27.010365] device: 'usb_host2': device_add
[   27.014552] PM: Adding info for No Bus:usb_host2
[   27.019204] uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
[   27.026602] uhci_hcd 0000:00:1f.4: detected 2 ports
[   27.031446] uhci_hcd 0000:00:1f.4: uhci_check_and_reset_hc: legsup = 0x2000
[   27.038373] uhci_hcd 0000:00:1f.4: Performing full reset
[   27.043671] uhci_hcd 0000:00:1f.4: supports USB remote wakeup
[   27.049441] uhci_hcd 0000:00:1f.4: irq 23, io base 0x0000d800
[   27.055627] usb usb2: default language 0x0409
[   27.060042] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   27.066787] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   27.073996] usb usb2: Product: UHCI Host Controller
[   27.078848] usb usb2: Manufacturer: Linux 2.6.29-tip-10645-g54ba01a-dirty uhci_hcd
[   27.086412] usb usb2: SerialNumber: 0000:00:1f.4
[   27.091043] device: 'usb2': device_add
[   27.095108] bus: 'usb': add device usb2
[   27.098946] PM: Adding info for usb:usb2
[   27.102895] usb usb2: uevent
[   27.105784] bus: 'usb': driver_probe_device: matched device usb2 with driver usb
[   27.113171] bus: 'usb': really_probe: probing driver usb with device usb2
[   27.119948] usb usb2: usb_probe_device
[   27.123658] usb usb2: configuration #1 chosen from 1 choice
[   27.129238] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   27.134935] device: '2-0:1.0': device_add
[   27.138970] bus: 'usb': add device 2-0:1.0
[   27.143121] PM: Adding info for usb:2-0:1.0
[   27.147279] usb 2-0:1.0: uevent
[   27.150425] bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
[   27.158075] bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
[   27.165111] hub 2-0:1.0: usb_probe_interface
[   27.169340] hub 2-0:1.0: usb_probe_interface - got id
[   27.174369] hub 2-0:1.0: USB hub found
[   27.178331] hub 2-0:1.0: 2 ports detected
[   27.182286] hub 2-0:1.0: standalone hub
[   27.186097] hub 2-0:1.0: no power switching (usb 1.0)
[   27.191124] hub 2-0:1.0: individual port over-current protection
[   27.197104] hub 2-0:1.0: power on to power good time: 2ms
[   27.202513] hub 2-0:1.0: local power source is good
[   27.207353] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   27.214220] driver: '2-0:1.0': driver_bound: bound to device 'hub'
[   27.220351] bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
[   27.227070] device: 'usbdev2.1_ep81': device_add
[   27.232096] PM: Adding info for No Bus:usbdev2.1_ep81
[   27.237208] device: 'usbdev2.1': device_add
[   27.241500] PM: Adding info for No Bus:usbdev2.1
[   27.246140] driver: 'usb2': driver_bound: bound to device 'usb'
[   27.252027] bus: 'usb': really_probe: bound device usb2 to driver usb
[   27.258441] device: 'usbdev2.1_ep00': device_add
[   27.263240] PM: Adding info for No Bus:usbdev2.1_ep00
[   27.268355] driver: '0000:00:1f.4': driver_bound: bound to device 'uhci_hcd'
[   27.275532] bus: 'pci': really_probe: bound device 0000:00:1f.4 to driver uhci_hcd
[   27.283269] initcall uhci_hcd_init+0x0/0x124 returned 0 after 627509 usecs
[   27.290094] calling  isp1760_init+0x0/0x44 @ 1
[   27.295080] bus: 'platform': add driver isp1760
[   27.299672] bus: 'pci': add driver isp1760
[   27.303913] initcall isp1760_init+0x0/0x44 returned 0 after 9178 usecs
[   27.310396] calling  c67x00_init+0x0/0xf @ 1
[   27.314645] bus: 'platform': add driver c67x00
[   27.319154] initcall c67x00_init+0x0/0xf returned 0 after 4402 usecs
[   27.325455] calling  acm_init+0x0/0xd2 @ 1
[   27.329552] bus: 'usb': add driver cdc_acm
[   27.333702] usbcore: registered new interface driver cdc_acm
[   27.339315] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[   27.347830] initcall acm_init+0x0/0xd2 returned 0 after 17871 usecs
[   27.354066] calling  usb_stor_init+0x0/0x42 @ 1
[   27.359679] Initializing USB Mass Storage driver...
[   27.364534] bus: 'usb': add driver usb-storage
[   27.369144] usbcore: registered new interface driver usb-storage
[   27.375102] USB Mass Storage support registered.
[   27.379693] initcall usb_stor_init+0x0/0x42 returned 0 after 19541 usecs
[   27.386363] calling  usb_usual_init+0x0/0x32 @ 1
[   27.391112] bus: 'usb': add driver libusual
[   27.395695] usbcore: registered new interface driver libusual
[   27.401401] initcall usb_usual_init+0x0/0x32 returned 0 after 10196 usecs
[   27.408148] calling  datafab_init+0x0/0x16 @ 1
[   27.412568] bus: 'usb': add driver ums-datafab
[   27.417128] usbcore: registered new interface driver ums-datafab
[   27.423095] initcall datafab_init+0x0/0x16 returned 0 after 10280 usecs
[   27.429670] calling  freecom_init+0x0/0x16 @ 1
[   27.434092] bus: 'usb': add driver ums-freecom
[   27.438603] usbcore: registered new interface driver ums-freecom
[   27.444568] initcall freecom_init+0x0/0x16 returned 0 after 10230 usecs
[   27.451145] calling  isd200_init+0x0/0x16 @ 1
[   27.455498] bus: 'usb': add driver ums-isd200
[   27.459903] usbcore: registered new interface driver ums-isd200
[   27.465789] initcall isd200_init+0x0/0x16 returned 0 after 10048 usecs
[   27.472277] calling  karma_init+0x0/0x16 @ 1
[   27.476527] bus: 'usb': add driver ums-karma
[   27.480881] usbcore: registered new interface driver ums-karma
[   27.486672] initcall karma_init+0x0/0x16 returned 0 after 9906 usecs
[   27.492987] calling  sddr09_init+0x0/0x16 @ 1
[   27.497322] bus: 'usb': add driver ums-sddr09
[   27.501747] usbcore: registered new interface driver ums-sddr09
[   27.507624] initcall sddr09_init+0x0/0x16 returned 0 after 10060 usecs
[   27.514113] calling  sddr55_init+0x0/0x16 @ 1
[   27.518448] bus: 'usb': add driver ums-sddr55
[   27.522872] usbcore: registered new interface driver ums-sddr55
[   27.528749] initcall sddr55_init+0x0/0x16 returned 0 after 10059 usecs
[   27.535239] calling  usbat_init+0x0/0x16 @ 1
[   27.539488] bus: 'usb': add driver ums-usbat
[   27.543826] usbcore: registered new interface driver ums-usbat
[   27.549615] initcall usbat_init+0x0/0x16 returned 0 after 9891 usecs
[   27.555932] calling  usb_mdc800_init+0x0/0x346 @ 1
[   27.560714] bus: 'usb': add driver mdc800
[   27.564772] usbcore: registered new interface driver mdc800
[   27.570295] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   27.577944] initcall usb_mdc800_init+0x0/0x346 returned 0 after 16840 usecs
[   27.584874] calling  appledisplay_init+0x0/0x51 @ 1
[   27.590333] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.590670] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   27.590884] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   27.590953] bus: 'usb': add driver appledisplay
[   27.591222] usbcore: registered new interface driver appledisplay
[   27.591251] initcall appledisplay_init+0x0/0x51 returned 0 after 1483 usecs
[   27.591263] calling  cypress_init+0x0/0x2f @ 1
[   27.591275] bus: 'usb': add driver cypress_cy7c63
[   27.591410] usbcore: registered new interface driver cypress_cy7c63
[   27.591434] initcall cypress_init+0x0/0x2f returned 0 after 154 usecs
[   27.591443] calling  emi62_init+0x0/0x2d @ 1
[   27.591455] bus: 'usb': add driver emi62 - firmware loader
[   27.591588] usbcore: registered new interface driver emi62 - firmware loader
[   27.591612] initcall emi62_init+0x0/0x2d returned 0 after 153 usecs
[   27.591622] calling  ftdi_elan_init+0x0/0x139 @ 1
[   27.591630] driver ftdi-elan built at 12:45:41 on Apr  6 2009
[   27.595777]  sda: sda1 sda2 sda3
[   27.603807] device: 'sda1': device_add
[   27.604244] PM: Adding info for No Bus:sda1
[   27.604652] device: 'sda2': device_add
[   27.604750] PM: Adding info for No Bus:sda2
[   27.604852] device: 'sda3': device_add
[   27.604949] PM: Adding info for No Bus:sda3
[   27.709329] device: 'sdb': device_add
[   27.709826] device: '8:0': device_add
[   27.709884] PM: Adding info for No Bus:8:0
[   27.710124] sd 0:0:0:0: [sda] Attached SCSI disk
[   27.710143] initcall 3_sd_probe_async+0x0/0x240 returned 0 after 1987925 usecs
[   27.712585] bus: 'usb': add driver ftdi-elan
[   27.712743] usbcore: registered new interface driver ftdi-elan
[   27.712768] initcall ftdi_elan_init+0x0/0x139 returned 0 after 118292 usecs
[   27.712776] calling  iowarrior_init+0x0/0x16 @ 1
[   27.712789] bus: 'usb': add driver iowarrior
[   27.712985] usbcore: registered new interface driver iowarrior
[   27.713046] initcall iowarrior_init+0x0/0x16 returned 0 after 250 usecs
[   27.713058] calling  usb_led_init+0x0/0x2f @ 1
[   27.713075] bus: 'usb': add driver usbled
[   27.713284] usbcore: registered new interface driver usbled
[   27.713311] initcall usb_led_init+0x0/0x2f returned 0 after 232 usecs
[   27.713320] calling  tv_init+0x0/0x3c @ 1
[   27.713335] bus: 'usb': add driver trancevibrator
[   27.713494] usbcore: registered new interface driver trancevibrator
[   27.713515] trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
[   27.713533] initcall tv_init+0x0/0x3c returned 0 after 193 usecs
[   27.713543] calling  usb_sisusb_init+0x0/0x1b @ 1
[   27.713560] bus: 'usb': add driver sisusb
[   27.713715] usbcore: registered new interface driver sisusb
[   27.713743] initcall usb_sisusb_init+0x0/0x1b returned 0 after 181 usecs
[   27.713755] calling  i8042_init+0x0/0x336 @ 1
[   27.713772] bus: 'pnp': add driver i8042 kbd
[   27.713842] bus: 'pnp': driver_probe_device: matched device 00:0d with driver i8042 kbd
[   27.713852] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:0d
[   27.713893] driver: '00:0d': driver_bound: bound to device 'i8042 kbd'
[   27.713904] bus: 'pnp': really_probe: bound device 00:0d to driver i8042 kbd
[   27.714085] bus: 'pnp': add driver i8042 aux
[   27.714277] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   27.714285] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[   27.714445] bus: 'platform': add driver i8042
[   27.714627] Registering platform device 'i8042'. Parent at platform
[   27.714640] device: 'i8042': device_add
[   27.714689] bus: 'platform': add device i8042
[   27.714759] PM: Adding info for platform:i8042
[   27.714878] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   27.714888] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   27.715335] serio: i8042 KBD port at 0x60,0x64 irq 1
[   27.715484] driver: 'i8042': driver_bound: bound to device 'i8042'
[   27.715494] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   27.715523] initcall i8042_init+0x0/0x336 returned 0 after 1710 usecs
[   27.715537] calling  serport_init+0x0/0x2b @ 1
[   27.715554] initcall serport_init+0x0/0x2b returned 0 after 4 usecs
[   27.715566] calling  mousedev_init+0x0/0x93 @ 1
[   27.715640] device: 'mice': device_add
[   27.715976] PM: Adding info for No Bus:mice
[   27.716546] device: 'serio0': device_add
[   27.716743] bus: 'serio': add device serio0
[   27.716868] PM: Adding info for serio:serio0
[   27.954057] usb usb1: suspend_rh (auto-stop)
[   27.999689] PM: Adding info for No Bus:sdb
[   28.007808] device: 'mouse0': device_add
[   28.014828] PM: Adding info for No Bus:mouse0
[   28.019701] device: 'psaux': device_add
[   28.023714] PM: Adding info for No Bus:psaux
[   28.028063] mice: PS/2 mouse device common for all mice
[   28.033255] initcall mousedev_init+0x0/0x93 returned 0 after 310224 usecs
[   28.040006] calling  joydev_init+0x0/0xf @ 1
[   28.044258] initcall joydev_init+0x0/0xf returned 0 after 8 usecs
[   28.050313] calling  atkbd_init+0x0/0x20 @ 1
[   28.054567] bus: 'serio': add driver atkbd
[   28.058802] initcall atkbd_init+0x0/0x20 returned 0 after 4141 usecs
[   28.065118] calling  sunkbd_init+0x0/0x16 @ 1
[   28.069446] bus: 'serio': add driver sunkbd
[   28.073744] initcall sunkbd_init+0x0/0x16 returned 0 after 4195 usecs
[   28.080145] calling  gpio_keys_init+0x0/0xf @ 1
[   28.084650] bus: 'platform': add driver gpio-keys
[   28.089437] initcall gpio_keys_init+0x0/0xf returned 0 after 4675 usecs
[   28.096039] calling  atp_init+0x0/0x16 @ 1
[   28.100096] bus: 'usb': add driver appletouch
[   28.104586] usbcore: registered new interface driver appletouch
[   28.110484] initcall atp_init+0x0/0x16 returned 0 after 10151 usecs
[   28.116707] calling  sermouse_init+0x0/0x16 @ 1
[   28.121212] bus: 'serio': add driver sermouse
[   28.125666] initcall sermouse_init+0x0/0x16 returned 0 after 4347 usecs
[   28.132072] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   28.132082] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   28.147421] calling  vsxxxaa_init+0x0/0x16 @ 1
[   28.151583] device: 'input1': device_add
[   28.151995] PM: Adding info for No Bus:input1
[   28.152589] input: AT Translated Set 2 keyboard as /class/input/input1
[   28.166563] bus: 'serio': add driver vsxxxaa
[   28.170958] initcall vsxxxaa_init+0x0/0x16 returned 0 after 4287 usecs
[   28.177457] calling  a3d_init+0x0/0x16 @ 1
[   28.181523] bus: 'gameport': add driver adc
[   28.185875] initcall a3d_init+0x0/0x16 returned 0 after 4248 usecs
[   28.192049] calling  analog_init+0x0/0xcd @ 1
[   28.196359] bus: 'gameport': add driver analog
[   28.200891] initcall analog_init+0x0/0xcd returned 0 after 4425 usecs
[   28.207311] calling  sw_init+0x0/0x16 @ 1
[   28.211279] bus: 'gameport': add driver sidewinder
[   28.216191] initcall sw_init+0x0/0x16 returned 0 after 4795 usecs
[   28.222244] calling  usb_acecad_init+0x0/0x2d @ 1
[   28.226929] bus: 'usb': add driver usb_acecad
[   28.231394] usbcore: registered new interface driver usb_acecad
[   28.237276] acecad: v3.2:USB Acecad Flair tablet driver
[   28.242470] initcall usb_acecad_init+0x0/0x2d returned 0 after 15182 usecs
[   28.249310] calling  fujitsu_init+0x0/0x16 @ 1
[   28.253734] bus: 'serio': add driver fujitsu_ts
[   28.258357] initcall fujitsu_init+0x0/0x16 returned 0 after 4514 usecs
[   28.266040] calling  mk712_init+0x0/0x1b4 @ 1
[   28.270361] mk712: device not present
[   28.273995] initcall mk712_init+0x0/0x1b4 returned -19 after 3553 usecs
[   28.280582] calling  tr_init+0x0/0x16 @ 1
[   28.284563] bus: 'serio': add driver touchright
[   28.289195] initcall tr_init+0x0/0x16 returned 0 after 4522 usecs
[   28.295250] calling  tw_init+0x0/0x16 @ 1
[   28.299233] bus: 'serio': add driver touchwin
[   28.303682] initcall tw_init+0x0/0x16 returned 0 after 4344 usecs
[   28.309736] calling  tsc2007_init+0x0/0x11 @ 1
[   28.314154] bus: 'i2c': add driver tsc2007
[   28.318324] i2c-core: driver [tsc2007] registered
[   28.322994] initcall tsc2007_init+0x0/0x11 returned 0 after 8631 usecs
[   28.329481] calling  pcspkr_init+0x0/0xf @ 1
[   28.333731] bus: 'platform': add driver pcspkr
[   28.338172] bus: 'platform': driver_probe_device: matched device pcspkr with driver pcspkr
[   28.346420] bus: 'platform': really_probe: probing driver pcspkr with device pcspkr
[   28.354102] device: 'input2': device_add
[   28.358182] PM: Adding info for No Bus:input2
[   28.362612] input: PC Speaker as /class/input/input2
[   28.368595]  sdb:<7>driver: 'serio0': driver_bound: bound to device 'atkbd'
[   28.377392] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   28.378757]  sdb1
[   28.378798] device: 'sdb1': device_add
[   28.378927] PM: Adding info for No Bus:sdb1
[   28.394534] device: '8:16': device_add
[   28.398450] PM: Adding info for No Bus:8:16
[   28.402780] sd 0:0:1:0: [sdb] Attached SCSI disk
[   28.407381] initcall 4_sd_probe_async+0x0/0x240 returned 0 after 2668473 usecs
[   28.416188] driver: 'pcspkr': driver_bound: bound to device 'pcspkr'
[   28.422498] bus: 'platform': really_probe: bound device pcspkr to driver pcspkr
[   28.429950] initcall pcspkr_init+0x0/0xf returned 0 after 93957 usecs
[   28.436355] calling  atlas_acpi_init+0x0/0x35 @ 1
[   28.441052] bus: 'acpi': add driver Atlas ACPI
[   28.445604] initcall atlas_acpi_init+0x0/0x35 returned 0 after 4448 usecs
[   28.452350] calling  ati_remote2_init+0x0/0x3c @ 1
[   28.457121] usb usb2: suspend_rh (auto-stop)
[   28.461378] bus: 'usb': add driver ati_remote2
[   28.465960] usbcore: registered new interface driver ati_remote2
[   28.471929] ati_remote2: ATI/Philips USB RF remote driver 0.3
[   28.477644] initcall ati_remote2_init+0x0/0x3c returned 0 after 15889 usecs
[   28.484571] calling  usb_keyspan_init+0x0/0x2f @ 1
[   28.489343] bus: 'usb': add driver keyspan_remote
[   28.494180] usbcore: registered new interface driver keyspan_remote
[   28.500419] initcall usb_keyspan_init+0x0/0x2f returned 0 after 10817 usecs
[   28.507335] calling  powermate_init+0x0/0x16 @ 1
[   28.511932] bus: 'usb': add driver powermate
[   28.516284] usbcore: registered new interface driver powermate
[   28.522091] initcall powermate_init+0x0/0x16 returned 0 after 9921 usecs
[   28.528747] calling  i2c_ali15x3_init+0x0/0x16 @ 1
[   28.533531] bus: 'pci': add driver ali15x3_smbus
[   28.538277] initcall i2c_ali15x3_init+0x0/0x16 returned 0 after 4648 usecs
[   28.545113] calling  i2c_amd8111_init+0x0/0x16 @ 1
[   28.549884] bus: 'pci': add driver amd8111_smbus2
[   28.554728] initcall i2c_amd8111_init+0x0/0x16 returned 0 after 4736 usecs
[   28.561567] calling  i2c_piix4_init+0x0/0x16 @ 1
[   28.566164] bus: 'pci': add driver piix4_smbus
[   28.570734] initcall i2c_piix4_init+0x0/0x16 returned 0 after 4469 usecs
[   28.577398] calling  ocores_i2c_init+0x0/0xf @ 1
[   28.581990] bus: 'platform': add driver ocores-i2c
[   28.586863] initcall ocores_i2c_init+0x0/0xf returned 0 after 4759 usecs
[   28.593523] calling  i2c_parport_init+0x0/0x12b @ 1
[   28.598369] i2c-parport-light: adapter type unspecified
[   28.603572] initcall i2c_parport_init+0x0/0x12b returned -19 after 5076 usecs
[   28.610677] calling  usb_i2c_tiny_usb_init+0x0/0x16 @ 1
[   28.615883] bus: 'usb': add driver i2c-tiny-usb
[   28.620504] usbcore: registered new interface driver i2c-tiny-usb
[   28.626577] initcall usb_i2c_tiny_usb_init+0x0/0x16 returned 0 after 10447 usecs
[   28.633960] calling  scx200_acb_init+0x0/0x25b @ 1
[   28.638814] initcall scx200_acb_init+0x0/0x25b returned -19 after 83 usecs
[   28.645633] calling  ds1682_init+0x0/0x11 @ 1
[   28.649967] bus: 'i2c': add driver ds1682
[   28.654084] i2c-core: driver [ds1682] registered
[   28.658667] initcall ds1682_init+0x0/0x11 returned 0 after 8495 usecs
[   28.665070] calling  pca9539_init+0x0/0x11 @ 1
[   28.669488] bus: 'i2c': add driver pca9539
[   28.673655] i2c-core: driver [pca9539] registered
[   28.678335] initcall pca9539_init+0x0/0x11 returned 0 after 8637 usecs
[   28.684816] calling  pcf8575_init+0x0/0x11 @ 1
[   28.689236] bus: 'i2c': add driver pcf8575
[   28.693401] i2c-core: driver [pcf8575] registered
[   28.698086] initcall pcf8575_init+0x0/0x11 returned 0 after 8639 usecs
[   28.704572] calling  telephony_init+0x0/0x3f @ 1
[   28.709146] Linux telephony interface: v1.00
[   28.713415] initcall telephony_init+0x0/0x3f returned 0 after 4165 usecs
[   28.720070] calling  isdn_init+0x0/0x293 @ 1
[   28.726781] ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/none/1.1.2.2
[   28.733723] initcall isdn_init+0x0/0x293 returned 0 after 9185 usecs
[   28.740065] calling  isdn_bsdcomp_init+0x0/0x26 @ 1
[   28.744908] PPP BSD Compression module registered
[   28.749592] initcall isdn_bsdcomp_init+0x0/0x26 returned 0 after 4570 usecs
[   28.756521] calling  kcapi_init+0x0/0x83 @ 1
[   28.760874] CAPI Subsystem Rev 1.1.2.8
[   28.764574] initcall kcapi_init+0x0/0x83 returned 0 after 3716 usecs
[   28.770897] calling  capi_init+0x0/0x151 @ 1
[   28.775161] device class 'capi': registering
[   28.779522] device: 'capi': device_add
[   28.783515] PM: Adding info for No Bus:capi
[   28.787996] capi20: Rev 1.1.2.7: started up with major 68 (no middleware)
[   28.794764] initcall capi_init+0x0/0x151 returned 0 after 19154 usecs
[   28.801167] calling  c4_init+0x0/0xc0 @ 1
[   28.805172] bus: 'pci': add driver c4
[   28.809097] c4: revision 1.1.2.2
[   28.812290] initcall c4_init+0x0/0xc0 returned 0 after 6966 usecs
[   28.818347] calling  b1_init+0x0/0x6e @ 1
[   28.822332] b1: revision 1.1.2.2
[   28.825541] initcall b1_init+0x0/0x6e returned 0 after 3131 usecs
[   28.831605] calling  divadidd_init+0x0/0xc3 @ 1
[   28.836110] Eicon DIVA - DIDD table (http://www.melware.net)
[   28.841739] divadidd: Rel:2.0  Rev:1.13.6.4  Build:102-51(local)
[   28.847846] initcall divadidd_init+0x0/0xc3 returned 0 after 11456 usecs
[   28.854491] calling  divas_init+0x0/0x11b @ 1
[   28.858824] Eicon DIVA Server driver (http://www.melware.net)
[   28.864539] divas: Rel:2.0  Rev:1.55.4.6  Build: 102-52(local)
[   28.870343] divas: support for: BRI/PCI adapters
[   28.874985] bus: 'pci': add driver divas
[   28.879104] divas: started with major 248
[   28.883089] initcall divas_init+0x0/0x11b returned 0 after 23690 usecs
[   28.889577] calling  divasi_init+0x0/0xf5 @ 1
[   28.893907] Eicon DIVA - User IDI (http://www.melware.net)
[   28.899365] diva_idi: Rel:2.0  Rev:1.25.6.2  Build: local
[   28.904770] diva_idi: started with major 247
[   28.908988] initcall divasi_init+0x0/0xf5 returned 0 after 14724 usecs
[   28.915485] calling  HiSax_init+0x0/0x2fe @ 1
[   28.919816] HiSax: Linux Driver for passive ISDN cards
[   28.924927] HiSax: Version 3.5 (kernel)
[   28.928740] HiSax: Layer1 Revision 2.46.2.5
[   28.932902] HiSax: Layer2 Revision 2.30.2.4
[   28.937067] HiSax: TeiMgr Revision 2.20.2.3
[   28.941219] HiSax: Layer3 Revision 2.22.2.3
[   28.945378] HiSax: LinkLayer Revision 2.59.2.4
[   28.949829] HiSax: Total 1 card defined
[   28.953815] HiSax: Card 1 Protocol NI1 Id=HiSax (0)
[   28.958639] HiSax: Traverse Tech. NETspider-U driver Rev. 2.14.2.3
[   28.964814] NETspider-U: No PCI card found
[   28.968993] HiSax: Card NETspider-U not installed !
[   28.973835] initcall HiSax_init+0x0/0x2fe returned -19 after 52746 usecs
[   28.980501] calling  hfc4s8s_module_init+0x0/0x54 @ 1
[   28.985524] HFC-4S/8S: Layer 1 driver module for HFC-4S/8S isdn chips, Revision: 1.10
[   28.993338] HFC-4S/8S: (C) 2003 Cornelius Consult, www.cornelius-consult.de
[   29.000292] bus: 'pci': add driver hfc4s8s_l1
[   29.004779] HFC-4S/8S: found 0 cards
[   29.008324] initcall hfc4s8s_module_init+0x0/0x54 returned 0 after 22259 usecs
[   29.015533] calling  hisax_isac_init+0x0/0x4b @ 1
[   29.020211] hisax_isac: ISAC-S/ISAC-SX ISDN driver v0.1.0
[   29.025596] initcall hisax_isac_init+0x0/0x4b returned 0 after 5255 usecs
[   29.032345] calling  hisax_fcpcipnp_init+0x0/0x4c @ 1
[   29.037368] hisax_fcpcipnp: Fritz!Card PCI/PCIv2/PnP ISDN driver v0.0.1
[   29.043966] bus: 'pci': add driver fcpci
[   29.048060] bus: 'pnp': add driver fcpnp
[   29.052129] initcall hisax_fcpcipnp_init+0x0/0x4c returned 0 after 14406 usecs
[   29.059359] calling  edac_init+0x0/0x95 @ 1
[   29.063510] EDAC MC: Ver: 2.1.0 Apr  6 2009
[   29.067903] Registering sysdev class 'edac'
[   29.072644] initcall edac_init+0x0/0x95 returned 0 after 8908 usecs
[   29.078890] calling  amd76x_init+0x0/0x29 @ 1
[   29.083255] bus: 'pci': add driver amd76x_edac
[   29.087861] initcall amd76x_init+0x0/0x29 returned 0 after 4513 usecs
[   29.094263] calling  i5000_init+0x0/0x36 @ 1
[   29.098514] bus: 'pci': add driver i5000_edac
[   29.103062] initcall i5000_init+0x0/0x36 returned 0 after 4450 usecs
[   29.109384] calling  i5100_init+0x0/0x23 @ 1
[   29.113635] bus: 'pci': add driver i5100_edac
[   29.118162] initcall i5100_init+0x0/0x23 returned 0 after 4429 usecs
[   29.124477] calling  i5400_init+0x0/0x36 @ 1
[   29.128729] bus: 'pci': add driver i5400_edac
[   29.131276] async_waiting @ 2842
[   29.136470] initcall i5400_init+0x0/0x36 returned 0 after 7566 usecs
[   29.142788] calling  i82875p_init+0x0/0x85 @ 1
[   29.147213] bus: 'pci': add driver i82875p_edac
[   29.151962] bus: 'pci': remove driver i82875p_edac
[   29.156826] driver: 'i82875p_edac': driver_release
[   29.162763] initcall i82875p_init+0x0/0x85 returned -19 after 15192 usecs
[   29.169506] calling  i82975x_init+0x0/0x85 @ 1
[   29.173936] bus: 'pci': add driver i82975x_edac
[   29.178684] bus: 'pci': remove driver i82975x_edac
[   29.183551] driver: 'i82975x_edac': driver_release
[   29.188323] initcall i82975x_init+0x0/0x85 returned -19 after 14055 usecs
[   29.195067] calling  x38_init+0x0/0x8f @ 1
[   29.199144] bus: 'pci': add driver x38_edac
[   29.203539] bus: 'pci': remove driver x38_edac
[   29.208100] driver: 'x38_edac': driver_release
[   29.212520] initcall x38_init+0x0/0x8f returned -19 after 13069 usecs
[   29.218916] calling  i82860_init+0x0/0x85 @ 1
[   29.223262] bus: 'pci': add driver i82860_edac
[   29.227695] bus: 'pci': driver_probe_device: matched device 0000:00:00.0 with driver i82860_edac
[   29.236469] bus: 'pci': really_probe: probing driver i82860_edac with device 0000:00:00.0
[   29.244650] EDAC i82860: i82860 init one
[   29.250195] EDAC MC0: Giving out device to 'i82860_edac' 'i82860': DEV 0000:00:00.0
[   29.258559] EDAC PCI0: Giving out device to module 'i82860_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)
[   29.269951] driver: '0000:00:00.0': driver_bound: bound to device 'i82860_edac'
[   29.277261] bus: 'pci': really_probe: bound device 0000:00:00.0 to driver i82860_edac
[   29.285285] initcall i82860_init+0x0/0x85 returned 0 after 60574 usecs
[   29.291768] calling  cpufreq_stats_init+0x0/0x8b @ 1
[   29.296797] initcall cpufreq_stats_init+0x0/0x8b returned 0 after 88 usecs
[   29.303617] calling  cpufreq_gov_userspace_init+0x0/0xf @ 1
[   29.309170] initcall cpufreq_gov_userspace_init+0x0/0xf returned 0 after 4 usecs
[   29.316554] calling  init_ladder+0x0/0xf @ 1
[   29.320858] cpuidle: using governor ladder
[   29.324901] initcall init_ladder+0x0/0xf returned 0 after 4003 usecs
[   29.331224] calling  init_menu+0x0/0xf @ 1
[   29.335297] cpuidle: using governor menu
[   29.339198] initcall init_menu+0x0/0xf returned 0 after 3808 usecs
[   29.345349] calling  mmc_blk_init+0x0/0x3d @ 1
[   29.349776] bus: 'mmc': add driver mmcblk
[   29.353861] initcall mmc_blk_init+0x0/0x3d returned 0 after 3994 usecs
[   29.360343] calling  mmc_test_init+0x0/0xf @ 1
[   29.364760] bus: 'mmc': add driver mmc_test
[   29.369060] initcall mmc_test_init+0x0/0xf returned 0 after 4196 usecs
[   29.375543] calling  sdio_uart_init+0x0/0xc6 @ 1
[   29.380169] bus: 'sdio': add driver sdio_uart
[   29.384592] initcall sdio_uart_init+0x0/0xc6 returned 0 after 4353 usecs
[   29.391254] calling  sdhci_drv_init+0x0/0x1b @ 1
[   29.395839] sdhci: Secure Digital Host Controller Interface driver
[   29.401988] sdhci: Copyright(c) Pierre Ossman
[   29.406327] initcall sdhci_drv_init+0x0/0x1b returned 0 after 10239 usecs
[   29.413085] calling  memstick_init+0x0/0x75 @ 1
[   29.417882] bus: 'memstick': registered
[   29.421675] device class 'memstick_host': registering
[   29.426850] initcall memstick_init+0x0/0x75 returned 0 after 9033 usecs
[   29.433427] calling  hifn_init+0x0/0x9d @ 1
[   29.437605] bus: 'pci': add driver hifn795x
[   29.441951] Driver for HIFN 795x crypto accelerator chip has been successfully registered.
[   29.450233] initcall hifn_init+0x0/0x9d returned 0 after 12351 usecs
[   29.456552] calling  init+0x0/0xf @ 1
[   29.460192] bus: 'virtio': add driver virtio_balloon
[   29.465230] initcall init+0x0/0xf returned 0 after 4919 usecs
[   29.470928] calling  compal_init+0x0/0x10e @ 1
[   29.475350] initcall compal_init+0x0/0x10e returned -19 after 4 usecs
[   29.481757] calling  tc1100_init+0x0/0x50 @ 1
[   29.486093] initcall tc1100_init+0x0/0x50 returned -19 after 2 usecs
[   29.492414] calling  asus_acpi_init+0x0/0xf8 @ 1
[   29.497064] bus: 'acpi': add driver asus_acpi
[   29.501552] bus: 'acpi': remove driver asus_acpi
[   29.506207] driver: 'asus_acpi': driver_release
[   29.510836] initcall asus_acpi_init+0x0/0xf8 returned -19 after 13466 usecs
[   29.517746] calling  flow_cache_init+0x0/0x14c @ 1
[   29.522868] initcall flow_cache_init+0x0/0x14c returned 0 after 348 usecs
[   29.529618] calling  llc_init+0x0/0x1b @ 1
[   29.533695] initcall llc_init+0x0/0x1b returned 0 after 4 usecs
[   29.539580] calling  snap_init+0x0/0x31 @ 1
[   29.543831] initcall snap_init+0x0/0x31 returned 0 after 87 usecs
[   29.549867] calling  blackhole_module_init+0x0/0xf @ 1
[   29.554984] initcall blackhole_module_init+0x0/0xf returned 0 after 3 usecs
[   29.561910] calling  police_init_module+0x0/0xf @ 1
[   29.566821] initcall police_init_module+0x0/0xf returned 0 after 55 usecs
[   29.573557] calling  pedit_init_module+0x0/0xf @ 1
[   29.578326] initcall pedit_init_module+0x0/0xf returned 0 after 2 usecs
[   29.584908] calling  cbq_module_init+0x0/0xf @ 1
[   29.589503] initcall cbq_module_init+0x0/0xf returned 0 after 2 usecs
[   29.595912] calling  red_module_init+0x0/0xf @ 1
[   29.600509] initcall red_module_init+0x0/0xf returned 0 after 2 usecs
[   29.606917] calling  dsmark_module_init+0x0/0xf @ 1
[   29.611774] initcall dsmark_module_init+0x0/0xf returned 0 after 2 usecs
[   29.618442] calling  prio_module_init+0x0/0xf @ 1
[   29.623124] initcall prio_module_init+0x0/0xf returned 0 after 2 usecs
[   29.629620] calling  atm_init+0x0/0xf @ 1
[   29.633610] initcall atm_init+0x0/0xf returned 0 after 2 usecs
[   29.639411] calling  drr_init+0x0/0xf @ 1
[   29.643401] initcall drr_init+0x0/0xf returned 0 after 2 usecs
[   29.649203] calling  init_route4+0x0/0xf @ 1
[   29.653501] initcall init_route4+0x0/0xf returned 0 after 48 usecs
[   29.659628] calling  init_fw+0x0/0xf @ 1
[   29.663531] initcall init_fw+0x0/0xf returned 0 after 2 usecs
[   29.669247] calling  init_tcindex+0x0/0xf @ 1
[   29.673582] initcall init_tcindex+0x0/0xf returned 0 after 2 usecs
[   29.679731] calling  cls_flow_init+0x0/0xf @ 1
[   29.684154] initcall cls_flow_init+0x0/0xf returned 0 after 2 usecs
[   29.690390] calling  init_cgroup_cls+0x0/0xf @ 1
[   29.694985] initcall init_cgroup_cls+0x0/0xf returned 0 after 2 usecs
[   29.701568] calling  sysctl_ipv4_init+0x0/0x3f @ 1
[   29.708628] initcall sysctl_ipv4_init+0x0/0x3f returned 0 after 2259 usecs
[   29.713303] hub 1-0:1.0: hub_suspend
[   29.713553] usb usb1: bus auto-suspend
[   29.713587] usb usb1: suspend_rh
[   29.713699] hub 2-0:1.0: hub_suspend
[   29.713714] usb usb2: bus auto-suspend
[   29.713720] usb usb2: suspend_rh
[   29.736421] calling  ipip_init+0x0/0x5f @ 1
[   29.740577] IPv4 over IPv4 tunneling driver
[   29.744849] device: 'tunl0': device_add
[   29.748908] PM: Adding info for No Bus:tunl0
[   29.754830] initcall ipip_init+0x0/0x5f returned 0 after 13912 usecs
[   29.761133] calling  init_syncookies+0x0/0x16 @ 1
[   29.765890] initcall init_syncookies+0x0/0x16 returned 0 after 76 usecs
[   29.772449] calling  tunnel4_init+0x0/0x5a @ 1
[   29.776874] initcall tunnel4_init+0x0/0x5a returned 0 after 4 usecs
[   29.783107] calling  tcp_westwood_register+0x0/0xf @ 1
[   29.788219] TCP westwood registered
[   29.791687] initcall tcp_westwood_register+0x0/0xf returned 0 after 3385 usecs
[   29.798894] calling  htcp_register+0x0/0xf @ 1
[   29.803312] TCP htcp registered
[   29.806435] initcall htcp_register+0x0/0xf returned 0 after 3046 usecs
[   29.812932] calling  tcp_veno_register+0x0/0x11 @ 1
[   29.817784] TCP veno registered
[   29.820906] initcall tcp_veno_register+0x0/0x11 returned 0 after 3046 usecs
[   29.827836] calling  tcp_lp_register+0x0/0xf @ 1
[   29.832428] TCP lp registered
[   29.835377] initcall tcp_lp_register+0x0/0xf returned 0 after 2877 usecs
[   29.842056] calling  tcp_illinois_register+0x0/0xf @ 1
[   29.847159] TCP illinois registered
[   29.850629] initcall tcp_illinois_register+0x0/0xf returned 0 after 3385 usecs
[   29.857835] calling  packet_init+0x0/0x39 @ 1
[   29.862172] NET: Registered protocol family 17
[   29.866728] initcall packet_init+0x0/0x39 returned 0 after 4448 usecs
[   29.873114] calling  br_init+0x0/0xae @ 1
[   29.877595] initcall br_init+0x0/0xae returned 0 after 480 usecs
[   29.883568] calling  atalk_init+0x0/0x77 @ 1
[   29.887810] NET: Registered protocol family 5
[   29.900394] initcall atalk_init+0x0/0x77 returned 0 after 12282 usecs
[   29.906790] calling  init_sunrpc+0x0/0x53 @ 1
[   29.913958] RPC: Registered udp transport module.
[   29.918625] RPC: Registered tcp transport module.
[   29.923311] initcall init_sunrpc+0x0/0x53 returned 0 after 11900 usecs
[   29.929802] calling  init_rpcsec_gss+0x0/0x3f @ 1
[   29.934638] initcall init_rpcsec_gss+0x0/0x3f returned 0 after 151 usecs
[   29.941282] calling  init_kerberos_module+0x0/0x26 @ 1
[   29.946506] initcall init_kerberos_module+0x0/0x26 returned 0 after 106 usecs
[   29.953588] calling  af_rxrpc_init+0x0/0x168 @ 1
[   29.959612] NET: Registered protocol family 33
[   29.964191] initcall af_rxrpc_init+0x0/0x168 returned 0 after 5865 usecs
[   29.970841] calling  phonet_init+0x0/0x6b @ 1
[   29.975195] NET: Registered protocol family 35
[   29.980132] initcall phonet_init+0x0/0x6b returned 0 after 4839 usecs
[   29.986535] calling  pep_register+0x0/0x14 @ 1
[   29.991277] initcall pep_register+0x0/0x14 returned 0 after 317 usecs
[   29.997680] calling  dccp_init+0x0/0x333 @ 1
[   30.018846] CCID: Activated CCID 2 (TCP-like)
[   30.023772] CCID: Activated CCID 3 (TCP-Friendly Rate Control)
[   30.029587] initcall dccp_init+0x0/0x333 returned 0 after 27008 usecs
[   30.035986] calling  dccp_v4_init+0x0/0x70 @ 1
[   30.045371] initcall dccp_v4_init+0x0/0x70 returned 0 after 4839 usecs
[   30.051883] calling  dccpprobe_init+0x0/0xc6 @ 1
[   30.062506] DCCP watch registered (port=0)
[   30.066551] initcall dccpprobe_init+0x0/0xc6 returned 0 after 9841 usecs
[   30.073219] calling  lib80211_init+0x0/0x19 @ 1
[   30.077723] lib80211: common routines for IEEE802.11 drivers
[   30.083465] lib80211_crypt: registered algorithm 'NULL'
[   30.088637] initcall lib80211_init+0x0/0x19 returned 0 after 10654 usecs
[   30.095306] calling  dcbnl_init+0x0/0x2d @ 1
[   30.099556] initcall dcbnl_init+0x0/0x2d returned 0 after 2 usecs
[   30.105620] calling  powernow_init+0x0/0xd3 @ 1
[   30.111236] initcall powernow_init+0x0/0xd3 returned -19 after 1 usecs
[   30.117732] calling  centrino_init+0x0/0x2a @ 1
[   30.122241] initcall centrino_init+0x0/0x2a returned -19 after 1 usecs
[   30.128739] calling  update_mp_table+0x0/0x3c1 @ 1
[   30.133505] initcall update_mp_table+0x0/0x3c1 returned 0 after 1 usecs
[   30.140088] calling  lapic_insert_resource+0x0/0x33 @ 1
[   30.145296] initcall lapic_insert_resource+0x0/0x33 returned 0 after 7 usecs
[   30.152305] calling  print_ipi_mode+0x0/0x25 @ 1
[   30.156898] Using IPI No-Shortcut mode
[   30.160625] initcall print_ipi_mode+0x0/0x25 returned 0 after 3637 usecs
[   30.167297] calling  init_lapic_nmi_sysfs+0x0/0x33 @ 1
[   30.172413] initcall init_lapic_nmi_sysfs+0x0/0x33 returned 0 after 1 usecs
[   30.179343] calling  ioapic_insert_resources+0x0/0x4b @ 1
[   30.184718] initcall ioapic_insert_resources+0x0/0x4b returned 0 after 3 usecs
[   30.191923] calling  io_apic_bug_finalize+0x0/0x1a @ 1
[   30.197054] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 1 usecs
[   30.203969] calling  check_early_ioremap_leak+0x0/0x5e @ 1
[   30.209430] initcall check_early_ioremap_leak+0x0/0x5e returned 0 after 1 usecs
[   30.216723] calling  pat_memtype_list_init+0x0/0x23 @ 1
[   30.221968] initcall pat_memtype_list_init+0x0/0x23 returned 0 after 35 usecs
[   30.229059] calling  sched_init_debug+0x0/0x1f @ 1
[   30.233841] initcall sched_init_debug+0x0/0x1f returned 0 after 18 usecs
[   30.240496] calling  init_oops_id+0x0/0x3f @ 1
[   30.244928] initcall init_oops_id+0x0/0x3f returned 0 after 14 usecs
[   30.251440] calling  disable_boot_consoles+0x0/0x36 @ 1
[   30.256626] initcall disable_boot_consoles+0x0/0x36 returned 0 after 1 usecs
[   30.263783] calling  pm_qos_power_init+0x0/0x54 @ 1
[   30.268631] device: 'cpu_dma_latency': device_add
[   30.273548] PM: Adding info for No Bus:cpu_dma_latency
[   30.278742] device: 'network_latency': device_add
[   30.283594] PM: Adding info for No Bus:network_latency
[   30.288788] device: 'network_throughput': device_add
[   30.293868] PM: Adding info for No Bus:network_throughput
[   30.299316] initcall pm_qos_power_init+0x0/0x54 returned 0 after 29976 usecs
[   30.306329] calling  debugfs_kprobe_init+0x0/0x78 @ 1
[   30.311410] initcall debugfs_kprobe_init+0x0/0x78 returned 0 after 58 usecs
[   30.318315] calling  taskstats_init+0x0/0x7d @ 1
[   30.322954] registered taskstats version 1
[   30.327000] initcall taskstats_init+0x0/0x7d returned 0 after 3994 usecs
[   30.333670] calling  clear_boot_tracer+0x0/0x27 @ 1
[   30.338525] initcall clear_boot_tracer+0x0/0x27 returned 0 after 1 usecs
[   30.345198] calling  random32_reseed+0x0/0x7d @ 1
[   30.349933] initcall random32_reseed+0x0/0x7d returned 0 after 56 usecs
[   30.356493] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
[   30.362749] initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned 0 after 15 usecs
[   30.370913] calling  pci_sysfs_init+0x0/0x44 @ 1
[   30.376147] initcall pci_sysfs_init+0x0/0x44 returned 0 after 625 usecs
[   30.382707] calling  seqgen_init+0x0/0xe @ 1
[   30.386990] initcall seqgen_init+0x0/0xe returned 0 after 35 usecs
[   30.393123] calling  hd_init+0x0/0x2ab @ 1
[   30.397260] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[   30.405098] initcall hd_init+0x0/0x2ab returned -1 after 7717 usecs
[   30.411311] initcall hd_init+0x0/0x2ab returned with error code -1 
[   30.417550] calling  scsi_complete_async_scans+0x0/0x12a @ 1
[   30.423185] initcall scsi_complete_async_scans+0x0/0x12a returned 0 after 1 usecs
[   30.430653] calling  memmap_init+0x0/0xb8 @ 1
[   30.435222] initcall memmap_init+0x0/0xb8 returned 0 after 231 usecs
[   30.441518] calling  init_net_drop_monitor+0x0/0x112 @ 1
[   30.446801] Initalizing network drop monitor service
[   30.451866] initcall init_net_drop_monitor+0x0/0x112 returned 0 after 4942 usecs
[   30.459255] calling  tcp_congestion_default+0x0/0xf @ 1
[   30.464458] initcall tcp_congestion_default+0x0/0xf returned 0 after 3 usecs
[   30.471472] calling  ip_auto_config+0x0/0xc87 @ 1
[   30.476180] initcall ip_auto_config+0x0/0xc87 returned 0 after 25 usecs
[   30.482740] calling  initialize_hashrnd+0x0/0x16 @ 1
[   30.487690] initcall initialize_hashrnd+0x0/0x16 returned 0 after 11 usecs
[   30.494579] async_waiting @ 1
[   36.282035] CPA self-test:
[   36.284818]  4k 2046 large 219 gb 0 x 2265[c0000000-f73fd000] miss 0
[   36.324938]  4k 190462 large 35 gb 0 x 190497[c0000000-f73fd000] miss 0
[   36.357747]  4k 190462 large 35 gb 0 x 190497[c0000000-f73fd000] miss 0
[   36.364308] ok.
[  246.929049] INFO: task swapper:1 blocked for more than 120 seconds.
[  246.935271] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  246.943095] swapper       D fed30457     0     1      0
[  246.948292]  f6c81f60 00000046 f6c78000 fed30457 00000006 c0c69270 c0c69270 c0c69270
[  246.955984]  c0c63a00 f6c78000 f6c78288 c2065270 00000001 c0c69270 00000002 c01507b4
[  246.963698]  00000006 c0b1e170 c07ab1db fffbe336 00000000 c0150771 c0b2a5fc 00000286
[  246.971409] Call Trace:
[  246.973873]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  246.978891]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  246.984607]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  246.990586]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  246.995615]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  247.001939]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  247.007656]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  247.013288]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  247.018751]  [<c0413cd0>] wait_for_device_probe+0x6f/0x75
[  247.024120]  [<c01ab7b1>] ? sys_access+0x15/0x17
[  247.028714]  [<c0bf8c9f>] prepare_namespace+0x2d/0x138
[  247.033827]  [<c0bf8533>] kernel_init+0x140/0x14f
[  247.038504]  [<c0bf83f3>] ? kernel_init+0x0/0x14f
[  247.043185]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  247.048378] no locks held by swapper/1.
[  247.052232] INFO: task async/1:2842 blocked for more than 120 seconds.
[  247.058707] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  247.066521] async/1       D c85b8a4f     0  2842      2
[  247.071719]  f4ef3eec 00000046 f4945af0 c85b8a4f 00000006 c0c69270 c0c69270 c0c69270
[  247.079413]  c0c63a00 f4945af0 f4945d78 c2075270 00000002 c0c69270 f4ef3eb4 c0150644
[  247.087143]  00000006 c0b1e170 c07ab1db fffbdded 00000000 c0150771 c0b2a5fc 00000286
[  247.094836] Call Trace:
[  247.097289]  [<c0150644>] ? mark_held_locks+0x42/0x5a
[  247.102315]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  247.108039]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  247.114023]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  247.119040]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  247.125364]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  247.131083]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  247.136716]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  247.142175]  [<c043d855>] scsi_complete_async_scans+0x120/0x12a
[  247.148068]  [<c043db76>] __scsi_add_device+0x6c/0xb0
[  247.153094]  [<c04c5243>] ata_scsi_scan_host+0x86/0x17e
[  247.158293]  [<c04c32d0>] async_port_probe+0xa2/0xaa
[  247.163231]  [<c0148109>] ? async_thread+0x0/0x1cc
[  247.167996]  [<c01481f4>] async_thread+0xeb/0x1cc
[  247.172679]  [<c012a63a>] ? default_wake_function+0x0/0x12
[  247.178135]  [<c01429fd>] kthread+0x40/0x67
[  247.182293]  [<c01429bd>] ? kthread+0x0/0x67
[  247.186541]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  247.191736] 1 lock held by async/1/2842:
[  247.195632]  #0:  (&shost->scan_mutex){+.+.+.}, at: [<c043db68>] __scsi_add_device+0x5e/0xb0
[  367.204051] INFO: task swapper:1 blocked for more than 120 seconds.
[  367.210270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  367.218093] swapper       D fed30457     0     1      0
[  367.223293]  f6c81f60 00000046 f6c78000 fed30457 00000006 c0c69270 c0c69270 c0c69270
[  367.230984]  c0c63a00 f6c78000 f6c78288 c2065270 00000001 c0c69270 00000002 c01507b4
[  367.238697]  00000006 c0b1e170 c07ab1db fffbe336 00000000 c0150771 c0b2a5fc 00000286
[  367.246409] Call Trace:
[  367.248871]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  367.253904]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  367.259607]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  367.265585]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  367.270611]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  367.276937]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  367.282654]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  367.288283]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  367.293749]  [<c0413cd0>] wait_for_device_probe+0x6f/0x75
[  367.299119]  [<c01ab7b1>] ? sys_access+0x15/0x17
[  367.303712]  [<c0bf8c9f>] prepare_namespace+0x2d/0x138
[  367.308826]  [<c0bf8533>] kernel_init+0x140/0x14f
[  367.313503]  [<c0bf83f3>] ? kernel_init+0x0/0x14f
[  367.318183]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  367.323376] no locks held by swapper/1.
[  367.327230] INFO: task async/1:2842 blocked for more than 120 seconds.
[  367.333706] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  367.341520] async/1       D c85b8a4f     0  2842      2
[  367.346718]  f4ef3eec 00000046 f4945af0 c85b8a4f 00000006 c0c69270 c0c69270 c0c69270
[  367.354411]  c0c63a00 f4945af0 f4945d78 c2075270 00000002 c0c69270 f4ef3eb4 c0150644
[  367.362141]  00000006 c0b1e170 c07ab1db fffbdded 00000000 c0150771 c0b2a5fc 00000286
[  367.369836] Call Trace:
[  367.372288]  [<c0150644>] ? mark_held_locks+0x42/0x5a
[  367.377314]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  367.383038]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  367.389022]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  367.394043]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  367.400363]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  367.406081]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  367.412832]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  367.418291]  [<c043d855>] scsi_complete_async_scans+0x120/0x12a
[  367.424183]  [<c043db76>] __scsi_add_device+0x6c/0xb0
[  367.429211]  [<c04c5243>] ata_scsi_scan_host+0x86/0x17e
[  367.434408]  [<c04c32d0>] async_port_probe+0xa2/0xaa
[  367.439347]  [<c0148109>] ? async_thread+0x0/0x1cc
[  367.444112]  [<c01481f4>] async_thread+0xeb/0x1cc
[  367.448795]  [<c012a63a>] ? default_wake_function+0x0/0x12
[  367.454251]  [<c01429fd>] kthread+0x40/0x67
[  367.458410]  [<c01429bd>] ? kthread+0x0/0x67
[  367.462657]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  367.467852] 1 lock held by async/1/2842:
[  367.471749]  #0:  (&shost->scan_mutex){+.+.+.}, at: [<c043db68>] __scsi_add_device+0x5e/0xb0
[  487.480052] INFO: task swapper:1 blocked for more than 120 seconds.
[  487.486277] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  487.494098] swapper       D fed30457     0     1      0
[  487.499295]  f6c81f60 00000046 f6c78000 fed30457 00000006 c0c69270 c0c69270 c0c69270
[  487.506987]  c0c63a00 f6c78000 f6c78288 c2065270 00000001 c0c69270 00000002 c01507b4
[  487.514700]  00000006 c0b1e170 c07ab1db fffbe336 00000000 c0150771 c0b2a5fc 00000286
[  487.522412] Call Trace:
[  487.524874]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  487.529894]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  487.535609]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  487.541590]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  487.546615]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  487.552940]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  487.558659]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  487.564291]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  487.569753]  [<c0413cd0>] wait_for_device_probe+0x6f/0x75
[  487.575124]  [<c01ab7b1>] ? sys_access+0x15/0x17
[  487.579715]  [<c0bf8c9f>] prepare_namespace+0x2d/0x138
[  487.584829]  [<c0bf8533>] kernel_init+0x140/0x14f
[  487.589507]  [<c0bf83f3>] ? kernel_init+0x0/0x14f
[  487.594188]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  487.599381] no locks held by swapper/1.
[  487.603235] INFO: task async/1:2842 blocked for more than 120 seconds.
[  487.609709] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  487.617524] async/1       D c85b8a4f     0  2842      2
[  487.622723]  f4ef3eec 00000046 f4945af0 c85b8a4f 00000006 c0c69270 c0c69270 c0c69270
[  487.630416]  c0c63a00 f4945af0 f4945d78 c2075270 00000002 c0c69270 f4ef3eb4 c0150644
[  487.638145]  00000006 c0b1e170 c07ab1db fffbdded 00000000 c0150771 c0b2a5fc 00000286
[  487.645840] Call Trace:
[  487.648293]  [<c0150644>] ? mark_held_locks+0x42/0x5a
[  487.653318]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  487.659040]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  487.665026]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  487.670043]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  487.676366]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  487.682085]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  487.687717]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  487.693178]  [<c043d855>] scsi_complete_async_scans+0x120/0x12a
[  487.699069]  [<c043db76>] __scsi_add_device+0x6c/0xb0
[  487.704096]  [<c04c5243>] ata_scsi_scan_host+0x86/0x17e
[  487.709296]  [<c04c32d0>] async_port_probe+0xa2/0xaa
[  487.714233]  [<c0148109>] ? async_thread+0x0/0x1cc
[  487.718999]  [<c01481f4>] async_thread+0xeb/0x1cc
[  487.723681]  [<c012a63a>] ? default_wake_function+0x0/0x12
[  487.729138]  [<c01429fd>] kthread+0x40/0x67
[  487.733297]  [<c01429bd>] ? kthread+0x0/0x67
[  487.737543]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  487.742741] 1 lock held by async/1/2842:
[  487.746636]  #0:  (&shost->scan_mutex){+.+.+.}, at: [<c043db68>] __scsi_add_device+0x5e/0xb0
[  607.755049] INFO: task swapper:1 blocked for more than 120 seconds.
[  607.761225] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  607.769022] swapper       D fed30457     0     1      0
[  607.774216]  f6c81f60 00000046 f6c78000 fed30457 00000006 c0c69270 c0c69270 c0c69270
[  607.781910]  c0c63a00 f6c78000 f6c78288 c2065270 00000001 c0c69270 00000002 c01507b4
[  607.789621]  00000006 c0b1e170 c07ab1db fffbe336 00000000 c0150771 c0b2a5fc 00000286
[  607.797333] Call Trace:
[  607.799795]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  607.804814]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  607.810530]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  607.816509]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  607.821534]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  607.827861]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  607.833579]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  607.839211]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  607.844673]  [<c0413cd0>] wait_for_device_probe+0x6f/0x75
[  607.850044]  [<c01ab7b1>] ? sys_access+0x15/0x17
[  607.854636]  [<c0bf8c9f>] prepare_namespace+0x2d/0x138
[  607.859751]  [<c0bf8533>] kernel_init+0x140/0x14f
[  607.864427]  [<c0bf83f3>] ? kernel_init+0x0/0x14f
[  607.869108]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  607.874301] no locks held by swapper/1.
[  607.878155] INFO: task async/1:2842 blocked for more than 120 seconds.
[  607.884614] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  607.892409] async/1       D c85b8a4f     0  2842      2
[  607.897608]  f4ef3eec 00000046 f4945af0 c85b8a4f 00000006 c0c69270 c0c69270 c0c69270
[  607.905302]  c0c63a00 f4945af0 f4945d78 c2075270 00000002 c0c69270 f4ef3eb4 c0150644
[  607.913036]  00000006 c0b1e170 c07ab1db fffbdded 00000000 c0150771 c0b2a5fc 00000286
[  607.920725] Call Trace:
[  607.923180]  [<c0150644>] ? mark_held_locks+0x42/0x5a
[  607.928203]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  607.933922]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  607.939900]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  607.944927]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  607.951253]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  607.956971]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  607.962604]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  607.968064]  [<c043d855>] scsi_complete_async_scans+0x120/0x12a
[  607.973955]  [<c043db76>] __scsi_add_device+0x6c/0xb0
[  607.978981]  [<c04c5243>] ata_scsi_scan_host+0x86/0x17e
[  607.984181]  [<c04c32d0>] async_port_probe+0xa2/0xaa
[  607.989119]  [<c0148109>] ? async_thread+0x0/0x1cc
[  607.993898]  [<c01481f4>] async_thread+0xeb/0x1cc
[  607.998571]  [<c012a63a>] ? default_wake_function+0x0/0x12
[  608.004033]  [<c01429fd>] kthread+0x40/0x67
[  608.008183]  [<c01429bd>] ? kthread+0x0/0x67
[  608.012431]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  608.017629] 1 lock held by async/1/2842:
[  608.021525]  #0:  (&shost->scan_mutex){+.+.+.}, at: [<c043db68>] __scsi_add_device+0x5e/0xb0
[  728.029071] INFO: task swapper:1 blocked for more than 120 seconds.
[  728.035253] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  728.043048] swapper       D fed30457     0     1      0
[  728.048245]  f6c81f60 00000046 f6c78000 fed30457 00000006 c0c69270 c0c69270 c0c69270
[  728.055938]  c0c63a00 f6c78000 f6c78288 c2065270 00000001 c0c69270 00000002 c01507b4
[  728.063650]  00000006 c0b1e170 c07ab1db fffbe336 00000000 c0150771 c0b2a5fc 00000286
[  728.071362] Call Trace:
[  728.073823]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  728.078841]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  728.084558]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  728.090537]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  728.095564]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  728.101890]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  728.107607]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  728.113238]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  728.118701]  [<c0413cd0>] wait_for_device_probe+0x6f/0x75
[  728.124072]  [<c01ab7b1>] ? sys_access+0x15/0x17
[  728.128664]  [<c0bf8c9f>] prepare_namespace+0x2d/0x138
[  728.133778]  [<c0bf8533>] kernel_init+0x140/0x14f
[  728.138456]  [<c0bf83f3>] ? kernel_init+0x0/0x14f
[  728.143137]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  728.148331] no locks held by swapper/1.
[  728.152185] INFO: task async/1:2842 blocked for more than 120 seconds.
[  728.158640] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  728.166438] async/1       D c85b8a4f     0  2842      2
[  728.171637]  f4ef3eec 00000046 f4945af0 c85b8a4f 00000006 c0c69270 c0c69270 c0c69270
[  728.179330]  c0c63a00 f4945af0 f4945d78 c2075270 00000002 c0c69270 f4ef3eb4 c0150644
[  728.187060]  00000006 c0b1e170 c07ab1db fffbdded 00000000 c0150771 c0b2a5fc 00000286
[  728.194754] Call Trace:
[  728.197208]  [<c0150644>] ? mark_held_locks+0x42/0x5a
[  728.202233]  [<c07ab1db>] ? _spin_unlock_irqrestore+0x3b/0x41
[  728.207952]  [<c0150771>] ? trace_hardirqs_on_caller+0x115/0x14d
[  728.213930]  [<c01507b4>] ? trace_hardirqs_on+0xb/0xd
[  728.218956]  [<c0147ebe>] async_synchronize_cookie_domain+0xac/0x103
[  728.225281]  [<c0142acc>] ? autoremove_wake_function+0x0/0x35
[  728.231000]  [<c0147f27>] async_synchronize_cookie+0x12/0x14
[  728.236632]  [<c01480ef>] async_synchronize_full+0x18/0x32
[  728.242092]  [<c043d855>] scsi_complete_async_scans+0x120/0x12a
[  728.247984]  [<c043db76>] __scsi_add_device+0x6c/0xb0
[  728.253032]  [<c04c5243>] ata_scsi_scan_host+0x86/0x17e
[  728.258208]  [<c04c32d0>] async_port_probe+0xa2/0xaa
[  728.263148]  [<c0148109>] ? async_thread+0x0/0x1cc
[  728.268979]  [<c01481f4>] async_thread+0xeb/0x1cc
[  728.273661]  [<c012a63a>] ? default_wake_function+0x0/0x12
[  728.279118]  [<c01429fd>] kthread+0x40/0x67
[  728.283277]  [<c01429bd>] ? kthread+0x0/0x67
[  728.287523]  [<c0103837>] kernel_thread_helper+0x7/0x10
[  728.292723] 1 lock held by async/1/2842:
[  728.296616]  #0:  (&shost->scan_mutex){+.+.+.}, at: [<c043db68>] __scsi_add_device+0x5e/0xb0
