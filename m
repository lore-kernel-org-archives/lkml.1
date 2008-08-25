Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbYHYMXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbYHYMXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYHYMXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:23:08 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:8122 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYHYMXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:23:05 -0400
Message-ID: <48B2A421.7080705@hp.com>
Date: Mon, 25 Aug 2008 08:22:57 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com>
In-Reply-To: <48B29F7B.6080405@hp.com>
Content-Type: multipart/mixed;
 boundary="------------020200010504060403080007"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020200010504060403080007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Before adding any more debugging, this is the status of my kernel boots:
3 times in a row w/ this same error. (Primary problem is the same,
secondary stacks differ of course.)

Alan

--------------020200010504060403080007
Content-Type: text/plain;
 name="prob3.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="prob3.txt"

Loading, please [    6.482953] busybox used greatest stack depth: 4840 bytes left
wait...
[    6.521876] all_generic_ide used greatest stack depth: 4784 bytes left
Begin: Loading essential drivers... ...
[    6.625509] fuse init (API version 7.9)
[    6.625509] modprobe used greatest stack depth: 1720 bytes left
[    6.644854] ACPI: SSDT CFFD0D0A, 08C4 (r1 HPQOEM  CPU_TM2        1 MSFT  100000E)
[    6.651489] BUG: unable to handle kernel NULL pointer dereference at 0000000000000858
[    6.655631] IP: [<ffffffff8025e302>] debug_mutex_add_waiter+0x32/0x80
[    6.655631] PGD 21a0a4067 PUD 21a4bd067 PMD 0
[    6.655631] Oops: 0002 [1] SMP
[    6.655631] CPU 1
[    6.655631] Modules linked in: processor(+) fan thermal_sys fuse
[    6.655631] Pid: 1259, comm: modprobe Not tainted 2.6.27-rc3 #29
[    6.655631] RIP: 0010:[<ffffffff8025e302>]  [<ffffffff8025e302>] debug_mutex_add_waiter+0x32/0x80
[    6.655631] RSP: 0018:ffff88021a4e7998  EFLAGS: 00010002
[    6.655631] RAX: 0000000000000000 RBX: ffff88021a4e79d8 RCX: 0000000000000000
[    6.655631] RDX: 0000000000000001 RSI: ffff88021a4e79d8 RDI: ffffffffa0091a60
[    6.655631] RBP: ffff88021a4e79b8 R08: ffffffff811deff0 R09: ffff8800a6fdb000
[    6.655631] R10: ffffffffa008f524 R11: 0000000000000000 R12: ffffffffa0091a60
[    6.655631] R13: ffff88021a4e6000 R14: ffff88021a9c40a0 R15: ffffffffa0091a98
[    6.655631] FS:  00007f233f11d6e0(0000) GS:ffff88022fc02a00(0000) knlGS:0000000000000000
[    6.655631] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    6.655631] CR2: 0000000000000858 CR3: 000000021a07e000 CR4: 00000000000006e0
[    6.655631] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.655631] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    6.655631] Process modprobe (pid: 1259, threadinfo ffff88021a4e6000, task ffff88021a9c40a0)
[    6.655631] Stack:  0000000000000000 ffffffffa0091a60 0000000000000246 ffffffffa008f524
[    6.655631]  ffff88021a4e7a38 ffffffff8049f596 ffffffffa008f524 ffffffffa0091a18
[    6.655631]  ffff88021a4e79d8 ffff88021a4e79d8 1111111111111111 1111111111111111
[    6.655631] Call Trace:
[    6.655631]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    6.655631]  [<ffffffff8049f596>] mutex_lock_nested+0xa6/0x250
[    6.655631]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    6.655631]  [<ffffffff803635c4>] ? idr_pre_get+0x44/0x90
[    6.655631]  [<ffffffffa008f524>] get_idr+0x44/0xa0 [thermal_sys]
[    6.655631]  [<ffffffffa008fe43>] thermal_cooling_device_register+0x83/0x250 [thermal_sys]
[    6.655631]  [<ffffffffa019b2a3>] acpi_processor_start+0x64b/0x774 [processor]
[    6.655631]  [<ffffffff8031a94b>] ? __sysfs_add_one+0x6b/0xa0
[    6.655631]  [<ffffffff8031ba3c>] ? sysfs_do_create_link+0xbc/0x150
[    6.655631]  [<ffffffff803a7f5e>] acpi_start_single_object+0x2d/0x52
[    6.655631]  [<ffffffff803a9556>] acpi_device_probe+0x7e/0x92
[    6.655631]  [<ffffffff803dd3eb>] driver_probe_device+0x9b/0x1a0
[    6.655631]  [<ffffffff803dd576>] __driver_attach+0x86/0x90
[    6.655631]  [<ffffffff803dd4f0>] ? __driver_attach+0x0/0x90
[    6.655631]  [<ffffffff803dc93d>] bus_for_each_dev+0x5d/0x90
[    6.655631]  [<ffffffff803dd22c>] driver_attach+0x1c/0x20
[    6.655631]  [<ffffffff803dcf79>] bus_add_driver+0x1e9/0x260
[    6.655631]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    6.655631]  [<ffffffff803dd74f>] driver_register+0x5f/0x140
[    6.655631]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    6.655631]  [<ffffffff803a9866>] acpi_bus_register_driver+0x3e/0x40
[    6.655631]  [<ffffffffa0222094>] acpi_processor_init+0x94/0x107 [processor]
[    6.655631]  [<ffffffff80209040>] _stext+0x40/0x180
[    6.655631]  [<ffffffff802a8911>] ? __vunmap+0xa1/0x110
[    6.655631]  [<ffffffff802676c2>] sys_init_module+0x142/0x1dc0
[    6.655631]  [<ffffffff80367b16>] ? __up_read+0x46/0xb0
[    6.655631]  [<ffffffff8048e570>] ? cpu_down+0x0/0x70
[    6.655631]  [<ffffffff8020c34b>] system_call_fastpath+0x16/0x1b
[    6.655631]
[    6.655631]
[    6.655631] Code: 20 48 89 5d e8 4c 89 65 f0 48 89 f3 4c 89 6d f8 8b 47 08 49 89 d5 49 89 fc 89 c2 25 ff ff 00 00 c1 ea 10 39 c2 74 1d 49 8b 4
[    6.655631] RIP  [<ffffffff8025e302>] debug_mutex_add_waiter+0x32/0x80
[    6.655631]  RSP <ffff88021a4e7998>
[    6.655631] CR2: 0000000000000858
[    6.655631] ---[ end trace 8bbd31df1403e48e ]---
[    7.024992] modprobe used greatest stack depth: 408 bytes left
[    7.030988] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[    7.031053] IP: [<ffffffff8023f39c>] do_exit+0x28c/0xa10
[    7.031053] PGD 0
[    7.031053] Oops: 0000 [2] SMP
[    7.031053] CPU 1
[    7.031053] Modules linked in: processor(+) fan thermal_sys fuse
[    7.031053] Pid: 1259, comm: modprobe Tainted: G      D   2.6.27-rc3 #29
[    7.031053] RIP: 0010:[<ffffffff8023f39c>]  [<ffffffff8023f39c>] do_exit+0x28c/0xa10
[    7.031053] RSP: 0018:ffff88021a4e77e8  EFLAGS: 00010246
[    7.031053] RAX: 0000000000000000 RBX: 0000000000000198 RCX: 0000000000000000
[    7.031053] RDX: 0000000000000000 RSI: ffffffff802740d0 RDI: 0000000000000000
[    7.031053] RBP: ffff88021a4e7848 R08: 0000000000000001 R09: 0000000000000000
[    7.031053] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88021a9c40a0
[    7.031053] R13: 0000000000000009 R14: ffff88021a4e78e8 R15: ffff88021a18b8a0
[    7.031053] FS:  0000000000000000(0000) GS:ffff88022fc02a00(0000) knlGS:0000000000000000
[    7.031053] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.031053] CR2: 0000000000000048 CR3: 0000000000201000 CR4: 00000000000006e0
[    7.031053] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.031053] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    7.031053] Process modprobe (pid: 1259, threadinfo ffff88021a4e6000, task ffff88021a9c40a0)
[    7.031053] Stack:  0000000000000001 0000000000000001 0000000000000040 0000000000000001
[    7.031053]  ffff88021a4e7828 ffffffff803c7d59 0000000000000092 0000000000000092
[    7.031053]  ffff88021a4e78e8 0000000000000009 ffff88021a4e78e8 ffff88021a18b8a0
[    7.031053] Call Trace:
[    7.031053]  [<ffffffff803c7d59>] ? do_unblank_screen+0x19/0x130
[    7.031053]  [<ffffffff804a1a57>] oops_end+0x87/0x90
[    7.031053]  [<ffffffff804a3d13>] do_page_fault+0x663/0x800
[    7.031053]  [<ffffffff804a162d>] error_exit+0x0/0x9a
[    7.031053]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.031053]  [<ffffffff8025e302>] ? debug_mutex_add_waiter+0x32/0x80
[    7.031053]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.031053]  [<ffffffff8049f596>] mutex_lock_nested+0xa6/0x250
[    7.031053]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.031053]  [<ffffffff803635c4>] ? idr_pre_get+0x44/0x90
[    7.031053]  [<ffffffffa008f524>] get_idr+0x44/0xa0 [thermal_sys]
[    7.031053]  [<ffffffffa008fe43>] thermal_cooling_device_register+0x83/0x250 [thermal_sys]
[    7.031053]  [<ffffffffa019b2a3>] acpi_processor_start+0x64b/0x774 [processor]
[    7.031053]  [<ffffffff8031a94b>] ? __sysfs_add_one+0x6b/0xa0
[    7.031053]  [<ffffffff8031ba3c>] ? sysfs_do_create_link+0xbc/0x150
[    7.031053]  [<ffffffff803a7f5e>] acpi_start_single_object+0x2d/0x52
[    7.031053]  [<ffffffff803a9556>] acpi_device_probe+0x7e/0x92
[    7.031053]  [<ffffffff803dd3eb>] driver_probe_device+0x9b/0x1a0
[    7.031053]  [<ffffffff803dd576>] __driver_attach+0x86/0x90
[    7.031053]  [<ffffffff803dd4f0>] ? __driver_attach+0x0/0x90
[    7.031053]  [<ffffffff803dc93d>] bus_for_each_dev+0x5d/0x90
[    7.031053]  [<ffffffff803dd22c>] driver_attach+0x1c/0x20
[    7.031053]  [<ffffffff803dcf79>] bus_add_driver+0x1e9/0x260
[    7.031053]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.031053]  [<ffffffff803dd74f>] driver_register+0x5f/0x140
[    7.031053]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.031053]  [<ffffffff803a9866>] acpi_bus_register_driver+0x3e/0x40
[    7.031053]  [<ffffffffa0222094>] acpi_processor_init+0x94/0x107 [processor]
[    7.031053]  [<ffffffff80209040>] _stext+0x40/0x180
[    7.031053]  [<ffffffff802a8911>] ? __vunmap+0xa1/0x110
[    7.031053]  [<ffffffff802676c2>] sys_init_module+0x142/0x1dc0
[    7.031053]  [<ffffffff80367b16>] ? __up_read+0x46/0xb0
[    7.031053]  [<ffffffff8048e570>] ? cpu_down+0x0/0x70
[    7.031053]  [<ffffffff8020c34b>] system_call_fastpath+0x16/0x1b
[    7.031053]
[    7.031053]
[    7.031053] Code: e8 8a e3 0e 00 8b 45 b8 85 c0 74 16 49 8b 84 24 40 07 00 00 8b 80 4c 01 00 00 85 c0 0f 85 77 07 00 00 49 8b 44 24 08 48 8b 4
[    7.031053] RIP  [<ffffffff8023f39c>] do_exit+0x28c/0xa10
[    7.031053]  RSP <ffff88021a4e77e8>
[    7.031053] CR2: 0000000000000048
[    7.421063] ------------[ cut here ]------------
[    7.424883] WARNING: at kernel/sched_fair.c:884 hrtick_start_fair+0x187/0x190()
[    7.424883] Modules linked in: processor(+) fan thermal_sys fuse
[    7.424883] Pid: 1259, comm: modprobe Tainted: G      D   2.6.27-rc3 #29
[    7.424883]
[    7.424883] Call Trace:
[    7.424883]  <IRQ>  [<ffffffff8023baef>] warn_on_slowpath+0x5f/0x80
[    7.424883]  [<ffffffff8022d927>] hrtick_start_fair+0x187/0x190
[    7.424883]  [<ffffffff8022ec79>] enqueue_task_fair+0x49/0x250
[    7.424883]  [<ffffffff8022c290>] enqueue_task+0x50/0x60
[    7.424883]  [<ffffffff8022c2c3>] activate_task+0x23/0x40
[    7.424883]  [<ffffffff80231653>] try_to_wake_up+0x253/0x280
[    7.424883]  [<ffffffff8023168d>] default_wake_function+0xd/0x10
[    7.424883]  [<ffffffff802521d1>] autoremove_wake_function+0x11/0x40
[    7.424883]  [<ffffffff8022bd6a>] __wake_up_common+0x5a/0x90
[    7.424883]  [<ffffffff8022d373>] __wake_up+0x43/0x70
[    7.424883]  [<ffffffff8024e910>] ? delayed_work_timer_fn+0x0/0x40
[    7.424883]  [<ffffffff8024df68>] insert_work+0x48/0x50
[    7.424883]  [<ffffffff8024e8f1>] __queue_work+0x31/0x50
[    7.424883]  [<ffffffff8024e942>] delayed_work_timer_fn+0x32/0x40
[    7.424883]  [<ffffffff80245e5b>] run_timer_softirq+0x1bb/0x230
[    7.424883]  [<ffffffff80255afa>] ? ktime_get_ts+0x4a/0x60
[    7.424883]  [<ffffffff8024157a>] __do_softirq+0x7a/0xf0
[    7.424883]  [<ffffffff8025cd8e>] ? tick_program_event+0x3e/0x70
[    7.424883]  [<ffffffff8020d69c>] call_softirq+0x1c/0x30
[    7.424883]  [<ffffffff8020f28d>] do_softirq+0x3d/0x80
[    7.424883]  [<ffffffff802414f5>] irq_exit+0x85/0x90
[    7.424883]  [<ffffffff8021d648>] smp_apic_timer_interrupt+0x88/0xc0
[    7.424883]  [<ffffffff8020d0e6>] apic_timer_interrupt+0x66/0x70
[    7.424883]  <EOI>  [<ffffffff804a1a1a>] ? oops_end+0x4a/0x90
[    7.424883]  [<ffffffff804a3d13>] ? do_page_fault+0x663/0x800
[    7.424883]  [<ffffffff804a162d>] ? error_exit+0x0/0x9a
[    7.424883]  [<ffffffff802740d0>] ? release_css_set_taskexit+0x0/0x10
[    7.424883]  [<ffffffff8023f39c>] ? do_exit+0x28c/0xa10
[    7.424883]  [<ffffffff8023f376>] ? do_exit+0x266/0xa10
[    7.424883]  [<ffffffff803c7d59>] ? do_unblank_screen+0x19/0x130
[    7.424883]  [<ffffffff804a1a57>] ? oops_end+0x87/0x90
[    7.424883]  [<ffffffff804a3d13>] ? do_page_fault+0x663/0x800
[    7.424883]  [<ffffffff804a162d>] ? error_exit+0x0/0x9a
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffff8025e302>] ? debug_mutex_add_waiter+0x32/0x80
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffff8049f596>] ? mutex_lock_nested+0xa6/0x250
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffff803635c4>] ? idr_pre_get+0x44/0x90
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffffa008fe43>] ? thermal_cooling_device_register+0x83/0x250 [thermal_sys]
[    7.424883]  [<ffffffffa019b2a3>] ? acpi_processor_start+0x64b/0x774 [processor]
[    7.424883]  [<ffffffff8031a94b>] ? __sysfs_add_one+0x6b/0xa0
[    7.424883]  [<ffffffff8031ba3c>] ? sysfs_do_create_link+0xbc/0x150
[    7.424883]  [<ffffffff803a7f5e>] ? acpi_start_single_object+0x2d/0x52
[    7.424883]  [<ffffffff803a9556>] ? acpi_device_probe+0x7e/0x92
[    7.424883]  [<ffffffff803dd3eb>] ? driver_probe_device+0x9b/0x1a0
[    7.424883]  [<ffffffff803dd576>] ? __driver_attach+0x86/0x90
[    7.424883]  [<ffffffff803dd4f0>] ? __driver_attach+0x0/0x90
[    7.424883]  [<ffffffff803dc93d>] ? bus_for_each_dev+0x5d/0x90
[    7.424883]  [<ffffffff803dd22c>] ? driver_attach+0x1c/0x20
[    7.424883]  [<ffffffff803dcf79>] ? bus_add_driver+0x1e9/0x260
[    7.424883]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.424883]  [<ffffffff803dd74f>] ? driver_register+0x5f/0x140
[    7.424883]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.424883]  [<ffffffff803a9866>] ? acpi_bus_register_driver+0x3e/0x40
[    7.424883]  [<ffffffffa0222094>] ? acpi_processor_init+0x94/0x107 [processor]
[    7.424883]  [<ffffffff80209040>] ? _stext+0x40/0x180
[    7.424883]  [<ffffffff802a8911>] ? __vunmap+0xa1/0x110
[    7.424883]  [<ffffffff802676c2>] ? sys_init_module+0x142/0x1dc0
[    7.424883]  [<ffffffff80367b16>] ? __up_read+0x46/0xb0
[    7.424883]  [<ffffffff8048e570>] ? cpu_down+0x0/0x70
[    7.424883]  [<ffffffff8020c34b>] ? system_call_fastpath+0x16/0x1b
[    7.424883]
[    7.424883] ---[ end trace 8bbd31df1403e48e ]---
[    7.424883] ------------[ cut here ]------------
[    7.424883] kernel BUG at kernel/sched.c:1155!
[    7.424883] invalid opcode: 0000 [3] SMP
[    7.424883] CPU 1
[    7.424883] Modules linked in: processor(+) fan thermal_sys fuse
[    7.424883] Pid: 1259, comm: modprobe Tainted: G      D W 2.6.27-rc3 #29
[    7.424883] RIP: 0010:[<ffffffff8022cc2b>]  [<ffffffff8022cc2b>] resched_task+0x6b/0x70
[    7.424883] RSP: 0018:ffff88022f0abce0  EFLAGS: 00010046
[    7.424883] RAX: 0000000000000709 RBX: 0000000004bfe971 RCX: ffff88021a4e6000
[    7.424883] RDX: 0000000000000709 RSI: 0000000000000000 RDI: ffff88021a9c40a0
[    7.424883] RBP: ffff88022f0abce0 R08: ffff88022f180038 R09: ffff88021a9c40d8
[    7.424883] R10: ffffffff810c9e00 R11: 0000000000000000 R12: ffff8800a6fc9000
[    7.424883] R13: ffffffff810c9e00 R14: ffff88021a9c40a0 R15: 0000000000000001
[    7.424883] FS:  0000000000000000(0000) GS:ffff88022fc02a00(0000) knlGS:0000000000000000
[    7.424883] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    7.424883] CR2: 0000000000000048 CR3: 0000000000201000 CR4: 00000000000006e0
[    7.424883] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.424883] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    7.424883] Process modprobe (pid: 1259, threadinfo ffff88021a4e6000, task ffff88021a9c40a0)
[    7.424883] Stack:  ffff88022f0abd20 ffffffff802387b3 0000000000000400 0000000000400000
[    7.424883]  ffff88022f180000 ffff8800280a4e00 0000000000000001 0000000000000003
[    7.424883]  ffff88022f0abd70 ffffffff802314bf 0000000100000001 0000000000000000
[    7.424883] Call Trace:
[    7.424883]  <IRQ>  [<ffffffff802387b3>] check_preempt_wakeup+0x133/0x1c0
[    7.424883]  [<ffffffff802314bf>] try_to_wake_up+0xbf/0x280
[    7.424883]  [<ffffffff8023168d>] default_wake_function+0xd/0x10
[    7.424883]  [<ffffffff802521d1>] autoremove_wake_function+0x11/0x40
[    7.424883]  [<ffffffff8022bd6a>] __wake_up_common+0x5a/0x90
[    7.424883]  [<ffffffff8022d373>] __wake_up+0x43/0x70
[    7.424883]  [<ffffffff8024e910>] ? delayed_work_timer_fn+0x0/0x40
[    7.424883]  [<ffffffff8024df68>] insert_work+0x48/0x50
[    7.424883]  [<ffffffff8024e8f1>] __queue_work+0x31/0x50
[    7.424883]  [<ffffffff8024e942>] delayed_work_timer_fn+0x32/0x40
[    7.424883]  [<ffffffff80245e5b>] run_timer_softirq+0x1bb/0x230
[    7.424883]  [<ffffffff80255afa>] ? ktime_get_ts+0x4a/0x60
[    7.424883]  [<ffffffff8024157a>] __do_softirq+0x7a/0xf0
[    7.424883]  [<ffffffff8025cd8e>] ? tick_program_event+0x3e/0x70
[    7.424883]  [<ffffffff8020d69c>] call_softirq+0x1c/0x30
[    7.424883]  [<ffffffff8020f28d>] do_softirq+0x3d/0x80
[    7.424883]  [<ffffffff802414f5>] irq_exit+0x85/0x90
[    7.424883]  [<ffffffff8021d648>] smp_apic_timer_interrupt+0x88/0xc0
[    7.424883]  [<ffffffff8020d0e6>] apic_timer_interrupt+0x66/0x70
[    7.424883]  <EOI>  [<ffffffff804a1a1a>] ? oops_end+0x4a/0x90
[    7.424883]  [<ffffffff804a3d13>] ? do_page_fault+0x663/0x800
[    7.424883]  [<ffffffff804a162d>] ? error_exit+0x0/0x9a
[    7.424883]  [<ffffffff802740d0>] ? release_css_set_taskexit+0x0/0x10
[    7.424883]  [<ffffffff8023f39c>] ? do_exit+0x28c/0xa10
[    7.424883]  [<ffffffff8023f376>] ? do_exit+0x266/0xa10
[    7.424883]  [<ffffffff803c7d59>] ? do_unblank_screen+0x19/0x130
[    7.424883]  [<ffffffff804a1a57>] ? oops_end+0x87/0x90
[    7.424883]  [<ffffffff804a3d13>] ? do_page_fault+0x663/0x800
[    7.424883]  [<ffffffff804a162d>] ? error_exit+0x0/0x9a
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffff8025e302>] ? debug_mutex_add_waiter+0x32/0x80
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffff8049f596>] ? mutex_lock_nested+0xa6/0x250
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffff803635c4>] ? idr_pre_get+0x44/0x90
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffffa008fe43>] ? thermal_cooling_device_register+0x83/0x250 [thermal_sys]
[    7.424883]  [<ffffffffa019b2a3>] ? acpi_processor_start+0x64b/0x774 [processor]
[    7.424883]  [<ffffffff8031a94b>] ? __sysfs_add_one+0x6b/0xa0
[    7.424883]  [<ffffffff8031ba3c>] ? sysfs_do_create_link+0xbc/0x150
[    7.424883]  [<ffffffff803a7f5e>] ? acpi_start_single_object+0x2d/0x52
[    7.424883]  [<ffffffff803a9556>] ? acpi_device_probe+0x7e/0x92
[    7.424883]  [<ffffffff803dd3eb>] ? driver_probe_device+0x9b/0x1a0
[    7.424883]  [<ffffffff803dd576>] ? __driver_attach+0x86/0x90
[    7.424883]  [<ffffffff803dd4f0>] ? __driver_attach+0x0/0x90
[    7.424883]  [<ffffffff803dc93d>] ? bus_for_each_dev+0x5d/0x90
[    7.424883]  [<ffffffff803dd22c>] ? driver_attach+0x1c/0x20
[    7.424883]  [<ffffffff803dcf79>] ? bus_add_driver+0x1e9/0x260
[    7.424883]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.424883]  [<ffffffff803dd74f>] ? driver_register+0x5f/0x140
[    7.424883]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.424883]  [<ffffffff803a9866>] ? acpi_bus_register_driver+0x3e/0x40
[    7.424883]  [<ffffffffa0222094>] ? acpi_processor_init+0x94/0x107 [processor]
[    7.424883]  [<ffffffff80209040>] ? _stext+0x40/0x180
[    7.424883]  [<ffffffff802a8911>] ? __vunmap+0xa1/0x110
[    7.424883]  [<ffffffff802676c2>] ? sys_init_module+0x142/0x1dc0
[    7.424883]  [<ffffffff80367b16>] ? __up_read+0x46/0xb0
[    7.424883]  [<ffffffff8048e570>] ? cpu_down+0x0/0x70
[    7.424883]  [<ffffffff8020c34b>] ? system_call_fastpath+0x16/0x1b
[    7.424883]
[    7.424883]
[    7.424883] Code: 8b 47 08 8b 50 1c 65 8b 04 25 24 00 00 00 39 c2 74 0d 0f ae f0 48 8b 47 08 f6 40 18 04 74 02 c9 c3 89 d7 ff 15 1f 7b 3c 00 c
[    7.424883] RIP  [<ffffffff8022cc2b>] resched_task+0x6b/0x70
[    7.424883]  RSP <ffff88022f0abce0>
[    7.424883] ---[ end trace 8bbd31df1403e48e ]---
[    7.424883] Kernel panic - not syncing: Aiee, killing interrupt handler!
[    7.424883] ------------[ cut here ]------------
[    7.424883] WARNING: at kernel/smp.c:328 smp_call_function_mask+0x25a/0x260()
[    7.424883] Modules linked in: processor(+) fan thermal_sys fuse
[    7.424883] Pid: 1259, comm: modprobe Tainted: G      D W 2.6.27-rc3 #29
[    7.424883]
[    7.424883] Call Trace:
[    7.424883]  <IRQ>  [<ffffffff8023baef>] warn_on_slowpath+0x5f/0x80
[    7.424883]  [<ffffffff8026514a>] smp_call_function_mask+0x25a/0x260
[    7.424883]  [<ffffffff803695bd>] ? string+0x3d/0xd0
[    7.424883]  [<ffffffff80369a8b>] ? vsnprintf+0x43b/0x720
[    7.424883]  [<ffffffff803695bd>] ? string+0x3d/0xd0
[    7.424883]  [<ffffffff80369a8b>] ? vsnprintf+0x43b/0x720
[    7.424883]  [<ffffffff803695bd>] ? string+0x3d/0xd0
[    7.424883]  [<ffffffff803695bd>] ? string+0x3d/0xd0
[    7.424883]  [<ffffffff80369a8b>] ? vsnprintf+0x43b/0x720
[    7.424883]  [<ffffffff80368d5e>] ? number+0x2ae/0x2d0
[    7.424883]  [<ffffffff80368d5e>] ? number+0x2ae/0x2d0
[    7.424883]  [<ffffffff80269ecd>] ? kallsyms_lookup+0x5d/0xa0
[    7.424883]  [<ffffffff80368d5e>] ? number+0x2ae/0x2d0
[    7.424883]  [<ffffffff80369a8b>] ? vsnprintf+0x43b/0x720
[    7.424883]  [<ffffffff80369dd8>] ? sprintf+0x68/0x70
[    7.424883]  [<ffffffff803695bd>] ? string+0x3d/0xd0
[    7.424883]  [<ffffffff804a3fa3>] ? __atomic_notifier_call_chain+0x83/0xa0
[    7.424883]  [<ffffffff804a3f20>] ? __atomic_notifier_call_chain+0x0/0xa0
[    7.424883]  [<ffffffff804a0ef6>] ? _spin_unlock+0x26/0x30
[    7.424883]  [<ffffffff8021c470>] ? stop_this_cpu+0x0/0x30
[    7.424883]  [<ffffffff80265190>] smp_call_function+0x40/0x50
[    7.424883]  [<ffffffff8021c4f3>] native_smp_send_stop+0x23/0x40
[    7.424883]  [<ffffffff8023be3f>] panic+0xaf/0x190
[    7.424883]  [<ffffffff8023cc97>] ? printk+0x67/0x70
[    7.424883]  [<ffffffff8049f4e9>] ? mutex_unlock+0x9/0x10
[    7.424883]  [<ffffffff80256d11>] ? blocking_notifier_call_chain+0x11/0x20
[    7.424883]  [<ffffffff8023f979>] do_exit+0x869/0xa10
[    7.424883]  [<ffffffff803c7d59>] ? do_unblank_screen+0x19/0x130
[    7.424883]  [<ffffffff804a1a57>] oops_end+0x87/0x90
[    7.424883]  [<ffffffff8020e08e>] die+0x5e/0x90
[    7.424883]  [<ffffffff804a1f60>] do_trap+0x130/0x150
[    7.424883]  [<ffffffff8020e662>] do_invalid_op+0x92/0xb0
[    7.424883]  [<ffffffff8022cc2b>] ? resched_task+0x6b/0x70
[    7.424883]  [<ffffffff804a162d>] error_exit+0x0/0x9a
[    7.424883]  [<ffffffff8022cc2b>] ? resched_task+0x6b/0x70
[    7.424883]  [<ffffffff802387b3>] check_preempt_wakeup+0x133/0x1c0
[    7.424883]  [<ffffffff802314bf>] try_to_wake_up+0xbf/0x280
[    7.424883]  [<ffffffff8023168d>] default_wake_function+0xd/0x10
[    7.424883]  [<ffffffff802521d1>] autoremove_wake_function+0x11/0x40
[    7.424883]  [<ffffffff8022bd6a>] __wake_up_common+0x5a/0x90
[    7.424883]  [<ffffffff8022d373>] __wake_up+0x43/0x70
[    7.424883]  [<ffffffff8024e910>] ? delayed_work_timer_fn+0x0/0x40
[    7.424883]  [<ffffffff8024df68>] insert_work+0x48/0x50
[    7.424883]  [<ffffffff8024e8f1>] __queue_work+0x31/0x50
[    7.424883]  [<ffffffff8024e942>] delayed_work_timer_fn+0x32/0x40
[    7.424883]  [<ffffffff80245e5b>] run_timer_softirq+0x1bb/0x230
[    7.424883]  [<ffffffff80255afa>] ? ktime_get_ts+0x4a/0x60
[    7.424883]  [<ffffffff8024157a>] __do_softirq+0x7a/0xf0
[    7.424883]  [<ffffffff8025cd8e>] ? tick_program_event+0x3e/0x70
[    7.424883]  [<ffffffff8020d69c>] call_softirq+0x1c/0x30
[    7.424883]  [<ffffffff8020f28d>] do_softirq+0x3d/0x80
[    7.424883]  [<ffffffff802414f5>] irq_exit+0x85/0x90
[    7.424883]  [<ffffffff8021d648>] smp_apic_timer_interrupt+0x88/0xc0
[    7.424883]  [<ffffffff8020d0e6>] apic_timer_interrupt+0x66/0x70
[    7.424883]  <EOI>  [<ffffffff804a1a1a>] ? oops_end+0x4a/0x90
[    7.424883]  [<ffffffff804a3d13>] ? do_page_fault+0x663/0x800
[    7.424883]  [<ffffffff804a162d>] ? error_exit+0x0/0x9a
[    7.424883]  [<ffffffff802740d0>] ? release_css_set_taskexit+0x0/0x10
[    7.424883]  [<ffffffff8023f39c>] ? do_exit+0x28c/0xa10
[    7.424883]  [<ffffffff8023f376>] ? do_exit+0x266/0xa10
[    7.424883]  [<ffffffff803c7d59>] ? do_unblank_screen+0x19/0x130
[    7.424883]  [<ffffffff804a1a57>] ? oops_end+0x87/0x90
[    7.424883]  [<ffffffff804a3d13>] ? do_page_fault+0x663/0x800
[    7.424883]  [<ffffffff804a162d>] ? error_exit+0x0/0x9a
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffff8025e302>] ? debug_mutex_add_waiter+0x32/0x80
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffff8049f596>] ? mutex_lock_nested+0xa6/0x250
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffff803635c4>] ? idr_pre_get+0x44/0x90
[    7.424883]  [<ffffffffa008f524>] ? get_idr+0x44/0xa0 [thermal_sys]
[    7.424883]  [<ffffffffa008fe43>] ? thermal_cooling_device_register+0x83/0x250 [thermal_sys]
[    7.424883]  [<ffffffffa019b2a3>] ? acpi_processor_start+0x64b/0x774 [processor]
[    7.424883]  [<ffffffff8031a94b>] ? __sysfs_add_one+0x6b/0xa0
[    7.424883]  [<ffffffff8031ba3c>] ? sysfs_do_create_link+0xbc/0x150
[    7.424883]  [<ffffffff803a7f5e>] ? acpi_start_single_object+0x2d/0x52
[    7.424883]  [<ffffffff803a9556>] ? acpi_device_probe+0x7e/0x92
[    7.424883]  [<ffffffff803dd3eb>] ? driver_probe_device+0x9b/0x1a0
[    7.424883]  [<ffffffff803dd576>] ? __driver_attach+0x86/0x90
[    7.424883]  [<ffffffff803dd4f0>] ? __driver_attach+0x0/0x90
[    7.424883]  [<ffffffff803dc93d>] ? bus_for_each_dev+0x5d/0x90
[    7.424883]  [<ffffffff803dd22c>] ? driver_attach+0x1c/0x20
[    7.424883]  [<ffffffff803dcf79>] ? bus_add_driver+0x1e9/0x260
[    7.424883]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.424883]  [<ffffffff803dd74f>] ? driver_register+0x5f/0x140
[    7.424883]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor]
[    7.424883]  [<ffffffff803a9866>] ? acpi_bus_register_driver+0x3e/0x40
[    7.424883]  [<ffffffffa0222094>] ? acpi_processor_init+0x94/0x107 [processor]
[    7.424883]  [<ffffffff80209040>] ? _stext+0x40/0x180
[    7.424883]  [<ffffffff802a8911>] ? __vunmap+0xa1/0x110
[    7.424883]  [<ffffffff802676c2>] ? sys_init_module+0x142/0x1dc0
[    7.424883]  [<ffffffff80367b16>] ? __up_read+0x46/0xb0
[    7.424883]  [<ffffffff8048e570>] ? cpu_down+0x0/0x70
[    7.424883]  [<ffffffff8020c34b>] ? system_call_fastpath+0x16/0x1b
[    7.424883]
[    7.424883] ---[ end trace 8bbd31df1403e48e ]---

--------------020200010504060403080007--
