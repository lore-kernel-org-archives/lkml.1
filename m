Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0APLW7 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985Ab0APLW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:22:58 -0500
Received: from authsmtp-0-3.virt.iitsp.net ([66.197.161.151]:39143 "EHLO
	authsmtp-0-3.virt.iitsp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab0APLWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:22:54 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jan 2010 06:22:54 EST
Message-ID: <4B519F14.7020104@lbsd.net>
Date: Sat, 16 Jan 2010 11:12:20 +0000
From: Nigel Kukard <nkukard@lbsd.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091201 IceDove/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] kernel 2.6.33-rc4 OOPS's with large initramfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Generating a initramfs with the following, one of about 30Mb, one of 77Mb.
find . | cpio -o -H newc > ../initramfs.cpio

Only difference is adding of more files to the 77Mb image.

It makes no difference if its compiled into kernel or used as initrd.
Compression types makes no difference either.

Tested on 2.6.32.3->2.6.33-rc4 , all fail with the below.

The 30Mb initramfs loads fine, the 77Mb image throws the following...


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.33-rc4 (root@fileserver1) (gcc version
4.1.2)
#5 SMP Fri Jan 15 09:46:48 GMT 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
[    0.000000]  BIOS-e820: 000000001fff0000 - 0000000020000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or
disabled in BIOS!
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x1fff0 max_arch_pfn = 0x100000
[    0.000000] PAT not supported by CPU.
[    0.000000] found SMP MP-table at [c00fbc90] fbc90
[    0.000000] init_memory_mapping: 0000000000000000-000000001fff0000
[    0.000000] ACPI: RSDP 000fbdb0 00014 (v00 QEMU  )
[    0.000000] ACPI: RSDT 1fff0000 00034 (v01 QEMU   QEMURSDT 00000001 QEMU
00000001)
[    0.000000] ACPI: FACP 1fff01b4 00074 (v01 QEMU   QEMUFACP 00000001 QEMU
00000001)
[    0.000000] ACPI: DSDT 1fff0280 01DD4 (v01   BXPC   BXDSDT 00000001 INTL
20061109)
[    0.000000] ACPI: FACS 1fff0240 00040
[    0.000000] ACPI: SSDT 1fff2054 009E3 (v01   BXPC   BXSSDT 00000001 INTL
20061109)
[    0.000000] ACPI: APIC 1fff2a38 000EA (v01 QEMU   QEMUAPIC 00000001 QEMU
00000001)
[    0.000000] ACPI: HPET 1fff2b90 00038 (v01 QEMU   QEMUHPET 00000001 QEMU
00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 511MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1fff0000
[    0.000000]   low ram: 0 - 1fff0000
[    0.000000]   node 0 low ram: 00000000 - 1fff0000
[    0.000000]   node 0 bootmap 00003000 - 00007000
[    0.000000] (12 early reservations) ==> bootmem [0000000000 - 001fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000
- 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000
- 0000002000]
[    0.000000]   #2 [0000100000 - 0000f68064]    TEXT DATA BSS ==>
[0000100000
- 0000f68064]
[    0.000000]   #3 [0000f69000 - 0000f6e03d]              BRK ==>
[0000f69000
- 0000f6e03d]
[    0.000000]   #4 [00000fbca0 - 0000100000]    BIOS reserved ==>
[00000fbca0
- 0000100000]
[    0.000000]   #5 [00000fbc90 - 00000fbca0]     MP-table mpf ==>
[00000fbc90
- 00000fbca0]
[    0.000000]   #6 [000009fc00 - 00000fba90]    BIOS reserved ==>
[000009fc00
- 00000fba90]
[    0.000000]   #7 [00000fbc84 - 00000fbc90]    BIOS reserved ==>
[00000fbc84
- 00000fbc90]
[    0.000000]   #8 [00000fba90 - 00000fbc84]     MP-table mpc ==>
[00000fba90
- 00000fbc84]
[    0.000000]   #9 [0000002000 - 0000003000]       TRAMPOLINE ==>
[0000002000
- 0000003000]
[    0.000000]   #10 [0000007000 - 0000008000]          PGTABLE ==>
[0000007000
- 0000008000]
[    0.000000]   #11 [0000003000 - 0000007000]          BOOTMAP ==>
[0000003000
- 0000007000]
[    0.000000] kvm-clock: cpu 0, msr 0:f271c1, boot clock
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001fff0
[    0.000000]   HighMem  0x0001fff0 -> 0x0001fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001fff0
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 16 Processors exceeds NR_CPUS limit of 8
[    0.000000] SMP: Allowing 8 CPUs, 7 hotplug CPUs
[    0.000000] Allocating PCI resources starting at 20000000 (gap:
20000000:dffbc000)
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8
nr_node_ids:1
[    0.000000] PERCPU: Embedded 15 pages/cpu @c1800000 s39832 r0 d21608
u524288
[    0.000000] pcpu-alloc: s39832 r0 d21608 u524288 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] kvm-clock: cpu 0, msr 0:18091c1, primary cpu clock
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total
pages: 129935
[    0.000000] Kernel command line: console=ttyS0,9600 console=tty0
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072
bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 2621120 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want
memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 500784k/524224k available (2733k kernel code, 22344k
reserved, 1024k data, 10736k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1d000 - 0xfffff000   ( 904 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xe07f0000 - 0xff7fe000   ( 496 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
[    0.000000]       .init : 0xc13ac000 - 0xc1e28000   (10736 kB)
[    0.000000]       .data : 0xc03ab5f5 - 0xc04ab6a8   (1024 kB)
[    0.000000]       .text : 0xc0100000 - 0xc03ab5f5   (2733 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor
mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=8,
Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Detected 1828.529 MHz processor.
[    0.020000] Calibrating delay loop (skipped) preset value.. 3657.05
BogoMIPS
(lpj=18285290)
[    0.020000] Security Framework initialized
[    0.020032] Smack:  Initializing.
[    0.022240] Mount-cache hash table entries: 512
[    0.025428] Initializing cgroup subsys cpuacct
[    0.028007] Initializing cgroup subsys memory
[    0.030035] Initializing cgroup subsys devices
[    0.032634] Initializing cgroup subsys freezer
[    0.036267] Initializing cgroup subsys net_cls
[    0.040041] mce: CPU supports 0 MCE banks
[    0.042806] Performance Events: unsupported p6 CPU model 2 no PMU driver,
software events only.
[    0.055976] SMP alternatives: switching to UP code
[    0.322827] ACPI: Core revision 20091214
[    0.329907] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.330007] CPU0: Intel QEMU Virtual CPU version 0.11.1 stepping 03
[    0.340000] Brought up 1 CPUs
[    0.340000] Total of 1 processors activated (3657.05 BogoMIPS).
[    0.340000] regulator: core version 0.5
[    0.340284] NET: Registered protocol family 16
[    0.343444] ACPI: bus type pci registered
[    0.346393] PCI: PCI BIOS revision 2.10 entry at 0xfb490, last bus=0
[    0.350033] PCI: Using configuration type 1 for base access
[    0.355808] bio: create slab <bio-0> at 0
[    0.362518] ACPI: Interpreter enabled
[    0.364864] ACPI: (supports S0 S5)
[    0.367471] ACPI: Using IOAPIC for interrupt routing
[    0.377905] ACPI: No dock devices found.
[    0.380523] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.383461] pci_root PNP0A03:00: ignoring host bridge windows from ACPI;
boot with "pci=use_crs" to use them
[    0.392298] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4
ACPI
[    0.396788] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4
SMB
[    0.421097] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.425444] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.429650] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.432403] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.436758] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.440024] vgaarb: loaded
[    0.442477] SCSI subsystem initialized
[    0.450418] PCI: Using ACPI for IRQ routing
[    0.453798] NetLabel: Initializing
[    0.456105] NetLabel:  domain hash size = 128
[    0.458682] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.460070] NetLabel:  unlabeled traffic allowed by default
[    0.464020] Switching to clocksource kvm-clock
[    0.467031] pnp: PnP ACPI init
[    0.467031] ACPI: bus type pnp registered
[    0.467521] pnp: PnP ACPI: found 7 devices
[    0.470070] ACPI: ACPI bus type pnp unregistered
[    0.508374] NET: Registered protocol family 2
[    0.511236] IP route cache hash table entries: 4096 (order: 2, 16384
bytes)
[    0.515250] TCP established hash table entries: 16384 (order: 5, 131072
bytes)
[    0.521677] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    0.525452] TCP: Hash tables configured (established 16384 bind 16384)
[    0.528961] TCP reno registered
[    0.531166] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.534275] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.537731] NET: Registered protocol family 1
[    0.540379] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.543566] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.546671] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    3.863208] audit: initializing netlink socket (disabled)
[    3.866275] type=2000 audit(1263549857.860:1): initialized
[    3.869907] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    3.876874] VFS: Disk quotas dquot_6.5.2
[    3.879913] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.884297] msgmni has been set to 979
[    3.887022] alg: No test for stdrng (krng)
[    3.890719] io scheduler noop registered (default)
[    3.897588] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.901437] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.905633] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.911430] brd: module loaded
[    3.913818] Fixed MDIO Bus: probed
[    3.916286] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at
0x60,0x64 irq
1,12
[    3.923278] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.926128] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.929215] mice: PS/2 mouse device common for all mice
[    3.932485] EDAC MC: Ver: 2.1.0 Jan 15 2010
[    3.935876] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    3.941223] cpuidle: using governor ladder
[    3.943892] cpuidle: using governor menu
[    3.946865] NET: Registered protocol family 10
[    3.950308] lo: Disabled Privacy Extensions
[    3.953570] Mobile IPv6
[    3.955609] NET: Registered protocol family 17
[    3.958400] Using IPI No-Shortcut mode
[    3.961645] Freeing unused kernel memory: 10736k freed
[    3.964699] BUG: Bad page state in process swapper  pfn:1f4c9
[    3.967779] page:c13ea920 flags:cccccccc count:-858993460
mapcount:-858993459 mapping:cccccccc index:cccccccc
[    3.970793] Pid: 1, comm: swapper Not tainted 2.6.33-rc4 #5
[    3.970793] Call Trace:
[    3.970793]  [<c0184632>] bad_page+0xa2/0x120
[    3.970793]  [<c0184733>] destroy_compound_page+0x83/0x90
[    3.970793]  [<c0184af2>] free_pcppages_bulk+0x1f2/0x200
[    3.970793]  [<c0184ef1>] free_hot_cold_page+0x171/0x1e0
[    3.970793]  [<c0184f9a>] free_hot_page+0xa/0x10
[    3.970793]  [<c0185137>] __free_pages+0x27/0x30
[    3.970793]  [<c0185168>] free_pages+0x28/0x30
[    3.970793]  [<c0121e2f>] free_init_pages+0x9f/0xc0
[    3.970793]  [<c0121e87>] free_initmem+0x17/0x20
[    3.970793]  [<c01011e0>] init_post+0x10/0x110
[    3.970793]  [<c04ac74a>] kernel_init+0x1aa/0x1d0
[    3.970793]  [<c04ac5a0>] ? kernel_init+0x0/0x1d0
[    3.970793]  [<c0103176>] kernel_thread_helper+0x6/0x30
[    3.970793] Disabling lock debugging due to kernel taint
[    3.970793] BUG: Bad page state in process swapper  pfn:1f025
[    3.970793] page:c13e14a0 flags:cccccccc count:-858993460
mapcount:-858993459 mapping:cccccccc index:cccccccc
[    3.970793] Pid: 1, comm: swapper Tainted: G    B      2.6.33-rc4 #5
[    3.970793] Call Trace:
[    3.970793]  [<c0184632>] bad_page+0xa2/0x120
[    3.970793]  [<c0184733>] destroy_compound_page+0x83/0x90
[    3.970793]  [<c0184af2>] free_pcppages_bulk+0x1f2/0x200
[    3.970793]  [<c0184ef1>] free_hot_cold_page+0x171/0x1e0
[    3.970793]  [<c0184f9a>] free_hot_page+0xa/0x10
[    3.970793]  [<c0185137>] __free_pages+0x27/0x30
[    3.970793]  [<c0185168>] free_pages+0x28/0x30
[    3.970793]  [<c0121e2f>] free_init_pages+0x9f/0xc0
[    3.970793]  [<c0121e87>] free_initmem+0x17/0x20
[    3.970793]  [<c01011e0>] init_post+0x10/0x110
[    3.970793]  [<c04ac74a>] kernel_init+0x1aa/0x1d0
[    3.970793]  [<c04ac5a0>] ? kernel_init+0x0/0x1d0
[    3.970793]  [<c0103176>] kernel_thread_helper+0x6/0x30
[    3.970793] BUG: unable to handle kernel paging request at 00100104
[    3.970793] IP: [<c0184a01>] free_pcppages_bulk+0x101/0x200
[    3.970793] *pde = 00000000
[    3.970793] Oops: 0002 [#1] SMP
[    3.970793] last sysfs file:
[    3.970793] Modules linked in:
[    3.970793]
[    3.970793] Pid: 1, comm: swapper Tainted: G    B      2.6.33-rc4 #5 /
[    3.970793] EIP: 0060:[<c0184a01>] EFLAGS: 00010093 CPU: 0
[    3.970793] EIP is at free_pcppages_bulk+0x101/0x200
[    3.970793] EAX: c13ea938 EBX: c10381f8 ECX: 00100100 EDX: 00200200
[    3.970793] ESI: c04a6f94 EDI: c13ea920 EBP: df84cf44 ESP: df84cf14
[    3.970793]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    3.970793] Process swapper (pid: 1, ti=df84c000 task=df850000
task.ti=df84c000)
[    3.970793] Stack:
[    3.970793]  c04a6d80 0000001c c04a6d40 00000001 00000001 c13ea920
c04a6d94
00000001
[    3.970793] <0> 00000001 c04a6d9c c1028e00 c04a6d80 df84cf70 c0184ef1
00001c00 c0486f08
[    3.970793] <0> 00000000 c04a6d40 00000000 00000297 c13f1000 c13ac000
c1e28000 df84cf78
[    3.970793] Call Trace:
[    3.970793]  [<c0184ef1>] ? free_hot_cold_page+0x171/0x1e0
[    3.970793]  [<c0184f9a>] ? free_hot_page+0xa/0x10
[    3.970793]  [<c0185137>] ? __free_pages+0x27/0x30
[    3.970793]  [<c0185168>] ? free_pages+0x28/0x30
[    3.970793]  [<c0121e2f>] ? free_init_pages+0x9f/0xc0
[    3.970793]  [<c0121e87>] ? free_initmem+0x17/0x20
[    3.970793]  [<c01011e0>] ? init_post+0x10/0x110
[    3.970793]  [<c04ac74a>] ? kernel_init+0x1aa/0x1d0
[    3.970793]  [<c04ac5a0>] ? kernel_init+0x0/0x1d0
[    3.970793]  [<c0103176>] ? kernel_thread_helper+0x6/0x30
[    3.970793] Code: 00 ff 4d d4 0f 84 f7 00 00 00 ff 4d e0 74 8a 8b 4d
e8 3b
09 0f 84 7f ff ff ff 8b 4d e8 8b 41 04 8d 78 e8 89 7d e4 8b 08 8b 50 04
<89> 51
04 89 0a f7 40 e8 00 c0 00 00 c7 00 00 01 10 00 c7 40 04
[    3.970793] EIP: [<c0184a01>] free_pcppages_bulk+0x101/0x200 SS:ESP
0068:df84cf14
[    3.970793] CR2: 0000000000100104
[    3.970793] ---[ end trace cd0813fc9ca17764 ]---
[    4.212708] BUG: unable to handle kernel NULL pointer dereference at
00000084
[    4.216649] IP: [<c01a9bde>] kfree+0x5e/0xd0
[    4.219385] *pde = 00000000
[    4.221798] Oops: 0000 [#2] SMP
[    4.222675] last sysfs file:
[    4.222675] Modules linked in:
[    4.222675]
[    4.222675] Pid: 1, comm: swapper Tainted: G    B D    2.6.33-rc4 #5 /
[    4.222675] EIP: 0060:[<c01a9bde>] EFLAGS: 00010086 CPU: 0
[    4.222675] EIP is at kfree+0x5e/0xd0
[    4.222675] EAX: 00000000 EBX: cccccccc ECX: df081ff4 EDX: 00000000
[    4.222675] ESI: 00000286 EDI: df081fe0 EBP: c1801f80 ESP: c1801f60
[    4.222675]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    4.222675] Process swapper (pid: 1, ti=c1801000 task=df850000
task.ti=df84c000)
[    4.222675] Stack:
[    4.222675]  00000202 c1805c20 c0488240 c014edd5 00000000 df081fe0
c1805c20
00000001
[    4.222675] <0> c1801f8c c014edd5 df081f94 c1801fb4 c0175f69 00000286
00000000 c1805c38
[    4.222675] <0> c0488240 df8a4c18 00000001 00000024 00000009 c1801fbc
c017616f c1801ff8
[    4.222675] Call Trace:
[    4.222675]  [<c014edd5>] ? release_tgcred_rcu+0x25/0x30
[    4.222675]  [<c014edd5>] ? release_tgcred_rcu+0x25/0x30
[    4.222675]  [<c0175f69>] ? __rcu_process_callbacks+0xe9/0x2d0
[    4.222675]  [<c017616f>] ? rcu_process_callbacks+0x1f/0x40
[    4.222675]  [<c013a660>] ? __do_softirq+0x90/0x120
[    4.222675]  [<c013a5d0>] ? __do_softirq+0x0/0x120
[    4.222675]  <IRQ>
[    4.222675]  [<c013a5c6>] ? irq_exit+0x66/0x70
[    4.222675]  [<c011933e>] ? smp_apic_timer_interrupt+0x5e/0x90
[    4.222675]  [<c03aa87a>] ? apic_timer_interrupt+0x2a/0x30
[    4.222675]  [<c01606f7>] ? acct_collect+0xf7/0x130
[    4.222675]  [<c01384d1>] ? do_exit+0x101/0x690
[    4.222675]  [<c0136b0c>] ? kmsg_dump+0x10c/0x150
[    4.222675]  [<c01360cb>] ? printk+0x1b/0x20
[    4.222675]  [<c010623f>] ? oops_end+0xbf/0xc0
[    4.222675]  [<c01360cb>] ? printk+0x1b/0x20
[    4.222675]  [<c012246e>] ? no_context+0x11e/0x150
[    4.222675]  [<c0122599>] ? __bad_area_nosemaphore+0x49/0x150
[    4.222675]  [<c01063c8>] ? show_trace_log_lvl+0x48/0x60
[    4.222675]  [<c0122742>] ? bad_area_nosemaphore+0x12/0x20
[    4.222675]  [<c0122b1c>] ? do_page_fault+0x1ac/0x330
[    4.222675]  [<c0122970>] ? do_page_fault+0x0/0x330
[    4.222675]  [<c03aab16>] ? error_code+0x66/0x70
[    4.222675]  [<c018007b>] ? sys_readahead+0x3b/0xa0
[    4.222675]  [<c0122970>] ? do_page_fault+0x0/0x330
[    4.222675]  [<c0184a01>] ? free_pcppages_bulk+0x101/0x200
[    4.222675]  [<c0184ef1>] ? free_hot_cold_page+0x171/0x1e0
[    4.222675]  [<c0184f9a>] ? free_hot_page+0xa/0x10
[    4.222675]  [<c0185137>] ? __free_pages+0x27/0x30
[    4.222675]  [<c0185168>] ? free_pages+0x28/0x30
[    4.222675]  [<c0121e2f>] ? free_init_pages+0x9f/0xc0
[    4.222675]  [<c0121e87>] ? free_initmem+0x17/0x20
[    4.222675]  [<c01011e0>] ? init_post+0x10/0x110
[    4.222675]  [<c04ac74a>] ? kernel_init+0x1aa/0x1d0
[    4.222675]  [<c04ac5a0>] ? kernel_init+0x0/0x1d0
[    4.222675]  [<c0103176>] ? kernel_thread_helper+0x6/0x30
[    4.222675] Code: 85 c0 75 74 84 d2 79 77 8b 45 04 89 45 ec 8b 53 0c
89 55
f0 9c 58 8d 74 26 00 89 c6 fa 90 8d 74 26 00 8b 55 f0 64 a1 f0 29 f2 c0
<8b> 8c
82 84 00 00 00 3b 59 04 74 2e 8b 41 0c 89 da 89 f9 89 44
[    4.222675] EIP: [<c01a9bde>] kfree+0x5e/0xd0 SS:ESP 0068:c1801f60
[    4.222675] CR2: 0000000000000084
[    4.222675] ---[ end trace cd0813fc9ca17765 ]---
[    4.222675] Kernel panic - not syncing: Fatal exception in interrupt
[    4.222675] Pid: 1, comm: swapper Tainted: G    B D    2.6.33-rc4 #5
[    4.222675] Call Trace:
[    4.222675]  [<c0135337>] panic+0x47/0x120
[    4.222675]  [<c0106238>] oops_end+0xb8/0xc0
[    4.222675]  [<c01360cb>] ? printk+0x1b/0x20
[    4.222675]  [<c012246e>] no_context+0x11e/0x150
[    4.222675]  [<c0122599>] __bad_area_nosemaphore+0x49/0x150
[    4.222675]  [<c0108fe6>] ? sched_clock+0x16/0x40
[    4.222675]  [<c0122742>] bad_area_nosemaphore+0x12/0x20
[    4.222675]  [<c0122b1c>] do_page_fault+0x1ac/0x330
[    4.222675]  [<c012199c>] ? pvclock_clocksource_read+0x4c/0xe0
[    4.222675]  [<c0122970>] ? do_page_fault+0x0/0x330
[    4.222675]  [<c03aab16>] error_code+0x66/0x70
[    4.222675]  [<c0122970>] ? do_page_fault+0x0/0x330
[    4.222675]  [<c01a9bde>] ? kfree+0x5e/0xd0
[    4.222675]  [<c014edd5>] ? release_tgcred_rcu+0x25/0x30
[    4.222675]  [<c014edd5>] release_tgcred_rcu+0x25/0x30
[    4.222675]  [<c0175f69>] __rcu_process_callbacks+0xe9/0x2d0
[    4.222675]  [<c017616f>] rcu_process_callbacks+0x1f/0x40
[    4.222675]  [<c013a660>] __do_softirq+0x90/0x120
[    4.222675]  [<c013a5d0>] ? __do_softirq+0x0/0x120
[    4.222675]  <IRQ>  [<c013a5c6>] ? irq_exit+0x66/0x70
[    4.222675]  [<c011933e>] ? smp_apic_timer_interrupt+0x5e/0x90
[    4.222675]  [<c03aa87a>] ? apic_timer_interrupt+0x2a/0x30
[    4.222675]  [<c01606f7>] ? acct_collect+0xf7/0x130
[    4.222675]  [<c01384d1>] ? do_exit+0x101/0x690
[    4.222675]  [<c0136b0c>] ? kmsg_dump+0x10c/0x150
[    4.222675]  [<c01360cb>] ? printk+0x1b/0x20
[    4.222675]  [<c010623f>] ? oops_end+0xbf/0xc0
[    4.222675]  [<c01360cb>] ? printk+0x1b/0x20
[    4.222675]  [<c012246e>] ? no_context+0x11e/0x150
[    4.222675]  [<c0122599>] ? __bad_area_nosemaphore+0x49/0x150
[    4.222675]  [<c01063c8>] ? show_trace_log_lvl+0x48/0x60
[    4.222675]  [<c0122742>] ? bad_area_nosemaphore+0x12/0x20
[    4.222675]  [<c0122b1c>] ? do_page_fault+0x1ac/0x330
[    4.222675]  [<c0122970>] ? do_page_fault+0x0/0x330
[    4.222675]  [<c03aab16>] ? error_code+0x66/0x70
[    4.222675]  [<c018007b>] ? sys_readahead+0x3b/0xa0
[    4.222675]  [<c0122970>] ? do_page_fault+0x0/0x330
[    4.222675]  [<c0184a01>] ? free_pcppages_bulk+0x101/0x200
[    4.222675]  [<c0184ef1>] ? free_hot_cold_page+0x171/0x1e0
[    4.222675]  [<c0184f9a>] ? free_hot_page+0xa/0x10
[    4.222675]  [<c0185137>] ? __free_pages+0x27/0x30
[    4.222675]  [<c0185168>] ? free_pages+0x28/0x30
[    4.222675]  [<c0121e2f>] ? free_init_pages+0x9f/0xc0
[    4.222675]  [<c0121e87>] ? free_initmem+0x17/0x20
[    4.222675]  [<c01011e0>] ? init_post+0x10/0x110
[    4.222675]  [<c04ac74a>] ? kernel_init+0x1aa/0x1d0
[    4.222675]  [<c04ac5a0>] ? kernel_init+0x0/0x1d0
[    4.222675]  [<c0103176>] ? kernel_thread_helper+0x6/0x30




Reproducer:
* Build initrmafs files, one of around 30Mb, one of around 80Mb, they
don't have to be compiled into kernel

* Run qemu with the following...
qemu -kernel /tmp/bzImage -initrd /tmp/initramfs.cpio  -m 512 /dev/zero
-serial
file:/tmp/serial.log -append "console=ttyS0,9600 console=tty0"



