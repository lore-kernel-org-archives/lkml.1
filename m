Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZDURhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZDURhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZDURho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:37:44 -0400
Received: from www.sr71.net ([198.145.64.142]:37818 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZDURhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:37:42 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2009 13:37:42 EDT
Subject: 2.6.30-rc2 soft lockups: ACPI?  clock source problem?
From: Dave Hansen <dave@sr71.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: jstultz <jstultz@us.ibm.com>, linux-acpi <linux-acpi@vger.kernel.org>,
       lenb@kernel.org
Content-Type: text/plain
Date: Tue, 21 Apr 2009 10:30:38 -0700
Message-Id: <1240335038.11194.11.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was during my first boot of 2.6.30-rc2.  At the end of all this,
there's a "Clocksource tsc unstable (delta = -222703151079 ns)" which
makes me think this probably wasn't a real soft lockup.  Maybe just a
bad guess since the clock source changed.  It seems really odd that both
CPUs would do this at precisely the same time, but in different code.

I'm including the ACPI folks since there was some ACPI stuff in here
that is way beyond me. :)

[   76.657737] ACPI: SSDT bf6e1b32 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[   76.676235] ACPI: SSDT bf6e1e7b 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[   76.695503] Monitor-Mwait will be used to enter C-1 state
[   76.695531] Monitor-Mwait will be used to enter C-2 state
[   76.695557] Monitor-Mwait will be used to enter C-3 state
[  299.485576] BUG: soft lockup - CPU#1 stuck for 207s! [udevd:3994]
[  299.485639] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[  299.485680] processor ACPI_CPU:00: registered as cooling_device0
[  299.485684] ACPI: Processor [CPU0] (supports 8 throttling states)
[  299.485576] Modules linked in: processor(+) ohci1394 ehci_hcd uhci_hcd ieee1394 usbcore thermal fan fuse
[  299.485576] 
[  299.485576] Pid: 3994, comm: udevd Not tainted (2.6.30-rc2 #304) 7659A71
[  299.485576] EIP: 0060:[<c014d0f5>] EFLAGS: 00000202 CPU: 1
[  299.485576] EIP is at current_kernel_time+0x35/0x40
[  299.485576] EAX: 00009529 EBX: f75cf400 ECX: 00000000 EDX: f7687480
[  299.485576] ESI: f70a49a0 EDI: f765ac80 EBP: f749de38 ESP: f749de2c
[  299.485576]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  299.485576] CR0: 8005003b CR2: b7f09078 CR3: 36db7000 CR4: 000006b0
[  299.485576] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  299.485576] DR6: ffff0ff0 DR7: 00000400
[  299.485576] Call Trace:
[  299.485576]  [<c013629b>] current_fs_time+0xb/0x20
[  299.485576]  [<c01ba7b8>] file_update_time+0x48/0xc0
[  299.485576]  [<c01af03f>] pipe_write+0x2ff/0x410
[  299.485576]  [<c013f2a6>] ? get_signal_to_deliver+0x276/0x380
[  299.485576]  [<c01a7bed>] do_sync_write+0xcd/0x110
[  299.485576]  [<c0145cd0>] ? autoremove_wake_function+0x0/0x40
[  299.485576]  [<c0191d89>] ? remove_vma+0x49/0x60
[  299.485576]  [<c01a8436>] vfs_write+0x96/0x160
[  299.485576]  [<c01a7b20>] ? do_sync_write+0x0/0x110
[  299.485576]  [<c01a8afd>] sys_write+0x3d/0x70
[  299.485576]  [<c0102e18>] sysenter_do_call+0x12/0x2c
[  299.489571] BUG: soft lockup - CPU#0 stuck for 218s! [modprobe:4100]
[  299.782577] Modules linked in: processor(+) ohci1394 ehci_hcd uhci_hcd ieee1394 usbcore thermal fan fuse
[  299.782577] 
[  299.782577] Pid: 4100, comm: modprobe Not tainted (2.6.30-rc2 #304) 7659A71
[  299.782577] EIP: 0060:[<c0154732>] EFLAGS: 00000202 CPU: 0
[  299.825706] EIP is at csd_lock_wait+0x12/0x20
[  299.835629] EAX: f6438ab4 EBX: c3e034c0 ECX: c0513960 EDX: 000008fb
[  299.845535] ESI: c3e034c8 EDI: f6438ab4 EBP: f6438a7c ESP: f6438a7c
[  299.866504]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  299.876407] CR0: 8005003b CR2: b7e52044 CR3: 36877000 CR4: 000006b0
[  299.886279] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  299.886279] DR6: ffff0ff0 DR7: 00000400
[  299.906715] Call Trace:
[  299.906715]  [<c015483b>] generic_exec_single+0x5b/0x80
[  299.926543]  [<c01549e6>] smp_call_function_single+0xf6/0x110
[  299.936708]  [<c011fa20>] ? do_flush_tlb_all+0x0/0x40
[  299.936708]  [<c011fa20>] ? do_flush_tlb_all+0x0/0x40
[  299.936708]  [<c011fa20>] ? do_flush_tlb_all+0x0/0x40
[  299.936708]  [<c0154aa4>] smp_call_function_many+0xa4/0x1c0
[  299.936708]  [<c011fa20>] ? do_flush_tlb_all+0x0/0x40
[  299.936708]  [<c011fa20>] ? do_flush_tlb_all+0x0/0x40
[  299.936708]  [<c0154be1>] smp_call_function+0x21/0x30
[  299.936708]  [<c01368aa>] on_each_cpu+0x1a/0x40
[  299.936708]  [<c011f9e4>] flush_tlb_all+0x14/0x20
[  299.936708]  [<c0196c71>] __purge_vmap_area_lazy+0x101/0x160
[  299.936708]  [<c019875f>] vm_unmap_aliases+0x11f/0x130
[  299.936708]  [<c011c7b0>] change_page_attr_set_clr+0xf0/0x3f0
[  299.936708]  [<c011c7b0>] change_page_attr_set_clr+0xf0/0x3f0
[  299.936708]  [<c0137cfe>] ? iomem_map_sanity_check+0xce/0x140
[  299.936708]  [<c019710e>] ? __get_vm_area_node+0x10e/0x1c0
[  299.936708]  [<c0247fce>] ? ioremap_page_range+0x1be/0x240
[  299.936708]  [<c011ce18>] _set_memory_uc+0x48/0x50
[  299.936708]  [<c011b12b>] ioremap_change_attr+0x1b/0x30
[  299.936708]  [<c011b320>] __ioremap_caller+0x1e0/0x3e0
[  299.936708]  [<c028edc8>] ? acpi_ut_update_object_reference+0xba/0x11b
[  299.936708]  [<c03c79f8>] ? acpi_os_map_memory+0x15/0x2d
[  299.936708]  [<c011b65a>] ioremap_nocache+0x1a/0x20
[  299.936708]  [<c03c79f8>] ? acpi_os_map_memory+0x15/0x2d
[  299.936708]  [<c03c79f8>] acpi_os_map_memory+0x15/0x2d
[  299.936708]  [<c0280110>] acpi_ex_load_op+0x65/0x215
[  299.936708]  [<c02827fb>] acpi_ex_opcode_1A_1T_0R+0x20/0x44
[  299.936708]  [<c027acad>] acpi_ds_exec_end_op+0xd1/0x35c
[  299.936708]  [<c028a203>] acpi_ps_parse_loop+0x5a8/0x72d
[  299.936708]  [<c028964f>] acpi_ps_parse_aml+0x87/0x281
[  299.936708]  [<c028a940>] acpi_ps_execute_method+0x185/0x229
[  299.936708]  [<c0287343>] acpi_ns_evaluate+0xcb/0x17c
[  299.936708]  [<c0286e85>] acpi_evaluate_object+0x14c/0x229
[  299.936708]  [<f8316a3a>] acpi_processor_start+0x532/0x666 [processor]
[  299.936708]  [<c0272ce6>] acpi_start_single_object+0x20/0x3d
[  299.936708]  [<c0272ee5>] acpi_device_probe+0x7a/0x127
[  299.936708]  [<c02dbf89>] driver_probe_device+0x69/0x150
[  299.936708]  [<c02dc0e5>] __driver_attach+0x75/0x80
[  299.936708]  [<c02db583>] bus_for_each_dev+0x43/0x70
[  299.936708]  [<c0272d9d>] ? acpi_device_remove+0x0/0xce
[  299.936708]  [<c02dbe29>] driver_attach+0x19/0x20
[  299.936708]  [<c02dc070>] ? __driver_attach+0x0/0x80
[  299.936708]  [<c02dbb6c>] bus_add_driver+0xcc/0x270
[  299.936708]  [<c0272d9d>] ? acpi_device_remove+0x0/0xce
[  299.936708]  [<c02dc3aa>] driver_register+0x5a/0x120
[  299.936708]  [<f827d000>] ? acpi_processor_init+0x0/0xe3 [processor]
[  299.936708]  [<f827d000>] ? acpi_processor_init+0x0/0xe3 [processor]
[  299.936708]  [<c0274532>] acpi_bus_register_driver+0x3a/0x3c
[  299.936708]  [<f827d07a>] acpi_processor_init+0x7a/0xe3 [processor]
[  299.936708]  [<c010112a>] do_one_initcall+0x2a/0x150
[  299.936708]  [<c016eac8>] ? tracepoint_module_notify+0x28/0x30
[  299.936708]  [<c03d9b2d>] ? notifier_call_chain+0x2d/0x60
[  299.936708]  [<c0149e1d>] ? __blocking_notifier_call_chain+0x4d/0x60
[  299.936708]  [<c0158f73>] sys_init_module+0x83/0x1c0
[  299.936708]  [<c0102e18>] sysenter_do_call+0x12/0x2c
[  300.507349] ACPI: SSDT bf6e1a6a 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[  300.523720] ACPI: SSDT bf6e1df6 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[  300.632658] Clocksource tsc unstable (delta = -222703151079 ns)
[  300.644998] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4


-- Dave

