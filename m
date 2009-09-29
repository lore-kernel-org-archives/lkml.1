Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZI2KR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZI2KR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZI2KR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:17:29 -0400
Received: from home.kolivas.org ([59.167.196.135]:34468 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZI2KR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:17:27 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Stack corruption on 2.6.31 [with KVM]
Date: Tue, 29 Sep 2009 20:18:12 +1000
User-Agent: KMail/1.9.9
References: <200909270816.10832.con@kolivas.org>
In-Reply-To: <200909270816.10832.con@kolivas.org>
Cc: avi@redhat.com, kvm@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909292018.12989.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with a couple of extra CCs.

Only extra details I guess were debian stable with kvm that reports itself as:
QEMU PC emulator version 0.9.1 (kvm-72), Copyright (c) 2003-2008 Fabrice 
Bellard

Note that I get this stack corruption *every time*, and it must be with 
the -no-kvm option.

Con


On Sun, 27 Sep 2009 08:16:10 you wrote:
> Hi I've had a stack corruption error on 2.6.31 on x86_64 kvm
> with the following options:
>
> kvm -smp 4 -kernel arch/x86/boot/bzImage -s -append
> "console=ttyS0,serial=115200" -nographic -no-kvm
>
> list *get_random_int+0xa5
> 0xffffffff812d5e85 is in get_random_int
> (/home/con/kernel/linux-2.6.31/drivers/char/random.c:1678). 1673           
> int ret;
> 1674
> 1675            keyptr = get_keyptr();
> 1676            hash[0] += current->pid + jiffies + get_cycles();
> 1677
> 1678            ret = half_md4_transform(hash, keyptr->secret);
> 1679            put_cpu_var(get_random_int_hash);
> 1680
> 1681            return ret;
> 1682    }
>
> dmesg follows:
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Linux version 2.6.31 (con@duo) (gcc version 4.3.2 (Debian
> 4.3.2-1.1) ) #132 SMP PREEMPT Sun Sep 27 08:05:33 EST 2009 [    0.000000]
> Command line: console=ttyS0,serial=115200
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
> [    0.000000]  BIOS-e820: 0000000007ff0000 - 0000000008000000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000fffbd000 - 0000000100000000 (reserved)
> [    0.000000] DMI 2.4 present.
> [    0.000000] last_pfn = 0x7ff0 max_arch_pfn = 0x400000000
> [    0.000000] x86 PAT enabled: cpu 0, old 0x0, new 0x7010600070106
> [    0.000000] CPU MTRRs all blank - virtualized system.
> [    0.000000] init_memory_mapping: 0000000000000000-0000000007ff0000
> [    0.000000] ACPI: RSDP 00000000000fb6c0 00014 (v00 QEMU  )
> [    0.000000] ACPI: RSDT 0000000007ff0000 0002C (v01 QEMU   QEMURSDT
> 00000001 QEMU 00000001) [    0.000000] ACPI: FACP 0000000007ff002c 00074
> (v01 QEMU   QEMUFACP 00000001 QEMU 00000001) [    0.000000] ACPI: DSDT
> 0000000007ff0100 0253C (v01   BXPC   BXDSDT 00000001 INTL 20061109) [   
> 0.000000] ACPI: FACS 0000000007ff00c0 00040
> [    0.000000] ACPI: APIC 0000000007ff2640 000E0 (v01 QEMU   QEMUAPIC
> 00000001 QEMU 00000001) [    0.000000] (6 early reservations) ==> bootmem
> [0000000000 - 0007ff0000] [    0.000000]   #0 [0000000000 - 0000001000]  
> BIOS data page ==> [0000000000 - 0000001000] [    0.000000]   #1
> [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000] [ 
>   0.000000]   #2 [0001000000 - 0005e3d7f0]    TEXT DATA BSS ==> [0001000000
> - 0005e3d7f0] [    0.000000]   #3 [000009fc00 - 0000100000]    BIOS
> reserved ==> [000009fc00 - 0000100000] [    0.000000]   #4 [0005e3e000 -
> 0005e3e065]              BRK ==> [0005e3e000 - 0005e3e065] [    0.000000]  
> #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
> [    0.000000] found SMP MP-table at [ffff8800000fb540] fb540
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00100000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x00007ff0
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI
> 0-23 [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high
> level) [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
> level) [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10
> high level) [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq
> 11 high level) [    0.000000] Using ACPI (MADT) for SMP configuration
> information [    0.000000] SMP: Allowing 16 CPUs, 12 hotplug CPUs
> [    0.000000] Allocating PCI resources starting at 8000000 (gap:
> 8000000:f7fbd000) [    0.000000] NR_CPUS:4096 nr_cpumask_bits:16
> nr_cpu_ids:16 nr_node_ids:1 [    0.000000] PERCPU: Embedded 29 pages at
> ffff880005e44000, static data 88068 bytes [    0.000000] Built 1 zonelists
> in Zone order, mobility grouping on.  Total pages: 32043 [    0.000000]
> Kernel command line: console=ttyS0,serial=115200
> [    0.000000] PID hash table entries: 512 (order: 9, 4096 bytes)
> [    0.000000] Dentry cache hash table entries: 16384 (order: 5, 131072
> bytes) [    0.000000] Inode-cache hash table entries: 8192 (order: 4, 65536
> bytes) [    0.000000] Initializing CPU#0
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 46164k/131008k available (4175k kernel code, 388k
> absent, 84296k reserved, 4702k data, 496k init) [    0.000000] Preemptible
> RCU implementation.
> [    0.000000] NR_IRQS:4352
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2994.555 MHz processor.
> [    0.000999] Console: colour VGA+ 80x25
> [    0.000999] console [ttyS0] enabled
> [    0.000999] allocated 1310720 bytes of page_cgroup
> [    0.000999] please try 'cgroup_disable=memory' option if you don't want
> memory cgroups [    0.003746] Calibrating delay loop (skipped), value
> calculated using timer frequency.. 5989.11 BogoMIPS (lpj=2994555) [   
> 0.012668] Mount-cache hash table entries: 256
> [    0.027415] Initializing cgroup subsys debug
> [    0.029469] Initializing cgroup subsys ns
> [    0.031396] Initializing cgroup subsys memory
> [    0.034332] Initializing cgroup subsys devices
> [    0.036344] Initializing cgroup subsys freezer
> [    0.040324] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
> bytes/line) [    0.042295] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.044654] mce: CPU supports 0 MCE banks
> [    0.046705] Performance Counters: AMD PMU driver.
> [    0.048461] ... version:                 0
> [    0.049237] ... bit width:               48
> [    0.050252] ... generic counters:        4
> [    0.051377] ... value mask:              0000ffffffffffff
> [    0.052243] ... max period:              00007fffffffffff
> [    0.053237] ... fixed-purpose counters:  0
> [    0.055175] ... counter mask:            000000000000000f
> [    0.070354] ACPI: Core revision 20090521
> [    0.114687] ftrace: converting mcount calls to 0f 1f 44 00 00
> [    0.115305] ftrace: allocating 15638 entries in 62 pages
> [    0.125980] BUG: unable to handle kernel paging request at
> ffffffff00000001 [    0.125980] IP: [<ffffffff00000001>] 0xffffffff00000001
> [    0.125980] PGD 1003067 PUD 0
> [    0.125980] Thread overran stack, or stack corrupted
> [    0.125980] Oops: 0010 [#1] PREEMPT SMP
> [    0.125980] last sysfs file:
> [    0.125980] CPU 0
> [    0.125980] Modules linked in:
> [    0.125980] Pid: 0, comm: swapper Not tainted 2.6.31 #132
> [    0.125980] RIP: 0010:[<ffffffff00000001>]  [<ffffffff00000001>]
> 0xffffffff00000001 [    0.125980] RSP: 0018:ffffffff815efc98  EFLAGS:
> f3115292
> [    0.125980] RAX: 00000000f3115290 RBX: 0000000000000000 RCX:
> 00000000bb3e4f15 [    0.125980] RDX: 00000000406f1caf RSI: ffffffff85e30744
> RDI: ffff880005e563b0 [    0.125980] RBP: ffffffff815efcc8 R08:
> 000000004e37d069 R09: 00000000614fede7 [    0.125980] R10: 0000000000000000
> R11: 0000000000000000 R12: 0000000000000000 [    0.125980] R13:
> 0000000000000000 R14: 0000000000000000 R15: 0000000000000000 [    0.125980]
> FS:  0000000000000000(0000) GS:ffff880005e44000(0000)
> knlGS:0000000000000000 [    0.125980] CS:  0010 DS: 0018 ES: 0018 CR0:
> 000000008005003b
> [    0.125980] CR2: ffffffff00000001 CR3: 0000000001001000 CR4:
> 00000000000006f0 [    0.125980] DR0: 0000000000000000 DR1: 0000000000000000
> DR2: 0000000000000000 [    0.125980] DR3: 0000000000000000 DR6:
> 0000000000000000 DR7: 0000000000000000 [    0.125980] Process swapper (pid:
> 0, threadinfo ffffffff815ee000, task ffffffff817214c0) [    0.125980]
> Stack:
> [    0.125980]  0000000000000000 0000000000000000 ffff880006fc2040
> ffffffff817214c0 [    0.125980] <0> 0000000000800b00 0000000000000000
> ffffffff815efd28 ffffffff812d5e85 [    0.125980] <0> ffff880005e563b0
> 00000000817d7140 00000000fffb6c9a ffffffff85e30740 [    0.125980] Call
> Trace:
> [    0.125980]  [<ffffffff812d5e85>] get_random_int+0xa5/0xf0
> [    0.125980]  [<ffffffff81053899>] copy_process+0x1a9/0x1390
> [    0.125980]  [<ffffffff81054b0a>] do_fork+0x8a/0x420
> [    0.125980]  [<ffffffff81012841>] ? restore_args+0x0/0x30
> [    0.125980]  [<ffffffff81012ea2>] kernel_thread+0x82/0xe0
> [    0.125980]  [<ffffffff818c2da3>] ? kernel_init+0x0/0x1ea
> [    0.125980]  [<ffffffff81012f00>] ? child_rip+0x0/0x20
> [    0.125980]  [<ffffffff813fab0c>] ? rest_init+0x1c/0x80
> [    0.125980]  [<ffffffff818c3625>] start_kernel+0x3ea/0x4b0
> [    0.125980]  [<ffffffff818c2ac9>] x86_64_start_reservations+0x99/0xb9
> [    0.125980]  [<ffffffff818c2bee>] x86_64_start_kernel+0x105/0x120
> [    0.125980]  [<ffffffff818c2950>] ? early_idt_handler+0x0/0x71
> [    0.125980] Code:  Bad RIP value.
> [    0.125980] RIP  [<ffffffff00000001>] 0xffffffff00000001
> [    0.125980]  RSP <ffffffff815efc98>
> [    0.125980] CR2: ffffffff00000001
> [    0.125980] ---[ end trace a7919e7f17c0a725 ]---
> [    0.125980] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.125980] Pid: 0, comm: swapper Tainted: G      D    2.6.31 #132
> [    0.125980] Call Trace:
> [    0.125980]  [<ffffffff8140d6c8>] panic+0xaf/0x176
> [    0.125980]  [<ffffffff8140d7fb>] ? printk+0x6c/0x71
> [    0.125980]  [<ffffffff81059b86>] do_exit+0x736/0x800
> [    0.125980]  [<ffffffff81016a03>] oops_end+0xa3/0xb0
> [    0.125980]  [<ffffffff81036bf0>] no_context+0xf0/0x260
> [    0.125980]  [<ffffffff81036eb5>] __bad_area_nosemaphore+0x155/0x1f0
> [    0.125980]  [<ffffffff810ce0c2>] ? get_page_from_freelist+0x212/0x650
> [    0.125980]  [<ffffffff81036f63>] bad_area_nosemaphore+0x13/0x20
> [    0.125980]  [<ffffffff810373a6>] do_page_fault+0x276/0x320
> [    0.125980]  [<ffffffff814115a5>] page_fault+0x25/0x30
> [    0.125980]  [<ffffffff812d5e85>] get_random_int+0xa5/0xf0
> [    0.125980]  [<ffffffff81053899>] copy_process+0x1a9/0x1390
> [    0.125980]  [<ffffffff81054b0a>] do_fork+0x8a/0x420
> [    0.125980]  [<ffffffff81012841>] ? restore_args+0x0/0x30
> [    0.125980]  [<ffffffff81012ea2>] kernel_thread+0x82/0xe0
> [    0.125980]  [<ffffffff818c2da3>] ? kernel_init+0x0/0x1ea
> [    0.125980]  [<ffffffff81012f00>] ? child_rip+0x0/0x20
> [    0.125980]  [<ffffffff813fab0c>] ? rest_init+0x1c/0x80
> [    0.125980]  [<ffffffff818c3625>] start_kernel+0x3ea/0x4b0
> [    0.125980]  [<ffffffff818c2ac9>] x86_64_start_reservations+0x99/0xb9
> [    0.125980]  [<ffffffff818c2bee>] x86_64_start_kernel+0x105/0x120
> [    0.125980]  [<ffffffff818c2950>] ? early_idt_handler+0x0/0x71
> [    0.125980] general protection fault: fff2 [#2] PREEMPT SMP
> [    0.125980] last sysfs file:
> [    0.125980] CPU 0
> [    0.125980] Modules linked in:
> [    0.125980] Pid: 0, comm: swapper Tainted: G      D    2.6.31 #132
> [    0.125980] RIP: 0010:[<ffffffff8140d700>]  [<ffffffff8140d700>]
> panic+0xe7/0x176 [    0.125980] RSP: 0018:ffffffff815ef8e8  EFLAGS:
> f3101246
> [    0.125980] RAX: 0000000000000000 RBX: ffffffff8154b7a8 RCX:
> ffff880005e54688 [    0.125980] RDX: 0000000000000000 RSI: 0000000000000000
> RDI: 00000000f3101046 [    0.125980] RBP: ffffffff815ef9c8 R08:
> 0000000000000000 R09: 0000000000000000 [    0.125980] R10: 000000000000000a
> R11: 0000000000000000 R12: ffffffff817214c0 [    0.125980] R13:
> ffffffff00000001 R14: ffffffff817214c0 R15: 00000000f3101092 [    0.125980]
> FS:  0000000000000000(0000) GS:ffff880005e44000(0000)
> knlGS:0000000000000000 [    0.125980] CS:  0010 DS: 0018 ES: 0018 CR0:
> 000000008005003b
> [    0.125980] CR2: ffffffff00000001 CR3: 0000000001001000 CR4:
> 00000000000006f0 [    0.125980] DR0: 0000000000000000 DR1: 0000000000000000
> DR2: 0000000000000000 [    0.125980] DR3: 0000000000000000 DR6:
> 0000000000000000 DR7: 0000000000000000 [    0.125980] Process swapper (pid:
> 0, threadinfo ffffffff815ee000, task ffffffff817214c0) [    0.125980]
> Stack:
> [    0.125980]  0000003000000008 ffffffff815ef9d8 ffffffff815ef908
> 0000000000000000 [    0.125980] <0> 0000000000000000 00000000f3101086
> 0000000000000000 0000000000000000 [    0.125980] <0> 00000000ffffffff
> 0000000000000000 ffffffff817214c0 00000000f3101092 [    0.125980] Call
> Trace:
> [    0.125980]  [<ffffffff8140d7fb>] ? printk+0x6c/0x71
> [    0.125980]  [<ffffffff81059b86>] do_exit+0x736/0x800
> [    0.125980]  [<ffffffff81016a03>] oops_end+0xa3/0xb0
> [    0.125980]  [<ffffffff81036bf0>] no_context+0xf0/0x260
> [    0.125980]  [<ffffffff81036eb5>] __bad_area_nosemaphore+0x155/0x1f0
> [    0.125980]  [<ffffffff810ce0c2>] ? get_page_from_freelist+0x212/0x650
> [    0.125980]  [<ffffffff81036f63>] bad_area_nosemaphore+0x13/0x20
> [    0.125980]  [<ffffffff810373a6>] do_page_fault+0x276/0x320
> [    0.125980]  [<ffffffff814115a5>] page_fault+0x25/0x30
> [    0.125980]  [<ffffffff812d5e85>] get_random_int+0xa5/0xf0
> [    0.125980]  [<ffffffff81053899>] copy_process+0x1a9/0x1390
> [    0.125980]  [<ffffffff81054b0a>] do_fork+0x8a/0x420
> [    0.125980]  [<ffffffff81012841>] ? restore_args+0x0/0x30
> [    0.125980]  [<ffffffff81012ea2>] kernel_thread+0x82/0xe0
> [    0.125980]  [<ffffffff818c2da3>] ? kernel_init+0x0/0x1ea
> [    0.125980]  [<ffffffff81012f00>] ? child_rip+0x0/0x20
> [    0.125980]  [<ffffffff813fab0c>] ? rest_init+0x1c/0x80
> [    0.125980]  [<ffffffff818c3625>] start_kernel+0x3ea/0x4b0
> [    0.125980]  [<ffffffff818c2ac9>] x86_64_start_reservations+0x99/0xb9
> [    0.125980]  [<ffffffff818c2bee>] x86_64_start_kernel+0x105/0x120
> [    0.125980]  [<ffffffff818c2950>] ? early_idt_handler+0x0/0x71
> [    0.125980] Code: 9a 81 48 c7 c7 20 b0 74 81 e8 2d 88 c6 ff 48 83 3d d5
> 81 59 00 00 74 3b 8b 35 d5 81 59 00 85 f6 7f 3e e8 34 8f ca ff fb 66 66 90
> <66> 66 90 45 31 e4 e8 15 e6 c8 ff 4c 89 e7 ff 15 ac 81 59 00 bf [   
> 0.125980] RIP  [<ffffffff8140d700>] panic+0xe7/0x176
> [    0.125980]  RSP <ffffffff815ef8e8>
> [    0.125980] ---[ end trace a7919e7f17c0a726 ]---
> [    0.125980] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.125980] Pid: 0, comm: swapper Tainted: G      D    2.6.31 #132
> [    0.125980] Call Trace:
> [    0.125980]  [<ffffffff8140d6c8>] panic+0xaf/0x176
> [    0.125980]  [<ffffffff8140d7fb>] ? printk+0x6c/0x71
> [    0.125980]  [<ffffffff814110e4>] ? _spin_unlock_irqrestore+0x34/0x70
> [    0.125980]  [<ffffffff81059b86>] do_exit+0x736/0x800
> [    0.125980]  [<ffffffff81016a03>] oops_end+0xa3/0xb0
> [    0.125980]  [<ffffffff81016c3b>] die+0x5b/0x90
> [    0.125980]  [<ffffffff81013cf8>] do_general_protection+0x158/0x160
> [    0.125980]  [<ffffffff81411575>] general_protection+0x25/0x30
> [    0.125980]  [<ffffffff8140d700>] ? panic+0xe7/0x176
> [    0.125980]  [<ffffffff8140d6fc>] ? panic+0xe3/0x176
> [    0.125980]  [<ffffffff8140d7fb>] ? printk+0x6c/0x71
> [    0.125980]  [<ffffffff81059b86>] do_exit+0x736/0x800
> [    0.125980]  [<ffffffff81016a03>] oops_end+0xa3/0xb0
> [    0.125980]  [<ffffffff81036bf0>] no_context+0xf0/0x260
> [    0.125980]  [<ffffffff81036eb5>] __bad_area_nosemaphore+0x155/0x1f0
> [    0.125980]  [<ffffffff810ce0c2>] ? get_page_from_freelist+0x212/0x650
> [    0.125980]  [<ffffffff81036f63>] bad_area_nosemaphore+0x13/0x20
> [    0.125980]  [<ffffffff810373a6>] do_page_fault+0x276/0x320
> [    0.125980]  [<ffffffff814115a5>] page_fault+0x25/0x30
> [    0.125980]  [<ffffffff812d5e85>] get_random_int+0xa5/0xf0
> [    0.125980]  [<ffffffff81053899>] copy_process+0x1a9/0x1390
> [    0.125980]  [<ffffffff81054b0a>] do_fork+0x8a/0x420
> [    0.125980]  [<ffffffff81012841>] ? restore_args+0x0/0x30
> [    0.125980]  [<ffffffff81012ea2>] kernel_thread+0x82/0xe0
> [    0.125980]  [<ffffffff818c2da3>] ? kernel_init+0x0/0x1ea
> [    0.125980]  [<ffffffff81012f00>] ? child_rip+0x0/0x20
> [    0.125980]  [<ffffffff813fab0c>] ? rest_init+0x1c/0x80
> [    0.125980]  [<ffffffff818c3625>] start_kernel+0x3ea/0x4b0
> [    0.125980]  [<ffffffff818c2ac9>] x86_64_start_reservations+0x99/0xb9
> [    0.125980]  [<ffffffff818c2bee>] x86_64_start_kernel+0x105/0x120
> [    0.125980]  [<ffffffff818c2950>] ? early_idt_handler+0x0/0x71
>
> ---
>
> Config follows
-- 
-ck
