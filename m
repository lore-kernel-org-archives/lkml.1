Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbYHNLRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbYHNLRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 07:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYHNLQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 07:16:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55271 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbYHNLQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 07:16:51 -0400
Date: Thu, 14 Aug 2008 13:16:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org,
       menage@google.com, a.p.zijlstra@chello.nl, vegard.nossum@gmail.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
	(take 4)
Message-ID: <20080814111633.GA2614@elte.hu>
References: <1218490433-10576-1-git-send-email-maxk@qualcomm.com> <20080811183122.acd25489.pj@sgi.com> <20080814092424.GB18771@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814092424.GB18771@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Paul Jackson <pj@sgi.com> wrote:
> 
> >   Acked-by: Paul Jackson <pj@sgi.com>
> > 
> > ... based on code reading and comparing with the
> > previous version - looks good.  Nice work, Max.
> > Thanks.
> 
> applied to tip/sched/cpuset, thanks. (will show up in tip/sched/urgent 
> as well soon, for v2.6.27 merging.)

FYI, this new lockdep warning showed up in -tip testing, after i added 
this patch.

	Ingo

[   59.750200] =======================================================
[   59.750200] [ INFO: possible circular locking dependency detected ]
[   59.750200] 2.6.27-rc3-tip-00076-g75f9a29-dirty #1
[   59.750200] -------------------------------------------------------
[   59.750200] Xorg/6623 is trying to acquire lock:
[   59.750200]  (cpu_add_remove_lock){--..}, at: [<c0147dae>] cpu_maps_update_begin+0x14/0x16
[   59.750200] 
[   59.750200] but task is already holding lock:
[   59.750200]  (polldev_mutex){--..}, at: [<c07eb66f>] input_close_polled_device+0x22/0x47
[   59.750200] 
[   59.750200] which lock already depends on the new lock.
[   59.750200] 
[   59.750200] 
[   59.750200] the existing dependency chain (in reverse order) is:
[   59.750200] 
[   59.750200] -> #5 (polldev_mutex){--..}:
[   59.750200]        [<c01632e3>] __lock_acquire+0x848/0x9ab
[   59.750200]        [<c01634b6>] lock_acquire+0x70/0x97
[   59.750200]        [<c09eaf41>] __mutex_lock_common+0x8a/0x278
[   59.750200]        [<c09eb15d>] mutex_lock_interruptible_nested+0x2e/0x35
[   59.750200]        [<c07eb745>] input_open_polled_device+0x1c/0xa3
[   59.750200]        [<c07e8f84>] input_open_device+0x5a/0x86
[   59.750200]        [<c07eded0>] evdev_open+0x103/0x14e
[   59.750200]        [<c07ea620>] input_open_file+0x44/0x60
[   59.750200]        [<c019ff1c>] chrdev_open+0x106/0x11d
[   59.750200]        [<c019c269>] __dentry_open+0x119/0x1f0
[   59.750200]        [<c019c364>] nameidata_to_filp+0x24/0x38
[   59.750200]        [<c01a6952>] do_filp_open+0x309/0x5b2
[   59.750200]        [<c019c04e>] do_sys_open+0x47/0xc1
[   59.750200]        [<c019c114>] sys_open+0x23/0x2b
[   59.750200]        [<c011bb2f>] sysenter_do_call+0x12/0x43
[   59.750200]        [<ffffffff>] 0xffffffff
[   59.750200] 
[   59.750200] -> #4 (&dev->mutex){--..}:
[   59.750200]        [<c01632e3>] __lock_acquire+0x848/0x9ab
[   59.750200]        [<c01634b6>] lock_acquire+0x70/0x97
[   59.750200]        [<c09eaf41>] __mutex_lock_common+0x8a/0x278
[   59.750200]        [<c09eb15d>] mutex_lock_interruptible_nested+0x2e/0x35
[   59.750200]        [<c07ea402>] input_register_handle+0x26/0x80
[   59.750200]        [<c0424336>] kbd_connect+0x6c/0x95
[   59.750200]        [<c07e8a46>] input_attach_handler+0x38/0x6b
[   59.750200]        [<c07ea4d7>] input_register_handler+0x7b/0xaf
[   59.750200]        [<c0f63917>] kbd_init+0x6b/0x87
[   59.750200]        [<c0f63a40>] vty_init+0xd3/0xdc
[   59.750200]        [<c0f63405>] tty_init+0x198/0x19c
[   59.750200]        [<c0101139>] do_one_initcall+0x42/0x133
[   59.750200]        [<c0f3f610>] kernel_init+0x17b/0x1e2
[   59.750200]        [<c011c85f>] kernel_thread_helper+0x7/0x10
[   59.750200]        [<ffffffff>] 0xffffffff
[   59.750200] 
[   59.750200] -> #3 (input_mutex){--..}:
[   59.750200]        [<c01632e3>] __lock_acquire+0x848/0x9ab
[   59.750200]        [<c01634b6>] lock_acquire+0x70/0x97
[   59.750200]        [<c09eaf41>] __mutex_lock_common+0x8a/0x278
[   59.750200]        [<c09eb15d>] mutex_lock_interruptible_nested+0x2e/0x35
[   59.750200]        [<c07ea2da>] input_register_device+0xff/0x171
[   59.750200]        [<c04080cd>] acpi_button_add+0x320/0x421
[   59.750200]        [<c040634f>] acpi_device_probe+0x3f/0x8d
[   59.750200]        [<c048e8fa>] driver_probe_device+0xc3/0x156
[   59.750200]        [<c048e9cf>] __driver_attach+0x42/0x64
[   59.750200]        [<c048e22f>] bus_for_each_dev+0x43/0x65
[   59.750200]        [<c048e713>] driver_attach+0x19/0x1b
[   59.750200]        [<c048dc2d>] bus_add_driver+0xaf/0x1b5
[   59.750200]        [<c048eb72>] driver_register+0x76/0xd2
[   59.750200]        [<c040665e>] acpi_bus_register_driver+0x3f/0x41
[   59.750200]        [<c0f61672>] acpi_button_init+0x37/0x56
[   59.750200]        [<c0101139>] do_one_initcall+0x42/0x133
[   59.750200]        [<c0f3f230>] do_async_initcalls+0x1f/0x2f
[   59.750200]        [<c015475f>] run_workqueue+0xb7/0x189
[   59.750200]        [<c01551ab>] worker_thread+0xbb/0xc7
[   59.750200]        [<c015764d>] kthread+0x40/0x67
[   59.750200]        [<c011c85f>] kernel_thread_helper+0x7/0x10
[   59.750200]        [<ffffffff>] 0xffffffff
[   59.750200] 
[   59.750200] -> #2 (async_work){--..}:
[   59.750200]        [<c01632e3>] __lock_acquire+0x848/0x9ab
[   59.750200]        [<c01634b6>] lock_acquire+0x70/0x97
[   59.750200]        [<c015475a>] run_workqueue+0xb2/0x189
[   59.750200]        [<c01551ab>] worker_thread+0xbb/0xc7
[   59.750200]        [<c015764d>] kthread+0x40/0x67
[   59.750200]        [<c011c85f>] kernel_thread_helper+0x7/0x10
[   59.750200]        [<ffffffff>] 0xffffffff
[   59.750200] 
[   59.750200] -> #1 (kasyncinit){--..}:
[   59.750200]        [<c01632e3>] __lock_acquire+0x848/0x9ab
[   59.750200]        [<c01634b6>] lock_acquire+0x70/0x97
[   59.750200]        [<c015499a>] cleanup_workqueue_thread+0x2b/0x5e
[   59.750200]        [<c0154a40>] destroy_workqueue+0x61/0x89
[   59.750200]        [<c0f3f634>] kernel_init+0x19f/0x1e2
[   59.750200]        [<c011c85f>] kernel_thread_helper+0x7/0x10
[   59.750200]        [<ffffffff>] 0xffffffff
[   59.750200] 
[   59.750200] -> #0 (cpu_add_remove_lock){--..}:
[   59.750200]        [<c01631b4>] __lock_acquire+0x719/0x9ab
[   59.750200]        [<c01634b6>] lock_acquire+0x70/0x97
[   59.750200]        [<c09eaf41>] __mutex_lock_common+0x8a/0x278
[   59.750200]        [<c09eb1c7>] mutex_lock_nested+0x2e/0x36
[   59.750200]        [<c0147dae>] cpu_maps_update_begin+0x14/0x16
[   59.750200]        [<c0154a05>] destroy_workqueue+0x26/0x89
[   59.750200]        [<c07eb688>] input_close_polled_device+0x3b/0x47
[   59.750200]        [<c07e9056>] input_close_device+0x45/0x61
[   59.750200]        [<c07edd49>] evdev_release+0x7f/0x99
[   59.750200]        [<c019e7d9>] __fput+0xb3/0x135
[   59.750200]        [<c019eb5f>] fput+0x1c/0x21
[   59.750200]        [<c019bffd>] filp_close+0x4c/0x56
[   59.750200]        [<c019d1d6>] sys_close+0x6d/0xa6
[   59.750200]        [<c011bb2f>] sysenter_do_call+0x12/0x43
[   59.750200]        [<ffffffff>] 0xffffffff
[   59.750200] 
[   59.750200] other info that might help us debug this:
[   59.750200] 
[   59.750200] 3 locks held by Xorg/6623:
[   59.750200]  #0:  (&evdev->mutex){--..}, at: [<c07edd31>] evdev_release+0x67/0x99
[   59.750200]  #1:  (&dev->mutex){--..}, at: [<c07e9030>] input_close_device+0x1f/0x61
[   59.750200]  #2:  (polldev_mutex){--..}, at: [<c07eb66f>] input_close_polled_device+0x22/0x47
[   59.750200] 
[   59.750200] stack backtrace:
[   59.750200] Pid: 6623, comm: Xorg Not tainted 2.6.27-rc3-tip-00076-g75f9a29-dirty #1
[   59.750200]  [<c016189b>] print_circular_bug_tail+0x5d/0x68
[   59.750200]  [<c01631b4>] __lock_acquire+0x719/0x9ab
[   59.750200]  [<c01634b6>] lock_acquire+0x70/0x97
[   59.750200]  [<c0147dae>] ? cpu_maps_update_begin+0x14/0x16
[   59.750200]  [<c09eaf41>] __mutex_lock_common+0x8a/0x278
[   59.750200]  [<c0147dae>] ? cpu_maps_update_begin+0x14/0x16
[   59.750200]  [<c016261e>] ? trace_hardirqs_on_caller+0x94/0xcd
[   59.750200]  [<c09eb1c7>] mutex_lock_nested+0x2e/0x36
[   59.750200]  [<c0147dae>] ? cpu_maps_update_begin+0x14/0x16
[   59.750200]  [<c0147dae>] cpu_maps_update_begin+0x14/0x16
[   59.750200]  [<c0154a05>] destroy_workqueue+0x26/0x89
[   59.750200]  [<c07eb688>] input_close_polled_device+0x3b/0x47
[   59.750200]  [<c07e9056>] input_close_device+0x45/0x61
[   59.750200]  [<c07edd49>] evdev_release+0x7f/0x99
[   59.750200]  [<c019e7d9>] __fput+0xb3/0x135
[   59.750200]  [<c019eb5f>] fput+0x1c/0x21
[   59.750200]  [<c019bffd>] filp_close+0x4c/0x56
[   59.750200]  [<c019d1d6>] sys_close+0x6d/0xa6
[   59.750200]  [<c011bb2f>] sysenter_do_call+0x12/0x43
[   59.750200]  [<c0110000>] ? x86_decode_insn+0x46e/0x942
[   59.750200]  =======================
