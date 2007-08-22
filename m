Return-Path: <linux-kernel-owner+w=401wt.eu-S934187AbXHVWlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187AbXHVWlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764497AbXHVWlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:41:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:47276 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326AbXHVWl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NHTCw1p5K/iIm2J5y5BZxPCSRREyqK9+HG52Hv3nCoa9QoIEC4y472rpluqH2645FR7BYqHSipy4ARPTABbSJrZyd1N/vzIxQuHQ9fDF7NmS5pE9rQZQhQGGeE2+w2CY1OL3REH/NjK/Zo503bGYs8gHJbGrC+6s+RvTrmpP/Lg=
Message-ID: <dda83e780708221541x4fabd27er64e6ecaa33ddccbf@mail.gmail.com>
Date: Wed, 22 Aug 2007 15:41:18 -0700
From: "Bret Towe" <magnade@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Trond.Myklebust@netapp.com
Subject: nfs4 hang regression
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

as of commit 3d39c691ff486142dd9aaeac12f553f4476b7a62
I got a hang on my clients after something around 26 minutes of uptime
the keyboard would stop accepting input
mouse would work still, plugging in a spare usb keyboard made no difference
another couple odd bits is shutting down would hang, below is a trace
of that hang
also if your logged into that machine via ssh when you log out it would hang
and would require a force terminate

I'm seeing this on 2 machines 1 a g4 mac mini and 2 a athlon64
both have a home directory mounted via nfs4
reverting the commit above found via bisecting on both machines allows me
to use the computers for several hours with no issues

and here is the trace from the athlon64 taken during its hang on shutdown
as you can tell from the dates in the trace ive been a bit busy and just
now got around to sending this email
I'm surprised tho I hadn't seen anyone hitting it
let me know what else is needed I'll do what I can and get it out quickly

Aug 12 17:06:35 ghoststar kernel: [ 4791.801262] SysRq : Show State
Aug 12 17:06:35 ghoststar kernel: [ 4791.801325]   task
        PC stack   pid father
Aug 12 17:06:35 ghoststar kernel: [ 4791.801327] init          S
00000000ffffffff     0     1      0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801331]  ffff81003ff879b8
0000000000000086 0000000000000008 ffff81003ff84000
Aug 12 17:06:35 ghoststar kernel: [ 4791.801335]  ffff81003fe16e00
ffff81003a604e00 0000000c3ff87998 0000000000000001
Aug 12 17:06:35 ghoststar kernel: [ 4791.801339]  ffff81003773ac00
7fffffffffffffff 0000000000000020 ffff8100376f4d00
Aug 12 17:06:35 ghoststar kernel: [ 4791.801342] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801357]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801362]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.801366]  [pipe_poll+157/160]
pipe_poll+0x9d/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801370]
[do_select+1275/1536] do_select+0x4fb/0x600
Aug 12 17:06:35 ghoststar kernel: [ 4791.801377]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.801381]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.801385]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.801389]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.801396]
[proc_destroy_inode+20/32] proc_destroy_inode+0x14/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.801401]
[free_hot_page+11/16] free_hot_page+0xb/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.801404]  [__free_pages+37/48]
__free_pages+0x25/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.801408]
[__free_slab+123/320] __free_slab+0x7b/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.801412]
[proc_destroy_inode+20/32] proc_destroy_inode+0x14/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.801415]  [discard_slab+30/64]
discard_slab+0x1e/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801418]
[__slab_free+519/928] __slab_free+0x207/0x3a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801423]
[proc_delete_inode+0/96] proc_delete_inode+0x0/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.801426]
[proc_destroy_inode+20/32] proc_destroy_inode+0x14/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.801430]
[proc_delete_inode+0/96] proc_delete_inode+0x0/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.801434]
[core_sys_select+510/784] core_sys_select+0x1fe/0x310
Aug 12 17:06:35 ghoststar kernel: [ 4791.801440]  [d_kill+78/112]
d_kill+0x4e/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.801443]  [dput+36/480] dput+0x24/0x1e0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801447]
[proc_flush_task+224/736] proc_flush_task+0xe0/0x2e0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801453]
[release_task+723/992] release_task+0x2d3/0x3e0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801459]  [sys_select+65/416]
sys_select+0x41/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801465]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.801469]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801471] kthreadd      S
00000000ffffffff     0     2      0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801474]  ffff81003ff8bf00
0000000000000046 0000000000000000 ffff81003ff84700
Aug 12 17:06:35 ghoststar kernel: [ 4791.801477]  ffff810029a8a700
0000000000000286 00000000000017ae ffff810032e21ac8
Aug 12 17:06:35 ghoststar kernel: [ 4791.801480]  0000000000000000
ffffffff806bfe10 00000000000017ae ffff810032e21ac8
Aug 12 17:06:35 ghoststar kernel: [ 4791.801483] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801490]  [kthreadd+453/496]
kthreadd+0x1c5/0x1f0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801494]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801500]  [kthreadd+0/496]
kthreadd+0x0/0x1f0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801503]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801505]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801507] ksoftirqd/0   S
00000000ffffffff     0     3      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.801509]  ffff81003ff8ff00
0000000000000046 00000000ffffffff ffff81003ff84e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.801513]  ffff810037eb8000
ffff810037eb8000 0000000000000000 ffffffff802382c0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801516]  0000000000000000
00000000fffffffc 0000000000000000 ffffffff802382c0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801519] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801523]  [ksoftirqd+0/288]
ksoftirqd+0x0/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.801527]  [ksoftirqd+0/288]
ksoftirqd+0x0/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.801531]  [ksoftirqd+252/288]
ksoftirqd+0xfc/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.801534]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801537]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801543]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801546]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801548]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801549] watchdog/0    S
00000000ffffffff     0     4      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.801552]  ffff81003ff91ee0
0000000000000046 0000000000000001 ffff81003ff85500
Aug 12 17:06:35 ghoststar kernel: [ 4791.801555]  ffff81003ff84000
ffffffff8022d91b ffff81003ff91f10 0000000000000046
Aug 12 17:06:35 ghoststar kernel: [ 4791.801559]  0000000000000202
0000000000000001 0000000000000000 ffffffff8025e9f0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801562] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801565]
[sched_setscheduler+619/864] sched_setscheduler+0x26b/0x360
Aug 12 17:06:35 ghoststar kernel: [ 4791.801569]  [watchdog+0/96]
watchdog+0x0/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.801572]  [watchdog+76/96]
watchdog+0x4c/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.801575]  [watchdog+0/96]
watchdog+0x0/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.801578]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801582]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801587]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801590]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801592]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801594] events/0      D
ffffffff8070c460     0     5      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.801596]  ffff81003ff95c70
0000000000000046 ffffffff80554950 ffff81003ff92000
Aug 12 17:06:35 ghoststar kernel: [ 4791.801599]  ffffffff806b5360
0000000000000086 0000000000000000 ffff81003ffc8e40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801603]  ffffffff806d1320
ffff81003ff95d00 0000000000000000 0000000000000000
Aug 12 17:06:35 ghoststar kernel: [ 4791.801606] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801610]
[rpc_free_client+0/288] rpc_free_client+0x0/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.801615]
[wait_for_completion+186/320] wait_for_completion+0xba/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.801619]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.801623]
[__cancel_work_timer+364/448] __cancel_work_timer+0x16c/0x1c0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801628]
[wq_barrier_func+0/16] wq_barrier_func+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.801632]  [discard_slab+30/64]
discard_slab+0x1e/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801636]
[cancel_delayed_work_sync+13/16] cancel_delayed_work_sync+0xd/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.801640]
[nfs_release_automount_timer+31/48]
nfs_release_automount_timer+0x1f/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.801645]
[nfs_free_server+216/288] nfs_free_server+0xd8/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.801648]
[nfs_kill_super+29/48] nfs_kill_super+0x1d/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.801652]
[deactivate_super+125/160] deactivate_super+0x7d/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801656]
[mntput_no_expire+113/208] mntput_no_expire+0x71/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801660]
[expire_mount_list+340/544] expire_mount_list+0x154/0x220
Aug 12 17:06:35 ghoststar kernel: [ 4791.801664]
[nfs_expire_automounts+0/64] nfs_expire_automounts+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801669]
[mark_mounts_for_expiry+187/240] mark_mounts_for_expiry+0xbb/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801672]
[nfs_expire_automounts+16/64] nfs_expire_automounts+0x10/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801676]
[run_workqueue+184/416] run_workqueue+0xb8/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801679]
[worker_thread+195/304] worker_thread+0xc3/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801683]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801686]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801689]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801693]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801699]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801702]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801704]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801705] khelper       S
00000000ffffffff     0     6      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.801708]  ffff81003ff99eb0
0000000000000046 0000000000000200 ffff81003ff92700
Aug 12 17:06:35 ghoststar kernel: [ 4791.801711]  ffff81003ff84e00
ffffffff8024398a ffff81003d2a6a88 ffff81003d2a6a80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801714]  ffff81003ff99eb0
ffff81003ffc8f10 ffff81003ffc8f00 ffff81003ff99ec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801717] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801721]
[__call_usermodehelper+106/144] __call_usermodehelper+0x6a/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.801726]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801729]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801733]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801736]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801740]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801745]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801748]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801751]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801752] kblockd/0     S
ffffffff8070c460     0    65      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.801754]  ffff81003ff2feb0
0000000000000046 ffff81003ff2fe60 ffff81003ff2c000
Aug 12 17:06:35 ghoststar kernel: [ 4791.801758]  ffffffff806b5360
0000000000000282 ffff81003ff2fe80 ffff810037500a80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801761]  ffff81003ff2feb0
ffff810037418010 ffff810037418000 ffff81003ff2fec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801764] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801769]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801772]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801776]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801779]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801783]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801789]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801792]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801794]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801795] kacpid        S
00000000ffffffff     0    68      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.801798]  ffff81003ff3beb0
0000000000000046 ffff81003ff3be60 ffff81003ff2d500
Aug 12 17:06:35 ghoststar kernel: [ 4791.801801]  ffff81003ff3c000
0000000000000000 ffffffff806b5040 ffff81003ff87cd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801804]  0000000000000000
ffff810037418190 ffff810037418180 ffff81003ff3bec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801807] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801813]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801816]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801820]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801823]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801826]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801832]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801835]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801837]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801839] kacpi_notify  S
00000000ffffffff     0    69      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.801841]  ffff81003ff3feb0
0000000000000046 ffff81003ff3fe60 ffff81003ff3c000
Aug 12 17:06:35 ghoststar kernel: [ 4791.801844]  ffff81003ff3c700
0000000000000000 ffffffff806b5040 0000000000004000
Aug 12 17:06:35 ghoststar kernel: [ 4791.801848]  0000000000000000
ffff810037418250 ffff810037418240 ffff81003ff3fec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801851] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801856]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801859]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801863]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801866]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801870]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801875]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801878]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801881]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801882] tifm          S
00000000ffffffff     0   167      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.801884]  ffff81003ff7feb0
0000000000000046 ffff81003ff7fe60 ffff81003fe17500
Aug 12 17:06:35 ghoststar kernel: [ 4791.801888]  ffff81003ff84000
0000000000000000 ffffffff806b5040 ffffffff8076b920
Aug 12 17:06:35 ghoststar kernel: [ 4791.801891]  0000000000000000
ffff810037ff4750 ffff810037ff4740 ffff81003ff7fec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801894] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801899]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801903]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801906]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801909]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801913]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801919]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801922]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801924]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801925] ata/0         S
00000000ffffffff     0   173      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.801928]  ffff81003ff9deb0
0000000000000046 ffff81003ff9de60 ffff81003ff28700
Aug 12 17:06:35 ghoststar kernel: [ 4791.801931]  ffff81003ff84000
0000000000000000 ffffffff806b5040 ffffffff8076b920
Aug 12 17:06:35 ghoststar kernel: [ 4791.801934]  0000000000000000
ffff810037ffdf90 ffff810037ffdf80 ffff81003ff9dec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801937] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801942]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801946]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801950]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801953]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801956]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801962]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.801965]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.801967]
Aug 12 17:06:35 ghoststar kernel: [ 4791.801968] ata_aux       S
00000000ffffffff     0   174      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.801971]  ffff81003ff9feb0
0000000000000046 ffff81003ff9fe60 ffff81003ff28e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.801974]  ffff81003ff84000
0000000000000000 ffffffff806b5040 ffffffff8076b920
Aug 12 17:06:35 ghoststar kernel: [ 4791.801978]  0000000000000000
ffff810001fb3050 ffff810001fb3040 ffff81003ff9fec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.801981] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.801986]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801989]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.801993]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.801996]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802000]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802006]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802008]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802011]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802012] ksuspend_usbd S
00000000ffffffff     0   175      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802015]  ffff81003ffa7eb0
0000000000000046 ffff81003ff50d28 ffff81003ff29500
Aug 12 17:06:35 ghoststar kernel: [ 4791.802018]  ffff810037eb8000
ffffffff80460a50 ffff81003ffa7e80 ffffffff80460a62
Aug 12 17:06:35 ghoststar kernel: [ 4791.802021]  ffff81003ffa7eb0
ffff810001fb3110 ffff810001fb3100 ffff81003ffa7ec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802024] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802029]
[usb_autosuspend_work+0/32] usb_autosuspend_work+0x0/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.802032]
[usb_autosuspend_work+18/32] usb_autosuspend_work+0x12/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.802036]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802039]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802043]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802046]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802050]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802056]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802058]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802061]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802062] khubd         S
ffffffff8070c460     0   181      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802065]  ffff81003fe21e00
0000000000000046 00000000ffffffed ffff81003fe3c700
Aug 12 17:06:35 ghoststar kernel: [ 4791.802068]  ffffffff806b5360
ffffffff804609d8 ffff81003fe21ed4 ffff810037508000
Aug 12 17:06:35 ghoststar kernel: [ 4791.802071]  0000000000000000
ffffffff806f2930 0000000000000000 ffff81003d2bdc00
Aug 12 17:06:35 ghoststar kernel: [ 4791.802074] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802078]
[usb_autopm_do_interface+152/256] usb_autopm_do_interface+0x98/0x100
Aug 12 17:06:35 ghoststar kernel: [ 4791.802084]
[hub_thread+610/3824] hub_thread+0x262/0xef0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802091]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802096]  [hub_thread+0/3824]
hub_thread+0x0/0xef0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802099]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802103]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802109]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802111]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802114]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802115] kseriod       S
00000000ffffffff     0   184      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802118]  ffff81003fe09eb0
0000000000000046 ffff81003fe09ea0 ffff81003fe26000
Aug 12 17:06:35 ghoststar kernel: [ 4791.802121]  ffff81003ff84000
ffffffff806f5e70 ffff81003fe09e90 0000000000000287
Aug 12 17:06:35 ghoststar kernel: [ 4791.802124]  ffff810037eeb800
ffffffff806f5fc0 ffff810037eeb800 0000000000000246
Aug 12 17:06:35 ghoststar kernel: [ 4791.802127] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802134]
[serio_thread+280/1104] serio_thread+0x118/0x450
Aug 12 17:06:35 ghoststar kernel: [ 4791.802137]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802142]
[serio_thread+0/1104] serio_thread+0x0/0x450
Aug 12 17:06:35 ghoststar kernel: [ 4791.802145]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802149]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802154]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802157]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802159]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802161] khpsbpkt      S
00000000ffffffff     0   206      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802163]  ffff81003ff35ee0
0000000000000046 0000000300000000 ffff81003fe16700
Aug 12 17:06:35 ghoststar kernel: [ 4791.802167]  ffff81003ff3c700
ffffffff80448760 0000000000000000 0000000000000000
Aug 12 17:06:35 ghoststar kernel: [ 4791.802170]  ffff81003ff35ed0
ffffffff806f0990 ffff81003ff35ef0 ffffffff80448760
Aug 12 17:06:35 ghoststar kernel: [ 4791.802173] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802177]
[hpsbpkt_thread+0/416] hpsbpkt_thread+0x0/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802182]
[hpsbpkt_thread+0/416] hpsbpkt_thread+0x0/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802186]
[hpsbpkt_thread+377/416] hpsbpkt_thread+0x179/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802190]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802193]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802199]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802202]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802204]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802206] pdflush       S
00000000ffffffff     0   240      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802208]  ffff81003d265eb0
0000000000000046 0000000000000000 ffff81003743d500
Aug 12 17:06:35 ghoststar kernel: [ 4791.802211]  ffff81003ff3d500
ffff81003a7e8700 00000000000038fe 0000000000001c7f
Aug 12 17:06:35 ghoststar kernel: [ 4791.802215]  0000000000000000
ffff81003d265ed8 0000000000000000 ffffffff80268f50
Aug 12 17:06:35 ghoststar kernel: [ 4791.802218] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802222]  [pdflush+0/656]
pdflush+0x0/0x290
Aug 12 17:06:35 ghoststar kernel: [ 4791.802225]  [pdflush+246/656]
pdflush+0xf6/0x290
Aug 12 17:06:35 ghoststar kernel: [ 4791.802229]  [pdflush+0/656]
pdflush+0x0/0x290
Aug 12 17:06:35 ghoststar kernel: [ 4791.802232]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802236]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802242]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802244]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802247]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802248] kswapd0       S
00000000ffffffff     0   241      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802251]  ffff81003d269e00
0000000000000046 ffff81003d269db0 ffff81003d266000
Aug 12 17:06:35 ghoststar kernel: [ 4791.802254]  ffff81003742e700
ffffffff8026c8e7 ffffffffffffff10 0000000000000100
Aug 12 17:06:35 ghoststar kernel: [ 4791.802257]  0000000000039aaa
0000000000000001 00000000ffffffff ffffffff806c8390
Aug 12 17:06:35 ghoststar kernel: [ 4791.802260] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802263]
[shrink_slab+375/448] shrink_slab+0x177/0x1c0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802268]  [kswapd+1447/1472]
kswapd+0x5a7/0x5c0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802275]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802280]
[preempt_schedule+102/160] preempt_schedule+0x66/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802283]  [kswapd+0/1472]
kswapd+0x0/0x5c0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802286]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802290]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802296]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802298]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802301]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802302] aio/0         S
00000000ffffffff     0   296      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802305]  ffff810037473eb0
0000000000000046 ffff810037473e60 ffff81003746b500
Aug 12 17:06:35 ghoststar kernel: [ 4791.802308]  ffff81003ff84000
0000000000000000 ffffffff806b5040 ffffffff8076b920
Aug 12 17:06:35 ghoststar kernel: [ 4791.802311]  0000000000000000
ffff810001fb3c10 ffff810001fb3c00 ffff810037473ec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802314] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802319]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802323]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802327]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802329]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802333]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802339]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802342]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802344]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802345] kpsmoused     S
00000000ffffffff     0  1053      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802348]  ffff81003d287eb0
0000000000000046 ffff81003d287e60 ffff81003ff3ce00
Aug 12 17:06:35 ghoststar kernel: [ 4791.802351]  ffff81003ff84000
0000000000000000 ffffffff806b5040 ffffffff8076b920
Aug 12 17:06:35 ghoststar kernel: [ 4791.802354]  0000000000000000
ffff810037eeb690 ffff810037eeb680 ffff81003d287ec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802357] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802363]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802366]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802370]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802373]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802377]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802382]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802385]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802387]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802389] edac-poller   S
00000000ffffffff     0  1069      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802391]  ffff810037477eb0
0000000000000046 ffff810037477e60 ffff81003ff92e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.802395]  ffff81003ff84000
0000000000000000 ffffffff806b5040 ffffffff8076b920
Aug 12 17:06:35 ghoststar kernel: [ 4791.802398]  0000000000000000
ffff810037eebad0 ffff810037eebac0 ffff810037477ec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802401] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802406]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802409]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802413]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802416]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802420]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802426]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802428]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802431]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802432] kondemand/0   S
ffffffff8070c460     0  1070      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802434]  ffff810037561eb0
0000000000000046 000000ab37561ec0 ffff81003fe26700
Aug 12 17:06:35 ghoststar kernel: [ 4791.802438]  ffffffff806b5360
ffff810037eeb540 ffffffff80499b50 0000000000000000
Aug 12 17:06:35 ghoststar kernel: [ 4791.802441]  ffff810037561eb0
ffff810037eeb550 ffff810037eeb540 ffff810037561ec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802444] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802449]  [do_dbs_timer+0/640]
do_dbs_timer+0x0/0x280
Aug 12 17:06:35 ghoststar kernel: [ 4791.802453]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802456]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802460]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802463]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802467]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802473]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802475]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802478]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802479] rpciod/0      S
00000000ffffffff     0  1078      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802482]  ffff810037461eb0
0000000000000046 0000000000000001 ffff81003742e000
Aug 12 17:06:35 ghoststar kernel: [ 4791.802485]  ffff81003ff84e00
ffff81003d2a3140 ffff810037461e80 ffffffff8055ab90
Aug 12 17:06:35 ghoststar kernel: [ 4791.802488]  ffff810037461eb0
ffff81003d2a3150 ffff81003d2a3140 ffff810037461ec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802491] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802495]
[rpc_async_schedule+16/32] rpc_async_schedule+0x10/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.802499]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802503]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802506]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802509]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802513]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802519]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802522]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802524]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802525] knodemgrd_0   S
ffffffff8070c460     0  1942      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802528]  ffff8100378bde60
0000000000000046 ffff81003ca26108 ffff81003ff3c700
Aug 12 17:06:35 ghoststar kernel: [ 4791.802531]  ffffffff806b5360
ffffffff802d8dcf ffff81003ca26108 0000000000000000
Aug 12 17:06:35 ghoststar kernel: [ 4791.802534]  0000000000000000
0000000000000001 0000000000000001 ffff810037680000
Aug 12 17:06:35 ghoststar kernel: [ 4791.802537] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802541]
[sysfs_create_link+223/448] sysfs_create_link+0xdf/0x1c0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802545]
[nodemgr_host_thread+1083/3040] nodemgr_host_thread+0x43b/0xbe0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802550]
[update_stats_wait_end+95/128] update_stats_wait_end+0x5f/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802556]
[preempt_schedule+102/160] preempt_schedule+0x66/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802559]
[nodemgr_host_thread+0/3040] nodemgr_host_thread+0x0/0xbe0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802562]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802566]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802572]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802575]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802577]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802578] xfslogd/0     S
ffffffff8070c460     0  1952      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802581]  ffff81003c629eb0
0000000000000046 ffff81003791c940 ffff81003fe27500
Aug 12 17:06:35 ghoststar kernel: [ 4791.802584]  ffffffff806b5360
ffffffff880a9404 ffff810037936680 ffff8100376230a8
Aug 12 17:06:35 ghoststar kernel: [ 4791.802587]  ffff81003c629eb0
ffff81003791c950 ffff81003791c940 ffff81003c629ec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802590] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802623]
[_end+126596380/2128683288] :xfs:xfs_buf_iodone_work+0x44/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.802629]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802632]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802636]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802639]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802643]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802649]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802652]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802654]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802655] scsi_eh_0     S
ffffffff8070c460     0  1967      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802658]  ffff81003c4a5e70
0000000000000046 0000000000000246 ffff810037e0ce00
Aug 12 17:06:35 ghoststar kernel: [ 4791.802661]  ffffffff806b5360
0000000000000246 ffff81003cff8800 ffffffff80420770
Aug 12 17:06:35 ghoststar kernel: [ 4791.802665]  ffff81003c4a5ed0
0000000000000246 ffff81003cff8800 ffffffff80420770
Aug 12 17:06:35 ghoststar kernel: [ 4791.802667] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802672]
[scsi_error_handler+0/896] scsi_error_handler+0x0/0x380
Aug 12 17:06:35 ghoststar kernel: [ 4791.802676]
[scsi_error_handler+0/896] scsi_error_handler+0x0/0x380
Aug 12 17:06:35 ghoststar kernel: [ 4791.802679]
[scsi_error_handler+103/896] scsi_error_handler+0x67/0x380
Aug 12 17:06:35 ghoststar kernel: [ 4791.802683]
[pick_next_task_fair+56/96] pick_next_task_fair+0x38/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.802687]  [schedule+250/427]
schedule+0xfa/0x1ab
Aug 12 17:06:35 ghoststar kernel: [ 4791.802691]
[preempt_schedule+102/160] preempt_schedule+0x66/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802695]
[scsi_error_handler+0/896] scsi_error_handler+0x0/0x380
Aug 12 17:06:35 ghoststar kernel: [ 4791.802698]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802702]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802708]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802711]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802713]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802714] xfsdatad/0    S
ffffffff8070c460     0  1983      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802717]  ffff81003ca3feb0
0000000000000046 ffff81001a047060 ffff81003c446000
Aug 12 17:06:35 ghoststar kernel: [ 4791.802720]  ffffffff806b5360
ffffffff880a6240 ffff81003ca3fec0 ffff81001a0470a8
Aug 12 17:06:35 ghoststar kernel: [ 4791.802723]  ffff81003ca3feb0
ffff81003d284090 ffff81003d284080 ffff81003ca3fec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802726] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802748]
[_end+126583640/2128683288] :xfs:xfs_end_bio_delalloc+0x20/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.802754]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802757]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802761]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802764]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802768]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802774]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802776]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802779]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802780] scsi_eh_1     S
ffffffff8070c460     0  1992      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802783]  ffff81003c49de70
0000000000000046 0000000000000246 ffff81003746a000
Aug 12 17:06:35 ghoststar kernel: [ 4791.802786]  ffffffff806b5360
0000000000000246 ffff81003cff9000 ffffffff80420770
Aug 12 17:06:35 ghoststar kernel: [ 4791.802789]  ffff81003c49ded0
0000000000000246 ffff81003cff9000 ffffffff80420770
Aug 12 17:06:35 ghoststar kernel: [ 4791.802792] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802796]
[scsi_error_handler+0/896] scsi_error_handler+0x0/0x380
Aug 12 17:06:35 ghoststar kernel: [ 4791.802800]
[scsi_error_handler+0/896] scsi_error_handler+0x0/0x380
Aug 12 17:06:35 ghoststar kernel: [ 4791.802803]
[scsi_error_handler+103/896] scsi_error_handler+0x67/0x380
Aug 12 17:06:35 ghoststar kernel: [ 4791.802807]
[pick_next_task_fair+56/96] pick_next_task_fair+0x38/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.802811]  [schedule+250/427]
schedule+0xfa/0x1ab
Aug 12 17:06:35 ghoststar kernel: [ 4791.802815]
[preempt_schedule+102/160] preempt_schedule+0x66/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802819]
[scsi_error_handler+0/896] scsi_error_handler+0x0/0x380
Aug 12 17:06:35 ghoststar kernel: [ 4791.802822]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802826]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802832]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802835]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802837]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802838] xfs_mru_cache S
ffffffff8070c460     0  2008      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802841]  ffff81003c62beb0
0000000000000046 ffff81003c81ae00 ffff81003fe16e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.802844]  ffffffff806b5360
ffffffff88096bf6 ffff81003c81ae60 ffff81003c81ae58
Aug 12 17:06:35 ghoststar kernel: [ 4791.802847]  ffff81003c62beb0
ffff81003d2845d0 ffff81003d2845c0 ffff81003c62bec0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802850] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802872]
[_end+126520590/2128683288] :xfs:_xfs_mru_cache_reap+0xc6/0xe0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802877]
[worker_thread+261/304] worker_thread+0x105/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802881]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.802885]
[worker_thread+0/304] worker_thread+0x0/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.802888]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802891]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802897]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802900]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802902]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802903] xfsbufd       S
ffffffff8070c460     0  2014      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802906]  ffff810037da3e50
0000000000000046 ffff81003d2af830 ffff81003742e700
Aug 12 17:06:35 ghoststar kernel: [ 4791.802909]  ffffffff806b5360
0000000100259278 ffff810037da3e50 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.802913]  ffff810037964af0
ffff810037da3e60 0000000100259278 ffff810037da3ee0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802916] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.802922]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802925]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.802929]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.802934]
[schedule_timeout_interruptible+25/32]
schedule_timeout_interruptible+0x19/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.802955]
[_end+126597419/2128683288] :xfs:xfsbufd+0x63/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.802977]
[_end+126597320/2128683288] :xfs:xfsbufd+0x0/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.802980]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802984]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802990]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.802993]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.802995]
Aug 12 17:06:35 ghoststar kernel: [ 4791.802996] xfssyncd      S
ffffffff8070c460     0  2299      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.802999]  ffff810037731e20
0000000000000046 ffff810037731e00 ffff81003cac4e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.803002]  ffffffff806b5360
000000010025ad57 ffff810037731e20 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.803005]  0000000000000271
ffff810037731e30 000000010025ad57 ffff81003c4b2430
Aug 12 17:06:35 ghoststar kernel: [ 4791.803008] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803015]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803018]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803022]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803026]
[schedule_timeout_interruptible+25/32]
schedule_timeout_interruptible+0x19/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.803048]
[_end+126624326/2128683288] :xfs:xfssyncd+0x5e/0x1f0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803071]
[_end+126624232/2128683288] :xfs:xfssyncd+0x0/0x1f0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803075]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.803078]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.803084]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.803087]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.803090]
Aug 12 17:06:35 ghoststar kernel: [ 4791.803091] udevd         S
00000000ffffffff     0  2466      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.803094]  ffff81003c0539b8
0000000000000086 8000000029f41065 ffff81003fe3d500
Aug 12 17:06:35 ghoststar kernel: [ 4791.803097]  ffff810031526700
ffff810031526700 ffff81003c053a08 0000000000000202
Aug 12 17:06:35 ghoststar kernel: [ 4791.803100]  000000013cc836c0
7fffffffffffffff 0000000000000040 ffff810037504c00
Aug 12 17:06:35 ghoststar kernel: [ 4791.803103] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803109]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803112]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.803116]  [pipe_poll+157/160]
pipe_poll+0x9d/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803119]
[do_select+1275/1536] do_select+0x4fb/0x600
Aug 12 17:06:35 ghoststar kernel: [ 4791.803127]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.803130]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803134]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803138]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803142]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803148]  [number+715/768]
number+0x2cb/0x300
Aug 12 17:06:35 ghoststar kernel: [ 4791.803152]  [dput+36/480] dput+0x24/0x1e0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803155]
[__follow_mount+47/160] __follow_mount+0x2f/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803160]  [do_lookup+132/512]
do_lookup+0x84/0x200
Aug 12 17:06:35 ghoststar kernel: [ 4791.803164]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803168]
[__link_path_walk+2079/4176] __link_path_walk+0x81f/0x1050
Aug 12 17:06:35 ghoststar kernel: [ 4791.803172]
[shmem_truncate_range+81/2912] shmem_truncate_range+0x51/0xb60
Aug 12 17:06:35 ghoststar kernel: [ 4791.803177]
[core_sys_select+510/784] core_sys_select+0x1fe/0x310
Aug 12 17:06:35 ghoststar kernel: [ 4791.803185]  [up_read+9/16]
up_read+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803188]
[do_page_fault+499/2384] do_page_fault+0x1f3/0x950
Aug 12 17:06:35 ghoststar kernel: [ 4791.803196]  [sys_select+65/416]
sys_select+0x41/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803198]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803204]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.803209]
Aug 12 17:06:35 ghoststar kernel: [ 4791.803210] portmap       S
00000000ffffffff     0  3895      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.803213]  ffff81003c1a5ae8
0000000000000082 ffff81003bf2f000 ffff81003d266700
Aug 12 17:06:35 ghoststar kernel: [ 4791.803216]  ffff81003a77b500
ffffffff804fc760 000040343c1a5ae8 0000000000000206
Aug 12 17:06:35 ghoststar kernel: [ 4791.803219]  ffff81003c1a5ae8
7fffffffffffffff ffff81003c1a5e24 ffff81003ced4700
Aug 12 17:06:35 ghoststar kernel: [ 4791.803222] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803226]
[udp_push_pending_frames+336/880] udp_push_pending_frames+0x150/0x370
Aug 12 17:06:35 ghoststar kernel: [ 4791.803232]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803235]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.803239]  [tcp_poll+301/432]
tcp_poll+0x12d/0x1b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803243]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803247]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.803251]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803255]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803260]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.803264]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.803269]
[filemap_fault+507/1200] filemap_fault+0x1fb/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803274]
[__do_fault+454/1104] __do_fault+0x1c6/0x450
Aug 12 17:06:35 ghoststar kernel: [ 4791.803278]
[move_addr_to_kernel+45/64] move_addr_to_kernel+0x2d/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.803282]
[verify_iovec+60/192] verify_iovec+0x3c/0xc0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803286]
[sys_sendmsg+376/752] sys_sendmsg+0x178/0x2f0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803294]  [d_free+73/80]
d_free+0x49/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.803297]  [d_kill+78/112]
d_kill+0x4e/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.803301]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803307]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.803311]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.803316]
Aug 12 17:06:35 ghoststar kernel: [ 4791.803317] getty         S
ffffffff8070c460     0  4203      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.803320]  ffff81003a949da8
0000000000000082 00002b545cca900e ffff81003fe26e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.803323]  ffffffff806b5360
000000ff80266cfb ffff81003a9401ff ffffffff8026a20f
Aug 12 17:06:35 ghoststar kernel: [ 4791.803326]  0000000000000100
7fffffffffffffff 000000000000001e ffff81003bde8800
Aug 12 17:06:35 ghoststar kernel: [ 4791.803329] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803333]  [put_page+47/240]
put_page+0x2f/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803337]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803342]
[con_flush_chars+75/96] con_flush_chars+0x4b/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.803346]  [con_write+35/48]
con_write+0x23/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.803349]  [read_chan+623/1808]
read_chan+0x26f/0x710
Aug 12 17:06:35 ghoststar kernel: [ 4791.803354]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803359]  [tty_read+164/240]
tty_read+0xa4/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803363]  [vfs_read+196/352]
vfs_read+0xc4/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.803366]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.803370]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.803375]
Aug 12 17:06:35 ghoststar kernel: [ 4791.803376] getty         S
0000000000000000     0  4204      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.803379]  ffff81003aacdda8
0000000000000082 00002b869dd1600e ffff810037e0c000
Aug 12 17:06:35 ghoststar kernel: [ 4791.803382]  ffff81003cac4700
000000ff80266cfb ffff81003aac01ff ffffffff8026a20f
Aug 12 17:06:35 ghoststar kernel: [ 4791.803385]  0000000000000100
7fffffffffffffff 000000000000001e ffff81003ccc8000
Aug 12 17:06:35 ghoststar kernel: [ 4791.803388] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803392]  [put_page+47/240]
put_page+0x2f/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803396]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803401]
[con_flush_chars+75/96] con_flush_chars+0x4b/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.803404]  [con_write+35/48]
con_write+0x23/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.803407]  [read_chan+623/1808]
read_chan+0x26f/0x710
Aug 12 17:06:35 ghoststar kernel: [ 4791.803412]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803417]  [tty_read+164/240]
tty_read+0xa4/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803421]  [vfs_read+196/352]
vfs_read+0xc4/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.803424]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.803428]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.803436]
Aug 12 17:06:35 ghoststar kernel: [ 4791.803437] getty         S
0000000000000000     0  4209      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.803439]  ffff81003a5e1da8
0000000000000086 00002b4bc9dc600e ffff81003aa90700
Aug 12 17:06:35 ghoststar kernel: [ 4791.803443]  ffff81003aa91500
000000ff80266cfb ffff81003a5e01ff ffffffff8026a20f
Aug 12 17:06:35 ghoststar kernel: [ 4791.803446]  0000000000000100
7fffffffffffffff 000000000000001e ffff81003ccc8800
Aug 12 17:06:35 ghoststar kernel: [ 4791.803449] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803452]  [put_page+47/240]
put_page+0x2f/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803457]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803461]
[con_flush_chars+75/96] con_flush_chars+0x4b/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.803465]  [con_write+35/48]
con_write+0x23/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.803468]  [read_chan+623/1808]
read_chan+0x26f/0x710
Aug 12 17:06:35 ghoststar kernel: [ 4791.803473]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803477]  [tty_read+164/240]
tty_read+0xa4/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803481]  [vfs_read+196/352]
vfs_read+0xc4/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.803485]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.803489]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.803493]
Aug 12 17:06:35 ghoststar kernel: [ 4791.803495] getty         S
0000000000000000     0  4210      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.803497]  ffff81003a603da8
0000000000000086 00002b5a12e3300e ffff81003aa91500
Aug 12 17:06:35 ghoststar kernel: [ 4791.803500]  ffff81003743c000
000000ff80266cfb ffff81003a6001ff ffffffff8026a20f
Aug 12 17:06:35 ghoststar kernel: [ 4791.803504]  0000000000000100
7fffffffffffffff 000000000000001e ffff81003ccc9000
Aug 12 17:06:35 ghoststar kernel: [ 4791.803507] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803510]  [put_page+47/240]
put_page+0x2f/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803515]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803519]
[con_flush_chars+75/96] con_flush_chars+0x4b/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.803522]  [con_write+35/48]
con_write+0x23/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.803526]  [read_chan+623/1808]
read_chan+0x26f/0x710
Aug 12 17:06:35 ghoststar kernel: [ 4791.803530]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803535]  [tty_read+164/240]
tty_read+0xa4/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803539]  [vfs_read+196/352]
vfs_read+0xc4/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.803543]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.803547]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.803551]
Aug 12 17:06:35 ghoststar kernel: [ 4791.803552] getty         S
0000000000000000     0  4211      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.803555]  ffff81003a645da8
0000000000000082 00002b49b3b4700e ffff81003743c000
Aug 12 17:06:35 ghoststar kernel: [ 4791.803558]  ffff810037e0c000
000000ff80266cfb ffff81003a6401ff ffffffff8026a20f
Aug 12 17:06:35 ghoststar kernel: [ 4791.803562]  0000000000000100
7fffffffffffffff 000000000000001e ffff810037462000
Aug 12 17:06:35 ghoststar kernel: [ 4791.803565] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803568]  [put_page+47/240]
put_page+0x2f/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803573]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803577]
[con_flush_chars+75/96] con_flush_chars+0x4b/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.803580]  [con_write+35/48]
con_write+0x23/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.803583]  [read_chan+623/1808]
read_chan+0x26f/0x710
Aug 12 17:06:35 ghoststar kernel: [ 4791.803588]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803593]  [tty_read+164/240]
tty_read+0xa4/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803597]  [vfs_read+196/352]
vfs_read+0xc4/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.803600]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.803604]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.803609]
Aug 12 17:06:35 ghoststar kernel: [ 4791.803610] getty         S
0000000000000000     0  4212      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.803613]  ffff81003a687da8
0000000000000086 00002b4c4cbe300e ffff81003cac4700
Aug 12 17:06:35 ghoststar kernel: [ 4791.803616]  ffff81003fe26e00
000000ff80266cfb ffff81003a6801ff ffffffff8026a20f
Aug 12 17:06:35 ghoststar kernel: [ 4791.803619]  0000000000000100
7fffffffffffffff 000000000000001e ffff81003bde9800
Aug 12 17:06:35 ghoststar kernel: [ 4791.803622] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803626]  [put_page+47/240]
put_page+0x2f/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803630]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803635]
[con_flush_chars+75/96] con_flush_chars+0x4b/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.803638]  [con_write+35/48]
con_write+0x23/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.803641]  [read_chan+623/1808]
read_chan+0x26f/0x710
Aug 12 17:06:35 ghoststar kernel: [ 4791.803646]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803651]  [tty_read+164/240]
tty_read+0xa4/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803655]  [vfs_read+196/352]
vfs_read+0xc4/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.803658]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.803662]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.803667]
Aug 12 17:06:35 ghoststar kernel: [ 4791.803668] syslogd       S
00000000ffffffff     0  4289      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.803671]  ffff81003a0b79b8
0000000000000082 ffff81003a0b7968 ffff81003a604700
Aug 12 17:06:35 ghoststar kernel: [ 4791.803674]  ffff81003fe27500
ffff81003a7e8700 ffff81003a0b79b8 ffff81003a0b79d8
Aug 12 17:06:35 ghoststar kernel: [ 4791.803677]  ffff810000000001
7fffffffffffffff 0000000000000001 ffff81003c0ac800
Aug 12 17:06:35 ghoststar kernel: [ 4791.803680] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803686]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803689]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.803693]
[datagram_poll+277/288] datagram_poll+0x115/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.803697]
[do_select+1275/1536] do_select+0x4fb/0x600
Aug 12 17:06:35 ghoststar kernel: [ 4791.803704]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.803707]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803713]  [up_write+9/16]
up_write+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803735]
[_end+126428996/2128683288] :xfs:xfs_iunlock+0x8c/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803757]
[_end+126553025/2128683288] :xfs:xfs_rwunlock+0x39/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.803778]
[_end+126621036/2128683288] :xfs:xfs_write+0x634/0xba0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803782]
[kfree_skbmem+65/160] kfree_skbmem+0x41/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803786]
[__kfree_skb+111/208] __kfree_skb+0x6f/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803792]
[pipe_write+617/1328] pipe_write+0x269/0x530
Aug 12 17:06:35 ghoststar kernel: [ 4791.803815]
[_end+126603592/2128683288] :xfs:xfs_file_aio_write+0x0/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.803819]  [pipe_write+0/1328]
pipe_write+0x0/0x530
Aug 12 17:06:35 ghoststar kernel: [ 4791.803824]
[do_sync_readv_writev+235/304] do_sync_readv_writev+0xeb/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.803829]
[core_sys_select+510/784] core_sys_select+0x1fe/0x310
Aug 12 17:06:35 ghoststar kernel: [ 4791.803836]
[rw_copy_check_uvector+149/304] rw_copy_check_uvector+0x95/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.803841]
[do_readv_writev+203/464] do_readv_writev+0xcb/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803848]  [sys_select+65/416]
sys_select+0x41/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803852]
[sys_rt_sigprocmask+126/256] sys_rt_sigprocmask+0x7e/0x100
Aug 12 17:06:35 ghoststar kernel: [ 4791.803857]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.803862]
Aug 12 17:06:35 ghoststar kernel: [ 4791.803863] acpid         S
00000000ffffffff     0  4338      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.803866]  ffff81003a78dae8
0000000000000086 000010003ab0dd68 ffff81003a771500
Aug 12 17:06:35 ghoststar kernel: [ 4791.803869]  ffff810037eb8000
fffff23c00000000 000000008020c83c ffff81003ab0dd68
Aug 12 17:06:35 ghoststar kernel: [ 4791.803872]  ffff81003a78db08
7fffffffffffffff ffff81003a78de24 ffff81003c0ae900
Aug 12 17:06:35 ghoststar kernel: [ 4791.803875] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.803881]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803884]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.803888]  [unix_poll+197/208]
unix_poll+0xc5/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803892]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803896]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.803900]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803904]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803908]  [up_write+9/16]
up_write+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.803930]
[_end+126428996/2128683288] :xfs:xfs_iunlock+0x8c/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803951]
[_end+126553025/2128683288] :xfs:xfs_rwunlock+0x39/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.803972]
[_end+126621036/2128683288] :xfs:xfs_write+0x634/0xba0
Aug 12 17:06:35 ghoststar kernel: [ 4791.803976]
[find_lock_page+48/272] find_lock_page+0x30/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.803979]
[mark_page_accessed+59/80] mark_page_accessed+0x3b/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.803986]
[__do_fault+454/1104] __do_fault+0x1c6/0x450
Aug 12 17:06:35 ghoststar kernel: [ 4791.804009]
[_end+126603682/2128683288] :xfs:xfs_file_aio_write+0x5a/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.804014]
[do_sync_write+241/304] do_sync_write+0xf1/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.804020]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804024]
[sock_getsockopt+184/1008] sock_getsockopt+0xb8/0x3f0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804027]
[move_addr_to_user+94/112] move_addr_to_user+0x5e/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.804031]  [sys_accept+338/496]
sys_accept+0x152/0x1f0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804038]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.804042]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804047]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804048] dd            R
running task        0  4369      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.804051] klogd         S
00000000ffffffff     0  4371      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.804053]  ffff81003a78fcc8
0000000000000082 ffff81003a78fd18 ffff81003a7e8700
Aug 12 17:06:35 ghoststar kernel: [ 4791.804057]  ffff81003a604700
ffff81003a78fed8 ffff81003a78fd28 ffff810037f18840
Aug 12 17:06:35 ghoststar kernel: [ 4791.804060]  0000000000000000
ffff81003a0b9c00 ffff81003a78fcd8 0000000000000000
Aug 12 17:06:35 ghoststar kernel: [ 4791.804063] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804068]  [pipe_wait+131/176]
pipe_wait+0x83/0xb0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804072]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804076]  [pipe_read+251/1104]
pipe_read+0xfb/0x450
Aug 12 17:06:35 ghoststar kernel: [ 4791.804084]
[do_sync_read+241/304] do_sync_read+0xf1/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.804090]  [up_read+9/16]
up_read+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804093]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804101]  [vfs_read+196/352]
vfs_read+0xc4/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.804104]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.804108]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804113]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804114] rpc.statd     S
00000000ffffffff     0  4391      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.804117]  ffff81003a1e19b8
0000000000000086 ffff81003a1e19b8 ffff81003a7e9500
Aug 12 17:06:35 ghoststar kernel: [ 4791.804120]  ffff81003d266e00
ffff81003a1e19b0 ffffffff8022cb20 0000000000000091
Aug 12 17:06:35 ghoststar kernel: [ 4791.804123]  ffff81003a7e9548
7fffffffffffffff 0000000000000080 ffff810037c5d300
Aug 12 17:06:35 ghoststar kernel: [ 4791.804126] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804129]
[update_curr+224/288] update_curr+0xe0/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.804135]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804137]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804142]  [tcp_poll+301/432]
tcp_poll+0x12d/0x1b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804145]
[do_select+1275/1536] do_select+0x4fb/0x600
Aug 12 17:06:35 ghoststar kernel: [ 4791.804152]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804156]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804160]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804164]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804168]
[kfree_skbmem+65/160] kfree_skbmem+0x41/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804171]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804174]
[__kfree_skb+111/208] __kfree_skb+0x6f/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804178]  [kfree_skb+23/48]
kfree_skb+0x17/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.804182]
[skb_free_datagram+12/16] skb_free_datagram+0xc/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804185]
[udp_recvmsg+504/560] udp_recvmsg+0x1f8/0x230
Aug 12 17:06:35 ghoststar kernel: [ 4791.804191]
[sock_common_recvmsg+50/80] sock_common_recvmsg+0x32/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.804195]
[sock_recvmsg+229/272] sock_recvmsg+0xe5/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804198]
[do_ip_setsockopt+103/2896] do_ip_setsockopt+0x67/0xb50
Aug 12 17:06:35 ghoststar kernel: [ 4791.804203]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804208]
[core_sys_select+510/784] core_sys_select+0x1fe/0x310
Aug 12 17:06:35 ghoststar kernel: [ 4791.804215]
[sock_destroy_inode+20/32] sock_destroy_inode+0x14/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.804218]
[destroy_inode+46/80] destroy_inode+0x2e/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.804222]  [__d_free+48/64]
__d_free+0x30/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804226]  [d_free+73/80]
d_free+0x49/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.804229]  [d_kill+78/112]
d_kill+0x4e/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.804234]  [sys_select+65/416]
sys_select+0x41/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804237]  [fput+21/32] fput+0x15/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.804240]  [filp_close+86/144]
filp_close+0x56/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.804244]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804249]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804250] dbus-daemon   S
00000000ffffffff     0  4406      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.804253]  ffff810039c4fae8
0000000000000082 ffff81003a77a700 ffff81003a7e8e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.804256]  ffff810037eb8000
ffff810038e1a000 0000000000000001 0000000000000001
Aug 12 17:06:35 ghoststar kernel: [ 4791.804259]  ffff810039c4fb08
7fffffffffffffff ffff810039c4fe64 ffff81003c0af800
Aug 12 17:06:35 ghoststar kernel: [ 4791.804262] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804268]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804273]
[do_sys_poll+506/1200] do_sys_poll+0x1fa/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804276]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804280]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804284]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804288]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804292]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804296]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804300]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804304]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804308]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804312]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804316]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804320]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804324]
[rw_copy_check_uvector+149/304] rw_copy_check_uvector+0x95/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.804331]  [d_kill+78/112]
d_kill+0x4e/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.804335]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804338]  [__fput+375/464]
__fput+0x177/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804343]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.804347]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804351]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804353] rpc.idmapd    S
ffffffff8070c460     0  4411      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.804355]  ffff810039ce1e48
0000000000000082 ffff810039ce1ec8 ffff81003bf6e700
Aug 12 17:06:35 ghoststar kernel: [ 4791.804358]  ffffffff806b5360
00000001002593aa ffff810039ce1e48 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.804362]  0000000000000000
ffff810039ce1e58 00000001002593aa ffff81003b297480
Aug 12 17:06:35 ghoststar kernel: [ 4791.804365] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804371]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804374]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804378]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804383]
[sys_epoll_wait+427/1440] sys_epoll_wait+0x1ab/0x5a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804387]
[recalc_sigpending+18/48] recalc_sigpending+0x12/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.804390]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804394]
[sys_rt_sigprocmask+126/256] sys_rt_sigprocmask+0x7e/0x100
Aug 12 17:06:35 ghoststar kernel: [ 4791.804398]
[sys_gettimeofday+59/128] sys_gettimeofday+0x3b/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.804402]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804406]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804408] nfsv4-svc     S
0000000000000000     0  4427      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.804410]  ffff810039d2bde0
0000000000000046 0000000000000001 ffff81003a770e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.804413]  ffff81003a77b500
0000000000000000 ffff810039d2bdd0 ffffffff8022ccb9
Aug 12 17:06:35 ghoststar kernel: [ 4791.804417]  ffff810039d2bdd0
7fffffffffffffff ffff81003a7e6898 ffff81003a374000
Aug 12 17:06:35 ghoststar kernel: [ 4791.804420] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804423]
[enqueue_entity+169/432] enqueue_entity+0xa9/0x1b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804428]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804432]  [svc_reserve+52/64]
svc_reserve+0x34/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804435]
[svc_sock_release+235/432] svc_sock_release+0xeb/0x1b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804439]  [svc_recv+612/1312]
svc_recv+0x264/0x520
Aug 12 17:06:35 ghoststar kernel: [ 4791.804443]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804447]
[preempt_schedule+102/160] preempt_schedule+0x66/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804452]
[nfs_callback_svc+138/320] nfs_callback_svc+0x8a/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.804457]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.804463]
[nfs_callback_svc+0/320] nfs_callback_svc+0x0/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.804466]  [child_rip+0/18]
child_rip+0x0/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.804469]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804470] hald          S
ffffffff8070c460     0  4437      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.804473]  ffff810039d53ae8
0000000000000082 000200d039d53ab8 ffff81003a77a700
Aug 12 17:06:35 ghoststar kernel: [ 4791.804476]  ffffffff806b5360
00000001002597e0 ffff810039d53ae8 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.804479]  ffff810039d53ae8
ffff810039d53af8 00000001002597e0 ffff81003c0b9700
Aug 12 17:06:35 ghoststar kernel: [ 4791.804482] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804488]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804492]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804495]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804499]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804504]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804507]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804511]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804515]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804519]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804523]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804527]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804531]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804535]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804539]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804543]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804551]
[sys_readlinkat+61/176] sys_readlinkat+0x3d/0xb0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804555]  [remove_vma+79/96]
remove_vma+0x4f/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.804561]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.804564]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804569]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804570] hald-runner   S
00000000ffffffff     0  4438   4437
Aug 12 17:06:35 ghoststar kernel: [ 4791.804573]  ffff810039d75ae8
0000000000000082 ffff810039d75ab8 ffff81003a77b500
Aug 12 17:06:35 ghoststar kernel: [ 4791.804576]  ffff81003a7e8e00
ffff81003bf6e000 ffff810039d75ad8 0000000000000082
Aug 12 17:06:35 ghoststar kernel: [ 4791.804579]  ffff810039d75b08
7fffffffffffffff ffff810039d75e1c ffff810037c5dc00
Aug 12 17:06:35 ghoststar kernel: [ 4791.804582] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804588]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804591]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804595]  [unix_poll+197/208]
unix_poll+0xc5/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804598]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804603]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804607]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804612]
[sock_aio_write+257/272] sock_aio_write+0x101/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804619]
[sock_aio_write+0/272] sock_aio_write+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804623]
[do_sync_readv_writev+235/304] do_sync_readv_writev+0xeb/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.804629]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804634]
[do_sync_read+241/304] do_sync_read+0xf1/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.804639]
[rw_copy_check_uvector+149/304] rw_copy_check_uvector+0x95/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.804643]
[do_readv_writev+334/464] do_readv_writev+0x14e/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804648]  [d_kill+78/112]
d_kill+0x4e/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.804655]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.804658]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804663]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804664] hald-addon-ke S
00000000ffffffff     0  4444   4438
Aug 12 17:06:35 ghoststar kernel: [ 4791.804667]  ffff810039df3e88
0000000000000086 ffff81003c0b6100 ffff81003ff2c700
Aug 12 17:06:35 ghoststar kernel: [ 4791.804670]  ffff81003ff84e00
ffff81003d267500 0000000000000000 ffff81003ba8e000
Aug 12 17:06:35 ghoststar kernel: [ 4791.804674]  00002b4d2d1b0000
ffff81003c714468 ffff81003ba8e000 ffff810039df3ea8
Aug 12 17:06:35 ghoststar kernel: [ 4791.804677] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804683]  [evdev_read+245/640]
evdev_read+0xf5/0x280
Aug 12 17:06:35 ghoststar kernel: [ 4791.804686]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804690]
[do_mmap_pgoff+742/880] do_mmap_pgoff+0x2e6/0x370
Aug 12 17:06:35 ghoststar kernel: [ 4791.804694]  [vfs_read+196/352]
vfs_read+0xc4/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.804698]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.804702]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804706]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804707] hald-addon-ke R
running task        0  4445   4438
Aug 12 17:06:35 ghoststar kernel: [ 4791.804710] hald-addon-cp S
00000000ffffffff     0  4447   4438
Aug 12 17:06:35 ghoststar kernel: [ 4791.804713]  ffff81003a94bae8
0000000000000082 ffff81003a94bab8 ffff81003ff93500
Aug 12 17:06:35 ghoststar kernel: [ 4791.804716]  ffff81003a7e8e00
ffff81003a7e8e00 ffff81003a94bac8 ffffffff8022c937
Aug 12 17:06:35 ghoststar kernel: [ 4791.804719]  ffffffff8076b920
7fffffffffffffff ffff81003a94be24 ffff81003c002700
Aug 12 17:06:35 ghoststar kernel: [ 4791.804722] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804726]
[update_curr_load+135/160] update_curr_load+0x87/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804731]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804733]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804737]  [unix_poll+197/208]
unix_poll+0xc5/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804740]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804745]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804749]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804753]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804756]
[unix_stream_recvmsg+1183/1792] unix_stream_recvmsg+0x49f/0x700
Aug 12 17:06:35 ghoststar kernel: [ 4791.804762]
[find_lock_page+48/272] find_lock_page+0x30/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804766]
[filemap_fault+507/1200] filemap_fault+0x1fb/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804771]  [unlock_page+44/64]
unlock_page+0x2c/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804774]
[__do_fault+454/1104] __do_fault+0x1c6/0x450
Aug 12 17:06:35 ghoststar kernel: [ 4791.804780]
[handle_mm_fault+448/2224] handle_mm_fault+0x1c0/0x8b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804786]  [up_read+9/16]
up_read+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.804789]
[do_page_fault+499/2384] do_page_fault+0x1f3/0x950
Aug 12 17:06:35 ghoststar kernel: [ 4791.804796]  [sys_newfstat+46/64]
sys_newfstat+0x2e/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804801]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.804805]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804810]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804811] hald-addon-ac S
00000000ffffffff     0  4448   4438
Aug 12 17:06:35 ghoststar kernel: [ 4791.804814]  ffff810039f0dbc8
0000000000000086 ffff810039f0dbb8 ffff81003aa90e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.804817]  ffff81003a771500
ffff81003f613928 ffff810039f0db98 ffff810039f0dedf
Aug 12 17:06:35 ghoststar kernel: [ 4791.804820]  ffff810039f0dbb8
7fffffffffffffff 0000000000000000 0000000000000000
Aug 12 17:06:35 ghoststar kernel: [ 4791.804823] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804829]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.804849]
[_end+126292846/2128683288] :xfs:xfs_bmap_search_extents+0x56/0x100
Aug 12 17:06:35 ghoststar kernel: [ 4791.804854]
[unix_stream_recvmsg+992/1792] unix_stream_recvmsg+0x3e0/0x700
Aug 12 17:06:35 ghoststar kernel: [ 4791.804860]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804863]
[update_curr+224/288] update_curr+0xe0/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.804868]
[sock_aio_read+256/272] sock_aio_read+0x100/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.804877]
[do_sync_read+241/304] do_sync_read+0xf1/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.804880]  [vma_link+105/384]
vma_link+0x69/0x180
Aug 12 17:06:35 ghoststar kernel: [ 4791.804885]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804892]
[do_mmap_pgoff+742/880] do_mmap_pgoff+0x2e6/0x370
Aug 12 17:06:35 ghoststar kernel: [ 4791.804896]  [vfs_read+342/352]
vfs_read+0x156/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.804899]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.804903]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804908]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804909] hald-addon-ke S
00000000ffffffff     0  4452   4438
Aug 12 17:06:35 ghoststar kernel: [ 4791.804912]  ffff810039f71e88
0000000000000086 0000000000000000 ffff81003a7e8000
Aug 12 17:06:35 ghoststar kernel: [ 4791.804915]  ffff81003a77a700
00000002b9eac28d 0010007300000001 0000000000000000
Aug 12 17:06:35 ghoststar kernel: [ 4791.804918]  0000000000000000
ffff81003747ac68 ffff810039f9a000 ffff810039f71ea8
Aug 12 17:06:35 ghoststar kernel: [ 4791.804921] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804927]  [evdev_read+245/640]
evdev_read+0xf5/0x280
Aug 12 17:06:35 ghoststar kernel: [ 4791.804931]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804935]
[do_mmap_pgoff+742/880] do_mmap_pgoff+0x2e6/0x370
Aug 12 17:06:35 ghoststar kernel: [ 4791.804939]  [vfs_read+196/352]
vfs_read+0xc4/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.804942]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.804946]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804951]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804952] hald-addon-ke S
00000000ffffffff     0  4453   4438
Aug 12 17:06:35 ghoststar kernel: [ 4791.804955]  ffff810039e8de88
0000000000000086 0000000000000000 ffff81003cac4000
Aug 12 17:06:35 ghoststar kernel: [ 4791.804958]  ffff81003a77a700
00000002acfda90b 0010007300000001 0000000000000000
Aug 12 17:06:35 ghoststar kernel: [ 4791.804961]  0000000000000000
ffff81003746d068 ffff810039f9a800 ffff810039e8dea8
Aug 12 17:06:35 ghoststar kernel: [ 4791.804964] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.804970]  [evdev_read+245/640]
evdev_read+0xf5/0x280
Aug 12 17:06:35 ghoststar kernel: [ 4791.804974]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.804977]
[do_mmap_pgoff+742/880] do_mmap_pgoff+0x2e6/0x370
Aug 12 17:06:35 ghoststar kernel: [ 4791.804981]  [vfs_read+196/352]
vfs_read+0xc4/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.804985]  [sys_read+80/144]
sys_read+0x50/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.804989]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.804993]
Aug 12 17:06:35 ghoststar kernel: [ 4791.804994] hald-addon-st S
ffffffff8070c460     0  4458   4438
Aug 12 17:06:35 ghoststar kernel: [ 4791.804997]  ffff8100394c7ae8
0000000000000082 0000000000000000 ffff81003bf6e000
Aug 12 17:06:35 ghoststar kernel: [ 4791.805000]  ffffffff806b5360
00000001002593f7 ffff8100394c7ae8 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.805004]  0000000000000008
ffff8100394c7af8 00000001002593f7 ffff81003ceace00
Aug 12 17:06:35 ghoststar kernel: [ 4791.805007] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.805013]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805016]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805020]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805024]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805028]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805032]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805038]
[cdrom_lockdoor+162/288] cdrom_lockdoor+0xa2/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.805049]
[blk_end_sync_rq+0/64] blk_end_sync_rq+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.805053]
[blkdev_ioctl+713/1904] blkdev_ioctl+0x2c9/0x770
Aug 12 17:06:35 ghoststar kernel: [ 4791.805058]
[ide_cdrom_lock_door+15/32] ide_cdrom_lock_door+0xf/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.805062]
[cdrom_release+172/624] cdrom_release+0xac/0x270
Aug 12 17:06:35 ghoststar kernel: [ 4791.805065]
[blkdev_open+108/128] blkdev_open+0x6c/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.805069]  [ide_cd_put+55/64]
ide_cd_put+0x37/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.805073]  [iput+70/144] iput+0x46/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.805076]  [bdput+13/16] bdput+0xd/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805078]
[__blkdev_put+298/384] __blkdev_put+0x12a/0x180
Aug 12 17:06:35 ghoststar kernel: [ 4791.805082]  [blkdev_put+11/16]
blkdev_put+0xb/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805086]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805089]  [__fput+375/464]
__fput+0x177/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805094]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.805098]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.805102]
Aug 12 17:06:35 ghoststar kernel: [ 4791.805103] hald-addon-st S
ffffffff8070c460     0  4460   4438
Aug 12 17:06:35 ghoststar kernel: [ 4791.805106]  ffff8100394f7ae8
0000000000000082 0000000000000000 ffff81003bf6f500
Aug 12 17:06:35 ghoststar kernel: [ 4791.805109]  ffffffff806b5360
00000001002593fa ffff8100394f7ae8 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.805112]  0000000000000008
ffff8100394f7af8 00000001002593fa ffff81003cecd400
Aug 12 17:06:35 ghoststar kernel: [ 4791.805115] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.805121]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805125]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805128]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805132]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805137]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805140]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805146]
[cdrom_lockdoor+162/288] cdrom_lockdoor+0xa2/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.805156]
[blk_end_sync_rq+0/64] blk_end_sync_rq+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.805160]
[blkdev_ioctl+713/1904] blkdev_ioctl+0x2c9/0x770
Aug 12 17:06:35 ghoststar kernel: [ 4791.805165]
[ide_cdrom_lock_door+15/32] ide_cdrom_lock_door+0xf/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.805168]
[cdrom_release+172/624] cdrom_release+0xac/0x270
Aug 12 17:06:35 ghoststar kernel: [ 4791.805171]
[blkdev_open+108/128] blkdev_open+0x6c/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.805176]  [ide_cd_put+55/64]
ide_cd_put+0x37/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.805179]  [iput+70/144] iput+0x46/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.805182]  [bdput+13/16] bdput+0xd/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805184]
[__blkdev_put+298/384] __blkdev_put+0x12a/0x180
Aug 12 17:06:35 ghoststar kernel: [ 4791.805189]  [blkdev_put+11/16]
blkdev_put+0xb/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805192]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805195]  [__fput+375/464]
__fput+0x177/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805200]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.805204]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.805209]
Aug 12 17:06:35 ghoststar kernel: [ 4791.805210] dhcdbd        S
ffffffff8070c460     0  4473      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.805212]  ffff8100394fb9b8
0000000000000082 0000000000000005 ffff81003a604000
Aug 12 17:06:35 ghoststar kernel: [ 4791.805216]  ffffffff806b5360
000000010025927e ffff8100394fb9b8 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.805219]  0000000000000206
ffff8100394fb9c8 000000010025927e ffff81003c0acc00
Aug 12 17:06:35 ghoststar kernel: [ 4791.805222] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.805228]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805231]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805235]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805239]
[do_select+1275/1536] do_select+0x4fb/0x600
Aug 12 17:06:35 ghoststar kernel: [ 4791.805246]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805249]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805258]  [get_pid_task+29/96]
get_pid_task+0x1d/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.805261]
[pid_revalidate+39/384] pid_revalidate+0x27/0x180
Aug 12 17:06:35 ghoststar kernel: [ 4791.805265]  [do_lookup+132/512]
do_lookup+0x84/0x200
Aug 12 17:06:35 ghoststar kernel: [ 4791.805269]  [dput+36/480] dput+0x24/0x1e0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805273]
[__link_path_walk+4071/4176] __link_path_walk+0xfe7/0x1050
Aug 12 17:06:35 ghoststar kernel: [ 4791.805279]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805283]
[link_path_walk+143/272] link_path_walk+0x8f/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805287]
[core_sys_select+510/784] core_sys_select+0x1fe/0x310
Aug 12 17:06:35 ghoststar kernel: [ 4791.805294]  [path_walk+28/32]
path_walk+0x1c/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.805297]
[do_path_lookup+185/656] do_path_lookup+0xb9/0x290
Aug 12 17:06:35 ghoststar kernel: [ 4791.805300]
[strncpy_from_user+58/80] strncpy_from_user+0x3a/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.805304]  [in_group_p+42/48]
in_group_p+0x2a/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.805308]
[generic_permission+103/304] generic_permission+0x67/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.805311]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805315]  [path_release+44/64]
path_release+0x2c/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.805319]
[sys_faccessat+392/416] sys_faccessat+0x188/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805324]  [sys_select+196/416]
sys_select+0xc4/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805330]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.805335]
Aug 12 17:06:35 ghoststar kernel: [ 4791.805336] NetworkManage S
00000000ffffffff     0  4488      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.805338]  ffff810039919ae8
0000000000000086 ffff810039919ab8 ffff81003c447500
Aug 12 17:06:35 ghoststar kernel: [ 4791.805342]  ffff81003a77a700
ffff81003a7e8e00 ffff810039919ac8 ffffffff8022c937
Aug 12 17:06:35 ghoststar kernel: [ 4791.805345]  ffffffff8076b920
7fffffffffffffff ffff810039919e34 ffff81003c1dc000
Aug 12 17:06:35 ghoststar kernel: [ 4791.805348] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.805352]
[update_curr_load+135/160] update_curr_load+0x87/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805356]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805359]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805363]  [unix_poll+197/208]
unix_poll+0xc5/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805366]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805371]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805374]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805379]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805383]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805387]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805390]
[sock_sendmsg+223/272] sock_sendmsg+0xdf/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805394]
[link_path_walk+143/272] link_path_walk+0x8f/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805399]
[sock_aio_read+256/272] sock_aio_read+0x100/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805407]
[do_sync_read+241/304] do_sync_read+0xf1/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.805412]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.805422]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.805426]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.805431]
Aug 12 17:06:35 ghoststar kernel: [ 4791.805432] NetworkManage S
ffffffff8070c460     0  4497      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.805434]  ffff810039b03ae8
0000000000000086 000000008023c1db ffff81003a770000
Aug 12 17:06:35 ghoststar kernel: [ 4791.805438]  ffffffff806b5360
0000000100259393 ffff810039b03ae8 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.805441]  0000000401936912
ffff810039b03af8 0000000100259393 ffff81003cecd800
Aug 12 17:06:35 ghoststar kernel: [ 4791.805444] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.805450]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805454]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805457]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805461]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805466]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805469]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805475]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805479]
[link_path_walk+143/272] link_path_walk+0x8f/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805483]  [number+715/768]
number+0x2cb/0x300
Aug 12 17:06:35 ghoststar kernel: [ 4791.805487]
[get_unused_fd_flags+120/336] get_unused_fd_flags+0x78/0x150
Aug 12 17:06:35 ghoststar kernel: [ 4791.805491]
[__slab_alloc+293/1424] __slab_alloc+0x125/0x590
Aug 12 17:06:35 ghoststar kernel: [ 4791.805494]
[get_empty_filp+57/320] get_empty_filp+0x39/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.805499]  [vsnprintf+700/1680]
vsnprintf+0x2bc/0x690
Aug 12 17:06:35 ghoststar kernel: [ 4791.805503]  [sprintf+104/112]
sprintf+0x68/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.805510]
[__alloc_pages+110/800] __alloc_pages+0x6e/0x320
Aug 12 17:06:35 ghoststar kernel: [ 4791.805515]
[free_hot_page+11/16] free_hot_page+0xb/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805518]  [__free_pages+37/48]
__free_pages+0x25/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.805522]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805526]  [__fput+375/464]
__fput+0x177/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805531]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.805534]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.805539]
Aug 12 17:06:35 ghoststar kernel: [ 4791.805540] NetworkManage S
00000000ffffffff     0  4508      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.805543]  ffff810039b0dae8
0000000000000086 ffff810039b0dab8 ffff81003aa90000
Aug 12 17:06:35 ghoststar kernel: [ 4791.805546]  ffff81003ff2c000
ffff81003a7e8e00 ffff810039b0dac8 ffffffff8022c937
Aug 12 17:06:35 ghoststar kernel: [ 4791.805549]  ffffffff8076b920
7fffffffffffffff ffff810039b0de24 ffff8100376f4400
Aug 12 17:06:35 ghoststar kernel: [ 4791.805552] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.805556]
[update_curr_load+135/160] update_curr_load+0x87/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805561]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805564]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805567]  [unix_poll+197/208]
unix_poll+0xc5/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805571]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805575]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805579]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805583]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805593]
[__dequeue_signal+28/480] __dequeue_signal+0x1c/0x1e0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805597]  [unlock_page+44/64]
unlock_page+0x2c/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.805600]
[do_wp_page+1068/1568] do_wp_page+0x42c/0x620
Aug 12 17:06:35 ghoststar kernel: [ 4791.805605]
[handle_mm_fault+1702/2224] handle_mm_fault+0x6a6/0x8b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805614]  [up_read+9/16]
up_read+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805617]
[do_page_fault+499/2384] do_page_fault+0x1f3/0x950
Aug 12 17:06:35 ghoststar kernel: [ 4791.805619]  [filldir64+0/224]
filldir64+0x0/0xe0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805625]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805628]  [__fput+375/464]
__fput+0x177/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805634]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.805637]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.805642]
Aug 12 17:06:35 ghoststar kernel: [ 4791.805643] system-tools- S
00000000ffffffff     0  4521      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.805646]  ffff810039b5fae8
0000000000000082 ffff810039b5fab8 ffff810039b5c000
Aug 12 17:06:35 ghoststar kernel: [ 4791.805649]  ffff81003bf6ee00
ffff81003a7e8e00 ffff810039b5fac8 ffffffff8022c937
Aug 12 17:06:35 ghoststar kernel: [ 4791.805652]  ffffffff8076b920
7fffffffffffffff ffff810039b5fe24 ffff81003cead100
Aug 12 17:06:35 ghoststar kernel: [ 4791.805655] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.805659]
[update_curr_load+135/160] update_curr_load+0x87/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805664]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805667]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805670]  [unix_poll+197/208]
unix_poll+0xc5/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805673]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805678]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805682]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805686]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805689]
[unix_stream_recvmsg+1183/1792] unix_stream_recvmsg+0x49f/0x700
Aug 12 17:06:35 ghoststar kernel: [ 4791.805695]
[find_lock_page+48/272] find_lock_page+0x30/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805699]
[filemap_fault+507/1200] filemap_fault+0x1fb/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805704]  [unlock_page+44/64]
unlock_page+0x2c/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.805707]
[__do_fault+454/1104] __do_fault+0x1c6/0x450
Aug 12 17:06:35 ghoststar kernel: [ 4791.805713]
[handle_mm_fault+448/2224] handle_mm_fault+0x1c0/0x8b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805719]  [up_read+9/16]
up_read+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805722]
[do_page_fault+499/2384] do_page_fault+0x1f3/0x950
Aug 12 17:06:35 ghoststar kernel: [ 4791.805728]  [do_wait+1931/3696]
do_wait+0x78b/0xe70
Aug 12 17:06:35 ghoststar kernel: [ 4791.805733]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805737]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.805741]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.805745]
Aug 12 17:06:35 ghoststar kernel: [ 4791.805746] dbus-daemon   S
00000000ffffffff     0  4522   4521
Aug 12 17:06:35 ghoststar kernel: [ 4791.805749]  ffff8100398dbae8
0000000000000086 ffff8100398dbab8 ffff81003bf6ee00
Aug 12 17:06:35 ghoststar kernel: [ 4791.805752]  ffff81003c447500
ffff810039b5c000 ffff8100398dbad8 0000000000000082
Aug 12 17:06:35 ghoststar kernel: [ 4791.805756]  ffff8100398dbb08
7fffffffffffffff ffff8100398dbe2c ffff810037d4fd00
Aug 12 17:06:35 ghoststar kernel: [ 4791.805759] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.805765]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805767]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805771]  [unix_poll+197/208]
unix_poll+0xc5/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805774]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805779]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805783]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805787]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805791]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805797]
[sock_aio_write+0/272] sock_aio_write+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805801]
[do_sync_readv_writev+235/304] do_sync_readv_writev+0xeb/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.805807]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.805812]
[page_add_new_anon_rmap+28/48] page_add_new_anon_rmap+0x1c/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.805815]
[handle_mm_fault+2057/2224] handle_mm_fault+0x809/0x8b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805820]
[rw_copy_check_uvector+149/304] rw_copy_check_uvector+0x95/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.805824]
[do_readv_writev+334/464] do_readv_writev+0x14e/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805849]
[_end+126574598/2128683288] :xfs:xfs_release+0x18e/0x260
Aug 12 17:06:35 ghoststar kernel: [ 4791.805857]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.805860]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.805865]
Aug 12 17:06:35 ghoststar kernel: [ 4791.805866] gdm           S
00000000ffffffff     0  4574      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.805869]  ffff81003d095ae8
0000000000000082 ffff81003831b410 ffff810037eb8700
Aug 12 17:06:35 ghoststar kernel: [ 4791.805872]  ffff810031526e00
ffff810031526e00 ffff81003d095b28 ffff81003831b410
Aug 12 17:06:35 ghoststar kernel: [ 4791.805876]  ffff81003d095b08
7fffffffffffffff ffff81003d095e2c ffff810037ed6e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.805879] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.805885]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805888]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805891]  [unix_poll+197/208]
unix_poll+0xc5/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805895]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805899]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805903]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805907]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805911]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805916]
[sock_sendmsg+223/272] sock_sendmsg+0xdf/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805920]
[link_path_walk+143/272] link_path_walk+0x8f/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805925]
[sock_aio_read+256/272] sock_aio_read+0x100/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.805933]
[do_sync_read+241/304] do_sync_read+0xf1/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.805939]  [__d_free+48/64]
__d_free+0x30/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.805942]  [d_free+73/80]
d_free+0x49/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.805946]  [d_kill+78/112]
d_kill+0x4e/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.805950]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805953]  [__fput+375/464]
__fput+0x177/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.805958]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.805961]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.805966]
Aug 12 17:06:35 ghoststar kernel: [ 4791.805967] gdm           S
00000000ffffffff     0  4577   4574
Aug 12 17:06:35 ghoststar kernel: [ 4791.805970]  ffff8100399adea8
0000000000000086 ffff8100399ade88 ffff81003ff28000
Aug 12 17:06:35 ghoststar kernel: [ 4791.805973]  ffff810037eb8000
0000000000000282 0000000000000000 000000000000000f
Aug 12 17:06:35 ghoststar kernel: [ 4791.805976]  ffff8100399adec8
ffff810037eb8160 ffff81003ff28150 ffff810037eb8000
Aug 12 17:06:35 ghoststar kernel: [ 4791.805979] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.805985]  [do_wait+2152/3696]
do_wait+0x868/0xe70
Aug 12 17:06:35 ghoststar kernel: [ 4791.805989]  [sys_kill+152/512]
sys_kill+0x98/0x200
Aug 12 17:06:35 ghoststar kernel: [ 4791.805993]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.805999]  [sys_wait4+44/48]
sys_wait4+0x2c/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.806001]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806006]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806007] Xorg          D
0000000000000000     0  4578   4577
Aug 12 17:06:35 ghoststar kernel: [ 4791.806010]  ffff81003d52dd28
0000000000000086 ffff81003d52dce8 ffff810037eb8000
Aug 12 17:06:35 ghoststar kernel: [ 4791.806013]  ffff81003fe3d500
0000000000000096 0000000000000001 ffff81003ffc8e40
Aug 12 17:06:35 ghoststar kernel: [ 4791.806016]  ffff81003bbdb600
ffff81003d52dda8 0000000000000000 0000000000000000
Aug 12 17:06:35 ghoststar kernel: [ 4791.806019] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.806025]
[wait_for_completion+186/320] wait_for_completion+0xba/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.806029]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806034]
[flush_cpu_workqueue+137/176] flush_cpu_workqueue+0x89/0xb0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806038]
[wq_barrier_func+0/16] wq_barrier_func+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806041]
[vcs_remove_sysfs+62/80] vcs_remove_sysfs+0x3e/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.806045]
[flush_workqueue+12/16] flush_workqueue+0xc/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806049]
[flush_scheduled_work+16/32] flush_scheduled_work+0x10/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.806052]
[release_dev+939/1984] release_dev+0x3ab/0x7c0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806056]  [up_read+9/16]
up_read+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806059]
[do_page_fault+499/2384] do_page_fault+0x1f3/0x950
Aug 12 17:06:35 ghoststar kernel: [ 4791.806065]  [tty_release+25/48]
tty_release+0x19/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.806068]  [__fput+179/464]
__fput+0xb3/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806072]  [fput+21/32] fput+0x15/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.806075]  [filp_close+86/144]
filp_close+0x56/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.806079]  [sys_close+177/320]
sys_close+0xb1/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.806083]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806087]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806088] dhclient      S
00000000ffffffff     0  4585   4473
Aug 12 17:06:35 ghoststar kernel: [ 4791.806091]  ffff81003d07d9b8
0000000000000086 ffff81003a0c2d00 ffff81003fe3ce00
Aug 12 17:06:35 ghoststar kernel: [ 4791.806094]  ffff810037eb8000
00000001002c6ca6 ffff81003d07d9b8 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.806098]  ffff81003d07d9b8
ffff81003d07d9c8 00000001002c6ca6 ffff810038e80000
Aug 12 17:06:35 ghoststar kernel: [ 4791.806101] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.806107]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806110]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806114]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806118]
[do_select+1275/1536] do_select+0x4fb/0x600
Aug 12 17:06:35 ghoststar kernel: [ 4791.806125]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806129]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806133]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806136]
[default_wake_function+13/16] default_wake_function+0xd/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806140]
[__wake_up_common+71/112] __wake_up_common+0x47/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.806146]
[sock_def_readable+133/160] sock_def_readable+0x85/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806149]
[unix_dgram_sendmsg+1342/1584] unix_dgram_sendmsg+0x53e/0x630
Aug 12 17:06:35 ghoststar kernel: [ 4791.806156]
[sock_sendmsg+223/272] sock_sendmsg+0xdf/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806160]
[link_path_walk+143/272] link_path_walk+0x8f/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806165]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.806170]
[core_sys_select+510/784] core_sys_select+0x1fe/0x310
Aug 12 17:06:35 ghoststar kernel: [ 4791.806178]  [up_read+9/16]
up_read+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806181]
[do_page_fault+499/2384] do_page_fault+0x1f3/0x950
Aug 12 17:06:35 ghoststar kernel: [ 4791.806184]  [sys_sendto+273/320]
sys_sendto+0x111/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.806191]  [sys_select+196/416]
sys_select+0xc4/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806196]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806201]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806202] cupsd         S
ffffffff8070c460     0  4666      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.806205]  ffff810038def9b8
0000000000000086 ffff810038def9b8 ffff81003743c700
Aug 12 17:06:35 ghoststar kernel: [ 4791.806208]  ffffffff806b5360
000000010026d3ff ffff810038def9b8 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.806212]  ffff810038def9e8
ffff810038def9c8 000000010026d3ff ffff81003cecd500
Aug 12 17:06:35 ghoststar kernel: [ 4791.806215] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.806221]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806224]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806228]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806231]
[do_select+1275/1536] do_select+0x4fb/0x600
Aug 12 17:06:35 ghoststar kernel: [ 4791.806239]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806242]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806246]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806250]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806254]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806258]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806264]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806268]
[link_path_walk+143/272] link_path_walk+0x8f/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806272]  [d_kill+78/112]
d_kill+0x4e/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.806277]
[get_unused_fd_flags+120/336] get_unused_fd_flags+0x78/0x150
Aug 12 17:06:35 ghoststar kernel: [ 4791.806281]
[__slab_alloc+293/1424] __slab_alloc+0x125/0x590
Aug 12 17:06:35 ghoststar kernel: [ 4791.806285]
[core_sys_select+510/784] core_sys_select+0x1fe/0x310
Aug 12 17:06:35 ghoststar kernel: [ 4791.806291]  [path_release+44/64]
path_release+0x2c/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.806295]
[open_namei+168/1760] open_namei+0xa8/0x6e0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806299]
[destroy_inode+46/80] destroy_inode+0x2e/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.806304]  [do_filp_open+40/80]
do_filp_open+0x28/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.806310]  [sys_select+196/416]
sys_select+0xc4/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806315]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806320]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806321] hpiod         S
00000000ffffffff     0  4688      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.806324]  ffff810038ca3d78
0000000000000082 ffff810038ca3d38 ffff810039b5d500
Aug 12 17:06:35 ghoststar kernel: [ 4791.806327]  ffff810037eb8000
ffff810001c3c838 ffff810038ca3db8 ffffffff8026fa36
Aug 12 17:06:35 ghoststar kernel: [ 4791.806331]  ffff810038f64b48
7fffffffffffffff 0000000000000000 7fffffffffffffff
Aug 12 17:06:35 ghoststar kernel: [ 4791.806333] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.806337]
[__do_fault+454/1104] __do_fault+0x1c6/0x450
Aug 12 17:06:35 ghoststar kernel: [ 4791.806342]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806345]
[lock_sock_nested+254/272] lock_sock_nested+0xfe/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806350]
[release_sock+215/240] release_sock+0xd7/0xf0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806354]
[inet_csk_accept+360/672] inet_csk_accept+0x168/0x2a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806357]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.806364]  [inet_accept+38/208]
inet_accept+0x26/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806367]  [sys_accept+253/496]
sys_accept+0xfd/0x1f0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806372]
[recalc_sigpending_and_wake+17/48]
recalc_sigpending_and_wake+0x11/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.806375]
[do_sigaction+364/480] do_sigaction+0x16c/0x1e0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806382]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806387]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806388] python        S
ffffffff8070c460     0  4709      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.806391]  ffff81003861f9b8
0000000000000086 ffffffff8023c1db ffff810037eb8e00
Aug 12 17:06:35 ghoststar kernel: [ 4791.806394]  ffffffff806b5360
0000000100259571 ffff81003861f9b8 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.806397]  0000000012c6f000
ffff81003861f9c8 0000000100259571 ffff81003899fd00
Aug 12 17:06:35 ghoststar kernel: [ 4791.806400] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.806403]
[__mod_timer+203/288] __mod_timer+0xcb/0x120
Aug 12 17:06:35 ghoststar kernel: [ 4791.806408]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806412]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806415]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806419]
[do_select+1275/1536] do_select+0x4fb/0x600
Aug 12 17:06:35 ghoststar kernel: [ 4791.806426]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806430]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806435]  [lookup_mnt+34/112]
lookup_mnt+0x22/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.806440]  [do_lookup+132/512]
do_lookup+0x84/0x200
Aug 12 17:06:35 ghoststar kernel: [ 4791.806443]  [dput+36/480] dput+0x24/0x1e0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806447]
[__link_path_walk+2049/4176] __link_path_walk+0x801/0x1050
Aug 12 17:06:35 ghoststar kernel: [ 4791.806455]
[find_lock_page+48/272] find_lock_page+0x30/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806459]
[filemap_fault+507/1200] filemap_fault+0x1fb/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806466]
[core_sys_select+510/784] core_sys_select+0x1fe/0x310
Aug 12 17:06:35 ghoststar kernel: [ 4791.806474]  [up_read+9/16]
up_read+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806477]
[do_page_fault+499/2384] do_page_fault+0x1f3/0x950
Aug 12 17:06:35 ghoststar kernel: [ 4791.806485]  [sys_select+196/416]
sys_select+0xc4/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806490]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806495]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806496] cannaserver   S
ffffffff8070c460     0  4754      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.806499]  ffff8100389c39b8
0000000000000082 ffff8100389c3998 ffff810038e1a700
Aug 12 17:06:35 ghoststar kernel: [ 4791.806502]  ffffffff806b5360
000000010025ccea ffff8100389c39b8 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.806505]  ffff810038c73350
ffff8100389c39c8 000000010025ccea ffff81003c10ed00
Aug 12 17:06:35 ghoststar kernel: [ 4791.806508] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.806514]
[schedule_timeout+99/208] schedule_timeout+0x63/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806518]
[process_timeout+0/16] process_timeout+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806521]
[schedule_timeout+94/208] schedule_timeout+0x5e/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806525]
[do_select+1275/1536] do_select+0x4fb/0x600
Aug 12 17:06:35 ghoststar kernel: [ 4791.806532]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806536]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806561]
[_end+126428964/2128683288] :xfs:xfs_iunlock+0x6c/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806582]
[_end+126574005/2128683288] :xfs:xfs_getattr+0x27d/0x340
Aug 12 17:06:35 ghoststar kernel: [ 4791.806604]
[_end+126628969/2128683288] :xfs:__vn_revalidate+0x41/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806626]
[_end+126613261/2128683288] :xfs:xfs_vn_setattr+0x135/0x190
Aug 12 17:06:35 ghoststar kernel: [ 4791.806634]
[find_lock_page+48/272] find_lock_page+0x30/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806637]
[mark_page_accessed+59/80] mark_page_accessed+0x3b/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.806641]
[filemap_fault+507/1200] filemap_fault+0x1fb/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806646]  [unlock_page+44/64]
unlock_page+0x2c/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.806650]
[core_sys_select+510/784] core_sys_select+0x1fe/0x310
Aug 12 17:06:35 ghoststar kernel: [ 4791.806659]  [up_read+9/16]
up_read+0x9/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806661]
[do_page_fault+499/2384] do_page_fault+0x1f3/0x950
Aug 12 17:06:35 ghoststar kernel: [ 4791.806669]  [sys_select+196/416]
sys_select+0xc4/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806675]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806679]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806681] sshd          S
00000000ffffffff     0  4767      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.806683]  ffff81003885f9b8
0000000000000086 ffff81003cc82000 ffff81003a770700
Aug 12 17:06:35 ghoststar kernel: [ 4791.806687]  ffff810037eb8000
ffff810035964000 ffff81003d1291f8 00000000000003f9
Aug 12 17:06:35 ghoststar kernel: [ 4791.806690]  ffff81003885f998
7fffffffffffffff 0000000000000008 ffff810037675b00
Aug 12 17:06:35 ghoststar kernel: [ 4791.806693] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.806699]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806702]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806706]  [tcp_poll+301/432]
tcp_poll+0x12d/0x1b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806709]
[do_select+1275/1536] do_select+0x4fb/0x600
Aug 12 17:06:35 ghoststar kernel: [ 4791.806717]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806720]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806724]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806730]
[__alloc_skb+138/352] __alloc_skb+0x8a/0x160
Aug 12 17:06:35 ghoststar kernel: [ 4791.806735]
[sock_alloc_send_skb+408/496] sock_alloc_send_skb+0x198/0x1f0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806739]  [number+715/768]
number+0x2cb/0x300
Aug 12 17:06:35 ghoststar kernel: [ 4791.806743]
[unix_stream_sendmsg+499/1024] unix_stream_sendmsg+0x1f3/0x400
Aug 12 17:06:35 ghoststar kernel: [ 4791.806747]
[__slab_free+536/928] __slab_free+0x218/0x3a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806752]
[proc_delete_inode+0/96] proc_delete_inode+0x0/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.806755]
[proc_destroy_inode+20/32] proc_destroy_inode+0x14/0x20
Aug 12 17:06:35 ghoststar kernel: [ 4791.806759]
[proc_delete_inode+0/96] proc_delete_inode+0x0/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.806763]
[core_sys_select+510/784] core_sys_select+0x1fe/0x310
Aug 12 17:06:35 ghoststar kernel: [ 4791.806769]  [d_kill+78/112]
d_kill+0x4e/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.806773]  [init_fpu+83/176]
init_fpu+0x53/0xb0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806777]
[math_state_restore+72/96] math_state_restore+0x48/0x60
Aug 12 17:06:35 ghoststar kernel: [ 4791.806781]  [error_exit+0/132]
error_exit+0x0/0x84
Aug 12 17:06:35 ghoststar kernel: [ 4791.806789]  [sys_select+65/416]
sys_select+0x41/0x1a0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806794]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806799]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806800] atd           S
00000000ffffffff     0  4848      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.806803]  ffff81003805be78
0000000000000086 ffff81003805be38 ffff81003a605500
Aug 12 17:06:35 ghoststar kernel: [ 4791.806806]  ffff810035964000
ffff81003805beb8 ffff81003805be78 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.806809]  0000000000000002
ffff81003805beb8 0000000000000001 ffff81003805beb8
Aug 12 17:06:35 ghoststar kernel: [ 4791.806812] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.806818]
[do_nanosleep+99/144] do_nanosleep+0x63/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.806822]
[hrtimer_nanosleep+111/320] hrtimer_nanosleep+0x6f/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.806826]
[hrtimer_wakeup+0/48] hrtimer_wakeup+0x0/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.806830]
[do_nanosleep+87/144] do_nanosleep+0x57/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.806835]
[sys_nanosleep+111/128] sys_nanosleep+0x6f/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.806839]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806844]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806845] cron          S
00000000ffffffff     0  4852      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.806848]  ffff8100386e7e78
0000000000000082 ffff8100386e7e38 ffff810037e0c700
Aug 12 17:06:35 ghoststar kernel: [ 4791.806851]  ffff81003fe16e00
ffff8100386e7eb8 ffff8100386e7e78 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.806854]  0000000000000001
ffff8100386e7eb8 0000000000000001 ffff8100386e7eb8
Aug 12 17:06:35 ghoststar kernel: [ 4791.806857] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.806863]
[do_nanosleep+99/144] do_nanosleep+0x63/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.806867]
[hrtimer_nanosleep+111/320] hrtimer_nanosleep+0x6f/0x140
Aug 12 17:06:35 ghoststar kernel: [ 4791.806871]
[hrtimer_wakeup+0/48] hrtimer_wakeup+0x0/0x30
Aug 12 17:06:35 ghoststar kernel: [ 4791.806875]
[do_nanosleep+87/144] do_nanosleep+0x57/0x90
Aug 12 17:06:35 ghoststar kernel: [ 4791.806880]
[sys_nanosleep+111/128] sys_nanosleep+0x6f/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.806884]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806889]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806890] bonobo-activa S
00000000ffffffff     0  5181      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.806893]  ffff810030e9fae8
0000000000000082 ffff810035d57dc0 ffff81003a77ae00
Aug 12 17:06:35 ghoststar kernel: [ 4791.806896]  ffff810031527500
ffff810031527500 ffff810030e9fad8 0000000000000286
Aug 12 17:06:35 ghoststar kernel: [ 4791.806899]  00000000000004d0
7fffffffffffffff ffff810030e9fe24 ffff810031339f00
Aug 12 17:06:35 ghoststar kernel: [ 4791.806902] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.806908]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806911]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806915]  [pipe_poll+157/160]
pipe_poll+0x9d/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806918]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806923]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806927]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806931]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806935]
[sock_aio_write+257/272] sock_aio_write+0x101/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806938]
[check_preempt_curr_fair+65/112] check_preempt_curr_fair+0x41/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.806943]
[default_wake_function+13/16] default_wake_function+0xd/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.806947]
[sock_aio_write+0/272] sock_aio_write+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.806950]
[do_sync_readv_writev+235/304] do_sync_readv_writev+0xeb/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.806956]
[autoremove_wake_function+0/64] autoremove_wake_function+0x0/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.806962]
[do_sync_write+241/304] do_sync_write+0xf1/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.806966]
[rw_copy_check_uvector+149/304] rw_copy_check_uvector+0x95/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.806971]
[do_readv_writev+334/464] do_readv_writev+0x14e/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.806980]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.806984]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.806988]
Aug 12 17:06:35 ghoststar kernel: [ 4791.806990] bonobo-activa S
00000000ffffffff     0  5182      1
Aug 12 17:06:35 ghoststar kernel: [ 4791.806992]  ffff8100312b9ae8
0000000000000082 ffff8100312b9ab8 ffff810031527500
Aug 12 17:06:35 ghoststar kernel: [ 4791.806996]  ffff810031526000
ffff810031526000 ffff8100312b9ac8 ffffffff8022c937
Aug 12 17:06:35 ghoststar kernel: [ 4791.806999]  ffffffff8076b920
7fffffffffffffff ffff8100312b9e2c ffff81003132df00
Aug 12 17:06:35 ghoststar kernel: [ 4791.807002] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.807006]
[update_curr_load+135/160] update_curr_load+0x87/0xa0
Aug 12 17:06:35 ghoststar kernel: [ 4791.807010]
[schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.807013]  [__pollwait+135/272]
__pollwait+0x87/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.807017]  [unix_poll+197/208]
unix_poll+0xc5/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.807020]
[do_sys_poll+774/1200] do_sys_poll+0x306/0x4b0
Aug 12 17:06:35 ghoststar kernel: [ 4791.807025]  [__pollwait+0/272]
__pollwait+0x0/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.807029]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.807033]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.807037]
[default_wake_function+0/16] default_wake_function+0x0/0x10
Aug 12 17:06:35 ghoststar kernel: [ 4791.807045]
[sock_aio_read+256/272] sock_aio_read+0x100/0x110
Aug 12 17:06:35 ghoststar kernel: [ 4791.807052]
[do_sync_read+241/304] do_sync_read+0xf1/0x130
Aug 12 17:06:35 ghoststar kernel: [ 4791.807059]  [__d_free+48/64]
__d_free+0x30/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.807062]  [d_free+73/80]
d_free+0x49/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.807065]  [d_kill+78/112]
d_kill+0x4e/0x70
Aug 12 17:06:35 ghoststar kernel: [ 4791.807069]
[mntput_no_expire+32/208] mntput_no_expire+0x20/0xd0
Aug 12 17:06:35 ghoststar kernel: [ 4791.807072]  [__fput+375/464]
__fput+0x177/0x1d0
Aug 12 17:06:35 ghoststar kernel: [ 4791.807077]  [sys_poll+51/80]
sys_poll+0x33/0x50
Aug 12 17:06:35 ghoststar kernel: [ 4791.807081]
[system_call+126/131] system_call+0x7e/0x83
Aug 12 17:06:35 ghoststar kernel: [ 4791.807086]
Aug 12 17:06:35 ghoststar kernel: [ 4791.807087] pdflush       S
00000000ffffffff     0  5724      2
Aug 12 17:06:35 ghoststar kernel: [ 4791.807090]  ffff8100097f3eb0
0000000000000046 ffff8100097f3e60 ffff81003746a700
Aug 12 17:06:35 ghoststar kernel: [ 4791.807093]  ffff81003a7e8700
ffffffff80268f50 ffff8100097f3e90 ffffffff802ae1c9
Aug 12 17:06:35 ghoststar kernel: [ 4791.807096]  0000000000000000
ffff8100097f3ed8 0000000000000000 ffffffff80268f50
Aug 12 17:06:35 ghoststar kernel: [ 4791.807099] Call Trace:
Aug 12 17:06:35 ghoststar kernel: [ 4791.807102]  [pdflush+0/656]
pdflush+0x0/0x290
Aug 12 17:06:35 ghoststar kernel: [ 4791.807105]  [sync_inodes+25/64]
sync_inodes+0x19/0x40
Aug 12 17:06:35 ghoststar kernel: [ 4791.807109]  [pdflush+0/656]
pdflush+0x0/0x290
Aug 12 17:06:35 ghoststar kernel: [ 4791.807111]  [pdflush+246/656]
pdflush+0xf6/0x290
Aug 12 17:06:35 ghoststar kernel: [ 4791.807115]  [pdflush+0/656]
pdflush+0x0/0x290
Aug 12 17:06:35 ghoststar kernel: [ 4791.807119]  [kthread+77/128]
kthread+0x4d/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.807122]  [child_rip+10/18]
child_rip+0xa/0x12
Aug 12 17:06:35 ghoststar kernel: [ 4791.807128]  [kthread+0/128]
kthread+0x0/0x80
Aug 12 17:06:35 ghoststar kernel: [ 4791.807131]  [child_rip+0/18]
child_rip+0x0/0x12
