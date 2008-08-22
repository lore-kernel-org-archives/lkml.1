Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYHVQfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYHVQfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYHVQfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:35:25 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:41454 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbYHVQfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:35:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAPqBrkhMRKxB/2dsb2JhbACBZbRvgWg
Date: Fri, 22 Aug 2008 12:35:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080822163520.GA9860@Krystal>
References: <20080820162925.75a5e064@doriath.conectiva> <48ADDF4F.2020401@zytor.com> <48AE5FCF.6030103@zytor.com> <20080822065012.GV14110@elte.hu> <20080822113941.147a1db0@doriath.conectiva> <20080822153451.GA8390@Krystal> <20080822132948.57e47076@doriath.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080822132948.57e47076@doriath.conectiva>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:34:34 up 78 days, 21:14,  6 users,  load average: 1.23, 1.16,
	0.85
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
> Em Fri, 22 Aug 2008 11:34:52 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:
> 
> | * Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
> | > Em Fri, 22 Aug 2008 08:50:12 +0200
> | > Ingo Molnar <mingo@elte.hu> escreveu:
> | > 
> | > | 
> | > | * H. Peter Anvin <hpa@zytor.com> wrote:
> | > | 
> | > | > H. Peter Anvin wrote:
> | > | >>>
> | > | >>>  Does this look like a kernel bug?
> | > | >>>
> | > | >>
> | > | >> No, it looks like a very common virtualizer bug.  Does the attached  
> | > | >> patch work for you?
> | > | >>
> | > | >
> | > | > Also, in addition to this, please try tip:master.  There is a patch in 
> | > | > tip:master which I hope should fix this problem, but the details are 
> | > | > important.
> | > | 
> | > | access coordinates would be at:
> | > | 
> | > |   http://people.redhat.com/mingo/tip.git/README
> | > 
> | >  As I already have Linus tree downloaded I have cloned it in
> | > the usual way.
> | > 
> | >  Got the same results: OOPS in virtualbox but it works on QEMU.
> | > 
> | >  The OOPS's output follows and I have attached the .config I'm using
> | > to reproduce the problem.
> | > 
> | 
> | Can you try booting with the kernel argument :
> |   debug_alternative 
> | 
> | The dmesg of the kernel bootup up to the oops would be helpful.
> | 
> | My guess is that there may be something wrong with irq disabling which
> | protects text_poke_early in apply_alternatives().
> 
>  I have attached two files:
> 
>   - normal.txt: normal boot with no debug options
>   - debug-alternative.txt ignore_loglevel and debug-alternative boot
>     options
> 
>  I had to pass ignore_loglevel otherwise it wouldn't print
> anything.
> 

Ok, now can you try booting with either of those args :

noreplace-paravirt
noreplace-smp

And see which one(s) works ?

Thanks,

Mathieu

> -- 
> Luiz Fernando N. Capitulino

> Linux version 2.6.27-rc4-test25 (lcapitulino@build1.conectiva) (gcc version 4.3.1 20080626 (prerelease) (GCC) ) #89 SMP Fri Aug 22 12:47:34 BRT 2008
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
>  BIOS-e820: 0000000007ff0000 - 0000000008000000 (ACPI data)
>  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
> last_pfn = 0x7ff0 max_arch_pfn = 0x100000
> RAMDISK: 07b9b000 - 07fbf89d
> DMI 2.5 present.
> ACPI: RSDP 000E0000, 0024 (r2 VBOX  )
> ACPI: XSDT 07FF0030, 002C (r1 VBOX   VBOXXSDT        1 ASL        61)
> ACPI: FACP 07FF0060, 00F4 (r4 VBOX   VBOXFACP        1 ASL        61)
> ACPI: DSDT 07FF01A0, 1064 (r1 VBOX   VBOXBIOS        2 INTL 20080213)
> ACPI: FACS 07FF0160, 0040
> 0MB HIGHMEM available.
> 127MB LOWMEM available.
>   mapped low ram: 0 - 07ff0000
>   low ram: 00000000 - 07ff0000
>   bootmap 00002000 - 00003000
> (9 early reservations) ==> bootmem [0000000000 - 0007ff0000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
>   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
>   #3 [0000100000 - 0000814b10]    TEXT DATA BSS ==> [0000100000 - 0000814b10]
>   #4 [0007b9b000 - 0007fbf89d]          RAMDISK ==> [0007b9b000 - 0007fbf89d]
>   #5 [0000815000 - 0000819000]    INIT_PG_TABLE ==> [0000815000 - 0000819000]
>   #6 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
>   #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
>   #8 [0000002000 - 0000003000]          BOOTMAP ==> [0000002000 - 0000003000]
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   Normal   0x00001000 -> 0x00007ff0
>   HighMem  0x00007ff0 -> 0x00007ff0
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000000 -> 0x0000009f
>     0: 0x00000100 -> 0x00007ff0
> ACPI: PM-Timer IO Port: 0x4008
> SMP: Allowing 1 CPUs, 0 hotplug CPUs
> Found and enabled local APIC!
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> Allocating PCI resources starting at 10000000 (gap: 8000000:f7fc0000)
> PERCPU: Allocating 40224 bytes of per cpu data
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32239
> Kernel command line: initrd=alt0/all.rdz vga=788 splash=silent BOOT_IMAGE=alt0/vmlinuz vga=0 console=ttyS0,9600 console=tty0
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> PID hash table entries: 512 (order: 9, 2048 bytes)
> TSC calibrated against PM_TIMER
> Detected 2410.453 MHz processor.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> console [ttyS0] enabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:    8
> ... MAX_LOCK_DEPTH:          48
> ... MAX_LOCKDEP_KEYS:        8191
> ... CLASSHASH_SIZE:           4096
> ... MAX_LOCKDEP_ENTRIES:     8192
> ... MAX_LOCKDEP_CHAINS:      16384
> ... CHAINHASH_SIZE:          8192
>  memory used by lock dependency info: 2335 kB
>  per task-struct memory footprint: 1152 bytes
> Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
> Memory: 117088k/131008k available (2340k kernel code, 13364k reserved, 1027k data, 308k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xc8800000 - 0xff7fe000   ( 879 MB)
>     lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
>       .init : 0xc0451000 - 0xc049e000   ( 308 kB)
>       .data : 0xc03493b8 - 0xc044a040   (1027 kB)
>       .text : 0xc0100000 - 0xc03493b8   (2340 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> Calibrating delay loop (skipped), value calculated using timer frequency.. 4820.90 BogoMIPS (lpj=2410453)
> Security Framework initialized
> Mount-cache hash table entries: 512
> CPU: Trace cache: 12K uops, L1 D cache: 16K
> CPU: L2 cache: 1024K
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> Checking 'hlt' instruction... OK.
> SMP alternatives: switching to UP code
> Freeing SMP alternatives: 10k freed
> ACPI: Core revision 20080609
> ACPI: setting ELCR to 0200 (from 0c00)
> weird, boot CPU (#0) not listedby the BIOS.
> SMP motherboard not detected.
> SMP disabled
> Brought up 1 CPUs
> Total of 1 processors activated (4820.90 BogoMIPS).
> khelper used greatest stack depth: 7108 bytes left
> net_namespace: 384 bytes
> Booting paravirtualized kernel on bare hardware
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: PCI BIOS revision 2.10 entry at 0xfadb0, last bus=0
> PCI: Using configuration type 1 for base access
> ACPI: Interpreter enabled
> ACPI: (supports S0 S5)
> ACPI: Using PIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> ACPI: PCI Interrupt Link [LNKA] (IRQs 5 9 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKB] (IRQs 5 9 10 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKC] (IRQs 5 9 10 *11)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 5 9 *10 11)
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> BUG: unable to handle kernel NULL pointer dereference at 00000246
> IP: [<c012fc71>] vprintk+0x181/0x440
> *pde = 00000000 
> Oops: 0002 [#1] SMP 
> Modules linked in:
> 
> Pid: 1, comm: swapper Not tainted (2.6.27-rc4-test25 #89)
> EIP: 0060:[<c012fc71>] EFLAGS: 00010246 CPU: 0
> EIP is at vprintk+0x181/0x440
> EAX: 00000246 EBX: 00000000 ECX: c012f8a9 EDX: 00003b3a
> ESI: 00000000 EDI: c04d76c1 EBP: c7435f20 ESP: c7435eac
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
> Process swapper (pid: 1, ti=c7434000 task=c7438000 task.ti=c7434000)
> Stack: 00003b3a c012f8a9 c7435f3c c02948b1 c7435f18 c02957f6 00000074 c7435ee2 
>        00000006 00000246 00000000 00000000 00000021 00000000 00000001 00000000 
>        a027c4ab a027c4c8 00000001 00000297 00000246 00000000 00000001 00000000 
> Call Trace:
>  [<c012f8a9>] ? release_console_sem+0x1c9/0x1e0
>  [<c02948b1>] ? put_device+0x11/0x20
>  [<c02957f6>] ? device_add+0x26/0x610
>  [<c0471c5c>] ? pnpacpi_init+0x0/0x89
>  [<c03450f4>] ? printk+0x18/0x1c
>  [<c0266f87>] ? register_acpi_bus_type+0x58/0x69
>  [<c0471ca5>] ? pnpacpi_init+0x49/0x89
>  [<c0101116>] ? do_one_initcall+0x26/0x170
>  [<c01e1d14>] ? create_proc_entry+0x54/0xa0
>  [<c016ef86>] ? register_irq_proc+0xb6/0xd0
>  [<c016efea>] ? init_irq_proc+0x4a/0x60
>  [<c045132d>] ? kernel_init+0x10f/0x166
>  [<c045121e>] ? kernel_init+0x0/0x166
>  [<c0104b67>] ? kernel_thread_helper+0x7/0x10
>  =======================
> Code: c0 0f 84 0b 01 00 00 b8 d0 bf 41 c0 c7 05 6c c0 41 c0 ff ff ff ff e8 7f 82 21 00 e8 1a 03 02 00 8b 45 b0 50 9d 0f 1f 84 00 00 00 <00> 00 8b 45 bc 83 c4 60 5b 5e 5f 5d c3 66 90 a1 6c c0 41 c0 e8 
> EIP: [<c012fc71>] vprintk+0x181/0x440 SS:ESP 0069:c7435eac
> ---[ end trace 4eaa2a86a8e2da22 ]---
> Kernel panic - not syncing: Attempted to kill init!

> Linux version 2.6.27-rc4-test25 (lcapitulino@build1.conectiva) (gcc version 4.3.1 20080626 (prerelease) (GCC) ) #89 SMP Fri Aug 22 12:47:34 BRT 2008
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
>  BIOS-e820: 0000000007ff0000 - 0000000008000000 (ACPI data)
>  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
> debug: ignoring loglevel setting.
> last_pfn = 0x7ff0 max_arch_pfn = 0x100000
> kernel direct mapping tables up to 7ff0000 @ 7000-d000
> RAMDISK: 07b9b000 - 07fbf89d
> DMI 2.5 present.
> ACPI: RSDP 000E0000, 0024 (r2 VBOX  )
> ACPI: XSDT 07FF0030, 002C (r1 VBOX   VBOXXSDT        1 ASL        61)
> ACPI: FACP 07FF0060, 00F4 (r4 VBOX   VBOXFACP        1 ASL        61)
> ACPI: DSDT 07FF01A0, 1064 (r1 VBOX   VBOXBIOS        2 INTL 20080213)
> ACPI: FACS 07FF0160, 0040
> 0MB HIGHMEM available.
> 127MB LOWMEM available.
>   mapped low ram: 0 - 07ff0000
>   low ram: 00000000 - 07ff0000
>   bootmap 00002000 - 00003000
> (9 early reservations) ==> bootmem [0000000000 - 0007ff0000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
>   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
>   #3 [0000100000 - 0000814b10]    TEXT DATA BSS ==> [0000100000 - 0000814b10]
>   #4 [0007b9b000 - 0007fbf89d]          RAMDISK ==> [0007b9b000 - 0007fbf89d]
>   #5 [0000815000 - 0000819000]    INIT_PG_TABLE ==> [0000815000 - 0000819000]
>   #6 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
>   #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
>   #8 [0000002000 - 0000003000]          BOOTMAP ==> [0000002000 - 0000003000]
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   Normal   0x00001000 -> 0x00007ff0
>   HighMem  0x00007ff0 -> 0x00007ff0
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000000 -> 0x0000009f
>     0: 0x00000100 -> 0x00007ff0
> On node 0 totalpages: 32655
> free_area_init_node: node 0, pgdat c041f600, node_mem_map c1000000
>   DMA zone: 3947 pages, LIFO batch:0
>   Normal zone: 28292 pages, LIFO batch:7
> ACPI: PM-Timer IO Port: 0x4008
> SMP: Allowing 1 CPUs, 0 hotplug CPUs
> Found and enabled local APIC!
> mapped APIC to ffffb000 (fee00000)
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
> PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
> Allocating PCI resources starting at 10000000 (gap: 8000000:f7fc0000)
> PERCPU: Allocating 40224 bytes of per cpu data
> NR_CPUS: 32, nr_cpu_ids: 1, nr_node_ids 1
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32239
> Kernel command line: initrd=alt0/all.rdz vga=788 splash=silent BOOT_IMAGE=alt0/vmlinuz vga=0 console=ttyS0,9600 console=tty0 ignore_loglevel debug-alternative
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> PID hash table entries: 512 (order: 9, 2048 bytes)
> TSC calibrated against PM_TIMER
> Detected 2410.976 MHz processor.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> console [ttyS0] enabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:    8
> ... MAX_LOCK_DEPTH:          48
> ... MAX_LOCKDEP_KEYS:        8191
> ... CLASSHASH_SIZE:           4096
> ... MAX_LOCKDEP_ENTRIES:     8192
> ... MAX_LOCKDEP_CHAINS:      16384
> ... CHAINHASH_SIZE:          8192
>  memory used by lock dependency info: 2335 kB
>  per task-struct memory footprint: 1152 bytes
> Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
> Memory: 117088k/131008k available (2340k kernel code, 13364k reserved, 1027k data, 308k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xc8800000 - 0xff7fe000   ( 879 MB)
>     lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
>       .init : 0xc0451000 - 0xc049e000   ( 308 kB)
>       .data : 0xc03493b8 - 0xc044a040   (1027 kB)
>       .text : 0xc0100000 - 0xc03493b8   (2340 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> CPA: page pool initialized 1 of 1 pages preallocated
> SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> Calibrating delay loop (skipped), value calculated using timer frequency.. 4821.95 BogoMIPS (lpj=2410976)
> Security Framework initialized
> Mount-cache hash table entries: 512
> CPU: Trace cache: 12K uops, L1 D cache: 16K
> CPU: L2 cache: 1024K
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> Checking 'hlt' instruction... OK.
> apply_alternatives: alt table c048afa4 -> c048f11f
> SMP alternatives: switching to UP code
> Freeing SMP alternatives: 10k freed
> ACPI: Core revision 20080609
> ACPI: setting ELCR to 0200 (from 0c00)
> weird, boot CPU (#0) not listedby the BIOS.
> SMP motherboard not detected.
> SMP disabled
> Brought up 1 CPUs
> Total of 1 processors activated (4821.95 BogoMIPS).
> BUG: unable to handle kernel NULL pointer dereference at 00000246
> IP: [<c012fc71>] vprintk+0x181/0x440
> *pde = 00000000 
> Oops: 0002 [#1] SMP 
> Modules linked in:
> 
> Pid: 1, comm: swapper Not tainted (2.6.27-rc4-test25 #89)
> EIP: 0060:[<c012fc71>] EFLAGS: 00010246 CPU: 0
> EIP is at vprintk+0x181/0x440
> EAX: 00000246 EBX: 00000000 ECX: c012f8a9 EDX: 00009695
> ESI: 00000000 EDI: c04d76d7 EBP: c7435f98 ESP: c7435f24
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
> Process swapper (pid: 1, ti=c7434000 task=c7438000 task.ti=c7434000)
> Stack: 00009695 c012f8a9 c7435fb4 0000007b c012007b 000000d8 ffffff10 c7435f5a 
>        00000006 00000246 00000000 c046902c 00000037 00000246 c03438ac c7435f7a 
>        00000006 00000246 00000000 00000000 00000015 c7435f94 c045e900 00000030 
> Call Trace:
>  [<c012f8a9>] ? release_console_sem+0x1c9/0x1e0
>  [<c012007b>] ? resched_task+0x4b/0x70
>  [<c046902c>] ? relay_init+0xd/0x11
>  [<c03438ac>] ? end_local_APIC_setup+0xb9/0xf2
>  [<c045e900>] ? prefill_possible_map+0x7/0x8a
>  [<c03450f4>] ? printk+0x18/0x1c
>  [<c045eacd>] ? native_smp_cpus_done+0x93/0xe9
>  [<c04512f3>] ? kernel_init+0xd5/0x166
>  [<c045121e>] ? kernel_init+0x0/0x166
>  [<c0104b67>] ? kernel_thread_helper+0x7/0x10
>  =======================
> Code: c0 0f 84 0b 01 00 00 b8 d0 bf 41 c0 c7 05 6c c0 41 c0 ff ff ff ff e8 7f 82 21 00 e8 1a 03 02 00 8b 45 b0 50 9d 0f 1f 84 00 00 00 <00> 00 8b 45 bc 83 c4 60 5b 5e 5f 5d c3 66 90 a1 6c c0 41 c0 e8 
> EIP: [<c012fc71>] vprintk+0x181/0x440 SS:ESP 0069:c7435f24
> ---[ end trace 4eaa2a86a8e2da22 ]---
> Kernel panic - not syncing: Attempted to kill init!


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
