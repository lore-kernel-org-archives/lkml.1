Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYIFNEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYIFNEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 09:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYIFNE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 09:04:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55695 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYIFNEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 09:04:21 -0400
Date: Sat, 6 Sep 2008 15:03:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: venkatesh.pallipadi@intel.com
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [RFC 0/4] Using HPET in MSI mode and setting up per CPU HPET
	timers
Message-ID: <20080906130353.GA30340@elte.hu>
References: <20080906010214.229910000@intel.com> <20080906124234.GG30964@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20080906124234.GG30964@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> There's a few routine checks this new has to pass: we've got to see 
> how widely this works and whether there are any bugs/quirks to take 
> care of, so i created a separate feature topic for it: 
> tip/timers/hpet-percpu.

it crashes two testsystems, the fault on a NULL pointer in hpet init, 
with:

initcall print_all_ICs+0x0/0x520 returned 0 after 26 msecs
calling  hpet_late_init+0x0/0x1c0
BUG: unable to handle kernel NULL pointer dereference at 000000000000008c
IP: [<ffffffff80d228be>] hpet_late_init+0xfe/0x1c0
PGD 0 
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc5 #29725
RIP: 0010:[<ffffffff80d228be>]  [<ffffffff80d228be>] hpet_late_init+0xfe/0x1c0
RSP: 0018:ffff88003fa07dd0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffffc20000000160 RSI: 0000000000000000 RDI: 0000000000000003
RBP: ffff88003fa07e90 R08: 0000000000000000 R09: ffff88003fa07dd0
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88003fa07dd0
R13: 0000000000000002 R14: ffffc20000000000 R15: 000000006f57e511
FS:  0000000000000000(0000) GS:ffffffff80cf6a80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000000008c CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88003fa06000, task ffff88003fa08000)
Stack:  00000000fed00000 ffffc20000000000 0000000100000003 0000000800000002
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff80d227c0>] ? hpet_late_init+0x0/0x1c0
 [<ffffffff80209045>] do_one_initcall+0x45/0x190
 [<ffffffff80296f39>] ? register_irq_proc+0x19/0xe0
 [<ffffffff80d0d140>] ? early_idt_handler+0x0/0x73
 [<ffffffff80d0dabc>] kernel_init+0x14c/0x1b0
 [<ffffffff80942ac1>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020dbd9>] child_rip+0xa/0x11
 [<ffffffff8020ceee>] ? restore_args+0x0/0x30
 [<ffffffff80d0d970>] ? kernel_init+0x0/0x1b0
 [<ffffffff8020dbcf>] ? child_rip+0x0/0x11
Code: 20 48 83 c1 01 48 39 f1 75 e3 44 89 e8 4c 8b 05 29 29 22 00 31 f6 48 8d 78 01 66 66 90 89 f0 48 8d 04 80 48 c1 e0 05 4a 8d 0c 00 <f6> 81 8c 00 00 00 08 74 26 8b 81 80 00 00 00 8b 91 88 00 00 00 
RIP  [<ffffffff80d228be>] hpet_late_init+0xfe/0x1c0
 RSP <ffff88003fa07dd0>
CR2: 000000000000008c
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu

I've attached the full crashlog and the .config as well.

i bisected it down to:

 45efe60daf77bf628c0dcfdbd2abc3fb531b5114 is first bad commit
 commit 45efe60daf77bf628c0dcfdbd2abc3fb531b5114
 Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
 Date:   Fri Sep 5 18:02:18 2008 -0700

     x86: HPET_MSI Initialise per-cpu HPET timers
 
 # bad:  [c25af515] Merge branch 'timers/hpet-percpu'
 # good: [1d09e6e1] Merge branch 'out-of-tree'
 # good: [d81e5e19] Merge branch 'x86/unify-cpu-detect'
 # good: [462e8a8f] x86: HPET_MSI Refactor code in preparation for HPE
 # good: [69e09e1d] x86: HPET_MSI Basic HPET_MSI setup code, cleanups
 # bad:  [45efe60d] x86: HPET_MSI Initialise per-cpu HPET timers

at first look hpet_virt_address must be NULL or so? Probably something 
trivial.

[ Another 32-bit testsystem crashed too but it's not as debuggable as 
  this 64-bit system - i presume it's the same problem. ]

	Ingo

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log"

Linux version 2.6.27-rc5 (mingo@dione) (gcc version 4.2.3) #29725 SMP Sat Sep 6 14:53:16 CEST 2008
Command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 5 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi maxcpus=1 no_hz=off noapic nolapic_timer lapic idle=poll pci=nomsi
KERNEL supported cpus:
  Intel GenuineIntel
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)
 BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)
 BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)
 BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)
 BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)
 BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data)
 BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)
console [earlyser0] enabled
debug: ignoring loglevel setting.
using polling idle threads.
last_pfn = 0x3ff00 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003ff00000 page 4k
kernel direct mapping tables up to 3ff00000 @ 8000-b000
last_map_addr: 3ff00000 end: 3ff00000
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 3FEFDE48, 0050 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: FACP 3FEFCF10, 0074 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: DSDT 3FEF8010, 3E70 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: FACS 3FEDFC40, 0040
ACPI: APIC 3FEFCE10, 0078 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: WDDT 3FEF7F90, 0040 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: MCFG 3FEF7F10, 003C (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: ASF! 3FEFCD10, 00A6 (r32 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: HPET 3FEF7E90, 0038 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: SSDT 3FEFDC10, 01BC (r1 INTEL     CpuPm      4B9 MSFT  1000013)
ACPI: SSDT 3FEFDA10, 01B7 (r1 INTEL   Cpu0Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD810, 01B7 (r1 INTEL   Cpu1Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD610, 01B7 (r1 INTEL   Cpu2Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD410, 01B7 (r1 INTEL   Cpu3Ist      4B9 MSFT  1000013)
No NUMA configuration found
Faking a node at 0000000000000000-000000003ff00000
Bootmem setup node 0 0000000000000000-000000003ff00000
  NODE_DATA [0000000000001000 - 0000000000005fff]
  bootmap [0000000000009000 -  0000000000010fdf] pages 8
(5 early reservations) ==> bootmem [0000000000 - 003ff00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 000170d1c8]    TEXT DATA BSS ==> [0000200000 - 000170d1c8]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
found SMP MP-table at [ffff8800000fe680] 000fe680
 [ffffe20000000000-ffffe200019fffff] PMD -> [ffff880001a00000-ffff8800033fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003ed94
    0: 0x0003ee4e -> 0x0003fea2
    0: 0x0003fee9 -> 0x0003feed
    0: 0x0003feff -> 0x0003ff00
On node 0 totalpages: 261516
  DMA zone: 3793 pages, LIFO batch:0
  DMA32 zone: 250971 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: Skipping IOAPIC probe due to 'noapic' option.
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: 
MPTABLE: Product ID: 
MPTABLE: APIC at: 0xFEE00000
BIOS bug, no explicit IRQ entries, using default mptable. (tell your hw vendor)
Bus #0 is ISA   
Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
Int: type 0, pol 0, trig 0, bus 00, IRQ 09, APIC ID 0, APIC INT 09
Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
Int: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 00
Processors: 2
SMP: Allowing 4 CPUs, 2 hotplug CPUs
mapped APIC to ffffffffff5fc000 (        fee00000)
Allocating PCI resources starting at 40000000 (gap: 3ff00000:c0100000)
dyn_array irq_2_pin_head+0x0/0x8 size:0x10 nr:256 align:0x1000
dyn_array irq_cfgx+0x0/0x8 size:0x28 nr:32 align:0x1000
dyn_array irq_desc+0x0/0x8 size:0x100 nr:32 align:0x1000
dyn_array irq_timer_state+0x0/0x10 size:0x8 nr:32 align:0x1000
dyn_array total_size: 0x5000
dyn_array irq_2_pin_head+0x0/0x8  ==> [0x17a1000 - 0x17a2000]
dyn_array irq_cfgx+0x0/0x8  ==> [0x17a2000 - 0x17a2500]
dyn_array irq_desc+0x0/0x8  ==> [0x17a3000 - 0x17a5000]
kstat_irqs ==> [0x17a6000 - 0x17a6200]
dyn_array irq_timer_state+0x0/0x10  ==> [0x17a5000 - 0x17a5100]
PERCPU: Allocating 1622016 bytes of per cpu data
per cpu data for cpu0 on node0 at 0000000001812000
per cpu data for cpu1 on node0 at 0000000003400000
per cpu data for cpu2 on node0 at 000000000358c000
per cpu data for cpu3 on node0 at 0000000003718000
NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 254764
Policy zone: DMA32
Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 console=tty 5 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi maxcpus=1 no_hz=off noapic nolapic_timer lapic idle=poll pci=nomsi
kernel profiling enabled (shift: 0)
debug: sysrq always enabled.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 2933.308 MHz processor.
Console: colour VGA+ 80x25
console handover: boot [earlyser0] -> real [tty0]
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:           4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 4095 kB
 per task-struct memory footprint: 2688 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 961032k/1047552k available (7469k kernel code, 85032k reserved, 3741k data, 2120k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 5866.61 BogoMIPS (lpj=11733232)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in enforcing mode
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys debug
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
numa_add_cpu cpu 0 node 0: mask now 0
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
ACPI: Core revision 20080609
ACPI: setting ELCR to 0200 (from 0e00)
Setting APIC routing to flat
enabled ExtINT on CPU#0
CPU0: Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
Disabling APIC timer
calling  migration_init+0x0/0x60
initcall migration_init+0x0/0x60 returned 1 after 0 msecs
initcall migration_init+0x0/0x60 returned with error code 1 
calling  spawn_ksoftirqd+0x0/0x60
initcall spawn_ksoftirqd+0x0/0x60 returned 0 after 0 msecs
calling  init_call_single_data+0x0/0x80
initcall init_call_single_data+0x0/0x80 returned 0 after 0 msecs
calling  spawn_softlockup_task+0x0/0x80
initcall spawn_softlockup_task+0x0/0x80 returned 0 after 0 msecs
calling  relay_init+0x0/0x20
initcall relay_init+0x0/0x20 returned 0 after 0 msecs
Brought up 1 CPUs
Total of 1 processors activated (5866.61 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0 level CPU
  groups: 0
calling  init_cpufreq_transition_notifier_list+0x0/0x20
initcall init_cpufreq_transition_notifier_list+0x0/0x20 returned 0 after 0 msecs
calling  net_ns_init+0x0/0x1a0
net_namespace: 1672 bytes
initcall net_ns_init+0x0/0x1a0 returned 0 after 3 msecs
calling  cpufreq_tsc+0x0/0x40
initcall cpufreq_tsc+0x0/0x40 returned 0 after 0 msecs
calling  init_smp_flush+0x0/0x70
initcall init_smp_flush+0x0/0x70 returned 0 after 0 msecs
calling  print_banner+0x0/0x20
Booting paravirtualized kernel on bare hardware
initcall print_banner+0x0/0x20 returned 0 after 3 msecs
calling  sysctl_init+0x0/0x40
initcall sysctl_init+0x0/0x40 returned 0 after 0 msecs
calling  ksysfs_init+0x0/0xc0
initcall ksysfs_init+0x0/0xc0 returned 0 after 0 msecs
calling  init_jiffies_clocksource+0x0/0x20
initcall init_jiffies_clocksource+0x0/0x20 returned 0 after 0 msecs
calling  pm_init+0x0/0x40
initcall pm_init+0x0/0x40 returned 0 after 0 msecs
calling  ftrace_dynamic_init+0x0/0xf0
initcall ftrace_dynamic_init+0x0/0xf0 returned 0 after 0 msecs
calling  filelock_init+0x0/0x40
initcall filelock_init+0x0/0x40 returned 0 after 0 msecs
calling  init_script_binfmt+0x0/0x20
initcall init_script_binfmt+0x0/0x20 returned 0 after 0 msecs
calling  init_elf_binfmt+0x0/0x20
initcall init_elf_binfmt+0x0/0x20 returned 0 after 0 msecs
calling  init_compat_elf_binfmt+0x0/0x20
initcall init_compat_elf_binfmt+0x0/0x20 returned 0 after 0 msecs
calling  debugfs_init+0x0/0x70
initcall debugfs_init+0x0/0x70 returned 0 after 0 msecs
calling  securityfs_init+0x0/0x70
initcall securityfs_init+0x0/0x70 returned 0 after 0 msecs
calling  random32_init+0x0/0x100
initcall random32_init+0x0/0x100 returned 0 after 0 msecs
calling  cpufreq_core_init+0x0/0x90
initcall cpufreq_core_init+0x0/0x90 returned 0 after 0 msecs
calling  sock_init+0x0/0x70
initcall sock_init+0x0/0x70 returned 0 after 3 msecs
calling  netpoll_init+0x0/0x50
initcall netpoll_init+0x0/0x50 returned 0 after 0 msecs
calling  netlink_proto_init+0x0/0x180
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x180 returned 0 after 0 msecs
calling  bdi_class_init+0x0/0x50
initcall bdi_class_init+0x0/0x50 returned 0 after 0 msecs
calling  kobject_uevent_init+0x0/0x50
initcall kobject_uevent_init+0x0/0x50 returned 0 after 0 msecs
calling  pcibus_class_init+0x0/0x20
initcall pcibus_class_init+0x0/0x20 returned 0 after 0 msecs
calling  pci_driver_init+0x0/0x20
initcall pci_driver_init+0x0/0x20 returned 0 after 0 msecs
calling  backlight_class_init+0x0/0x60
initcall backlight_class_init+0x0/0x60 returned 0 after 0 msecs
calling  dock_init+0x0/0x5f
No dock devices found.
initcall dock_init+0x0/0x5f returned 0 after 3 msecs
calling  tty_class_init+0x0/0x40
initcall tty_class_init+0x0/0x40 returned 0 after 3 msecs
calling  vtconsole_class_init+0x0/0xf0
initcall vtconsole_class_init+0x0/0xf0 returned 0 after 0 msecs
calling  register_node_type+0x0/0x80
initcall register_node_type+0x0/0x80 returned 0 after 0 msecs
calling  amd_postcore_init+0x0/0x8d0
initcall amd_postcore_init+0x0/0x8d0 returned 0 after 0 msecs
calling  arch_kdebugfs_init+0x0/0x1f0
initcall arch_kdebugfs_init+0x0/0x1f0 returned 0 after 0 msecs
calling  mtrr_if_init+0x0/0x90
initcall mtrr_if_init+0x0/0x90 returned 0 after 0 msecs
calling  ffh_cstate_init+0x0/0x50
initcall ffh_cstate_init+0x0/0x50 returned 0 after 0 msecs
calling  acpi_pci_init+0x0/0x60
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x60 returned 0 after 3 msecs
calling  init_acpi_device_notify+0x0/0x50
initcall init_acpi_device_notify+0x0/0x50 returned 0 after 0 msecs
calling  pci_arch_init+0x0/0x60
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x60 returned 0 after 11 msecs
calling  topology_init+0x0/0x80
initcall topology_init+0x0/0x80 returned 0 after 0 msecs
calling  mtrr_init_finialize+0x0/0x50
initcall mtrr_init_finialize+0x0/0x50 returned 0 after 0 msecs
calling  param_sysfs_init+0x0/0x250
initcall param_sysfs_init+0x0/0x250 returned 0 after 22 msecs
calling  pm_sysrq_init+0x0/0x20
initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 msecs
calling  readahead_init+0x0/0x40
initcall readahead_init+0x0/0x40 returned 0 after 0 msecs
calling  init_bio+0x0/0x110
initcall init_bio+0x0/0x110 returned 0 after 0 msecs
calling  integrity_init+0x0/0x40
initcall integrity_init+0x0/0x40 returned 0 after 0 msecs
calling  blk_settings_init+0x0/0x40
initcall blk_settings_init+0x0/0x40 returned 0 after 0 msecs
calling  blk_ioc_init+0x0/0x30
initcall blk_ioc_init+0x0/0x30 returned 0 after 0 msecs
calling  genhd_device_init+0x0/0x60
initcall genhd_device_init+0x0/0x60 returned 0 after 0 msecs
calling  blk_dev_integrity_init+0x0/0x30
initcall blk_dev_integrity_init+0x0/0x30 returned 0 after 0 msecs
calling  pci_slot_init+0x0/0x50
initcall pci_slot_init+0x0/0x50 returned 0 after 0 msecs
calling  acpi_init+0x0/0x226
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using PIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Using MMCONFIG at f0000000 - f3ffffff
initcall acpi_init+0x0/0x226 returned 0 after 68 msecs
calling  acpi_scan_init+0x0/0x115
initcall acpi_scan_init+0x0/0x115 returned 0 after 26 msecs
calling  acpi_ec_init+0x0/0x66
initcall acpi_ec_init+0x0/0x66 returned 0 after 0 msecs
calling  acpi_pci_root_init+0x0/0x2d
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Scanning bus 0000:00
pci 0000:00:00.0: found [8086/277c] class 000600 header type 00
pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:01.0: found [8086/277d] class 000604 header type 01
pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1b.0: found [8086/27d8] class 000403 header type 00
PCI: 0000:00:1b.0 reg 10 64bit mmio: [50400000, 50403fff]
pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: found [8086/27d0] class 000604 header type 01
pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: found [8086/27e0] class 000604 header type 01
pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: found [8086/27e2] class 000604 header type 01
pci 0000:00:1c.5: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: found [8086/27c8] class 000c03 header type 00
PCI: 0000:00:1d.0 reg 20 io port: [4080, 409f]
pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1d.1: found [8086/27c9] class 000c03 header type 00
PCI: 0000:00:1d.1 reg 20 io port: [4060, 407f]
pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1d.2: found [8086/27ca] class 000c03 header type 00
PCI: 0000:00:1d.2 reg 20 io port: [4040, 405f]
pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1d.3: found [8086/27cb] class 000c03 header type 00
PCI: 0000:00:1d.3 reg 20 io port: [4020, 403f]
pci 0000:00:1d.3: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1d.7: found [8086/27cc] class 000c03 header type 00
PCI: 0000:00:1d.7 reg 10 32bit mmio: [50404400, 504047ff]
pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: found [8086/244e] class 000604 header type 01
pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1f.0: found [8086/27b0] class 000601 header type 00
pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1f.1: found [8086/27df] class 000101 header type 00
PCI: 0000:00:1f.1 reg 10 io port: [0, 7]
PCI: 0000:00:1f.1 reg 14 io port: [0, 3]
PCI: 0000:00:1f.1 reg 18 io port: [0, 7]
PCI: 0000:00:1f.1 reg 1c io port: [0, 3]
PCI: 0000:00:1f.1 reg 20 io port: [40b0, 40bf]
pci 0000:00:1f.1: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1f.2: found [8086/27c0] class 000101 header type 00
PCI: 0000:00:1f.2 reg 10 io port: [40c8, 40cf]
PCI: 0000:00:1f.2 reg 14 io port: [40e4, 40e7]
PCI: 0000:00:1f.2 reg 18 io port: [40c0, 40c7]
PCI: 0000:00:1f.2 reg 1c io port: [40e0, 40e3]
PCI: 0000:00:1f.2 reg 20 io port: [40a0, 40af]
PCI: 0000:00:1f.2 reg 24 32bit mmio: [50404000, 504043ff]
pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: found [8086/27da] class 000c05 header type 00
PCI: 0000:00:1f.3 reg 20 io port: [4000, 401f]
pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x40
PCI: Fixups for bus 0000:00
pci 0000:00:01.0: scanning behind bridge, config 010100, pass 0
PCI: Scanning bus 0000:01
pci 0000:01:00.0: found [1002/7249] class 000300 header type 00
pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x30
PCI: 0000:01:00.0 reg 10 32bit mmio: [40000000, 4fffffff]
PCI: 0000:01:00.0 reg 18 64bit mmio: [50300000, 5030ffff]
PCI: 0000:01:00.0 reg 20 io port: [3000, 30ff]
PCI: 0000:01:00.0 reg 30 32bit mmio: [fffe0000, ffffffff]
pci 0000:01:00.0: supports D1
pci 0000:01:00.0: supports D2
pci 0000:01:00.1: found [1002/7269] class 000380 header type 00
pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x30
PCI: 0000:01:00.1 reg 10 64bit mmio: [50310000, 5031ffff]
pci 0000:01:00.1: supports D1
pci 0000:01:00.1: supports D2
PCI: Fixups for bus 0000:01
PCI: bridge 0000:00:01.0 io port: [3000, 3fff]
PCI: bridge 0000:00:01.0 32bit mmio: [50300000, 503fffff]
PCI: bridge 0000:00:01.0 64bit mmio pref: [40000000, 4fffffff]
PCI: Bus scan for 0000:01 returning with max=01
pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 0
PCI: Scanning bus 0000:02
pci 0000:02:00.0: found [1131/7162] class 000480 header type 00
PCI: 0000:02:00.0 reg 10 64bit mmio: [50200000, 502fffff]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D0 D1 D2
pci 0000:02:00.0: PME# disabled
PCI: Fixups for bus 0000:02
PCI: bridge 0000:00:1c.0 32bit mmio: [50200000, 502fffff]
PCI: Bus scan for 0000:02 returning with max=02
pci 0000:00:1c.4: scanning behind bridge, config 030300, pass 0
PCI: Scanning bus 0000:03
PCI: Fixups for bus 0000:03
PCI: Bus scan for 0000:03 returning with max=03
pci 0000:00:1c.5: scanning behind bridge, config 040400, pass 0
PCI: Scanning bus 0000:04
pci 0000:04:00.0: found [8086/109a] class 000200 header type 00
PCI: 0000:04:00.0 reg 10 32bit mmio: [50100000, 5011ffff]
PCI: 0000:04:00.0 reg 18 io port: [2000, 201f]
pci 0000:04:00.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
PCI: Fixups for bus 0000:04
PCI: bridge 0000:00:1c.5 io port: [2000, 2fff]
PCI: bridge 0000:00:1c.5 32bit mmio: [50100000, 501fffff]
PCI: Bus scan for 0000:04 returning with max=04
pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 0
PCI: Scanning bus 0000:05
pci 0000:05:02.0: found [1814/0301] class 000280 header type 00
PCI: 0000:05:02.0 reg 10 32bit mmio: [50000000, 50007fff]
pci 0000:05:04.0: found [104c/8024] class 000c00 header type 00
PCI: 0000:05:04.0 reg 10 32bit mmio: [5000c000, 5000c7ff]
PCI: 0000:05:04.0 reg 14 32bit mmio: [50008000, 5000bfff]
pci 0000:05:04.0: supports D1
pci 0000:05:04.0: supports D2
pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:04.0: PME# disabled
pci 0000:05:05.0: found [1095/3114] class 000104 header type 00
PCI: 0000:05:05.0 reg 10 io port: [1018, 101f]
PCI: 0000:05:05.0 reg 14 io port: [1024, 1027]
PCI: 0000:05:05.0 reg 18 io port: [1010, 1017]
PCI: 0000:05:05.0 reg 1c io port: [1020, 1023]
PCI: 0000:05:05.0 reg 20 io port: [1000, 100f]
PCI: 0000:05:05.0 reg 24 32bit mmio: [5000c800, 5000cbff]
PCI: 0000:05:05.0 reg 30 32bit mmio: [fff80000, ffffffff]
pci 0000:05:05.0: supports D1
pci 0000:05:05.0: supports D2
PCI: Fixups for bus 0000:05
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [1000, 1fff]
PCI: bridge 0000:00:1e.0 32bit mmio: [50000000, 500fffff]
PCI: Bus scan for 0000:05 returning with max=05
pci 0000:00:01.0: scanning behind bridge, config 010100, pass 1
pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 1
pci 0000:00:1c.4: scanning behind bridge, config 030300, pass 1
pci 0000:00:1c.5: scanning behind bridge, config 040400, pass 1
pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 1
PCI: Bus scan for 0000:00 returning with max=05
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
initcall acpi_pci_root_init+0x0/0x2d returned 0 after 602 msecs
calling  acpi_pci_link_init+0x0/0x4d
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
initcall acpi_pci_link_init+0x0/0x4d returned 0 after 45 msecs
calling  acpi_power_init+0x0/0x7c
initcall acpi_power_init+0x0/0x7c returned 0 after 0 msecs
calling  acpi_system_init+0x0/0x26f
initcall acpi_system_init+0x0/0x26f returned 0 after 0 msecs
calling  pnp_init+0x0/0x30
Linux Plug and Play Support v0.97 (c) Adam Belay
initcall pnp_init+0x0/0x30 returned 0 after 3 msecs
calling  pnpacpi_init+0x0/0xa0
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0xa0 returned 0 after 19 msecs
calling  misc_init+0x0/0xb0
initcall misc_init+0x0/0xb0 returned 0 after 0 msecs
calling  tifm_init+0x0/0x90
initcall tifm_init+0x0/0x90 returned 0 after 0 msecs
calling  phy_init+0x0/0x50
initcall phy_init+0x0/0x50 returned 0 after 0 msecs
calling  init_scsi+0x0/0xa0
SCSI subsystem initialized
initcall init_scsi+0x0/0xa0 returned 0 after 0 msecs
calling  ata_init+0x0/0x3c0
libata version 3.00 loaded.
initcall ata_init+0x0/0x3c0 returned 0 after 3 msecs
calling  spi_init+0x0/0xa0
initcall spi_init+0x0/0xa0 returned 0 after 0 msecs
calling  init_pcmcia_cs+0x0/0x40
initcall init_pcmcia_cs+0x0/0x40 returned 0 after 0 msecs
calling  usb_init+0x0/0x120
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x120 returned 0 after 11 msecs
calling  serio_init+0x0/0xb0
initcall serio_init+0x0/0xb0 returned 0 after 0 msecs
calling  gameport_init+0x0/0xb0
initcall gameport_init+0x0/0xb0 returned 0 after 0 msecs
calling  input_init+0x0/0x130
initcall input_init+0x0/0x130 returned 0 after 0 msecs
calling  rtc_init+0x0/0x80
initcall rtc_init+0x0/0x80 returned 0 after 0 msecs
calling  hwmon_init+0x0/0x50
initcall hwmon_init+0x0/0x50 returned 0 after 3 msecs
calling  thermal_init+0x0/0x60
initcall thermal_init+0x0/0x60 returned 0 after 0 msecs
calling  leds_init+0x0/0x40
initcall leds_init+0x0/0x40 returned 0 after 0 msecs
calling  dma_bus_init+0x0/0x40
initcall dma_bus_init+0x0/0x40 returned 0 after 0 msecs
calling  ac97_bus_init+0x0/0x20
initcall ac97_bus_init+0x0/0x20 returned 0 after 0 msecs
calling  pci_subsys_init+0x0/0x140
PCI: Using ACPI for IRQ routing
initcall pci_subsys_init+0x0/0x140 returned 0 after 3 msecs
calling  proto_init+0x0/0x40
initcall proto_init+0x0/0x40 returned 0 after 0 msecs
calling  net_dev_init+0x0/0x200
initcall net_dev_init+0x0/0x200 returned 0 after 0 msecs
calling  neigh_init+0x0/0x80
initcall neigh_init+0x0/0x80 returned 0 after 0 msecs
calling  fib_rules_init+0x0/0xc0
initcall fib_rules_init+0x0/0xc0 returned 0 after 0 msecs
calling  genl_init+0x0/0xe0
initcall genl_init+0x0/0xe0 returned 0 after 15 msecs
calling  irda_init+0x0/0xc0
irda_init()
NET: Registered protocol family 23
initcall irda_init+0x0/0xc0 returned 0 after 3 msecs
calling  wireless_nlevent_init+0x0/0x50
initcall wireless_nlevent_init+0x0/0x50 returned 0 after 0 msecs
calling  cfg80211_init+0x0/0x70
initcall cfg80211_init+0x0/0x70 returned 0 after 11 msecs
calling  ieee80211_init+0x0/0x30
initcall ieee80211_init+0x0/0x30 returned 0 after 0 msecs
calling  sysctl_init+0x0/0x51
initcall sysctl_init+0x0/0x51 returned 0 after 0 msecs
calling  pci_iommu_init+0x0/0x20
PCI-GART: No AMD northbridge found.
initcall pci_iommu_init+0x0/0x20 returned 0 after 0 msecs
calling  print_all_ICs+0x0/0x520

printing PIC contents
... PIC  IMR: fdfa
... PIC  IRR: 0c00
... PIC  ISR: 0000
... PIC ELCR: 0200

printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 00050014
... APIC TASKPRI: 00000000 (00)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC ESR: 00000000
... APIC ICR: 00000200
... APIC ICR2: 01000000
... APIC LVTT: 00010000
... APIC LVTPC: 00010000
... APIC LVT0: 00001700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 00000000
... APIC TMCCT: 00000000
... APIC TDCR: 00000000

number of MP IRQ sources: 16.
testing the IO APIC.......................
IRQ to pin mappings:
.................................... done.
initcall print_all_ICs+0x0/0x520 returned 0 after 26 msecs
calling  hpet_late_init+0x0/0x1c0
BUG: unable to handle kernel NULL pointer dereference at 000000000000008c
IP: [<ffffffff80d228be>] hpet_late_init+0xfe/0x1c0
PGD 0 
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc5 #29725
RIP: 0010:[<ffffffff80d228be>]  [<ffffffff80d228be>] hpet_late_init+0xfe/0x1c0
RSP: 0018:ffff88003fa07dd0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffffc20000000160 RSI: 0000000000000000 RDI: 0000000000000003
RBP: ffff88003fa07e90 R08: 0000000000000000 R09: ffff88003fa07dd0
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88003fa07dd0
R13: 0000000000000002 R14: ffffc20000000000 R15: 000000006f57e511
FS:  0000000000000000(0000) GS:ffffffff80cf6a80(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000000008c CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88003fa06000, task ffff88003fa08000)
Stack:  00000000fed00000 ffffc20000000000 0000000100000003 0000000800000002
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff80d227c0>] ? hpet_late_init+0x0/0x1c0
 [<ffffffff80209045>] do_one_initcall+0x45/0x190
 [<ffffffff80296f39>] ? register_irq_proc+0x19/0xe0
 [<ffffffff80d0d140>] ? early_idt_handler+0x0/0x73
 [<ffffffff80d0dabc>] kernel_init+0x14c/0x1b0
 [<ffffffff80942ac1>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020dbd9>] child_rip+0xa/0x11
 [<ffffffff8020ceee>] ? restore_args+0x0/0x30
 [<ffffffff80d0d970>] ? kernel_init+0x0/0x1b0
 [<ffffffff8020dbcf>] ? child_rip+0x0/0x11
Code: 20 48 83 c1 01 48 39 f1 75 e3 44 89 e8 4c 8b 05 29 29 22 00 31 f6 48 8d 78 01 66 66 90 89 f0 48 8d 04 80 48 c1 e0 05 4a 8d 0c 00 <f6> 81 8c 00 00 00 08 74 26 8b 81 80 00 00 00 8b 91 88 00 00 00 
RIP  [<ffffffff80d228be>] hpet_late_init+0xfe/0x1c0
 RSP <ffff88003fa07dd0>
CR2: 000000000000008c
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..Press any key to enter the menu

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.27-rc5
# Sat Sep  6 14:53:11 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_BOOTPARAM_SUPPORT=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
# CONFIG_BROKEN_BOOT_ALLOWED3 is not set
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_BOOTPARAM_MAXCPUS_1=y
# CONFIG_BOOTPARAM_NOSMP is not set
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MM_OWNER=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_MARKERS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_ARCH_TRACEHOOK is not set
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_CLK is not set
CONFIG_HAVE_DYN_ARRAY=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_BOOTPARAM_NO_HZ_OFF=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_BOOTPARAM_HIGHRES_OFF is not set
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_CLOCK is not set
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL_64=y
# CONFIG_CPU_SUP_AMD_64 is not set
CONFIG_CPU_SUP_CENTAUR_64=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_SYSFS_POWER is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_WMI=m
CONFIG_ACPI_ASUS=y
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_PCI_SLOT=m
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
# CONFIG_CPU_IDLE is not set
# CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_0 is not set
# CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_1 is not set
CONFIG_BOOTPARAM_NOAPIC=y
# CONFIG_BOOTPARAM_NOLAPIC is not set
CONFIG_BOOTPARAM_NOLAPIC_TIMER=y
CONFIG_BOOTPARAM_LAPIC=y
# CONFIG_BOOTPARAM_HPET_DISABLE is not set
# CONFIG_BOOTPARAM_IDLE_MWAIT is not set
CONFIG_BOOTPARAM_IDLE_POLL=y
# CONFIG_BOOTPARAM_HIGHMEM_512M is not set
# CONFIG_BOOTPARAM_NOPAT is not set
# CONFIG_BOOTPARAM_NOTSC is not set
# CONFIG_BOOTPARAM_ACPI_OFF is not set
# CONFIG_BOOTPARAM_PCI_NOACPI is not set
CONFIG_BOOTPARAM_PCI_NOMSI=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
CONFIG_PCI_DEBUG=y
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA_DEBUG=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE=m
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IP_VS=m
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
# CONFIG_IP_VS_SH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
CONFIG_NETFILTER_XT_TARGET_TRACE=m
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=y
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
CONFIG_NETFILTER_XT_MATCH_MARK=y
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=m
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_TIME=y
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
# CONFIG_NF_CONNTRACK_IPV4 is not set
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=y
# CONFIG_IP_NF_MATCH_RECENT is not set
CONFIG_IP_NF_MATCH_ECN=m
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=y
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_ECN=y
# CONFIG_IP_NF_TARGET_TTL is not set
CONFIG_IP_NF_RAW=y
CONFIG_IP_NF_SECURITY=y
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_AH=y
CONFIG_IP6_NF_MATCH_MH=m
# CONFIG_IP6_NF_MATCH_EUI64 is not set
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set

#
# Bridge: Netfilter Configuration
#
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_IP_DCCP=y
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=y
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set
# CONFIG_IP_DCCP_TFRC_LIB is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
CONFIG_TIPC_DEBUG=y
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
# CONFIG_IPDDP_ENCAP is not set
CONFIG_IPDDP_DECAP=y
CONFIG_X25=m
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=m
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_TCPPROBE=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

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
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=m
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=y
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=y

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
# CONFIG_MAC80211_VERBOSE_MPL_DEBUG is not set
CONFIG_MAC80211_LOWTX_FRAME_DUMP=y
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
# CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG is not set
CONFIG_IEEE80211=y
CONFIG_IEEE80211_DEBUG=y
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_IEEE80211_CRYPT_CCMP=y
CONFIG_IEEE80211_CRYPT_TKIP=y
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=m
CONFIG_BLK_DEV_HD=y
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
CONFIG_EEPROM_93CX6=y
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ACER_WMI=m
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_HP_WMI=m
# CONFIG_MSI_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_INTEL_MENLOW=y
CONFIG_EEEPC_LAPTOP=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_SGI_XP is not set
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=y
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
# CONFIG_SCSI_ENCLOSURE is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=m
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
# CONFIG_MEGARAID_MAILBOX is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_SCSI_DMX3191D=m
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_SRP=y
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=y
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
CONFIG_SATA_ULI=m
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INIC162X=y
CONFIG_PATA_ACPI=y
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=m
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_CMD64X=y
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_CS5530=y
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=y
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=m
# CONFIG_PATA_HPT3X3 is not set
CONFIG_PATA_IT821X=y
CONFIG_PATA_IT8213=m
# CONFIG_PATA_JMICRON is not set
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87410=y
CONFIG_PATA_NS87415=y
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=y
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
CONFIG_PATA_SC1200=m
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=m
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=y
CONFIG_PATA_PLATFORM=y
# CONFIG_PATA_SCH is not set
# CONFIG_MD is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LAN=m
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_IEEE1394=m
# CONFIG_IEEE1394_OHCI1394 is not set
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_SBP2_PHYS_DMA=y
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VERBOSEDEBUG=y
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
CONFIG_MACVLAN=y
CONFIG_EQUALIZER=y
# CONFIG_TUN is not set
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=m
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
# CONFIG_ENC28J60 is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
# CONFIG_TULIP_NAPI_HW_MITIGATION is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
CONFIG_ULI526X=y
CONFIG_PCMCIA_XIRCOM=y
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
CONFIG_AMD8111_ETH=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
CONFIG_FEALNX=y
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=m
CONFIG_SIS900=m
# CONFIG_EPIC100 is not set
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
# CONFIG_TLAN is not set
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
# CONFIG_DE620 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000_DISABLE_PACKET_SPLIT=y
CONFIG_E1000E=y
CONFIG_IP1000=m
# CONFIG_IGB is not set
CONFIG_NS83820=y
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
# CONFIG_R8169_VLAN is not set
CONFIG_SIS190=y
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=m
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
# CONFIG_ATL1E is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=y
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
CONFIG_NETXEN_NIC=y
# CONFIG_NIU is not set
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_TEHUTI=m
CONFIG_BNX2X=m
CONFIG_SFC=m
CONFIG_TR=y
# CONFIG_IBMOL is not set
CONFIG_3C359=m
# CONFIG_TMS380TR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=m
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
# CONFIG_IPW2200_QOS is not set
CONFIG_IPW2200_DEBUG=y
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_DEBUG=y
CONFIG_AIRO=m
CONFIG_HERMES=m
CONFIG_PLX_HERMES=m
# CONFIG_TMD_HERMES is not set
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
CONFIG_RTL8180=y
# CONFIG_RTL8187 is not set
CONFIG_ADM8211=m
# CONFIG_MAC80211_HWSIM is not set
CONFIG_P54_COMMON=y
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_ATH5K=m
CONFIG_ATH5K_DEBUG=y
CONFIG_ATH9K=y
CONFIG_IWLWIFI=y
CONFIG_IWLCORE=m
# CONFIG_IWLWIFI_LEDS is not set
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLAGN is not set
CONFIG_IWL3945=y
# CONFIG_IWL3945_RFKILL is not set
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
CONFIG_IWL3945_DEBUG=y
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
CONFIG_HOSTAP_PCI=y
CONFIG_B43=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PIO=y
CONFIG_B43_LEDS=y
CONFIG_B43_DEBUG=y
CONFIG_B43_FORCE_PIO=y
# CONFIG_B43LEGACY is not set
CONFIG_ZD1211RW=y
CONFIG_ZD1211RW_DEBUG=y
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
CONFIG_PPPOL2TP=m
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=y
# CONFIG_MISDN is not set
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=y

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
CONFIG_CAPI_EICON=y
# CONFIG_ISDN_DIVAS is not set
CONFIG_PHONE=m
# CONFIG_PHONE_IXJ is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=m
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_UCB1400=y
# CONFIG_TOUCHSCREEN_WM97XX is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
CONFIG_TOUCHSCREEN_USB_3M=y
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
CONFIG_AT24=m
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
CONFIG_PCF8575=m
CONFIG_SENSORS_PCA9539=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_SENSORS_MAX6875 is not set
CONFIG_SENSORS_TSL2550=m
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_LM70_LLP=m

#
# SPI Protocol Masters
#
CONFIG_SPI_AT25=y
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_POWER_SUPPLY=m
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7473 is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_HDAPS=y
CONFIG_SENSORS_APPLESMC=m
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=y
CONFIG_SC520_WDT=y
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_HP_WATCHDOG=m
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=y
# CONFIG_WDT_501_PCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2266=m
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
# CONFIG_AGP_VIA is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI9320=m
CONFIG_LCD_VGG2432A4=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_MBP_NVIDIA=m

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FONT_8x16=y
# CONFIG_SOUND is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_USB_HIDINPUT_POWERBOOK=y
CONFIG_HID_FF=y
CONFIG_HID_PID=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_THRUSTMASTER_FF=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1760_PCI=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=m
CONFIG_USB_R8A66597_HCD=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_SIERRA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP2101 is not set
CONFIG_USB_SERIAL_CYPRESS_M8=y
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MOTOROLA=y
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_HP4X=m
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=m
# CONFIG_USB_BERRY_CHARGE is not set
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_PHIDGET=y
CONFIG_USB_PHIDGETKIT=y
# CONFIG_USB_PHIDGETMOTORCONTROL is not set
CONFIG_USB_PHIDGETSERVO=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_IPATH is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_INFINIBAND_CXGB3 is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=m
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_DMATEST=m
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_UIO is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_EFI_VARS is not set
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set

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
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=m
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=m
CONFIG_CRAMFS=y
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_KPROBES_SANITY_TEST is not set
CONFIG_BACKTRACE_SELF_TEST=m
# CONFIG_LKDTM is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACING=y
CONFIG_FTRACE=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=m
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_LEAK=y
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_64=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y

--0F1p//8PRICkK4MW--
