Return-Path: <linux-kernel-owner+w=401wt.eu-S965419AbXJQPsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419AbXJQPsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbXJQPrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:47:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56177 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934288AbXJQPrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:47:46 -0400
Date: Wed, 17 Oct 2007 17:46:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [bug] block subsystem related crash with latest -git
Message-ID: <20071017154655.GA13394@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Jens, just got this crash on a testbox:

[   37.701628] warning: process `kmodule' used the removed sysctl system call with 1.23.
[   39.409390] BUG: unable to handle kernel paging request at virtual address 7ca76000
[   39.416892] printing eip: 78406669 *pde = 00dda027 *pte = 04a76000 
[   39.423132] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   39.427292] 
[   39.428766] Pid: 431, comm: fsck.ext3 Not tainted (2.6.23 #45)
[   39.434571] EIP: 0060:[<78406669>] EFLAGS: 00010006 CPU: 0
[   39.440035] EIP is at blk_rq_map_sg+0xb9/0x170
[   39.444450] EAX: 04aed000 EBX: 7ca1f380 ECX: 04aee000 EDX: 00095da0
[   39.450689] ESI: 7ca75ff0 EDI: 79180da0 EBP: 00001000 ESP: 7caa1cac
[   39.456929]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   39.462303] Process fsck.ext3 (pid: 431, ti=7caa0000 task=7ca80000 task.ti=7caa0000)
[   39.469841] Stack: 00000020 7b520000 00002000 04aef000 7ca75fe0 0000001f 00000001 00000000 
[   39.478161]        7ca1f300 01000002 7ca44980 7b522b94 7ca0de00 7b520000 784c89b5 7b520000 
[   39.486480]        784c843a 7ca0de00 7b520f20 7b522b94 7ca0de00 784e54a0 784f394b 00000000 
[   39.494799] Call Trace:
[   39.497400]  [<784c89b5>] scsi_init_io+0x55/0xe0
[   39.501992]  [<784c843a>] scsi_get_cmd_from_req+0x2a/0x40
[   39.507366]  [<784e54a0>] sd_prep_fn+0x80/0x940
[   39.511872]  [<784f394b>] ata_bmdma_start+0xb/0x20
[   39.516638]  [<784ef344>] ata_qc_issue_prot+0x164/0x1e0
[   39.521839]  [<78405c63>] elv_dispatch_sort+0x23/0xe0
[   39.526865]  [<784057d0>] elv_next_request+0xa0/0x130
[   39.531891]  [<787715b8>] _spin_lock_irq+0x38/0x50
[   39.536657]  [<784c9af4>] scsi_request_fn+0x1e4/0x370
[   39.541684]  [<78120e72>] del_timer+0x62/0x70
[   39.546016]  [<78408a45>] __generic_unplug_device+0x25/0x30
[   39.551563]  [<78408d15>] generic_unplug_device+0x15/0x30
[   39.556936]  [<78406430>] blk_backing_dev_unplug+0x0/0x10
[   39.562309]  [<7840643c>] blk_backing_dev_unplug+0xc/0x10
[   39.567682]  [<7818080d>] block_sync_page+0x2d/0x40
[   39.572535]  [<78144ee9>] sync_page+0x29/0x40
[   39.576868]  [<7876fdec>] __wait_on_bit_lock+0x3c/0x70
[   39.581981]  [<78144ec0>] sync_page+0x0/0x40
[   39.586227]  [<78144ea2>] __lock_page+0x52/0x60
[   39.590734]  [<7812ae90>] wake_bit_function+0x0/0x60
[   39.595674]  [<7814566c>] do_generic_mapping_read+0x21c/0x450
[   39.601393]  [<78144c30>] file_read_actor+0x0/0x130
[   39.606246]  [<78147227>] generic_file_aio_read+0x137/0x180
[   39.611793]  [<78144c30>] file_read_actor+0x0/0x130
[   39.616645]  [<78160d95>] do_sync_read+0xd5/0x120
[   39.621326]  [<78135cd8>] mark_held_locks+0x38/0x70
[   39.626179]  [<7812ae50>] autoremove_wake_function+0x0/0x40
[   39.631724]  [<787705b4>] mutex_lock_nested+0x1a4/0x200
[   39.636924]  [<78185611>] block_llseek+0x31/0xc0
[   39.641517]  [<787703a5>] __mutex_unlock_slowpath+0xb5/0x110
[   39.647150]  [<78135e1c>] trace_hardirqs_on+0x9c/0xb0
[   39.652177]  [<78160cc0>] do_sync_read+0x0/0x120
[   39.656770]  [<7816165b>] vfs_read+0xbb/0x120
[   39.661103]  [<78161a41>] sys_read+0x41/0x70
[   39.665349]  [<781028a2>] syscall_call+0x7/0xb
[   39.669769]  =======================
[   39.673322] Code: 05 c1 e1 0c 03 4a 08 8b 52 04 01 ca 89 54 24 0c 8b 3b 89 fa 29 c2 89 d0 c1 f8 05 c1 e0 0c 03 43 08 39 44 24 0c 0f 84 7e 00 00 00 <8b> 46 10 8d 56 10 a8 01 75 4c 89 3e 89 6e 0c 8b 43 08 89 46 04 

config and full bootlog attached.

i tried another bootup with the same kernel and the crash did not 
reoccur, so it seems to be spurious. This crash could be related to the 
scsi or block merges done in the past few days - never saw this before.

	Ingo

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log"

[    0.000000] Linux version 2.6.23 (mingo@dione) (gcc version 4.2.2) #45 Wed Oct 17 17:24:44 CEST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] using polling idle threads.
[    0.000000] using polling idle threads.
[    0.000000] ignoring highmem size on non-highmem kernel!
[    0.000000] 1023MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f5680
[    0.000000] Entering add_active_range(0, 0, 262128) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   262128
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] On node 0 totalpages: 262128
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 2015 pages used for memmap
[    0.000000]   Normal zone: 256017 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
[    0.000000] Processor #0 15:3 APIC version 17
[    0.000000] Processor #1 15:3 APIC version 17
[    0.000000] WARNING: NR_CPUS limit of 1 reached.  Processor ignored.
[    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 1
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
[    0.000000] Kernel command line: root=/dev/sda1 console=tty 3 debug profile=0 initcall_debug selinux=0 enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled earlyprintk=serial,ttyS0,115200,keep idle=poll maxcpus=1 nosmp highres=0 lapic hpet=disable idle=poll highmem=512m
[    0.000000] kernel profiling enabled (shift: 0)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] debug: sysrq always enabled.
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2160.216 MHz processor.
[   13.512953] spurious 8259A interrupt: IRQ7.
[   13.517829] Console: colour VGA+ 80x25
[   13.521401] console [tty0] enabled
[   13.821423] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[   13.829133] ... MAX_LOCKDEP_SUBCLASSES:    8
[   13.833380] ... MAX_LOCK_DEPTH:          30
[   13.837540] ... MAX_LOCKDEP_KEYS:        2048
[   13.841872] ... CLASSHASH_SIZE:           1024
[   13.846293] ... MAX_LOCKDEP_ENTRIES:     8192
[   13.850626] ... MAX_LOCKDEP_CHAINS:      16384
[   13.855046] ... CHAINHASH_SIZE:          8192
[   13.859379]  memory used by lock dependency info: 992 kB
[   13.864665]  per task-struct memory footprint: 1200 bytes
[   13.870323] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   13.877560] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   13.917852] Memory: 998396k/1048512k available (6601k kernel code, 49616k reserved, 2681k data, 372k init, 0k highmem)
[   13.928434] virtual kernel memory layout:
[   13.928435]     fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
[   13.928436]     vmalloc : 0xb8800000 - 0xfffb7000   (1143 MB)
[   13.928437]     lowmem  : 0x78000000 - 0xb7ff0000   (1023 MB)
[   13.928438]       .init : 0x78a14000 - 0x78a71000   ( 372 kB)
[   13.928439]       .data : 0x78772582 - 0x78a10a34   (2681 kB)
[   13.928440]       .text : 0x78100000 - 0x78772582   (6601 kB)
[   13.966734] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   14.058153] Calibrating delay using timer specific routine.. 4324.74 BogoMIPS (lpj=7204389)
[   14.066419] Security Framework v1.0.0 initialized
[   14.071033] Capability LSM initialized
[   14.074764] Mount-cache hash table entries: 512
[   14.079636] CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003 00000000
[   14.090167] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   14.097279] CPU: L2 Cache: 512K (64 bytes/line)
[   14.101785] CPU: After all inits, caps: 178bfbf7 e3d3fbff 00000000 00000410 00000001 00000000 00000003 00000000
[   14.111835] Compat vDSO mapped to ffffe000.
[   14.115999] CPU: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[   14.122925] Checking 'hlt' instruction... OK.
[   14.139083] Freeing SMP alternatives: 0k freed
[   14.143523] enabled ExtINT on CPU#0
[   14.146939] ExtINT not setup in hardware but reported by MP table
[   14.153036] ENABLING IO-APIC IRQs
[   14.156242] init IO_APIC IRQs
[   14.159189]  IO-APIC (apicid-pin) 2-0 not connected.
[   14.164181]  IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
[   14.172921] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
[   14.211647] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   14.217341] ...trying to set up timer (IRQ0) through the 8259A ... 
[   14.223407] ..... (found pin 0) ...works.
[   14.260473] number of MP IRQ sources: 17.
[   14.264463] number of IO-APIC #2 registers: 24.
[   14.268969] testing the IO APIC.......................
[   14.274084] IO APIC #2......
[   14.276942] .... register #00: 00000000
[   14.280755] .......    : physical APIC id: 00
[   14.285087] .......    : Delivery Type: 0
[   14.289074] .......    : LTS          : 0
[   14.293060] .... register #01: 00170011
[   14.296874] .......     : max redirection entries: 0017
[   14.302073] .......     : PRQ implemented: 0
[   14.306320] .......     : IO APIC version: 0011
[   14.310826] .... register #02: 00000000
[   14.314639] .......     : arbitration: 00
[   14.318626] .... IRQ redirection table:
[   14.322439]  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
[   14.328507]  00 001 01  0    0    0   0   0    1    1    31
[   14.334054]  01 001 01  0    0    0   0   0    1    1    39
[   14.339600]  02 000 00  1    0    0   0   0    0    0    00
[   14.345146]  03 001 01  1    1    0   1   0    1    1    41
[   14.350692]  04 001 01  0    0    0   0   0    1    1    49
[   14.356239]  05 001 01  1    1    0   1   0    1    1    51
[   14.361785]  06 001 01  0    0    0   0   0    1    1    59
[   14.367331]  07 001 01  1    0    0   0   0    1    1    61
[   14.372878]  08 001 01  0    0    0   0   0    1    1    69
[   14.378424]  09 001 01  0    0    0   0   0    1    1    71
[   14.383971]  0a 001 01  0    0    0   0   0    1    1    79
[   14.389517]  0b 001 01  1    1    0   1   0    1    1    81
[   14.395062]  0c 001 01  0    0    0   0   0    1    1    89
[   14.400609]  0d 001 01  0    0    0   0   0    1    1    91
[   14.406155]  0e 001 01  0    0    0   0   0    1    1    99
[   14.411702]  0f 001 01  0    0    0   0   0    1    1    A1
[   14.417248]  10 000 00  1    0    0   0   0    0    0    00
[   14.422795]  11 000 00  1    0    0   0   0    0    0    00
[   14.428341]  12 000 00  1    0    0   0   0    0    0    00
[   14.433887]  13 000 00  1    0    0   0   0    0    0    00
[   14.439434]  14 000 00  1    0    0   0   0    0    0    00
[   14.444980]  15 000 00  1    0    0   0   0    0    0    00
[   14.450526]  16 000 00  1    0    0   0   0    0    0    00
[   14.456072]  17 000 00  1    0    0   0   0    0    0    00
[   14.461616] IRQ to pin mappings:
[   14.464823] IRQ0 -> 0:0
[   14.467246] IRQ1 -> 0:1
[   14.469672] IRQ3 -> 0:3
[   14.472099] IRQ4 -> 0:4
[   14.474526] IRQ5 -> 0:5
[   14.476952] IRQ6 -> 0:6
[   14.479378] IRQ7 -> 0:7
[   14.481805] IRQ8 -> 0:8
[   14.484231] IRQ9 -> 0:9
[   14.486658] IRQ10 -> 0:10
[   14.489258] IRQ11 -> 0:11
[   14.491858] IRQ12 -> 0:12
[   14.494457] IRQ13 -> 0:13
[   14.497057] IRQ14 -> 0:14
[   14.499657] IRQ15 -> 0:15
[   14.502257] .................................... done.
[   14.507375] Using local APIC timer interrupts.
[   14.507376] calibrating APIC timer ...
[   14.621409] ... lapic delta = 1350029
[   14.624935] ... PM timer delta = 0
[   14.628315] ..... delta 1350029
[   14.631435] ..... mult: 57987084
[   14.634640] ..... calibration result: 720015
[   14.638887] ..... CPU clock speed is 2160.0875 MHz.
[   14.643740] ..... host bus clock speed is 216.0087 MHz.
[   14.648939] ... verify APIC timer
[   14.758885] ... jiffies delta = 30
[   14.762157] ... jiffies result ok
[   14.765591] Calling initcall 0x78a4abe0: init_cpufreq_transition_notifier_list+0x0/0x10()
[   14.773604] initcall 0x78a4abe0: init_cpufreq_transition_notifier_list+0x0/0x10() returned 0.
[   14.782095] initcall 0x78a4abe0 ran for 0 msecs: init_cpufreq_transition_notifier_list+0x0/0x10()
[   14.790935] Calling initcall 0x78a4d1e0: net_ns_init+0x0/0x180()
[   14.796914] net_namespace: 64 bytes
[   14.800413] initcall 0x78a4d1e0: net_ns_init+0x0/0x180() returned 0.
[   14.806707] initcall 0x78a4d1e0 ran for 3 msecs: net_ns_init+0x0/0x180()
[   14.813381] Calling initcall 0x78a19b40: cpufreq_tsc+0x0/0x10()
[   14.819273] initcall 0x78a19b40: cpufreq_tsc+0x0/0x10() returned 0.
[   14.825514] initcall 0x78a19b40 ran for 0 msecs: cpufreq_tsc+0x0/0x10()
[   14.832620] Calling initcall 0x78a1d9c0: reboot_init+0x0/0x10()
[   14.838514] initcall 0x78a1d9c0: reboot_init+0x0/0x10() returned 0.
[   14.844751] initcall 0x78a1d9c0 ran for 0 msecs: reboot_init+0x0/0x10()
[   14.851337] Calling initcall 0x78a232f0: print_banner+0x0/0x10()
[   14.857317] Booting paravirtualized kernel on bare hardware
[   14.862865] initcall 0x78a232f0: print_banner+0x0/0x10() returned 0.
[   14.869191] initcall 0x78a232f0 ran for 3 msecs: print_banner+0x0/0x10()
[   14.875864] Calling initcall 0x78a24850: sysctl_init+0x0/0x10()
[   14.881760] initcall 0x78a24850: sysctl_init+0x0/0x10() returned 0.
[   14.887995] initcall 0x78a24850 ran for 0 msecs: sysctl_init+0x0/0x10()
[   14.894581] Calling initcall 0x78a254c0: init_jiffies_clocksource+0x0/0x10()
[   14.901606] initcall 0x78a254c0: init_jiffies_clocksource+0x0/0x10() returned 0.
[   14.908968] initcall 0x78a254c0 ran for 0 msecs: init_jiffies_clocksource+0x0/0x10()
[   14.916682] Calling initcall 0x78a25990: ksysfs_init+0x0/0x50()
[   14.922576] initcall 0x78a25990: ksysfs_init+0x0/0x50() returned 0.
[   14.928814] initcall 0x78a25990 ran for 0 msecs: ksysfs_init+0x0/0x50()
[   14.935399] Calling initcall 0x78a27a60: filelock_init+0x0/0x30()
[   14.941465] initcall 0x78a27a60: filelock_init+0x0/0x30() returned 0.
[   14.947878] initcall 0x78a27a60 ran for 0 msecs: filelock_init+0x0/0x30()
[   14.954637] Calling initcall 0x78a28440: init_misc_binfmt+0x0/0x40()
[   14.960971] initcall 0x78a28440: init_misc_binfmt+0x0/0x40() returned 0.
[   14.967637] initcall 0x78a28440 ran for 0 msecs: init_misc_binfmt+0x0/0x40()
[   14.974656] Calling initcall 0x78a28480: init_script_binfmt+0x0/0x10()
[   14.981156] initcall 0x78a28480: init_script_binfmt+0x0/0x10() returned 0.
[   14.988002] initcall 0x78a28480 ran for 0 msecs: init_script_binfmt+0x0/0x10()
[   14.995195] Calling initcall 0x78a28490: init_elf_binfmt+0x0/0x10()
[   15.001434] initcall 0x78a28490: init_elf_binfmt+0x0/0x10() returned 0.
[   15.008021] initcall 0x78a28490 ran for 0 msecs: init_elf_binfmt+0x0/0x10()
[   15.014953] Calling initcall 0x78a2a6f0: debugfs_init+0x0/0x40()
[   15.020937] initcall 0x78a2a6f0: debugfs_init+0x0/0x40() returned 0.
[   15.027259] initcall 0x78a2a6f0 ran for 0 msecs: debugfs_init+0x0/0x40()
[   15.033934] Calling initcall 0x78a2af40: securityfs_init+0x0/0x40()
[   15.040175] initcall 0x78a2af40: securityfs_init+0x0/0x40() returned 0.
[   15.046758] initcall 0x78a2af40 ran for 0 msecs: securityfs_init+0x0/0x40()
[   15.053693] Calling initcall 0x78a2b9a0: random32_init+0x0/0x20()
[   15.059758] initcall 0x78a2b9a0: random32_init+0x0/0x20() returned 0.
[   15.066171] initcall 0x78a2b9a0 ran for 0 msecs: random32_init+0x0/0x20()
[   15.072932] Calling initcall 0x78a4abf0: cpufreq_core_init+0x0/0x30()
[   15.079343] initcall 0x78a4abf0: cpufreq_core_init+0x0/0x30() returned 0.
[   15.086104] initcall 0x78a4abf0 ran for 0 msecs: cpufreq_core_init+0x0/0x30()
[   15.093210] Calling initcall 0x78a4d090: sock_init+0x0/0x60()
[   15.098962] initcall 0x78a4d090: sock_init+0x0/0x60() returned 0.
[   15.104995] initcall 0x78a4d090 ran for 0 msecs: sock_init+0x0/0x60()
[   15.111407] Calling initcall 0x78a4dbd0: netpoll_init+0x0/0x40()
[   15.117388] initcall 0x78a4dbd0: netpoll_init+0x0/0x40() returned 0.
[   15.123714] initcall 0x78a4dbd0 ran for 0 msecs: netpoll_init+0x0/0x40()
[   15.130388] Calling initcall 0x78a4e2e0: netlink_proto_init+0x0/0x140()
[   15.136997] NET: Registered protocol family 16
[   15.141411] initcall 0x78a4e2e0: netlink_proto_init+0x0/0x140() returned 0.
[   15.148325] initcall 0x78a4e2e0 ran for 3 msecs: netlink_proto_init+0x0/0x140()
[   15.155606] Calling initcall 0x78a2bac0: pcibus_class_init+0x0/0x10()
[   15.162032] initcall 0x78a2bac0: pcibus_class_init+0x0/0x10() returned 0.
[   15.168778] initcall 0x78a2bac0 ran for 0 msecs: pcibus_class_init+0x0/0x10()
[   15.175885] Calling initcall 0x78a2d020: pci_driver_init+0x0/0x10()
[   15.182145] initcall 0x78a2d020: pci_driver_init+0x0/0x10() returned 0.
[   15.188710] initcall 0x78a2d020 ran for 0 msecs: pci_driver_init+0x0/0x10()
[   15.195643] Calling initcall 0x78a2d160: lcd_class_init+0x0/0x50()
[   15.201804] initcall 0x78a2d160: lcd_class_init+0x0/0x50() returned 0.
[   15.208295] initcall 0x78a2d160 ran for 0 msecs: lcd_class_init+0x0/0x50()
[   15.215141] Calling initcall 0x78a2d1b0: backlight_class_init+0x0/0x50()
[   15.221822] initcall 0x78a2d1b0: backlight_class_init+0x0/0x50() returned 0.
[   15.228835] initcall 0x78a2d1b0 ran for 0 msecs: backlight_class_init+0x0/0x50()
[   15.236201] Calling initcall 0x78a2d370: tty_class_init+0x0/0x20()
[   15.242361] initcall 0x78a2d370: tty_class_init+0x0/0x20() returned 0.
[   15.248854] initcall 0x78a2d370 ran for 0 msecs: tty_class_init+0x0/0x20()
[   15.255700] Calling initcall 0x78a2ddb0: vtconsole_class_init+0x0/0xd0()
[   15.262397] initcall 0x78a2ddb0: vtconsole_class_init+0x0/0xd0() returned 0.
[   15.269393] initcall 0x78a2ddb0 ran for 0 msecs: vtconsole_class_init+0x0/0xd0()
[   15.276759] Calling initcall 0x78a199b0: init_pit_clocksource+0x0/0x70()
[   15.283442] initcall 0x78a199b0: init_pit_clocksource+0x0/0x70() returned 0.
[   15.290452] initcall 0x78a199b0 ran for 0 msecs: init_pit_clocksource+0x0/0x70()
[   15.297820] Calling initcall 0x78a4b8a0: pci_access_init+0x0/0x30()
[   15.308637] PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
[   15.314857] initcall 0x78a4b8a0: pci_access_init+0x0/0x30() returned 0.
[   15.321440] initcall 0x78a4b8a0 ran for 6 msecs: pci_access_init+0x0/0x30()
[   15.328375] Calling initcall 0x78a19010: request_standard_resources+0x0/0x3a0()
[   15.335652] Setting up standard PCI resources
[   15.342812] initcall 0x78a19010: request_standard_resources+0x0/0x3a0() returned 0.
[   15.350309] initcall 0x78a19010 ran for 6 msecs: request_standard_resources+0x0/0x3a0()
[   15.358283] Calling initcall 0x78a198e0: topology_init+0x0/0x10()
[   15.364355] initcall 0x78a198e0: topology_init+0x0/0x10() returned 0.
[   15.370761] initcall 0x78a198e0 ran for 0 msecs: topology_init+0x0/0x10()
[   15.377522] Calling initcall 0x78a1da00: mca_init+0x0/0x330()
[   15.383249] initcall 0x78a1da00: mca_init+0x0/0x330() returned -19.
[   15.389479] initcall 0x78a1da00 ran for 0 msecs: mca_init+0x0/0x330()
[   15.395892] Calling initcall 0x78a24e00: param_sysfs_init+0x0/0x180()
[   15.403702] initcall 0x78a24e00: param_sysfs_init+0x0/0x180() returned 0.
[   15.410330] initcall 0x78a24e00 ran for 0 msecs: param_sysfs_init+0x0/0x180()
[   15.417438] Calling initcall 0x78a28150: init_bio+0x0/0x100()
[   15.423185] initcall 0x78a28150: init_bio+0x0/0x100() returned 0.
[   15.429222] initcall 0x78a28150 ran for 0 msecs: init_bio+0x0/0x100()
[   15.435634] Calling initcall 0x78a2b6e0: genhd_device_init+0x0/0x60()
[   15.442077] initcall 0x78a2b6e0: genhd_device_init+0x0/0x60() returned 0.
[   15.448807] initcall 0x78a2b6e0 ran for 0 msecs: genhd_device_init+0x0/0x60()
[   15.455915] Calling initcall 0x78a2d850: misc_init+0x0/0x80()
[   15.461647] initcall 0x78a2d850: misc_init+0x0/0x80() returned 0.
[   15.467700] initcall 0x78a2d850 ran for 0 msecs: misc_init+0x0/0x80()
[   15.474112] Calling initcall 0x78a39230: init_dvbdev+0x0/0xd0()
[   15.480010] initcall 0x78a39230: init_dvbdev+0x0/0xd0() returned 0.
[   15.486245] initcall 0x78a39230 ran for 0 msecs: init_dvbdev+0x0/0xd0()
[   15.492831] Calling initcall 0x78a39300: init_scsi+0x0/0xa0()
[   15.498707] SCSI subsystem initialized
[   15.502333] initcall 0x78a39300: init_scsi+0x0/0xa0() returned 0.
[   15.508394] initcall 0x78a39300 ran for 6 msecs: init_scsi+0x0/0xa0()
[   15.514809] Calling initcall 0x78a39950: ata_init+0x0/0x70()
[   15.520481] libata version 3.00 loaded.
[   15.524257] initcall 0x78a39950: ata_init+0x0/0x70() returned 0.
[   15.530235] initcall 0x78a39950 ran for 3 msecs: ata_init+0x0/0x70()
[   15.536560] Calling initcall 0x78a3c8b0: spi_init+0x0/0x70()
[   15.542206] initcall 0x78a3c8b0: spi_init+0x0/0x70() returned 0.
[   15.548172] initcall 0x78a3c8b0 ran for 0 msecs: spi_init+0x0/0x70()
[   15.554500] Calling initcall 0x78a3d2e0: usb_init+0x0/0xd0()
[   15.560173] usbcore: registered new interface driver usbfs
[   15.565606] usbcore: registered new interface driver hub
[   15.570908] usbcore: registered new device driver usb
[   15.575908] initcall 0x78a3d2e0: usb_init+0x0/0xd0() returned 0.
[   15.581882] initcall 0x78a3d2e0 ran for 9 msecs: usb_init+0x0/0xd0()
[   15.588211] Calling initcall 0x78a3f350: serio_init+0x0/0xb0()
[   15.594050] initcall 0x78a3f350: serio_init+0x0/0xb0() returned 0.
[   15.600170] initcall 0x78a3f350 ran for 0 msecs: serio_init+0x0/0xb0()
[   15.606669] Calling initcall 0x78a3fe70: gameport_init+0x0/0xb0()
[   15.612786] initcall 0x78a3fe70: gameport_init+0x0/0xb0() returned 0.
[   15.619148] initcall 0x78a3fe70 ran for 0 msecs: gameport_init+0x0/0xb0()
[   15.625908] Calling initcall 0x78a406e0: input_init+0x0/0x100()
[   15.631811] initcall 0x78a406e0: input_init+0x0/0x100() returned 0.
[   15.638039] initcall 0x78a406e0 ran for 0 msecs: input_init+0x0/0x100()
[   15.644627] Calling initcall 0x78a40c10: i2c_init+0x0/0x20()
[   15.650274] initcall 0x78a40c10: i2c_init+0x0/0x20() returned 0.
[   15.656240] initcall 0x78a40c10 ran for 0 msecs: i2c_init+0x0/0x20()
[   15.662566] Calling initcall 0x78a42f50: hwmon_init+0x0/0x40()
[   15.668374] initcall 0x78a42f50: hwmon_init+0x0/0x40() returned 0.
[   15.674526] initcall 0x78a42f50 ran for 0 msecs: hwmon_init+0x0/0x40()
[   15.681025] Calling initcall 0x78a4acc0: leds_init+0x0/0x20()
[   15.686753] initcall 0x78a4acc0: leds_init+0x0/0x20() returned 0.
[   15.692810] initcall 0x78a4acc0 ran for 0 msecs: leds_init+0x0/0x20()
[   15.699223] Calling initcall 0x78a4b4e0: ssb_modinit+0x0/0x80()
[   15.705152] initcall 0x78a4b4e0: ssb_modinit+0x0/0x80() returned 0.
[   15.711354] initcall 0x78a4b4e0 ran for 0 msecs: ssb_modinit+0x0/0x80()
[   15.717943] Calling initcall 0x78a4c100: pci_legacy_init+0x0/0x100()
[   15.724267] PCI: Probing PCI hardware
[   15.727923] PCI: Probing PCI hardware (bus 00)
[   15.735245] PCI: Transparent bridge - 0000:00:09.0
[   15.742165] initcall 0x78a4c100: pci_legacy_init+0x0/0x100() returned 0.
[   15.748707] initcall 0x78a4c100 ran for 12 msecs: pci_legacy_init+0x0/0x100()
[   15.755816] Calling initcall 0x78a4c720: pcibios_irq_init+0x0/0x510()
[   15.762482] PCI: Using IRQ router default [10de/005e] at 0000:00:00.0
[   15.768823] PCI->APIC IRQ transform: 0000:00:04.0[A] -> IRQ 3
[   15.774520] PCI->APIC IRQ transform: 0000:00:0a.0[A] -> IRQ 11
[   15.780350] PCI->APIC IRQ transform: 0000:05:07.0[A] -> IRQ 11
[   15.786125] PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 5
[   15.791845] initcall 0x78a4c720: pcibios_irq_init+0x0/0x510() returned 0.
[   15.798597] initcall 0x78a4c720 ran for 15 msecs: pcibios_irq_init+0x0/0x510()
[   15.805793] Calling initcall 0x78a4cc90: pcibios_init+0x0/0xa0()
[   15.865364] initcall 0x78a4cc90: pcibios_init+0x0/0xa0() returned 0.
[   15.871556] initcall 0x78a4cc90 ran for 54 msecs: pcibios_init+0x0/0xa0()
[   15.878318] Calling initcall 0x78a4d150: proto_init+0x0/0x30()
[   15.884124] initcall 0x78a4d150: proto_init+0x0/0x30() returned 0.
[   15.890278] initcall 0x78a4d150 ran for 0 msecs: proto_init+0x0/0x30()
[   15.896779] Calling initcall 0x78a4d560: net_dev_init+0x0/0x110()
[   15.902872] initcall 0x78a4d560: net_dev_init+0x0/0x110() returned 0.
[   15.909256] initcall 0x78a4d560 ran for 0 msecs: net_dev_init+0x0/0x110()
[   15.916014] Calling initcall 0x78a4d6c0: neigh_init+0x0/0x80()
[   15.921820] initcall 0x78a4d6c0: neigh_init+0x0/0x80() returned 0.
[   15.927973] initcall 0x78a4d6c0 ran for 0 msecs: neigh_init+0x0/0x80()
[   15.934475] Calling initcall 0x78a4dfd0: pktsched_init+0x0/0xd0()
[   15.940547] initcall 0x78a4dfd0: pktsched_init+0x0/0xd0() returned 0.
[   15.946954] initcall 0x78a4dfd0 ran for 0 msecs: pktsched_init+0x0/0xd0()
[   15.953715] Calling initcall 0x78a4e0b0: tc_filter_init+0x0/0x60()
[   15.959864] initcall 0x78a4e0b0: tc_filter_init+0x0/0x60() returned 0.
[   15.966888] initcall 0x78a4e0b0 ran for 0 msecs: tc_filter_init+0x0/0x60()
[   15.973734] Calling initcall 0x78a4e110: tc_action_init+0x0/0x60()
[   15.979883] initcall 0x78a4e110: tc_action_init+0x0/0x60() returned 0.
[   15.986384] initcall 0x78a4e110 ran for 0 msecs: tc_action_init+0x0/0x60()
[   15.993230] Calling initcall 0x78a4e420: genl_init+0x0/0xd0()
[   16.008625] initcall 0x78a4e420: genl_init+0x0/0xd0() returned 0.
[   16.014559] initcall 0x78a4e420 ran for 9 msecs: genl_init+0x0/0xd0()
[   16.020972] Calling initcall 0x78a50ee0: cipso_v4_init+0x0/0x80()
[   16.027049] initcall 0x78a50ee0: cipso_v4_init+0x0/0x80() returned 0.
[   16.033450] initcall 0x78a50ee0 ran for 0 msecs: cipso_v4_init+0x0/0x80()
[   16.040212] Calling initcall 0x78a52400: wanrouter_init+0x0/0x60()
[   16.046361] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[   16.053648] initcall 0x78a52400: wanrouter_init+0x0/0x60() returned 0.
[   16.060142] initcall 0x78a52400 ran for 3 msecs: wanrouter_init+0x0/0x60()
[   16.066990] Calling initcall 0x78a52960: irda_init+0x0/0x90()
[   16.072741] NET: Registered protocol family 23
[   16.077153] initcall 0x78a52960: irda_init+0x0/0x90() returned 0.
[   16.083191] initcall 0x78a52960 ran for 3 msecs: irda_init+0x0/0x90()
[   16.089606] Calling initcall 0x78a53880: wireless_nlevent_init+0x0/0x40()
[   16.096364] initcall 0x78a53880: wireless_nlevent_init+0x0/0x40() returned 0.
[   16.103472] initcall 0x78a53880 ran for 0 msecs: wireless_nlevent_init+0x0/0x40()
[   16.110927] Calling initcall 0x78730f10: cfg80211_init+0x0/0x50()
[   16.117093] initcall 0x78730f10: cfg80211_init+0x0/0x50() returned 0.
[   16.123405] initcall 0x78730f10 ran for 0 msecs: cfg80211_init+0x0/0x50()
[   16.130166] Calling initcall 0x78a538c0: ieee80211_init+0x0/0x40()
[   16.136317] initcall 0x78a538c0: ieee80211_init+0x0/0x40() returned 0.
[   16.142816] initcall 0x78a538c0 ran for 0 msecs: ieee80211_init+0x0/0x40()
[   16.149662] Calling initcall 0x78a53900: rate_control_simple_init+0x0/0x10()
[   16.156689] initcall 0x78a53900: rate_control_simple_init+0x0/0x10() returned 0.
[   16.164048] initcall 0x78a53900 ran for 0 msecs: rate_control_simple_init+0x0/0x10()
[   16.171763] Calling initcall 0x78a53ac0: netlbl_init+0x0/0x80()
[   16.177652] NetLabel: Initializing
[   16.181037] NetLabel:  domain hash size = 128
[   16.185370] NetLabel:  protocols = UNLABELED CIPSOv4
[   16.190360] NetLabel:  unlabeled traffic allowed by default
[   16.195856] initcall 0x78a53ac0: netlbl_init+0x0/0x80() returned 0.
[   16.202093] initcall 0x78a53ac0 ran for 12 msecs: netlbl_init+0x0/0x80()
[   16.208766] Calling initcall 0x78a253d0: clocksource_done_booting+0x0/0x10()
[   16.215783] initcall 0x78a253d0<6>Time: tsc clocksource has been installed.
[   16.222727] : clocksource_done_booting+0x0/0x10() returned 0.
[   16.228436] initcall 0x78a253d0 ran for 0 msecs: clocksource_done_booting+0x0/0x10()
[   16.236152] Calling initcall 0x78a279e0: init_pipe_fs+0x0/0x50()
[   16.242157] initcall 0x78a279e0: init_pipe_fs+0x0/0x50() returned 0.
[   16.248455] initcall 0x78a279e0 ran for 0 msecs: init_pipe_fs+0x0/0x50()
[   16.255130] Calling initcall 0x78a282c0: eventpoll_init+0x0/0x90()
[   16.261282] initcall 0x78a282c0: eventpoll_init+0x0/0x90() returned 0.
[   16.267782] initcall 0x78a282c0 ran for 0 msecs: eventpoll_init+0x0/0x90()
[   16.274628] Calling initcall 0x78a28350: anon_inode_init+0x0/0xf0()
[   16.280898] initcall 0x78a28350: anon_inode_init+0x0/0xf0() returned 0.
[   16.287454] initcall 0x78a28350 ran for 0 msecs: anon_inode_init+0x0/0xf0()
[   16.294387] Calling initcall 0x78a2d270: chr_dev_init+0x0/0xc0()
[   16.300464] initcall 0x78a2d270: chr_dev_init+0x0/0xc0() returned 0.
[   16.306693] initcall 0x78a2d270 ran for 0 msecs: chr_dev_init+0x0/0xc0()
[   16.313368] Calling initcall 0x78a31130: firmware_class_init+0x0/0x70()
[   16.319956] initcall 0x78a31130: firmware_class_init+0x0/0x70() returned 0.
[   16.326885] initcall 0x78a31130 ran for 0 msecs: firmware_class_init+0x0/0x70()
[   16.334167] Calling initcall 0x78a33a30: loopback_init+0x0/0x10()
[   16.340375] initcall 0x78a33a30: loopback_init+0x0/0x10() returned 0.
[   16.346661] initcall 0x78a33a30 ran for 0 msecs: loopback_init+0x0/0x10()
[   16.353422] Calling initcall 0x78a4aca0: cpufreq_gov_userspace_init+0x0/0x10()
[   16.360617] initcall 0x78a4aca0: cpufreq_gov_userspace_init+0x0/0x10() returned 0.
[   16.368150] initcall 0x78a4aca0 ran for 0 msecs: cpufreq_gov_userspace_init+0x0/0x10()
[   16.376041] Calling initcall 0x78a4b570: pcibios_assign_resources+0x0/0xa0()
[   16.383096] PCI: Bridge: 0000:00:09.0
[   16.386705]   IO window: c000-cfff
[   16.390096]   MEM window: da000000-da0fffff
[   16.394248]   PREFETCH window: disabled.
[   16.398152] PCI: Bridge: 0000:00:0b.0
[   16.401779]   IO window: disabled.
[   16.405170]   MEM window: disabled.
[   16.408632]   PREFETCH window: disabled.
[   16.412537] PCI: Bridge: 0000:00:0c.0
[   16.416165]   IO window: disabled.
[   16.419556]   MEM window: disabled.
[   16.423019]   PREFETCH window: disabled.
[   16.426923] PCI: Bridge: 0000:00:0d.0
[   16.430551]   IO window: disabled.
[   16.433942]   MEM window: disabled.
[   16.437404]   PREFETCH window: disabled.
[   16.441312] PCI: Bridge: 0000:00:0e.0
[   16.444941]   IO window: b000-bfff
[   16.448327]   MEM window: d8000000-d9ffffff
[   16.452484]   PREFETCH window: d0000000-d7ffffff
[   16.457103] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   16.463354] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   16.469594] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   16.475833] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   16.482072] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   16.488273] initcall 0x78a4b570: pcibios_assign_resources+0x0/0xa0() returned 0.
[   16.495631] initcall 0x78a4b570 ran for 100 msecs: pcibios_assign_resources+0x0/0xa0()
[   16.503519] Calling initcall 0x78a4ee60: inet_init+0x0/0x300()
[   16.509327] NET: Registered protocol family 2
[   16.541898] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   16.549162] TCP established hash table entries: 131072 (order: 10, 4194304 bytes)
[   16.565249] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[   16.575949] TCP: Hash tables configured (established 131072 bind 65536)
[   16.582453] TCP reno registered
[   16.595222] initcall 0x78a4ee60: inet_init+0x0/0x300() returned 0.
[   16.601243] initcall 0x78a4ee60 ran for 81 msecs: inet_init+0x0/0x300()
[   16.607832] Calling initcall 0x78a17600: populate_rootfs+0x0/0xa0()
[   16.614366] initcall 0x78a17600: populate_rootfs+0x0/0xa0() returned 0.
[   16.620823] initcall 0x78a17600 ran for 0 msecs: populate_rootfs+0x0/0xa0()
[   16.627755] Calling initcall 0x78a186b0: i8259A_init_sysfs+0x0/0x20()
[   16.634182] initcall 0x78a186b0: i8259A_init_sysfs+0x0/0x20() returned 0.
[   16.640928] initcall 0x78a186b0 ran for 0 msecs: i8259A_init_sysfs+0x0/0x20()
[   16.648034] Calling initcall 0x78a18830: sbf_init+0x0/0xd0()
[   16.653665] initcall 0x78a18830: sbf_init+0x0/0xd0() returned 0.
[   16.659646] initcall 0x78a18830 ran for 0 msecs: sbf_init+0x0/0xd0()
[   16.665972] Calling initcall 0x78a198c0: i8237A_init_sysfs+0x0/0x20()
[   16.672394] initcall 0x78a198c0: i8237A_init_sysfs+0x0/0x20() returned 0.
[   16.679146] initcall 0x78a198c0 ran for 0 msecs: i8237A_init_sysfs+0x0/0x20()
[   16.686251] Calling initcall 0x78a1cbb0: cache_sysfs_init+0x0/0x200()
[   16.692749] initcall 0x78a1cbb0: cache_sysfs_init+0x0/0x200() returned 0.
[   16.699424] initcall 0x78a1cbb0 ran for 0 msecs: cache_sysfs_init+0x0/0x200()
[   16.706530] Calling initcall 0x78a1d460: longrun_init+0x0/0x30()
[   16.712508] initcall 0x78a1d460: longrun_init+0x0/0x30() returned -19.
[   16.719009] initcall 0x78a1d460 ran for 0 msecs: longrun_init+0x0/0x30()
[   16.725682] Calling initcall 0x78a1dd30: microcode_init+0x0/0xa0()
[   16.731924] microcode: CPU0 not a capable Intel processor
[   16.737212] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   16.744490] initcall 0x78a1dd30: microcode_init+0x0/0xa0() returned 0.
[   16.750988] initcall 0x78a1dd30 ran for 12 msecs: microcode_init+0x0/0xa0()
[   16.757921] Calling initcall 0x78a202a0: ioapic_init_sysfs+0x0/0xe0()
[   16.764340] initcall 0x78a202a0: ioapic_init_sysfs+0x0/0xe0() returned 0.
[   16.771093] initcall 0x78a202a0 ran for 0 msecs: ioapic_init_sysfs+0x0/0xe0()
[   16.778199] Calling initcall 0x78a22ff0: init_vmi_clocksource+0x0/0x130()
[   16.784956] initcall 0x78a22ff0: init_vmi_clocksource+0x0/0x130() returned 0.
[   16.792065] initcall 0x78a22ff0 ran for 0 msecs: init_vmi_clocksource+0x0/0x130()
[   16.799520] Calling initcall 0x78a23320: add_pcspkr+0x0/0x60()
[   16.805338] initcall 0x78a23320: add_pcspkr+0x0/0x60() returned 0.
[   16.811475] initcall 0x78a23320 ran for 0 msecs: add_pcspkr+0x0/0x60()
[   16.817976] Calling initcall 0x78a23bd0: init+0x0/0x10()
[   16.823273] initcall 0x78a23bd0: init+0x0/0x10() returned 0.
[   16.828895] initcall 0x78a23bd0 ran for 0 msecs: init+0x0/0x10()
[   16.834874] Calling initcall 0x78a23c00: init_sched_debug_procfs+0x0/0x30()
[   16.841810] initcall 0x78a23c00: init_sched_debug_procfs+0x0/0x30() returned 0.
[   16.849088] initcall 0x78a23c00 ran for 0 msecs: init_sched_debug_procfs+0x0/0x30()
[   16.856716] Calling initcall 0x78a245a0: create_proc_profile+0x0/0x50()
[   16.863303] initcall 0x78a245a0: create_proc_profile+0x0/0x50() returned 0.
[   16.870234] initcall 0x78a245a0 ran for 0 msecs: create_proc_profile+0x0/0x50()
[   16.877515] Calling initcall 0x78a24730: ioresources_init+0x0/0x40()
[   16.883840] initcall 0x78a24730: ioresources_init+0x0/0x40() returned 0.
[   16.890512] initcall 0x78a24730 ran for 0 msecs: ioresources_init+0x0/0x40()
[   16.897534] Calling initcall 0x78a249f0: uid_cache_init+0x0/0x90()
[   16.903688] initcall 0x78a249f0: uid_cache_init+0x0/0x90() returned 0.
[   16.910184] initcall 0x78a249f0 ran for 0 msecs: uid_cache_init+0x0/0x90()
[   16.917033] Calling initcall 0x78a24f80: init_posix_timers+0x0/0x90()
[   16.923442] initcall 0x78a24f80: init_posix_timers+0x0/0x90() returned 0.
[   16.930203] initcall 0x78a24f80 ran for 0 msecs: init_posix_timers+0x0/0x90()
[   16.937311] Calling initcall 0x78a25010: init_posix_cpu_timers+0x0/0xa0()
[   16.944066] initcall 0x78a25010: init_posix_cpu_timers+0x0/0xa0() returned 0.
[   16.951173] initcall 0x78a25010 ran for 0 msecs: init_posix_cpu_timers+0x0/0xa0()
[   16.958630] Calling initcall 0x78a251d0: latency_init+0x0/0x20()
[   16.964611] initcall 0x78a251d0: latency_init+0x0/0x20() returned 0.
[   16.970933] initcall 0x78a251d0 ran for 0 msecs: latency_init+0x0/0x20()
[   16.977606] Calling initcall 0x78a251f0: nsproxy_cache_init+0x0/0x30()
[   16.984105] initcall 0x78a251f0: nsproxy_cache_init+0x0/0x30() returned 0.
[   16.990952] initcall 0x78a251f0 ran for 0 msecs: nsproxy_cache_init+0x0/0x30()
[   16.998146] Calling initcall 0x78a25220: timekeeping_init_device+0x0/0x20()
[   17.005089] initcall 0x78a25220: timekeeping_init_device+0x0/0x20() returned 0.
[   17.012894] initcall 0x78a25220 ran for 0 msecs: timekeeping_init_device+0x0/0x20()
[   17.020523] Calling initcall 0x78a253e0: init_clocksource_sysfs+0x0/0x40()
[   17.027380] initcall 0x78a253e0: init_clocksource_sysfs+0x0/0x40() returned 0.
[   17.034559] initcall 0x78a253e0 ran for 0 msecs: init_clocksource_sysfs+0x0/0x40()
[   17.042102] Calling initcall 0x78a254d0: init_timer_list_procfs+0x0/0x30()
[   17.048948] initcall 0x78a254d0: init_timer_list_procfs+0x0/0x30() returned 0.
[   17.056139] initcall 0x78a254d0 ran for 0 msecs: init_timer_list_procfs+0x0/0x30()
[   17.063680] Calling initcall 0x78a25510: init_tstats_procfs+0x0/0x30()
[   17.070178] initcall 0x78a25510: init_tstats_procfs+0x0/0x30() returned 0.
[   17.077025] initcall 0x78a25510 ran for 0 msecs: init_tstats_procfs+0x0/0x30()
[   17.084219] Calling initcall 0x78a25630: lockdep_proc_init+0x0/0x40()
[   17.090631] initcall 0x78a25630: lockdep_proc_init+0x0/0x40() returned 0.
[   17.097389] initcall 0x78a25630 ran for 0 msecs: lockdep_proc_init+0x0/0x40()
[   17.104496] Calling initcall 0x78a25670: init+0x0/0xf0()
[   17.109819] initcall 0x78a25670: init+0x0/0xf0() returned 0.
[   17.115415] initcall 0x78a25670 ran for 0 msecs: init+0x0/0xf0()
[   17.121393] Calling initcall 0x7813ae00: init_rttest+0x0/0x120()
[   17.127622] Initializing RT-Tester: OK
[   17.131243] initcall 0x7813ae00: init_rttest+0x0/0x120() returned 0.
[   17.137566] initcall 0x7813ae00 ran for 3 msecs: init_rttest+0x0/0x120()
[   17.144238] Calling initcall 0x78a25760: proc_dma_init+0x0/0x20()
[   17.150304] initcall 0x78a25760: proc_dma_init+0x0/0x20() returned 0.
[   17.156718] initcall 0x78a25760 ran for 0 msecs: proc_dma_init+0x0/0x20()
[   17.163480] Calling initcall 0x78a25780: kallsyms_init+0x0/0x20()
[   17.169542] initcall 0x78a25780: kallsyms_init+0x0/0x20() returned 0.
[   17.175956] initcall 0x78a25780 ran for 0 msecs: kallsyms_init+0x0/0x20()
[   17.182716] Calling initcall 0x78a25810: audit_init+0x0/0x100()
[   17.188607] audit: initializing netlink socket (disabled)
[   17.194013] audit(1192636448.851:1): initialized
[   17.198582] initcall 0x78a25810: audit_init+0x0/0x100() returned 0.
[   17.204812] initcall 0x78a25810 ran for 9 msecs: audit_init+0x0/0x100()
[   17.211401] Calling initcall 0x78a25a40: utsname_sysctl_init+0x0/0x10()
[   17.217987] initcall 0x78a25a40: utsname_sysctl_init+0x0/0x10() returned 0.
[   17.224918] initcall 0x78a25a40 ran for 0 msecs: utsname_sysctl_init+0x0/0x10()
[   17.232202] Calling initcall 0x78a27260: init_per_zone_pages_min+0x0/0x50()
[   17.239174] initcall 0x78a27260: init_per_zone_pages_min+0x0/0x50() returned 0.
[   17.246411] initcall 0x78a27260 ran for 0 msecs: init_per_zone_pages_min+0x0/0x50()
[   17.254041] Calling initcall 0x78a27800: pdflush_init+0x0/0x10()
[   17.260066] initcall 0x78a27800: pdflush_init+0x0/0x10() returned 0.
[   17.266343] initcall 0x78a27800 ran for 0 msecs: pdflush_init+0x0/0x10()
[   17.273017] Calling initcall 0x78a27830: kswapd_init+0x0/0x10()
[   17.278930] initcall 0x78a27830: kswapd_init+0x0/0x10() returned 0.
[   17.285150] initcall 0x78a27830 ran for 0 msecs: kswapd_init+0x0/0x10()
[   17.291738] Calling initcall 0x78a27880: procswaps_init+0x0/0x20()
[   17.297888] initcall 0x78a27880: procswaps_init+0x0/0x20() returned 0.
[   17.304389] initcall 0x78a27880 ran for 0 msecs: procswaps_init+0x0/0x20()
[   17.311235] Calling initcall 0x78a278a0: init_tmpfs+0x0/0xc0()
[   17.317075] initcall 0x78a278a0: init_tmpfs+0x0/0xc0() returned 0.
[   17.323194] initcall 0x78a278a0 ran for 0 msecs: init_tmpfs+0x0/0xc0()
[   17.329693] Calling initcall 0x78a27a30: fasync_init+0x0/0x30()
[   17.335585] initcall 0x78a27a30: fasync_init+0x0/0x30() returned 0.
[   17.341826] initcall 0x78a27a30 ran for 0 msecs: fasync_init+0x0/0x30()
[   17.348414] Calling initcall 0x78a28090: aio_setup+0x0/0x70()
[   17.354157] initcall 0x78a28090: aio_setup+0x0/0x70() returned 0.
[   17.360199] initcall 0x78a28090 ran for 0 msecs: aio_setup+0x0/0x70()
[   17.366613] Calling initcall 0x78a284a0: init_mbcache+0x0/0x10()
[   17.372590] initcall 0x78a284a0: init_mbcache+0x0/0x10() returned 0.
[   17.378916] initcall 0x78a284a0 ran for 0 msecs: init_mbcache+0x0/0x10()
[   17.385590] Calling initcall 0x78a284b0: dquot_init+0x0/0xf0()
[   17.391394] VFS: Disk quotas dquot_6.5.1
[   17.395305] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   17.401800] initcall 0x78a284b0: dquot_init+0x0/0xf0() returned 0.
[   17.407947] initcall 0x78a284b0 ran for 9 msecs: dquot_init+0x0/0xf0()
[   17.414448] Calling initcall 0x78a285a0: dnotify_init+0x0/0x30()
[   17.420426] initcall 0x78a285a0: dnotify_init+0x0/0x30() returned 0.
[   17.426754] initcall 0x78a285a0 ran for 0 msecs: dnotify_init+0x0/0x30()
[   17.433429] Calling initcall 0x78a28a30: configfs_init+0x0/0x90()
[   17.439496] initcall 0x78a28a30: configfs_init+0x0/0x90() returned 0.
[   17.445906] initcall 0x78a28a30 ran for 0 msecs: configfs_init+0x0/0x90()
[   17.452666] Calling initcall 0x78a28ac0: init_devpts_fs+0x0/0x30()
[   17.458871] initcall 0x78a28ac0: init_devpts_fs+0x0/0x30() returned 0.
[   17.465318] initcall 0x78a28ac0 ran for 0 msecs: init_devpts_fs+0x0/0x30()
[   17.472165] Calling initcall 0x78a28af0: init_reiserfs_fs+0x0/0x90()
[   17.478504] initcall 0x78a28af0: init_reiserfs_fs+0x0/0x90() returned 0.
[   17.485163] initcall 0x78a28af0 ran for 0 msecs: init_reiserfs_fs+0x0/0x90()
[   17.492186] Calling initcall 0x78a28c60: init_ext3_fs+0x0/0x70()
[   17.498171] initcall 0x78a28c60: init_ext3_fs+0x0/0x70() returned 0.
[   17.504487] initcall 0x78a28c60 ran for 0 msecs: init_ext3_fs+0x0/0x70()
[   17.511163] Calling initcall 0x78a28d10: init_ext4_fs+0x0/0x60()
[   17.517141] initcall 0x78a28d10: init_ext4_fs+0x0/0x60() returned 0.
[   17.523469] initcall 0x78a28d10 ran for 0 msecs: init_ext4_fs+0x0/0x60()
[   17.530143] Calling initcall 0x78a28df0: journal_init+0x0/0x100()
[   17.536207] initcall 0x78a28df0: journal_init+0x0/0x100() returned 0.
[   17.542620] initcall 0x78a28df0 ran for 0 msecs: journal_init+0x0/0x100()
[   17.549379] Calling initcall 0x78a28f70: journal_init+0x0/0xd0()
[   17.555358] initcall 0x78a28f70: journal_init+0x0/0xd0() returned 0.
[   17.561684] initcall 0x78a28f70 ran for 0 msecs: journal_init+0x0/0xd0()
[   17.568360] Calling initcall 0x78a29040: init_cramfs_fs+0x0/0x30()
[   17.574552] initcall 0x78a29040: init_cramfs_fs+0x0/0x30() returned 0.
[   17.581011] initcall 0x78a29040 ran for 0 msecs: init_cramfs_fs+0x0/0x30()
[   17.587857] Calling initcall 0x78a29080: init_ramfs_fs+0x0/0x10()
[   17.593923] initcall 0x78a29080: init_ramfs_fs+0x0/0x10() returned 0.
[   17.600337] initcall 0x78a29080 ran for 0 msecs: init_ramfs_fs+0x0/0x10()
[   17.607098] Calling initcall 0x78a29090: init_coda+0x0/0x190()
[   17.612964] initcall 0x78a29090: init_coda+0x0/0x190() returned 0.
[   17.619055] initcall 0x78a29090 ran for 0 msecs: init_coda+0x0/0x190()
[   17.625554] Calling initcall 0x78a29220: init_minix_fs+0x0/0x60()
[   17.631620] initcall 0x78a29220: init_minix_fs+0x0/0x60() returned 0.
[   17.638033] initcall 0x78a29220 ran for 0 msecs: init_minix_fs+0x0/0x60()
[   17.644794] Calling initcall 0x78a292c0: init_fat_fs+0x0/0x50()
[   17.650686] initcall 0x78a292c0: init_fat_fs+0x0/0x50() returned 0.
[   17.656927] initcall 0x78a292c0 ran for 0 msecs: init_fat_fs+0x0/0x50()
[   17.663515] Calling initcall 0x78a29310: init_msdos_fs+0x0/0x10()
[   17.669578] initcall 0x78a29310: init_msdos_fs+0x0/0x10() returned 0.
[   17.675992] initcall 0x78a29310 ran for 0 msecs: init_msdos_fs+0x0/0x10()
[   17.682751] Calling initcall 0x78a29320: init_vfat_fs+0x0/0x10()
[   17.688730] initcall 0x78a29320: init_vfat_fs+0x0/0x10() returned 0.
[   17.695057] initcall 0x78a29320 ran for 0 msecs: init_vfat_fs+0x0/0x10()
[   17.701732] Calling initcall 0x78a29330: init_iso9660_fs+0x0/0x70()
[   17.707986] initcall 0x78a29330: init_iso9660_fs+0x0/0x70() returned 0.
[   17.714553] initcall 0x78a29330 ran for 0 msecs: init_iso9660_fs+0x0/0x70()
[   17.721489] Calling initcall 0x78a29410: init_hfsplus_fs+0x0/0x70()
[   17.727728] initcall 0x78a29410: init_hfsplus_fs+0x0/0x70() returned 0.
[   17.734315] initcall 0x78a29410 ran for 0 msecs: init_hfsplus_fs+0x0/0x70()
[   17.741247] Calling initcall 0x78a29480: init_hfs_fs+0x0/0x70()
[   17.747140] initcall 0x78a29480: init_hfs_fs+0x0/0x70() returned 0.
[   17.753381] initcall 0x78a29480 ran for 0 msecs: init_hfs_fs+0x0/0x70()
[   17.759968] Calling initcall 0x78a294f0: ecryptfs_init+0x0/0x1d0()
[   17.766187] initcall 0x78a294f0: ecryptfs_init+0x0/0x1d0() returned 0.
[   17.772619] initcall 0x78a294f0 ran for 0 msecs: ecryptfs_init+0x0/0x1d0()
[   17.779465] Calling initcall 0x78a296c0: vxfs_init+0x0/0x70()
[   17.785184] initcall 0x78a296c0: vxfs_init+0x0/0x70() returned 0.
[   17.791249] initcall 0x78a296c0 ran for 0 msecs: vxfs_init+0x0/0x70()
[   17.797665] Calling initcall 0x78a29730: init_nfsd+0x0/0xb0()
[   17.803382] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   17.810144] initcall 0x78a29730: init_nfsd+0x0/0xb0() returned 0.
[   17.816079] initcall 0x78a29730 ran for 6 msecs: init_nfsd+0x0/0xb0()
[   17.822492] Calling initcall 0x78a297e0: init_nlm+0x0/0x20()
[   17.828124] initcall 0x78a297e0: init_nlm+0x0/0x20() returned 0.
[   17.834105] initcall 0x78a297e0 ran for 0 msecs: init_nlm+0x0/0x20()
[   17.840432] Calling initcall 0x78a29800: init_nls_cp437+0x0/0x10()
[   17.846593] initcall 0x78a29800: init_nls_cp437+0x0/0x10() returned 0.
[   17.853082] initcall 0x78a29800 ran for 0 msecs: init_nls_cp437+0x0/0x10()
[   17.859933] Calling initcall 0x78a29810: init_nls_cp775+0x0/0x10()
[   17.866081] initcall 0x78a29810: init_nls_cp775+0x0/0x10() returned 0.
[   17.872582] initcall 0x78a29810 ran for 0 msecs: init_nls_cp775+0x0/0x10()
[   17.879429] Calling initcall 0x78a29820: init_nls_cp852+0x0/0x10()
[   17.885580] initcall 0x78a29820: init_nls_cp852+0x0/0x10() returned 0.
[   17.892081] initcall 0x78a29820 ran for 0 msecs: init_nls_cp852+0x0/0x10()
[   17.898928] Calling initcall 0x78a29830: init_nls_cp857+0x0/0x10()
[   17.905080] initcall 0x78a29830: init_nls_cp857+0x0/0x10() returned 0.
[   17.911578] initcall 0x78a29830 ran for 0 msecs: init_nls_cp857+0x0/0x10()
[   17.918428] Calling initcall 0x78a29840: init_nls_cp860+0x0/0x10()
[   17.924578] initcall 0x78a29840: init_nls_cp860+0x0/0x10() returned 0.
[   17.931076] initcall 0x78a29840 ran for 0 msecs: init_nls_cp860+0x0/0x10()
[   17.937925] Calling initcall 0x78a29850: init_nls_cp861+0x0/0x10()
[   17.944076] initcall 0x78a29850: init_nls_cp861+0x0/0x10() returned 0.
[   17.950578] initcall 0x78a29850 ran for 0 msecs: init_nls_cp861+0x0/0x10()
[   17.957424] Calling initcall 0x78a29860: init_nls_cp863+0x0/0x10()
[   17.963575] initcall 0x78a29860: init_nls_cp863+0x0/0x10() returned 0.
[   17.970077] initcall 0x78a29860 ran for 0 msecs: init_nls_cp863+0x0/0x10()
[   17.976925] Calling initcall 0x78a29870: init_nls_cp864+0x0/0x10()
[   17.983073] initcall 0x78a29870: init_nls_cp864+0x0/0x10() returned 0.
[   17.989573] initcall 0x78a29870 ran for 0 msecs: init_nls_cp864+0x0/0x10()
[   17.996424] Calling initcall 0x78a29880: init_nls_cp869+0x0/0x10()
[   18.002573] initcall 0x78a29880: init_nls_cp869+0x0/0x10() returned 0.
[   18.009074] initcall 0x78a29880 ran for 0 msecs: init_nls_cp869+0x0/0x10()
[   18.015920] Calling initcall 0x78a29890: init_nls_cp874+0x0/0x10()
[   18.022071] initcall 0x78a29890: init_nls_cp874+0x0/0x10() returned 0.
[   18.028573] initcall 0x78a29890 ran for 0 msecs: init_nls_cp874+0x0/0x10()
[   18.035419] Calling initcall 0x78a298a0: init_nls_cp932+0x0/0x10()
[   18.041570] initcall 0x78a298a0: init_nls_cp932+0x0/0x10() returned 0.
[   18.048069] initcall 0x78a298a0 ran for 0 msecs: init_nls_cp932+0x0/0x10()
[   18.054918] Calling initcall 0x78a298b0: init_nls_euc_jp+0x0/0x40()
[   18.061157] initcall 0x78a298b0: init_nls_euc_jp+0x0/0x40() returned 0.
[   18.067742] initcall 0x78a298b0 ran for 0 msecs: init_nls_euc_jp+0x0/0x40()
[   18.074677] Calling initcall 0x78a298f0: init_nls_cp936+0x0/0x10()
[   18.080828] initcall 0x78a298f0: init_nls_cp936+0x0/0x10() returned 0.
[   18.087330] initcall 0x78a298f0 ran for 0 msecs: init_nls_cp936+0x0/0x10()
[   18.094176] Calling initcall 0x78a29900: init_nls_cp1250+0x0/0x10()
[   18.100414] initcall 0x78a29900: init_nls_cp1250+0x0/0x10() returned 0.
[   18.107522] initcall 0x78a29900 ran for 0 msecs: init_nls_cp1250+0x0/0x10()
[   18.114454] Calling initcall 0x78a29910: init_nls_ascii+0x0/0x10()
[   18.120605] initcall 0x78a29910: init_nls_ascii+0x0/0x10() returned 0.
[   18.127107] initcall 0x78a29910 ran for 0 msecs: init_nls_ascii+0x0/0x10()
[   18.133952] Calling initcall 0x78a29920: init_nls_iso8859_3+0x0/0x10()
[   18.140451] initcall 0x78a29920: init_nls_iso8859_3+0x0/0x10() returned 0.
[   18.147299] initcall 0x78a29920 ran for 0 msecs: init_nls_iso8859_3+0x0/0x10()
[   18.154491] Calling initcall 0x78a29930: init_nls_iso8859_5+0x0/0x10()
[   18.160989] initcall 0x78a29930: init_nls_iso8859_5+0x0/0x10() returned 0.
[   18.167835] initcall 0x78a29930 ran for 0 msecs: init_nls_iso8859_5+0x0/0x10()
[   18.175032] Calling initcall 0x78a29940: init_nls_iso8859_6+0x0/0x10()
[   18.181528] initcall 0x78a29940: init_nls_iso8859_6+0x0/0x10() returned 0.
[   18.188376] initcall 0x78a29940 ran for 0 msecs: init_nls_iso8859_6+0x0/0x10()
[   18.195571] Calling initcall 0x78a29950: init_nls_iso8859_15+0x0/0x10()
[   18.202153] initcall 0x78a29950: init_nls_iso8859_15+0x0/0x10() returned 0.
[   18.209088] initcall 0x78a29950 ran for 0 msecs: init_nls_iso8859_15+0x0/0x10()
[   18.216367] Calling initcall 0x78a29960: init_nls_koi8_r+0x0/0x10()
[   18.222606] initcall 0x78a29960: init_nls_koi8_r+0x0/0x10() returned 0.
[   18.229193] initcall 0x78a29960 ran for 0 msecs: init_nls_koi8_r+0x0/0x10()
[   18.236126] Calling initcall 0x78a29970: init_nls_koi8_u+0x0/0x10()
[   18.242364] initcall 0x78a29970: init_nls_koi8_u+0x0/0x10() returned 0.
[   18.248951] initcall 0x78a29970 ran for 0 msecs: init_nls_koi8_u+0x0/0x10()
[   18.255885] Calling initcall 0x78a29980: init_nls_koi8_ru+0x0/0x40()
[   18.262210] initcall 0x78a29980: init_nls_koi8_ru+0x0/0x40() returned 0.
[   18.268884] initcall 0x78a29980 ran for 0 msecs: init_nls_koi8_ru+0x0/0x40()
[   18.275903] Calling initcall 0x78a299c0: init_nls_utf8+0x0/0x30()
[   18.281968] initcall 0x78a299c0: init_nls_utf8+0x0/0x30() returned 0.
[   18.288382] initcall 0x78a299c0 ran for 0 msecs: init_nls_utf8+0x0/0x30()
[   18.295145] Calling initcall 0x78a299f0: init_cifs+0x0/0x510()
[   18.301063] initcall 0x78a299f0: init_cifs+0x0/0x510() returned 0.
[   18.307103] initcall 0x78a299f0 ran for 0 msecs: init_cifs+0x0/0x510()
[   18.313602] Calling initcall 0x78a29f00: init_ncp_fs+0x0/0x60()
[   18.319494] initcall 0x78a29f00: init_ncp_fs+0x0/0x60() returned 0.
[   18.325734] initcall 0x78a29f00 ran for 0 msecs: init_ncp_fs+0x0/0x60()
[   18.332320] Calling initcall 0x78a29f60: init_hpfs_fs+0x0/0x60()
[   18.338301] initcall 0x78a29f60: init_hpfs_fs+0x0/0x60() returned 0.
[   18.344624] initcall 0x78a29f60 ran for 0 msecs: init_hpfs_fs+0x0/0x60()
[   18.351299] Calling initcall 0x78a29fc0: init_ntfs_fs+0x0/0x270()
[   18.357363] NTFS driver 2.1.29 [Flags: R/W DEBUG].
[   18.362138] initcall 0x78a29fc0: init_ntfs_fs+0x0/0x270() returned 0.
[   18.368544] initcall 0x78a29fc0 ran for 4 msecs: init_ntfs_fs+0x0/0x270()
[   18.375303] Calling initcall 0x78a2a230: init_romfs_fs+0x0/0x60()
[   18.381371] initcall 0x78a2a230: init_romfs_fs+0x0/0x60() returned 0.
[   18.387782] initcall 0x78a2a230 ran for 0 msecs: init_romfs_fs+0x0/0x60()
[   18.394543] Calling initcall 0x78a2a290: init_qnx4_fs+0x0/0x70()
[   18.400522] QNX4 filesystem 0.2.3 registered.
[   18.404857] initcall 0x78a2a290: init_qnx4_fs+0x0/0x70() returned 0.
[   18.411180] initcall 0x78a2a290 ran for 4 msecs: init_qnx4_fs+0x0/0x70()
[   18.417855] Calling initcall 0x78a2a300: init_autofs_fs+0x0/0x10()
[   18.424007] initcall 0x78a2a300: init_autofs_fs+0x0/0x10() returned 0.
[   18.430508] initcall 0x78a2a300 ran for 0 msecs: init_autofs_fs+0x0/0x10()
[   18.437354] Calling initcall 0x78a2a310: init_autofs4_fs+0x0/0x10()
[   18.443592] initcall 0x78a2a310: init_autofs4_fs+0x0/0x10() returned -16.
[   18.450353] initcall 0x78a2a310 ran for 0 msecs: init_autofs4_fs+0x0/0x10()
[   18.457288] initcall at 0x78a2a310: init_autofs4_fs+0x0/0x10(): returned with error code -16
[   18.465694] Calling initcall 0x78a2a320: init_adfs_fs+0x0/0x60()
[   18.471673] initcall 0x78a2a320: init_adfs_fs+0x0/0x60() returned 0.
[   18.477996] initcall 0x78a2a320 ran for 0 msecs: init_adfs_fs+0x0/0x60()
[   18.484671] Calling initcall 0x78a2a3f0: fuse_init+0x0/0x120()
[   18.490475] fuse init (API version 7.8)
[   18.494315] initcall 0x78a2a3f0: fuse_init+0x0/0x120() returned 0.
[   18.500444] initcall 0x78a2a3f0 ran for 3 msecs: fuse_init+0x0/0x120()
[   18.506944] Calling initcall 0x78a2a520: init_udf_fs+0x0/0x60()
[   18.512835] initcall 0x78a2a520: init_udf_fs+0x0/0x60() returned 0.
[   18.519075] initcall 0x78a2a520 ran for 0 msecs: init_udf_fs+0x0/0x60()
[   18.525660] Calling initcall 0x78a2a660: init_xfs_fs+0x0/0x70()
[   18.531554] SGI XFS with large block numbers, no debug enabled
[   18.537460] SGI XFS Quota Management subsystem
[   18.541789] initcall 0x78a2a660: init_xfs_fs+0x0/0x70() returned 0.
[   18.548018] initcall 0x78a2a660 ran for 9 msecs: init_xfs_fs+0x0/0x70()
[   18.554606] Calling initcall 0x78a2a6d0: init_v9fs+0x0/0x20()
[   18.560324] Installing v9fs 9p2000 file system support
[   18.565443] initcall 0x78a2a6d0: init_v9fs+0x0/0x20() returned 0.
[   18.571503] initcall 0x78a2a6d0 ran for 4 msecs: init_v9fs+0x0/0x20()
[   18.577918] Calling initcall 0x78a2a730: ocfs2_init+0x0/0x300()
[   18.583810] OCFS2 1.3.3
[   18.586275] initcall 0x78a2a730: ocfs2_init+0x0/0x300() returned 0.
[   18.592477] initcall 0x78a2a730 ran for 2 msecs: ocfs2_init+0x0/0x300()
[   18.599063] Calling initcall 0x78a2aad0: init_o2nm+0x0/0xd0()
[   18.604782] OCFS2 Node Manager 1.3.3
[   18.608580] initcall 0x78a2aad0: init_o2nm+0x0/0xd0() returned 0.
[   18.614513] initcall 0x78a2aad0 ran for 3 msecs: init_o2nm+0x0/0xd0()
[   18.620929] Calling initcall 0x78a2aba0: dlm_init+0x0/0x100()
[   18.626646] OCFS2 DLM 1.3.3
[   18.629431] initcall 0x78a2aba0<4>Clocksource tsc unstable (delta = 86616443 ns)
[   18.636797] : dlm_init+0x0/0x100()<6>Time: pit clocksource has been installed.
[   18.643987]  returned 0.
[   18.646498] initcall 0x78a2aba0 ran for 2 msecs: dlm_init+0x0/0x100()
[   18.652909] Calling initcall 0x78a2aca0: init_dlmfs_fs+0x0/0xb0()
[   18.658974] OCFS2 DLMFS 1.3.3
[   18.661961] OCFS2 User DLM kernel interface loaded
[   18.666696] initcall 0x78a2aca0: init_dlmfs_fs+0x0/0xb0() returned 0.
[   18.673098] initcall 0x78a2aca0 ran for 4 msecs: init_dlmfs_fs+0x0/0xb0()
[   18.679864] Calling initcall 0x78a2ae90: key_proc_init+0x0/0x60()
[   18.685932] initcall 0x78a2ae90: key_proc_init+0x0/0x60() returned 0.
[   18.692340] initcall 0x78a2ae90 ran for 0 msecs: key_proc_init+0x0/0x60()
[   18.699100] Calling initcall 0x78a2b010: crypto_algapi_init+0x0/0x10()
[   18.705603] initcall 0x78a2b010: crypto_algapi_init+0x0/0x10() returned 0.
[   18.712447] initcall 0x78a2b010 ran for 0 msecs: crypto_algapi_init+0x0/0x10()
[   18.719638] Calling initcall 0x78a2b040: cryptomgr_init+0x0/0x10()
[   18.725793] initcall 0x78a2b040: cryptomgr_init+0x0/0x10() returned 0.
[   18.732291] initcall 0x78a2b040 ran for 0 msecs: cryptomgr_init+0x0/0x10()
[   18.739137] Calling initcall 0x78a2b050: hmac_module_init+0x0/0x10()
[   18.745478] initcall 0x78a2b050: hmac_module_init+0x0/0x10() returned 0.
[   18.752136] initcall 0x78a2b050 ran for 0 msecs: hmac_module_init+0x0/0x10()
[   18.759156] Calling initcall 0x78a2b060: crypto_xcbc_module_init+0x0/0x10()
[   18.766091] initcall 0x78a2b060: crypto_xcbc_module_init+0x0/0x10() returned 0.
[   18.773365] initcall 0x78a2b060 ran for 0 msecs: crypto_xcbc_module_init+0x0/0x10()
[   18.780997] Calling initcall 0x78a2b070: init+0x0/0x50()
[   18.786286] initcall 0x78a2b070: init+0x0/0x50() returned 0.
[   18.791915] initcall 0x78a2b070 ran for 0 msecs: init+0x0/0x50()
[   18.797888] Calling initcall 0x78a2b0c0: init+0x0/0x10()
[   18.803182] initcall 0x78a2b0c0: init+0x0/0x10() returned 0.
[   18.808813] initcall 0x78a2b0c0 ran for 0 msecs: init+0x0/0x10()
[   18.814787] Calling initcall 0x78a2b0d0: init+0x0/0x10()
[   18.820081] initcall 0x78a2b0d0: init+0x0/0x10() returned 0.
[   18.825711] initcall 0x78a2b0d0 ran for 0 msecs: init+0x0/0x10()
[   18.831692] Calling initcall 0x78a2b0e0: init+0x0/0x10()
[   18.836980] initcall 0x78a2b0e0: init+0x0/0x10() returned 0.
[   18.842610] initcall 0x78a2b0e0 ran for 0 msecs: init+0x0/0x10()
[   18.848591] Calling initcall 0x78a2b0f0: init+0x0/0x10()
[   18.853879] initcall 0x78a2b0f0: init+0x0/0x10() returned 0.
[   18.859504] initcall 0x78a2b0f0 ran for 0 msecs: init+0x0/0x10()
[   18.865489] Calling initcall 0x78a2b100: crypto_ecb_module_init+0x0/0x10()
[   18.872338] initcall 0x78a2b100: crypto_ecb_module_init+0x0/0x10() returned 0.
[   18.879523] initcall 0x78a2b100 ran for 0 msecs: crypto_ecb_module_init+0x0/0x10()
[   18.887070] Calling initcall 0x78a2b110: crypto_cbc_module_init+0x0/0x10()
[   18.893917] initcall 0x78a2b110: crypto_cbc_module_init+0x0/0x10() returned 0.
[   18.901102] initcall 0x78a2b110 ran for 0 msecs: crypto_cbc_module_init+0x0/0x10()
[   18.908649] Calling initcall 0x78a2b120: crypto_pcbc_module_init+0x0/0x10()
[   18.915582] initcall 0x78a2b120: crypto_pcbc_module_init+0x0/0x10() returned 0.
[   18.922854] initcall 0x78a2b120 ran for 0 msecs: crypto_pcbc_module_init+0x0/0x10()
[   18.930487] Calling initcall 0x78a2b130: init+0x0/0x40()
[   18.935775] initcall 0x78a2b130: init+0x0/0x40() returned 0.
[   18.941399] initcall 0x78a2b130 ran for 0 msecs: init+0x0/0x40()
[   18.947381] Calling initcall 0x78a2b170: init+0x0/0x10()
[   18.952673] initcall 0x78a2b170: init+0x0/0x10() returned 0.
[   18.958303] initcall 0x78a2b170 ran for 0 msecs: init+0x0/0x10()
[   18.964280] Calling initcall 0x78a2b180: init+0x0/0x10()
[   18.969572] initcall 0x78a2b180: init+0x0/0x10() returned 0.
[   18.975203] initcall 0x78a2b180 ran for 0 msecs: init+0x0/0x10()
[   18.981176] Calling initcall 0x78a2b190: init+0x0/0x40()
[   18.986472] initcall 0x78a2b190: init+0x0/0x40() returned 0.
[   18.992101] initcall 0x78a2b190 ran for 0 msecs: init+0x0/0x40()
[   18.998075] Calling initcall 0x78a2b1d0: aes_init+0x0/0x330()
[   19.003820] initcall 0x78a2b1d0: aes_init+0x0/0x330() returned 0.
[   19.009864] initcall 0x78a2b1d0 ran for 0 msecs: aes_init+0x0/0x330()
[   19.016279] Calling initcall 0x78a2b500: camellia_init+0x0/0x10()
[   19.022348] initcall 0x78a2b500: camellia_init+0x0/0x10() returned 0.
[   19.028759] initcall 0x78a2b500 ran for 0 msecs: camellia_init+0x0/0x10()
[   19.035519] Calling initcall 0x78a2b510: init+0x0/0x10()
[   19.040808] initcall 0x78a2b510: init+0x0/0x10() returned 0.
[   19.046435] initcall 0x78a2b510 ran for 0 msecs: init+0x0/0x10()
[   19.052418] Calling initcall 0x78a2b520: init+0x0/0x10()
[   19.057707] initcall 0x78a2b520: init+0x0/0x10() returned 0.
[   19.063334] initcall 0x78a2b520 ran for 0 msecs: init+0x0/0x10()
[   19.069317] Calling initcall 0x78a2b530: arc4_init+0x0/0x10()
[   19.075039] initcall 0x78a2b530: arc4_init+0x0/0x10() returned 0.
[   19.081097] initcall 0x78a2b530 ran for 0 msecs: arc4_init+0x0/0x10()
[   19.087512] Calling initcall 0x78a2b540: init+0x0/0x60()
[   19.092806] initcall 0x78a2b540: init+0x0/0x60() returned 0.
[   19.098435] initcall 0x78a2b540 ran for 0 msecs: init+0x0/0x60()
[   19.104409] Calling initcall 0x78a2b5a0: init+0x0/0x10()
[   19.109706] initcall 0x78a2b5a0: init+0x0/0x10() returned 0.
[   19.115853] initcall 0x78a2b5a0 ran for 0 msecs: init+0x0/0x10()
[   19.121833] Calling initcall 0x78a2b5b0: init+0x0/0x10()
[   19.127123] initcall 0x78a2b5b0: init+0x0/0x10() returned 0.
[   19.132747] initcall 0x78a2b5b0 ran for 0 msecs: init+0x0/0x10()
[   19.138733] Calling initcall 0x78a2b8c0: noop_init+0x0/0x10()
[   19.144460] io scheduler noop registered (default)
[   19.149224] initcall 0x78a2b8c0: noop_init+0x0/0x10() returned 0.
[   19.155285] initcall 0x78a2b8c0 ran for 3 msecs: noop_init+0x0/0x10()
[   19.161697] Calling initcall 0x78a2b8d0: deadline_init+0x0/0x10()
[   19.167762] io scheduler deadline registered
[   19.172016] initcall 0x78a2b8d0: deadline_init+0x0/0x10() returned 0.
[   19.178422] initcall 0x78a2b8d0 ran for 3 msecs: deadline_init+0x0/0x10()
[   19.185182] Calling initcall 0x78a2b9f0: audit_classes_init+0x0/0x50()
[   19.191688] initcall 0x78a2b9f0: audit_classes_init+0x0/0x50() returned 0.
[   19.198528] initcall 0x78a2b9f0 ran for 0 msecs: audit_classes_init+0x0/0x50()
[   19.205721] Calling initcall 0x78a2be10: pci_init+0x0/0x30()
[   19.231480] Boot video device is 0000:01:00.0
[   19.235715] initcall 0x78a2be10: pci_init+0x0/0x30() returned 0.
[   19.241685] initcall 0x78a2be10 ran for 15 msecs: pci_init+0x0/0x30()
[   19.248093] Calling initcall 0x78a2d070: pci_proc_init+0x0/0x70()
[   19.254203] initcall 0x78a2d070: pci_proc_init+0x0/0x70() returned 0.
[   19.260575] initcall 0x78a2d070 ran for 0 msecs: pci_proc_init+0x0/0x70()
[   19.267334] Calling initcall 0x78a2d200: corgibl_init+0x0/0x10()
[   19.273333] initcall 0x78a2d200: corgibl_init+0x0/0x10() returned 0.
[   19.279640] initcall 0x78a2d200 ran for 0 msecs: corgibl_init+0x0/0x10()
[   19.286319] Calling initcall 0x78a2d210: progearbl_init+0x0/0x60()
[   19.292497] ALI M7101 PMU not found.
[   19.296049] initcall 0x78a2d210: progearbl_init+0x0/0x60() returned 0.
[   19.302522] initcall 0x78a2d210 ran for 3 msecs: progearbl_init+0x0/0x60()
[   19.309368] Calling initcall 0x78a2d330: rand_initialize+0x0/0x30()
[   19.315636] initcall 0x78a2d330: rand_initialize+0x0/0x30() returned 0.
[   19.322194] initcall 0x78a2d330 ran for 0 msecs: rand_initialize+0x0/0x30()
[   19.329127] Calling initcall 0x78a2d390: tty_init+0x0/0x1f0()
[   19.335791] initcall 0x78a2d390: tty_init+0x0/0x1f0() returned 0.
[   19.341727] initcall 0x78a2d390 ran for 0 msecs: tty_init+0x0/0x1f0()
[   19.348143] Calling initcall 0x78a2d5b0: pty_init+0x0/0x2a0()
[   19.353868] initcall 0x78a2d5b0: pty_init+0x0/0x2a0() returned 0.
[   19.359923] initcall 0x78a2d5b0 ran for 0 msecs: pty_init+0x0/0x2a0()
[   19.366341] Calling initcall 0x78a2deb0: raw_init+0x0/0xd0()
[   19.372000] initcall 0x78a2deb0: raw_init+0x0/0xd0() returned 0.
[   19.377946] initcall 0x78a2deb0 ran for 0 msecs: raw_init+0x0/0xd0()
[   19.384275] Calling initcall 0x78a2df80: applicom_init+0x0/0x4c0()
[   19.390429] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[   19.397542] ac.o: No PCI boards found.
[   19.401268] ac.o: For an ISA board you must supply memory and irq parameters.
[   19.408376] initcall 0x78a2df80: applicom_init+0x0/0x4c0() returned -6.
[   19.414956] initcall 0x78a2df80 ran for 10 msecs: applicom_init+0x0/0x4c0()
[   19.421891] initcall at 0x78a2df80: applicom_init+0x0/0x4c0(): returned with error code -6
[   19.430124] Calling initcall 0x78a2e440: rtc_init+0x0/0x1b0()
[   19.435871] Real Time Clock Driver v1.12ac
[   19.439921] initcall 0x78a2e440: rtc_init+0x0/0x1b0() returned 0.
[   19.445975] initcall 0x78a2e440 ran for 0 msecs: rtc_init+0x0/0x1b0()
[   19.452393] Calling initcall 0x78a2e5f0: nvram_init+0x0/0x80()
[   19.458216] Non-volatile memory driver v1.2
[   19.462366] initcall 0x78a2e5f0: nvram_init+0x0/0x80() returned 0.
[   19.468513] initcall 0x78a2e5f0 ran for 3 msecs: nvram_init+0x0/0x80()
[   19.475012] Calling initcall 0x78a2e670: i8k_init+0x0/0x250()
[   19.480736] initcall 0x78a2e670: i8k_init+0x0/0x250() returned -19.
[   19.486968] initcall 0x78a2e670 ran for 0 msecs: i8k_init+0x0/0x250()
[   19.493382] Calling initcall 0x78a2e8c0: mod_init+0x0/0x210()
[   19.499115] initcall 0x78a2e8c0: mod_init+0x0/0x210() returned -19.
[   19.505344] initcall 0x78a2e8c0 ran for 0 msecs: mod_init+0x0/0x210()
[   19.511756] Calling initcall 0x78a2ebc0: mod_init+0x0/0xb0()
[   19.517396] initcall 0x78a2ebc0: mod_init+0x0/0xb0() returned -19.
[   19.523540] initcall 0x78a2ebc0 ran for 0 msecs: mod_init+0x0/0xb0()
[   19.529871] Calling initcall 0x78a2ec70: cs5535_gpio_init+0x0/0x1d0()
[   19.536283] cs5535_gpio: DIVIL not found
[   19.540187] initcall 0x78a2ec70: cs5535_gpio_init+0x0/0x1d0() returned -19.
[   19.547111] initcall 0x78a2ec70 ran for 0 msecs: cs5535_gpio_init+0x0/0x1d0()
[   19.554218] Calling initcall 0x78a2ee40: mwave_init+0x0/0x340()
[   19.560119] smapi::smapi_init, ERROR invalid usSmapiID
[   19.565230] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[   19.574502] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[   19.581694] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   19.587939] initcall 0x78a2ee40: mwave_init+0x0/0x340() returned -5.
[   19.594252] initcall 0x78a2ee40 ran for 13 msecs: mwave_init+0x0/0x340()
[   19.600928] initcall at 0x78a2ee40: mwave_init+0x0/0x340(): returned with error code -5
[   19.608905] Calling initcall 0x78a2f1c0: agp_init+0x0/0x30()
[   19.614536] Linux agpgart interface v0.102
[   19.618616] initcall 0x78a2f1c0: agp_init+0x0/0x30() returned 0.
[   19.624584] initcall 0x78a2f1c0 ran for 2 msecs: agp_init+0x0/0x30()
[   19.630912] Calling initcall 0x78a2f360: agp_ali_init+0x0/0x30()
[   19.636916] initcall 0x78a2f360: agp_ali_init+0x0/0x30() returned 0.
[   19.643218] initcall 0x78a2f360 ran for 0 msecs: agp_ali_init+0x0/0x30()
[   19.649896] Calling initcall 0x78a2f470: agp_ati_init+0x0/0x30()
[   19.655892] initcall 0x78a2f470: agp_ati_init+0x0/0x30() returned 0.
[   19.662201] initcall 0x78a2f470 ran for 0 msecs: agp_ati_init+0x0/0x30()
[   19.668873] Calling initcall 0x78a2fc10: agp_amd64_init+0x0/0xd0()
[   19.675045] initcall 0x78a2fc10: agp_amd64_init+0x0/0xd0() returned 0.
[   19.681526] initcall 0x78a2fc10 ran for 0 msecs: agp_amd64_init+0x0/0xd0()
[   19.688375] Calling initcall 0x78a2fe40: agp_nvidia_init+0x0/0x30()
[   19.694634] initcall 0x78a2fe40: agp_nvidia_init+0x0/0x30() returned 0.
[   19.701192] initcall 0x78a2fe40 ran for 0 msecs: agp_nvidia_init+0x0/0x30()
[   19.708134] Calling initcall 0x78a2ffc0: agp_sis_init+0x0/0x30()
[   19.714134] initcall 0x78a2ffc0: agp_sis_init+0x0/0x30() returned 0.
[   19.720434] initcall 0x78a2ffc0 ran for 0 msecs: agp_sis_init+0x0/0x30()
[   19.727107] Calling initcall 0x78a2fff0: drm_core_init+0x0/0x140()
[   19.733287] [drm] Initialized drm 1.1.0 20060810
[   19.737863] initcall 0x78a2fff0: drm_core_init+0x0/0x140() returned 0.
[   19.744350] initcall 0x78a2fff0 ran for 4 msecs: drm_core_init+0x0/0x140()
[   19.751199] Calling initcall 0x78a30130: tdfx_init+0x0/0x10()
[   19.756927] initcall 0x78a30130: tdfx_init+0x0/0x10() returned 0.
[   19.762985] initcall 0x78a30130 ran for 0 msecs: tdfx_init+0x0/0x10()
[   19.769400] Calling initcall 0x78a30140: radeon_init+0x0/0x20()
[   19.775505] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[   19.781313] initcall 0x78a30140: radeon_init+0x0/0x20() returned 0.
[   19.787533] initcall 0x78a30140 ran for 2 msecs: radeon_init+0x0/0x20()
[   19.794122] Calling initcall 0x78a30160: mga_init+0x0/0x20()
[   19.799761] initcall 0x78a30160: mga_init+0x0/0x20() returned 0.
[   19.805737] initcall 0x78a30160 ran for 0 msecs: mga_init+0x0/0x20()
[   19.812064] Calling initcall 0x78a30180: sis_init+0x0/0x20()
[   19.817701] initcall 0x78a30180: sis_init+0x0/0x20() returned 0.
[   19.823673] initcall 0x78a30180 ran for 0 msecs: sis_init+0x0/0x20()
[   19.830000] Calling initcall 0x78a301a0: via_init+0x0/0x20()
[   19.835643] initcall 0x78a301a0: via_init+0x0/0x20() returned 0.
[   19.841616] initcall 0x78a301a0 ran for 0 msecs: via_init+0x0/0x20()
[   19.847938] Calling initcall 0x78a30280: hangcheck_init+0x0/0xb0()
[   19.854093] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   19.863023] Hangcheck: Using get_cycles().
[   19.867101] initcall 0x78a30280: hangcheck_init+0x0/0xb0() returned 0.
[   19.873590] initcall 0x78a30280 ran for 5 msecs: hangcheck_init+0x0/0xb0()
[   19.880437] Calling initcall 0x78a307c0: serial8250_init+0x0/0x140()
[   19.886764] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   19.894722] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   19.900777] initcall 0x78a307c0: serial8250_init+0x0/0x140() returned 0.
[   19.907319] initcall 0x78a307c0 ran for 10 msecs: serial8250_init+0x0/0x140()
[   19.914425] Calling initcall 0x78a30ef0: mca_init+0x0/0x20()
[   19.920063] initcall 0x78a30ef0: mca_init+0x0/0x20() returned -19.
[   19.926211] initcall 0x78a30ef0 ran for 0 msecs: mca_init+0x0/0x20()
[   19.932540] Calling initcall 0x78a30f10: jsm_init_module+0x0/0x40()
[   19.938812] initcall 0x78a30f10: jsm_init_module+0x0/0x40() returned 0.
[   19.945366] initcall 0x78a30f10 ran for 0 msecs: jsm_init_module+0x0/0x40()
[   19.952299] Calling initcall 0x78a311a0: e1000_init_module+0x0/0x90()
[   19.958710] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
[   19.964694] Copyright (c) 1999-2006 Intel Corporation.
[   19.969829] initcall 0x78a311a0: e1000_init_module+0x0/0x90() returned 0.
[   19.976561] initcall 0x78a311a0 ran for 4 msecs: e1000_init_module+0x0/0x90()
[   19.983673] Calling initcall 0x78a33190: e100_init_module+0x0/0x60()
[   19.989995] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   19.996065] e100: Copyright(c) 1999-2006 Intel Corporation
[   20.001546] initcall 0x78a33190: e100_init_module+0x0/0x60() returned 0.
[   20.008195] initcall 0x78a33190 ran for 7 msecs: e100_init_module+0x0/0x60()
[   20.015218] Calling initcall 0x78a339a0: net_olddevs_init+0x0/0x90()
[   20.021547] initcall 0x78a339a0: net_olddevs_init+0x0/0x90() returned 0.
[   20.028214] initcall 0x78a339a0 ran for 0 msecs: net_olddevs_init+0x0/0x90()
[   20.035236] Calling initcall 0x78a33ad0: init_nic+0x0/0x20()
[   20.040881] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   20.048197] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   20.571522] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[   20.579774] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
[   20.586718] initcall 0x78a33ad0: init_nic+0x0/0x20() returned 0.
[   20.592677] initcall 0x78a33ad0 ran for 506 msecs: init_nic+0x0/0x20()
[   20.599180] Calling initcall 0x78a352f0: rtl8139_init_module+0x0/0x20()
[   20.605785] 8139too Fast Ethernet driver 0.9.28
[   20.610640] eth1: RealTek RTL8139 at 0xb8820000, 00:c0:df:03:68:5d, IRQ 11
[   20.617385] eth1:  Identified 8139 chip type 'RTL-8139B'
[   20.622678] initcall 0x78a352f0: rtl8139_init_module+0x0/0x20() returned 0.
[   20.629596] initcall 0x78a352f0 ran for 9 msecs: rtl8139_init_module+0x0/0x20()
[   20.636881] Calling initcall 0x78a35d20: ipddp_init_module+0x0/0x110()
[   20.643378] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[   20.651020] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@samba.org>
[   20.658317] initcall 0x78a35d20: ipddp_init_module+0x0/0x110() returned 0.
[   20.665156] initcall 0x78a35d20 ran for 7 msecs: ipddp_init_module+0x0/0x110()
[   20.672349] Calling initcall 0x78a35e30: usb_irda_init+0x0/0x50()
[   20.678422] usbcore: registered new interface driver irda-usb
[   20.684145] USB IrDA support registered
[   20.687955] initcall 0x78a35e30: usb_irda_init+0x0/0x50() returned 0.
[   20.694881] initcall 0x78a35e30 ran for 5 msecs: usb_irda_init+0x0/0x50()
[   20.701643] Calling initcall 0x78a35e80: w83977af_init+0x0/0x520()
[   20.707843] initcall 0x78a35e80: w83977af_init+0x0/0x520() returned -19.
[   20.714461] initcall 0x78a35e80 ran for 0 msecs: w83977af_init+0x0/0x520()
[   20.721315] Calling initcall 0x78a363a0: donauboe_init+0x0/0x20()
[   20.727402] initcall 0x78a363a0: donauboe_init+0x0/0x20() returned 0.
[   20.733789] initcall 0x78a363a0 ran for 0 msecs: donauboe_init+0x0/0x20()
[   20.740548] Calling initcall 0x78a372d0: smsc_ircc_init+0x0/0x5c0()
[   20.746922] initcall 0x78a372d0: smsc_ircc_init+0x0/0x5c0() returned -19.
[   20.753548] initcall 0x78a372d0 ran for 0 msecs: smsc_ircc_init+0x0/0x5c0()
[   20.760481] Calling initcall 0x78a37b50: ali_ircc_init+0x0/0x6a0()
[   20.766693] initcall 0x78a37b50: ali_ircc_init+0x0/0x6a0() returned -19.
[   20.773306] initcall 0x78a37b50 ran for 0 msecs: ali_ircc_init+0x0/0x6a0()
[   20.780158] Calling initcall 0x78a381f0: vlsi_mod_init+0x0/0x130()
[   20.786333] initcall 0x78a381f0: vlsi_mod_init+0x0/0x130() returned 0.
[   20.792805] initcall 0x78a381f0 ran for 0 msecs: vlsi_mod_init+0x0/0x130()
[   20.799657] Calling initcall 0x78a38c10: via_ircc_init+0x0/0x20()
[   20.805742] initcall 0x78a38c10: via_ircc_init+0x0/0x20() returned 0.
[   20.812134] initcall 0x78a38c10 ran for 0 msecs: via_ircc_init+0x0/0x20()
[   20.818893] Calling initcall 0x78a38ff0: irtty_sir_init+0x0/0x40()
[   20.825048] initcall 0x78a38ff0: irtty_sir_init+0x0/0x40() returned 0.
[   20.831546] initcall 0x78a38ff0 ran for 0 msecs: irtty_sir_init+0x0/0x40()
[   20.838392] Calling initcall 0x78a39030: sir_wq_init+0x0/0x20()
[   20.844320] initcall 0x78a39030: sir_wq_init+0x0/0x20() returned 0.
[   20.850521] initcall 0x78a39030 ran for 0 msecs: sir_wq_init+0x0/0x20()
[   20.857107] Calling initcall 0x78a39050: ksdazzle_init+0x0/0x20()
[   20.863183] usbcore: registered new interface driver ksdazzle-sir
[   20.869250] initcall 0x78a39050: ksdazzle_init+0x0/0x20() returned 0.
[   20.875656] initcall 0x78a39050 ran for 5 msecs: ksdazzle_init+0x0/0x20()
[   20.882416] Calling initcall 0x78a39090: init_netconsole+0x0/0x1a0()
[   20.888743] console [netcon0] enabled
[   27.186511] netconsole: network logging started
[   27.191020] initcall 0x78a39090: init_netconsole+0x0/0x1a0() returned 0.
[   27.197685] initcall 0x78a39090 ran for 9 msecs: init_netconsole+0x0/0x1a0()
[   27.204706] Calling initcall 0x78a39590: raid_init+0x0/0x10()
[   27.210433] initcall 0x78a39590: raid_init+0x0/0x10() returned 0.
[   27.216486] initcall 0x78a39590 ran for 0 msecs: raid_init+0x0/0x10()
[   27.222902] Calling initcall 0x78a395a0: spi_transport_init+0x0/0x30()
[   27.229426] initcall 0x78a395a0: spi_transport_init+0x0/0x30() returned 0.
[   27.236247] initcall 0x78a395a0 ran for 0 msecs: spi_transport_init+0x0/0x30()
[   27.243440] Calling initcall 0x78a395d0: fc_transport_init+0x0/0x50()
[   27.249875] initcall 0x78a395d0: fc_transport_init+0x0/0x50() returned 0.
[   27.256610] initcall 0x78a395d0 ran for 0 msecs: fc_transport_init+0x0/0x50()
[   27.263724] Calling initcall 0x78a39620: iscsi_transport_init+0x0/0xe0()
[   27.270393] Loading iSCSI transport class v2.0-724.
[   27.275282] initcall 0x78a39620: iscsi_transport_init+0x0/0xe0() returned 0.
[   27.282264] initcall 0x78a39620 ran for 1 msecs: iscsi_transport_init+0x0/0xe0()
[   27.289636] Calling initcall 0x78a39700: sas_transport_init+0x0/0xa0()
[   27.296185] initcall 0x78a39700: sas_transport_init+0x0/0xa0() returned 0.
[   27.302976] initcall 0x78a39700 ran for 0 msecs: sas_transport_init+0x0/0xa0()
[   27.310169] Calling initcall 0x78a397a0: sas_class_init+0x0/0x40()
[   27.316328] initcall 0x78a397a0: sas_class_init+0x0/0x40() returned 0.
[   27.322822] initcall 0x78a397a0 ran for 0 msecs: sas_class_init+0x0/0x40()
[   27.329668] Calling initcall 0x78a397e0: init_sd+0x0/0xd0()
[   27.335269] initcall 0x78a397e0: init_sd+0x0/0xd0() returned 0.
[   27.341110] initcall 0x78a397e0 ran for 0 msecs: init_sd+0x0/0xd0()
[   27.347350] Calling initcall 0x78a398b0: init_ch_module+0x0/0xa0()
[   27.353500] SCSI Media Changer driver v0.25 
[   27.357781] initcall 0x78a398b0: init_ch_module+0x0/0xa0() returned 0.
[   27.364249] initcall 0x78a398b0 ran for 3 msecs: init_ch_module+0x0/0xa0()
[   27.371095] Calling initcall 0x78a399c0: ahci_init+0x0/0x20()
[   27.376852] initcall 0x78a399c0: ahci_init+0x0/0x20() returned 0.
[   27.382878] initcall 0x78a399c0 ran for 2 msecs: ahci_init+0x0/0x20()
[   27.389291] Calling initcall 0x78a399e0: piix_init+0x0/0x20()
[   27.395037] initcall 0x78a399e0: piix_init+0x0/0x20() returned 0.
[   27.401080] initcall 0x78a399e0 ran for 0 msecs: piix_init+0x0/0x20()
[   27.407492] Calling initcall 0x78a39a00: pdc_ata_init+0x0/0x20()
[   27.413496] initcall 0x78a39a00: pdc_ata_init+0x0/0x20() returned 0.
[   27.419793] initcall 0x78a39a00 ran for 0 msecs: pdc_ata_init+0x0/0x20()
[   27.426468] Calling initcall 0x78a39a20: qs_ata_init+0x0/0x20()
[   27.432386] initcall 0x78a39a20: qs_ata_init+0x0/0x20() returned 0.
[   27.438601] initcall 0x78a39a20 ran for 0 msecs: qs_ata_init+0x0/0x20()
[   27.445193] Calling initcall 0x78a39d00: vsc_sata_init+0x0/0x20()
[   27.451279] initcall 0x78a39d00: vsc_sata_init+0x0/0x20() returned 0.
[   27.457670] initcall 0x78a39d00 ran for 0 msecs: vsc_sata_init+0x0/0x20()
[   27.464429] Calling initcall 0x78a39d20: nv_init+0x0/0x20()
[   27.469998] initcall 0x78a39d20: nv_init+0x0/0x20() returned 0.
[   27.475866] initcall 0x78a39d20 ran for 0 msecs: nv_init+0x0/0x20()
[   27.482105] Calling initcall 0x78a39d40: mv_init+0x0/0x20()
[   27.487677] initcall 0x78a39d40: mv_init+0x0/0x20() returned 0.
[   27.493547] initcall 0x78a39d40 ran for 0 msecs: mv_init+0x0/0x20()
[   27.499784] Calling initcall 0x78a39d60: inic_init+0x0/0x20()
[   27.505530] initcall 0x78a39d60: inic_init+0x0/0x20() returned 0.
[   27.511567] initcall 0x78a39d60 ran for 0 msecs: inic_init+0x0/0x20()
[   27.517985] Calling initcall 0x78a39d80: amd_init+0x0/0x20()
[   27.523647] pata_amd 0000:00:06.0: version 0.3.9
[   27.528329] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   27.534566] scsi0 : pata_amd
[   27.537401] scsi1 : pata_amd
[   27.540228] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   27.547125] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   27.880496] ata1.00: ATA-5: MAXTOR 6L040J2, AR1.0500, max UDMA/133
[   27.886551] ata1.00: 78177792 sectors, multi 1: LBA 
[   27.891771] ata1.01: ATA-6: ST380011A, 3.06, max UDMA/100
[   27.897046] ata1.01: 156301488 sectors, multi 1: LBA48 
[   27.913730] ata1.00: configured for UDMA/133
[   27.930394] ata1.01: configured for UDMA/100
[   28.097846] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR 6L040J2   AR1. PQ: 0 ANSI: 5
[   28.106020] sd 0:0:0:0: [sda] 78177792 512-byte hardware sectors (40027 MB)
[   28.112875] sd 0:0:0:0: [sda] Write Protect is off
[   28.117624] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   28.122679] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.131925] sd 0:0:0:0: [sda] 78177792 512-byte hardware sectors (40027 MB)
[   28.138776] sd 0:0:0:0: [sda] Write Protect is off
[   28.143527] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   28.148582] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.157590]  sda: sda1 sda2 sda3 sda4 < sda5 >
[   28.198720] sd 0:0:0:0: [sda] Attached SCSI disk
[   28.203319] scsi 0:0:1:0: Direct-Access     ATA      ST380011A        3.06 PQ: 0 ANSI: 5
[   28.211420] sd 0:0:1:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
[   28.218361] sd 0:0:1:0: [sdb] Write Protect is off
[   28.223108] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   28.228167] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.237253] sd 0:0:1:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
[   28.244203] sd 0:0:1:0: [sdb] Write Protect is off
[   28.248942] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[   28.254021] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.262984]  sdb: sdb1 sdb2 sdb3 < sdb5 >
[   28.285871] sd 0:0:1:0: [sdb] Attached SCSI disk
[   28.290406] initcall 0x78a39d80: amd_init+0x0/0x20() returned 0.
[   28.296336] initcall 0x78a39d80 ran for 648 msecs: amd_init+0x0/0x20()
[   28.302839] Calling initcall 0x78a39da0: artop_init+0x0/0x20()
[   28.308674] initcall 0x78a39da0: artop_init+0x0/0x20() returned 0.
[   28.314796] initcall 0x78a39da0 ran for 0 msecs: artop_init+0x0/0x20()
[   28.321301] Calling initcall 0x78a39dc0: atiixp_init+0x0/0x20()
[   28.327217] initcall 0x78a39dc0: atiixp_init+0x0/0x20() returned 0.
[   28.333953] initcall 0x78a39dc0 ran for 0 msecs: atiixp_init+0x0/0x20()
[   28.340539] Calling initcall 0x78a39de0: cmd640_init+0x0/0x20()
[   28.346454] initcall 0x78a39de0: cmd640_init+0x0/0x20() returned 0.
[   28.352669] initcall 0x78a39de0 ran for 0 msecs: cmd640_init+0x0/0x20()
[   28.359254] Calling initcall 0x78a39e00: cmd64x_init+0x0/0x20()
[   28.365176] initcall 0x78a39e00: cmd64x_init+0x0/0x20() returned 0.
[   28.371385] initcall 0x78a39e00 ran for 0 msecs: cmd64x_init+0x0/0x20()
[   28.377977] Calling initcall 0x78a39e20: cs5535_init+0x0/0x20()
[   28.383893] initcall 0x78a39e20: cs5535_init+0x0/0x20() returned 0.
[   28.390109] initcall 0x78a39e20 ran for 0 msecs: cs5535_init+0x0/0x20()
[   28.396698] Calling initcall 0x78a39e40: cy82c693_init+0x0/0x20()
[   28.402785] initcall 0x78a39e40: cy82c693_init+0x0/0x20() returned 0.
[   28.409171] initcall 0x78a39e40 ran for 0 msecs: cy82c693_init+0x0/0x20()
[   28.415931] Calling initcall 0x78a39e60: hpt37x_init+0x0/0x20()
[   28.421853] initcall 0x78a39e60: hpt37x_init+0x0/0x20() returned 0.
[   28.428061] initcall 0x78a39e60 ran for 0 msecs: hpt37x_init+0x0/0x20()
[   28.434653] Calling initcall 0x78a39e80: hpt3x2n_init+0x0/0x20()
[   28.440657] initcall 0x78a39e80: hpt3x2n_init+0x0/0x20() returned 0.
[   28.446959] initcall 0x78a39e80 ran for 0 msecs: hpt3x2n_init+0x0/0x20()
[   28.453634] Calling initcall 0x78a39ea0: hpt3x3_init+0x0/0x20()
[   28.459547] initcall 0x78a39ea0: hpt3x3_init+0x0/0x20() returned 0.
[   28.465762] initcall 0x78a39ea0 ran for 0 msecs: hpt3x3_init+0x0/0x20()
[   28.472347] Calling initcall 0x78a39ec0: it8213_init+0x0/0x20()
[   28.478266] initcall 0x78a39ec0: it8213_init+0x0/0x20() returned 0.
[   28.484483] initcall 0x78a39ec0 ran for 0 msecs: it8213_init+0x0/0x20()
[   28.491069] Calling initcall 0x78a39ee0: netcell_init+0x0/0x20()
[   28.497070] initcall 0x78a39ee0: netcell_init+0x0/0x20() returned 0.
[   28.503375] initcall 0x78a39ee0 ran for 0 msecs: netcell_init+0x0/0x20()
[   28.510051] Calling initcall 0x78a39f00: ns87410_init+0x0/0x20()
[   28.516051] initcall 0x78a39f00: ns87410_init+0x0/0x20() returned 0.
[   28.522351] initcall 0x78a39f00 ran for 0 msecs: ns87410_init+0x0/0x20()
[   28.529024] Calling initcall 0x78a39f20: ns87415_init+0x0/0x20()
[   28.535029] initcall 0x78a39f20: ns87415_init+0x0/0x20() returned 0.
[   28.541328] initcall 0x78a39f20 ran for 0 msecs: ns87415_init+0x0/0x20()
[   28.548006] Calling initcall 0x78a39f40: opti_init+0x0/0x20()
[   28.553753] initcall 0x78a39f40: opti_init+0x0/0x20() returned 0.
[   28.559787] initcall 0x78a39f40 ran for 0 msecs: opti_init+0x0/0x20()
[   28.566202] Calling initcall 0x78a39f60: marvell_init+0x0/0x20()
[   28.572210] initcall 0x78a39f60: marvell_init+0x0/0x20() returned 0.
[   28.578508] initcall 0x78a39f60 ran for 0 msecs: marvell_init+0x0/0x20()
[   28.585186] Calling initcall 0x78a39f80: mpiix_init+0x0/0x20()
[   28.591012] initcall 0x78a39f80: mpiix_init+0x0/0x20() returned 0.
[   28.597143] initcall 0x78a39f80 ran for 0 msecs: mpiix_init+0x0/0x20()
[   28.603644] Calling initcall 0x78a39fa0: oldpiix_init+0x0/0x20()
[   28.609645] initcall 0x78a39fa0: oldpiix_init+0x0/0x20() returned 0.
[   28.615945] initcall 0x78a39fa0 ran for 0 msecs: oldpiix_init+0x0/0x20()
[   28.622618] Calling initcall 0x78a39fc0: pdc202xx_init+0x0/0x20()
[   28.628710] initcall 0x78a39fc0: pdc202xx_init+0x0/0x20() returned 0.
[   28.635098] initcall 0x78a39fc0 ran for 0 msecs: pdc202xx_init+0x0/0x20()
[   28.641862] Calling initcall 0x78a39fe0: serverworks_init+0x0/0x20()
[   28.648210] initcall 0x78a39fe0: serverworks_init+0x0/0x20() returned 0.
[   28.654854] initcall 0x78a39fe0 ran for 0 msecs: serverworks_init+0x0/0x20()
[   28.661881] Calling initcall 0x78a3a440: sil680_init+0x0/0x20()
[   28.667793] initcall 0x78a3a440: sil680_init+0x0/0x20() returned 0.
[   28.674011] initcall 0x78a3a440 ran for 0 msecs: sil680_init+0x0/0x20()
[   28.680598] Calling initcall 0x78a3a460: via_init+0x0/0x20()
[   28.686263] initcall 0x78a3a460: via_init+0x0/0x20() returned 0.
[   28.692207] initcall 0x78a3a460 ran for 0 msecs: via_init+0x0/0x20()
[   28.698533] Calling initcall 0x78a3a480: triflex_init+0x0/0x20()
[   28.704539] initcall 0x78a3a480: triflex_init+0x0/0x20() returned 0.
[   28.710842] initcall 0x78a3a480 ran for 0 msecs: triflex_init+0x0/0x20()
[   28.717515] Calling initcall 0x78a3a4a0: pata_platform_init+0x0/0x10()
[   28.724030] initcall 0x78a3a4a0: pata_platform_init+0x0/0x10() returned 0.
[   28.730861] initcall 0x78a3a4a0 ran for 0 msecs: pata_platform_init+0x0/0x10()
[   28.738054] Calling initcall 0x78a3a810: ata_generic_init+0x0/0x20()
[   28.744426] initcall 0x78a3a810: ata_generic_init+0x0/0x20() returned 0.
[   28.751053] initcall 0x78a3a810 ran for 0 msecs: ata_generic_init+0x0/0x20()
[   28.758073] Calling initcall 0x78a3a830: i2o_iop_init+0x0/0x50()
[   28.764051] I2O subsystem v1.325
[   28.767262] i2o: max drivers = 8
[   28.770544] initcall 0x78a3a830: i2o_iop_init+0x0/0x50() returned 0.
[   28.776796] initcall 0x78a3a830 ran for 6 msecs: i2o_iop_init+0x0/0x50()
[   28.783467] Calling initcall 0x78a3b1a0: i2o_config_init+0x0/0xa0()
[   28.789703] I2O Configuration OSM v1.323
[   28.793629] initcall 0x78a3b1a0: i2o_config_init+0x0/0xa0() returned 0.
[   28.800191] initcall 0x78a3b1a0 ran for 3 msecs: i2o_config_init+0x0/0xa0()
[   28.807125] Calling initcall 0x78a3b240: i2o_bus_init+0x0/0x40()
[   28.813101] I2O Bus Adapter OSM v1.317
[   28.816841] initcall 0x78a3b240: i2o_bus_init+0x0/0x40() returned 0.
[   28.823150] initcall 0x78a3b240 ran for 2 msecs: i2o_bus_init+0x0/0x40()
[   28.829825] Calling initcall 0x78a3b280: i2o_block_init+0x0/0x120()
[   28.836066] I2O Block Device OSM v1.325
[   28.840017] initcall 0x78a3b280: i2o_block_init+0x0/0x120() returned 0.
[   28.846470] initcall 0x78a3b280 ran for 6 msecs: i2o_block_init+0x0/0x120()
[   28.853411] Calling initcall 0x78a3b3a0: i2o_proc_init+0x0/0x190()
[   28.859560] I2O ProcFS OSM v1.316
[   28.862870] initcall 0x78a3b3a0: i2o_proc_init+0x0/0x190() returned 0.
[   28.869351] initcall 0x78a3b3a0 ran for 2 msecs: i2o_proc_init+0x0/0x190()
[   28.876197] Calling initcall 0x78a3b530: fusion_init+0x0/0x110()
[   28.882179] Fusion MPT base driver 3.04.06
[   28.886256] Copyright (c) 1999-2007 LSI Corporation
[   28.891118] initcall 0x78a3b530: fusion_init+0x0/0x110() returned 0.
[   28.897432] initcall 0x78a3b530 ran for 8 msecs: fusion_init+0x0/0x110()
[   28.904105] Calling initcall 0x78a3b640: mptspi_init+0x0/0xd0()
[   28.910002] Fusion MPT SPI Host driver 3.04.06
[   28.914443] initcall 0x78a3b640: mptspi_init+0x0/0xd0() returned 0.
[   28.920658] initcall 0x78a3b640 ran for 4 msecs: mptspi_init+0x0/0xd0()
[   28.927244] Calling initcall 0x78a3b710: mptfc_init+0x0/0xf0()
[   28.933048] Fusion MPT FC Host driver 3.04.06
[   28.937411] initcall 0x78a3b710: mptfc_init+0x0/0xf0() returned 0.
[   28.943536] initcall 0x78a3b710 ran for 3 msecs: mptfc_init+0x0/0xf0()
[   28.950038] Calling initcall 0x78a3b800: mptsas_init+0x0/0xf0()
[   28.955928] Fusion MPT SAS Host driver 3.04.06
[   28.960376] initcall 0x78a3b800: mptsas_init+0x0/0xf0() returned 0.
[   28.966583] initcall 0x78a3b800 ran for 3 msecs: mptsas_init+0x0/0xf0()
[   28.973172] Calling initcall 0x78a3b8f0: mptctl_init+0x0/0x100()
[   28.979153] Fusion MPT misc device (ioctl) driver 3.04.06
[   28.984540] mptctl: Registered with Fusion MPT base driver
[   28.989990] mptctl: /dev/mptctl @ (major,minor=10,220)
[   28.995107] initcall 0x78a3b8f0: mptctl_init+0x0/0x100() returned 0.
[   29.001420] initcall 0x78a3b8f0 ran for 7 msecs: mptctl_init+0x0/0x100()
[   29.008099] Calling initcall 0x78a3b9f0: ieee1394_init+0x0/0x250()
[   29.014345] initcall 0x78a3b9f0: ieee1394_init+0x0/0x250() returned 0.
[   29.020751] initcall 0x78a3b9f0 ran for 0 msecs: ieee1394_init+0x0/0x250()
[   29.027599] Calling initcall 0x78a3bc40: ohci1394_init+0x0/0x20()
[   29.033681] initcall 0x78a3bc40: ohci1394_init+0x0/0x20() returned 0.
[   29.040077] initcall 0x78a3bc40 ran for 0 msecs: ohci1394_init+0x0/0x20()
[   29.046839] Calling initcall 0x78a3c6b0: video1394_init_module+0x0/0xc0()
[   29.053607] video1394: Installed video1394 module
[   29.058282] initcall 0x78a3c6b0: video1394_init_module+0x0/0xc0() returned 0.
[   29.065379] initcall 0x78a3c6b0 ran for 4 msecs: video1394_init_module+0x0/0xc0()
[   29.072837] Calling initcall 0x78538420: sbp2_module_init+0x0/0xa0()
[   29.079173] initcall 0x78538420: sbp2_module_init+0x0/0xa0() returned 0.
[   29.085831] initcall 0x78538420 ran for 0 msecs: sbp2_module_init+0x0/0xa0()
[   29.092850] Calling initcall 0x78a3c770: dv1394_init_module+0x0/0xc0()
[   29.099351] NOTE: The dv1394 driver is unsupported and may be removed in a future Linux release. Use raw1394 instead.
[   29.109942] initcall 0x78a3c770: dv1394_init_module+0x0/0xc0() returned 0.
[   29.116772] initcall 0x78a3c770 ran for 3 msecs: dv1394_init_module+0x0/0xc0()
[   29.123967] Calling initcall 0x78a3c830: ether1394_init_module+0x0/0x70()
[   29.130736] initcall 0x78a3c830: ether1394_init_module+0x0/0x70() returned 0.
[   29.137825] initcall 0x78a3c830 ran for 0 msecs: ether1394_init_module+0x0/0x70()
[   29.145286] Calling initcall 0x78a3c8a0: uio_init+0x0/0x10()
[   29.150918] initcall 0x78a3c8a0: uio_init+0x0/0x10() returned 0.
[   29.156896] initcall 0x78a3c8a0 ran for 0 msecs: uio_init+0x0/0x10()
[   29.163219] Calling initcall 0x78a3c9c0: at25_init+0x0/0x10()
[   29.168950] initcall 0x78a3c9c0: at25_init+0x0/0x10() returned 0.
[   29.175005] initcall 0x78a3c9c0 ran for 0 msecs: at25_init+0x0/0x10()
[   29.181421] Calling initcall 0x78a3c9d0: tle62x0_init+0x0/0x10()
[   29.187409] initcall 0x78a3c9d0: tle62x0_init+0x0/0x10() returned 0.
[   29.193728] initcall 0x78a3c9d0 ran for 0 msecs: tle62x0_init+0x0/0x10()
[   29.200403] Calling initcall 0x78a3cb90: kvm_init+0x0/0x120()
[   29.206195] initcall 0x78a3cb90: kvm_init+0x0/0x120() returned 0.
[   29.212183] initcall 0x78a3cb90 ran for 0 msecs: kvm_init+0x0/0x120()
[   29.218596] Calling initcall 0x78a3d000: vmx_init+0x0/0x110()
[   29.224329] kvm: no hardware support
[   29.227883] initcall 0x78a3d000: vmx_init+0x0/0x110() returned -95.
[   29.234111] initcall 0x78a3d000 ran for 3 msecs: vmx_init+0x0/0x110()
[   29.240524] initcall at 0x78a3d000: vmx_init+0x0/0x110(): returned with error code -95
[   29.248413] Calling initcall 0x78a3d110: svm_init+0x0/0x20()
[   29.254042] has_svm: svm not available
[   29.257772] kvm: no hardware support
[   29.261330] initcall 0x78a3d110: svm_init+0x0/0x20() returned -95.
[   29.267476] initcall 0x78a3d110 ran for 6 msecs: svm_init+0x0/0x20()
[   29.273803] initcall at 0x78a3d110: svm_init+0x0/0x20(): returned with error code -95
[   29.281604] Calling initcall 0x78a3d450: mon_init+0x0/0x120()
[   29.287367] initcall 0x78a3d450: mon_init+0x0/0x120() returned 0.
[   29.293388] initcall 0x78a3d450 ran for 0 msecs: mon_init+0x0/0x120()
[   29.299797] Calling initcall 0x78a3dad0: ehci_hcd_init+0x0/0x20()
[   29.305928] PCI: No IRQ known for interrupt pin B of device 0000:00:02.1. Probably buggy MP table.
[   29.314797] ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
[   29.323217] ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
[   29.329025] initcall 0x78a3dad0: ehci_hcd_init+0x0/0x20() returned 0.
[   29.335415] initcall 0x78a3dad0 ran for 11 msecs: ehci_hcd_init+0x0/0x20()
[   29.342261] Calling initcall 0x78a3daf0: isp116x_init+0x0/0x40()
[   29.348242] 116x: driver isp116x-hcd, 03 Nov 2005
[   29.352946] initcall 0x78a3daf0: isp116x_init+0x0/0x40() returned 0.
[   29.359247] initcall 0x78a3daf0 ran for 1 msecs: isp116x_init+0x0/0x40()
[   29.365920] Calling initcall 0x78a3de10: ohci_hcd_mod_init+0x0/0x70()
[   29.372335] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   29.379867] PCI: No IRQ known for interrupt pin A of device 0000:00:02.0. Probably buggy MP table.
[   29.389341] ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
[   29.397757] ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
[   29.403587] initcall 0x78a3de10: ohci_hcd_mod_init+0x0/0x70() returned 0.
[   29.410312] initcall 0x78a3de10 ran for 17 msecs: ohci_hcd_mod_init+0x0/0x70()
[   29.417507] Calling initcall 0x78a3dee0: uhci_hcd_init+0x0/0xb0()
[   29.423569] USB Universal Host Controller Interface driver v3.0
[   29.429492] initcall 0x78a3dee0: uhci_hcd_init+0x0/0xb0() returned 0.
[   29.435873] initcall 0x78a3dee0 ran for 2 msecs: uhci_hcd_init+0x0/0xb0()
[   29.442633] Calling initcall 0x78a3df90: r8a66597_init+0x0/0x50()
[   29.448700] drivers/usb/host/r8a66597-hcd.c: driver r8a66597_hcd, 29 May 2007
[   29.455830] initcall 0x78a3df90: r8a66597_init+0x0/0x50() returned 0.
[   29.462218] initcall 0x78a3df90 ran for 3 msecs: r8a66597_init+0x0/0x50()
[   29.468978] Calling initcall 0x78a3e270: usblp_init+0x0/0x20()
[   29.474800] usbcore: registered new interface driver usblp
[   29.480254] initcall 0x78a3e270: usblp_init+0x0/0x20() returned 0.
[   29.486393] initcall 0x78a3e270 ran for 2 msecs: usblp_init+0x0/0x20()
[   29.492896] Calling initcall 0x78a3e290: usb_stor_init+0x0/0x50()
[   29.498964] Initializing USB Mass Storage driver...
[   29.503835] usbcore: registered new interface driver usb-storage
[   29.509802] USB Mass Storage support registered.
[   29.514405] initcall 0x78a3e290: usb_stor_init+0x0/0x50() returned 0.
[   29.520804] initcall 0x78a3e290 ran for 10 msecs: usb_stor_init+0x0/0x50()
[   29.527651] Calling initcall 0x78a3e2e0: usb_usual_init+0x0/0x30()
[   29.533817] usbcore: registered new interface driver libusual
[   29.539529] initcall 0x78a3e2e0: usb_usual_init+0x0/0x30() returned 0.
[   29.546019] initcall 0x78a3e2e0 ran for 2 msecs: usb_usual_init+0x0/0x30()
[   29.552865] Calling initcall 0x78a3e310: usb_mdc800_init+0x0/0x230()
[   29.559209] usbcore: registered new interface driver mdc800
[   29.564745] drivers/usb/image/mdc800.c: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   29.574107] initcall 0x78a3e310: usb_mdc800_init+0x0/0x230() returned 0.
[   29.580774] initcall 0x78a3e310 ran for 7 msecs: usb_mdc800_init+0x0/0x230()
[   29.587794] Calling initcall 0x78a3e540: microtek_drv_init+0x0/0x20()
[   29.594218] usbcore: registered new interface driver microtekX6
[   29.600106] initcall 0x78a3e540: microtek_drv_init+0x0/0x20() returned 0.
[   29.606858] initcall 0x78a3e540 ran for 2 msecs: microtek_drv_init+0x0/0x20()
[   29.613966] Calling initcall 0x78a3e560: usb_serial_init+0x0/0x260()
[   29.620342] usbcore: registered new interface driver usbserial
[   29.626114] drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
[   29.634000] usbcore: registered new interface driver usbserial_generic
[   29.640487] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   29.646729] initcall 0x78a3e560: usb_serial_init+0x0/0x260() returned 0.
[   29.653396] initcall 0x78a3e560 ran for 12 msecs: usb_serial_init+0x0/0x260()
[   29.660504] Calling initcall 0x78a3e7c0: aircable_init+0x0/0x40()
[   29.666585] drivers/usb/serial/usb-serial.c: USB Serial support registered for aircable
[   29.674557] usbcore: registered new interface driver aircable
[   29.680268] initcall 0x78a3e7c0: aircable_init+0x0/0x40() returned 0.
[   29.686674] initcall 0x78a3e7c0 ran for 6 msecs: aircable_init+0x0/0x40()
[   29.693436] Calling initcall 0x78a3e800: airprime_init+0x0/0x60()
[   29.699511] drivers/usb/serial/usb-serial.c: USB Serial support registered for airprime
[   29.707488] usbcore: registered new interface driver airprime
[   29.713199] initcall 0x78a3e800: airprime_init+0x0/0x60() returned 0.
[   29.719599] initcall 0x78a3e800 ran for 5 msecs: airprime_init+0x0/0x60()
[   29.726361] Calling initcall 0x78a3e860: ark3116_init+0x0/0x40()
[   29.732355] drivers/usb/serial/usb-serial.c: USB Serial support registered for ark3116
[   29.740246] usbcore: registered new interface driver ark3116
[   29.745870] initcall 0x78a3e860: ark3116_init+0x0/0x40() returned 0.
[   29.752186] initcall 0x78a3e860 ran for 5 msecs: ark3116_init+0x0/0x40()
[   29.758859] Calling initcall 0x78a3e8a0: cypress_init+0x0/0xd0()
[   29.764841] drivers/usb/serial/cypress_m8.c: cypress_init
[   29.770231] drivers/usb/serial/usb-serial.c: USB Serial support registered for DeLorme Earthmate USB
[   29.779330] drivers/usb/serial/usb-serial.c: USB Serial support registered for HID->COM RS232 Adapter
[   29.788517] drivers/usb/serial/usb-serial.c: USB Serial support registered for Nokia CA-42 V2 Adapter
[   29.797703] usbcore: registered new interface driver cypress
[   29.803323] drivers/usb/serial/cypress_m8.c: Cypress USB to Serial Driver v1.09
[   29.810605] initcall 0x78a3e8a0: cypress_init+0x0/0xd0() returned 0.
[   29.816925] initcall 0x78a3e8a0 ran for 18 msecs: cypress_init+0x0/0xd0()
[   29.823687] Calling initcall 0x78a3e970: debug_init+0x0/0x40()
[   29.829502] drivers/usb/serial/usb-serial.c: USB Serial support registered for debug
[   29.837220] usbcore: registered new interface driver debug
[   29.842670] initcall 0x78a3e970: debug_init+0x0/0x40() returned 0.
[   29.848814] initcall 0x78a3e970 ran for 5 msecs: debug_init+0x0/0x40()
[   29.855312] Calling initcall 0x78a3e9b0: empeg_init+0x0/0x120()
[   29.861251] drivers/usb/serial/usb-serial.c: USB Serial support registered for empeg
[   29.868939] usbcore: registered new interface driver empeg
[   29.874385] drivers/usb/serial/empeg.c: v1.2:USB Empeg Mark I/II Driver
[   29.880975] initcall 0x78a3e9b0: empeg_init+0x0/0x120() returned 0.
[   29.887207] initcall 0x78a3e9b0 ran for 9 msecs: empeg_init+0x0/0x120()
[   29.893794] Calling initcall 0x78a3ead0: ftdi_init+0x0/0xf0()
[   29.899525] drivers/usb/serial/usb-serial.c: USB Serial support registered for FTDI USB Serial Device
[   29.908716] usbcore: registered new interface driver ftdi_sio
[   29.914423] drivers/usb/serial/ftdi_sio.c: v1.4.3:USB FTDI Serial Converters Driver
[   29.922052] initcall 0x78a3ead0: ftdi_init+0x0/0xf0() returned 0.
[   29.928106] initcall 0x78a3ead0 ran for 7 msecs: ftdi_init+0x0/0xf0()
[   29.934524] Calling initcall 0x78a3ebc0: funsoft_init+0x0/0x40()
[   29.940516] drivers/usb/serial/usb-serial.c: USB Serial support registered for funsoft
[   29.948408] usbcore: registered new interface driver funsoft
[   29.954031] initcall 0x78a3ebc0: funsoft_init+0x0/0x40() returned 0.
[   29.960349] initcall 0x78a3ebc0 ran for 6 msecs: funsoft_init+0x0/0x40()
[   29.967022] Calling initcall 0x78a3ec00: hp49gp_init+0x0/0x70()
[   29.972927] drivers/usb/serial/usb-serial.c: USB Serial support registered for hp4X
[   29.980559] usbcore: registered new interface driver hp4X
[   29.985918] drivers/usb/serial/hp4x.c: HP4x (48/49) Generic Serial driver v1.00
[   29.993200] initcall 0x78a3ec00: hp49gp_init+0x0/0x70() returned 0.
[   29.999428] initcall 0x78a3ec00 ran for 8 msecs: hp49gp_init+0x0/0x70()
[   30.006017] Calling initcall 0x7858be70: usb_ipw_init+0x0/0x70()
[   30.012012] drivers/usb/serial/usb-serial.c: USB Serial support registered for IPWireless converter
[   30.021030] usbcore: registered new interface driver ipwtty
[   30.026562] drivers/usb/serial/ipw.c: IPWireless tty driver v0.3
[   30.032546] initcall 0x7858be70: usb_ipw_init+0x0/0x70() returned 0.
[   30.038861] initcall 0x7858be70 ran for 10 msecs: usb_ipw_init+0x0/0x70()
[   30.045621] Calling initcall 0x78a3ec70: keyspan_pda_init+0x0/0xa0()
[   30.051963] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan PDA
[   30.060200] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan PDA - (prerenumeration)
[   30.070165] drivers/usb/serial/usb-serial.c: USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[   30.080998] usbcore: registered new interface driver keyspan_pda
[   30.086965] drivers/usb/serial/keyspan_pda.c: USB Keyspan PDA Converter driver v1.1
[   30.094594] initcall 0x78a3ec70: keyspan_pda_init+0x0/0xa0() returned 0.
[   30.101255] initcall 0x78a3ec70 ran for 18 msecs: keyspan_pda_init+0x0/0xa0()
[   30.108370] Calling initcall 0x78a3ed10: klsi_105_init+0x0/0x70()
[   30.114444] drivers/usb/serial/usb-serial.c: USB Serial support registered for KL5KUSB105D / PalmConnect
[   30.123897] usbcore: registered new interface driver kl5kusb105d
[   30.129862] drivers/usb/serial/kl5kusb105.c: KLSI KL5KUSB105 chipset USB->Serial Converter driver v0.3a
[   30.139224] initcall 0x78a3ed10: klsi_105_init+0x0/0x70() returned 0.
[   30.145628] initcall 0x78a3ed10 ran for 7 msecs: klsi_105_init+0x0/0x70()
[   30.152388] Calling initcall 0x78a3ed80: moschip7720_init+0x0/0x90()
[   30.158729] drivers/usb/serial/usb-serial.c: USB Serial support registered for Moschip 2 port adapter
[   30.167906] drivers/usb/serial/mos7720.c: Moschip USB Serial Driver 1.0.0.4F
[   30.174938] usbcore: registered new interface driver moschip7720
[   30.180909] initcall 0x78a3ed80: moschip7720_init+0x0/0x90() returned 0.
[   30.187575] initcall 0x78a3ed80 ran for 11 msecs: moschip7720_init+0x0/0x90()
[   30.194680] Calling initcall 0x78a3ee10: moschip7840_init+0x0/0xf0()
[   30.201019] drivers/usb/serial/usb-serial.c: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[   30.211324] drivers/usb/serial/mos7840.c: Moschip 7840/7820 USB Serial Driver 1.3.1
[   30.218962] usbcore: registered new interface driver mos7840
[   30.224587] initcall 0x78a3ee10: moschip7840_init+0x0/0xf0() returned 0.
[   30.231246] initcall 0x78a3ee10 ran for 9 msecs: moschip7840_init+0x0/0xf0()
[   30.238274] Calling initcall 0x78a3ef00: omninet_init+0x0/0x70()
[   30.244263] drivers/usb/serial/usb-serial.c: USB Serial support registered for ZyXEL - omni.net lcd plus usb
[   30.254061] usbcore: registered new interface driver omninet
[   30.259682] drivers/usb/serial/omninet.c: v1.1:USB ZyXEL omni.net LCD PLUS Driver
[   30.267137] initcall 0x78a3ef00: omninet_init+0x0/0x70() returned 0.
[   30.273457] initcall 0x78a3ef00 ran for 9 msecs: omninet_init+0x0/0x70()
[   30.280131] Calling initcall 0x78a3ef70: sierra_init+0x0/0x80()
[   30.286033] drivers/usb/serial/usb-serial.c: USB Serial support registered for Sierra USB modem (1 port)
[   30.295485] drivers/usb/serial/usb-serial.c: USB Serial support registered for Sierra USB modem (3 port)
[   30.304930] usbcore: registered new interface driver sierra
[   30.310464] drivers/usb/serial/sierra.c: USB Driver for Sierra Wireless USB modems: v.1.2.5b
[   30.318873] initcall 0x78a3ef70: sierra_init+0x0/0x80() returned 0.
[   30.325103] initcall 0x78a3ef70 ran for 11 msecs: sierra_init+0x0/0x80()
[   30.331782] Calling initcall 0x78a3eff0: whiteheat_init+0x0/0x80()
[   30.337943] drivers/usb/serial/usb-serial.c: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[   30.349040] drivers/usb/serial/usb-serial.c: USB Serial support registered for Connect Tech - WhiteHEAT
[   30.358401] usbcore: registered new interface driver whiteheat
[   30.364195] drivers/usb/serial/whiteheat.c: USB ConnectTech WhiteHEAT driver v2.0
[   30.372204] initcall 0x78a3eff0: whiteheat_init+0x0/0x80() returned 0.
[   30.378694] initcall 0x78a3eff0 ran for 10 msecs: whiteheat_init+0x0/0x80()
[   30.385628] Calling initcall 0x78a3f070: appledisplay_init+0x0/0x50()
[   30.392089] usbcore: registered new interface driver appledisplay
[   30.398117] initcall 0x78a3f070: appledisplay_init+0x0/0x50() returned 0.
[   30.404866] initcall 0x78a3f070 ran for 5 msecs: appledisplay_init+0x0/0x50()
[   30.411978] Calling initcall 0x78a3f0c0: auerswald_init+0x0/0x40()
[   30.418136] usbcore: registered new interface driver auerswald
[   30.423941] initcall 0x78a3f0c0: auerswald_init+0x0/0x40() returned 0.
[   30.430435] initcall 0x78a3f0c0 ran for 2 msecs: auerswald_init+0x0/0x40()
[   30.437280] Calling initcall 0x78a3f100: berry_init+0x0/0x20()
[   30.443096] usbcore: registered new interface driver berry_charge
[   30.449159] initcall 0x78a3f100: berry_init+0x0/0x20() returned 0.
[   30.455303] initcall 0x78a3f100 ran for 2 msecs: berry_init+0x0/0x20()
[   30.461803] Calling initcall 0x78a3f120: emi26_init+0x0/0x20()
[   30.467618] usbcore: registered new interface driver emi26 - firmware loader
[   30.474638] initcall 0x78a3f120: emi26_init+0x0/0x20() returned 0.
[   30.480785] initcall 0x78a3f120 ran for 3 msecs: emi26_init+0x0/0x20()
[   30.487285] Calling initcall 0x78a3f140: usb_idmouse_init+0x0/0x50()
[   30.493609] drivers/usb/misc/idmouse.c: Siemens ID Mouse FingerTIP Sensor Driver 0.6
[   30.501333] usbcore: registered new interface driver idmouse
[   30.506963] initcall 0x78a3f140: usb_idmouse_init+0x0/0x50() returned 0.
[   30.513629] initcall 0x78a3f140 ran for 6 msecs: usb_idmouse_init+0x0/0x50()
[   30.520649] Calling initcall 0x78a3f190: ld_usb_init+0x0/0x40()
[   30.526546] usbcore: registered new interface driver ldusb
[   30.532008] initcall 0x78a3f190: ld_usb_init+0x0/0x40() returned 0.
[   30.538237] initcall 0x78a3f190 ran for 2 msecs: ld_usb_init+0x0/0x40()
[   30.544829] Calling initcall 0x78a3f1d0: usb_led_init+0x0/0x40()
[   30.550811] usbcore: registered new interface driver usbled
[   30.556359] initcall 0x78a3f1d0: usb_led_init+0x0/0x40() returned 0.
[   30.562674] initcall 0x78a3f1d0 ran for 2 msecs: usb_led_init+0x0/0x40()
[   30.569349] Calling initcall 0x78a3f210: lego_usb_tower_init+0x0/0xa0()
[   30.575944] usbcore: registered new interface driver legousbtower
[   30.582007] drivers/usb/misc/legousbtower.c: LEGO USB Tower Driver v0.96
[   30.588685] initcall 0x78a3f210: lego_usb_tower_init+0x0/0xa0() returned 0.
[   30.595608] initcall 0x78a3f210 ran for 5 msecs: lego_usb_tower_init+0x0/0xa0()
[   30.602887] Calling initcall 0x78a3f2b0: init_phidget+0x0/0x20()
[   30.608877] initcall 0x78a3f2b0: init_phidget+0x0/0x20() returned 0.
[   30.615193] initcall 0x78a3f2b0 ran for 0 msecs: init_phidget+0x0/0x20()
[   30.621866] Calling initcall 0x78a3f2d0: tv_init+0x0/0x60()
[   30.627428] usbcore: registered new interface driver trancevibrator
[   30.633659] drivers/usb/misc/trancevibrator.c: v1.1:PlayStation 2 Trance Vibrator driver
[   30.641720] initcall 0x78a3f2d0: tv_init+0x0/0x60() returned 0.
[   30.647602] initcall 0x78a3f2d0 ran for 4 msecs: tv_init+0x0/0x60()
[   30.653846] Calling initcall 0x78a3f330: usb_sisusb_init+0x0/0x20()
[   30.660097] usbcore: registered new interface driver sisusb
[   30.665640] initcall 0x78a3f330: usb_sisusb_init+0x0/0x20() returned 0.
[   30.672216] initcall 0x78a3f330 ran for 2 msecs: usb_sisusb_init+0x0/0x20()
[   30.679149] Calling initcall 0x78a3fc30: i8042_init+0x0/0xe0()
[   30.687754] serio: i8042 KBD port at 0x60,0x64 irq 1
[   30.692614] serio: i8042 AUX port at 0x60,0x64 irq 12
[   30.697630] initcall 0x78a3fc30: i8042_init+0x0/0xe0() returned 0.
[   30.703773] initcall 0x78a3fc30 ran for 12 msecs: i8042_init+0x0/0xe0()
[   30.710359] Calling initcall 0x78a3fd10: pcips2_init+0x0/0x20()
[   30.716278] initcall 0x78a3fd10: pcips2_init+0x0/0x20() returned 0.
[   30.722488] initcall 0x78a3fd10 ran for 0 msecs: pcips2_init+0x0/0x20()
[   30.729074] Calling initcall 0x78a3fe50: serio_raw_init+0x0/0x20()
[   30.735248] initcall 0x78a3fe50: serio_raw_init+0x0/0x20() returned 0.
[   30.741727] initcall 0x78a3fe50 ran for 0 msecs: serio_raw_init+0x0/0x20()
[   30.748579] Calling initcall 0x78a40080: fm801_gp_init+0x0/0x20()
[   30.754666] initcall 0x78a40080: fm801_gp_init+0x0/0x20() returned 0.
[   30.761050] initcall 0x78a40080 ran for 0 msecs: fm801_gp_init+0x0/0x20()
[   30.767815] Calling initcall 0x78a400a0: l4_init+0x0/0x2b0()
[   30.773460] initcall 0x78a400a0: l4_init+0x0/0x2b0() returned -19.
[   30.779595] initcall 0x78a400a0 ran for 0 msecs: l4_init+0x0/0x2b0()
[   30.785925] Calling initcall 0x78a40350: ns558_init+0x0/0x390()
[   30.800567] initcall 0x78a40350: ns558_init+0x0/0x390() returned -19.
[   30.806848] initcall 0x78a40350 ran for 11 msecs: ns558_init+0x0/0x390()
[   30.813520] Calling initcall 0x78a407e0: mousedev_init+0x0/0x90()
[   30.819648] mice: PS/2 mouse device common for all mice
[   30.824793] initcall 0x78a407e0: mousedev_init+0x0/0x90() returned 0.
[   30.831193] initcall 0x78a407e0 ran for 4 msecs: mousedev_init+0x0/0x90()
[   30.837959] Calling initcall 0x78a40870: evdev_init+0x0/0x10()
[   30.843767] initcall 0x78a40870: evdev_init+0x0/0x10() returned 0.
[   30.849918] initcall 0x78a40870 ran for 0 msecs: evdev_init+0x0/0x10()
[   30.856420] Calling initcall 0x78a40880: evbug_init+0x0/0x10()
[   30.862226] initcall 0x78a40880: evbug_init+0x0/0x10() returned 0.
[   30.868374] initcall 0x78a40880 ran for 0 msecs: evbug_init+0x0/0x10()
[   30.874879] Calling initcall 0x78a40890: atkbd_init+0x0/0x20()
[   30.880702] initcall 0x78a40890: atkbd_init+0x0/0x20() returned 0.
[   30.886836] initcall 0x78a40890 ran for 0 msecs: atkbd_init+0x0/0x20()
[   30.893338] Calling initcall 0x78a408b0: sunkbd_init+0x0/0x20()
[   30.899247] initcall 0x78a408b0: sunkbd_init+0x0/0x20() returned 0.
[   30.905465] initcall 0x78a408b0 ran for 0 msecs: sunkbd_init+0x0/0x20()
[   30.912051] Calling initcall 0x78a408d0: xtkbd_init+0x0/0x20()
[   30.917878] initcall 0x78a408d0: xtkbd_init+0x0/0x20() returned 0.
[   30.924014] initcall 0x78a408d0 ran for 0 msecs: xtkbd_init+0x0/0x20()
[   30.930514] Calling initcall 0x78a408f0: a3d_init+0x0/0x10()
[   30.936160] initcall 0x78a408f0: a3d_init+0x0/0x10() returned 0.
[   30.942123] initcall 0x78a408f0 ran for 0 msecs: a3d_init+0x0/0x10()
[   30.948449] Calling initcall 0x78a40900: adi_init+0x0/0x10()
[   30.954088] initcall 0x78a40900: adi_init+0x0/0x10() returned 0.
[   30.960064] initcall 0x78a40900 ran for 0 msecs: adi_init+0x0/0x10()
[   30.966393] Calling initcall 0x78a40910: analog_init+0x0/0x100()
[   30.972374] initcall 0x78a40910: analog_init+0x0/0x100() returned 0.
[   30.978694] initcall 0x78a40910 ran for 0 msecs: analog_init+0x0/0x100()
[   30.985366] Calling initcall 0x78a40a10: cobra_init+0x0/0x10()
[   30.991179] initcall 0x78a40a10: cobra_init+0x0/0x10() returned 0.
[   30.997329] initcall 0x78a40a10 ran for 0 msecs: cobra_init+0x0/0x10()
[   31.003828] Calling initcall 0x78a40a20: grip_init+0x0/0x10()
[   31.009551] initcall 0x78a40a20: grip_init+0x0/0x10() returned 0.
[   31.015611] initcall 0x78a40a20 ran for 0 msecs: grip_init+0x0/0x10()
[   31.022024] Calling initcall 0x78a40a30: grip_init+0x0/0x10()
[   31.027750] initcall 0x78a40a30: grip_init+0x0/0x10() returned 0.
[   31.033813] initcall 0x78a40a30 ran for 0 msecs: grip_init+0x0/0x10()
[   31.040226] Calling initcall 0x78a40a40: guillemot_init+0x0/0x10()
[   31.046387] initcall 0x78a40a40: guillemot_init+0x0/0x10() returned 0.
[   31.052873] initcall 0x78a40a40 ran for 0 msecs: guillemot_init+0x0/0x10()
[   31.059727] Calling initcall 0x78a40a50: interact_init+0x0/0x10()
[   31.065794] initcall 0x78a40a50: interact_init+0x0/0x10() returned 0.
[   31.072201] initcall 0x78a40a50 ran for 0 msecs: interact_init+0x0/0x10()
[   31.078960] Calling initcall 0x78a40a60: joydump_init+0x0/0x10()
[   31.084947] initcall 0x78a40a60: joydump_init+0x0/0x10() returned 0.
[   31.091263] initcall 0x78a40a60 ran for 0 msecs: joydump_init+0x0/0x10()
[   31.097943] Calling initcall 0x78a40a70: magellan_init+0x0/0x20()
[   31.104026] initcall 0x78a40a70: magellan_init+0x0/0x20() returned 0.
[   31.110422] initcall 0x78a40a70 ran for 0 msecs: magellan_init+0x0/0x20()
[   31.117181] Calling initcall 0x78a40a90: sw_init+0x0/0x10()
[   31.122731] initcall 0x78a40a90: sw_init+0x0/0x10() returned 0.
[   31.128618] initcall 0x78a40a90 ran for 0 msecs: sw_init+0x0/0x10()
[   31.134856] Calling initcall 0x78a40aa0: stinger_init+0x0/0x20()
[   31.140857] initcall 0x78a40aa0: stinger_init+0x0/0x20() returned 0.
[   31.147166] initcall 0x78a40aa0 ran for 0 msecs: stinger_init+0x0/0x20()
[   31.153838] Calling initcall 0x78a40ac0: tmdc_init+0x0/0x10()
[   31.159562] initcall 0x78a40ac0: tmdc_init+0x0/0x10() returned 0.
[   31.165621] initcall 0x78a40ac0 ran for 0 msecs: tmdc_init+0x0/0x10()
[   31.172034] Calling initcall 0x78a40ad0: usb_xpad_init+0x0/0x40()
[   31.178117] usbcore: registered new interface driver xpad
[   31.183481] drivers/input/joystick/xpad.c: X-Box pad driver:v0.0.6
[   31.189636] initcall 0x78a40ad0: usb_xpad_init+0x0/0x40() returned 0.
[   31.196037] initcall 0x78a40ad0 ran for 4 msecs: usb_xpad_init+0x0/0x40()
[   31.202799] Calling initcall 0x78a40b10: iforce_init+0x0/0x20()
[   31.208714] initcall 0x78a40b10: iforce_init+0x0/0x20() returned 0.
[   31.214932] initcall 0x78a40b10 ran for 0 msecs: iforce_init+0x0/0x20()
[   31.221524] Calling initcall 0x78a40c30: i2c_dev_init+0x0/0x90()
[   31.227499] i2c /dev entries driver
[   31.231016] initcall 0x78a40c30: i2c_dev_init+0x0/0x90() returned 0.
[   31.237294] initcall 0x78a40c30 ran for 3 msecs: i2c_dev_init+0x0/0x90()
[   31.243966] Calling initcall 0x78a40ee0: ali1563_init+0x0/0x20()
[   31.249971] initcall 0x78a40ee0: ali1563_init+0x0/0x20() returned 0.
[   31.256272] initcall 0x78a40ee0 ran for 0 msecs: ali1563_init+0x0/0x20()
[   31.262948] Calling initcall 0x78a410b0: i2c_amd8111_init+0x0/0x20()
[   31.269295] initcall 0x78a410b0: i2c_amd8111_init+0x0/0x20() returned 0.
[   31.275939] initcall 0x78a410b0 ran for 0 msecs: i2c_amd8111_init+0x0/0x20()
[   31.282966] Calling initcall 0x78a411a0: i2c_i810_init+0x0/0x20()
[   31.289054] initcall 0x78a411a0: i2c_i810_init+0x0/0x20() returned 0.
[   31.295440] initcall 0x78a411a0 ran for 0 msecs: i2c_i810_init+0x0/0x20()
[   31.302200] Calling initcall 0x78a411c0: i2c_parport_init+0x0/0x190()
[   31.308614] i2c-parport-light: adapter type unspecified
[   31.313822] initcall 0x78a411c0: i2c_parport_init+0x0/0x190() returned -19.
[   31.320748] initcall 0x78a411c0 ran for 4 msecs: i2c_parport_init+0x0/0x190()
[   31.327854] Calling initcall 0x78a418c0: i2c_piix4_init+0x0/0x20()
[   31.334032] initcall 0x78a418c0: i2c_piix4_init+0x0/0x20() returned 0.
[   31.340507] initcall 0x78a418c0 ran for 0 msecs: i2c_piix4_init+0x0/0x20()
[   31.347353] Calling initcall 0x78a41a90: i2c_prosavage_init+0x0/0x20()
[   31.353876] initcall 0x78a41a90: i2c_prosavage_init+0x0/0x20() returned 0.
[   31.360699] initcall 0x78a41a90 ran for 0 msecs: i2c_prosavage_init+0x0/0x20()
[   31.367892] Calling initcall 0x78a41b50: i2c_savage4_init+0x0/0x20()
[   31.374242] initcall 0x78a41b50: i2c_savage4_init+0x0/0x20() returned 0.
[   31.380885] initcall 0x78a41b50 ran for 0 msecs: i2c_savage4_init+0x0/0x20()
[   31.387910] Calling initcall 0x78a41f30: i2c_sis5595_init+0x0/0x20()
[   31.394260] initcall 0x78a41f30: i2c_sis5595_init+0x0/0x20() returned 0.
[   31.400904] initcall 0x78a41f30 ran for 0 msecs: i2c_sis5595_init+0x0/0x20()
[   31.407929] Calling initcall 0x78a42190: i2c_sis630_init+0x0/0x20()
[   31.414193] initcall 0x78a42190: i2c_sis630_init+0x0/0x20() returned 0.
[   31.420755] initcall 0x78a42190 ran for 0 msecs: i2c_sis630_init+0x0/0x20()
[   31.427689] Calling initcall 0x78a421b0: usb_i2c_tiny_usb_init+0x0/0x20()
[   31.434460] usbcore: registered new interface driver i2c-tiny-usb
[   31.440521] initcall 0x78a421b0: usb_i2c_tiny_usb_init+0x0/0x20() returned 0.
[   31.447615] initcall 0x78a421b0 ran for 2 msecs: usb_i2c_tiny_usb_init+0x0/0x20()
[   31.455075] Calling initcall 0x78a421d0: i2c_vt596_init+0x0/0x20()
[   31.461251] initcall 0x78a421d0: i2c_vt596_init+0x0/0x20() returned 0.
[   31.467720] initcall 0x78a421d0 ran for 0 msecs: i2c_vt596_init+0x0/0x20()
[   31.474572] Calling initcall 0x78a426a0: i2c_voodoo3_init+0x0/0x20()
[   31.481444] initcall 0x78a426a0: i2c_voodoo3_init+0x0/0x20() returned 0.
[   31.488088] initcall 0x78a426a0 ran for 0 msecs: i2c_voodoo3_init+0x0/0x20()
[   31.495113] Calling initcall 0x78a42870: scx200_acb_init+0x0/0x220()
[   31.501437] scx200_acb: NatSemi SCx200 ACCESS.bus Driver
[   31.506732] initcall 0x78a42870: scx200_acb_init+0x0/0x220() returned -19.
[   31.513570] initcall 0x78a42870 ran for 2 msecs: scx200_acb_init+0x0/0x220()
[   31.520589] Calling initcall 0x78a42a90: ds1682_init+0x0/0x10()
[   31.526499] initcall 0x78a42a90: ds1682_init+0x0/0x10() returned 0.
[   31.532716] initcall 0x78a42a90 ran for 0 msecs: ds1682_init+0x0/0x10()
[   31.539305] Calling initcall 0x78a42aa0: pcf8591_init+0x0/0x40()
[   31.545303] initcall 0x78a42aa0: pcf8591_init+0x0/0x40() returned 0.
[   31.551611] initcall 0x78a42aa0 ran for 0 msecs: pcf8591_init+0x0/0x40()
[   31.558288] Calling initcall 0x78a42cc0: tsl2550_init+0x0/0x10()
[   31.564282] initcall 0x78a42cc0: tsl2550_init+0x0/0x10() returned 0.
[   31.570592] initcall 0x78a42cc0 ran for 0 msecs: tsl2550_init+0x0/0x10()
[   31.577265] Calling initcall 0x785c7880: w1_init+0x0/0x120()
[   31.582902] Driver for 1-wire Dallas network protocol.
[   31.588428] initcall 0x785c7880: w1_init+0x0/0x120() returned 0.
[   31.594272] initcall 0x785c7880 ran for 2 msecs: w1_init+0x0/0x120()
[   31.600603] Calling initcall 0x78a42f00: matrox_w1_init+0x0/0x20()
[   31.606775] initcall 0x78a42f00: matrox_w1_init+0x0/0x20() returned 0.
[   31.613256] initcall 0x78a42f00 ran for 0 msecs: matrox_w1_init+0x0/0x20()
[   31.620105] Calling initcall 0x785c8ef0: ds_init+0x0/0x40()
[   31.625654] usbcore: registered new interface driver DS9490R
[   31.631287] initcall 0x785c8ef0: ds_init+0x0/0x40() returned 0.
[   31.637174] initcall 0x785c8ef0 ran for 4 msecs: ds_init+0x0/0x40()
[   31.643413] Calling initcall 0x78a42f20: w1_ds2760_init+0x0/0x30()
[   31.649571] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[   31.658343] initcall 0x78a42f20: w1_ds2760_init+0x0/0x30() returned 0.
[   31.664816] initcall 0x78a42f20 ran for 2 msecs: w1_ds2760_init+0x0/0x30()
[   31.671667] Calling initcall 0x78a42f90: asb100_init+0x0/0x10()
[   31.677568] initcall 0x78a42f90: asb100_init+0x0/0x10() returned 0.
[   31.683798] initcall 0x78a42f90 ran for 0 msecs: asb100_init+0x0/0x10()
[   31.690384] Calling initcall 0x78a42fa0: sensors_w83792d_init+0x0/0x10()
[   31.697065] initcall 0x78a42fa0: sensors_w83792d_init+0x0/0x10() returned 0.
[   31.704071] initcall 0x78a42fa0 ran for 0 msecs: sensors_w83792d_init+0x0/0x10()
[   31.711446] Calling initcall 0x78a43170: sensors_w83781d_init+0x0/0x420()
[   31.718221] w83781d: Detection failed at step 3
[   31.722716] initcall 0x78a43170: sensors_w83781d_init+0x0/0x420() returned 0.
[   31.729815] initcall 0x78a43170 ran for 4 msecs: sensors_w83781d_init+0x0/0x420()
[   31.737270] Calling initcall 0x78a43590: ad7418_init+0x0/0x10()
[   31.743168] initcall 0x78a43590: ad7418_init+0x0/0x10() returned 0.
[   31.749395] initcall 0x78a43590 ran for 0 msecs: ad7418_init+0x0/0x10()
[   31.755984] Calling initcall 0x78a435a0: sensors_adm1021_init+0x0/0x10()
[   31.762668] initcall 0x78a435a0: sensors_adm1021_init+0x0/0x10() returned 0.
[   31.769680] initcall 0x78a435a0 ran for 0 msecs: sensors_adm1021_init+0x0/0x10()
[   31.777048] Calling initcall 0x78a435b0: sensors_adm1031_init+0x0/0x10()
[   31.783727] initcall 0x78a435b0: sensors_adm1031_init+0x0/0x10() returned 0.
[   31.790732] initcall 0x78a435b0 ran for 0 msecs: sensors_adm1031_init+0x0/0x10()
[   31.798106] Calling initcall 0x78a435c0: applesmc_init+0x0/0x520()
[   31.804256] applesmc: supported laptop not found!
[   31.808940] applesmc: driver init failed (ret=-19)!
[   31.813796] initcall 0x78a435c0: applesmc_init+0x0/0x520() returned -19.
[   31.820463] initcall 0x78a435c0 ran for 5 msecs: applesmc_init+0x0/0x520()
[   31.827308] Calling initcall 0x78a43c30: f71805f_init+0x0/0x170()
[   31.833402] initcall 0x78a43c30: f71805f_init+0x0/0x170() returned -19.
[   31.839961] initcall 0x78a43c30 ran for 0 msecs: f71805f_init+0x0/0x170()
[   31.846724] Calling initcall 0x78a441c0: sensors_f75375_init+0x0/0x10()
[   31.853317] initcall 0x78a441c0: sensors_f75375_init+0x0/0x10() returned 0.
[   31.860240] initcall 0x78a441c0 ran for 0 msecs: sensors_f75375_init+0x0/0x10()
[   31.867519] Calling initcall 0x78a441d0: sensors_fscher_init+0x0/0x10()
[   31.874114] initcall 0x78a441d0: sensors_fscher_init+0x0/0x10() returned 0.
[   31.881033] initcall 0x78a441d0 ran for 0 msecs: sensors_fscher_init+0x0/0x10()
[   31.888321] Calling initcall 0x78a441e0: sensors_gl518sm_init+0x0/0x10()
[   31.895000] initcall 0x78a441e0: sensors_gl518sm_init+0x0/0x10() returned 0.
[   31.902008] initcall 0x78a441e0 ran for 0 msecs: sensors_gl518sm_init+0x0/0x10()
[   31.909373] Calling initcall 0x78a441f0: sensors_gl520sm_init+0x0/0x10()
[   31.916058] initcall 0x78a441f0: sensors_gl520sm_init+0x0/0x10() returned 0.
[   31.923069] initcall 0x78a441f0 ran for 0 msecs: sensors_gl520sm_init+0x0/0x10()
[   31.930438] Calling initcall 0x78a44250: hdaps_init+0x0/0x1f0()
[   31.936331] hdaps: supported laptop not found!
[   31.940751] hdaps: driver init failed (ret=-19)!
[   31.945348] initcall 0x78a44250: hdaps_init+0x0/0x1f0() returned -19.
[   31.951752] initcall 0x78a44250 ran for 5 msecs: hdaps_init+0x0/0x1f0()
[   31.958338] Calling initcall 0x78a44440: init_lm70+0x0/0x10()
[   31.964077] initcall 0x78a44440: init_lm70+0x0/0x10() returned 0.
[   31.970126] initcall 0x78a44440 ran for 0 msecs: init_lm70+0x0/0x10()
[   31.976540] Calling initcall 0x78a44570: sensors_lm77_init+0x0/0x10()
[   31.982972] initcall 0x78a44570: sensors_lm77_init+0x0/0x10() returned 0.
[   31.989711] initcall 0x78a44570 ran for 0 msecs: sensors_lm77_init+0x0/0x10()
[   31.996820] Calling initcall 0x78a44580: sensors_lm80_init+0x0/0x10()
[   32.003246] initcall 0x78a44580: sensors_lm80_init+0x0/0x10() returned 0.
[   32.009991] initcall 0x78a44580 ran for 0 msecs: sensors_lm80_init+0x0/0x10()
[   32.017100] Calling initcall 0x78a44590: sm_lm85_init+0x0/0x10()
[   32.023091] initcall 0x78a44590: sm_lm85_init+0x0/0x10() returned 0.
[   32.029397] initcall 0x78a44590 ran for 0 msecs: sm_lm85_init+0x0/0x10()
[   32.036072] Calling initcall 0x78a445a0: sensors_lm87_init+0x0/0x10()
[   32.042503] initcall 0x78a445a0: sensors_lm87_init+0x0/0x10() returned 0.
[   32.049243] initcall 0x78a445a0 ran for 0 msecs: sensors_lm87_init+0x0/0x10()
[   32.056356] Calling initcall 0x78a445b0: lm93_init+0x0/0x10()
[   32.062090] initcall 0x78a445b0: lm93_init+0x0/0x10() returned 0.
[   32.068138] initcall 0x78a445b0 ran for 0 msecs: lm93_init+0x0/0x10()
[   32.074554] Calling initcall 0x78a445c0: sensors_max1619_init+0x0/0x10()
[   32.081244] initcall 0x78a445c0: sensors_max1619_init+0x0/0x10() returned 0.
[   32.088242] initcall 0x78a445c0 ran for 0 msecs: sensors_max1619_init+0x0/0x10()
[   32.095614] Calling initcall 0x78a445d0: sensors_max6650_init+0x0/0x10()
[   32.102300] initcall 0x78a445d0: sensors_max6650_init+0x0/0x10() returned 0.
[   32.109298] initcall 0x78a445d0 ran for 0 msecs: sensors_max6650_init+0x0/0x10()
[   32.116673] Calling initcall 0x78a454b0: pc87360_init+0x0/0x1a0()
[   32.122748] pc87360: PC8736x not detected, module not inserted.
[   32.128639] initcall 0x78a454b0: pc87360_init+0x0/0x1a0() returned -19.
[   32.135213] initcall 0x78a454b0 ran for 1 msecs: pc87360_init+0x0/0x1a0()
[   32.141973] Calling initcall 0x78a45770: pc87427_init+0x0/0x140()
[   32.148060] initcall 0x78a45770: pc87427_init+0x0/0x140() returned -19.
[   32.154625] initcall 0x78a45770 ran for 0 msecs: pc87427_init+0x0/0x140()
[   32.161390] Calling initcall 0x78a45ba0: sm_sis5595_init+0x0/0x20()
[   32.167652] initcall 0x78a45ba0: sm_sis5595_init+0x0/0x20() returned 0.
[   32.174208] initcall 0x78a45ba0 ran for 0 msecs: sm_sis5595_init+0x0/0x20()
[   32.181147] Calling initcall 0x78a462c0: vt1211_init+0x0/0x180()
[   32.187146] initcall 0x78a462c0: vt1211_init+0x0/0x180() returned -19.
[   32.193626] initcall 0x78a462c0 ran for 0 msecs: vt1211_init+0x0/0x180()
[   32.200298] Calling initcall 0x78a46800: sm_vt8231_init+0x0/0x20()
[   32.206476] initcall 0x78a46800: sm_vt8231_init+0x0/0x20() returned 0.
[   32.212952] initcall 0x78a46800 ran for 0 msecs: sm_vt8231_init+0x0/0x20()
[   32.219800] Calling initcall 0x78a46c00: sensors_w83627ehf_init+0x0/0x180()
[   32.226761] initcall 0x78a46c00: sensors_w83627ehf_init+0x0/0x180() returned -19.
[   32.234178] initcall 0x78a46c00 ran for 0 msecs: sensors_w83627ehf_init+0x0/0x180()
[   32.241812] Calling initcall 0x78a47720: wdtpci_init+0x0/0x20()
[   32.247727] initcall 0x78a47720: wdtpci_init+0x0/0x20() returned 0.
[   32.253942] initcall 0x78a47720 ran for 0 msecs: wdtpci_init+0x0/0x20()
[   32.260528] Calling initcall 0x78a47890: acq_init+0x0/0x70()
[   32.266165] WDT driver for Acquire single board computer initialising.
[   32.272703] acquirewdt: I/O address 0x0043 already in use
[   32.278042] acquirewdt: probe of acquirewdt failed with error -5
[   32.284021] initcall 0x78a47890: acq_init+0x0/0x70() returned 0.
[   32.289993] initcall 0x78a47890 ran for 10 msecs: acq_init+0x0/0x70()
[   32.296407] Calling initcall 0x78a47a90: advwdt_init+0x0/0x70()
[   32.302297] WDT driver for Advantech single board computer initialising.
[   32.309031] advantechwdt: initialized. timeout=60 sec (nowayout=0)
[   32.315134] initcall 0x78a47a90: advwdt_init+0x0/0x70() returned 0.
[   32.321362] initcall 0x78a47a90 ran for 4 msecs: advwdt_init+0x0/0x70()
[   32.327952] Calling initcall 0x78a47b00: watchdog_init+0x0/0x1a0()
[   32.334107] initcall 0x78a47b00: watchdog_init+0x0/0x1a0() returned -19.
[   32.340776] initcall 0x78a47b00 ran for 0 msecs: watchdog_init+0x0/0x1a0()
[   32.347622] Calling initcall 0x78a47ca0: alim7101_wdt_init+0x0/0x200()
[   32.354121] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[   32.359586] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   32.365654] initcall 0x78a47ca0: alim7101_wdt_init+0x0/0x200() returned -16.
[   32.372662] initcall 0x78a47ca0 ran for 4 msecs: alim7101_wdt_init+0x0/0x200()
[   32.379864] initcall at 0x78a47ca0: alim7101_wdt_init+0x0/0x200(): returned with error code -16
[   32.388529] Calling initcall 0x78a47ea0: sc520_wdt_init+0x0/0x110()
[   32.394769] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[   32.401191] initcall 0x78a47ea0: sc520_wdt_init+0x0/0x110() returned -16.
[   32.407936] initcall 0x78a47ea0 ran for 6 msecs: sc520_wdt_init+0x0/0x110()
[   32.414874] initcall at 0x78a47ea0: sc520_wdt_init+0x0/0x110(): returned with error code -16
[   32.423279] Calling initcall 0x78a47fb0: watchdog_init+0x0/0x2e0()
[   32.429444] initcall 0x78a47fb0: watchdog_init+0x0/0x2e0() returned -19.
[   32.436104] initcall 0x78a47fb0 ran for 0 msecs: watchdog_init+0x0/0x2e0()
[   32.442953] Calling initcall 0x78a48290: iTCO_wdt_init_module+0x0/0x80()
[   32.449622] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[   32.456429] iTCO_wdt: No card detected
[   32.460122] initcall 0x78a48290: iTCO_wdt_init_module+0x0/0x80() returned 0.
[   32.467129] initcall 0x78a48290 ran for 6 msecs: iTCO_wdt_init_module+0x0/0x80()
[   32.474495] Calling initcall 0x78a48310: iTCO_vendor_init_module+0x0/0x20()
[   32.481426] iTCO_vendor_support: vendor-support=0
[   32.486114] initcall 0x78a48310: iTCO_vendor_init_module+0x0/0x20() returned 0.
[   32.493387] initcall 0x78a48310 ran for 4 msecs: iTCO_vendor_init_module+0x0/0x20()
[   32.501013] Calling initcall 0x78a48330: cpu5wdt_init_module+0x0/0x150()
[   32.507685] cpu5wdt: misc_register failed
[   32.511679] initcall 0x78a48330: cpu5wdt_init_module+0x0/0x150() returned -16.
[   32.519413] initcall 0x78a48330 ran for 0 msecs: cpu5wdt_init_module+0x0/0x150()
[   32.526780] initcall at 0x78a48330: cpu5wdt_init_module+0x0/0x150(): returned with error code -16
[   32.535614] Calling initcall 0x78a48480: wb_smsc_wdt_init+0x0/0x200()
[   32.542028] SMsC 37B787 watchdog component driver 1.1 initialising...
[   32.549482] smsc37b787_wdt: Unable to register miscdev on minor 130
[   32.555625] initcall 0x78a48480: wb_smsc_wdt_init+0x0/0x200() returned -16.
[   32.562548] initcall 0x78a48480 ran for 9 msecs: wb_smsc_wdt_init+0x0/0x200()
[   32.569661] initcall at 0x78a48480: wb_smsc_wdt_init+0x0/0x200(): returned with error code -16
[   32.578239] Calling initcall 0x78a48680: w83977f_wdt_init+0x0/0x160()
[   32.584651] W83977F WDT: W83977F WDT driver, v1.00
[   32.589420] W83977F WDT: cannot register miscdev on minor=130 (err=-16)
[   32.596009] initcall 0x78a48680: w83977f_wdt_init+0x0/0x160() returned -16.
[   32.602936] initcall 0x78a48680 ran for 4 msecs: w83977f_wdt_init+0x0/0x160()
[   32.610045] initcall at 0x78a48680: w83977f_wdt_init+0x0/0x160(): returned with error code -16
[   32.618624] Calling initcall 0x78a487e0: zf_init+0x0/0x1c0()
[   32.624252] machzwd: MachZ ZF-Logic Watchdog driver initializing.
[   32.630324] machzwd: no ZF-Logic found
[   32.634053] initcall 0x78a487e0: zf_init+0x0/0x1c0() returned -19.
[   32.640200] initcall 0x78a487e0 ran for 6 msecs: zf_init+0x0/0x1c0()
[   32.646526] Calling initcall 0x78a489a0: watchdog_init+0x0/0xd0()
[   32.652592] epx_c3: cannot register miscdev on minor=130 (err=-16)
[   32.658751] initcall 0x78a489a0: watchdog_init+0x0/0xd0() returned -16.
[   32.665328] initcall 0x78a489a0 ran for 1 msecs: watchdog_init+0x0/0xd0()
[   32.672088] initcall at 0x78a489a0: watchdog_init+0x0/0xd0(): returned with error code -16
[   32.680325] Calling initcall 0x78a48a70: watchdog_init+0x0/0xe0()
[   32.686389] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   32.692636] initcall 0x78a48a70: watchdog_init+0x0/0xe0() returned -16.
[   32.699210] initcall 0x78a48a70 ran for 2 msecs: watchdog_init+0x0/0xe0()
[   32.705973] initcall at 0x78a48a70: watchdog_init+0x0/0xe0(): returned with error code -16
[   32.714208] Calling initcall 0x78a48b50: telephony_init+0x0/0x50()
[   32.720360] Linux telephony interface: v1.00
[   32.724625] initcall 0x78a48b50: telephony_init+0x0/0x50() returned 0.
[   32.731102] initcall 0x78a48b50 ran for 0 msecs: telephony_init+0x0/0x50()
[   32.737955] Calling initcall 0x78a48ba0: dm_init+0x0/0x70()
[   32.743531] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   32.751913] initcall 0x78a48ba0: dm_init+0x0/0x70() returned 0.
[   32.757794] initcall 0x78a48ba0 ran for 1 msecs: dm_init+0x0/0x70()
[   32.764039] Calling initcall 0x78a48dd0: dm_crypt_init+0x0/0xa0()
[   32.770152] initcall 0x78a48dd0: dm_crypt_init+0x0/0xa0() returned 0.
[   32.776518] initcall 0x78a48dd0 ran for 0 msecs: dm_crypt_init+0x0/0xa0()
[   32.783279] Calling initcall 0x78a48e70: dm_delay_init+0x0/0xc0()
[   32.789384] initcall 0x78a48e70: dm_delay_init+0x0/0xc0() returned 0.
[   32.795751] initcall 0x78a48e70 ran for 0 msecs: dm_delay_init+0x0/0xc0()
[   32.802513] Calling initcall 0x78a48f30: dm_snapshot_init+0x0/0x1e0()
[   32.809013] initcall 0x78a48f30: dm_snapshot_init+0x0/0x1e0() returned 0.
[   32.815683] initcall 0x78a48f30 ran for 0 msecs: dm_snapshot_init+0x0/0x1e0()
[   32.822797] Calling initcall 0x78a49160: dm_mirror_init+0x0/0x40()
[   32.828962] initcall 0x78a49160: dm_mirror_init+0x0/0x40() returned 0.
[   32.835444] initcall 0x78a49160 ran for 0 msecs: dm_mirror_init+0x0/0x40()
[   32.842291] Calling initcall 0x78a491a0: kcapi_init+0x0/0xb0()
[   32.848109] CAPI Subsystem Rev 1.1.2.8
[   32.851832] initcall 0x78a491a0: kcapi_init+0x0/0xb0() returned 0.
[   32.857976] initcall 0x78a491a0 ran for 3 msecs: kcapi_init+0x0/0xb0()
[   32.864482] Calling initcall 0x78a49a10: b1pci_init+0x0/0xd0()
[   32.870307] b1pci: revision 1.1.2.2
[   32.873758] initcall 0x78a49a10: b1pci_init+0x0/0xd0() returned 0.
[   32.879904] initcall 0x78a49a10 ran for 3 msecs: b1pci_init+0x0/0xd0()
[   32.886406] Calling initcall 0x78a49ae0: b1_init+0x0/0x80()
[   32.891949] b1: revision 1.1.2.2
[   32.895163] initcall 0x78a49ae0: b1_init+0x0/0x80() returned 0.
[   32.901044] initcall 0x78a49ae0 ran for 1 msecs: b1_init+0x0/0x80()
[   32.907289] Calling initcall 0x78a49b60: b1dma_init+0x0/0x80()
[   32.913094] b1dma: revision 1.1.2.3
[   32.916568] initcall 0x78a49b60: b1dma_init+0x0/0x80() returned 0.
[   32.922715] initcall 0x78a49b60 ran for 3 msecs: b1dma_init+0x0/0x80()
[   32.929211] Calling initcall 0x78a49be0: b1pcmcia_init+0x0/0xa0()
[   32.935280] b1pci: revision 1.1.2.2
[   32.938754] initcall 0x78a49be0: b1pcmcia_init+0x0/0xa0() returned 0.
[   32.945157] initcall 0x78a49be0 ran for 2 msecs: b1pcmcia_init+0x0/0xa0()
[   32.951917] Calling initcall 0x78a49fc0: t1pci_init+0x0/0xb0()
[   32.957739] t1pci: revision 1.1.2.2
[   32.961199] initcall 0x78a49fc0: t1pci_init+0x0/0xb0() returned 0.
[   32.967340] initcall 0x78a49fc0 ran for 0 msecs: t1pci_init+0x0/0xb0()
[   32.973845] Calling initcall 0x78a4a970: c4_init+0x0/0xd0()
[   32.979413] c4: revision 1.1.2.2
[   32.982598] initcall 0x78a4a970: c4_init+0x0/0xd0() returned 0.
[   32.988487] initcall 0x78a4a970 ran for 0 msecs: c4_init+0x0/0xd0()
[   32.994728] Calling initcall 0x78a4ac20: cpufreq_stats_init+0x0/0x70()
[   33.001243] initcall 0x78a4ac20: cpufreq_stats_init+0x0/0x70() returned 0.
[   33.008073] initcall 0x78a4ac20 ran for 0 msecs: cpufreq_stats_init+0x0/0x70()
[   33.015272] Calling initcall 0x78a4ac90: cpufreq_gov_powersave_init+0x0/0x10()
[   33.022466] initcall 0x78a4ac90: cpufreq_gov_powersave_init+0x0/0x10() returned 0.
[   33.030001] initcall 0x78a4ac90 ran for 0 msecs: cpufreq_gov_powersave_init+0x0/0x10()
[   33.037890] Calling initcall 0x78a4acb0: cpufreq_gov_dbs_init+0x0/0x10()
[   33.044566] initcall 0x78a4acb0: cpufreq_gov_dbs_init+0x0/0x10() returned 0.
[   33.051577] initcall 0x78a4acb0 ran for 0 msecs: cpufreq_gov_dbs_init+0x0/0x10()
[   33.058944] Calling initcall 0x78a4b430: hid_init+0x0/0x10()
[   33.064585] initcall 0x78a4b430: hid_init+0x0/0x10() returned 0.
[   33.070553] initcall 0x78a4b430 ran for 0 msecs: hid_init+0x0/0x10()
[   33.076886] Calling initcall 0x78a4b440: hid_init+0x0/0x60()
[   33.082531] usbcore: registered new interface driver usbhid
[   33.088069] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   33.094310] initcall 0x78a4b440: hid_init+0x0/0x60() returned 0.
[   33.100285] initcall 0x78a4b440 ran for 6 msecs: hid_init+0x0/0x60()
[   33.106610] Calling initcall 0x78a4b4a0: usb_mouse_init+0x0/0x40()
[   33.112778] usbcore: registered new interface driver usbmouse
[   33.118487] drivers/hid/usbhid/usbmouse.c: v1.6:USB HID Boot Protocol mouse driver
[   33.126028] initcall 0x78a4b4a0: usb_mouse_init+0x0/0x40() returned 0.
[   33.132516] initcall 0x78a4b4a0 ran for 6 msecs: usb_mouse_init+0x0/0x40()
[   33.139371] Calling initcall 0x78a4d880: flow_cache_init+0x0/0x100()
[   33.145701] initcall 0x78a4d880: flow_cache_init+0x0/0x100() returned 0.
[   33.152362] initcall 0x78a4d880 ran for 0 msecs: flow_cache_init+0x0/0x100()
[   33.159389] Calling initcall 0x78a4d980: pg_init+0x0/0x250()
[   33.165018] pktgen v2.69: Packet Generator for packet performance testing.
[   33.171914] initcall 0x78a4d980: pg_init+0x0/0x250() returned 0.
[   33.177842] initcall 0x78a4d980 ran for 2 msecs: pg_init+0x0/0x250()
[   33.184172] Calling initcall 0x78a4dc10: llc_init+0x0/0x70()
[   33.189808] initcall 0x78a4dc10: llc_init+0x0/0x70() returned 0.
[   33.195779] initcall 0x78a4dc10 ran for 0 msecs: llc_init+0x0/0x70()
[   33.202108] Calling initcall 0x78a4dd00: llc2_init+0x0/0xd0()
[   33.207844] NET: Registered protocol family 26
[   33.212257] initcall 0x78a4dd00: llc2_init+0x0/0xd0() returned 0.
[   33.218313] initcall 0x78a4dd00 ran for 1 msecs: llc2_init+0x0/0xd0()
[   33.224726] Calling initcall 0x78a4df90: snap_init+0x0/0x40()
[   33.230465] initcall 0x78a4df90: snap_init+0x0/0x40() returned 0.
[   33.236515] initcall 0x78a4df90 ran for 0 msecs: snap_init+0x0/0x40()
[   33.242930] Calling initcall 0x78a4e0a0: blackhole_module_init+0x0/0x10()
[   33.249690] initcall 0x78a4e0a0: blackhole_module_init+0x0/0x10() returned 0.
[   33.256794] initcall 0x78a4e0a0 ran for 0 msecs: blackhole_module_init+0x0/0x10()
[   33.264247] Calling initcall 0x78a4e170: gact_init_module+0x0/0x20()
[   33.270572] GACT probability on
[   33.273706] initcall 0x78a4e170: gact_init_module+0x0/0x20() returned 0.
[   33.280366] initcall 0x78a4e170 ran for 2 msecs: gact_init_module+0x0/0x20()
[   33.287385] Calling initcall 0x78a4e190: simp_init_module+0x0/0x30()
[   33.293710] Simple TC action Loaded
[   33.297184] initcall 0x78a4e190: simp_init_module+0x0/0x30() returned 0.
[   33.303846] initcall 0x78a4e190 ran for 3 msecs: simp_init_module+0x0/0x30()
[   33.310870] Calling initcall 0x78a4e1c0: hfsc_init+0x0/0x10()
[   33.316593] initcall 0x78a4e1c0: hfsc_init+0x0/0x10() returned 0.
[   33.322656] initcall 0x78a4e1c0 ran for 0 msecs: hfsc_init+0x0/0x10()
[   33.329066] Calling initcall 0x78a4e1d0: gred_module_init+0x0/0x10()
[   33.335398] initcall 0x78a4e1d0: gred_module_init+0x0/0x10() returned 0.
[   33.342065] initcall 0x78a4e1d0 ran for 0 msecs: gred_module_init+0x0/0x10()
[   33.349085] Calling initcall 0x78a4e1e0: sfq_module_init+0x0/0x10()
[   33.355331] initcall 0x78a4e1e0: sfq_module_init+0x0/0x10() returned 0.
[   33.361911] initcall 0x78a4e1e0 ran for 0 msecs: sfq_module_init+0x0/0x10()
[   33.368844] Calling initcall 0x78a4e1f0: prio_module_init+0x0/0x40()
[   33.375176] initcall 0x78a4e1f0: prio_module_init+0x0/0x40() returned 0.
[   33.381843] initcall 0x78a4e1f0 ran for 0 msecs: prio_module_init+0x0/0x40()
[   33.388862] Calling initcall 0x78a4e230: netem_module_init+0x0/0x20()
[   33.395277] netem: version 1.2
[   33.398317] initcall 0x78a4e230: netem_module_init+0x0/0x20() returned 0.
[   33.405068] initcall 0x78a4e230 ran for 2 msecs: netem_module_init+0x0/0x20()
[   33.412175] Calling initcall 0x78a4e250: init_u32+0x0/0x30()
[   33.417811] u32 classifier
[   33.420497]     Actions configured 
[   33.423978] initcall 0x78a4e250: init_u32+0x0/0x30() returned 0.
[   33.429943] initcall 0x78a4e250 ran for 6 msecs: init_u32+0x0/0x30()
[   33.436269] Calling initcall 0x78a4e280: init_route4+0x0/0x10()
[   33.442165] initcall 0x78a4e280: init_route4+0x0/0x10() returned 0.
[   33.448399] initcall 0x78a4e280 ran for 0 msecs: init_route4+0x0/0x10()
[   33.454985] Calling initcall 0x78a4e290: init_rsvp+0x0/0x10()
[   33.460710] initcall 0x78a4e290: init_rsvp+0x0/0x10() returned 0.
[   33.466774] initcall 0x78a4e290 ran for 0 msecs: init_rsvp+0x0/0x10()
[   33.473187] Calling initcall 0x78a4e2a0: init_rsvp+0x0/0x10()
[   33.478910] initcall 0x78a4e2a0: init_rsvp+0x0/0x10() returned 0.
[   33.484970] initcall 0x78a4e2a0 ran for 0 msecs: init_rsvp+0x0/0x10()
[   33.491382] Calling initcall 0x78a4f450: ipip_init+0x0/0xa0()
[   33.497104] IPv4 over IPv4 tunneling driver
[   33.501390] initcall 0x78a4f450: ipip_init+0x0/0xa0() returned 0.
[   33.507326] initcall 0x78a4f450 ran for 0 msecs: ipip_init+0x0/0xa0()
[   33.513744] Calling initcall 0x78a4f540: ipgre_init+0x0/0xa0()
[   33.519549] GRE over IPv4 tunneling driver
[   33.523715] initcall 0x78a4f540: ipgre_init+0x0/0xa0() returned 0.
[   33.529776] initcall 0x78a4f540 ran for 3 msecs: ipgre_init+0x0/0xa0()
[   33.536279] Calling initcall 0x78a4f630: ah4_init+0x0/0x70()
[   33.542432] initcall 0x78a4f630: ah4_init+0x0/0x70() returned 0.
[   33.548406] initcall 0x78a4f630 ran for 0 msecs: ah4_init+0x0/0x70()
[   33.554732] Calling initcall 0x78a4f6a0: ipcomp4_init+0x0/0x70()
[   33.560718] initcall 0x78a4f6a0: ipcomp4_init+0x0/0x70() returned 0.
[   33.567042] initcall 0x78a4f6a0 ran for 0 msecs: ipcomp4_init+0x0/0x70()
[   33.573714] Calling initcall 0x78a4f710: ipip_init+0x0/0xb0()
[   33.579436] initcall 0x78a4f710: ipip_init+0x0/0xb0() returned 0.
[   33.585497] initcall 0x78a4f710 ran for 0 msecs: ipip_init+0x0/0xb0()
[   33.591909] Calling initcall 0x78a4f7c0: xfrm4_beet_init+0x0/0x10()
[   33.598155] initcall 0x78a4f7c0: xfrm4_beet_init+0x0/0x10() returned 0.
[   33.604736] initcall 0x78a4f7c0 ran for 0 msecs: xfrm4_beet_init+0x0/0x10()
[   33.611669] Calling initcall 0x78a4f7d0: tunnel4_init+0x0/0x70()
[   33.617653] initcall 0x78a4f7d0: tunnel4_init+0x0/0x70() returned 0.
[   33.623972] initcall 0x78a4f7d0 ran for 0 msecs: tunnel4_init+0x0/0x70()
[   33.630650] Calling initcall 0x78a4f840: xfrm4_transport_init+0x0/0x10()
[   33.637326] initcall 0x78a4f840: xfrm4_transport_init+0x0/0x10() returned 0.
[   33.644337] initcall 0x78a4f840 ran for 0 msecs: xfrm4_transport_init+0x0/0x10()
[   33.651711] Calling initcall 0x78a4f850: xfrm4_tunnel_init+0x0/0x10()
[   33.658124] initcall 0x78a4f850: xfrm4_tunnel_init+0x0/0x10() returned 0.
[   33.664878] initcall 0x78a4f850 ran for 0 msecs: xfrm4_tunnel_init+0x0/0x10()
[   33.671985] Calling initcall 0x78a50e40: cubictcp_register+0x0/0xa0()
[   33.678400] TCP cubic registered
[   33.681614] initcall 0x78a50e40: cubictcp_register+0x0/0xa0() returned 0.
[   33.688364] initcall 0x78a50e40 ran for 3 msecs: cubictcp_register+0x0/0xa0()
[   33.695470] Calling initcall 0x78a51120: af_unix_init+0x0/0x70()
[   33.701452] NET: Registered protocol family 1
[   33.705796] initcall 0x78a51120: af_unix_init+0x0/0x70() returned 0.
[   33.712108] initcall 0x78a51120 ran for 4 msecs: af_unix_init+0x0/0x70()
[   33.718781] Calling initcall 0x78a51190: inet6_init+0x0/0x2e0()
[   33.724690] NET: Registered protocol family 10
[   33.729219] lo: Disabled Privacy Extensions
[   33.733444] tunl0: Disabled Privacy Extensions
[   33.737843] initcall 0x78a51190: inet6_init+0x0/0x2e0() returned 0.
[   33.743998] initcall 0x78a51190 ran for 12 msecs: inet6_init+0x0/0x2e0()
[   33.750676] Calling initcall 0x78a51d10: xfrm6_tunnel_init+0x0/0x10()
[   33.757091] initcall 0x78a51d10: xfrm6_tunnel_init+0x0/0x10() returned 0.
[   33.763843] initcall 0x78a51d10 ran for 0 msecs: xfrm6_tunnel_init+0x0/0x10()
[   33.770955] Calling initcall 0x78a51d20: xfrm6_beet_init+0x0/0x10()
[   33.777196] initcall 0x78a51d20: xfrm6_beet_init+0x0/0x10() returned 0.
[   33.783775] initcall 0x78a51d20 ran for 0 msecs: xfrm6_beet_init+0x0/0x10()
[   33.790713] Calling initcall 0x78a51d30: sit_init+0x0/0xa0()
[   33.796345] IPv6 over IPv4 tunneling driver
[   33.800618] sit0: Disabled Privacy Extensions
[   33.804862] initcall 0x78a51d30: sit_init+0x0/0xa0() returned 0.
[   33.810822] initcall 0x78a51d30 ran for 4 msecs: sit_init+0x0/0xa0()
[   33.817154] Calling initcall 0x78a51e20: packet_init+0x0/0x50()
[   33.823046] NET: Registered protocol family 17
[   33.827488] initcall 0x78a51e20: packet_init+0x0/0x50() returned 0.
[   33.833707] initcall 0x78a51e20 ran for 4 msecs: packet_init+0x0/0x50()
[   33.840292] Calling initcall 0x78a51e70: br_init+0x0/0xb0()
[   33.845869] initcall 0x78a51e70: br_init+0x0/0xb0() returned 0.
[   33.851729] initcall 0x78a51e70 ran for 0 msecs: br_init+0x0/0xb0()
[   33.857968] Calling initcall 0x78a51fc0: ipx_init+0x0/0xf0()
[   33.863604] NET: Registered protocol family 4
[   33.871365] input: AT Translated Set 2 keyboard as /class/input/input0
[   33.879184] initcall 0x78a51fc0: ipx_init+0x0/0xf0() returned 0.
[   33.885032] initcall 0x78a51fc0 ran for 11 msecs: ipx_init+0x0/0xf0()
[   33.891446] Calling initcall 0x78a521e0: atalk_init+0x0/0x90()
[   33.897254] NET: Registered protocol family 5
[   33.919166] evbug.c: Connected device: "AT Translated Set 2 keyboard", isa0060/serio0/input0
[   33.927623] initcall 0x78a521e0: atalk_init+0x0/0x90() returned 0.
[   33.933653] initcall 0x78a521e0 ran for 25 msecs: atalk_init+0x0/0x90()
[   33.940239] Calling initcall 0x78a52460: x25_init+0x0/0x60()
[   33.945877] NET: Registered protocol family 9
[   33.950209] X.25 for Linux. Version 0.2 for Linux 2.1.15
[   33.955502] initcall 0x78a52460: x25_init+0x0/0x60() returned 0.
[   33.961468] initcall 0x78a52460 ran for 6 msecs: x25_init+0x0/0x60()
[   33.967794] Calling initcall 0x78a52a70: irlan_init+0x0/0x220()
[   33.973835] initcall 0x78a52a70: irlan_init+0x0/0x220() returned 0.
[   33.979949] initcall 0x78a52a70 ran for 0 msecs: irlan_init+0x0/0x220()
[   33.986534] Calling initcall 0x78a52c90: ircomm_init+0x0/0x80()
[   33.992426] IrCOMM protocol (Dag Brattli)
[   33.996420] initcall 0x78a52c90: ircomm_init+0x0/0x80() returned 0.
[   34.002653] initcall 0x78a52c90 ran for 2 msecs: ircomm_init+0x0/0x80()
[   34.009240] Calling initcall 0x78a52d10: ircomm_tty_init+0x0/0x170()
[   34.016031] initcall 0x78a52d10: ircomm_tty_init+0x0/0x170() returned 0.
[   34.022575] initcall 0x78a52d10 ran for 3 msecs: ircomm_tty_init+0x0/0x170()
[   34.029597] Calling initcall 0x78a52eb0: init_sunrpc+0x0/0x60()
[   34.035684] RPC: Registered udp transport module.
[   34.040273] RPC: Registered tcp transport module.
[   34.044955] initcall 0x78a52eb0: init_sunrpc+0x0/0x60() returned 0.
[   34.051179] initcall 0x78a52eb0 ran for 4 msecs: init_sunrpc+0x0/0x60()
[   34.057771] Calling initcall 0x78a52f10: init_rpcsec_gss+0x0/0x30()
[   34.064034] initcall 0x78a52f10: init_rpcsec_gss+0x0/0x30() returned 0.
[   34.070589] initcall 0x78a52f10 ran for 0 msecs: init_rpcsec_gss+0x0/0x30()
[   34.077528] Calling initcall 0x78a52f40: init_kerberos_module+0x0/0x30()
[   34.084225] initcall 0x78a52f40: init_kerberos_module+0x0/0x30() returned 0.
[   34.091217] initcall 0x78a52f40 ran for 0 msecs: init_kerberos_module+0x0/0x30()
[   34.098589] Calling initcall 0x78a52f70: decnet_init+0x0/0x80()
[   34.104478] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   34.112308] DECnet: Routing cache hash table of 1024 buckets, 32Kbytes
[   34.118851] NET: Registered protocol family 12
[   34.123209] initcall 0x78a52f70: decnet_init+0x0/0x80() returned 0.
[   34.129438] initcall 0x78a52f70 ran for 11 msecs: decnet_init+0x0/0x80()
[   34.136112] Calling initcall 0x78a532d0: econet_proto_init+0x0/0x40()
[   34.142528] NET: Registered protocol family 19
[   34.146952] initcall 0x78a532d0: econet_proto_init+0x0/0x40() returned 0.
[   34.153697] initcall 0x78a532d0 ran for 4 msecs: econet_proto_init+0x0/0x40()
[   34.160809] Calling initcall 0x78a53310: vlan_proto_init+0x0/0xd0()
[   34.167047] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   34.173811] All bugs added by David S. Miller <davem@redhat.com>
[   34.179810] initcall 0x78a53310: vlan_proto_init+0x0/0xd0() returned 0.
[   34.186373] initcall 0x78a53310 ran for 5 msecs: vlan_proto_init+0x0/0xd0()
[   34.193309] Calling initcall 0x78a53440: dccp_init+0x0/0x2c0()
[   34.207686] initcall 0x78a53440: dccp_init+0x0/0x2c0() returned 0.
[   34.213710] initcall 0x78a53440 ran for 8 msecs: dccp_init+0x0/0x2c0()
[   34.220215] Calling initcall 0x78a53740: dccp_v4_init+0x0/0xa0()
[   34.235804] initcall 0x78a53740: dccp_v4_init+0x0/0xa0() returned 0.
[   34.241998] initcall 0x78a53740 ran for 9 msecs: dccp_v4_init+0x0/0xa0()
[   34.248672] Calling initcall 0x78a537e0: dccp_v6_init+0x0/0xa0()
[   34.254678] initcall 0x78a537e0: dccp_v6_init+0x0/0xa0() returned 0.
[   34.260977] initcall 0x78a537e0 ran for 0 msecs: dccp_v6_init+0x0/0xa0()
[   34.267656] Calling initcall 0x78a53910: ieee80211_init+0x0/0xb0()
[   34.273809] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   34.280396] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   34.288719] initcall 0x78a53910: ieee80211_init+0x0/0xb0() returned 0.
[   34.295208] initcall 0x78a53910 ran for 4 msecs: ieee80211_init+0x0/0xb0()
[   34.302055] Calling initcall 0x78a539c0: ieee80211_crypto_init+0x0/0x10()
[   34.308843] ieee80211_crypt: registered algorithm 'NULL'
[   34.314110] initcall 0x78a539c0: ieee80211_crypto_init+0x0/0x10() returned 0.
[   34.321207] initcall 0x78a539c0 ran for 5 msecs: ieee80211_crypto_init+0x0/0x10()
[   34.328665] Calling initcall 0x78a539d0: tipc_init+0x0/0xf0()
[   34.334393] TIPC: Activated (version 1.6.2 compiled Oct 17 2007 17:24:06)
[   34.342666] NET: Registered protocol family 30
[   34.346991] TIPC: Started in single node mode
[   34.351324] initcall 0x78a539d0: tipc_init+0x0/0xf0() returned 0.
[   34.357377] initcall 0x78a539d0 ran for 9 msecs: tipc_init+0x0/0xf0()
[   34.363796] Calling initcall 0x78a53b40: init_p9+0x0/0x60()
[   34.369354] Installing 9P2000 support
[   34.373041] initcall 0x78a53b40: init_p9+0x0/0x60() returned 0.
[   34.378869] initcall 0x78a53b40 ran for 3 msecs: init_p9+0x0/0x60()
[   34.385111] Calling initcall 0x78a1d920: centrino_init+0x0/0x20()
[   34.391182] initcall 0x78a1d920: centrino_init+0x0/0x20() returned -19.
[   34.397764] initcall 0x78a1d920 ran for 0 msecs: centrino_init+0x0/0x20()
[   34.404529] Calling initcall 0x78a1fb30: check_nmi_watchdog+0x0/0x140()
[   34.411116] initcall 0x78a1fb30: check_nmi_watchdog+0x0/0x140() returned 0.
[   34.418042] initcall 0x78a1fb30 ran for 0 msecs: check_nmi_watchdog+0x0/0x140()
[   34.425322] Calling initcall 0x78a1fda0: io_apic_bug_finalize+0x0/0x20()
[   34.432000] initcall 0x78a1fda0: io_apic_bug_finalize+0x0/0x20() returned 0.
[   34.439012] initcall 0x78a1fda0 ran for 0 msecs: io_apic_bug_finalize+0x0/0x20()
[   34.446386] Calling initcall 0x78a23a40: print_ipi_mode+0x0/0x30()
[   34.452540] Using IPI Shortcut mode
[   34.456009] initcall 0x78a23a40: print_ipi_mode+0x0/0x30() returned 0.
[   34.462502] initcall 0x78a23a40 ran for 3 msecs: print_ipi_mode+0x0/0x30()
[   34.469352] Calling initcall 0x78a24180: disable_boot_consoles+0x0/0x50()
[   34.476111] initcall 0x78a24180: disable_boot_consoles+0x0/0x50() returned 0.
[   34.483215] initcall 0x78a24180 ran for 0 msecs: disable_boot_consoles+0x0/0x50()
[   34.490667] Calling initcall 0x78a25a60: taskstats_init+0x0/0x70()
[   34.496834] initcall 0x78a25a60: taskstats_init+0x0/0x70() returned 0.
[   34.503320] initcall 0x78a25a60 ran for 0 msecs: taskstats_init+0x0/0x70()
[   34.510166] Calling initcall 0x78a2b9c0: random32_reseed+0x0/0x30()
[   34.516414] initcall 0x78a2b9c0: random32_reseed+0x0/0x30() returned 0.
[   34.522992] initcall 0x78a2b9c0 ran for 0 msecs: random32_reseed+0x0/0x30()
[   34.529927] Calling initcall 0x78a2d030: pci_sysfs_init+0x0/0x40()
[   34.536194] initcall 0x78a2d030: pci_sysfs_init+0x0/0x40() returned 0.
[   34.542577] initcall 0x78a2d030 ran for 0 msecs: pci_sysfs_init+0x0/0x40()
[   34.549427] Calling initcall 0x78a2d360: seqgen_init+0x0/0x10()
[   34.555334] initcall 0x78a2d360: seqgen_init+0x0/0x10() returned 0.
[   34.561553] initcall 0x78a2d360 ran for 0 msecs: seqgen_init+0x0/0x10()
[   34.568140] Calling initcall 0x784ca5a0: scsi_complete_async_scans+0x0/0xe0()
[   34.575251] initcall 0x784ca5a0: scsi_complete_async_scans+0x0/0xe0() returned 0.
[   34.582702] initcall 0x784ca5a0 ran for 0 msecs: scsi_complete_async_scans+0x0/0xe0()
[   34.590503] Calling initcall 0x78a4ebf0: tcp_congestion_default+0x0/0x10()
[   34.597350] initcall 0x78a4ebf0: tcp_congestion_default+0x0/0x10() returned 0.
[   34.604538] initcall 0x78a4ebf0 ran for 0 msecs: tcp_congestion_default+0x0/0x10()
[   34.612082] Calling initcall 0x78a4fc40: ip_auto_config+0x0/0xdc0()
[   34.618324] initcall 0x78a4fc40: ip_auto_config+0x0/0xdc0() returned 0.
[   34.625422] initcall 0x78a4fc40 ran for 0 msecs: ip_auto_config+0x0/0xdc0()
[   34.665133] kjournald starting.  Commit interval 5 seconds
[   34.670612] EXT3-fs: mounted filesystem with ordered data mode.
[   34.676419] VFS: Mounted root (ext3 filesystem) readonly.
[   34.682140] Freeing unused kernel memory: 372k freed
[   37.701628] warning: process `kmodule' used the removed sysctl system call with 1.23.
[   39.409390] BUG: unable to handle kernel paging request at virtual address 7ca76000
[   39.416892] printing eip: 78406669 *pde = 00dda027 *pte = 04a76000 
[   39.423132] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   39.427292] 
[   39.428766] Pid: 431, comm: fsck.ext3 Not tainted (2.6.23 #45)
[   39.434571] EIP: 0060:[<78406669>] EFLAGS: 00010006 CPU: 0
[   39.440035] EIP is at blk_rq_map_sg+0xb9/0x170
[   39.444450] EAX: 04aed000 EBX: 7ca1f380 ECX: 04aee000 EDX: 00095da0
[   39.450689] ESI: 7ca75ff0 EDI: 79180da0 EBP: 00001000 ESP: 7caa1cac
[   39.456929]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   39.462303] Process fsck.ext3 (pid: 431, ti=7caa0000 task=7ca80000 task.ti=7caa0000)
[   39.469841] Stack: 00000020 7b520000 00002000 04aef000 7ca75fe0 0000001f 00000001 00000000 
[   39.478161]        7ca1f300 01000002 7ca44980 7b522b94 7ca0de00 7b520000 784c89b5 7b520000 
[   39.486480]        784c843a 7ca0de00 7b520f20 7b522b94 7ca0de00 784e54a0 784f394b 00000000 
[   39.494799] Call Trace:
[   39.497400]  [<784c89b5>] scsi_init_io+0x55/0xe0
[   39.501992]  [<784c843a>] scsi_get_cmd_from_req+0x2a/0x40
[   39.507366]  [<784e54a0>] sd_prep_fn+0x80/0x940
[   39.511872]  [<784f394b>] ata_bmdma_start+0xb/0x20
[   39.516638]  [<784ef344>] ata_qc_issue_prot+0x164/0x1e0
[   39.521839]  [<78405c63>] elv_dispatch_sort+0x23/0xe0
[   39.526865]  [<784057d0>] elv_next_request+0xa0/0x130
[   39.531891]  [<787715b8>] _spin_lock_irq+0x38/0x50
[   39.536657]  [<784c9af4>] scsi_request_fn+0x1e4/0x370
[   39.541684]  [<78120e72>] del_timer+0x62/0x70
[   39.546016]  [<78408a45>] __generic_unplug_device+0x25/0x30
[   39.551563]  [<78408d15>] generic_unplug_device+0x15/0x30
[   39.556936]  [<78406430>] blk_backing_dev_unplug+0x0/0x10
[   39.562309]  [<7840643c>] blk_backing_dev_unplug+0xc/0x10
[   39.567682]  [<7818080d>] block_sync_page+0x2d/0x40
[   39.572535]  [<78144ee9>] sync_page+0x29/0x40
[   39.576868]  [<7876fdec>] __wait_on_bit_lock+0x3c/0x70
[   39.581981]  [<78144ec0>] sync_page+0x0/0x40
[   39.586227]  [<78144ea2>] __lock_page+0x52/0x60
[   39.590734]  [<7812ae90>] wake_bit_function+0x0/0x60
[   39.595674]  [<7814566c>] do_generic_mapping_read+0x21c/0x450
[   39.601393]  [<78144c30>] file_read_actor+0x0/0x130
[   39.606246]  [<78147227>] generic_file_aio_read+0x137/0x180
[   39.611793]  [<78144c30>] file_read_actor+0x0/0x130
[   39.616645]  [<78160d95>] do_sync_read+0xd5/0x120
[   39.621326]  [<78135cd8>] mark_held_locks+0x38/0x70
[   39.626179]  [<7812ae50>] autoremove_wake_function+0x0/0x40
[   39.631724]  [<787705b4>] mutex_lock_nested+0x1a4/0x200
[   39.636924]  [<78185611>] block_llseek+0x31/0xc0
[   39.641517]  [<787703a5>] __mutex_unlock_slowpath+0xb5/0x110
[   39.647150]  [<78135e1c>] trace_hardirqs_on+0x9c/0xb0
[   39.652177]  [<78160cc0>] do_sync_read+0x0/0x120
[   39.656770]  [<7816165b>] vfs_read+0xbb/0x120
[   39.661103]  [<78161a41>] sys_read+0x41/0x70
[   39.665349]  [<781028a2>] syscall_call+0x7/0xb
[   39.669769]  =======================
[   39.673322] Code: 05 c1 e1 0c 03 4a 08 8b 52 04 01 ca 89 54 24 0c 8b 3b 89 fa 29 c2 89 d0 c1 f8 05 c1 e0 0c 03 43 08 39 44 24 0c 0f 84 7e 00 00 00 <8b> 46 10 8d 56 10 a8 01 75 4c 89 3e 89 6e 0c 8b 43 08 89 46 04 
[   39.692128] EIP: [<78406669>] blk_rq_map_sg+0xb9/0x170 SS:ESP 0068:7caa1cac
[   73.714486] BUG: spinlock lockup on CPU#0, fsck.ext3/431, 7b52010c
[   73.720530]  [<78415bfb>] _raw_spin_lock+0x13b/0x140
[   73.725469]  [<784c8c66>] scsi_device_unbusy+0x66/0xa0
[   73.730582]  [<784c31ec>] scsi_finish_command+0x1c/0xd0
[   73.735782]  [<7811d4b8>] do_softirq+0x68/0x70
[   73.740202]  [<784068f3>] blk_done_softirq+0x73/0x80
[   73.745141]  [<7811d3f3>] __do_softirq+0x53/0xb0
[   73.749734]  [<7811d4b8>] do_softirq+0x68/0x70
[   73.754154]  [<7810c1ce>] smp_apic_timer_interrupt+0x3e/0x80
[   73.759787]  [<781038c9>] apic_timer_interrupt+0x29/0x40
[   73.765073]  [<781038d3>] apic_timer_interrupt+0x33/0x40
[   73.770360]  [<7811b6ee>] do_exit+0x6e/0x760
[   73.774606]  [<78771645>] _spin_unlock_irq+0x25/0x30
[   73.779546]  [<7811b6ee>] do_exit+0x6e/0x760
[   73.783792]  [<78104031>] show_registers+0x71/0x1a0
[   73.788645]  [<78439153>] do_unblank_screen+0x23/0x130
[   73.793759]  [<7810437f>] die+0x21f/0x220
[   73.797745]  [<7810fcb7>] do_page_fault+0x177/0x670
[   73.802597]  [<7810fb40>] do_page_fault+0x0/0x670
[   73.807277]  [<787718fa>] error_code+0x6a/0x70
[   73.811697]  [<78406669>] blk_rq_map_sg+0xb9/0x170
[   73.816464]  [<784c89b5>] scsi_init_io+0x55/0xe0
[   73.821057]  [<784c843a>] scsi_get_cmd_from_req+0x2a/0x40
[   73.826429]  [<784e54a0>] sd_prep_fn+0x80/0x940
[   73.830936]  [<784f394b>] ata_bmdma_start+0xb/0x20
[   73.835702]  [<784ef344>] ata_qc_issue_prot+0x164/0x1e0
[   73.840902]  [<78405c63>] elv_dispatch_sort+0x23/0xe0
[   73.845928]  [<784057d0>] elv_next_request+0xa0/0x130
[   73.850955]  [<787715b8>] _spin_lock_irq+0x38/0x50
[   73.855721]  [<784c9af4>] scsi_request_fn+0x1e4/0x370
[   73.860747]  [<78120e72>] del_timer+0x62/0x70
[   73.865081]  [<78408a45>] __generic_unplug_device+0x25/0x30
[   73.870627]  [<78408d15>] generic_unplug_device+0x15/0x30
[   73.876000]  [<78406430>] blk_backing_dev_unplug+0x0/0x10
[   73.881372]  [<7840643c>] blk_backing_dev_unplug+0xc/0x10
[   73.886746]  [<7818080d>] block_sync_page+0x2d/0x40
[   73.891599]  [<78144ee9>] sync_page+0x29/0x40
[   73.895932]  [<7876fdec>] __wait_on_bit_lock+0x3c/0x70
[   73.901044]  [<78144ec0>] sync_page+0x0/0x40
[   73.905291]  [<78144ea2>] __lock_page+0x52/0x60
[   73.909797]  [<7812ae90>] wake_bit_function+0x0/0x60
[   73.914737]  [<7814566c>] do_generic_mapping_read+0x21c/0x450
[   73.920456]  [<78144c30>] file_read_actor+0x0/0x130
[   73.925310]  [<78147227>] generic_file_aio_read+0x137/0x180
[   73.930857]  [<78144c30>] file_read_actor+0x0/0x130
[   73.935709]  [<78160d95>] do_sync_read+0xd5/0x120
[   73.940389]  [<78135cd8>] mark_held_locks+0x38/0x70
[   73.945242]  [<7812ae50>] autoremove_wake_function+0x0/0x40
[   73.950788]  [<787705b4>] mutex_lock_nested+0x1a4/0x200
[   73.955988]  [<78185611>] block_llseek+0x31/0xc0
[   73.960581]  [<787703a5>] __mutex_unlock_slowpath+0xb5/0x110
[   73.966214]  [<78135e1c>] trace_hardirqs_on+0x9c/0xb0
[   73.971241]  [<78160cc0>] do_sync_read+0x0/0x120
[   73.975833]  [<7816165b>] vfs_read+0xbb/0x120
[   73.980166]  [<78161a41>] sys_read+0x41/0x70
[   73.984413]  [<781028a2>] syscall_call+0x7/0xb
[   73.988832]  =======================

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23
# Wed Oct 17 17:23:34 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_BOOTPARAM_SUPPORT=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_USER_NS is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_BOOTPARAM_MAXCPUS_1=y
CONFIG_BOOTPARAM_NOSMP=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
# CONFIG_HOTPLUG is not set
CONFIG_PRINTK=y
# CONFIG_BUG is not set
CONFIG_ELF_CORE=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_LSF=y
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
# CONFIG_BOOTPARAM_NO_HZ_OFF is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_BOOTPARAM_HIGHRES_OFF=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT=y
# CONFIG_XEN is not set
CONFIG_VMI=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
CONFIG_MGEODEGX1=y
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
# CONFIG_HPET_TIMER is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
# CONFIG_X86_PAE is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_0 is not set
# CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_1 is not set
# CONFIG_BOOTPARAM_NOAPIC is not set
# CONFIG_BOOTPARAM_NOLAPIC is not set
CONFIG_BOOTPARAM_LAPIC=y
CONFIG_BOOTPARAM_HPET_DISABLE=y
# CONFIG_BOOTPARAM_IDLE_MWAIT is not set
CONFIG_BOOTPARAM_IDLE_POLL=y
CONFIG_BOOTPARAM_HIGHMEM_512M=y

#
# Power management options (ACPI, APM)
#
# CONFIG_PM is not set
CONFIG_SUSPEND_UP_POSSIBLE=y
CONFIG_HIBERNATION_UP_POSSIBLE=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_MCA=y
# CONFIG_MCA_LEGACY is not set
# CONFIG_SCx200 is not set
CONFIG_K8_NB=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2 is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_IP_SCTP is not set
CONFIG_TIPC=y
# CONFIG_TIPC_ADVANCED is not set
CONFIG_TIPC_DEBUG=y
# CONFIG_ATM is not set
CONFIG_BRIDGE=y
CONFIG_VLAN_8021Q=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
# CONFIG_IPDDP_DECAP is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_ECONET=y
# CONFIG_ECONET_AUNUDP is not set
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=y

#
# QoS and/or fair queueing
#
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_FIFO=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_RR=y
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
# CONFIG_NET_CLS_POLICE is not set
# CONFIG_NET_CLS_IND is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
# CONFIG_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
# CONFIG_KS959_DONGLE is not set

#
# Old SIR device drivers
#
# CONFIG_IRPORT_SIR is not set

#
# Old Serial dongle support
#

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
# CONFIG_MCS_FIR is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
CONFIG_CFG80211=y
# CONFIG_NL80211 is not set
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_LOWTX_FRAME_DUMP=y
# CONFIG_TKIP_DEBUG is not set
CONFIG_MAC80211_DEBUG_COUNTERS=y
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
CONFIG_IEEE80211=y
CONFIG_IEEE80211_DEBUG=y
# CONFIG_IEEE80211_CRYPT_WEP is not set
# CONFIG_IEEE80211_CRYPT_CCMP is not set
# CONFIG_IEEE80211_CRYPT_TKIP is not set
# CONFIG_IEEE80211_SOFTMAC is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_PARPORT is not set
# CONFIG_BLK_DEV is not set
# CONFIG_MISC_DEVICES is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=y
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
CONFIG_SATA_VITESSE=y
CONFIG_SATA_INIC162X=y
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_CMD64X=y
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CS5535=y
# CONFIG_PATA_CS5536 is not set
CONFIG_PATA_CYPRESS=y
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_IT8213=y
# CONFIG_PATA_JMICRON is not set
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_MARVELL=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NS87410=y
CONFIG_PATA_NS87415=y
CONFIG_PATA_OPTI=y
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=y
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_SIL680=y
# CONFIG_PATA_SIS is not set
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_PLATFORM=y
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_OHCI1394=y

#
# Protocols
#
CONFIG_IEEE1394_VIDEO1394=y
CONFIG_IEEE1394_SBP2=y
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_DV1394=y
# CONFIG_IEEE1394_RAWIO is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NET_PCI=y
CONFIG_FORCEDETH=y
CONFIG_E100=y
CONFIG_8139TOO=y
CONFIG_E1000=y
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
# CONFIG_CAPI_TRACE is not set
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
# CONFIG_ISDN_CAPI_CAPI20 is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=y
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
CONFIG_ISDN_DRV_AVMB1_C4=y
CONFIG_CAPI_EICON=y
# CONFIG_ISDN_DIVAS is not set
CONFIG_PHONE=y
# CONFIG_PHONE_IXJ is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_MCA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_SC520_WDT=y
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=y
CONFIG_RTC=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
CONFIG_CS5535_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_I810=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_PROSAVAGE=y
CONFIG_I2C_SAVAGE4=y
# CONFIG_I2C_SIMTEC is not set
CONFIG_SCx200_ACB=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y
CONFIG_I2C_VOODOO3=y

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
CONFIG_DS1682=y
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_SENSORS_MAX6875 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_BITBANG is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_AT25=y
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHER=y
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_HDAPS=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
CONFIG_DVB_CORE=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_CINERGYT2 is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_CX24110=y
CONFIG_DVB_CX24123=y
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_MT312=y
# CONFIG_DVB_VES1X93 is not set
CONFIG_DVB_S5H1420=y
# CONFIG_DVB_TDA10086 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
CONFIG_DVB_CX22702=y
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=y
# CONFIG_DVB_ZL10353 is not set
# CONFIG_DVB_DIB3000MB is not set
CONFIG_DVB_DIB3000MC=y
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
# CONFIG_DVB_OR51132 is not set
CONFIG_DVB_BCM3510=y
# CONFIG_DVB_LGDT330X is not set
CONFIG_DVB_S5H1409=y

#
# Tuners/PLL support
#
# CONFIG_DVB_PLL is not set
CONFIG_DVB_TDA826X=y
# CONFIG_DVB_TDA827X is not set
# CONFIG_DVB_TUNER_QT1010 is not set
CONFIG_DVB_TUNER_MT2060=y
# CONFIG_DVB_TUNER_MT2266 is not set
# CONFIG_DVB_TUNER_MT2131 is not set
# CONFIG_DVB_TUNER_DIB0070 is not set

#
# Miscellaneous devices
#
# CONFIG_DVB_LNBP21 is not set
CONFIG_DVB_ISL6421=y
CONFIG_DVB_TUA6100=y
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=y
CONFIG_BACKLIGHT_PROGEAR=y

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_USB_HIDINPUT_POWERBOOK=y
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USB_MON=y

#
# USB port drivers
#

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_AIRPRIME=y
CONFIG_USB_SERIAL_ARK3116=y
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=y
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_HP4X=y
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=y
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_DEBUG=y
CONFIG_USB_EZUSB=y

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_AUERSWALD=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_PHIDGET=y
# CONFIG_USB_PHIDGETKIT is not set
# CONFIG_USB_PHIDGETMOTORCONTROL is not set
# CONFIG_USB_PHIDGETSERVO is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y

#
# Userspace I/O
#
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_LGUEST is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4DEV_FS=y
# CONFIG_EXT4DEV_FS_XATTR is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_SECURITY is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_MINIX_FS=y
CONFIG_ROMFS_FS=y
# CONFIG_INOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_DNOTIFY=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=y
CONFIG_VXFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_CODA_FS_OLD_API=y
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set
# CONFIG_INSTRUMENTATION is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_LIST=y
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PAGEALLOC=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
# CONFIG_DOUBLEFAULT is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_XTS is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_FORCE_MINIMAL_CONFIG=y

--k1lZvvs/B4yU6o8G--
