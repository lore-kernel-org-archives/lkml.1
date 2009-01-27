Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbZA0QLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbZA0QLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZA0QLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:11:01 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:58295 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbZA0QLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:11:00 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, arve@android.com
Subject: Re: 2.6.29-rc2 dies on startup
References: <877i4rjw38.fsf@tac.ki.iif.hu>
	<20090125224625.96429d3d.akpm@linux-foundation.org>
Date: Tue, 27 Jan 2009 17:10:47 +0100
In-Reply-To: <20090125224625.96429d3d.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sun, 25 Jan 2009 22:46:25 -0800")
Message-ID: <87eiyok9vc.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 19 Jan 2009 13:53:31 +0100 Ferenc Wagner <wferi@niif.hu> wrote:
>
>> I'm running 2.6.28 without problems.  I decided to give 2.6.29-rc2 a
>> try.  It crashes very early during boot, see screenshot, config and lspci
>> under http://apt.niif.hu/2.6.29-rc2/.  CPU is AMD Athlon(tm) XP 1800+,
>> kernel command line: root=/dev/hda1 ro.  I fixed the pcf50663 compile
>> error by hand, and have a small patch on /drivers/acpi/battery.c, but
>> that module isn't loaded on this system.  I can hook up a serial
>> console for further info if needed.
>
> What a ghastly backtrace.
>
> At a guess I'd say that drivers/staging/android/ram_console.c is calling
> the reed-solomon code earlier than it's expecting.  But that might be
> totally wrong.
>
> Please set CONFIG_STAGING=n and retest.

Indeed, with CONFIG_STAGING unset the kernel boots up fine!  Before
testing I pulled again, set CONFIG_CLASSIC_RCU=y and
CONFIG_FRAME_POINTER=y, but the resulting kernel still crashed (serial
log attached).  Then I unset CONFIG_STAGING and that worked.

Should I also test Arve's patch?

Regards,
Feri.


--=-=-=
Content-Disposition: inline; filename=crash.log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29-rc2 (wferi@rs22) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Mon Jan 26 21:11:28 CET 2009
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
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
[    0.000000]  BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.2 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x1fff0 max_arch_pfn = 0x1000000
[    0.000000] RAMDISK: 1f8c5000 - 1ffdf529
[    0.000000] ACPI: RSDP 000F75C0, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT 1FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 1FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 1FFF30C0, 43E7 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS 1FFF0000, 0040
[    0.000000] ACPI: APIC 1FFF74C0, 006E (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 511MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1fff0000
[    0.000000]   low ram: 00000000 - 1fff0000
[    0.000000]   bootmap 00011000 - 00015000
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 001fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00004f5424]    TEXT DATA BSS ==> [0000100000 - 00004f5424]
[    0.000000]   #4 [001f8c5000 - 001ffdf529]          RAMDISK ==> [001f8c5000 - 001ffdf529]
[    0.000000]   #5 [00004f6000 - 00004fd000]    INIT_PG_TABLE ==> [00004f6000 - 00004fd000]
[    0.000000]   #6 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #7 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000]   #8 [0000011000 - 0000015000]          BOOTMAP ==> [0000011000 - 0000015000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001fff0
[    0.000000]   HighMem  0x0001fff0 -> 0x0001fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001fff0
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Allocating 40960 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129919
[    0.000000] Kernel command line: root=/dev/hda1 ro console=ttyS0,57600
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1536.828 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [ttyS0] enabled
[    0.004000] BUG: unable to handle kernel paging request at f000e816
[    0.004000] IP: [<c0190b5c>] kmem_cache_alloc+0x2d/0x95
[    0.004000] *pdpt = 0000000000467001 *pde = 0000000000000000
[    0.004000] Oops: 0000 [#1] SMP
[    0.004000] last sysfs file:
[    0.004000] Modules linked in:
[    0.004000]
[    0.004000] Pid: 0, comm: swapper Not tainted (2.6.29-rc2 #1) A7N8X-X
[    0.004000] EIP: 0060:[<c0190b5c>] EFLAGS: 00010082 CPU: 0
[    0.004000] EIP is at kmem_cache_alloc+0x2d/0x95
[    0.004000] EAX: 00000000 EBX: c04513e4 ECX: f000e816 EDX: 000000d0
[    0.004000] ESI: 00000000 EDI: 00000282 EBP: c040fed8 ESP: c040fec8
[    0.004000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.004000] Process swapper (pid: 0, ti=c040e000 task=c03b82fc task.ti=c040e000)
[    0.004000] Stack:
[    0.004000]  000000d0 c04513e4 00000100 00000008 c040ff1c c0214ca6 00000000 0000011d
[    0.004000]  d576ec50 c020fbe5 c040ff08 c0275fcf 00000020 c04efc18 0000000a 00000060
[    0.004000]  c04efc18 00002630 c04513e4 00099800 c03eb000 c040ff30 c0214f5e 00000000
[    0.004000] Call Trace:
[    0.004000]  [<c0214ca6>] ? init_rs_internal+0xc2/0x354
[    0.004000]  [<c020fbe5>] ? __const_udelay+0x2c/0x2e
[    0.004000]  [<c0275fcf>] ? wait_for_xmitr+0x35/0x79
[    0.004000]  [<c0214f5e>] ? init_rs+0x11/0x13
[    0.004000]  [<c04380f7>] ? ram_console_early_init+0x3c/0x2ea
[    0.004000]  [<c030c824>] ? _spin_unlock_irqrestore+0x19/0x1f
[    0.004000]  [<c030c824>] ? _spin_unlock_irqrestore+0x19/0x1f
[    0.004000]  [<c012f028>] ? release_console_sem+0x185/0x1b2
[    0.004000]  [<c012f6f3>] ? register_console+0x21f/0x227
[    0.004000]  [<c0434c8d>] ? console_init+0x12/0x20
[    0.004000]  [<c041371d>] ? start_kernel+0x1d1/0x2e1
[    0.004000]  [<c0413096>] ? i386_start_kernel+0x85/0x8d
[    0.004000] Code: e5 57 56 89 c6 53 83 ec 04 89 55 f0 51 52 ff 15 dc 07 3c c0 5a 59 89 c7 51 52 ff 15 e4 07 3c c0 5a 59 64 a1 44 0c 46 c0 8b 0c 86 <83> 39 00 74 14 8b 11 c7 41 0c 01 00 00 00 8d 42 ff 8b 5c 91 10
[    0.004000] EIP: [<c0190b5c>] kmem_cache_alloc+0x2d/0x95 SS:ESP 0068:c040fec8
[    0.004000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.004000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.004000] ------------[ cut here ]------------
[    0.004000] WARNING: at kernel/smp.c:299 smp_call_function_many+0x37/0x1bf()
[    0.004000] Hardware name: A7N8X-X
[    0.004000] Modules linked in:
[    0.004000] Pid: 0, comm: swapper Tainted: G      D    2.6.29-rc2 #1
[    0.004000] Call Trace:
[    0.004000]  [<c012e9c9>] warn_slowpath+0x71/0xa8
[    0.004000]  [<c020fbe5>] ? __const_udelay+0x2c/0x2e
[    0.004000]  [<c0275fcf>] ? wait_for_xmitr+0x35/0x79
[    0.004000]  [<c0276380>] ? serial8250_console_write+0xe1/0xeb
[    0.004000]  [<c030c824>] ? _spin_unlock_irqrestore+0x19/0x1f
[    0.004000]  [<c030c824>] ? _spin_unlock_irqrestore+0x19/0x1f
[    0.004000]  [<c012f028>] ? release_console_sem+0x185/0x1b2
[    0.004000]  [<c012f4af>] ? vprintk+0x280/0x2a5
[    0.004000]  [<c014c3b0>] smp_call_function_many+0x37/0x1bf
[    0.004000]  [<c010dcc6>] ? stop_this_cpu+0x0/0x47
[    0.004000]  [<c014c554>] smp_call_function+0x1c/0x23
[    0.004000]  [<c0115afd>] native_smp_send_stop+0x1b/0x45
[    0.004000]  [<c030a5fd>] panic+0x48/0xe4
[    0.004000]  [<c01316ce>] do_exit+0x61/0x6dc
[    0.004000]  [<c030a6a8>] ? printk+0xf/0x17
[    0.004000]  [<c012eafd>] ? oops_exit+0x23/0x28
[    0.004000]  [<c010ae25>] oops_end+0xa1/0xa9
[    0.004000]  [<c010afac>] die+0x54/0x5a
[    0.004000]  [<c011e1da>] do_page_fault+0x7de/0x898
[    0.004000]  [<c020e985>] ? number+0x106/0x1c0
[    0.004000]  [<c020f710>] ? vsnprintf+0x85c/0x8bb
[    0.004000]  [<c030c824>] ? _spin_unlock_irqrestore+0x19/0x1f
[    0.004000]  [<c030c824>] ? _spin_unlock_irqrestore+0x19/0x1f
[    0.004000]  [<c012f028>] ? release_console_sem+0x185/0x1b2
[    0.004000]  [<c012f4af>] ? vprintk+0x280/0x2a5
[    0.004000]  [<c011d9fc>] ? do_page_fault+0x0/0x898
[    0.004000]  [<c030ca62>] error_code+0x72/0x78
[    0.004000]  [<c0190b5c>] ? kmem_cache_alloc+0x2d/0x95
[    0.004000]  [<c0214ca6>] init_rs_internal+0xc2/0x354
[    0.004000]  [<c020fbe5>] ? __const_udelay+0x2c/0x2e
[    0.004000]  [<c0275fcf>] ? wait_for_xmitr+0x35/0x79
[    0.004000]  [<c0214f5e>] init_rs+0x11/0x13
[    0.004000]  [<c04380f7>] ram_console_early_init+0x3c/0x2ea
[    0.004000]  [<c030c824>] ? _spin_unlock_irqrestore+0x19/0x1f
[    0.004000]  [<c030c824>] ? _spin_unlock_irqrestore+0x19/0x1f
[    0.004000]  [<c012f028>] ? release_console_sem+0x185/0x1b2
[    0.004000]  [<c012f6f3>] ? register_console+0x21f/0x227
[    0.004000]  [<c0434c8d>] console_init+0x12/0x20
[    0.004000]  [<c041371d>] start_kernel+0x1d1/0x2e1
[    0.004000]  [<c0413096>] i386_start_kernel+0x85/0x8d
[    0.004000] ---[ end trace 4eaa2a86a8e2da23 ]---

--=-=-=--
