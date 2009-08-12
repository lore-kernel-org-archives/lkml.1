Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZHLUH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZHLUH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZHLUH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:07:26 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:58812 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZHLUHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:07:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=THuEECPXmkNwKYugtLYtsydCFjQFpmnNE0Wo5xQkkHGnp+rnCKuOA/3hS3PBXSkYVV
         sMU1iWbEhoxaXzwhRDzitZO/JNdKi4/tu1srRDpXoL2JrsjWmxTpnuFCYQ+7MjYSyuxV
         0r+pH3Z/bApoSUuRSzk8XVjwlJAG+GkipxuW8=
Date: Wed, 12 Aug 2009 23:10:34 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Len Brown <len.brown@intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: acpi_ex_system_memory_space_handler oops
Message-ID: <20090812201034.GA2983@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

Kernel oopses on early boot stages (boots normally with boot_delay=3D10).

rc5-git8
eip: acpi_ex_system_memory_space_handler+0x75/0x22f
b8 08 00 00 00 eb 24 57 68 fa f8 51 c1 6a 6c 68 ac 81 4b c1 e8 ba
e8 00 00 b8 04 30 00 00 83 c4 10 e9 a4 01 00 00 b8 01 00 00 00 <8b>
53 08 89 55 d8 39 55 ec 72 4b 89 45 cc c7 45 d0 00 00 00 00

eip: acpi_ex_system_memory_space_handler+0x10a/0x2c3
9c bb db ff ba 73 00 00 00 b8 d9 f9 51 c1 e8 1d fb d9 ff ff 45 d8
83 7d d8 05 75 94 b8 04 30 00 00 e9 a4 01 00 00 b8 01 00 00 00 <8b>
53 08 89 55 c4 39 55 d8 72 4b 89 45 b8 c7 45 bc 00 00 00 00

---prev. kernel (git5 or git6)
eip: acpi_ex_system_memory_space_handler+0x75/0x22f
b8 08 00 00 00 eb 24 57 68 1a a1 51 c1 6a 6c 68 6c 30 43 c1 e8 ba
e8 00 00 b8 04 30 00 00 83 c4 10 e9 a4 01 00 00 b8 01 00 00 00 <8b>
53 08 89 55 d8 39 55 ec 72 4b 89 45 cc c7 45 d0 00 00 00 00

Happend on 0.216666 second:

=2E..???... top flushed
?acpi_ex_resolve_node_to_value+0x1db/0x244
?acpi_ex_resolve_to_value+0x221/0x26b
?acpi_ds_evaluate_name_path+0x77/0xf4
?acpi_ds_exec_end_op+0x89/049c
?acpi_ps_parse_loop+0x652/0x7cc
?acpi_ps_parse_aml+0xdd/0x3e
?acpi_ps_execute_method+0x1cd/0x2c2
?acpi_ns_evaluate+0x147/0x260
?acpi_ev_asynch_execute_gpe_method+0x111/0x16a
?acpi_os_execute_dereferred+0x2e/0x4b
?worker_thread+0x11b/0x270
?acpi_os_execute_dereferred+0x0/0x4b
?autoremove_wake_function+0x0/0x60
?worker_thread+0x0/0x270
?kthread+0x84/0x90
?kthread+0x0/0x90
?kernel_thread_helper+0x7/0x18

Something is wrong with given 'acpi_physical_address address'.

/* ...+ =3D=3D acpi_ex_system_memory_space_handler+ */

acpi_ex_system_memory_space_handler+0x75/0x22f
0x000001e1 <...+0>:	push   %ebp
0x000001e2 <...+1>:	mov    %esp,%ebp
0x000001e4 <...+3>:	push   %edi
0x000001e5 <...+4>:	mov    %ecx,%edi
0x000001e7 <...+6>:	push   %esi
0x000001e8 <...+7>:	push   %ebx
0x000001e9 <...+8>:	sub    $0x28,%esp
0x000001ec <...+11>:	mov    %eax,-0x20(%ebp)
0x000001ef <...+14>:	mov    %edx,-0x14(%ebp)
0x000001f2 <...+17>:	mov    %gs:0x14,%eax
0x000001f8 <...+23>:	mov    %eax,-0x10(%ebp)
0x000001fb <...+26>:	xor    %eax,%eax
0x000001fd <...+28>:	mov    0x8(%ebp),%esi
0x00000200 <...+31>:	mov    0x10(%ebp),%ebx
0x00000203 <...+34>:	cmp    $0x10,%ecx
0x00000206 <...+37>:	je     0x21d <...+60>
0x00000208 <...+39>:	ja     0x211 <...+48>
0x0000020a <...+41>:	cmp    $0x8,%ecx
0x0000020d <...+44>:	jne    0x232 <...+81>
0x0000020f <...+46>:	jmp    0x251 <...+112>
0x00000211 <...+48>:	cmp    $0x20,%ecx
0x00000214 <...+51>:	je     0x224 <...+67>
0x00000216 <...+53>:	cmp    $0x40,%ecx
0x00000219 <...+56>:	jne    0x232 <...+81>
0x0000021b <...+58>:	jmp    0x22b <...+74>
0x0000021d <...+60>:	mov    $0x2,%eax
0x00000222 <...+65>:	jmp    0x256 <...+117>
0x00000224 <...+67>:	mov    $0x4,%eax
0x00000229 <...+72>:	jmp    0x256 <...+117>
0x0000022b <...+74>:	mov    $0x8,%eax
0x00000230 <...+79>:	jmp    0x256 <...+117>
0x00000232 <...+81>:	push   %edi
0x00000233 <...+82>:	push   $0x77
0x00000238 <...+87>:	push   $0x6c
0x0000023a <...+89>:	push   $0x0
0x0000023f <...+94>:	call   0x240 <...+95>
0x00000244 <...+99>:	mov    $0x3004,%eax
0x00000249 <...+104>:	add    $0x10,%esp
0x0000024c <...+107>:	jmp    0x3f5 <...+532>
0x00000251 <...+112>:	mov    $0x1,%eax
0x00000256 <...+117>:	mov    0x8(%ebx),%edx		<<
0x00000259 <...+120>:	mov    %edx,-0x28(%ebp)
0x0000025c <...+123>:	cmp    %edx,-0x14(%ebp)
0x0000025f <...+126>:	jb     0x2ac <...+203>
[...]


Hardware (x86)	: ASUS f3jc
cpu family	: 6
model		: 15


dmesg ("ACPI Error/Exception")
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc5-git8 (gcc version 4.4.2 20090811 (p=
rerelease) (Debian 4.4-150647) ) #4 SMP PREEMPT Wed Aug 12 21:19:34 EEST 20=
09
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
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffa8000 (usable)
[    0.000000]  BIOS-e820: 000000003ffa8000 - 000000003ffb0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ffb0000 - 000000003ffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffbe000 - 0000000040000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around =
it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0x3ffa8 max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003ffa8000 (usable)
[    0.000000]  modified: 000000003ffa8000 - 000000003ffb0000 (ACPI NVS)
[    0.000000]  modified: 000000003ffb0000 - 000000003ffbe000 (ACPI data)
[    0.000000]  modified: 000000003ffbe000 - 0000000040000000 (ACPI NVS)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffb80000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
[    0.000000] RAMDISK: 37b21000 - 37fef8de
[    0.000000] Allocated new RAMDISK: 00100000 - 005ce8de
[    0.000000] Move RAMDISK from 0000000037b21000 - 0000000037fef8dd to 001=
00000 - 005ce8dd
[    0.000000] ACPI: RSDP 000f7af0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 3ffb0000 00040 (v01 _ASUS_ Notebook 02000715 MSFT=
 00000097)
[    0.000000] ACPI: FACP 3ffb0200 00084 (v02 AMI    OEMFACP  02000715 MSFT=
 00000097)
[    0.000000] ACPI: DSDT 3ffb05e0 08918 (v01  F3J00 F3J00001 00000001 INTL=
 02002026)
[    0.000000] ACPI: FACS 3ffbe000 00040
[    0.000000] ACPI: APIC 3ffb0390 0005C (v01 AMI    OEMAPIC  02000715 MSFT=
 00000097)
[    0.000000] ACPI: MCFG 3ffb03f0 0003C (v01 AMI    OEMMCFG  02000715 MSFT=
 00000097)
[    0.000000] ACPI: BOOT 3ffb05b0 00028 (v01 AMI    OEMBOOT  02000715 MSFT=
 00000097)
[    0.000000] ACPI: SLIC 3ffb0430 00176 (v01 _ASUS_ Notebook 02000715 MSFT=
 00000097)
[    0.000000] ACPI: OEMB 3ffbe040 00046 (v01 AMI    AMI_OEM  02000715 MSFT=
 00000097)
[    0.000000] ACPI: HPET 3ffb8f00 00038 (v01 AMI        ASUS 02000715 MSFT=
 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 135MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00011000 - 00017f00
[    0.000000] (9 early reservations) =3D=3D> bootmem [0000000000 - 00377fe=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [000=
0001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00016a9098]    TEXT DATA BSS =3D=3D> [000=
1000000 - 00016a9098]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000=
009fc00 - 0000100000]
[    0.000000]   #5 [00016aa000 - 00016b11cd]              BRK =3D=3D> [000=
16aa000 - 00016b11cd]
[    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE =3D=3D> [000=
0010000 - 0000011000]
[    0.000000]   #7 [0000100000 - 00005ce8de]      NEW RAMDISK =3D=3D> [000=
0100000 - 00005ce8de]
[    0.000000]   #8 [0000011000 - 0000018000]          BOOTMAP =3D=3D> [000=
0011000 - 0000018000]
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003ffa8
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003ffa8
[    0.000000] On node 0 totalpages: 261943
[    0.000000] free_area_init_node: node 0, pgdat c159bcc0, node_mem_map c1=
6b2200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 272 pages used for memmap
[    0.000000]   HighMem zone: 34458 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000001=
00000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000=
:bee00000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages at c1eb7000, static data 34116 byt=
es
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 259895
[    0.000000] Kernel command line: root=3DUUID=3Dd44dd563-a831-40b0-9bfd-f=
460c9430ffa ro=20
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0003ffa8)
[    0.000000] Memory: 1026552k/1048224k available (4144k kernel code, 2091=
6k reserved, 1689k data, 408k init, 138920k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff91000 - 0xfffff000   ( 440 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc15ba000 - 0xc1620000   ( 408 kB)
[    0.000000]       .data : 0xc140c2d6 - 0xc15b2968   (1689 kB)
[    0.000000]       .text : 0xc1000000 - 0xc140c2d6   (4144 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1597.682 MHz processor.
[    0.002672] Console: colour VGA+ 80x25
[    0.002676] console [tty0] enabled
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.003333] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 3196.50 BogoMIPS (lpj=3D5325606)
[    0.003333] Security Framework initialized
[    0.003333] Mount-cache hash table entries: 512
[    0.003333] Initializing cgroup subsys ns
[    0.003333] Initializing cgroup subsys cpuacct
[    0.003333] Initializing cgroup subsys devices
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] CPU0: Thermal monitoring handled by SMI
[    0.003333] using mwait in idle threads.
[    0.003333] Performance Counters: Core2 events, Intel PMU driver.
[    0.003333] ... version:                 2
[    0.003333] ... bit width:               40
[    0.003333] ... generic counters:        2
[    0.003333] ... value mask:              000000ffffffffff
[    0.003333] ... max period:              000000007fffffff
[    0.003333] ... fixed-purpose counters:  3
[    0.003333] ... counter mask:            0000000700000003
[    0.003333] Checking 'hlt' instruction... OK.
[    0.013975] ACPI: Core revision 20090521
[    0.033782] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.068294] CPU0: Intel(R) Core(TM)2 CPU         T5200  @ 1.60GHz steppi=
ng 06
[    0.069999] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 3197.98 Bog=
oMIPS (lpj=3D5326372)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] CPU1: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.161930] CPU1: Intel(R) Core(TM)2 CPU         T5200  @ 1.60GHz steppi=
ng 06
[    0.162895] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.163365] Brought up 2 CPUs
[    0.163451] Total of 2 processors activated (6393.48 BogoMIPS).
[    0.163596] CPU0 attaching sched-domain:
[    0.163600]  domain 0: span 0-1 level MC
[    0.163604]   groups: 0 1
[    0.163610] CPU1 attaching sched-domain:
[    0.166670]  domain 0: span 0-1 level MC
[    0.166674]   groups: 1 0
[    0.166879] NET: Registered protocol family 16
[    0.166879] ACPI: bus type pci registered
[    0.166879] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.166879] PCI: Not using MMCONFIG.
[    0.167174] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D6
[    0.167265] PCI: Using configuration type 1 for base access
[    0.173389] bio: create slab <bio-0> at 0
[    0.178672] ACPI: EC: Look up EC in DSDT
[    0.197047] ACPI: Interpreter enabled
[    0.197142] ACPI: (supports S0 S1 S3 S4 S5)
[    0.197558] ACPI: Using IOAPIC for interrupt routing
[    0.197724] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.205668] ACPI Error (dswload-0790): [PCFG] Namespace lookup failure, =
AE_ALREADY_EXISTS
[    0.205899] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/catalo=
g 20090521 psloop-227
[    0.206124] ACPI Error (psparse-0537): Method parse/execution failed [\_=
SB_.RBPE] (Node f7017678), AE_ALREADY_EXISTS
[    0.206417] ACPI: Marking method RBPE as Serialized because of AE_ALREAD=
Y_EXISTS error
[    0.206773] ACPI Error (psparse-0537): Method parse/execution failed [\_=
SB_.PCI0.P0P4.XCRD._STA] (Node f7015648), AE_ALREADY_EXISTS
[    0.207070] ACPI: Marking method _STA as Serialized because of AE_ALREAD=
Y_EXISTS error
[    0.207326] ACPI Error (uteval-0256): Method execution failed [\_SB_.PCI=
0.P0P4.XCRD._STA] (Node f7015648), AE_ALREADY_EXISTS
[    0.213503] ACPI Error: Could not map memory at 0000000000000000, size 0=
 20090521 exregion-173
[    0.213734] ACPI Exception: AE_NO_MEMORY, Returned by Handler for [Syste=
mMemory] 20090521 evregion-424
[    0.213963] ACPI Error (psparse-0537): Method parse/execution failed [\_=
SB_.RBPE] (Node f7017678), AE_NO_MEMORY
[    0.214286] ACPI Error (psparse-0537): Method parse/execution failed [\_=
GPE._L01] (Node f701d198), AE_NO_MEMORY
[    0.214616] ACPI Exception: AE_NO_MEMORY, while evaluating GPE method [_=
L01] 20090521 evgpe-568
[    0.216428] PCI: MCFG area at e0000000 reserved in ACPI motherboard reso=
urces
[    0.216523] PCI: updated MCFG configuration 0: base e0000000 segment 0 b=
uses 0 - 63
[    0.216627] PCI: Using MMCONFIG for extended config space
[    0.227058] ACPI: EC: GPE =3D 0x1c, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.227152] ACPI: EC: driver started in poll mode
[    0.230233] ACPI: No dock devices found.
[    0.230521] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.230648] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.230648] pci 0000:00:01.0: PME# disabled
[    0.230648] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfebfc000-0xfebfffff]
[    0.230648] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.230648] pci 0000:00:1b.0: PME# disabled
[    0.230766] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.230859] pci 0000:00:1c.0: PME# disabled
[    0.231041] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.231134] pci 0000:00:1c.1: PME# disabled
[    0.231315] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.231408] pci 0000:00:1c.2: PME# disabled
[    0.231565] pci 0000:00:1d.0: reg 20 io port: [0xec00-0xec1f]
[    0.231641] pci 0000:00:1d.1: reg 20 io port: [0xe880-0xe89f]
[    0.231717] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.231792] pci 0000:00:1d.3: reg 20 io port: [0xe480-0xe49f]
[    0.231873] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfebfbc00-0xfebfbfff]
[    0.231946] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.232040] pci 0000:00:1d.7: PME# disabled
[    0.232312] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 AC=
PI/GPIO/TCO
[    0.232419] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GP=
IO
[    0.232515] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0250 (=
mask 000f)
[    0.233358] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.233368] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.233378] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.233388] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.233397] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.233439] pci 0000:00:1f.2: PME# supported from D3hot
[    0.233531] pci 0000:00:1f.2: PME# disabled
[    0.233682] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.233772] pci 0000:01:00.0: reg 10 32bit mmio: [0xfd000000-0xfdffffff]
[    0.233788] pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xcfffffff]
[    0.233804] pci 0000:01:00.0: reg 1c 64bit mmio: [0xfc000000-0xfcffffff]
[    0.233820] pci 0000:01:00.0: reg 30 32bit mmio: [0xfbfe0000-0xfbffffff]
[    0.233885] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    0.234090] pci 0000:00:01.0: bridge 32bit mmio: [0xf9f00000-0xfdffffff]
[    0.234097] pci 0000:00:01.0: bridge 64bit mmio pref: [0xbdf00000-0xddef=
ffff]
[    0.234185] pci 0000:02:00.0: reg 10 io port: [0xc800-0xc8ff]
[    0.234217] pci 0000:02:00.0: reg 18 64bit mmio: [0xfe0ff000-0xfe0fffff]
[    0.234251] pci 0000:02:00.0: reg 30 32bit mmio: [0xfe0e0000-0xfe0effff]
[    0.234320] pci 0000:02:00.0: supports D1 D2
[    0.234323] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.234410] pci 0000:02:00.0: PME# disabled
[    0.234531] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    0.234751] pci 0000:00:1c.0: bridge io port: [0xc000-0xcfff]
[    0.234758] pci 0000:00:1c.0: bridge 32bit mmio: [0xfe000000-0xfe0fffff]
[    0.234960] pci 0000:03:00.0: reg 10 32bit mmio: [0xfe1ff000-0xfe1fffff]
[    0.235216] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.235347] pci 0000:03:00.0: PME# disabled
[    0.235531] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    0.235843] pci 0000:00:1c.1: bridge 32bit mmio: [0xfe100000-0xfe1fffff]
[    0.235920] pci 0000:00:1c.2: bridge io port: [0xd000-0xdfff]
[    0.235927] pci 0000:00:1c.2: bridge 32bit mmio: [0xfe200000-0xfe9fffff]
[    0.235937] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xddf00000-0xdfef=
ffff]
[    0.235991] pci 0000:06:01.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
[    0.236061] pci 0000:06:01.0: PME# supported from D0 D3hot D3cold
[    0.236146] pci 0000:06:01.0: PME# disabled
[    0.236268] pci 0000:06:01.1: reg 10 32bit mmio: [0xfeaff400-0xfeaff4ff]
[    0.236338] pci 0000:06:01.1: supports D1 D2
[    0.236341] pci 0000:06:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.236427] pci 0000:06:01.1: PME# disabled
[    0.236550] pci 0000:06:01.2: reg 10 32bit mmio: [0xfeaff000-0xfeaff0ff]
[    0.236620] pci 0000:06:01.2: supports D1 D2
[    0.236623] pci 0000:06:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.236672] pci 0000:06:01.2: PME# disabled
[    0.236795] pci 0000:06:01.3: reg 10 32bit mmio: [0xfeafec00-0xfeafecff]
[    0.236864] pci 0000:06:01.3: supports D1 D2
[    0.236867] pci 0000:06:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.236953] pci 0000:06:01.3: PME# disabled
[    0.237107] pci 0000:00:1e.0: transparent bridge
[    0.237191] pci 0000:00:1e.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.237233] pci_bus 0000:00: on NUMA node 0
[    0.237241] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.237515] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.237617] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.237724] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.237826] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.237941] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.254429] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *11 12)
[    0.256874] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 12)
[    0.257572] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 12)
[    0.258267] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *4 5 6 7 12)
[    0.258964] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 12) *0, disa=
bled.
[    0.259768] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 12) *0, disa=
bled.
[    0.260633] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 12) *0, disa=
bled.
[    0.261438] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 12)
[    0.262027] SCSI subsystem initialized
[...]


dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc5-git8 (gcc version 4.4.2 20090811 (p=
rerelease) (Debian 4.4-150647) ) #4 SMP PREEMPT Wed Aug 12 21:19:34 EEST 20=
09
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
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffa8000 (usable)
[    0.000000]  BIOS-e820: 000000003ffa8000 - 000000003ffb0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ffb0000 - 000000003ffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffbe000 - 0000000040000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around =
it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0x3ffa8 max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003ffa8000 (usable)
[    0.000000]  modified: 000000003ffa8000 - 000000003ffb0000 (ACPI NVS)
[    0.000000]  modified: 000000003ffb0000 - 000000003ffbe000 (ACPI data)
[    0.000000]  modified: 000000003ffbe000 - 0000000040000000 (ACPI NVS)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffb80000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
[    0.000000] RAMDISK: 37b21000 - 37fef8de
[    0.000000] Allocated new RAMDISK: 00100000 - 005ce8de
[    0.000000] Move RAMDISK from 0000000037b21000 - 0000000037fef8dd to 001=
00000 - 005ce8dd
[    0.000000] ACPI: RSDP 000f7af0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 3ffb0000 00040 (v01 _ASUS_ Notebook 02000715 MSFT=
 00000097)
[    0.000000] ACPI: FACP 3ffb0200 00084 (v02 AMI    OEMFACP  02000715 MSFT=
 00000097)
[    0.000000] ACPI: DSDT 3ffb05e0 08918 (v01  F3J00 F3J00001 00000001 INTL=
 02002026)
[    0.000000] ACPI: FACS 3ffbe000 00040
[    0.000000] ACPI: APIC 3ffb0390 0005C (v01 AMI    OEMAPIC  02000715 MSFT=
 00000097)
[    0.000000] ACPI: MCFG 3ffb03f0 0003C (v01 AMI    OEMMCFG  02000715 MSFT=
 00000097)
[    0.000000] ACPI: BOOT 3ffb05b0 00028 (v01 AMI    OEMBOOT  02000715 MSFT=
 00000097)
[    0.000000] ACPI: SLIC 3ffb0430 00176 (v01 _ASUS_ Notebook 02000715 MSFT=
 00000097)
[    0.000000] ACPI: OEMB 3ffbe040 00046 (v01 AMI    AMI_OEM  02000715 MSFT=
 00000097)
[    0.000000] ACPI: HPET 3ffb8f00 00038 (v01 AMI        ASUS 02000715 MSFT=
 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 135MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00011000 - 00017f00
[    0.000000] (9 early reservations) =3D=3D> bootmem [0000000000 - 00377fe=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [000=
0001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00016a9098]    TEXT DATA BSS =3D=3D> [000=
1000000 - 00016a9098]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000=
009fc00 - 0000100000]
[    0.000000]   #5 [00016aa000 - 00016b11cd]              BRK =3D=3D> [000=
16aa000 - 00016b11cd]
[    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE =3D=3D> [000=
0010000 - 0000011000]
[    0.000000]   #7 [0000100000 - 00005ce8de]      NEW RAMDISK =3D=3D> [000=
0100000 - 00005ce8de]
[    0.000000]   #8 [0000011000 - 0000018000]          BOOTMAP =3D=3D> [000=
0011000 - 0000018000]
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003ffa8
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003ffa8
[    0.000000] On node 0 totalpages: 261943
[    0.000000] free_area_init_node: node 0, pgdat c159bcc0, node_mem_map c1=
6b2200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 272 pages used for memmap
[    0.000000]   HighMem zone: 34458 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000001=
00000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000=
:bee00000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages at c1eb7000, static data 34116 byt=
es
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 259895
[    0.000000] Kernel command line: root=3DUUID=3Dd44dd563-a831-40b0-9bfd-f=
460c9430ffa ro=20
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0003ffa8)
[    0.000000] Memory: 1026552k/1048224k available (4144k kernel code, 2091=
6k reserved, 1689k data, 408k init, 138920k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff91000 - 0xfffff000   ( 440 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc15ba000 - 0xc1620000   ( 408 kB)
[    0.000000]       .data : 0xc140c2d6 - 0xc15b2968   (1689 kB)
[    0.000000]       .text : 0xc1000000 - 0xc140c2d6   (4144 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1597.937 MHz processor.
[    0.002672] Console: colour VGA+ 80x25
[    0.002677] console [tty0] enabled
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.003333] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 3197.03 BogoMIPS (lpj=3D5326456)
[    0.003333] Security Framework initialized
[    0.003333] Mount-cache hash table entries: 512
[    0.003333] Initializing cgroup subsys ns
[    0.003333] Initializing cgroup subsys cpuacct
[    0.003333] Initializing cgroup subsys devices
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] CPU0: Thermal monitoring handled by SMI
[    0.003333] using mwait in idle threads.
[    0.003333] Performance Counters: Core2 events, Intel PMU driver.
[    0.003333] ... version:                 2
[    0.003333] ... bit width:               40
[    0.003333] ... generic counters:        2
[    0.003333] ... value mask:              000000ffffffffff
[    0.003333] ... max period:              000000007fffffff
[    0.003333] ... fixed-purpose counters:  3
[    0.003333] ... counter mask:            0000000700000003
[    0.003333] Checking 'hlt' instruction... OK.
[    0.013975] ACPI: Core revision 20090521
[    0.033780] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.069165] CPU0: Intel(R) Core(TM)2 CPU         T5200  @ 1.60GHz steppi=
ng 06
[    0.069999] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 3197.98 Bog=
oMIPS (lpj=3D5326371)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] CPU1: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.161996] CPU1: Intel(R) Core(TM)2 CPU         T5200  @ 1.60GHz steppi=
ng 06
[    0.162966] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.163365] Brought up 2 CPUs
[    0.163451] Total of 2 processors activated (6394.01 BogoMIPS).
[    0.166727] CPU0 attaching sched-domain:
[    0.166731]  domain 0: span 0-1 level MC
[    0.166735]   groups: 0 1
[    0.166742] CPU1 attaching sched-domain:
[    0.166744]  domain 0: span 0-1 level MC
[    0.166748]   groups: 1 0
[    0.166879] NET: Registered protocol family 16
[    0.166879] ACPI: bus type pci registered
[    0.166879] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.166879] PCI: Not using MMCONFIG.
[    0.167174] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D6
[    0.167265] PCI: Using configuration type 1 for base access
[    0.173389] bio: create slab <bio-0> at 0
[    0.178641] ACPI: EC: Look up EC in DSDT
[    0.196689] ACPI: Interpreter enabled
[    0.196784] ACPI: (supports S0 S1 S3 S4 S5)
[    0.197200] ACPI: Using IOAPIC for interrupt routing
[    0.197368] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.212595] PCI: MCFG area at e0000000 reserved in ACPI motherboard reso=
urces
[    0.212690] PCI: updated MCFG configuration 0: base e0000000 segment 0 b=
uses 0 - 63
[    0.212793] PCI: Using MMCONFIG for extended config space
[    0.223729] ACPI: EC: GPE =3D 0x1c, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.223823] ACPI: EC: driver started in poll mode
[    0.223943] ACPI: No dock devices found.
[    0.223943] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.226940] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.226940] pci 0000:00:01.0: PME# disabled
[    0.227070] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfebfc000-0xfebfffff]
[    0.227142] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.227235] pci 0000:00:1b.0: PME# disabled
[    0.227414] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.227506] pci 0000:00:1c.0: PME# disabled
[    0.227688] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.227781] pci 0000:00:1c.1: PME# disabled
[    0.227965] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.228058] pci 0000:00:1c.2: PME# disabled
[    0.228215] pci 0000:00:1d.0: reg 20 io port: [0xec00-0xec1f]
[    0.228290] pci 0000:00:1d.1: reg 20 io port: [0xe880-0xe89f]
[    0.228365] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.228440] pci 0000:00:1d.3: reg 20 io port: [0xe480-0xe49f]
[    0.228520] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfebfbc00-0xfebfbfff]
[    0.228594] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.228688] pci 0000:00:1d.7: PME# disabled
[    0.228960] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 AC=
PI/GPIO/TCO
[    0.229068] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GP=
IO
[    0.229165] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0250 (=
mask 000f)
[    0.229343] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.229353] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.229362] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.229372] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.229382] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.229424] pci 0000:00:1f.2: PME# supported from D3hot
[    0.229515] pci 0000:00:1f.2: PME# disabled
[    0.229515] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.229515] pci 0000:01:00.0: reg 10 32bit mmio: [0xfd000000-0xfdffffff]
[    0.229515] pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xcfffffff]
[    0.229515] pci 0000:01:00.0: reg 1c 64bit mmio: [0xfc000000-0xfcffffff]
[    0.229515] pci 0000:01:00.0: reg 30 32bit mmio: [0xfbfe0000-0xfbffffff]
[    0.229515] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    0.229515] pci 0000:00:01.0: bridge 32bit mmio: [0xf9f00000-0xfdffffff]
[    0.229515] pci 0000:00:01.0: bridge 64bit mmio pref: [0xbdf00000-0xddef=
ffff]
[    0.229515] pci 0000:02:00.0: reg 10 io port: [0xc800-0xc8ff]
[    0.229515] pci 0000:02:00.0: reg 18 64bit mmio: [0xfe0ff000-0xfe0fffff]
[    0.229515] pci 0000:02:00.0: reg 30 32bit mmio: [0xfe0e0000-0xfe0effff]
[    0.229515] pci 0000:02:00.0: supports D1 D2
[    0.229515] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.229515] pci 0000:02:00.0: PME# disabled
[    0.229515] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    0.229515] pci 0000:00:1c.0: bridge io port: [0xc000-0xcfff]
[    0.229515] pci 0000:00:1c.0: bridge 32bit mmio: [0xfe000000-0xfe0fffff]
[    0.229515] pci 0000:03:00.0: reg 10 32bit mmio: [0xfe1ff000-0xfe1fffff]
[    0.229515] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.229515] pci 0000:03:00.0: PME# disabled
[    0.229515] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  Yo=
u can enable it with 'pcie_aspm=3Dforce'
[    0.229515] pci 0000:00:1c.1: bridge 32bit mmio: [0xfe100000-0xfe1fffff]
[    0.229515] pci 0000:00:1c.2: bridge io port: [0xd000-0xdfff]
[    0.229515] pci 0000:00:1c.2: bridge 32bit mmio: [0xfe200000-0xfe9fffff]
[    0.229515] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xddf00000-0xdfef=
ffff]
[    0.229515] pci 0000:06:01.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
[    0.229515] pci 0000:06:01.0: PME# supported from D0 D3hot D3cold
[    0.229515] pci 0000:06:01.0: PME# disabled
[    0.229515] pci 0000:06:01.1: reg 10 32bit mmio: [0xfeaff400-0xfeaff4ff]
[    0.229515] pci 0000:06:01.1: supports D1 D2
[    0.229515] pci 0000:06:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.229515] pci 0000:06:01.1: PME# disabled
[    0.229601] pci 0000:06:01.2: reg 10 32bit mmio: [0xfeaff000-0xfeaff0ff]
[    0.229669] pci 0000:06:01.2: supports D1 D2
[    0.229672] pci 0000:06:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.229758] pci 0000:06:01.2: PME# disabled
[    0.229883] pci 0000:06:01.3: reg 10 32bit mmio: [0xfeafec00-0xfeafecff]
[    0.230026] pci 0000:06:01.3: supports D1 D2
[    0.230029] pci 0000:06:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.230115] pci 0000:06:01.3: PME# disabled
[    0.230268] pci 0000:00:1e.0: transparent bridge
[    0.230352] pci 0000:00:1e.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.230393] pci_bus 0000:00: on NUMA node 0
[    0.230402] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.230675] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.230777] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.230884] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.230986] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.231102] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.251108] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *11 12)
[    0.251108] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 12)
[    0.251108] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 12)
[    0.251449] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *4 5 6 7 12)
[    0.252144] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 12) *0, disa=
bled.
[    0.252949] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 12) *0, disa=
bled.
[    0.253751] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 12) *0, disa=
bled.
[    0.254555] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 12)
[    0.258340] SCSI subsystem initialized
[...]


	Sergey
--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqDIboACgkQfKHnntdSXjTuMgP+NG3AeGOFlknR6suYDDZaJ8my
5IYXO805S9IqNE2LEfyGwExCkh6j1SiZflt4OPB+dyV6wLPZM9ldXbVN5c//lBJU
Sz9q4WDsUUQtscoC6nylwMrttcEYArf96Ly4ZPMUIKe0npnB9Uzu0hHujx3RtX89
6ahyqla13b2E39W/Hro=
=whm5
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
