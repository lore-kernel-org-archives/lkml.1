Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbXI1ClT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbXI1ClT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 22:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760015AbXI1ClG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 22:41:06 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50505 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755631AbXI1ClC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 22:41:02 -0400
Message-ID: <390947257.08622@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 28 Sep 2007 10:40:54 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
Message-ID: <20070928024054.GA14457@mail.ustc.edu.cn>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 02:22:20AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/
 
Laurent,

It triggered a WARNING on first run in qemu:

[    0.310000] WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
[    0.310000]
[    0.310000] Call Trace:
[    0.310000]  [<ffffffff8100dbde>] dump_trace+0x3ee/0x4a0
[    0.310000]  [<ffffffff8100dcd3>] show_trace+0x43/0x70
[    0.310000]  [<ffffffff8100dd15>] dump_stack+0x15/0x20
[    0.310000]  [<ffffffff8101cd44>] smp_call_function_mask+0x94/0xa0
[    0.310000]  [<ffffffff8101cd69>] smp_call_function+0x19/0x20
[    0.310000]  [<ffffffff8104277f>] on_each_cpu+0x1f/0x50
[    0.310000]  [<ffffffff81026eac>] global_flush_tlb+0x8c/0x110
[    0.310000]  [<ffffffff81025c85>] free_init_pages+0xe5/0xf0
[    0.310000]  [<ffffffff81549b5e>] alternative_instructions+0x7e/0x150
[    0.310000]  [<ffffffff8154a2ea>] check_bugs+0x1a/0x20
[    0.310000]  [<ffffffff81540c4a>] start_kernel+0x2da/0x380
[    0.310000]  [<ffffffff81540132>] _sinittext+0x132/0x140


Here is the more complete log:

[    0.000000] Linux version 2.6.23-rc8-mm2 (wfg@intel) (gcc version 4.2.1 (Debian 4.2.1-5)) #3 SMP Fri Sep 28 10:29:34 CST 2007
[    0.000000] Command line: root=/dev/hda rw console=ttyS0 clock=pit init=/bin/bash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000039ff0000 (usable)
[    0.000000]  BIOS-e820: 0000000039ff0000 - 000000003a000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI not present or invalid.
[    0.000000] ACPI: RSDP 000FAA30, 0014 (r0 BOCHS )
[    0.000000] ACPI: RSDT 39FF0000, 002C (r0 BOCHS  BXPCRSDT        1 BXPC        1)
[    0.000000] ACPI: FACP 39FF002C, 0074 (r0 BOCHS  BXPCFACP        1 BXPC        1)
[    0.000000] ACPI: DSDT 39FF0100, 0832 (r1   BXPC   BXDSDT        1 INTL 20060912)
[    0.000000] ACPI: FACS 39FF00C0, 0040
[    0.000000] ACPI: APIC 39FF0938, 0040 (r0 BOCHS  BXPCAPIC        1 BXPC        1)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000039ff0000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000039ff0000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   237552
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3a000000:c5fc0000)
[    0.000000] .eh_frame_hdr for 'kernel' present but unusable
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 429480 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 231879
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/hda rw console=ttyS0 clock=pit init=/bin/bash
[    0.000000] Warning! clock= boot option is deprecated. Use clocksource=xyz
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] time.c: Detected 2932.892 MHz processor.
[    0.020000] console [kgdb0] enabled
[    0.030000] Console: colour VGA+ 80x25
[    0.040000] console [ttyS0] enabled
[    0.050000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.050000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.050000] ... MAX_LOCK_DEPTH:          30
[    0.050000] ... MAX_LOCKDEP_KEYS:        2048
[    0.050000] ... CLASSHASH_SIZE:           1024
[    0.050000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.050000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.050000] ... CHAINHASH_SIZE:          8192
[    0.050000]  memory used by lock dependency info: 1712 kB
[    0.050000]  per task-struct memory footprint: 2160 bytes
[    0.050000] Checking aperture...
[    0.100000] Memory: 905832k/950208k available (3018k kernel code, 43988k reserved, 2171k data, 720k init)
[    0.100000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=16, CPUs=1, Nodes=1
[    0.250000] Calibrating delay using timer specific routine.. 5880.64 BogoMIPS (lpj=29403242)
[    0.250000] kswapd reclaim order set to 3
[    0.250000] Security Framework initialized
[    0.250000] SELinux:  Initializing.
[    0.250000] selinux_register_security:  Registering secondary module capability
[    0.250000] Capability LSM initialized as secondary
[    0.260000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.260000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.260000] Mount-cache hash table entries: 256
[    0.310000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.310000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.310000] CPU 0/0 -> Node 0
[    0.310000] SMP alternatives: switching to UP code
[    0.310000] Freeing SMP alternatives: 25k freed
[    0.310000] WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
[    0.310000]
[    0.310000] Call Trace:
[    0.310000]  [<ffffffff8100dbde>] dump_trace+0x3ee/0x4a0
[    0.310000]  [<ffffffff8100dcd3>] show_trace+0x43/0x70
[    0.310000]  [<ffffffff8100dd15>] dump_stack+0x15/0x20
[    0.310000]  [<ffffffff8101cd44>] smp_call_function_mask+0x94/0xa0
[    0.310000]  [<ffffffff8101cd69>] smp_call_function+0x19/0x20
[    0.310000]  [<ffffffff8104277f>] on_each_cpu+0x1f/0x50
[    0.310000]  [<ffffffff81026eac>] global_flush_tlb+0x8c/0x110
[    0.310000]  [<ffffffff81025c85>] free_init_pages+0xe5/0xf0
[    0.310000]  [<ffffffff81549b5e>] alternative_instructions+0x7e/0x150
[    0.310000]  [<ffffffff8154a2ea>] check_bugs+0x1a/0x20
[    0.310000]  [<ffffffff81540c4a>] start_kernel+0x2da/0x380
[    0.310000]  [<ffffffff81540132>] _sinittext+0x132/0x140
[    0.310000]
[    0.320000] ACPI: Core revision 20070126
[    0.570000] Using local APIC timer interrupts.
[    0.590000] Detected 62.496 MHz APIC timer.
[    0.590000] Brought up 1 CPUs
[    0.610000] khelper used greatest stack depth: 5040 bytes left
[    0.620000] net_namespace: 144 bytes
[    0.633319] NET: Registered protocol family 16
[    0.646198] ACPI: bus type pci registered
[    0.646757] PCI: Using configuration type 1
[    0.666362] khelper used greatest stack depth: 4528 bytes left

