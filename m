Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYHMAza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYHMAza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYHMAzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:55:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:25373 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbYHMAzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,198,1217833200"; 
   d="scan'208";a="33044450"
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
From: Zhang Rui <rui.zhang@intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
In-Reply-To: <20080812094135.GA1565@elf.ucw.cz>
References: <20080806090246.GA1572@elf.ucw.cz>
	 <87bq046cht.fsf@basil.nowhere.org>  <20080812094135.GA1565@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 08:55:04 +0800
Message-Id: <1218588904.3209.13.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 11:41 +0200, Pavel Machek wrote:
> Hi!
> 
> > > Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
> > > Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
> > > shutting down.
> > > Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt
> > >
> > > ...and machine went down at that point :-(.
> > 
> > I hope you can easily reproduce it?
> > 
> > So it's new in 2.6.27rc1 and wasn't in 2.6.26? Can you please
> 
> Yes, I'm very sure. It makes machine basically unusable.
> 
> > double check that? Are there are new warnings in the boot logs
> > from ACPI compared to .26?
> 
> Will take a look.... ... I don't see anything obvious, diff is below.
> 
> > I looked through the pile of patches that went in for ACPI and the 
> > only candidate that might have imho caused this would be 
> > ea51011a27db48ea0a80a5e20de3969b292d5d4d. Can you please 
> > try reverting that. If that doesn't help a full bisect will be needed.
> 
> Not that one :-(. Thinkpad does not even have fan device: it is
> controlled by hardware.
> 									Pavel
> 
> --- /tmp/dmesg.26	2008-08-12 11:38:44.000000000 +0200
> +++ /tmp/dmesg.rc2	2008-08-12 11:15:44.000000000 +0200
> @@ -1,4 +1,4 @@
> -Linux version 2.6.26 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #313 SMP Mon Jul 14 08:33:14 CEST 2008
> +Linux version 2.6.27-rc2 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #322 SMP Thu Aug 7 11:58:09 CEST 2008
>  PAT disabled. Not yet verified on this CPU type.
>  BIOS-provided physical RAM map:
>   BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
> @@ -16,31 +16,13 @@
>   BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
>   BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>   BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
> -1142MB HIGHMEM available.
> -896MB LOWMEM available.
> -found SMP MP-table at [c00f67f0] 000f67f0
> -Entering add_active_range(0, 0, 521936) 0 entries of 256 used
> -Zone PFN ranges:
> -  DMA             0 ->     4096
> -  Normal       4096 ->   229376
> -  HighMem    229376 ->   521936
> -Movable zone start PFN for each node
> -early_node_map[1] active PFN ranges
> -    0:        0 ->   521936
> -On node 0 totalpages: 521936
> -  DMA zone: 32 pages used for memmap
> -  DMA zone: 0 pages reserved
> -  DMA zone: 4064 pages, LIFO batch:0
> -  Normal zone: 1760 pages used for memmap
> -  Normal zone: 223520 pages, LIFO batch:31
> -  HighMem zone: 2286 pages used for memmap
> -  HighMem zone: 290274 pages, LIFO batch:31
> -  Movable zone: 0 pages used for memmap
> +last_pfn = 0x7f6d0 max_arch_pfn = 0x100000
> +kernel direct mapping tables up to 38000000 @ 7000-c000
>  DMI present.
>  ACPI: RSDP 000F67C0, 0024 (r2 LENOVO)
>  ACPI: XSDT 7F6D191C, 0084 (r1 LENOVO TP-7B        2140  LTP        0)
>  ACPI: FACP 7F6D1A00, 00F4 (r3 LENOVO TP-7B        2140 LNVO        1)
> -ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080321]
> +ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080609]
>  ACPI: DSDT 7F6D1D90, CFB9 (r1 LENOVO TP-7B        2140 MSFT  100000E)
>  ACPI: FACS 7F6F4000, 0040
>  ACPI: SSDT 7F6D1BB4, 01DC (r1 LENOVO TP-7B        2140 MSFT  100000E)
> @@ -54,6 +36,37 @@
>  ACPI: SSDT 7F6F28A4, 00A6 (r1 LENOVO TP-7B        2140 INTL 20050513)
>  ACPI: SSDT 7F6F294A, 04F7 (r1 LENOVO TP-7B        2140 INTL 20050513)
>  ACPI: SSDT 7F6F2E41, 01D8 (r1 LENOVO TP-7B        2140 INTL 20050513)
> +1142MB HIGHMEM available.
> +896MB LOWMEM available.
> +  mapped low ram: 0 - 38000000
> +  low ram: 00000000 - 38000000
> +  bootmap 00008000 - 0000f000
> +(8 early reservations) ==> bootmem [0000000000 - 0038000000]
> +  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> +  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
> +  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
> +  #3 [0000200000 - 0000c07128]    TEXT DATA BSS ==> [0000200000 - 0000c07128]
> +  #4 [0000c08000 - 0000c1d000]    INIT_PG_TABLE ==> [0000c08000 - 0000c1d000]
> +  #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
> +  #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
> +  #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
> +Scan SMP from c0000000 for 1024 bytes.
> +Scan SMP from c009fc00 for 1024 bytes.
> +Scan SMP from c00f0000 for 65536 bytes.
> +found SMP MP-table at [c00f67f0] 000f67f0
> +Zone PFN ranges:
> +  DMA      0x00000000 -> 0x00001000
> +  Normal   0x00001000 -> 0x00038000
> +  HighMem  0x00038000 -> 0x0007f6d0
> +Movable zone start PFN for each node
> +early_node_map[2] active PFN ranges
> +    0: 0x00000000 -> 0x0000009f
> +    0: 0x00000100 -> 0x0007f6d0
> +On node 0 totalpages: 521839
> +free_area_init_node: node 0, pgdat c0942e80, node_mem_map c1001000
> +  DMA zone: 3967 pages, LIFO batch:0
> +  Normal zone: 223520 pages, LIFO batch:31
> +  HighMem zone: 290274 pages, LIFO batch:31
>  ACPI: PM-Timer IO Port: 0x1008
>  ACPI: Local APIC address 0xfee00000
>  ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> @@ -70,26 +83,27 @@
>  Enabling APIC mode:  Flat.  Using 1 I/O APICs
>  ACPI: HPET id: 0x8086a201 base: 0xfed00000
>  Using ACPI (MADT) for SMP configuration information
> -Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
> +SMP: Allowing 2 CPUs, 0 hotplug CPUs
> +mapped APIC to ffffb000 (fee00000)
> +mapped IOAPIC to ffffa000 (fec00000)
>  PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
>  PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
>  PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
>  PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
>  PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
> -SMP: Allowing 2 CPUs, 0 hotplug CPUs
> -PERCPU: Allocating 37800 bytes of per cpu data
> -NR_CPUS: 2, nr_cpu_ids: 2
> -Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517858
> +Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
> +PERCPU: Allocating 37552 bytes of per cpu data
> +NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
> +Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517761
>  Kernel command line: root=/dev/sda4 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps vga=791 init=/tmp/swsusp-init acpi_sleep=s3_bios,s3_mode no_console_suspend
>  Unknown boot option `psmouse.psmouse_proto=imps': ignoring
> -mapped APIC to ffffb000 (fee00000)
> -mapped IOAPIC to ffffa000 (fec00000)
>  Enabling fast FPU save and restore... done.
>  Enabling unmasked SIMD FPU exception support... done.
>  Initializing CPU#0
>  PID hash table entries: 4096 (order: 12, 16384 bytes)
>  Extended CMOS year: 2000
> -Detected 1828.792 MHz processor.
> +TSC calibrated against PM_TIMER
> +Detected 1828.748 MHz processor.
>  Console: colour dummy device 80x25
>  console [tty0] enabled
>  Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> @@ -100,23 +114,23 @@
>  ... MAX_LOCKDEP_ENTRIES:     8192
>  ... MAX_LOCKDEP_CHAINS:      16384
>  ... CHAINHASH_SIZE:          8192
> - memory used by lock dependency info: 992 kB
> + memory used by lock dependency info: 1056 kB
>   per task-struct memory footprint: 1920 bytes
>  Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>  Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> -Memory: 2059068k/2087744k available (5320k kernel code, 27516k reserved, 2458k data, 320k init, 1170240k highmem)
> +Memory: 2058760k/2087744k available (5438k kernel code, 27692k reserved, 2511k data, 344k init, 1170240k highmem)
>  virtual kernel memory layout:
> -    fixmap  : 0xfff7f000 - 0xfffff000   ( 512 kB)
> +    fixmap  : 0xfff83000 - 0xfffff000   ( 496 kB)
>      pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>      vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
>      lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
> -      .init : 0xc09a1000 - 0xc09f1000   ( 320 kB)
> -      .data : 0xc0732166 - 0xc0998a08   (2458 kB)
> -      .text : 0xc0200000 - 0xc0732166   (5320 kB)
> +      .init : 0xc09cb000 - 0xc0a21000   ( 344 kB)
> +      .data : 0xc074fbc6 - 0xc09c38f0   (2511 kB)
> +      .text : 0xc0200000 - 0xc074fbc6   (5438 kB)
>  Checking if this processor honours the WP bit even in supervisor mode...Ok.
>  CPA: page pool initialized 32 of 32 pages preallocated
>  hpet clockevent registered
> -Calibrating delay using timer specific routine.. 3662.04 BogoMIPS (lpj=7324080)
> +Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.49 BogoMIPS (lpj=7314992)
>  Mount-cache hash table entries: 512
>  CPU: L1 I cache: 32K, L1 D cache: 32K
>  CPU: L2 cache: 2048K
> @@ -124,7 +138,7 @@
>  CPU: Processor Core ID: 0
>  using mwait in idle threads.
>  Checking 'hlt' instruction... OK.
> -ACPI: Core revision 20080321
> +ACPI: Core revision 20080609

that's weird.
ACPICA should be 20080609 in 2.6.26.
Pavel, can you please make a double check? :)

thanks,
rui

