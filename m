Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425Ab0AMVLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0AMVLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405Ab0AMVLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:11:36 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:31082 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab0AMVLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:11:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=J9+tM7BGOmtrcnit32aioWhpdswvIW4OwApTsJnR/qdeGFRdxyq+EiBNWpv6l7cDYF
         ccMbPrGd5xk78Yg5tvrTALGtnHF16CIt705UjaMxFaM0T7a/Mie1qCuIrPScjEQYPtMT
         YEN9b23wvaAEkmSK4Zq4kvHiwMKEQZ6jtAdi8=
MIME-Version: 1.0
In-Reply-To: <a44ae5cd1001130817v7a3ffbc9yc83d7cc701f8620@mail.gmail.com>
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com>
	 <2375c9f91001100058w4bac1cf9s183fc37eafbfde75@mail.gmail.com>
	 <m13a2dho1o.fsf@fess.ebiederm.org> <201001101935.31882.rjw@sisk.pl>
	 <m1wrzpbcmi.fsf@fess.ebiederm.org> <4B4BC2D3.7070003@kernel.org>
	 <m11vhw6u3k.fsf@fess.ebiederm.org>
	 <a44ae5cd1001130817v7a3ffbc9yc83d7cc701f8620@mail.gmail.com>
Date: Wed, 13 Jan 2010 16:11:28 -0500
Message-ID: <a44ae5cd1001131311g643d2084ye7819d2e684f1e43@mail.gmail.com>
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking -- 
	(s_active){++++.+}, at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
From: Miles Lane <miles.lane@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, here is the full INFO text  It does appear I am having trouble
with your patch.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.33-rc3-git3 #39
-------------------------------------------------------
pm-suspend/5868 is trying to acquire lock:
 (mutex){+.+...}, at: [<c10d0e50>] sync_filesystems+0x14/0xd6

but task is already holding lock:
 (s_active){++++.+}, at: [<c10f7b31>] sysfs_get_active_two+0x16/0x34

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (s_active){++++.+}:
       [<c105c1d5>] __lock_acquire+0x9f5/0xb67
       [<c105c3ea>] lock_acquire+0xa3/0xcd
       [<c10f79c6>] sysfs_addrm_finish+0xa6/0x10a
       [<c10f6319>] sysfs_hash_and_remove+0x3d/0x4f
       [<c10f8881>] sysfs_remove_group+0x52/0x81
       [<c1212798>] dpm_sysfs_remove+0x10/0x12
       [<c120dff4>] device_del+0x33/0x131
       [<c120e0fd>] device_unregister+0xb/0x15
       [<c109fa52>] bdi_unregister+0xc9/0xdb
       [<c109fb35>] bdi_destroy+0xd1/0xf0
       [<c113a69f>] fuse_conn_kill+0xb3/0xb8
       [<c113a6f0>] fuse_put_super+0x4c/0x57
       [<c10b9055>] generic_shutdown_super+0x42/0xaa
       [<c10b90fa>] kill_anon_super+0xc/0x43
       [<c1139c10>] fuse_kill_sb_anon+0x37/0x3c
       [<c10b9693>] deactivate_super+0x48/0x5d
       [<c10c970d>] mntput_no_expire+0x87/0xb1
       [<c10c9b8c>] sys_umount+0x253/0x279
       [<c10031e3>] sysenter_do_call+0x12/0x3c

-> #1 (&type->s_umount_key#26){+++++.}:
       [<c105c1d5>] __lock_acquire+0x9f5/0xb67
       [<c105c3ea>] lock_acquire+0xa3/0xcd
       [<c12f576e>] down_read+0x2c/0x40
       [<c10d0eaf>] sync_filesystems+0x73/0xd6
       [<c10d0f4e>] sys_sync+0x11/0x2d
       [<c10031e3>] sysenter_do_call+0x12/0x3c

-> #0 (mutex){+.+...}:
       [<c105c0d7>] __lock_acquire+0x8f7/0xb67
       [<c105c3ea>] lock_acquire+0xa3/0xcd
       [<c12f505b>] __mutex_lock_common+0x39/0x44d
       [<c12f54fe>] mutex_lock_nested+0x2b/0x33
 [<c12f4bd8>] schedule_timeout_interruptible+0x15/0x17
 [<c1072652>] watchdog+0x31/0x1b0
 [<c102758b>] ? complete+0x34/0x3e
 [<c1072621>] ? watchdog+0x0/0x1b0
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
kswapd0       S 00000af8  2436   320      2 0x00000000
 f71fcee4 00000086 f1fdfc36 00000af8 f72dc0e0 f72dc394 c1536980 f71fcea8
 c1531ef0 c1536980 f72dc394 c1536980 c105b0d0 f71fcec0 c12f6318 f64f2280
 f1fd986f 00000af8 f72dc0e0 f71fcee4 00000000 c14b8240 00000002 c14b8240
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c1098b98>] kswapd+0x6b9/0x6be
 [<c1096b5d>] ? isolate_pages_global+0x0/0x1aa
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c10984df>] ? kswapd+0x0/0x6be
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
aio/0         S 00000000  3276   417      2 0x00000000
 f6ac6f44 00000086 52cb8972 00000000 f72dec20 f72deed4 c1536980 f6ac6f08
 c1531ef0 c1536980 f72deed4 c1536980 c105b0d0 f6ac6f20 c12f6318 00000000
 52cb7169 00000000 f72dec20 f6ac6f44 c104b9ff 00000286 00000000 c2c0cd40
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b9ff>] ? prepare_to_wait+0x4e/0x55
 [<c1047e63>] worker_thread+0xa1/0x289
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
aio/1         S 00000000  3276   418      2 0x00000000
 f70c0f44 00000086 5316e827 00000000 f72de150 f72de404 c1536980 f70c0f08
 c1531ef0 c1536980 f72de404 c1536980 c105b0d0 fffedc65 c2e05ef0 00000000
 5316bbd6 00000000 f72de150 f70c0f44 00000000 00000000 00000000 c2e0cd40
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c1047e63>] worker_thread+0xa1/0x289
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
crypto/0      S 00000000  3276   436      2 0x00000000
 f7139f44 00000086 53fcd3aa 00000000 f72dd680 f72dd934 c1536980 f7139f08
 c1531ef0 c1536980 f72dd934 c1536980 c105b0d0 f7139f20 c12f6318 00000000
 53fcbbe2 00000000 f72dd680 f7139f44 c104b9ff 00000286 00000000 c2c0ce00
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b9ff>] ? prepare_to_wait+0x4e/0x55
 [<c1047e63>] worker_thread+0xa1/0x289
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
crypto/1      S 00000000  3276   437      2 0x00000000
 f6a63f44 00000086 543ec681 00000000 f72dcbb0 f72dce64 c1536980 f6a63f08
 c1531ef0 c1536980 f72dce64 c1536980 c105b0d0 fffedc6a c2e05ef0 00000000
 543e997c 00000000 f72dcbb0 f6a63f44 00000000 00000000 00000000 c2e0ce00
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c1047e63>] worker_thread+0xa1/0x289
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
i915          S 00000b08  3028   553      2 0x00000000
 f71d1f44 00000086 411eca05 00000b08 f72da070 f72da324 c1536980 f71d1f08
 c1531ef0 c1536980 f72da324 c1536980 c105b0d0 002d20bc c2c05ef0 00000000
 411e563e 00000b08 f72da070 f71d1f44 00000000 00000000 00000000 c2c0ce80
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c1047e63>] worker_thread+0xa1/0x289
 [<c11f25a0>] ? i915_gem_retire_work_handler+0x0/0x5f
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
scsi_eh_0     S 00000000  2332   575      2 0x00000000
 f6b1ef60 00000086 69af1e35 00000000 f70218d0 f72d9854 c1536980 c105b0d0
 c1531ef0 c1536980 f72d9854 c1536980 f6b1ef30 fffedcc0 c2c05ef0 00000000
 69ab7ab1 00000000 f72d95a0 00000286 00000000 00000000 00000000 f7021890
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c121bc7e>] scsi_error_handler+0x67/0x320
 [<c121bc17>] ? scsi_error_handler+0x0/0x320
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
scsi_eh_1     S 00000000  2744   580      2 0x00000000
 f6b3ef60 00000086 6848be36 00000000 f7022100 f72d82b4 c1536980 c105b0d0
 c1531ef0 c1536980 f72d82b4 c1536980 f6b3ef30 c1218324 f6b3ef4c 00000000
 6844e360 00000000 f72d8000 00000286 f6b3ef88 f6b3ef5c c121d5f2 f70220c0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c1218324>] ? spin_unlock_irqrestore+0x8/0xa
 [<c121d5f2>] ? scsi_run_host_queues+0x1c/0x26
 [<c121bc7e>] scsi_error_handler+0x67/0x320
 [<c121bc17>] ? scsi_error_handler+0x0/0x320
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
kpsmoused     S 00000000  3156   605      2 0x00000008
 f6af5f44 00000086 64f388f1 00000000 f6b34bb0 f6b34e64 c1536980 00000400
 c1531ef0 c1536980 f6b34e64 c1536980 c12ff364 fffedcae c2e05ef0 00000000
 64f388f1 00000000 f6b34bb0 00000078 00000000 00000000 00000400 c2c0d080
Call Trace:
 [<c1047e63>] worker_thread+0xa1/0x289
 [<c12f6321>] ? _raw_spin_unlock_irqrestore+0x7d/0x81
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c102758b>] ? complete+0x34/0x3e
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
usbhid_resume S 00000000  3276   640      2 0x00000000
 f6b84f44 00000086 66201a1e 00000000 f72db610 f72db8c4 c1536980 f6b84f08
 c1531ef0 c1536980 f72db8c4 c1536980 c105b0d0 fffedcb3 c2c05ef0 00000000
 66200242 00000000 f72db610 f6b84f44 00000000 00000000 00000000 c2c0d100
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c1047e63>] worker_thread+0xa1/0x289
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
scsi_eh_2     S 00000000  3304   849      2 0x00000000
 f6488f60 00000086 d316cb7e 00000000 f6b76150 f6b76404 c1536980 f6488f24
 c1531ef0 c1536980 f6b76404 c1536980 c105b0d0 f6488f38 f6488f38 00000000
 d3166f87 00000000 f6b76150 f6b76150 f6b76150 f6b76404 c1536980 f7026240
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c121bc7e>] scsi_error_handler+0x67/0x320
 [<c102758b>] ? complete+0x34/0x3e
 [<c121bc17>] ? scsi_error_handler+0x0/0x320
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
usb-storage   S 00000b08  2532   850      2 0x00000000
 f6bd5ec4 00000086 367d44da 00000b08 c16eb324 f6b75934 c1536980 f6b75601
 c1531ef0 c1536980 f6b75934 c1536980 00000000 00000002 003e2000 00000000
 367d13d2 00000b08 f6b75680 00000000 f6bd5ec8 00000086 f6b75680 f7026818
Call Trace:
 [<c12f4afd>] schedule_timeout+0x22/0xba
 [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
 [<c12f3fe6>] ? wait_for_common+0x2c/0xd3
 [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f404f>] wait_for_common+0x95/0xd3
 [<c102ccce>] ? default_wake_function+0x0/0xd
 [<f80f01be>] ? usb_stor_control_thread+0x0/0x1c1 [usb_storage]
 [<c12f40cf>] wait_for_completion_interruptible+0x12/0x21
 [<f80f0200>] usb_stor_control_thread+0x42/0x1c1 [usb_storage]
 [<c12f4ab1>] ? preempt_schedule+0x46/0x4c
 [<c12f6321>] ? _raw_spin_unlock_irqrestore+0x7d/0x81
 [<c102758b>] ? complete+0x34/0x3e
 [<f80f01be>] ? usb_stor_control_thread+0x0/0x1c1 [usb_storage]
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
mount.ntfs    D 00000b08  2144   873      1 0x00000000
 f6213e5c 00000086 6e77b8d0 00000b08 c1052065 f6b738c4 c1536980 00000000
 c1531ef0 c1536980 f6b738c4 c1536980 00000086 00000000 00000000 00000000
 6e75df98 00000b08 f6b73610 f6538504 00000000 f6213e50 c105b0d0 f6b73610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c10b6d7a>] ? fsnotify_access+0x4f/0x5a
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b763c>] ? vfs_read+0x9d/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
loop0         D 00000b08  1836   880      2 0x00000000
 f6207cb4 00000086 6ccf3ca5 00000b08 c105c3ea f6b70d84 c1536980 f6207c90
 c1531ef0 c1536980 f6b70d84 c1536980 f6207ca4 c10539c6 6c12ae47 f64b9900
 6ccf09fe 00000b08 f6b70ad0 c2e0a980 00000000 c2b3bf9c f6207cac c2e0a980
Call Trace:
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c12f4959>] io_schedule+0x32/0x49
 [<c108f095>] sync_page+0x3f/0x43
 [<c12f4c0e>] __wait_on_bit_lock+0x34/0x70
 [<c108f056>] ? sync_page+0x0/0x43
 [<c108f016>] __lock_page+0x6f/0x77
 [<c104b83f>] ? wake_bit_function+0x0/0x37
 [<c10cf9d9>] lock_page+0x29/0x2c
 [<c10d00b9>] __generic_file_splice_read+0x241/0x3f8
 [<c102da06>] ? update_curr+0x1a9/0x1b1
 [<c10278bf>] ? rcu_read_lock+0x0/0x26
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10278bf>] ? rcu_read_lock+0x0/0x26
 [<c1027901>] ? rcu_read_unlock+0x1c/0x1e
 [<c1027954>] ? cpuacct_charge+0x51/0x58
 [<c102da06>] ? update_curr+0x1a9/0x1b1
 [<c102e12e>] ? dequeue_entity+0x15/0x1a1
 [<c102ba48>] ? finish_task_switch+0x0/0xa1
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10cf4c7>] ? spd_release_page+0x0/0xf
 [<c10d02fe>] generic_file_splice_read+0x8e/0xb9
 [<c10d0270>] ? generic_file_splice_read+0x0/0xb9
 [<c10cf3f3>] do_splice_to+0x50/0x5a
 [<c10cf663>] splice_direct_to_actor+0xb5/0x175
 [<c1216c17>] ? lo_direct_splice_actor+0x0/0xf
 [<c1216bba>] loop_thread+0x38e/0x3eb
 [<c12166f9>] ? do_lo_send_aops+0x0/0x133
 [<c121682c>] ? loop_thread+0x0/0x3eb
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
jbd2/loop0-8  D 00000b09  2372   882      2 0x00000000
 f7172dd0 00000086 a1fe5c64 00000b09 c105c3ea f6b72df4 c1536980 f7172dac
 c1531ef0 c1536980 f6b72df4 c1536980 f7172dc0 002d217c c2e05ef0 00000000
 a1f9f5e4 00000b09 f6b72b40 c2e0a980 00000000 00000000 00000000 c2e0a980
Call Trace:
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c12f4959>] io_schedule+0x32/0x49
 [<c108f095>] sync_page+0x3f/0x43
 [<c12f4cdd>] __wait_on_bit+0x34/0x5b
 [<c108f056>] ? sync_page+0x0/0x43
 [<c108f294>] wait_on_page_bit+0x7e/0x87
 [<c104b83f>] ? wake_bit_function+0x0/0x37
 [<c108f9d0>] filemap_fdatawait_range+0x66/0x104
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
 [<c11281a0>] ? spin_lock+0x8/0xa
 [<c108faa8>] filemap_fdatawait+0x3a/0x47
 [<c1128ce2>] jbd2_journal_commit_transaction+0x8ae/0x1144
 [<c103ebd6>] ? lock_timer_base+0x21/0x40
 [<c103ebb3>] ? spin_unlock_irqrestore+0x8/0xa
 [<c103ec4e>] ? try_to_del_timer_sync+0x59/0x61
 [<c112d8ae>] kjournald2+0x111/0x302
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c112d79d>] ? kjournald2+0x0/0x302
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
ext4-dio-unwr S 00000001  3276   883      2 0x00000000
 f64ebf44 00000086 2094c328 00000001 f6b74bb0 f6b74e64 c1536980 f64ebf08
 c1531ef0 c1536980 f6b74e64 c1536980 c105b0d0 f64ebf20 c12f6318 00000000
 2094ab94 00000001 f6b74bb0 f64ebf44 c104b9ff 00000286 00000000 c2c0d2c0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b9ff>] ? prepare_to_wait+0x4e/0x55
 [<c1047e63>] worker_thread+0xa1/0x289
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
ext4-dio-unwr S 00000001  3276   884      2 0x00000000
 f64eaf44 00000086 20e18953 00000001 f64fec20 f64feed4 c1536980 f64eaf08
 c1531ef0 c1536980 f64feed4 c1536980 c105b0d0 fffedfc4 c2e05ef0 00000000
 20e14ba5 00000001 f64fec20 f64eaf44 00000000 00000000 00000000 c2e0d2c0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c1047e63>] worker_thread+0xa1/0x289
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
upstart-udev- D 00000b08  1936  3234      1 0x00000000
 f4a94e5c 00000086 6dd6f150 00000b08 c1052065 f652c394 c1536980 00000000
 c1531ef0 c1536980 f652c394 c1536980 00000086 00000000 00000000 f38b8780
 6dbe37b9 00000b08 f652c0e0 f6bee804 00000000 f4a94e50 c105b0d0 f652c0e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105a22b>] ? register_lock_class+0x17/0x2a2
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
udevd         D 00000b08  2092  3236      1 0x00000000
 f4983e5c 00000086 6dbed073 00000b08 c1052065 f652b8c4 c1536980 00000000
 c1531ef0 c1536980 f652b8c4 c1536980 00000086 00000000 00000000 f38b8a00
 6dbe5759 00000b08 f652b610 f6bec184 00000000 f4983e50 c105b0d0 f652b610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6f5c>] ? do_sync_write+0x87/0xc2
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1288263>] ? sys_recv+0x18/0x1a
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
udevd         D 00000b08  2144  3326   3236 0x00000000
 f38d8e5c 00000086 6dd7280c 00000b08 c1052065 f389adf4 c1536980 00000000
 c1531ef0 c1536980 f389adf4 c1536980 00000086 00000000 00000000 f3835180
 6dbeb807 00000b08 f389ab40 f388a084 00000000 f38d8e50 c105b0d0 f389ab40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1041d0a>] ? spin_lock_irq+0x8/0xa
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
 [<c1041d0a>] ? spin_lock_irq+0x8/0xa
 [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c1041d14>] ? spin_unlock_irq+0x8/0xa
 [<c1041edc>] ? sigprocmask+0xbe/0xc6
 [<c10c3b1b>] ? sys_ppoll+0xe1/0xf8
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
udevd         D 00000b08  2152  3327   3236 0x00000000
 f38d3e5c 00000086 6dbef909 00000b08 c1052065 f389b8c4 c1536980 00000000
 c1531ef0 c1536980 f389b8c4 c1536980 00000086 00000000 00000000 f3835180
 6dbe9a1e 00000b08 f389b610 f388a604 00000000 f38d3e50 c105b0d0 f389b610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1041d0a>] ? spin_lock_irq+0x8/0xa
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
 [<c1041d0a>] ? spin_lock_irq+0x8/0xa
 [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c1041d14>] ? spin_unlock_irq+0x8/0xa
 [<c1041edc>] ? sigprocmask+0xbe/0xc6
 [<c10c3b1b>] ? sys_ppoll+0xe1/0xf8
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
cfg80211      S 00000b08  2956  3422      2 0x00000000
 f4b6cf44 00000086 1d22ded0 00000b08 f385d680 f385d934 c1536980 f4b6cf08
 c1531ef0 c1536980 f385d934 c1536980 c105b0d0 f4b6cf20 c12f6318 f3ea0280
 1d164011 00000b08 f385d680 f4b6cf44 c104b9ff 00000286 00000000 c2c0d4c0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b9ff>] ? prepare_to_wait+0x4e/0x55
 [<c1047e63>] worker_thread+0xa1/0x289
 [<f84e14d2>] ? wdev_cleanup_work+0x0/0xa5 [cfg80211]
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
phy0          S 00000b08  2400  3476      2 0x00000000
 f2dfbf44 00000086 1a75ca6a 00000b08 f389e150 f389e404 c1536980 f2dfbf08
 c1531ef0 c1536980 f389e404 c1536980 c105b0d0 f2dfbf20 c12f6318 f3ea0280
 1a343c89 00000b08 f389e150 f2dfbf44 c104b9ff 00000286 00000000 c2c0d5c0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b9ff>] ? prepare_to_wait+0x4e/0x55
 [<c1047e63>] worker_thread+0xa1/0x289
 [<f869e8a4>] ? ieee80211_reconfig_filter+0x0/0xf [mac80211]
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
hd-audio0     S 00000005  3276  3484      2 0x00000000
 f2e00f44 00000086 3f91c3b3 00000005 f3fea070 f3fea324 c1536980 f2e00f08
 c1531ef0 c1536980 f3fea324 c1536980 c105b0d0 fffef10b c2c05ef0 00000000
 3f915251 00000005 f3fea070 f2e00f44 00000000 00000000 00000000 c2c0d640
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c1047e63>] worker_thread+0xa1/0x289
 [<c12f6321>] ? _raw_spin_unlock_irqrestore+0x7d/0x81
 [<c104b810>] ? autoremove_wake_function+0x0/0x2f
 [<c102758b>] ? complete+0x34/0x3e
 [<c1047dc2>] ? worker_thread+0x0/0x289
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
dd            D 00000b08  1988  3592      1 0x00000008
 f13c7e5c 00000086 6de07a25 00000b08 c1052065 f3988d84 c1536980 0000848b
 c1531ef0 c1536980 f3988d84 c1536980 c12ff364 002d218a c2e05ef0 d4556f00
 6de07a25 00000b08 f3988ad0 00000078 00000000 00000000 0000848b f3988ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6f5c>] ? do_sync_write+0x87/0xc2
 [<c12f6298>] ? _raw_spin_unlock+0x33/0x3f
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c10b6ed5>] ? do_sync_write+0x0/0xc2
 [<c10b74aa>] ? vfs_write+0xa0/0xdf
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
rsyslogd      D 00000b08  1992  3608      1 0x00000000
 f040be5c 00000086 6dbf4794 00000b08 c1052065 f385adf4 c1536980 00000000
 c1531ef0 c1536980 f385adf4 c1536980 00000086 00000000 00000000 f3ea0780
 6dbef7d1 00000b08 f385ab40 f38e0a84 00000000 f040be50 c105b0d0 f385ab40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c116bad6>] ? copy_to_user+0x2b/0x57
 [<c10c29d7>] ? poll_select_copy_remaining+0xb1/0xcd
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
rsyslogd      D 00000b08  1964  3620      1 0x00000000
 f0880e5c 00000086 6dd77c27 00000b08 c1052065 f385ce64 c1536980 00000000
 c1531ef0 c1536980 f385ce64 c1536980 00000086 00000000 00000000 f3ea0000
 6dbf612d 00000b08 f385cbb0 f38e0a84 00000000 f0880e50 c105b0d0 f385cbb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c102ba48>] ? finish_task_switch+0x0/0xa1
 [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c102baa3>] ? finish_task_switch+0x5b/0xa1
 [<c102ba48>] ? finish_task_switch+0x0/0xa1
 [<c1025f06>] ? need_resched+0x14/0x1e
 [<c12f4909>] ? schedule+0x808/0x826
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
rsyslogd      D 00000b08  2848  3621      1 0x00000000
 f0882e5c 00000086 6ddffce4 00000b08 c1052065 f385a324 c1536980 00000000
 c1531ef0 c1536980 f385a324 c1536980 00000086 00000000 00000000 f3835680
 6dbe1b50 00000b08 f385a070 f38e0a84 00000000 f0882e50 c105b0d0 f385a070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10bd749>] ? pipe_read+0x290/0x2db
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c102809c>] ? __dequeue_entity+0x23/0x27
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c10b6ca5>] ? fput_light+0xc/0xe
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
rsyslogd      D 00000b08  2492  5932      1 0x00000000
 d6717e5c 00000086 6deb1227 00000b08 c1052065 d4b6e404 c1536980 00000000
 c1531ef0 c1536980 d4b6e404 c1536980 00000086 002d218b c2c05ef0 00000000
 6deae85e 00000b08 d4b6e150 f38e0a84 00000000 00000000 00000000 d4b6e150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c102ba48>] ? finish_task_switch+0x0/0xa1
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c102baa3>] ? finish_task_switch+0x5b/0xa1
 [<c102ba48>] ? finish_task_switch+0x0/0xa1
 [<c1025f06>] ? need_resched+0x14/0x1e
 [<c12f4909>] ? schedule+0x808/0x826
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
dbus-daemon   D 00000b08  1868  3660      1 0x00000000
 efd96e5c 00000086 6dc1f961 00000b08 c1052065 f398adf4 c1536980 00000000
 c1531ef0 c1536980 f398adf4 c1536980 00000086 00000000 00000000 f3834000
 6dbf24ca 00000b08 f398ab40 f710c704 00000000 efd96e50 c105b0d0 f398ab40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
recovery-menu D 00000b08  1852  3678      1 0x00000000
 ef8fae5c 00000086 6dc23a27 00000b08 c1052065 f398b8c4 c1536980 00000000
 c1531ef0 c1536980 f398b8c4 c1536980 00000086 00000000 00000000 f3ea0f00
 6dbf3f8f 00000b08 f398b610 f7109b04 00000000 ef8fae50 c105b0d0 f398b610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c104ba45>] ? remove_wait_queue+0xf/0x27
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104ba58>] ? remove_wait_queue+0x22/0x27
 [<c1037415>] ? do_wait+0x1b6/0x1e9
 [<c10374dc>] ? sys_wait4+0x94/0xa1
 [<c1035d59>] ? child_wait_callback+0x0/0x5f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
avahi-daemon  D 00000b08  1880  3682      1 0x00000000
 efbdfe5c 00000086 6dc2a64e 00000b08 c1052065 f398ce64 c1536980 00000000
 c1531ef0 c1536980 f398ce64 c1536980 00000086 00000000 00000000 f3ea0280
 6dbf82cc 00000b08 f398cbb0 f710d784 00000000 efbdfe50 c105b0d0 f398cbb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c10b6d7a>] ? fsnotify_access+0x4f/0x5a
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b763c>] ? vfs_read+0x9d/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
avahi-daemon  D 00000b08  2828  3683   3682 0x00000000
 ef49ae5c 00000086 6dd7ba70 00000b08 c1052065 f3989854 c1536980 00000000
 c1531ef0 c1536980 f3989854 c1536980 00000086 00000000 00000000 f3834500
 6dbfee93 00000b08 f39895a0 f710dd04 00000000 ef49ae50 c105b0d0 f39895a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c10b582c>] ? sys_close+0x25/0xa0
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
flush-7:0     S 00000b0d  2020  3686      2 0x00000000
 ef59df14 00000086 12746d2f 00000b0d ef59ded8 f398eed4 c1536980 f70b0000
 c1531ef0 c1536980 f398eed4 c1536980 c12f6318 002d217c c2e05ef0 00000000
 12742acb 00000b0d f398ec20 00000001 00000000 00000000 00000000 ef59df20
Call Trace:
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c12f4b60>] schedule_timeout+0x85/0xba
 [<c103eda1>] ? process_timeout+0x0/0xa
 [<c12f4bd8>] schedule_timeout_interruptible+0x15/0x17
 [<c10ce1dd>] bdi_writeback_task+0x65/0x84
 [<c109f684>] ? bdi_start_fn+0x0/0xa4
 [<c109f6d2>] bdi_start_fn+0x4e/0xa4
 [<c109f684>] ? bdi_start_fn+0x0/0xa4
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
flush-8:0     S 00000b0d  2128  3687      2 0x00000000
 ef59ef14 00000086 0c047c97 00000b0d ef59eed8 f398c394 c1536980 f70b0000
 c1531ef0 c1536980 f398c394 c1536980 c12f6318 002d217c c2e05ef0 00000000
 0c04381c 00000b0d f398c0e0 00000001 00000000 00000000 00000000 ef59ef20
Call Trace:
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c12f4b60>] schedule_timeout+0x85/0xba
 [<c103eda1>] ? process_timeout+0x0/0xa
 [<c12f4bd8>] schedule_timeout_interruptible+0x15/0x17
 [<c10ce1dd>] bdi_writeback_task+0x65/0x84
 [<c109f684>] ? bdi_start_fn+0x0/0xa4
 [<c109f6d2>] bdi_start_fn+0x4e/0xa4
 [<c109f684>] ? bdi_start_fn+0x0/0xa4
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
NetworkManage D 00000b08  1884  3739      1 0x00000000
 eefffe5c 00000086 6dc32b47 00000b08 c1052065 f389a324 c1536980 00000000
 c1531ef0 c1536980 f389a324 c1536980 00000086 00000000 00000000 f3ea0280
 6dbf9c7c 00000b08 f389a070 f710ed84 00000000 eefffe50 c105b0d0 f389a070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c10b7ae6>] ? do_readv_writev+0xd2/0xdf
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
NetworkManage D 00000b08  2864  4304      1 0x00000000
 d7127e5c 00000086 6dc366f0 00000b08 c1052065 dd9d0d84 c1536980 00000000
 c1531ef0 c1536980 dd9d0d84 c1536980 00000086 00000000 00000000 f3ea1b80
 6dbfbd54 00000b08 dd9d0ad0 f710ed84 00000000 d7127e50 c105b0d0 dd9d0ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10bd749>] ? pipe_read+0x290/0x2db
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c10b6ca5>] ? fput_light+0xc/0xe
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
modem-manager D 00000b08  2048  3741      1 0x00000000
 f087fe5c 00000086 6dc3ef86 00000b08 c1052065 f389d934 c1536980 00000000
 c1531ef0 c1536980 f389d934 c1536980 00000086 00000000 00000000 f3ea1180
 6dbfd70b 00000b08 f389d680 f7108504 00000000 f087fe50 c105b0d0 f389d680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
wpa_supplican D 00000b08  1908  3744      1 0x00000000
 ee138e5c 00200086 6dc423e9 00000b08 c1052065 f3fe2324 c1536980 00000000
 c1531ef0 c1536980 f3fe2324 c1536980 00200086 00000000 00000000 f3ea0a00
 6dc01fe9 00000b08 f3fe2070 f38e2084 00000000 ee138e50 c105b0d0 f3fe2070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b40af>] ? kmem_cache_free+0xac/0xfd
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c10c3fee>] ? __d_free+0x38/0x3b
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10c3fee>] ? __d_free+0x38/0x3b
 [<c10c3fee>] ? __d_free+0x38/0x3b
 [<c10c969f>] ? mntput_no_expire+0x19/0xb1
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
netroot       D 00000b08  2436  3747   3678 0x00000000
 ef1b6e5c 00000086 6dd7f33c 00000b08 c1052065 f3fe2df4 c1536980 00000000
 c1531ef0 c1536980 f3fe2df4 c1536980 00000086 00000000 00000000 f3ea1400
 6dc009ff 00000b08 f3fe2b40 f38e2604 00000000 ef1b6e50 c105b0d0 f3fe2b40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
 [<c104ba45>] ? remove_wait_queue+0xf/0x27
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104ba58>] ? remove_wait_queue+0x22/0x27
 [<c1037415>] ? do_wait+0x1b6/0x1e9
 [<c10374dc>] ? sys_wait4+0x94/0xa1
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
dhclient      D 00000b08  2156  3776      1 0x00000000
 ed897e5c 00000086 6dd85bea 00000b08 c1052065 f3899854 c1536980 00000000
 c1531ef0 c1536980 f3899854 c1536980 00000086 00000000 00000000 f3834280
 6dc05163 00000b08 f38995a0 f710b684 00000000 ed897e50 c105b0d0 f38995a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c116bad6>] ? copy_to_user+0x2b/0x57
 [<c10c29d7>] ? poll_select_copy_remaining+0xb1/0xcd
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
bash          D 00000b08  2232  3777   3747 0x00000000
 ed89ae5c 00000086 6dc45064 00000b08 c1052065 f38982b4 c1536980 00000000
 c1531ef0 c1536980 f38982b4 c1536980 00000086 00000000 00000000 f3834280
 6dc03825 00000b08 f3898000 f710a604 00000000 ed89ae50 c105b0d0 f3898000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c104ba45>] ? remove_wait_queue+0xf/0x27
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104ba58>] ? remove_wait_queue+0x22/0x27
 [<c1037415>] ? do_wait+0x1b6/0x1e9
 [<c10374dc>] ? sys_wait4+0x94/0xa1
 [<c1035d59>] ? child_wait_callback+0x0/0x5f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2092  3851      1 0x00000000
 e874be5c 00000086 6dc4ae54 00000b08 00000015 f3fe5934 c1536980 e874be18
 c1531ef0 c1536980 f3fe5934 c1536980 f3fe59c8 631706fc f3fe5680 f3834280
 6dc0c14b 00000b08 f3fe5680 f38e5204 00000000 e874be50 c105b0d0 f3fe5680
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c1003764>] ? conditional_sti+0xe/0x23
 [<c1003d3b>] ? do_device_not_available+0x0/0x53
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2148  3852      1 0x00000000
 e8aebe5c 00000086 6dd88de9 00000b08 c1052065 f3fe0d84 c1536980 00000000
 c1531ef0 c1536980 f3fe0d84 c1536980 00000086 00000000 00000000 f3834280
 6dc06e87 00000b08 f3fe0ad0 f38e5204 00000000 e8aebe50 c105b0d0 f3fe0ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3859      1 0x00000000
 e8753e5c 00000086 6dd8cde9 00000b08 c1052065 f3fe8d84 c1536980 00000000
 c1531ef0 c1536980 f3fe8d84 c1536980 00000086 00000000 00000000 f3834280
 6dc08b74 00000b08 f3fe8ad0 f38e5204 00000000 e8753e50 c105b0d0 f3fe8ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3860      1 0x00000000
 e8754e5c 00000086 6dd90258 00000b08 c1052065 f3feeed4 c1536980 00000000
 c1531ef0 c1536980 f3feeed4 c1536980 00000086 00000000 00000000 f3834280
 6dc0a67b 00000b08 f3feec20 f38e5204 00000000 e8754e50 c105b0d0 f3feec20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3861      1 0x00000000
 e8755e5c 00000086 6dd92dcb 00000b08 c1052065 f3fee404 c1536980 00000000
 c1531ef0 c1536980 f3fee404 c1536980 00000086 00000000 00000000 f3834280
 6dc0de38 00000b08 f3fee150 f38e5204 00000000 e8755e50 c105b0d0 f3fee150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3862      1 0x00000000
 e8756e5c 00000086 6dc4e624 00000b08 00000000 f3fed934 c1536980 e8756e18
 c1531ef0 c1536980 f3fed934 c1536980 f3fed9c8 631706fc f3fed680 f3834280
 6dc13338 00000b08 f3fed680 f38e5204 00000000 e8756e50 c105b0d0 f3fed680
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3864      1 0x00000000
 e8758e5c 00000086 6dd964d5 00000b08 c1052065 f3fe9854 c1536980 00000000
 c1531ef0 c1536980 f3fe9854 c1536980 00000086 00000000 00000000 f3834280
 6dc0fe44 00000b08 f3fe95a0 f38e5204 00000000 e8758e50 c105b0d0 f3fe95a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3865      1 0x00000000
 e8759e5c 00000086 6dd993f0 00000b08 c1052065 f3feb8c4 c1536980 00000000
 c1531ef0 c1536980 f3feb8c4 c1536980 00000086 00000000 00000000 f3834280
 6dc116b1 00000b08 f3feb610 f38e5204 00000000 e8759e50 c105b0d0 f3feb610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3866      1 0x00000000
 e875ae5c 00000086 6dd9be49 00000b08 c1052065 f3fe82b4 c1536980 00000000
 c1531ef0 c1536980 f3fe82b4 c1536980 00000086 00000000 00000000 f3834280
 6dc14da8 00000b08 f3fe8000 f38e5204 00000000 e875ae50 c105b0d0 f3fe8000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3867      1 0x00000000
 e875be5c 00000086 6dc51caf 00000b08 00000014 f3fece64 c1536980 e875be18
 c1531ef0 c1536980 f3fece64 c1536980 f3fecef8 631706fc f3fecbb0 f3834280
 6dc1687f 00000b08 f3fecbb0 f38e5204 00000000 e875be50 c105b0d0 f3fecbb0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3868      1 0x00000000
 e875ce5c 00000086 6dd9e8d8 00000b08 c1052065 f6b702b4 c1536980 00000000
 c1531ef0 c1536980 f6b702b4 c1536980 00000086 00000000 00000000 f3834280
 6dc1839e 00000b08 f6b70000 f38e5204 00000000 e875ce50 c105b0d0 f6b70000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3869      1 0x00000000
 e875de5c 00000086 6dc548e2 00000b08 00000007 f6b71854 c1536980 e875de18
 c1531ef0 c1536980 f6b71854 c1536980 f6b718e8 631706fc f6b715a0 f3834280
 6dc19e3e 00000b08 f6b715a0 f38e5204 00000000 e875de50 c105b0d0 f6b715a0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2764  3870      1 0x00000000
 e875ee5c 00000086 6dda1e55 00000b08 c1052065 f6b76ed4 c1536980 00000000
 c1531ef0 c1536980 f6b76ed4 c1536980 00000086 00000000 00000000 f3834280
 6dc1bc4c 00000b08 f6b76c20 f38e5204 00000000 e875ee50 c105b0d0 f6b76c20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3871      1 0x00000000
 e875fe5c 00000086 6dc57d0f 00000b08 00000010 f6b72324 c1536980 e875fe18
 c1531ef0 c1536980 f6b72324 c1536980 f6b723b8 631706fc f6b72070 f3834280
 6dc2155a 00000b08 f6b72070 f38e5204 00000000 e875fe50 c105b0d0 f6b72070
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3872      1 0x00000000
 e8760e5c 00000086 6dda4775 00000b08 c1052065 f6b74394 c1536980 00000000
 c1531ef0 c1536980 f6b74394 c1536980 00000086 00000000 00000000 f3834280
 6dc1d572 00000b08 f6b740e0 f38e5204 00000000 e8760e50 c105b0d0 f6b740e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3873      1 0x00000000
 e8761e5c 00000086 6dda7198 00000b08 c1052065 f6b34394 c1536980 00000000
 c1531ef0 c1536980 f6b34394 c1536980 00000086 00000000 00000000 f3834280
 6dc1edba 00000b08 f6b340e0 f38e5204 00000000 e8761e50 c105b0d0 f6b340e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3874      1 0x00000000
 e8762e5c 00000086 6ddaa0ad 00000b08 c1052065 f6b302b4 c1536980 00000000
 c1531ef0 c1536980 f6b302b4 c1536980 00000086 00000000 00000000 f3834280
 6dc23a2f 00000b08 f6b30000 f38e5204 00000000 e8762e50 c105b0d0 f6b30000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3875      1 0x00000000
 e8763e5c 00000086 6dc5b56a 00000b08 00000017 f6b32df4 c1536980 e8763e18
 c1531ef0 c1536980 f6b32df4 c1536980 f6b32e88 631706fc f6b32b40 f3834280
 6dc274fa 00000b08 f6b32b40 f38e5204 00000000 e8763e50 c105b0d0 f6b32b40
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c1095d20>] ? ____pagevec_lru_add+0xf2/0x100
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3876      1 0x00000000
 e8764e5c 00000086 6ddace19 00000b08 c1052065 f6b338c4 c1536980 00000000
 c1531ef0 c1536980 f6b338c4 c1536980 00000086 00000000 00000000 f3834280
 6dc258b5 00000b08 f6b33610 f38e5204 00000000 e8764e50 c105b0d0 f6b33610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3877      1 0x00000000
 e8765e5c 00000086 6ddaf74b 00000b08 c1052065 f6b36ed4 c1536980 00000000
 c1531ef0 c1536980 f6b36ed4 c1536980 00000086 00000000 00000000 f3834280
 6dc291cf 00000b08 f6b36c20 f38e5204 00000000 e8765e50 c105b0d0 f6b36c20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2804  3878      1 0x00000000
 e8766e5c 00000086 6dc5e636 00000b08 00000010 f6b30d84 c1536980 e8766e18
 c1531ef0 c1536980 f6b30d84 c1536980 f6b30e18 631706fc f6b30ad0 f3834280
 6dc2c1cf 00000b08 f6b30ad0 f38e5204 00000000 e8766e50 c105b0d0 f6b30ad0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2812  3879      1 0x00000000
 e8767e5c 00000086 6ddb23a8 00000b08 c1052065 f6b32324 c1536980 00000000
 c1531ef0 c1536980 f6b32324 c1536980 00000086 00000000 00000000 f3834280
 6dc33470 00000b08 f6b32070 f38e5204 00000000 e8767e50 c105b0d0 f6b32070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3880      1 0x00000000
 e8768e5c 00000086 6dc61d0f 00000b08 00000019 f6b35934 c1536980 e8768e18
 c1531ef0 c1536980 f6b35934 c1536980 f6b359c8 631706fc f6b35680 f3834280
 6dc2ddde 00000b08 f6b35680 f38e5204 00000000 e8768e50 c105b0d0 f6b35680
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3881      1 0x00000000
 e8769e5c 00000086 6dc654a3 00000b08 0000001d f6b36404 c1536980 e8769e18
 c1531ef0 c1536980 f6b36404 c1536980 f6b36498 631706fc f6b36150 f3834280
 6dc2fd06 00000b08 f6b36150 f38e5204 00000000 e8769e50 c105b0d0 f6b36150
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3882      1 0x00000000
 e87ace5c 00000086 6dc6812a 00000b08 00000008 f6b31854 c1536980 e87ace18
 c1531ef0 c1536980 f6b31854 c1536980 f6b318e8 631706fc f6b315a0 f3834280
 6dc319db 00000b08 f6b315a0 f38e5204 00000000 e87ace50 c105b0d0 f6b315a0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3883      1 0x00000000
 e87ade5c 00000086 6dc6b2ab 00000b08 0000000c f652ce64 c1536980 e87ade18
 c1531ef0 c1536980 f652ce64 c1536980 f652cef8 631706fc f652cbb0 f3834280
 6dc3507f 00000b08 f652cbb0 f38e5204 00000000 e87ade50 c105b0d0 f652cbb0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2956  3884      1 0x00000000
 e87aee5c 00000086 6ddb5162 00000b08 c1052065 f652d934 c1536980 00000000
 c1531ef0 c1536980 f652d934 c1536980 00000086 00000000 00000000 f3834280
 6dc371cf 00000b08 f652d680 f38e5204 00000000 e87aee50 c105b0d0 f652d680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3885      1 0x00000000
 e87afe5c 00000086 6dc6dfd4 00000b08 00000007 f652adf4 c1536980 e87afe18
 c1531ef0 c1536980 f652adf4 c1536980 f652ae88 631706fc f652ab40 f3834280
 6dc3bcca 00000b08 f652ab40 f38e5204 00000000 e87afe50 c105b0d0 f652ab40
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3886      1 0x00000000
 e87b0e5c 00000086 6ddb7dbf 00000b08 c1052065 f65282b4 c1536980 00000000
 c1531ef0 c1536980 f65282b4 c1536980 00000086 00000000 00000000 f3834280
 6dc38c5e 00000b08 f6528000 f38e5204 00000000 e87b0e50 c105b0d0 f6528000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3887      1 0x00000000
 e87b1e5c 00000086 6ddba865 00000b08 c1052065 f652eed4 c1536980 00000000
 c1531ef0 c1536980 f652eed4 c1536980 00000086 00000000 00000000 f3834280
 6dc3a2b3 00000b08 f652ec20 f38e5204 00000000 e87b1e50 c105b0d0 f652ec20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3888      1 0x00000000
 e87b2e5c 00000086 6ddbd8ad 00000b08 c1052065 f652e404 c1536980 00000000
 c1531ef0 c1536980 f652e404 c1536980 00000086 00000000 00000000 f3834280
 6dc3f44c 00000b08 f652e150 f38e5204 00000000 e87b2e50 c105b0d0 f652e150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3889      1 0x00000000
 e87b3e5c 00000086 6dc71df4 00000b08 0000001d f6529854 c1536980 e87b3e18
 c1531ef0 c1536980 f6529854 c1536980 f65298e8 631706fc f65295a0 f3834280
 6dc3d9e1 00000b08 f65295a0 f38e5204 00000000 e87b3e50 c105b0d0 f65295a0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c1095d20>] ? ____pagevec_lru_add+0xf2/0x100
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3890      1 0x00000000
 e87b4e5c 00000086 6dc75654 00000b08 00000019 f6528d84 c1536980 e87b4e18
 c1531ef0 c1536980 f6528d84 c1536980 f6528e18 631706fc f6528ad0 f3834280
 6dc410c7 00000b08 f6528ad0 f38e5204 00000000 e87b4e50 c105b0d0 f6528ad0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c1017aa4>] ? apic_write+0xf/0x11
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3891      1 0x00000000
 e87b5e5c 00000086 6ddc03f6 00000b08 c1052065 f652a324 c1536980 00000000
 c1531ef0 c1536980 f652a324 c1536980 00000086 00000000 00000000 f3834280
 6dc4361a 00000b08 f652a070 f38e5204 00000000 e87b5e50 c105b0d0 f652a070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3892      1 0x00000000
 e87b6e5c 00000086 6dc7845b 00000b08 0000000b f64fadf4 c1536980 e87b6e18
 c1531ef0 c1536980 f64fadf4 c1536980 f64fae88 631706fc f64fab40 f3834280
 6dc471a5 00000b08 f64fab40 f38e5204 00000000 e87b6e50 c105b0d0 f64fab40
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3893      1 0x00000000
 e87b8e5c 00000086 6ddc3035 00000b08 c1052065 f64fe404 c1536980 00000000
 c1531ef0 c1536980 f64fe404 c1536980 00000086 00000000 00000000 f3834280
 6dc45386 00000b08 f64fe150 f38e5204 00000000 e87b8e50 c105b0d0 f64fe150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3894      1 0x00000000
 e87b9e5c 00000086 6ddc5bf0 00000b08 c1052065 f64fb8c4 c1536980 00000000
 c1531ef0 c1536980 f64fb8c4 c1536980 00000086 00000000 00000000 f3834280
 6dc4b121 00000b08 f64fb610 f38e5204 00000000 e87b9e50 c105b0d0 f64fb610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2956  3895      1 0x00000000
 e87bae5c 00000086 6dc7be66 00000b08 0000001d f64f82b4 c1536980 e87bae18
 c1531ef0 c1536980 f64f82b4 c1536980 f64f8348 631706fc f64f8000 f3834280
 6dc49404 00000b08 f64f8000 f38e5204 00000000 e87bae50 c105b0d0 f64f8000
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3896      1 0x00000000
 e87bbe5c 00000086 6dc7f54b 00000b08 00000019 f64fce64 c1536980 e87bbe18
 c1531ef0 c1536980 f64fce64 c1536980 f64fcef8 631706fc f64fcbb0 f3834280
 6dc52f34 00000b08 f64fcbb0 f38e5204 00000000 e87bbe50 c105b0d0 f64fcbb0
Call Trace:
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3897      1 0x00000000
 e87bce5c 00000086 6ddc8caa 00000b08 c1052065 f64f9854 c1536980 00000000
 c1531ef0 c1536980 f64f9854 c1536980 00000086 00000000 00000000 f3834280
 6dc4cde4 00000b08 f64f95a0 f38e5204 00000000 e87bce50 c105b0d0 f64f95a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3898      1 0x00000000
 e87bde5c 00000086 6ddcbb90 00000b08 c1052065 f64f8d84 c1536980 00000000
 c1531ef0 c1536980 f64f8d84 c1536980 00000086 00000000 00000000 f3834280
 6dc4e8fd 00000b08 f64f8ad0 f38e5204 00000000 e87bde50 c105b0d0 f64f8ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3899      1 0x00000000
 e87bee5c 00000086 6ddceaf4 00000b08 c1052065 f64fc394 c1536980 00000000
 c1531ef0 c1536980 f64fc394 c1536980 00000086 00000000 00000000 f3834280
 6dc503f8 00000b08 f64fc0e0 f38e5204 00000000 e87bee50 c105b0d0 f64fc0e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3900      1 0x00000000
 e87bfe5c 00000086 6ddd1697 00000b08 c1052065 f64fa324 c1536980 00000000
 c1531ef0 c1536980 f64fa324 c1536980 00000086 00000000 00000000 f3834280
 6dc57eb6 00000b08 f64fa070 f38e5204 00000000 e87bfe50 c105b0d0 f64fa070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c1095d20>] ? ____pagevec_lru_add+0xf2/0x100
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2956  3901      1 0x00000000
 e87c0e5c 00000086 6dc81e00 00000b08 c1052065 f64fd934 c1536980 00000000
 c1531ef0 c1536980 f64fd934 c1536980 00000086 00000000 00000000 f3834280
 6dc560d3 00000b08 f64fd680 f38e5204 00000000 e87c0e50 c105b0d0 f64fd680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2956  3902      1 0x00000000
 e87c1e5c 00000086 6dc84bd7 00000b08 c1052065 f72dadf4 c1536980 00000000
 c1531ef0 c1536980 f72dadf4 c1536980 00000086 00000000 00000000 f3834280
 6dc5cd90 00000b08 f72dab40 f38e5204 00000000 e87c1e50 c105b0d0 f72dab40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3903      1 0x00000000
 e87c2e5c 00000086 6ddd433c 00000b08 c1052065 f72d8d84 c1536980 00000000
 c1531ef0 c1536980 f72d8d84 c1536980 00000086 00000000 00000000 f3834280
 6dc59b43 00000b08 f72d8ad0 f38e5204 00000000 e87c2e50 c105b0d0 f72d8ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2764  3904      1 0x00000000
 e87c3e5c 00000086 6ddd6e43 00000b08 c1052065 f385b8c4 c1536980 00000000
 c1531ef0 c1536980 f385b8c4 c1536980 00000086 00000000 00000000 f3834280
 6dc5e80d 00000b08 f385b610 f38e5204 00000000 e87c3e50 c105b0d0 f385b610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2764  3905      1 0x00000000
 e87c4e5c 00000086 6dc8888e 00000b08 c1052065 f3859854 c1536980 00000000
 c1531ef0 c1536980 f3859854 c1536980 00000086 00000000 00000000 f38b9680
 6dc85e62 00000b08 f38595a0 f38e5204 00000000 e87c4e50 c105b0d0 f38595a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3906      1 0x00000000
 e87c5e5c 00000086 6ddd9ba8 00000b08 c1052065 f38582b4 c1536980 00000000
 c1531ef0 c1536980 f38582b4 c1536980 00000086 00000000 00000000 f3834280
 6dc6212d 00000b08 f3858000 f38e5204 00000000 e87c5e50 c105b0d0 f3858000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3907      1 0x00000000
 e87c6e5c 00000086 6dc92c4f 00000b08 c1052065 f385c394 c1536980 00000000
 c1531ef0 c1536980 f385c394 c1536980 00000086 00000000 00000000 f3834280
 6dc6682b 00000b08 f385c0e0 f38e5204 00000000 e87c6e50 c105b0d0 f385c0e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3908      1 0x00000000
 e87c7e5c 00000086 6dddc733 00000b08 c1052065 f385eed4 c1536980 00000000
 c1531ef0 c1536980 f385eed4 c1536980 00000086 00000000 00000000 f3834280
 6dc63bb6 00000b08 f385ec20 f38e5204 00000000 e87c7e50 c105b0d0 f385ec20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3909      1 0x00000000
 e87c9e5c 00000086 6dddf192 00000b08 c1052065 f3858d84 c1536980 00000000
 c1531ef0 c1536980 f3858d84 c1536980 00000086 00000000 00000000 f3834280
 6dc6e22f 00000b08 f3858ad0 f38e5204 00000000 e87c9e50 c105b0d0 f3858ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c105fa1c>] ? do_futex+0x99/0x690
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3910      1 0x00000000
 e87cae5c 00000086 6dc9601c 00000b08 c1052065 f385e404 c1536980 00000000
 c1531ef0 c1536980 f385e404 c1536980 00000086 00000000 00000000 f3834280
 6dc698d3 00000b08 f385e150 f38e5204 00000000 e87cae50 c105b0d0 f385e150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3911      1 0x00000000
 e87cbe5c 00000086 6dc98cd9 00000b08 c1052065 f398a324 c1536980 00000000
 c1531ef0 c1536980 f398a324 c1536980 00000086 00000000 00000000 f3834280
 6dc6c5ae 00000b08 f398a070 f38e5204 00000000 e87cbe50 c105b0d0 f398a070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  3912      1 0x00000000
 e87d0e5c 00000086 6dc9b26f 00000b08 c1052065 f39882b4 c1536980 00000000
 c1531ef0 c1536980 f39882b4 c1536980 00000086 00000000 00000000 f3834280
 6dc73e86 00000b08 f3988000 f38e5204 00000000 e87d0e50 c105b0d0 f3988000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2956  3913      1 0x00000000
 e87d1e5c 00000086 6dde1c4a 00000b08 c1052065 f398d934 c1536980 00000000
 c1531ef0 c1536980 f398d934 c1536980 00000086 00000000 00000000 f3834280
 6dc7040a 00000b08 f398d680 f38e5204 00000000 e87d1e50 c105b0d0 f398d680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2880  3915      1 0x00000000
 e87d4e5c 00000086 6dde54f8 00000b08 c1052065 f389eed4 c1536980 00000000
 c1531ef0 c1536980 f389eed4 c1536980 00000086 00000000 00000000 f3834280
 6dc720b5 00000b08 f389ec20 f38e5204 00000000 e87d4e50 c105b0d0 f389ec20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10bd749>] ? pipe_read+0x290/0x2db
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c10b6ca5>] ? fput_light+0xc/0xe
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  4512      1 0x00000000
 ddd6de5c 00000086 6dde808f 00000b08 c1052065 e6f2d934 c1536980 00000000
 c1531ef0 c1536980 e6f2d934 c1536980 00000086 00000000 00000000 f3834280
 6dc786e0 00000b08 e6f2d680 f38e5204 00000000 ddd6de50 c105b0d0 e6f2d680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c12f6298>] ? _raw_spin_unlock+0x33/0x3f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10a3c2b>] ? do_wp_page+0x64d/0x6ce
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  4513      1 0x00000000
 e8752e5c 00000086 6dc9d996 00000b08 c1052065 e6f34394 c1536980 00000000
 c1531ef0 c1536980 e6f34394 c1536980 00000086 00000000 00000000 f3834280
 6dc76a53 00000b08 e6f340e0 f38e5204 00000000 e8752e50 c105b0d0 e6f340e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  4514      1 0x00000000
 dca6be5c 00000086 6dca010c 00000b08 c1052065 e6f36404 c1536980 00000000
 c1531ef0 c1536980 e6f36404 c1536980 00000086 00000000 00000000 f3834280
 6dc7a49a 00000b08 e6f36150 f38e5204 00000000 dca6be50 c105b0d0 e6f36150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  4515      1 0x00000000
 d5b0ce5c 00000086 6ddeac80 00000b08 c1052065 e6f32df4 c1536980 00000000
 c1531ef0 c1536980 e6f32df4 c1536980 00000086 00000000 00000000 f3834280
 6dc7c0b5 00000b08 e6f32b40 f38e5204 00000000 d5b0ce50 c105b0d0 e6f32b40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2812  4516      1 0x00000000
 d5b06e5c 00000086 6dca2b77 00000b08 c1052065 e6f2adf4 c1536980 00000000
 c1531ef0 c1536980 e6f2adf4 c1536980 00000086 00000000 00000000 f3834280
 6dc7dd84 00000b08 e6f2ab40 f38e5204 00000000 d5b06e50 c105b0d0 e6f2ab40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2836  4592      1 0x00000000
 d539fe5c 00000086 6dded438 00000b08 c1052065 dd9d02b4 c1536980 00000000
 c1531ef0 c1536980 dd9d02b4 c1536980 00000086 00000000 00000000 f64f2f00
 6dc7f987 00000b08 dd9d0000 f38e5204 00000000 d539fe50 c105b0d0 dd9d0000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10a125b>] ? spin_lock+0x8/0xa
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10a3c2b>] ? do_wp_page+0x64d/0x6ce
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
console-kit-d D 00000b08  2952  4636      1 0x00000000
 d5326e5c 00000086 6dca54a9 00000b08 c1052065 e2316ed4 c1536980 00000000
 c1531ef0 c1536980 e2316ed4 c1536980 00000086 00000000 00000000 f38b9680
 6dc83999 00000b08 e2316c20 f38e5204 00000000 d5326e50 c105b0d0 e2316c20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c11c738c>] ? vt_ioctl+0x0/0x169c
 [<c11c05d8>] ? tty_ioctl+0x6ab/0x70e
 [<c10c1a06>] ? vfs_ioctl+0x27/0x91
 [<c11bff2d>] ? tty_ioctl+0x0/0x70e
 [<c10c1f8b>] ? do_vfs_ioctl+0x47c/0x4ba
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
devkit-power- D 00000b08  2088  3959      1 0x00000000
 e32a6e5c 00000086 6ddf0fa5 00000b08 c1052065 e6f34e64 c1536980 00000000
 c1531ef0 c1536980 e6f34e64 c1536980 00000086 00000000 00000000 d4557400
 6dd5ea0a 00000b08 e6f34bb0 f710f884 00000000 e32a6e50 c105b0d0 e6f34bb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c104ba45>] ? remove_wait_queue+0xf/0x27
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104ba58>] ? remove_wait_queue+0x22/0x27
 [<c1037415>] ? do_wait+0x1b6/0x1e9
 [<c10374dc>] ? sys_wait4+0x94/0xa1
 [<c1035d59>] ? child_wait_callback+0x0/0x5f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
rtkit-daemon  D 00000b08  2048  3968      1 0x00000000
 e2669e5c 00000086 6ddf8af4 00000b08 c1052065 f389c394 c1536980 00000000
 c1531ef0 c1536980 f389c394 c1536980 00000086 00000000 00000000 f64b9b80
 6dc8c554 00000b08 f389c0e0 f38e6804 00000000 e2669e50 c105b0d0 f389c0e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10b6ea2>] ? do_sync_readv_writev+0x84/0xb7
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c10b7ae6>] ? do_readv_writev+0xd2/0xdf
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
rtkit-daemon  D 00000b08  2036  3971      1 0x00000000
 e266ae5c 00000086 6dca9c85 00000b08 c1052065 e6f35934 c1536980 00000000
 c1531ef0 c1536980 e6f35934 c1536980 00000086 00000000 00000000 f64f3b80
 6dc8a5f6 00000b08 e6f35680 f38e6804 00000000 e266ae50 c105b0d0 e6f35680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c102baa3>] ? finish_task_switch+0x5b/0xa1
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10c329c>] ? pollwake+0x57/0x60
 [<c102ccce>] ? default_wake_function+0x0/0xd
 [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
 [<c1025f06>] ? need_resched+0x14/0x1e
 [<c12f4ab1>] ? preempt_schedule+0x46/0x4c
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
rtkit-daemon  D 00000b08  2112  3972      1 0x00000000
 e2744e5c 00000086 6dc8e7f8 00000b08 c1052065 e6f36ed4 c1536980 00000000
 c1531ef0 c1536980 e6f36ed4 c1536980 00000086 00000000 00000000 f3834280
 6dc6059c 00000b08 e6f36c20 f38e6804 00000000 e2744e50 c105b0d0 e6f36c20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
polkitd       D 00000b08  2092  3974      1 0x00000000
 e2cc4e5c 00000086 6dcae39b 00000b08 c1052065 e6f2eed4 c1536980 00000000
 c1531ef0 c1536980 e6f2eed4 c1536980 00000086 00000000 00000000 f64b8a00
 6dc90f94 00000b08 e6f2ec20 f726dd04 00000000 e2cc4e50 c105b0d0 e6f2ec20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
hald          D 00000b08  2092  3977      1 0x00000000
 e22eee5c 00000086 6de0591f 00000b08 c1052065 e20d9854 c1536980 00000000
 c1531ef0 c1536980 e20d9854 c1536980 00000086 00000000 00000000 f64b8500
 6dc9309d 00000b08 e20d95a0 f726f884 00000000 e22eee50 c105b0d0 e20d95a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
hald-runner   D 00000b08  2280  3978   3977 0x00000000
 e21b7e5c 00000086 6dcb13cb 00000b08 c1052065 f70d4394 c1536980 00000000
 c1531ef0 c1536980 f70d4394 c1536980 00000086 00000000 00000000 f64b8f00
 6dc94e44 00000b08 f70d40e0 f38e6d84 00000000 e21b7e50 c105b0d0 f70d40e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105c338>] ? __lock_acquire+0xb58/0xb67
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c116eb10>] ? do_raw_spin_unlock+0x8f/0x94
 [<c102412e>] ? kunmap_atomic+0xa9/0xc0
 [<c10a3c2b>] ? do_wp_page+0x64d/0x6ce
 [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
 [<c12f5dff>] ? _raw_spin_lock+0x2c/0x34
 [<c104f359>] ? up_read+0x16/0x29
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
hald-addon-in D 00000b08  1980  4033   3978 0x00000000
 e0cdae5c 00000086 6de0cec7 00000b08 c1052065 e20dce64 c1536980 00000000
 c1531ef0 c1536980 e20dce64 c1536980 00000086 00000000 00000000 f3834f00
 6dc9711b 00000b08 e20dcbb0 f653f304 00000000 e0cdae50 c105b0d0 e20dcbb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
 [<c12540b7>] ? evdev_read+0x131/0x186
 [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c12540f9>] ? evdev_read+0x173/0x186
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c1253f86>] ? evdev_read+0x0/0x186
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
hald-addon-le D 00000b08  2284  4035   3978 0x00000000
 e0e15e5c 00000086 6dcb42ff 00000b08 c1052065 e20db8c4 c1536980 00000000
 c1531ef0 c1536980 e20db8c4 c1536980 00000086 00000000 00000000 f64b9180
 6dc9bd1e 00000b08 e20db610 f653f884 00000000 e0e15e50 c105b0d0 e20db610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10b6ea2>] ? do_sync_readv_writev+0x84/0xb7
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c10b7ae6>] ? do_readv_writev+0xd2/0xdf
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
hald-addon-ge D 00000b08  2164  4040   3978 0x00000000
 e0010e5c 00000086 6de11ab8 00000b08 c1052065 e23102b4 c1536980 00000000
 c1531ef0 c1536980 e23102b4 c1536980 00000086 00000000 00000000 f38b8280
 6dc98eec 00000b08 e2310000 f3889b04 00000000 e0010e50 c105b0d0 e2310000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10b6ea2>] ? do_sync_readv_writev+0x84/0xb7
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c10b7ae6>] ? do_readv_writev+0xd2/0xdf
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10a6390>] ? remove_vma+0x52/0x58
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
hald-addon-st D 00000b08  2036  4043   3978 0x00000000
 e0ecee5c 00000086 6de17751 00000b08 c1052065 e2310d84 c1536980 00000000
 c1531ef0 c1536980 e2310d84 c1536980 00000086 00000000 00000000 dc68ea00
 6dca0bc7 00000b08 e2310ad0 f3888a84 00000000 e0ecee50 c105b0d0 e2310ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105ac23>] ? mark_lock+0x1e/0x1b4
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b8287>] ? file_kill+0x14/0x2b
 [<c1075c79>] ? __call_rcu+0xfa/0x116
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
hald-addon-ac D 00000b08  2284  4051   3978 0x00000000
 e0260e5c 00000086 6dcb8d1b 00000b08 c1052065 e20deed4 c1536980 00000000
 c1531ef0 c1536980 e20deed4 c1536980 00000086 00000000 00000000 dc68f180
 6dc9ee86 00000b08 e20dec20 f653b684 00000000 e0260e50 c105b0d0 e20dec20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c116fbb6>] ? free_object+0x12/0x81
 [<c116fbb6>] ? free_object+0x12/0x81
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c116fc12>] ? free_object+0x6e/0x81
 [<c116fe3c>] ? debug_object_free+0xc4/0xd6
 [<c104e072>] ? destroy_hrtimer_on_stack+0xd/0xf
 [<c104f153>] ? hrtimer_nanosleep+0xcb/0xe6
 [<c104e3bd>] ? hrtimer_wakeup+0x0/0x1c
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
devkit-disks- D 00000b08  1988  4252      1 0x00000000
 dbc67e5c 00000086 6dcc17b0 00000b08 c1052065 dc66ce64 c1536980 00000000
 c1531ef0 c1536980 dc66ce64 c1536980 00000086 00000000 00000000 dc488000
 6dca397b 00000b08 dc66cbb0 f6beb684 00000000 dbc67e50 c105b0d0 dc66cbb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
devkit-disks- D 00000b08  2036  4254   4252 0x00000000
 dbd43e5c 00000086 6de1e10d 00000b08 c1052065 dc66c394 c1536980 00000000
 c1531ef0 c1536980 dc66c394 c1536980 00000086 00000000 00000000 dc99ea00
 6dcad740 00000b08 dc66c0e0 f6bee284 00000000 dbd43e50 c105b0d0 dc66c0e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105a22b>] ? register_lock_class+0x17/0x2a2
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c102ccba>] ? try_to_wake_up+0x32d/0x341
 [<c10b8287>] ? file_kill+0x14/0x2b
 [<c1075c79>] ? __call_rcu+0xfa/0x116
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
Xorg          D 00000b08  1848  4444      1 0x00400000
 e87d8e5c 00200086 6dcc91d8 00000b08 c1052065 e20de404 c1536980 00000000
 c1531ef0 c1536980 e20de404 c1536980 00200086 00000000 00000000 dc488280
 6dca6d3c 00000b08 e20de150 f38e0504 00000000 e87d8e50 c105b0d0 e20de150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105a22b>] ? register_lock_class+0x17/0x2a2
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
dbus-launch   D 00000b08  2156  4463      1 0x00000000
 e6e63e5c 00000086 6dccca92 00000b08 c1052065 e2314e64 c1536980 00000000
 c1531ef0 c1536980 e2314e64 c1536980 00000086 00000000 00000000 dc99e500
 6dca8bdf 00000b08 e2314bb0 f3889584 00000000 e6e63e50 c105b0d0 e2314bb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10a125b>] ? spin_lock+0x8/0xa
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
dbus-daemon   D 00000b08  2120  4464      1 0x00000000
 dfc2ae5c 00000086 6dcd6e8f 00000b08 c1052065 e20da324 c1536980 00000000
 c1531ef0 c1536980 e20da324 c1536980 00000086 00000000 00000000 dc99ea00
 6dcab9ed 00000b08 e20da070 f38e1004 00000000 dfc2ae50 c105b0d0 e20da070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-session D 00000b08  2164  4465      1 0x00000000
 def12e5c 00000086 6dce025c 00000b08 c1052065 e2312df4 c1536980 00000000
 c1531ef0 c1536980 e2312df4 c1536980 00000086 00000000 00000000 dc99ef00
 6dcafd6c 00000b08 e2312b40 f388b684 00000000 def12e50 c105b0d0 e2312b40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-session D 00000b08  3040  4470      1 0x00000000
 def19e5c 00000086 6de215c4 00000b08 c1052065 e20dc394 c1536980 00000000
 c1531ef0 c1536980 e20dc394 c1536980 00000086 00000000 00000000 dc488f00
 6dcb7cdb 00000b08 e20dc0e0 f388b684 00000000 def19e50 c105b0d0 e20dc0e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10bd749>] ? pipe_read+0x290/0x2db
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c10b6ca5>] ? fput_light+0xc/0xe
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gconfd-2      D 00000b08  2092  4468      1 0x00000000
 dcab9e5c 00000086 6dcec924 00000b08 c1052065 e2312324 c1536980 00000000
 c1531ef0 c1536980 e2312324 c1536980 00000086 00000000 00000000 dc489400
 6dcb2eec 00000b08 e2312070 f388f884 00000000 dcab9e50 c105b0d0 e2312070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1017c5b>] ? lapic_next_event+0xf/0x13
 [<c10568c4>] ? clockevents_program_event+0xc6/0xd8
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-setting D 00000b08  2036  4471      1 0x00000000
 debf9e5c 00200086 6dcf6846 00000b08 c1052065 e23138c4 c1536980 00000000
 c1531ef0 c1536980 e23138c4 c1536980 00200086 00000000 00000000 dc489400
 6dcb5aa1 00000b08 e2313610 f388c184 00000000 debf9e50 c105b0d0 e2313610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-setting D 00000b08  3036  4473      1 0x00000000
 d705ee5c 00000086 6dcf9f73 00000b08 c1052065 e2311854 c1536980 00000000
 c1531ef0 c1536980 e2311854 c1536980 00000086 00000000 00000000 dc489680
 6dcba945 00000b08 e23115a0 f388c184 00000000 d705ee50 c105b0d0 e23115a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10bd749>] ? pipe_read+0x290/0x2db
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c10b6ca5>] ? fput_light+0xc/0xe
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfsd         D 00000b08  2164  4480      1 0x00000000
 d890ae5c 00000086 6de25ea9 00000b08 c1052065 f3fec394 c1536980 00000000
 c1531ef0 c1536980 f3fec394 c1536980 00000086 00000000 00000000 dc488c80
 6dcbc722 00000b08 f3fec0e0 f388c704 00000000 d890ae50 c105b0d0 f3fec0e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c10b7ae6>] ? do_readv_writev+0xd2/0xdf
 [<c10578e2>] ? tick_program_event+0x33/0x3b
 [<c104e737>] ? hrtimer_interrupt+0x12e/0x1f8
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
notify-osd    D 00000b08  2164  4482      1 0x00000000
 d609fe5c 00000086 6dcff8a0 00000b08 c1052065 e6f2c394 c1536980 00000000
 c1531ef0 c1536980 e6f2c394 c1536980 00000086 00000000 00000000 dc99f900
 6dcc06ec 00000b08 e6f2c0e0 f3888504 00000000 d609fe50 c105b0d0 e6f2c0e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c10c3fee>] ? __d_free+0x38/0x3b
 [<c10c969f>] ? mntput_no_expire+0x19/0xb1
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
metacity      D 00000b08  2036  4483   4465 0x00000000
 d5be5e5c 00200086 6de2d68a 00000b08 c1052065 e6f28d84 c1536980 00000000
 c1531ef0 c1536980 e6f28d84 c1536980 00200086 00000000 00000000 dc488c80
 6dcbe8c0 00000b08 e6f28ad0 f388f304 00000000 d5be5e50 c105b0d0 e6f28ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c10c3fee>] ? __d_free+0x38/0x3b
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
metacity      D 00000b08  2284  4506   4465 0x00000000
 de810e5c 00200086 6de312fa 00000b08 c1052065 e6f282b4 c1536980 00000000
 c1531ef0 c1536980 e6f282b4 c1536980 00200086 00000000 00000000 dc99e280
 6dcc21f3 00000b08 e6f28000 f388f304 00000000 de810e50 c105b0d0 e6f28000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105c338>] ? __lock_acquire+0xb58/0xb67
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1287ce4>] ? fput_light+0xc/0xe
 [<c1287f35>] ? sys_recvmsg+0x39/0x43
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-power-m D 00000b08  2092  4484   4465 0x00000000
 de815e5c 00200086 6dd06dff 00000b08 c1052065 f3fe4394 c1536980 00000000
 c1531ef0 c1536980 f3fe4394 c1536980 00200086 00000000 00000000 dc99e280
 6dcc4000 00000b08 f3fe40e0 f38e6284 00000000 de815e50 c105b0d0 f3fe40e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
pulseaudio    D 00000b08  2072  4491      1 0x00000000
 d95cbe5c 00000086 6de3e6e4 00000b08 c1052065 e6f32324 c1536980 00000000
 c1531ef0 c1536980 e6f32324 c1536980 00000086 00000000 00000000 dc489900
 6dcc5bd9 00000b08 e6f32070 f38e3684 00000000 d95cbe50 c105b0d0 e6f32070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c116bad6>] ? copy_to_user+0x2b/0x57
 [<c10c29d7>] ? poll_select_copy_remaining+0xb1/0xcd
 [<c10c3b1b>] ? sys_ppoll+0xe1/0xf8
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
pulseaudio    D 00000b08  2144  4494      1 0x00000000
 d712ae5c 00000086 6dd0ae83 00000b08 c1052065 e6f2b8c4 c1536980 00000000
 c1531ef0 c1536980 e6f2b8c4 c1536980 00000086 00000000 00000000 f64f2780
 6dccb0ea 00000b08 e6f2b610 f38e3684 00000000 d712ae50 c105b0d0 e6f2b610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c102ccba>] ? try_to_wake_up+0x32d/0x341
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105de04>] ? spin_unlock+0x8/0xa
 [<c105e46f>] ? futex_wake+0xc6/0xd0
 [<c105fa1c>] ? do_futex+0x99/0x690
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10b6d7a>] ? fsnotify_access+0x4f/0x5a
 [<c10c3b1b>] ? sys_ppoll+0xe1/0xf8
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gconf-helper  D 00000b08  2164  4492   4491 0x00000000
 debf7e5c 00000086 6de43847 00000b08 c1052065 e6f2ce64 c1536980 00000000
 c1531ef0 c1536980 e6f2ce64 c1536980 00000086 00000000 00000000 f38b8f00
 6dcc79a5 00000b08 e6f2cbb0 f388bc04 00000000 debf7e50 c105b0d0 e6f2cbb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b40af>] ? kmem_cache_free+0xac/0xfd
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c10c3fee>] ? __d_free+0x38/0x3b
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10c3fee>] ? __d_free+0x38/0x3b
 [<c10c3fee>] ? __d_free+0x38/0x3b
 [<c10c969f>] ? mntput_no_expire+0x19/0xb1
 [<c10b843a>] ? __fput+0x173/0x17b
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gdm-binary    D 00000b08  2036  4624   3777 0x00000000
 d52fee5c 00000086 6de4946e 00000b08 c1052065 e2314394 c1536980 00000000
 c1531ef0 c1536980 e2314394 c1536980 00000086 00000000 00000000 dc68e000
 6dcd7a17 00000b08 e23140e0 f388b104 00000000 d52fee50 c105b0d0 e23140e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104b927>] ? finish_wait+0x44/0x49
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gdm-simple-sl D 00000b08  2156  4633   4624 0x00000000
 d5321e5c 00000086 6dd1023e 00000b08 c1052065 e2315934 c1536980 00000000
 c1531ef0 c1536980 e2315934 c1536980 00000086 00000000 00000000 f64f2280
 6dcce1ab 00000b08 e2315680 f388ab84 00000000 d5321e50 c105b0d0 e2315680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c104ba45>] ? remove_wait_queue+0xf/0x27
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c12f62ed>] ? _raw_spin_unlock_irqrestore+0x49/0x81
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104ba58>] ? remove_wait_queue+0x22/0x27
 [<c1037415>] ? do_wait+0x1b6/0x1e9
 [<c10374dc>] ? sys_wait4+0x94/0xa1
 [<c1035d59>] ? child_wait_callback+0x0/0x5f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
Xorg          D 00000b08  1680  4635   4633 0x00400000
 d5324e5c 00200086 6dd2680f 00000b08 c1052065 e2316404 c1536980 00000000
 c1531ef0 c1536980 e2316404 c1536980 00200086 00000000 00000000 f64f3680
 6dccfe86 00000b08 e2316150 f3889004 00000000 d5324e50 c105b0d0 e2316150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c116bad6>] ? copy_to_user+0x2b/0x57
 [<c10c29d7>] ? poll_select_copy_remaining+0xb1/0xcd
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
dbus-launch   D 00000b08  2156  4654      1 0x00000000
 d4924e5c 00000086 6dd29e59 00000b08 c1052065 e20dadf4 c1536980 00000000
 c1531ef0 c1536980 e20dadf4 c1536980 00000086 00000000 00000000 f38b9400
 6dcd208a 00000b08 e20dab40 f726fe04 00000000 d4924e50 c105b0d0 e20dab40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10a125b>] ? spin_lock+0x8/0xa
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gdm-session-w D 00000b08  2164  4676   4633 0x00000000
 d49b1e5c 00000086 6dd2f3be 00000b08 c1052065 dc66e404 c1536980 00000000
 c1531ef0 c1536980 dc66e404 c1536980 00000086 00000000 00000000 dc68e000
 6dcd3de4 00000b08 dc66e150 f388ed84 00000000 d49b1e50 c105b0d0 dc66e150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c104ba45>] ? remove_wait_queue+0xf/0x27
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c12f62ed>] ? _raw_spin_unlock_irqrestore+0x49/0x81
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104ba58>] ? remove_wait_queue+0x22/0x27
 [<c1037415>] ? do_wait+0x1b6/0x1e9
 [<c10374dc>] ? sys_wait4+0x94/0xa1
 [<c1035d59>] ? child_wait_callback+0x0/0x5f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-keyring D 00000b08  2036  4695      1 0x00000000
 d4926e5c 00000086 6dd384b5 00000b08 c1052065 e6f338c4 c1536980 00000000
 c1531ef0 c1536980 e6f338c4 c1536980 00000086 00000000 00000000 dc68e000
 6dcd5c33 00000b08 e6f33610 f726e284 00000000 d4926e50 c105b0d0 e6f33610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104b927>] ? finish_wait+0x44/0x49
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-keyring D 00000b08  3128  4696      1 0x00000000
 d4932e5c 00000086 6dd3b172 00000b08 c1052065 dc66adf4 c1536980 00000000
 c1531ef0 c1536980 dc66adf4 c1536980 00000086 00000000 00000000 dc488780
 6dcd96e0 00000b08 dc66ab40 f726e284 00000000 d4932e50 c105b0d0 dc66ab40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1041916>] ? recalc_sigpending+0x5e/0x72
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c1041d14>] ? spin_unlock_irq+0x8/0xa
 [<c104438d>] ? sys_rt_sigtimedwait+0x18e/0x1db
 [<c104f359>] ? up_read+0x16/0x29
 [<c12f696d>] ? restore_all_notrace+0x0/0x18
 [<c1020347>] ? do_page_fault+0x0/0x2bb
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-keyring D 00000b08  2984  4791      1 0x00000000
 d4a4ce5c 00000086 6de4c7f3 00000b08 c1052065 f398e404 c1536980 00000000
 c1531ef0 c1536980 f398e404 c1536980 00000086 00000000 00000000 dc488780
 6dcdb331 00000b08 f398e150 f726e284 00000000 d4a4ce50 c105b0d0 f398e150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c338>] ? __lock_acquire+0xb58/0xb67
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c102ba48>] ? finish_task_switch+0x0/0xa1
 [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-session D 00000b08  2036  4705   4676 0x00000000
 f26e2e5c 00000086 6dd48244 00000b08 c1052065 dc66d934 c1536980 00000000
 c1531ef0 c1536980 dc66d934 c1536980 00000086 00000000 00000000 f3ea1900
 6dcdcd05 00000b08 dc66d680 f710b104 00000000 f26e2e50 c105b0d0 dc66d680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-session D 00000b08  2920  4786   4676 0x00000000
 d4a2ce5c 00000086 6de4fa21 00000b08 c1052065 dc6682b4 c1536980 00000000
 c1531ef0 c1536980 dc6682b4 c1536980 00000086 00000000 00000000 dc68e500
 6dce0608 00000b08 dc668000 f710b104 00000000 d4a2ce50 c105b0d0 dc668000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10bd749>] ? pipe_read+0x290/0x2db
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c10b6ca5>] ? fput_light+0xc/0xe
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
ssh-agent     D 00000b08  1964  4757   4705 0x00000000
 d4990e5c 00000086 6dd4d69b 00000b08 c1052065 e20d82b4 c1536980 00000000
 c1531ef0 c1536980 e20d82b4 c1536980 00000086 00000000 00000000 dc489b80
 6dcde902 00000b08 e20d8000 f710c184 00000000 d4990e50 c105b0d0 e20d8000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c116bad6>] ? copy_to_user+0x2b/0x57
 [<c10c29d7>] ? poll_select_copy_remaining+0xb1/0xcd
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
dbus-launch   D 00000b08  2156  4760      1 0x00000000
 d499de5c 00000086 6dd507cd 00000b08 c1052065 e20d8d84 c1536980 00000000
 c1531ef0 c1536980 e20d8d84 c1536980 00000086 00000000 00000000 dc68ef00
 6dce4211 00000b08 e20d8ad0 f710f304 00000000 d499de50 c105b0d0 e20d8ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10a125b>] ? spin_lock+0x8/0xa
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c116eb10>] ? do_raw_spin_unlock+0x8f/0x94
 [<c108f173>] ? unlock_page+0x4a/0x4d
 [<c10a3fbe>] ? __do_fault+0x312/0x342
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
dbus-daemon   D 00000b08  1948  4761      1 0x00000000
 f26e6e5c 00000086 6de74341 00000b08 c1052065 dd9d1854 c1536980 00000000
 c1531ef0 c1536980 dd9d1854 c1536980 00000086 00000000 00000000 dc488a00
 6dce26bc 00000b08 dd9d15a0 f726d784 00000000 f26e6e50 c105b0d0 dd9d15a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
seahorse-agen D 00000b08  2164  4771   4705 0x00000000
 d497be5c 00000086 6de7bc6e 00000b08 c1052065 e6f30d84 c1536980 00000000
 c1531ef0 c1536980 e6f30d84 c1536980 00000086 00000000 00000000 dc68f400
 6dce605a 00000b08 e6f30ad0 f710e284 00000000 d497be50 c105b0d0 e6f30ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfsd         D 00000b08  2164  4774      1 0x00000000
 d49c3e5c 00000086 6dd55454 00000b08 c1052065 dd9d2324 c1536980 00000000
 c1531ef0 c1536980 dd9d2324 c1536980 00000086 00000000 00000000 f64b8280
 6dce7c93 00000b08 dd9d2070 f726ed84 00000000 d49c3e50 c105b0d0 dd9d2070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c10b7ae6>] ? do_readv_writev+0xd2/0xdf
 [<c10578e2>] ? tick_program_event+0x33/0x3b
 [<c104e737>] ? hrtimer_interrupt+0x12e/0x1f8
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gconfd-2      D 00000b08  1868  4780      1 0x00000000
 d4a17e5c 00000086 6de966f0 00000b08 c1052065 f70d4e64 c1536980 00000000
 c1531ef0 c1536980 f70d4e64 c1536980 00000086 00000000 00000000 f64b8280
 6dce9962 00000b08 f70d4bb0 f710cc84 00000000 d4a17e50 c105b0d0 f70d4bb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfs-fuse-dae D 00000b08  2984  4781      1 0x00000000
 d49bde5c 00000086 6dd58dc3 00000b08 c1052065 dc66eed4 c1536980 00000000
 c1531ef0 c1536980 dc66eed4 c1536980 00000086 00000000 00000000 f64b8280
 6dceb7b8 00000b08 dc66ec20 f710d204 00000000 d49bde50 c105b0d0 dc66ec20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c116eb10>] ? do_raw_spin_unlock+0x8f/0x94
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c12f696d>] ? restore_all_notrace+0x0/0x18
 [<c1020347>] ? do_page_fault+0x0/0x2bb
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfs-fuse-dae D 00000b08  2200  4782      1 0x00000000
 d49a2e5c 00000086 6de99fd4 00000b08 c1052065 dc66b8c4 c1536980 00000000
 c1531ef0 c1536980 dc66b8c4 c1536980 00000086 00000000 00000000 f64b8280
 6dced32b 00000b08 dc66b610 f710d204 00000000 d49a2e50 c105b0d0 dc66b610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c10b6ca5>] ? fput_light+0xc/0xe
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfs-fuse-dae D 00000b08  2384  4783      1 0x00000000
 d49fde5c 00000086 6dd5c129 00000b08 c1052065 dc669854 c1536980 00000000
 c1531ef0 c1536980 dc669854 c1536980 00000086 00000000 00000000 f64b8780
 6dcf0e86 00000b08 dc6695a0 f710d204 00000000 d49fde50 c105b0d0 dc6695a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c10b6ca5>] ? fput_light+0xc/0xe
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfs-fuse-dae D 00000b08  2284  4784      1 0x00000000
 d4967e5c 00000086 6de9e131 00000b08 c1052065 dd9d38c4 c1536980 00000000
 c1531ef0 c1536980 dd9d38c4 c1536980 00000086 00000000 00000000 f64b8780
 6dcef241 00000b08 dd9d3610 f710d204 00000000 d4967e50 c105b0d0 dd9d3610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-setting D 00000b08  2036  4792      1 0x00000000
 d4a48e5c 00200086 6dea825d 00000b08 c1052065 f3fe4e64 c1536980 00000000
 c1531ef0 c1536980 f3fe4e64 c1536980 00200086 00000000 00000000 dc99e780
 6dcf5ca5 00000b08 f3fe4bb0 f653dd04 00000000 d4a48e50 c105b0d0 f3fe4bb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-setting D 00000b08  2920  4808      1 0x00000000
 d499ee5c 00000086 6dd5f3b8 00000b08 c1052065 dd9d6ed4 c1536980 00000000
 c1531ef0 c1536980 dd9d6ed4 c1536980 00000086 00000000 00000000 dc68e280
 6dcf30b4 00000b08 dd9d6c20 f653dd04 00000000 d499ee50 c105b0d0 dd9d6c20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10bd749>] ? pipe_read+0x290/0x2db
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c10b6ca5>] ? fput_light+0xc/0xe
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
seahorse-daem D 00000b08  2092  4793      1 0x00000000
 d4938e5c 00000086 6dd67d38 00000b08 c1052065 dd9d6404 c1536980 00000000
 c1531ef0 c1536980 dd9d6404 c1536980 00000086 00000000 00000000 f64b8000
 6dcfaf94 00000b08 dd9d6150 f726e804 00000000 d4938e50 c105b0d0 dd9d6150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
notify-osd    D 00000b08  2036  4817      1 0x00800004
 d49cdb34 00200086 6cd6b1bb 00000b08 c105c3ea e6f31854 c1536980 00000400
 c1531ef0 c1536980 e6f31854 c1536980 00000000 002d2173 c2e05ef0 00000000
 6cd5cce0 00000b08 e6f315a0 00000078 00000000 00000000 00000400 c2e0a980
Call Trace:
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c12f4959>] io_schedule+0x32/0x49
 [<c10d2822>] sync_buffer+0x33/0x37
 [<c12f4cdd>] __wait_on_bit+0x34/0x5b
 [<c10d27ef>] ? sync_buffer+0x0/0x37
 [<c12f4d5b>] out_of_line_wait_on_bit+0x57/0x5f
 [<c10d27ef>] ? sync_buffer+0x0/0x37
 [<c104b83f>] ? wake_bit_function+0x0/0x37
 [<c10d277e>] __wait_on_buffer+0x19/0x1c
 [<c10d27ab>] wait_on_buffer+0x2a/0x2d
 [<c10d2873>] bh_submit_read+0x3a/0x4a
 [<c1101102>] ext4_get_branch+0x6a/0xce
 [<c1102431>] ext4_ind_get_blocks+0x93/0x537
 [<c1025f06>] ? need_resched+0x14/0x1e
 [<c110290b>] ? ext4_get_blocks+0x36/0x35d
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c110290b>] ? ext4_get_blocks+0x36/0x35d
 [<c110293c>] ext4_get_blocks+0x67/0x35d
 [<c115769c>] ? submit_bio+0xb6/0xcf
 [<c1103b04>] ext4_get_block+0x8e/0xc1
 [<c10d88fa>] do_mpage_readpage+0x147/0x380
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c1095db3>] ? __lru_cache_add+0x76/0x8e
 [<c10d8c00>] mpage_readpages+0x7c/0xb2
 [<c1103a76>] ? ext4_get_block+0x0/0xc1
 [<c109532d>] ? rcu_read_lock+0x0/0x26
 [<c109532d>] ? rcu_read_lock+0x0/0x26
 [<c1101882>] ? ext4_readpages+0x0/0x16
 [<c1101896>] ext4_readpages+0x14/0x16
 [<c1103a76>] ? ext4_get_block+0x0/0xc1
 [<c1095470>] __do_page_cache_readahead+0xff/0x15d
 [<c10954e5>] ra_submit+0x17/0x1c
 [<c1095734>] ondemand_readahead+0x1a0/0x1ac
 [<c10957d1>] page_cache_sync_readahead+0x16/0x1b
 [<c10903c7>] generic_file_aio_read+0x1fd/0x4e6
 [<c10b701e>] do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] vfs_read+0x7d/0xdc
 [<c10b770f>] sys_read+0x3b/0x5d
 [<c10031e3>] sysenter_do_call+0x12/0x3c
metacity      D 00000b08  1980  4818   4705 0x00000000
 d4a5ee5c 00000086 6deae85e 00000b08 c1052065 e6f302b4 c1536980 00000000
 c1531ef0 c1536980 e6f302b4 c1536980 00000086 00000000 00000000 f3835180
 6db5bebd 00000b08 e6f30000 f6befe04 00000000 d4a5ee50 c105b0d0 e6f30000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
pulseaudio    D 00000b08  1812  4823      1 0x00000000
 d4a3fe5c 00000086 6debce33 00000b08 c1052065 e6f29854 c1536980 00000000
 c1531ef0 c1536980 e6f29854 c1536980 00000086 002d217c c2e05ef0 00000000
 6deaa266 00000b08 e6f295a0 f653e804 00000000 00000000 00000000 e6f295a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c116bad6>] ? copy_to_user+0x2b/0x57
 [<c10c29d7>] ? poll_select_copy_remaining+0xb1/0xcd
 [<c10c3b1b>] ? sys_ppoll+0xe1/0xf8
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
pulseaudio    D 00000b08  2008  4832      1 0x00000000
 d4a6ee5c 00000086 6dd6c33a 00000b08 c1052065 dc668d84 c1536980 00000000
 c1531ef0 c1536980 dc668d84 c1536980 00000086 00000000 00000000 dc99fb80
 6dcfcf4c 00000b08 dc668ad0 f653e804 00000000 d4a6ee50 c105b0d0 dc668ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c102ccba>] ? try_to_wake_up+0x32d/0x341
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105de04>] ? spin_unlock+0x8/0xa
 [<c105e46f>] ? futex_wake+0xc6/0xd0
 [<c105fa1c>] ? do_futex+0x99/0x690
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10b6d7a>] ? fsnotify_access+0x4f/0x5a
 [<c10c3b1b>] ? sys_ppoll+0xe1/0xf8
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
gconf-helper  D 00000b08  2284  4828   4823 0x00000000
 d4a53e5c 00000086 6dd74eef 00000b08 d4a53000 e6f2a324 c1536980 e6f2a070
 c1531ef0 c1536980 e6f2a324 c1536980 0000d4d3 00000000 e6f2a070 dc68e780
 6dd01313 00000b08 e6f2a070 f65300d8 000000e0 ffffff10 c12f6356 e6f2a070
Call Trace:
 [<c12f6356>] ? _raw_spin_unlock_irq+0x31/0x57
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c102ba48>] ? finish_task_switch+0x0/0xa1
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6370>] ? _raw_spin_unlock_irq+0x4b/0x57
 [<c102baa3>] ? finish_task_switch+0x5b/0xa1
 [<c102ba48>] ? finish_task_switch+0x0/0xa1
 [<c1025f06>] ? need_resched+0x14/0x1e
 [<c12f4909>] ? schedule+0x808/0x826
 [<c10b74aa>] ? vfs_write+0xa0/0xdf
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-panel   D 00000b08  2004  4836   4705 0x00000000
 d4a33e5c 00200086 6deaa266 00000b08 c1052065 e20dd934 c1536980 00001b45
 c1531ef0 c1536980 e20dd934 c1536980 c12ff364 002d218a c2e05ef0 f64b8000
 6deaa266 00000b08 e20dd680 00000078 00000000 00000000 00001b45 e20dd680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
syndaemon     D 00000b08  2036  4838      1 0x00000000
 d4abde5c 00000086 6dd78b10 00000b08 c1052065 dd9d4e64 c1536980 00000000
 c1531ef0 c1536980 dd9d4e64 c1536980 00000086 00000000 00000000 dc68fb80
 6dd032e3 00000b08 dd9d4bb0 f653e284 00000000 d4abde50 c105b0d0 dd9d4bb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c116fbb6>] ? free_object+0x12/0x81
 [<c116fbb6>] ? free_object+0x12/0x81
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c116fc12>] ? free_object+0x6e/0x81
 [<c116fe3c>] ? debug_object_free+0xc4/0xd6
 [<c104e072>] ? destroy_hrtimer_on_stack+0xd/0xf
 [<c104f153>] ? hrtimer_nanosleep+0xcb/0xe6
 [<c104e3bd>] ? hrtimer_wakeup+0x0/0x1c
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
nautilus      D 00000b08  1980  4839   4705 0x00000000
 d4ac4e5c 00200086 6dd841f6 00000b08 c1052065 f3fe6404 c1536980 00000000
 c1531ef0 c1536980 f3fe6404 c1536980 00200086 00000000 00000000 dc68f680
 6dd0947b 00000b08 f3fe6150 f6beab84 00000000 d4ac4e50 c105b0d0 f3fe6150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
bonobo-activa D 00000b08  2284  4841      1 0x00000000
 d4aabe5c 00200086 6de9bdcd 00000b08 c1052065 f3fe38c4 c1536980 00002145
 c1531ef0 c1536980 f3fe38c4 c1536980 c12ff364 002d218a c2e05ef0 dc99ec80
 6de9bdcd 00000b08 f3fe3610 00000078 00000000 00000000 00002145 f3fe3610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1017aa4>] ? apic_write+0xf/0x11
 [<c1017c5b>] ? lapic_next_event+0xf/0x13
 [<c10568c4>] ? clockevents_program_event+0xc6/0xd8
 [<c1057801>] ? tick_dev_program_event+0x2e/0xb4
 [<c10578e2>] ? tick_program_event+0x33/0x3b
 [<c104e737>] ? hrtimer_interrupt+0x12e/0x1f8
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
bonobo-activa D 00000b08  2284  4842      1 0x00000000
 d4ab4e5c 00200086 6de95237 00000b08 c1052065 f3fe1854 c1536980 00002745
 c1531ef0 c1536980 f3fe1854 c1536980 c12ff364 002d218a c2e05ef0 dc68ec80
 6de95237 00000b08 f3fe15a0 00000078 00000000 00000000 00002745 f3fe15a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105de04>] ? spin_unlock+0x8/0xa
 [<c105e46f>] ? futex_wake+0xc6/0xd0
 [<c105fa1c>] ? do_futex+0x99/0x690
 [<c10274bb>] ? task_rq_unlock+0xa/0xc
 [<c10307fe>] ? wake_up_new_task+0x97/0x9d
 [<c10b6d7a>] ? fsnotify_access+0x4f/0x5a
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gdu-notificat D 00000b08  2164  4845   4705 0x00000000
 d4ae6e5c 00000086 6dd89454 00000b08 c1052065 dd9d5934 c1536980 00000000
 c1531ef0 c1536980 dd9d5934 c1536980 00000086 00000000 00000000 f64f3180
 6dd0cd41 00000b08 dd9d5680 f653cc84 00000000 d4ae6e50 c105b0d0 dd9d5680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
polkit-gnome- D 00000b08  2036  4847   4705 0x00000000
 d4b1ce5c 00000086 6dd8f56e 00000b08 c1052065 f70d6404 c1536980 00000000
 c1531ef0 c1536980 f70d6404 c1536980 00000086 00000000 00000000 dc68f900
 6dd0ea40 00000b08 f70d6150 f653d784 00000000 d4b1ce50 c105b0d0 f70d6150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-power-m D 00000b08  2036  4848   4705 0x00000000
 d4b1fe5c 00200086 6dd9389f 00000b08 c1052065 e6f2e404 c1536980 00000000
 c1531ef0 c1536980 e6f2e404 c1536980 00200086 00000000 00000000 dc68f900
 6dd120d8 00000b08 e6f2e150 f6538a84 00000000 d4b1fe50 c105b0d0 e6f2e150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105a22b>] ? register_lock_class+0x17/0x2a2
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-power-m D 00000b08  2284  5866   4705 0x00000000
 d6299e5c 00200086 6dd97755 00000b08 c1052065 d4b6adf4 c1536980 00000000
 c1531ef0 c1536980 d4b6adf4 c1536980 00200086 00000000 00000000 f38b8500
 6dd14114 00000b08 d4b6ab40 f6538a84 00000000 d6299e50 c105b0d0 d4b6ab40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105c338>] ? __lock_acquire+0xb58/0xb67
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10b7e31>] ? rcu_read_lock+0x0/0x26
 [<c10b7e73>] ? rcu_read_unlock+0x1c/0x1e
 [<c10b7efe>] ? fget_light+0x89/0x93
 [<c1287ce4>] ? fput_light+0xc/0xe
 [<c1287f35>] ? sys_recvmsg+0x39/0x43
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
update-notifi D 00000b08  2036  4849   4705 0x00000000
 d4b1ee5c 00200086 6dd9fb3a 00000b08 c1052065 f3fe6ed4 c1536980 00000000
 c1531ef0 c1536980 f3fe6ed4 c1536980 00200086 00000000 00000000 f38b8c80
 6dd15b5b 00000b08 f3fe6c20 f6bed204 00000000 d4b1ee50 c105b0d0 f3fe6c20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
gnome-volume- D 00000b08  2036  4850   4705 0x00000000
 d4b2ae5c 00200086 6dda47fd 00000b08 c1052065 d4b602b4 c1536980 00000000
 c1531ef0 c1536980 d4b602b4 c1536980 00200086 00000000 00000000 f3834c80
 6dd1b054 00000b08 d4b60000 f6beb104 00000000 d4b2ae50 c105b0d0 d4b60000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
python        D 00000b08  2092  4854   4705 0x00000000
 d4ad1e5c 00200086 6de8b321 00000b08 c1052065 d4b60d84 c1536980 00002945
 c1531ef0 c1536980 d4b60d84 c1536980 c12ff364 002d218a c2e05ef0 dc68ec80
 6de8b321 00000b08 d4b60ad0 00000078 00000000 00000000 00002945 d4b60ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
nm-applet     D 00000b08  2036  4856   4705 0x00000000
 d4acfe5c 00000086 6de843e7 00000b08 c1052065 d4b68d84 c1536980 00002b45
 c1531ef0 c1536980 d4b68d84 c1536980 c12ff364 002d218a c2e05ef0 d4556c80
 6de843e7 00000b08 d4b68ad0 00000078 00000000 00000000 00002b45 d4b68ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105a22b>] ? register_lock_class+0x17/0x2a2
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
bluetooth-app D 00000b08  2092  4862   4705 0x00000000
 d4b02e5c 00000086 6ddab5d4 00000b08 c1052065 d4b6b8c4 c1536980 00000000
 c1531ef0 c1536980 d4b6b8c4 c1536980 00000086 00000000 00000000 dc99e000
 6dd1e94a 00000b08 d4b6b610 f38e5d04 00000000 d4b02e50 c105b0d0 d4b6b610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
evolution-ala D 00000b08  2092  4869   4705 0x00000000
 d4b8ae5c 00000086 6de7e07a 00000b08 c1052065 d4bd02b4 c1536980 00002f45
 c1531ef0 c1536980 d4bd02b4 c1536980 c12ff364 002d218a c2e05ef0 f3834780
 6de7e07a 00000b08 d4bd0000 00000078 00000000 00000000 00002f45 d4bd0000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
evolution-ala D 00000b08  2284  4974   4705 0x00000000
 d46f6e5c 00000086 6ddb1e28 00000b08 c1052065 dd9d2df4 c1536980 00000000
 c1531ef0 c1536980 dd9d2df4 c1536980 00000086 00000000 00000000 f64b8c80
 6dd20c99 00000b08 dd9d2b40 f38e7e04 00000000 d46f6e50 c105b0d0 dd9d2b40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c116eb10>] ? do_raw_spin_unlock+0x8f/0x94
 [<c12f6298>] ? _raw_spin_unlock+0x33/0x3f
 [<c105de04>] ? spin_unlock+0x8/0xa
 [<c105de1f>] ? double_unlock_hb+0x19/0x1d
 [<c105ff5f>] ? do_futex+0x5dc/0x690
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
trashapplet   D 00000b08  2092  4878      1 0x00000000
 d4bb0e5c 00000086 6ddba6a6 00000b08 c1052065 d4bd38c4 c1536980 00000000
 c1531ef0 c1536980 d4bd38c4 c1536980 00000086 00000000 00000000 f3835900
 6dd24848 00000b08 d4bd3610 f38e3104 00000000 d4bb0e50 c105b0d0 d4bd3610
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfs-gdu-volu D 00000b08  2036  4881      1 0x00000000
 d4b51e5c 00000086 6de72d01 00000b08 c1052065 d4b61854 c1536980 00003345
 c1531ef0 c1536980 d4b61854 c1536980 c12ff364 002d218a c2e05ef0 dc99e000
 6de72d01 00000b08 d4b615a0 00000078 00000000 00000000 00003345 d4b615a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104b927>] ? finish_wait+0x44/0x49
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfsd-trash   D 00000b08  2036  4884      1 0x00000000
 d4be7e5c 00000086 6ddc11e3 00000b08 c1052065 d4b62324 c1536980 00000000
 c1531ef0 c1536980 d4b62324 c1536980 00000086 00000000 00000000 f3834a00
 6dd27baf 00000b08 d4b62070 f6bea604 00000000 d4be7e50 c105b0d0 d4b62070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104b927>] ? finish_wait+0x44/0x49
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfs-gphoto2- D 00000b08  2284  4889      1 0x00000000
 d4419e5c 00000086 6ddc4db0 00000b08 c1052065 d4b65934 c1536980 00000000
 c1531ef0 c1536980 d4b65934 c1536980 00000086 00000000 00000000 dc99f680
 6dd2bbd9 00000b08 d4b65680 f6be9b04 00000000 d4419e50 c105b0d0 d4b65680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c1003764>] ? conditional_sti+0xe/0x23
 [<c1003d3b>] ? do_device_not_available+0x0/0x53
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-screens D 00000b08  2036  4893      1 0x00000000
 d4ae4e5c 00000086 6de6aa31 00000b08 c1052065 d4bd1854 c1536980 00003545
 c1531ef0 c1536980 d4bd1854 c1536980 c12ff364 002d218a c2e05ef0 f38b8000
 6de6aa31 00000b08 d4bd15a0 00000078 00000000 00000000 00003545 d4bd15a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfsd-burn    D 00000b08  2284  4907      1 0x00000000
 d443ce5c 00000086 6ddc9340 00000b08 c1052065 d4bd2df4 c1536980 00000000
 c1531ef0 c1536980 d4bd2df4 c1536980 00000086 00000000 00000000 d4556000
 6dd2e18c 00000b08 d4bd2b40 f388e804 00000000 d443ce50 c105b0d0 d4bd2b40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c116eb10>] ? do_raw_spin_unlock+0x8f/0x94
 [<c108f173>] ? unlock_page+0x4a/0x4d
 [<c10a3fbe>] ? __do_fault+0x312/0x342
 [<c104f359>] ? up_read+0x16/0x29
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gvfsd-metadat D 00000b08  2048  5014      1 0x00000000
 d0016e5c 00000086 6ddcc7cd 00000b08 c1052065 d4b66404 c1536980 00000000
 c1531ef0 c1536980 d4b66404 c1536980 00000086 00000000 00000000 dc99f180
 6dd30e91 00000b08 d4b66150 f6be8504 00000000 d0016e50 c105b0d0 d4b66150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10a125b>] ? spin_lock+0x8/0xa
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c116eb10>] ? do_raw_spin_unlock+0x8f/0x94
 [<c108f173>] ? unlock_page+0x4a/0x4d
 [<c10a3fbe>] ? __do_fault+0x312/0x342
 [<c104f359>] ? up_read+0x16/0x29
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
system-tools- D 00000b08  2036  5580      1 0x00000000
 da791e5c 00000086 6ddd1394 00000b08 c1052065 db692324 c1536980 00000000
 c1531ef0 c1536980 db692324 c1536980 00000086 00000000 00000000 d4557680
 6dd371aa 00000b08 db692070 f388fe04 00000000 da791e50 c105b0d0 db692070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c104b927>] ? finish_wait+0x44/0x49
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
SystemToolsBa D 00000b08  2156  5582      1 0x00000000
 da7cae5c 00000086 6de61844 00000b08 c1052065 db692df4 c1536980 00003745
 c1531ef0 c1536980 db692df4 c1536980 c12ff364 002d218a c2e05ef0 f64f3400
 6de61844 00000b08 db692b40 00000078 00000000 00000000 00003745 db692b40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105a22b>] ? register_lock_class+0x17/0x2a2
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10c3660>] ? sys_select+0x7a/0x84
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-vfs-dae D 00000b08  2048  5721      1 0x00000000
 eae68e5c 00000086 6de5b94d 00000b08 c1052065 db694e64 c1536980 00003945
 c1531ef0 c1536980 db694e64 c1536980 c12ff364 002d218a c2e05ef0 dc488500
 6de5b94d 00000b08 db694bb0 00000078 00000000 00000000 00003945 db694bb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c104e737>] ? hrtimer_interrupt+0x12e/0x1f8
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
firefox       D 00000b08  1980  5736      1 0x00000000
 e041ee5c 00200086 6dddadda 00000b08 c1052065 c815eed4 c1536980 00000000
 c1531ef0 c1536980 c815eed4 c1536980 00200086 00000000 00000000 d4557680
 6dd3cbc7 00000b08 c815ec20 f6beed84 00000000 e041ee50 c105b0d0 c815ec20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2716  5739      1 0x00000000
 ebd5ce5c 00000086 6de520c2 00000b08 c1052065 c8158d84 c1536980 00003b45
 c1531ef0 c1536980 c8158d84 c1536980 c12ff364 002d218a c2e05ef0 f64b9680
 6de520c2 00000b08 c8158ad0 00000078 00000000 00000000 00003b45 c8158ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c1053a28>] ? ktime_get+0x58/0x95
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c116bad6>] ? copy_to_user+0x2b/0x57
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2012  5740      1 0x00000000
 ebd5de5c 00000086 6de4b3f3 00000b08 c1052065 c8159854 c1536980 00004145
 c1531ef0 c1536980 c8159854 c1536980 c12ff364 002d218a c2e05ef0 d4557680
 6de4b3f3 00000b08 c81595a0 00000078 00000000 00000000 00004145 c81595a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105a22b>] ? register_lock_class+0x17/0x2a2
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105de04>] ? spin_unlock+0x8/0xa
 [<c105fa1c>] ? do_futex+0x99/0x690
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c10a100f>] ? might_fault+0x83/0x88
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2716  5741      1 0x00000000
 ddffde5c 00000086 6dddf0db 00000b08 c1052065 db696404 c1536980 00000000
 c1531ef0 c1536980 db696404 c1536980 00000086 00000000 00000000 d4557680
 6dd42b49 00000b08 db696150 f6beed84 00000000 ddffde50 c105b0d0 db696150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c1053a28>] ? ktime_get+0x58/0x95
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2984  5753      1 0x00000000
 e0559e5c 00200086 6de456d6 00000b08 c1052065 c815a324 c1536980 00004545
 c1531ef0 c1536980 c815a324 c1536980 c12ff364 002d218a c2e05ef0 d4557680
 6de456d6 00000b08 c815a070 00000078 00000000 00000000 00004545 c815a070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c116eb10>] ? do_raw_spin_unlock+0x8f/0x94
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c12f696d>] ? restore_all_notrace+0x0/0x18
 [<c1020347>] ? do_page_fault+0x0/0x2bb
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2984  5754      1 0x00000000
 e5c73e5c 00200086 6de40bb7 00000b08 c1052065 c815c394 c1536980 00004945
 c1531ef0 c1536980 c815c394 c1536980 c12ff364 002d218a c2e05ef0 d4557680
 6de40bb7 00000b08 c815c0e0 00000078 00000000 00000000 00004945 c815c0e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c338>] ? __lock_acquire+0xb58/0xb67
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c102ba48>] ? finish_task_switch+0x0/0xa1
 [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2020  5755      1 0x00000000
 e0567e5c 00200086 6dde1616 00000b08 c1052065 c815adf4 c1536980 00000000
 c1531ef0 c1536980 c815adf4 c1536980 00200086 00000000 00000000 d4557680
 6dd4495c 00000b08 c815ab40 f6beed84 00000000 e0567e50 c105b0d0 c815ab40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b0c22>] ? check_valid_pointer+0x1c/0x48
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c10e0bbb>] ? locks_free_lock+0x3d/0x40
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10e0bbb>] ? locks_free_lock+0x3d/0x40
 [<c10e1cb2>] ? fcntl_setlk64+0x15b/0x165
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2708  5764      1 0x00000000
 e05a3e5c 00200086 6dde4376 00000b08 c1052065 c815e404 c1536980 00000000
 c1531ef0 c1536980 c815e404 c1536980 00200086 00000000 00000000 d4557680
 6dd4bf82 00000b08 c815e150 f6beed84 00000000 e05a3e50 c105b0d0 c815e150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c1017c5b>] ? lapic_next_event+0xf/0x13
 [<c10568c4>] ? clockevents_program_event+0xc6/0xd8
 [<c10578e2>] ? tick_program_event+0x33/0x3b
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c12f696d>] ? restore_all_notrace+0x0/0x18
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f007b>] ? init_centaur+0xaf/0x3da
firefox       D 00000b08  2864  5765      1 0x00000000
 e05a7e5c 00200086 6de3b435 00000b08 c1052065 d4b62df4 c1536980 0000628b
 c1531ef0 c1536980 d4b62df4 c1536980 c12ff364 002d218a c2e05ef0 d4557680
 6de3b435 00000b08 d4b62b40 00000078 00000000 00000000 0000628b d4b62b40
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c338>] ? __lock_acquire+0xb58/0xb67
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c102ba48>] ? finish_task_switch+0x0/0xa1
 [<c12f6347>] ? _raw_spin_unlock_irq+0x22/0x57
 [<c105b09d>] ? trace_hardirqs_on_caller+0x119/0x141
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2016  5777      1 0x00000000
 ec759e5c 00200086 6de36718 00000b08 c1052065 d4bd6ed4 c1536980 0000648b
 c1531ef0 c1536980 d4bd6ed4 c1536980 c12ff364 002d218a c2e05ef0 d4557680
 6de36718 00000b08 d4bd6c20 00000078 00000000 00000000 0000648b d4bd6c20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105a22b>] ? register_lock_class+0x17/0x2a2
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2016  5778      1 0x00000000
 ee53fe5c 00200086 6de2f3d5 00000b08 c1052065 d4b6a324 c1536980 0000688b
 c1531ef0 c1536980 d4b6a324 c1536980 c12ff364 002d218a c2e05ef0 d4557680
 6de2f3d5 00000b08 d4b6a070 00000078 00000000 00000000 0000688b d4b6a070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10bd749>] ? pipe_read+0x290/0x2db
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f007b>] ? init_centaur+0xaf/0x3da
firefox       D 00000b08  2428  5796      1 0x00000000
 d68f3e5c 00200086 6dde6a73 00000b08 c1052065 d4b6ce64 c1536980 00000000
 c1531ef0 c1536980 d4b6ce64 c1536980 00200086 00000000 00000000 f3835400
 6dd53cb7 00000b08 d4b6cbb0 f6beed84 00000000 d68f3e50 c105b0d0 d4b6cbb0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c10b6dd4>] ? fsnotify_modify+0x4f/0x5a
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2144  5813      1 0x00000000
 d62b8e5c 00200086 6de29dfe 00000b08 c1052065 d4b6eed4 c1536980 00006c8b
 c1531ef0 c1536980 d4b6eed4 c1536980 c12ff364 002d218a c2e05ef0 d4557680
 6de29dfe 00000b08 d4b6ec20 00000078 00000000 00000000 00006c8b d4b6ec20
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c1053a28>] ? ktime_get+0x58/0x95
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2144  5816      1 0x00000000
 d5ce8e5c 00200086 6de23a7f 00000b08 c1052065 d4bd6404 c1536980 0000708c
 c1531ef0 c1536980 d4bd6404 c1536980 c12ff364 002d218a c2e05ef0 d4557680
 6de23a7f 00000b08 d4bd6150 00000078 00000000 00000000 0000708c d4bd6150
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c1053a28>] ? ktime_get+0x58/0x95
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
firefox       D 00000b08  2144  5818      1 0x00000000
 d6090e5c 00200086 6de1c826 00000b08 c1052065 d4b682b4 c1536980 0000768b
 c1531ef0 c1536980 d4b682b4 c1536980 c12ff364 002d218a c2e05ef0 d4557680
 6de1c826 00000b08 d4b68000 00000078 00000000 00000000 0000768b d4b68000
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105f9fa>] ? do_futex+0x77/0x690
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c1053a28>] ? ktime_get+0x58/0x95
 [<c10600f4>] ? sys_futex+0xe1/0xf5
 [<c100321c>] ? sysenter_exit+0xf/0x1f
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
 [<c12f0000>] ? init_centaur+0x34/0x3da
gnome-termina D 00000b08  2092  5843      1 0x00000000
 d3b4ce5c 00000086 6ddf41e9 00000b08 c1052065 d4bd0d84 c1536980 00000000
 c1531ef0 c1536980 d4bd0d84 c1536980 00000086 00000000 00000000 f38b9180
 6dd57a7c 00000b08 d4bd0ad0 f6539b04 00000000 d3b4ce50 c105b0d0 d4bd0ad0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-termina D 00000b08  3020  5846      1 0x00000000
 d3b1ae5c 00000086 6de15cf0 00000b08 c1052065 d4bd2324 c1536980 00007a8b
 c1531ef0 c1536980 d4bd2324 c1536980 c12ff364 002d218a c2e05ef0 d4557680
 6de15cf0 00000b08 d4bd2070 00000078 00000000 00000000 00007a8b d4bd2070
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c10bd749>] ? pipe_read+0x290/0x2db
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b6f97>] ? do_sync_read+0x0/0xc2
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c10b6ca5>] ? fput_light+0xc/0xe
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
gnome-pty-hel D 00000b08  2440  5844   5843 0x00000000
 f2a3ae5c 00000086 6ddf7cd2 00000b08 c1052065 d4bd4394 c1536980 00000000
 c1531ef0 c1536980 d4bd4394 c1536980 00000086 00000000 00000000 d4556a00
 6dd5a90e 00000b08 d4bd40e0 f653d204 00000000 f2a3ae50 c105b0d0 d4bd40e0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c10b701e>] ? do_sync_read+0x87/0xc2
 [<c10b582c>] ? sys_close+0x25/0xa0
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c1147456>] ? security_file_permission+0xf/0x11
 [<c10b70f1>] ? rw_verify_area+0x98/0xbb
 [<c10b762a>] ? vfs_read+0x8b/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
bash          D 00000b08  2236  5845   5843 0x00000000
 d3b19e5c 00000086 6ddfc472 00000b08 c1052065 d4bd5934 c1536980 00000000
 c1531ef0 c1536980 d4bd5934 c1536980 00000086 00000000 00000000 f3835180
 6dbed073 00000b08 d4bd5680 f653c184 00000000 d3b19e50 c105b0d0 d4bd5680
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c104b87e>] ? spin_unlock_irqrestore+0x8/0xa
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c116eb75>] ? do_raw_spin_lock+0x60/0x122
 [<c105b0d0>] ? trace_hardirqs_on+0xb/0xd
 [<c11c4c53>] ? tty_ldisc_deref+0x8/0xa
 [<c11beae6>] ? tty_read+0x72/0x9e
 [<c11c24d0>] ? n_tty_read+0x0/0x5e0
 [<c11bea74>] ? tty_read+0x0/0x9e
 [<c10b761c>] ? vfs_read+0x7d/0xdc
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
pm-suspend    R running   2088  5868   3959 0x00000008
 00000001 5d303536 d52a0020 c1035115 00000001 0000000d 00000286 00000034
 00000000 00000004 00000286 4a744ba2 f3898ad0 0000000d d52a8e23 d52a8e34
 c12f3ea1 c1019142 f3898ad0 d52a8e58 c10054a0 c13de766 c13de766 00000000
Call Trace:
 [<c100632c>] show_trace_log_lvl+0x34/0x3e
 [<c10054c7>] show_stack_log_lvl+0x8f/0x9a
 [<c10062f4>] show_stack+0x13/0x17
 [<c102b67f>] sched_show_task+0x9b/0xa5
 [<c102b6c5>] show_state_filter+0x3c/0x82
 [<c1066bba>] try_to_freeze_tasks+0x165/0x228
 [<c1066c95>] freeze_processes+0x18/0x8f
 [<c1066fe0>] enter_state+0x90/0x114
 [<c106687d>] state_store+0x93/0xa7
 [<c10667ea>] ? state_store+0x0/0xa7
 [<c1165c71>] kobj_attr_store+0x16/0x22
 [<c10f6b6f>] sysfs_write_file+0xc0/0xeb
 [<c10f6aaf>] ? sysfs_write_file+0x0/0xeb
 [<c10b748a>] vfs_write+0x80/0xdf
 [<c10b757d>] sys_write+0x3b/0x5d
 [<c10031e3>] sysenter_do_call+0x12/0x3c
nm-dispatcher D 00000b08  2164  5986      1 0x00000000
 d662ee5c 00000086 6de1055c 00000b08 c1052065 db691854 c1536980 00007e8b
 c1531ef0 c1536980 db691854 c1536980 c12ff364 002d218a c2e05ef0 f3835400
 6de1055c 00000b08 db6915a0 00000078 00000000 00000000 00007e8b db6915a0
Call Trace:
 [<c1052065>] ? refrigerator+0x64/0xbb
 [<c10520a9>] refrigerator+0xa8/0xbb
 [<c1042aa8>] try_to_freeze+0x23/0x2a
 [<c1044426>] get_signal_to_deliver+0x4c/0x37f
 [<c105a22b>] ? register_lock_class+0x17/0x2a2
 [<c1002649>] do_signal+0x5a/0x6cb
 [<c105c597>] ? lock_release_non_nested+0x86/0x1d8
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c105c3ea>] ? lock_acquire+0xa3/0xcd
 [<c10a0fda>] ? might_fault+0x4e/0x88
 [<c1052e19>] ? timekeeping_get_ns+0x11/0x49
 [<c10539c6>] ? ktime_get_ts+0x89/0x93
 [<c1002cdd>] do_notify_resume+0x23/0x62
 [<c12f6a3c>] work_notifysig+0x13/0x1b
flush-8:1-fus S 00000b0d  3228  6032      2 0x00000000
 d2d2ff14 00000086 0f97f624 00000b0d d2d2fed8 c815d934 c1536980 c158cdc0
 c1531ef0 c1536980 c815d934 c1536980 c12f6318 002d34b1 c2c05ef0 00000000
 0f97b582 00000b0d c815d680 00000000 00000000 00000000 00000000 d2d2ff20
Call Trace:
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c12f4b60>] schedule_timeout+0x85/0xba
 [<c103eda1>] ? process_timeout+0x0/0xa
 [<c12f4bd8>] schedule_timeout_interruptible+0x15/0x17
 [<c10ce1dd>] bdi_writeback_task+0x65/0x84
 [<c109f684>] ? bdi_start_fn+0x0/0xa4
 [<c109f6d2>] bdi_start_fn+0x4e/0xa4
 [<c109f684>] ? bdi_start_fn+0x0/0xa4
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
flush-8:16    S 00000b0d  3228  6033      2 0x00000000
 d3becf14 00000086 145ca765 00000b0d d3beced8 c815b8c4 c1536980 c158cdc0
 c1531ef0 c1536980 c815b8c4 c1536980 c12f6318 002d34b1 c2c05ef0 00000000
 145c6699 00000b0d c815b610 00000000 00000000 00000000 00000000 d3becf20
Call Trace:
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c12f4b60>] schedule_timeout+0x85/0xba
 [<c103eda1>] ? process_timeout+0x0/0xa
 [<c12f4bd8>] schedule_timeout_interruptible+0x15/0x17
 [<c10ce1dd>] bdi_writeback_task+0x65/0x84
 [<c109f684>] ? bdi_start_fn+0x0/0xa4
 [<c109f6d2>] bdi_start_fn+0x4e/0xa4
 [<c109f684>] ? bdi_start_fn+0x0/0xa4
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
flush-0:20    S 00000b0d  3228  6034      2 0x00000000
 d3bebf14 00000086 1513bf5b 00000b0d d3bebed8 c81582b4 c1536980 c158cdc0
 c1531ef0 c1536980 c81582b4 c1536980 c12f6318 002d3511 c2c05ef0 00000000
 15137d56 00000b0d c8158000 00000000 00000000 00000000 00000000 d3bebf20
Call Trace:
 [<c12f6318>] ? _raw_spin_unlock_irqrestore+0x74/0x81
 [<c12f4b60>] schedule_timeout+0x85/0xba
 [<c103eda1>] ? process_timeout+0x0/0xa
 [<c12f4bd8>] schedule_timeout_interruptible+0x15/0x17
 [<c10ce1dd>] bdi_writeback_task+0x65/0x84
 [<c109f684>] ? bdi_start_fn+0x0/0xa4
 [<c109f6d2>] bdi_start_fn+0x4e/0xa4
 [<c109f684>] ? bdi_start_fn+0x0/0xa4
 [<c104b4aa>] kthread+0x6a/0x6f
 [<c104b440>] ? kthread+0x0/0x6f
 [<c1003742>] kernel_thread_helper+0x6/0x1a
INFO: lockdep is turned off.
