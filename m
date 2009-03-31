Return-Path: <linux-kernel-owner+w=401wt.eu-S1763593AbZCaWk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763593AbZCaWk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZCaWkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:40:49 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:63173 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbZCaWkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <200902142304.00339.rjw@sisk.pl>
References: <B4ED8DE8E195E84A872496A085BC07822F11@exchange01.corp.win-professional.com>
	 <20090206155038.67847521.akpm@linux-foundation.org>
	 <B4ED8DE8E195E84A872496A085BC07822F2E@exchange01.corp.win-professional.com>
	 <200902142304.00339.rjw@sisk.pl>
Date: Wed, 1 Apr 2009 00:40:44 +0200
Message-ID: <897274600903311540x5fb067c3r758da0ddab97947a@mail.gmail.com>
Subject: Re: linux 2.6.29-rc3 kernel failure with mptsas
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/14 Rafael J. Wysocki <rjw@sisk.pl>:
> On Saturday 14 February 2009, Morten P.D. Stevens wrote:
>> Update:
>>
>> today i installed linux 2.6.29-rc5 and there a no problems?
>>
>> no errors or kernel failures in dmesg.
>>
>> linux 2.6.29-rc5 works fine but something is strange:
>>
>> > -   init_timer(&pCfg->timer);
>> > +   init_timer_on_stack(&pCfg->timer);
>>
>> this wasn't changed?
>>
>> Anyway it´s working fine with 2.6.29-rc5, now.
>
> Thanks for the update.  I'm going to close this bug.
>
> Rafael
>

Hi,

the problem is back with 2.6.29 final. I tested it with a clean self
build kernel (2.6.29 vanilla sources) and a fedora 11 beta livecd
(based on 2.6.29-rc8)

------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a0/0x33d()
(Not tainted)
Hardware name: Precision WorkStation T7400
Modules linked in: ext4 jbd2 crc16 squashfs firewire_ohci(+) pata_acpi
firewire_core mptsas(+) crc_itu_t ata_generic mptscsih nouveau mptbase
scsi_transport_sas drm i2c_core
Pid: 36, comm: work_on_cpu/0 Not tainted
2.6.29-0.258.2.3.rc8.git2.fc11.x86_64 #1
Call Trace:
 [<ffffffff8104bae3>] warn_slowpath+0xbc/0xf0
 [<ffffffff8104c0ba>] ? release_console_sem+0x1c3/0x1f4
 [<ffffffff8101781b>] ? native_sched_clock+0x2d/0x5a
 [<ffffffff81393b9b>] ? printk+0x41/0x46
 [<ffffffff811a2a44>] __debug_object_init+0x2a0/0x33d
 [<ffffffff811a2b0e>] debug_object_init+0x14/0x16
 [<ffffffff81055ea2>] init_timer+0x1d/0x60
 [<ffffffffa005423c>] mpt_config+0x1d2/0x2e6 [mptbase]
 [<ffffffff8106f9d6>] ? mark_held_locks+0x68/0x86
 [<ffffffffa0054729>] mpt_findImVolumes+0xa1/0x484 [mptbase]
 [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff811a223a>] ? free_object+0x84/0xba
 [<ffffffff811a24eb>] ? debug_object_free+0xd0/0xe9
 [<ffffffff81055a55>] ? destroy_timer_on_stack+0x15/0x17
 [<ffffffff81394975>] ? schedule_timeout+0xa4/0xc0
 [<ffffffff810560d0>] ? process_timeout+0x0/0x10
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8105679b>] ? __mod_timer+0x21/0xd2
 [<ffffffff81056867>] ? msleep+0x1b/0x22
 [<ffffffffa0052626>] ? WaitForDoorbellInt+0x56/0xd0 [mptbase]
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106fd2c>] ? debug_check_no_locks_freed+0x131/0x149
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8106e298>] ? static_obj+0x74/0x80
 [<ffffffff8106e975>] ? lockdep_init_map+0x93/0x102
 [<ffffffff8106d581>] ? debug_mutex_init+0x31/0x44
 [<ffffffffa0057a74>] mpt_do_ioc_recovery+0x824/0x1560 [mptbase]
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8105eb80>] ? __kernel_text_address+0x42/0x4d
 [<ffffffff81014d35>] ? print_context_stack+0xae/0xcd
 [<ffffffff81014252>] ? dump_trace+0x256/0x268
 [<ffffffff8106deaf>] ? find_usage_backwards+0x3b/0x103
 [<ffffffff8101c37f>] ? save_stack_trace+0x2f/0x4c
 [<ffffffff8106ea23>] ? save_trace+0x3f/0x95
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f9d6>] ? mark_held_locks+0x68/0x86
 [<ffffffff813967de>] ? _spin_unlock_irqrestore+0x48/0x58
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8119bc2d>] ? __up_read+0x76/0x7f
 [<ffffffff810645dc>] ? up_read+0x2b/0x2f
 [<ffffffffa005951d>] mpt_attach+0x8b2/0xa11 [mptbase]
 [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
 [<ffffffffa00dd5a7>] mptsas_probe+0x1e/0x46e [mptsas]
 [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
 [<ffffffff811ad085>] local_pci_probe+0x17/0x1b
 [<ffffffff8105cadc>] do_work_for_cpu+0x18/0x20
 [<ffffffff8105ccb0>] run_workqueue+0xfd/0x1fd
 [<ffffffff8105cc5f>] ? run_workqueue+0xac/0x1fd
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8105ce9f>] worker_thread+0xef/0x100
 [<ffffffff81060d46>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
 [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
 [<ffffffff810609ad>] kthread+0x4d/0x78
 [<ffffffff810126aa>] child_rip+0xa/0x20
 [<ffffffff8100f88b>] ? __switch_to+0x190/0x398
 [<ffffffff81011fbe>] ? restore_args+0x0/0x30
 [<ffffffff81060960>] ? kthread+0x0/0x78
 [<ffffffff810126a0>] ? child_rip+0x0/0x20
---[ end trace 67afa24243f21d1b ]---
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a0/0x33d()
(Tainted: G        W )
Hardware name: Precision WorkStation T7400
Modules linked in: ext4 jbd2 crc16 squashfs firewire_ohci(+) pata_acpi
firewire_core mptsas(+) crc_itu_t ata_generic mptscsih nouveau mptbase
scsi_transport_sas drm i2c_core
Pid: 36, comm: work_on_cpu/0 Tainted: G        W
2.6.29-0.258.2.3.rc8.git2.fc11.x86_64 #1
Call Trace:
 [<ffffffff8104bae3>] warn_slowpath+0xbc/0xf0
 [<ffffffff8104c0ba>] ? release_console_sem+0x1c3/0x1f4
 [<ffffffff81071064>] ? print_lock_contention_bug+0x1b/0xe1
 [<ffffffff811a2ab9>] ? __debug_object_init+0x315/0x33d
 [<ffffffff81393b9b>] ? printk+0x41/0x46
 [<ffffffff811a2a44>] __debug_object_init+0x2a0/0x33d
 [<ffffffff811a2b0e>] debug_object_init+0x14/0x16
 [<ffffffff81055ea2>] init_timer+0x1d/0x60
 [<ffffffffa005423c>] mpt_config+0x1d2/0x2e6 [mptbase]
 [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa0054833>] mpt_findImVolumes+0x1ab/0x484 [mptbase]
 [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff811a24eb>] ? debug_object_free+0xd0/0xe9
 [<ffffffff81055a55>] ? destroy_timer_on_stack+0x15/0x17
 [<ffffffff81394975>] ? schedule_timeout+0xa4/0xc0
 [<ffffffff810560d0>] ? process_timeout+0x0/0x10
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8105679b>] ? __mod_timer+0x21/0xd2
 [<ffffffffa0000000>] ? i2c_check_functionality+0x0/0x25 [i2c_core]
 [<ffffffffa0058979>] ? mpt_timer_expired+0x0/0x66 [mptbase]
 [<ffffffff8106fd2c>] ? debug_check_no_locks_freed+0x131/0x149
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8106e298>] ? static_obj+0x74/0x80
 [<ffffffff8106e975>] ? lockdep_init_map+0x93/0x102
 [<ffffffffa0057a74>] mpt_do_ioc_recovery+0x824/0x1560 [mptbase]
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8105eb80>] ? __kernel_text_address+0x42/0x4d
 [<ffffffff81014d35>] ? print_context_stack+0xae/0xcd
 [<ffffffff81014252>] ? dump_trace+0x256/0x268
 [<ffffffff8106deaf>] ? find_usage_backwards+0x3b/0x103
 [<ffffffff8101c37f>] ? save_stack_trace+0x2f/0x4c
 [<ffffffff8106ea23>] ? save_trace+0x3f/0x95
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f9d6>] ? mark_held_locks+0x68/0x86
 [<ffffffff813967de>] ? _spin_unlock_irqrestore+0x48/0x58
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8119bc2d>] ? __up_read+0x76/0x7f
 [<ffffffff810645dc>] ? up_read+0x2b/0x2f
 [<ffffffffa005951d>] mpt_attach+0x8b2/0xa11 [mptbase]
 [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
 [<ffffffffa00dd5a7>] mptsas_probe+0x1e/0x46e [mptsas]
 [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
 [<ffffffff811ad085>] local_pci_probe+0x17/0x1b
 [<ffffffff8105cadc>] do_work_for_cpu+0x18/0x20
 [<ffffffff8105ccb0>] run_workqueue+0xfd/0x1fd
 [<ffffffff8105cc5f>] ? run_workqueue+0xac/0x1fd
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8105ce9f>] worker_thread+0xef/0x100
 [<ffffffff81060d46>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
 [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
 [<ffffffff810609ad>] kthread+0x4d/0x78
 [<ffffffff810126aa>] child_rip+0xa/0x20
 [<ffffffff8100f88b>] ? __switch_to+0x190/0x398
 [<ffffffff81011fbe>] ? restore_args+0x0/0x30
 [<ffffffff81060960>] ? kthread+0x0/0x78
 [<ffffffff810126a0>] ? child_rip+0x0/0x20
---[ end trace 67afa24243f21d1c ]---
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a0/0x33d()
(Tainted: G        W )
Hardware name: Precision WorkStation T7400
Modules linked in: ext4 jbd2 crc16 squashfs firewire_ohci(+) pata_acpi
firewire_core mptsas(+) crc_itu_t ata_generic mptscsih nouveau mptbase
scsi_transport_sas drm i2c_core
Pid: 36, comm: work_on_cpu/0 Tainted: G        W
2.6.29-0.258.2.3.rc8.git2.fc11.x86_64 #1
Call Trace:
 [<ffffffff8104bae3>] warn_slowpath+0xbc/0xf0
 [<ffffffff8104c0ba>] ? release_console_sem+0x1c3/0x1f4
 [<ffffffff81071064>] ? print_lock_contention_bug+0x1b/0xe1
 [<ffffffff811a2ab9>] ? __debug_object_init+0x315/0x33d
 [<ffffffff81393b9b>] ? printk+0x41/0x46
 [<ffffffff811a2a44>] __debug_object_init+0x2a0/0x33d
 [<ffffffff811a2b0e>] debug_object_init+0x14/0x16
 [<ffffffff81055ea2>] init_timer+0x1d/0x60
 [<ffffffffa005423c>] mpt_config+0x1d2/0x2e6 [mptbase]
 [<ffffffff811a5f22>] ? swiotlb_free_coherent+0x6e/0x97
 [<ffffffffa0053207>] ? pci_free_consistent+0x8b/0x97 [mptbase]
 [<ffffffffa005495e>] mpt_findImVolumes+0x2d6/0x484 [mptbase]
 [<ffffffffa0058979>] ? mpt_timer_expired+0x0/0x66 [mptbase]
 [<ffffffffa0058979>] ? mpt_timer_expired+0x0/0x66 [mptbase]
 [<ffffffff8106fd2c>] ? debug_check_no_locks_freed+0x131/0x149
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8106e298>] ? static_obj+0x74/0x80
 [<ffffffff8106e975>] ? lockdep_init_map+0x93/0x102
 [<ffffffffa0057a74>] mpt_do_ioc_recovery+0x824/0x1560 [mptbase]
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8105eb80>] ? __kernel_text_address+0x42/0x4d
 [<ffffffff81014d35>] ? print_context_stack+0xae/0xcd
 [<ffffffff81014252>] ? dump_trace+0x256/0x268
 [<ffffffff8106deaf>] ? find_usage_backwards+0x3b/0x103
 [<ffffffff8101c37f>] ? save_stack_trace+0x2f/0x4c
 [<ffffffff8106ea23>] ? save_trace+0x3f/0x95
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f9d6>] ? mark_held_locks+0x68/0x86
 [<ffffffff813967de>] ? _spin_unlock_irqrestore+0x48/0x58
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8119bc2d>] ? __up_read+0x76/0x7f
 [<ffffffff810645dc>] ? up_read+0x2b/0x2f
 [<ffffffffa005951d>] mpt_attach+0x8b2/0xa11 [mptbase]
 [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
 [<ffffffffa00dd5a7>] mptsas_probe+0x1e/0x46e [mptsas]
 [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
 [<ffffffff811ad085>] local_pci_probe+0x17/0x1b
 [<ffffffff8105cadc>] do_work_for_cpu+0x18/0x20
 [<ffffffff8105ccb0>] run_workqueue+0xfd/0x1fd
 [<ffffffff8105cc5f>] ? run_workqueue+0xac/0x1fd
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8105ce9f>] worker_thread+0xef/0x100
 [<ffffffff81060d46>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
 [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
 [<ffffffff810609ad>] kthread+0x4d/0x78
 [<ffffffff810126aa>] child_rip+0xa/0x20
 [<ffffffff8100f88b>] ? __switch_to+0x190/0x398
 [<ffffffff81011fbe>] ? restore_args+0x0/0x30
 [<ffffffff81060960>] ? kthread+0x0/0x78
 [<ffffffff810126a0>] ? child_rip+0x0/0x20
---[ end trace 67afa24243f21d1d ]---
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a0/0x33d()
(Tainted: G        W )
Hardware name: Precision WorkStation T7400
Modules linked in: ext4 jbd2 crc16 squashfs firewire_ohci(+) pata_acpi
firewire_core mptsas(+) crc_itu_t ata_generic mptscsih nouveau mptbase
scsi_transport_sas drm i2c_core
Pid: 36, comm: work_on_cpu/0 Tainted: G        W
2.6.29-0.258.2.3.rc8.git2.fc11.x86_64 #1
Call Trace:
 [<ffffffff8104bae3>] warn_slowpath+0xbc/0xf0
 [<ffffffff8104c0ba>] ? release_console_sem+0x1c3/0x1f4
 [<ffffffff81071064>] ? print_lock_contention_bug+0x1b/0xe1
 [<ffffffff811a2ab9>] ? __debug_object_init+0x315/0x33d
 [<ffffffff81393b9b>] ? printk+0x41/0x46
 [<ffffffff811a2a44>] __debug_object_init+0x2a0/0x33d
 [<ffffffff811a2b0e>] debug_object_init+0x14/0x16
 [<ffffffff81055ea2>] init_timer+0x1d/0x60
 [<ffffffffa005423c>] mpt_config+0x1d2/0x2e6 [mptbase]
 [<ffffffffa00584d0>] mpt_do_ioc_recovery+0x1280/0x1560 [mptbase]
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8105eb80>] ? __kernel_text_address+0x42/0x4d
 [<ffffffff81014d35>] ? print_context_stack+0xae/0xcd
 [<ffffffff81014252>] ? dump_trace+0x256/0x268
 [<ffffffff8106deaf>] ? find_usage_backwards+0x3b/0x103
 [<ffffffff8101c37f>] ? save_stack_trace+0x2f/0x4c
 [<ffffffff8106ea23>] ? save_trace+0x3f/0x95
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f9d6>] ? mark_held_locks+0x68/0x86
 [<ffffffff813967de>] ? _spin_unlock_irqrestore+0x48/0x58
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8119bc2d>] ? __up_read+0x76/0x7f
 [<ffffffff810645dc>] ? up_read+0x2b/0x2f
 [<ffffffffa005951d>] mpt_attach+0x8b2/0xa11 [mptbase]
 [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
 [<ffffffffa00dd5a7>] mptsas_probe+0x1e/0x46e [mptsas]
 [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
 [<ffffffff811ad085>] local_pci_probe+0x17/0x1b
 [<ffffffff8105cadc>] do_work_for_cpu+0x18/0x20
 [<ffffffff8105ccb0>] run_workqueue+0xfd/0x1fd
 [<ffffffff8105cc5f>] ? run_workqueue+0xac/0x1fd
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8105ce9f>] worker_thread+0xef/0x100
 [<ffffffff81060d46>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
 [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
 [<ffffffff810609ad>] kthread+0x4d/0x78
 [<ffffffff810126aa>] child_rip+0xa/0x20
 [<ffffffff8100f88b>] ? __switch_to+0x190/0x398
 [<ffffffff81011fbe>] ? restore_args+0x0/0x30
 [<ffffffff81060960>] ? kthread+0x0/0x78
 [<ffffffff810126a0>] ? child_rip+0x0/0x20
---[ end trace 67afa24243f21d1e ]---
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:253 __debug_object_init+0x2a0/0x33d()
(Tainted: G        W )
Hardware name: Precision WorkStation T7400
Modules linked in: ext4 jbd2 crc16 squashfs firewire_ohci(+) pata_acpi
firewire_core mptsas(+) crc_itu_t ata_generic mptscsih nouveau mptbase
scsi_transport_sas drm i2c_core
Pid: 36, comm: work_on_cpu/0 Tainted: G        W
2.6.29-0.258.2.3.rc8.git2.fc11.x86_64 #1
Call Trace:
 [<ffffffff8104bae3>] warn_slowpath+0xbc/0xf0
 [<ffffffff8104c0ba>] ? release_console_sem+0x1c3/0x1f4
 [<ffffffff81071064>] ? print_lock_contention_bug+0x1b/0xe1
 [<ffffffff811a2ab9>] ? __debug_object_init+0x315/0x33d
 [<ffffffff81393b9b>] ? printk+0x41/0x46
 [<ffffffff811a2a44>] __debug_object_init+0x2a0/0x33d
 [<ffffffff811a2b0e>] debug_object_init+0x14/0x16
 [<ffffffff81055ea2>] init_timer+0x1d/0x60
 [<ffffffffa005423c>] mpt_config+0x1d2/0x2e6 [mptbase]
 [<ffffffff811a5f22>] ? swiotlb_free_coherent+0x6e/0x97
 [<ffffffffa0053207>] ? pci_free_consistent+0x8b/0x97 [mptbase]
 [<ffffffffa0058594>] mpt_do_ioc_recovery+0x1344/0x1560 [mptbase]
 [<ffffffffa0058979>] ? mpt_timer_expired+0x0/0x66 [mptbase]
 [<ffffffff81014252>] ? dump_trace+0x256/0x268
 [<ffffffff8106deaf>] ? find_usage_backwards+0x3b/0x103
 [<ffffffff8101c37f>] ? save_stack_trace+0x2f/0x4c
 [<ffffffff8106ea23>] ? save_trace+0x3f/0x95
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f617>] ? mark_lock+0x28/0x37f
 [<ffffffff8106f9d6>] ? mark_held_locks+0x68/0x86
 [<ffffffff813967de>] ? _spin_unlock_irqrestore+0x48/0x58
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8106fbf9>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8119bc2d>] ? __up_read+0x76/0x7f
 [<ffffffff810645dc>] ? up_read+0x2b/0x2f
 [<ffffffffa005951d>] mpt_attach+0x8b2/0xa11 [mptbase]
 [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
 [<ffffffffa00dd5a7>] mptsas_probe+0x1e/0x46e [mptsas]
 [<ffffffff8105cac4>] ? do_work_for_cpu+0x0/0x20
 [<ffffffff811ad085>] local_pci_probe+0x17/0x1b
 [<ffffffff8105cadc>] do_work_for_cpu+0x18/0x20
 [<ffffffff8105ccb0>] run_workqueue+0xfd/0x1fd
 [<ffffffff8105cc5f>] ? run_workqueue+0xac/0x1fd
 [<ffffffff8106fbc8>] ? trace_hardirqs_on_caller+0x12f/0x153
 [<ffffffff8105ce9f>] worker_thread+0xef/0x100
 [<ffffffff81060d46>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
 [<ffffffff8105cdb0>] ? worker_thread+0x0/0x100
 [<ffffffff810609ad>] kthread+0x4d/0x78
 [<ffffffff810126aa>] child_rip+0xa/0x20
 [<ffffffff8100f88b>] ? __switch_to+0x190/0x398
 [<ffffffff81011fbe>] ? restore_args+0x0/0x30
 [<ffffffff81060960>] ? kthread+0x0/0x78
 [<ffffffff810126a0>] ? child_rip+0x0/0x20
---[ end trace 67afa24243f21d1f ]---

Where do we go from here?

-

Morten
