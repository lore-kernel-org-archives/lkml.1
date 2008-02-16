Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbYBPVyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbYBPVyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 16:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbYBPVyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 16:54:14 -0500
Received: from mga07.intel.com ([143.182.124.22]:9753 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757303AbYBPVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 16:54:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,363,1199692800"; 
   d="scan'208";a="379965802"
Message-ID: <47B75B10.3070700@linux.intel.com>
Date: Sat, 16 Feb 2008 13:52:16 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Laurent Riffard <laurent.riffard@free.fr>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, "Brown, Len" <len.brown@intel.com>
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr>
In-Reply-To: <47B7553D.5040601@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Riffard wrote:
> Le 16.02.2008 09:25, Andrew Morton a écrit :
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/ 
>>
> 
> Got this in dmesg output:
> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/ioremap.c:129 __ioremap+0xc7/0x182()
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.25-rc2-mm1 #40
> [<c0118955>] warn_on_slowpath+0x41/0x6d
> [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
> [<c01fdd89>] ? acpi_os_release_object+0x8/0xc
> [<c02188d4>] ? acpi_ut_delete_object_desc+0x39/0x3e
> [<c0217f05>] ? acpi_ut_delete_internal_obj+0x2c1/0x2c9
> [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
> [<c0131cde>] ? trace_hardirqs_on_caller+0xdf/0x100
> [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
> [<c01129c5>] __ioremap+0xc7/0x182
> [<c0112a99>] ioremap_nocache+0xa/0xc
> [<c02a6877>] acpi_os_map_memory+0x11/0x1a
> [<c020b697>] acpi_ex_system_memory_space_handler+0xd3/0x228
> [<c0203bd8>] ? acpi_ev_address_space_dispatch+0x142/0x1a8
> [<c020b5c4>] ? acpi_ex_system_memory_space_handler+0x0/0x228
> [<c0203bfd>] acpi_ev_address_space_dispatch+0x167/0x1a8
> [<c02083dd>] acpi_ex_access_region+0x1e4/0x270
> [<c02085bc>] acpi_ex_field_datum_io+0x153/0x2a1
> [<c0158ac0>] ? cache_alloc_debugcheck_after+0xe9/0x165
> [<c020879b>] acpi_ex_extract_from_field+0x91/0x224
> [<c0206bcf>] ? acpi_ex_read_data_from_field+0x163/0x1b0
> [<c0206bec>] acpi_ex_read_data_from_field+0x180/0x1b0
> [<c020d256>] acpi_ex_resolve_node_to_value+0x1aa/0x230
> [<c0207a32>] acpi_ex_resolve_to_value+0x270/0x2aa
> [<c0209e47>] acpi_ex_resolve_operands+0x24e/0x52f
> [<c0200827>] acpi_ds_exec_end_op+0xb7/0x4f4
> [<c0212d51>] acpi_ps_parse_loop+0x5e5/0x79c
> [<c02120dc>] acpi_ps_parse_aml+0xb2/0x2dd
> [<c021350c>] acpi_ps_execute_method+0x13d/0x20d
> [<c020fb72>] acpi_ns_evaluate+0x10e/0x1b0
> [<c02164ca>] acpi_ut_evaluate_object+0x57/0x1a1
> [<c02166ce>] acpi_ut_execute_STA+0x22/0x7b
> [<c0218d61>] ? acpi_ut_release_mutex+0x85/0x8f
> [<c020f45d>] acpi_ns_get_device_callback+0x5a/0x121
> [<c021173e>] acpi_ns_walk_namespace+0xfa/0x114
> [<c020f381>] acpi_get_devices+0x47/0x5d
> [<c020f403>] ? acpi_ns_get_device_callback+0x0/0x121
> [<c021ce4a>] ? ec_parse_device+0x0/0x6e
> [<c03a4460>] acpi_ec_ecdt_probe+0xaa/0x10a
> [<c03a404b>] acpi_init+0x73/0x21e
> [<c023e5bb>] ? class_create+0x4b/0x64
> [<c0390652>] kernel_init+0xa3/0x1f3
> [<c0103a4e>] ? restore_nocheck_notrace+0x0/0xe
> [<c03905af>] ? kernel_init+0x0/0x1f3
> [<c03905af>] ? kernel_init+0x0/0x1f3
> [<c01045a7>] kernel_thread_helper+0x7/0x10
> =======================
> ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> The offending code in arch/x86/mm/ioremap.c is:
> 101 static void __iomem *__ioremap(unsigned long phys_addr, unsigned 
> long size,
> 102                                enum ioremap_mode mode)
> 103 {
> ...
> 119         /*
> 120          * Don't allow anybody to remap normal RAM that we're using..
> 121          */
> 122         for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
> 123              (pfn << PAGE_SHIFT) < last_addr; pfn++) {
> 124                 if (page_is_ram(pfn) && pfn_valid(pfn) &&
> 125                     !PageReserved(pfn_to_page(pfn)))
> 126                         return NULL;
> 127         }
> 128 129         WARN_ON_ONCE(page_is_ram(pfn));
> 130
> The WARN_ON was introduced by git-agpgart.patch.
> 
> CC'd Stuart Bennett and Arjan van dev Ven.
> 
> attached: full dmesg and config.
> ~~
> laurent
> 
> 
> ------------------------------------------------------------------------
> 
> Linux version 2.6.25-rc2-mm1 (laurent@calimero) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #40 PREEMPT Sat Feb 16 21:34:19 CET 2008
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000001ffec000 (usable)
>  BIOS-e820: 000000001ffec000 - 000000001ffef000 (ACPI data)
>  BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
>  BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
>  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
> 511MB LOWMEM available.
> Scan SMP from c0000000 for 1024 bytes.
> Scan SMP from c009fc00 for 1024 bytes.
> Scan SMP from c00f0000 for 65536 bytes.
> Scan SMP from c009fc00 for 1024 bytes.
> Entering add_active_range(0, 0, 131052) 0 entries of 256 used
> sizeof(struct page) = 32
> Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->   131052
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->   131052
> On node 0 totalpages: 131052
> Node 0 memmap at 0xc1000000 size 4194304 first pfn 0xc1000000
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 4064 pages, LIFO batch:0
>   Normal zone: 991 pages used for memmap
>   Normal zone: 125965 pages, LIFO batch:31
>   Movable zone: 0 pages used for memmap
> DMI 2.3 present.
> ACPI: RSDP 000F6A80, 0014 (r0 ASUS  )
> ACPI: RSDT 1FFEC000, 002C (r1 ASUS   A7V133-C 30303031 MSFT 31313031)
> ACPI: FACP 1FFEC080, 0074 (r1 ASUS   A7V133-C 30303031 MSFT 31313031)
> ACPI: DSDT 1FFEC100, 2CE1 (r1   ASUS A7V133-C     1000 MSFT  100000B)
> ACPI: FACS 1FFFF000, 0040
> ACPI: BOOT 1FFEC040, 0028 (r1 ASUS   A7V133-C 30303031 MSFT 31313031)
> ACPI: PM-Timer IO Port: 0xe408
> Allocating PCI resources starting at 30000000 (gap: 20000000:dfff0000)
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130029
> Kernel command line: root=/dev/mapper/vglinux1-lv_ubuntu2 ro locale=fr_FR video=radeonfb:1280x1024@60 resume=/dev/mapper/vglinux1-lvswap
> Local APIC disabled by BIOS -- you can enable it with "lapic"
> mapped APIC to ffffb000 (01406000)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> Preemptible RCU implementation.
> CPU 0 irqstacks, hard=c03c6000 soft=c03c5000
> PID hash table entries: 2048 (order: 11, 8192 bytes)
> Detected 1410.240 MHz processor.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:    8
> ... MAX_LOCK_DEPTH:          30
> ... MAX_LOCKDEP_KEYS:        2048
> ... CLASSHASH_SIZE:           1024
> ... MAX_LOCKDEP_ENTRIES:     8192
> ... MAX_LOCKDEP_CHAINS:      16384
> ... CHAINHASH_SIZE:          8192
>  memory used by lock dependency info: 992 kB
>  per task-struct memory footprint: 1200 bytes
> ------------------------
> | Locking API testsuite:
> ----------------------------------------------------------------------------
>                                  | spin |wlock |rlock |mutex | wsem | rsem |
>   --------------------------------------------------------------------------
>                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>   --------------------------------------------------------------------------
>               recursive read-lock:             |  ok  |             |  ok  |
>            recursive read-lock #2:             |  ok  |             |  ok  |
>             mixed read-write-lock:             |  ok  |             |  ok  |
>             mixed write-read-lock:             |  ok  |             |  ok  |
>   --------------------------------------------------------------------------
>      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
>      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
>      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
>      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
>        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
>        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
>          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
>          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
>          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
>          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
>       hard-irq read-recursion/123:  ok  |
>       soft-irq read-recursion/123:  ok  |
>       hard-irq read-recursion/132:  ok  |
>       soft-irq read-recursion/132:  ok  |
>       hard-irq read-recursion/213:  ok  |
>       soft-irq read-recursion/213:  ok  |
>       hard-irq read-recursion/231:  ok  |
>       soft-irq read-recursion/231:  ok  |
>       hard-irq read-recursion/312:  ok  |
>       soft-irq read-recursion/312:  ok  |
>       hard-irq read-recursion/321:  ok  |
>       soft-irq read-recursion/321:  ok  |
> -------------------------------------------------------
> Good, all 218 testcases passed! |
> ---------------------------------
> Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> Memory: 510712k/524208k available (1723k kernel code, 12936k reserved, 895k data, 200k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
>     vmalloc : 0xe0800000 - 0xfffb3000   ( 503 MB)
>     lowmem  : 0xc0000000 - 0xdffec000   ( 511 MB)
>       .init : 0xc0390000 - 0xc03c2000   ( 200 kB)
>       .data : 0xc02aecc8 - 0xc038eca0   ( 895 kB)
>       .text : 0xc0100000 - 0xc02aecc8   (1723 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> CPA: page pool initialized 16 of 16 pages preallocated
> Calibrating delay using timer specific routine.. 2824.66 BogoMIPS (lpj=5649325)
> Mount-cache hash table entries: 512
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 256K (64 bytes/line)
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> Compat vDSO mapped to ffffe000.
> CPU: AMD Athlon(TM) XP 1600+ stepping 02
> Checking 'hlt' instruction... OK.
> Freeing SMP alternatives: 0k freed
> ACPI: Core revision 20070126
> Parsing all Control Methods:
> Table [DSDT](id 0001) - 356 Objects with 38 Devices 115 Methods 24 Regions
>  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
> ACPI: setting ELCR to 0200 (from 0820)
> evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
> khelper used greatest stack depth: 3144 bytes left
> net_namespace: 304 bytes
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> khelper used greatest stack depth: 3032 bytes left
> PCI: PCI BIOS revision 2.10 entry at 0xf1180, last bus=1
> PCI: Using configuration type 1
> Setting up standard PCI resources
> evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on int 0x9
> evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 4 Wake, Enabled 0 Runtime GPEs in this block
> ACPI: EC: Look up EC in DSDT
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/ioremap.c:129 __ioremap+0xc7/0x182()
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.25-rc2-mm1 #40
>  [<c0118955>] warn_on_slowpath+0x41/0x6d
>  [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
>  [<c01fdd89>] ? acpi_os_release_object+0x8/0xc
>  [<c02188d4>] ? acpi_ut_delete_object_desc+0x39/0x3e
>  [<c0217f05>] ? acpi_ut_delete_internal_obj+0x2c1/0x2c9
>  [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
>  [<c0131cde>] ? trace_hardirqs_on_caller+0xdf/0x100
>  [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
>  [<c01129c5>] __ioremap+0xc7/0x182
>  [<c0112a99>] ioremap_nocache+0xa/0xc
>  [<c02a6877>] acpi_os_map_memory+0x11/0x1a
>  [<c020b697>] acpi_ex_system_memory_space_handler+0xd3/0x228
>  [<c0203bd8>] ? acpi_ev_address_space_dispatch+0x142/0x1a8
>  [<c020b5c4>] ? acpi_ex_system_memory_space_handler+0x0/0x228
>  [<c0203bfd>] acpi_ev_address_space_dispatch+0x167/0x1a8
>  [<c02083dd>] acpi_ex_access_region+0x1e4/0x270
>  [<c02085bc>] acpi_ex_field_datum_io+0x153/0x2a1
>  [<c0158ac0>] ? cache_alloc_debugcheck_after+0xe9/0x165
>  [<c020879b>] acpi_ex_extract_from_field+0x91/0x224
>  [<c0206bcf>] ? acpi_ex_read_data_from_field+0x163/0x1b0
>  [<c0206bec>] acpi_ex_read_data_from_field+0x180/0x1b0
>  [<c020d256>] acpi_ex_resolve_node_to_value+0x1aa/0x230
>  [<c0207a32>] acpi_ex_resolve_to_value+0x270/0x2aa
>  [<c0209e47>] acpi_ex_resolve_operands+0x24e/0x52f

Len: This WARN_ON says that ACPI is trying to call ioremap() on memory that the e820_table
lists as "kernel owned". Do you know why ACPI would do this? Would ACPI get upset if
the kernel would tell it to take a hike?
