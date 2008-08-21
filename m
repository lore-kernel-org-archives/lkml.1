Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYHUUTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYHUUTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbYHUUT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:19:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40007 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757996AbYHUUT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:19:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: latest -git: suspend: unable to handle kernel paging request (was Re: no_console_suspend doesn't work?)
Date: Thu, 21 Aug 2008 22:22:44 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com> <200808212137.52757.rjw@sisk.pl> <19f34abd0808211308t2ee63a37kc204a5849231af45@mail.gmail.com>
In-Reply-To: <19f34abd0808211308t2ee63a37kc204a5849231af45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212222.45444.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, Vegard Nossum wrote:
> On Thu, Aug 21, 2008 at 9:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Can you switch to SLAB and retest?  I don't really think SLUB is the issue
> > here, but SLAB may give us additional information.
> 
> Got this with SLAB:

Well, it looks like this happened while devices were suspended, but I can't say
what's going wrong.  Andrew?  Who's the right person to CC?

> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c03897ac>] list_del+0xc/0x90
> *pdpt = 0000000031480001 *pde = 0000000000000000
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 7, comm: events/0 Not tainted (2.6.27-rc4-00003-gef9b1bc #33)
> EIP: 0060:[<c03897ac>] EFLAGS: 00010082 CPU: 0
> EIP is at list_del+0xc/0x90
> EAX: 00000000 EBX: f556afa0 ECX: f54a5380 EDX: f54e3128
> ESI: f54f1ef0 EDI: f556afa0 EBP: f68b7ee0 ESP: f68b7ec8
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process events/0 (pid: 7, ti=f68b6000 task=f689c338 task.ti=f68b6000)
> Stack: c015b62e f68b7ed4 c015b66d f68b7efc 00000046 f54f1f20 f68b7f1c c01b4054
>        00000000 f689c338 f54e315c 00000001 f54f1f20 f54a5380 00000000 f54e3128
>        f55b3348 00000000 f54f1f20 f54f1ef0 00000001 f68b7f3c c01b41ba 00000000
> Call Trace:
>  [<c015b62e>] ? get_lock_stats+0x1e/0x50
>  [<c015b66d>] ? put_lock_stats+0xd/0x30
>  [<c01b4054>] ? free_block+0xa4/0x1b0
>  [<c01b41ba>] ? drain_array+0x5a/0xb0
>  [<c01b4f82>] ? cache_reap+0x72/0x230
>  [<c014ada7>] ? run_workqueue+0x107/0x200
>  [<c014ae0a>] ? run_workqueue+0x16a/0x200
>  [<c014ada7>] ? run_workqueue+0x107/0x200
>  [<c01b4f10>] ? cache_reap+0x0/0x230
>  [<c014b94d>] ? worker_thread+0x7d/0xe0
>  [<c014e4f0>] ? autoremove_wake_function+0x0/0x50
>  [<c014b8d0>] ? worker_thread+0x0/0xe0
>  [<c014e1e2>] ? kthread+0x42/0x70
>  [<c014e1a0>] ? kthread+0x0/0x70
>  [<c0105cf3>] ? kernel_thread_helper+0x7/0x14
>  =======================
> Code: e8 01 89 44 24 04 e8 d4 1d db ff 8b 55 04 b8 48 2f 7a c0 e8 47 d8 dd ff e8
>  c2 dc d7 ff eb a9 55 89 e5 53 89 c3 83 ec 14 8b 40 04 <8b> 00 39 d8 75 24 8b 13
>  8b 42 04 39 d8 75 41 8b 43 04 89 42 04
> EIP: [<c03897ac>] list_del+0xc/0x90 SS:ESP 0068:f68b7ec8
> ---[ end trace 958cea1a710a109a ]---
> note: events/0[7] exited with preempt_count 1
> uhci_hcd 0000:00:1d.2: setting latency timer to 64
> uhci_hcd 0000:00:1d.3: setting latency timer to 64
> ehci_hcd 0000:00:1d.7: setting latency timer to 64
> pci 0000:00:1e.0: setting latency timer to 64
> ------------[ cut here ]------------
> WARNING: at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/lib/list_debug.c:26
> __list_add+0x61/0x90()
> list_add corruption. next->prev should be prev (f6c00490), but was
> f73ecea8. (next=f73ecea8).
> Pid: 201, comm: rcu_torture_rea Tainted: G      D
> 2.6.27-rc4-00003-gef9b1bc #33
>  [<c013a58e>] warn_slowpath+0x5e/0x80
>  [<c015b60b>] ? trace_hardirqs_off+0xb/0x10
>  [<c010b325>] ? native_sched_clock+0xb5/0x110
>  [<c0125c36>] ? kernel_map_pages+0xa6/0x130
>  [<c0389891>] __list_add+0x61/0x90
>  [<c018c978>] __free_pages_ok+0x368/0x410
>  [<c018ccf2>] __free_pages+0x22/0x40
>  [<c018cd58>] free_pages+0x48/0x50
>  [<c010be69>] free_thread_info+0x19/0x20
>  [<c0138929>] free_task+0x19/0x30
>  [<c0139e31>] __put_task_struct+0x51/0xa0
>  [<c013c0b7>] delayed_put_task_struct+0x27/0x30
>  [<c018206c>] rcu_process_callbacks+0x6c/0xb0
>  [<c013f5b3>] __do_softirq+0x83/0x100
>  [<c013f6d5>] do_softirq+0xa5/0xb0
>  [<c013f975>] irq_exit+0x95/0xa0
>  [<c010813d>] do_IRQ+0x4d/0xa0
>  [<c037a264>] ? trace_hardirqs_off_thunk+0xc/0x18
>  [<c0105a3c>] common_interrupt+0x28/0x30
>  [<c0683b44>] ? schedule+0x734/0x8f0
>  [<c068007b>] ? start_secondary+0x19b/0x1c0
>  [<c06800d8>] ? check_tsc_warp+0x38/0x1e0
>  [<c068695b>] ? _spin_unlock_irq+0x2b/0x60
>  [<c0683b44>] schedule+0x734/0x8f0
>  [<c010509e>] ? restore_nocheck_notrace+0x0/
>  [<c015e93b>] ? trace_hardirqs_on+0xb/0x10
>  [<c0180c88>] rcu_torture_reader+0x148/0x230
>  [<c0181460>] ? rcu_torture_timer+0x0/0x100
>  [<c0180d19>] ? rcu_torture_reader+0x1d9/0x230
>  [<c0180b40>] ? rcu_torture_reader+0x0/0x230
>  [<c014e1e2>] kthread+0x42/0x70
>  [<c014e1a0>] ? kthread+0x0/0x70
>  [<c0105cf3>] kernel_thread_helper+0x7/0x14
>  =======================
> ---[ end trace 958cea1a710a109a ]---
> eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
> eth1: link down
> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hda: UDMA/100 mode selected
> ------------[ cut here ]------------
> kernel BUG at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/mm/slab.c:590!
> invalid opcode: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 3257, comm: S99local Tainted: G      D W (2.6.27-rc4-00003-gef9b1bc #33)
> EIP: 0060:[<c01b24c0>] EFLAGS: 00210002 CPU: 0
> EIP is at cache_free_debugcheck+0x2e0/0x310
> EAX: 00000000 EBX: f4c1f688 ECX: c018976e EDX: f785f744
> ESI: f6864180 EDI: f4c1f688 EBP: f25b1de8 ESP: f25b1d94
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process S99local (pid: 3257, ti=f25b0000 task=f253f338 task.ti=f25b0000)
> Stack: 00200200 f4c1f688 00000000 f25b1e20 f25b1dac c0683402 f25b1e58 c018976e
>        00000001 c036a7b0 00000002 00000000 00000000 c088c190 f253f338 f4c1f688
>        f253f338 f25b1df8 f6864180 f6960ef0 f4c1f688 f25b1e0c c01b3c9c f253f7f4
> Call Trace:
>  [<c0683402>] ? wait_for_completion+0x12/0x20
>  [<c018976e>] ? mempool_free_slab+0xe/0x10
>  [<c036a7b0>] ? blk_end_sync_rq+0x0/0x30
>  [<c01b3c9c>] ? kmem_cache_free+0x5c/0x200
>  [<c018976e>] ? mempool_free_slab+0xe/0x10
>  [<c018979c>] ? mempool_free+0x2c/0x90
>  [<c0367252>] ? __blk_put_request+0x62/0x90
>  [<c036764c>] ? blk_put_request+0x2c/0x50
>  [<c0470732>] ? generic_ide_resume+0xa2/0xf0
>  [<c03f767e>] ? device_resume+0x32e/0x380
>  [<c01687d1>] ? hibernation_snapshot+0xa1/0x220
>  [<c013b57b>] ? printk+0x1b/0x20
>  [<c0168a30>] ? hibernate+0xe0/0x180
>  [<c01674e0>] ? state_store+0x0/0xd0
>  [<c016759f>] ? state_store+0xbf/0xd0
>  [<c01674e0>] ? state_store+0x0/0xd0
>  [<c03749d4>] ? kobj_attr_store+0x24/0x30
>  [<c01f8ef2>] ? sysfs_write_file+0xa2/0x100
>  [<c01ba946>] ? vfs_write+0x96/0x130
>  [<c01f8e50>] ? sysfs_write_file+0x0/0x100
>  [<c01bae8d>] ? sys_write+0x3d/0x70
>  [<c0104f3b>] ? sysenter_do_call+0x12/0x3f
>  =======================
> Code: 00 00 75 cd c7 03 21 43 65 87 8b 5e 28 e9 78 ff ff ff 0f 0b eb fe 90 8d 74
>  26 00 8b 52 0c e9 ca fd ff ff 0f 0b eb fe 8d 74 26 00 <0f> 0b eb fe 0f 0b eb fe
>  0f 0b eb fe 8d 74 26 00 8b 52 0c 8b 02
> EIP: [<c01b24c0>] cache_free_debugcheck+0x2e0/0x310 SS:ESP 0068:f25b1d94
> ---[ end trace 958cea1a710a109a ]---
> note: S99local[3257] exited with preempt_count 1
> BUG: sleeping function called from invalid context at
> /uio/arkimedes/s29/vegardno/git-working/linux-2.6/kernel/rwsem.c:21
> in_atomic():1, irqs_disabled():0
> INFO: lockdep is turned off.
> Pid: 3257, comm: S99local Tainted: G      D W 2.6.27-rc4-00003-gef9b1bc #33
>  [<c01312c1>] __might_sleep+0xf1/0x140
>  [<c0684fe9>] down_read+0x19/0x80
>  [<c03e007b>] ? tty_audit_add_data+0x1bb/0x2e0
>  [<c013c33b>] exit_mm+0x2b/0x110
>  [<c013d7c4>] do_exit+0x184/0x890
>  [<c013b57b>] ? printk+0x1b/0x20
>  [<c013a52a>] ? print_oops_end_marker+0x2a/0x30
>  [<c01060f1>] oops_end+0xb1/0xc0
>  [<c01067c0>] die+0x50/0x70
>  [<c0106871>] do_trap+0x91/0xc0
> BUG: unable to handle kernel paging request at 00100104
> IP: [<c0389845>] __list_add+0x15/0x90
> *pdpt = 0000000031480001 *pde = 0000000000000000
> Oops: 0000 [#3] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 3257, comm: S99local Tainted: G      D W (2.6.27-rc4-00003-gef9b1bc #33)
> EIP: 0060:[<c0389845>] EFLAGS: 00210086 CPU: 0
> EIP is at __list_add+0x15/0x90
> EAX: f73ece6c EBX: 00100100 ECX: 00100100 EDX: f73ece6c
> ESI: f73ece6c EDI: f73ece6c EBP: f25b16dc ESP: f25b16b8
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process S99local (pid: 3257, ti=f25b0000 task=f253f338 task.ti=f25b0000)
> Stack: f6814e44 f6c00400 c06860b3 00000000 00000002 00000000 f73ece3c f73ece6c
>        f73ece6c f25b1704 c018b9e4 0000001f 00000000 f6c00400 f6c00444 00000001
>        f6814e44 f6814e38 00200002 f25b1778 c018d3a7 f6814e44 00000000 00000000
> Call Trace:
>  [<c06860b3>] ? _spin_lock+0x63/0x70
>  [<c018b9e4>] ? rmqueue_bulk+0x54/0x80
>  [<c018d3a7>] ? get_page_from_freelist+0x5a7/0x720
>  [<c018dde0>] ? __alloc_pages_internal+0xa0/0x450
>  [<c01b25a2>] ? kmem_getpages+0x62/0x110
>  [<c01b2f4c>] ? cache_grow+0x39c/0x3b0
>  [<c03890b6>] ? _raw_spin_unlock+0x46/0x80
>  [<c01b3503>] ? cache_alloc_refill+0x1f3/0x230
>  [<c01b36e5>] ? __kmalloc+0x1a5/0x1e0
>  [<c03cd9b2>] ? tty_buffer_request_room+0xe2/0x130
>  [<c03cd9b2>] ? tty_buffer_request_room+0xe2/0x130
>  [<c03cfe0d>] ? tty_insert_flip_string_flags+0x2d/0xa0
>  [<c03ee7b1>] ? receive_chars+0x161/0x290
>  [<c03ef7e4>] ? serial8250_interrupt+0x134/0x150
>  [<c017dc08>] ? handle_IRQ_event+0x28/0x70
>  [<c017f1cf>] ? handle_edge_irq+0xaf/0x140
>  [<c0108138>] ? do_IRQ+0x48/0xa0
>  [<c037a264>] ? trace_hardirqs_off_thunk+0xc/0x18
>  [<c0105a3c>] ? common_interrupt+0x28/0x30
>  [<c013b2f1>] ? vprintk+0x151/0x3c0
>  [<c0143e5f>] ? run_timer_softirq+0x19f/0x1d0
>  [<c0143e5f>] ? run_timer_softirq+0x19f/0x1d0
>  [<c013b57b>] ? printk+0x1b/0x20
>  [<c016700a>] ? __print_symbol+0x2a/0x40
>  [<c037a254>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c010509e>] ? restore_nocheck_notrace+0x0/0xe
>  [<c013b2f1>] ? vprintk+0x151/0x3c0
>  [<c013b47b>] ? vprintk+0x2db/0x3c0
>  [<c013f91a>] ? irq_exit+0x3a/0xa0
>  [<c010509e>] ? restore_nocheck_notrace+0x0/0xe
>  [<c013b2f1>] ? vprintk+0x151/0x3c0
>  [<c0106871>] ? do_trap+0x91/0xc0
>  [<c013b57b>] ? printk+0x1b/0x20
>  [<c0106871>] ? do_trap+0x91/0xc0
>  [<c01061f0>] ? print_trace_address+0x40/0x50
>  [<c0106871>] ? do_trap+0x91/0xc0
>  [<c01062aa>] ? dump_trace+0xaa/0x120
>  [<c0106346>] ? show_trace_log_lvl+0x26/0x40
>  [<c0106b8a>] ? show_trace+0x1a/0x20
>  [<c01074d2>] ? dump_stack+0x72/0x80
>  [<c01312c1>] ? __might_sleep+0xf1/0x140
>  [<c0684fe9>] ? down_read+0x19/0x80
>  [<c03e007b>] ? tty_audit_add_data+0x1bb/0x2e0
>  [<c013c33b>] ? exit_mm+0x2b/0x110
>  [<c013d7c4>] ? do_exit+0x184/0x890
>  [<c013b57b>] ? printk+0x1b/0x20
>  [<c013a52a>] ? print_oops_end_marker+0x2a/0x30
>  [<c01060f1>] ? oops_end+0xb1/0xc0
>  [<c01067c0>] ? die+0x50/0x70
>  [<c0106871>] ? do_trap+0x91/0xc0
>  [<c0106940>] ? do_invalid_op+0x0/0xa0
>  [<c01069c8>] ? do_invalid_op+0x88/0xa0
>  [<c01b24c0>] ? cache_free_debugcheck+0x2e0/0x310
>  [<c015c60a>] ? print_lock_contention_bug+0x1a/0xe0
>  [<c0182527>] ? rcu_irq_exit+0x17/0x90
>  [<c0686cba>] ? error_code+0x72/0x78
>  [<c018976e>] ? mempool_free_slab+0xe/0x10
>  [<c068007b>] ? start_secondary+0x19b/0x1c0
>  [<c06800d8>] ? check_tsc_warp+0x38/0x1e0
>  [<c01b24c0>] ? cache_free_debugcheck+0x2e0/0x310
>  [<c0683402>] ? wait_for_completion+0x12/0x20
>  [<c018976e>] ? mempool_free_slab+0xe/0x10
>  [<c036a7b0>] ? blk_end_sync_rq+0x0/0x30
>  [<c01b3c9c>] ? kmem_cache_free+0x5c/0x200
>  [<c018976e>] ? mempool_free_slab+0xe/0x10
>  [<c018979c>] ? mempool_free+0x2c/0x90
>  [<c0367252>] ? __blk_put_request+0x62/0x90
>  [<c036764c>] ? blk_put_request+0x2c/0x50
>  [<c0470732>] ? generic_ide_resume+0xa2/0xf0
>  [<c03f767e>] ? device_resume+0x32e/0x380
>  [<c01687d1>] ? hibernation_snapshot+0xa1/0x220
>  [<c013b57b>] ? printk+0x1b/0x20
>  [<c0168a30>] ? hibernate+0xe0/0x180
>  [<c01674e0>] ? state_store+0x0/0xd0
>  [<c016759f>] ? state_store+0xbf/0xd0
>  [<c01674e0>] ? state_store+0x0/0xd0
>  [<c03749d4>] ? kobj_attr_store+0x24/0x30
>  [<c01f8ef2>] ? sysfs_write_file+0xa2/0x100
>  [<c01ba946>] ? vfs_write+0x96/0x130
>  [<c01f8e50>] ? sysfs_write_file+0x0/0x100
>  [<c01bae8d>] ? sys_write+0x3d/0x70
>  [<c0104f3b>] ? sysenter_do_call+0x12/0x3f
>  =======================
> Code: c0 e8 10 0d db ff 8b 13 eb 97 8d b6 00 00 00 00 8d bf 00 00 00 00 55 89 e5
>  83 ec 24 89 5d f4 89 cb 89 75 f8 89 d6 89 7d fc 89 c7 <8b> 41 04 39 d0 75 1d 8b
>  06 39 d8 75 41 89 7b 04 89 1f 8b 5d f4
> EIP: [<c0389845>] __list_add+0x15/0x90 SS:ESP 0068:f25b16b8
> Kernel panic - not syncing: Fatal exception in interrupt
> ------------[ cut here ]------------
> WARNING: at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/kernel/smp.c:328
> smp_call_function_mask+0x1b1/0x1c0()
> Pid: 3257, comm: S99local Tainted: G      D W 2.6.27-rc4-00f9b1bc #33
>  [<c013a97f>] warn_on_slowpath+0x4f/0x80
>  [<c0397ff4>] ? vgacon_set_cursor_size+0xa4/0x120
>  [<c015b60b>] ? trace_hardirqs_off+0xb/0x10
>  [<c018214b>] ? __rcu_read_unlock+0x9b/0xc0
>  [<c015332c>] ? __atomic_notifier_call_chain+0x3c/0x50
>  [<c03db7fd>] ? vt_console_print+0x1dd/0x2a0
>  [<c015335a>] ? atomic_notifier_call_chain+0x1a/0x20
>  [<c03890b6>] ? _raw_spin_unlock+0x46/0x80
>  [<c068680c>] ? _spin_unlock+0x3c/0x50
>  [<c03db7fd>] ? vt_console_print+0x1dd/0x2a0
>  [<c015b60b>] ? trace_hardirqs_off+0xb/0x10
>  [<c013af61>] ? release_console_sem+0x1c1/0x1f0
>  [<c015b60b>] ? trace_hardirqs_off+0xb/0x10
>  [<c0165f81>] smp_call_function_mask+0x1b1/0x1c0
>  [<c0119280>] ? stop_this_cpu+0x0/0x50
>  [<c0684808>] ? mutex_unlock+0x8/0x10
>  [<c015b60b>] ? trace_hardirqs_off+0xb/0x10
>  [<c06847f1>] ? __mutex_unlock_slowpath+0x151/0x160
>  [<c0684808>] ? mutex_unlock+0x8/0x10
>  [<c016c46d>] ? crash_kexec+0x6d/0xc0
>  [<c0684808>] ? mutex_unlock+0x8/0x10
>  [<c016c46d>] ? crash_kexec+0x6d/0xc0
>  [<c0119280>] ? stop_this_cpu+0x0/0x50
>  [<c0165fc0>] smp_call_function+0x30/0x60
>  [<c011937e>] native_smp_send_stop+0x1e/0x70
>  [<c013a879>] panic+0x69/0x120
>  [<c01060e5>] oops_end+0xa5/0xc0
>  [<c01067c0>] die+0x50/0x70
>  [<c0122b4f>] do_page_fault+0x1ef/0xa20
>  [<c0122960>] ? do_page_fault+0x0/0xa20
>  [<c0686cba>] error_code+0x72/0x78
>  [<c0389845>] ? __list_add+0x15/0x90
>  [<c06860b3>] ? _spin_lock+0x63/0x70
>  [<c018b9e4>] rmqueue_bulk+0x54/0x80
>  [<c018d3a7>] get_page_from_freelist+0x5a7/0x720
>  [<c018dde0>] __alloc_pages_internal+0xa0/0x450
>  [<c01b25a2>] kmem_getpages+0x62/0x110
>  [<c01b2f4c>] cache_grow+0x39c/0x3b0
>  [<c03890b6>] ? _raw_spin_unlock+0x46/0x80
>  [<c01b3503>] cache_alloc_refill+0x1f3/0x230
>  [<c01b36e5>] __kmalloc+0x1a5/0x1e0
>  [<c03cd9b2>] ? tty_buffer_request_room+0xe2/0x130
>  [<c03cd9b2>] tty_buffer_request_room+0xe2/0x130
>  [<c03cfe0d>] tty_insert_flip_string_flags+0x2d/0xa0
>  [<c03ee7b1>] receive_chars+0x161/0x290
>  [<c03ef7e4>] serial8250_interrupt+0x134/0x150
>  [<c017dc08>] handle_IRQ_event+0x28/0x70
>  [<c017f1cf>] handle_edge_irq+0xaf/0x140
>  [<c0108138>] do_IRQ+0x48/0xa0
>  [<c037a264>] ? trace_hardirqs_off_thunk+0xc/0x18
>  [<c0105a3c>] common_interrupt+0x28/0x30
>  [<c013b2f1>] ? vprintk+0x151/0x3c0
>  [<c0143e5f>] ? run_timer_softirq+0x19f/0x1d0
>  [<c0143e5f>] ? run_timer_softirq+0x19f/0x1d0
>  [<c013b57b>] printk+0x1b/0x20
>  [<c016700a>] __print_symbol+0x2a/0x40
>  [<c037a254>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c010509e>] ? restore_nocheck_notrace+0x0/0xe
>  [<c013b2f1>] ? vprintk+0x151/0x3c0
>  [<c013b47b>] ? vprintk+0x2db/0x3c0
>  [<c013f91a>] ? irq_exit+0x3a/0xa0
>  [<c010509e>] ? restore_nocheck_notrace+0x0/0xe
>  [<c013b2f1>] ? vprintk+0x151/0x3c0
>  [<c0106871>] ? do_trap+0x91/0xc0
>  [<c013b57b>] ? printk+0x1b/0x20
>  [<c0106871>] ? do_trap+0x91/0xc0
>  [<c01061f0>] print_trace_address+0x40/0x50
>  [<c0106871>] ? do_trap+0x91/0xc0
>  [<c01062aa>] dump_trace+0xaa/0x120
>  [<c0106346>] show_trace_log_lvl+0x26/0x40
>  [<c0106b8a>] show_trace+0x1a/0x20
>  [<c01074d2>] dump_stack+0x72/0x80
>  [<c01312c1>] __might_sleep+0xf1/0x140
>  [<c0684fe9>] down_read+0x19/0x80
>  [<c03e007b>] ? tty_audit_add_data+0x1bb/0x2e0
>  [<c013c33b>] exit_mm+0x2b/0x110
>  [<c013d7c4>] do_exit+0x184/0x890
>  [<c013b57b>] ? printk+0x1b/0x20
>  [<c013a52a>] ? print_oops_end_marker+0x2a/0x30
>  [<c01060f1>] oops_end+0xb1/0xc0
>  [<c01067c0>] die+0x50/0x70
>  [<c0106871>] do_trap+0x91/0xc0
>  [<c0106940>] ? do_invalid_op+0x0/0xa0
>  [<c01069c8>] do_invalid_op+0x88/0xa0
>  [<c01b24c0>] ? cache_free_debugcheck+0x2e0/0x310
>  [<c015c60a>] ? print_lock_contention_bug+0x1a/0xe0
>  [<c0182527>] ? rcu_irq_exit+0x17/0x90
>  [<c0686cba>] error_code+0x72/0x78
>  [<c018976e>] ? mempool_free_slab+0xe/0x10
>  [<c068007b>] ? start_secondary+0x19b/0x1c0
>  [<c06800d8>] ? check_tsc_warp+0x38/0x1e0
>  [<c01b24c0>] ? cache_free_debugcheck+0x2e0/0x310
>  [<c0683402>] ? wait_for_completion+0x12/0x20
>  [<c018976e>] ? mempool_free_slab+0xe/0x10
>  [<c036a7b0>] ? blk_end_sync_rq+0x0/0x30
>  [<c01b3c9c>] kmem_cache_free+0x5c/0x200
>  [<c018976e>] mempool_free_slab+0xe/0x10
>  [<c018979c>] mempool_free+0x2c/0x90
>  [<c0367252>] __blk_put_request+0x62/0x90
>  [<c036764c>] blk_put_request+0x2c/0x50
>  [<c0470732>] generic_ide_resume+0xa2/0xf0
>  [<c03f767e>] device_resume+0x32e/0x380
>  [<c01687d1>] hibernation_snapshot+0xa1/0x220
>  [<c013b57b>] ? printk+0x1b/0x20
>  [<c0168a30>] hibernate+0xe0/0x180
>  [<c01674e0>] ? state_store+0x0/0xd0
>  [<c016759f>] state_store+0xbf/0xd0
>  [<c01674e0>] ? state_store+0x0/0xd0
>  [<c03749d4>] kobj_attr_store+0x24/0x30
>  [<c01f8ef2>] sysfs_write_file+0xa2/0x100
>  [<c01ba946>] vfs_write+0x96/0x130
>  [<c01f8e50>] ? sysfs_write_file+0x0/0x100
>  [<c01bae8d>] sys_write+0x3d/0x70
>  [<c0104f3b>] sysenter_do_call+0x12/0x3f
>  =======================
> ---[ end trace 958cea1a710a109a ]---
> Rebooting in 10 seconds..Initializing cgroup subsys cpuset
> 
> 
> Vegard
> 


