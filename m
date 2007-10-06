Return-Path: <linux-kernel-owner+w=401wt.eu-S1765414AbXJFUOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765414AbXJFUOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 16:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbXJFUOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 16:14:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:43122 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXJFUO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 16:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=jFS6zNp5SGqFqgPDy/QDerFk5Zjf1mU9AUwfL2zK3LIN4gHjJL78lwW7RJx0CibqQINiM8yy1p/AkYw2IymqHAIMuZJrzxPph1+Qigkrpiar6OWwZr0VMneJwizzZxCwapw5ROoaW3OafcGvTE7RShasVJdCJhQfmGy2lzg+CoM=
Date: Sat, 6 Oct 2007 22:14:06 +0200
To: linux-kernel@vger.kernel.org
Subject: [Oops] on 2.6.23-rc9 sysRq Show Tasks (t)
Message-ID: <20071006201405.GA2530@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Pressing sysRq+T always produce an Oops for every running system task (94 
Oopses, that's a record ;)).
The bug is 100% reproducable. Should I begin bisecting/investigating the 
issue or it's a known problem ?

$ ver_linux
Linux darwish-laptop 2.6.23-rc9 #23 Sat Oct 6 21:48:45 EET 2007 i686 GNU/Linux
 
Gnu C                  4.0.3
Gnu make               3.81beta4
binutils               2.16.91
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.38
Linux C Library        3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.6
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.93
udev                   079

[  226.309874] SysRq : Show State
[  226.309948]   task                PC stack   pid father
[  226.310105] init          S c1465b64     0     1      0
[  226.310195]        c1465b54 00000082 00000286 c1465b64 c04255c0 c03c3ec0 00000000 00000286 
[  226.310414]        c1465b64 fffd689a 0000000b 00000000 c02e8fda c1537040 00000292 c0425ab4 
[  226.310664]        c0425ab4 fffd689a c0123cd0 c14634f0 c04255c0 00000800 c1465f9c c0176bf5 
[  226.310914] Call Trace:
[  226.310995]  [<c02e8fda>] schedule_timeout+0x4a/0xc0
[  226.311075]  [<c0123cd0>] process_timeout+0x0/0x10
[  226.311148]  [<c0176bf5>] do_select+0x375/0x4b0
[  226.311231]  [<c01760e0>] __pollwait+0x0/0x100
[  226.311302]  [<c0117a50>] default_wake_function+0x0/0x10
[  226.311379]  [<c0138bad>] __lock_acquire+0x74d/0x1130
[  226.311452]  [<c01c0278>] do_get_write_access+0x2c8/0x570
[  226.311538]  [<c0164a39>] poison_obj+0x29/0x60
[  226.311613]  [<c0139997>] mark_held_locks+0x67/0x80
[  226.311684]  [<c01663dd>] kmem_cache_free+0xad/0xf0
[  226.311755]  [<c0139b64>] trace_hardirqs_on+0x104/0x170
[  226.311832]  [<c0138bad>] __lock_acquire+0x74d/0x1130
[  226.311903]  [<c0138bad>] __lock_acquire+0x74d/0x1130
[  226.311981]  [<c0138bad>] __lock_acquire+0x74d/0x1130
[  226.312052]  [<c01aefb6>] ext3_ordered_commit_write+0xa6/0xe0
[  226.312137]  [<c0138bad>] __lock_acquire+0x74d/0x1130
[  226.312207]  [<c02eb074>] _spin_unlock+0x14/0x20
[  226.312278]  [<c017c0d7>] __d_lookup+0x107/0x110
[  226.312352]  [<c01dbc95>] _atomic_dec_and_lock+0x15/0x40
[  226.312428]  [<c02eb074>] _spin_unlock+0x14/0x20
[  226.312498]  [<c01dbcaa>] _atomic_dec_and_lock+0x2a/0x40
[  226.312570]  [<c017ae71>] dput+0x51/0x120
[  226.312638]  [<c0172b0e>] __link_path_walk+0xc4e/0xca0
[  226.312718]  [<c0176ef6>] core_sys_select+0x1c6/0x320
[  226.312796]  [<c0164a39>] poison_obj+0x29/0x60
[  226.312868]  [<c01653c0>] cache_free_debugcheck+0xb0/0x1e0
[  226.312949]  [<c01e215f>] copy_to_user+0x3f/0x70
[  226.313020]  [<c016d1ff>] cp_new_stat64+0xef/0x110
[  226.313110]  [<c01773b1>] sys_select+0x51/0x1c0
[  226.313179]  [<c0139b64>] trace_hardirqs_on+0x104/0x170
[  226.313255]  [<c0104026>] sysenter_past_esp+0x5f/0x99
[  226.313336]  =======================
[  226.313380] kthreadd      S 00000000     0     2      0
[  226.313468]        c1467fd0 00000082 00000002 00000000 c012dee2 00000246 c03a4ee0 00000584 
[  226.313686]        c03a4efc 00000584 ded73c48 00000000 c012df3c c012de40 00000000 00000000 
[  226.313936]        c0104c23 00000000 00000000 00000000 00000000 00000000 00000000 
[  226.314163] Call Trace:
[  226.314237]  [<c012dee2>] kthreadd+0xa2/0x110
[  226.314311]  [<c012df3c>] kthreadd+0xfc/0x110
[  226.314379]  [<c012de40>] kthreadd+0x0/0x110
[  226.314447]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.314521]  =======================
[  226.314564] ksoftirqd/0   S c0139b64     0     3      2
[  226.314652]        c146bfcc 00000082 00000000 c0139b64 00000001 c012038f c01205b6 00000246 
[  226.314869]        00000000 fffffffc c0120640 00000000 c0120688 c012de34 c012ddc0 00000000 
[  226.315118]        00000000 c0104c23 c1465f04 00000000 00000000 00000000 00000000 00000000 
[  226.315367] Call Trace:
[  226.315441]  [<c0139b64>] trace_hardirqs_on+0x104/0x170
[  226.315512]  [<c012038f>] _local_bh_enable+0x4f/0xf0
[  226.315584]  [<c01205b6>] __do_softirq+0x76/0xb0
[  226.315654]  [<c0120640>] ksoftirqd+0x0/0x90
[  226.315721]  [<c0120688>] ksoftirqd+0x48/0x90
[  226.315788]  [<c012de34>] kthread+0x74/0x80
[  226.315855]  [<c012ddc0>] kthread+0x0/0x80
[  226.315923]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.315997]  =======================
[  226.316039] watchdog/0    S 00000073     0     4      2
[  226.316127]        c146ffc8 00000096 00000001 00000073 ffffffff 308b09e3 00000d34 00000000 
[  226.316345]        00000000 fffffffc c0147c60 00000000 c0147c97 00000063 c012de34 c012ddc0 
[  226.316595]        00000000 00000000 c0104c23 c1465f08 00000000 00000000 00000000 00000000 
[  226.316844] Call Trace:
[  226.316922]  [<c0147c60>] watchdog+0x0/0x50
[  226.316992]  [<c0147c97>] watchdog+0x37/0x50
[  226.317061]  [<c012de34>] kthread+0x74/0x80
[  226.317128]  [<c012ddc0>] kthread+0x0/0x80
[  226.317196]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.317270]  =======================
[  226.317312] events/0      R running      0     5      2
[  226.317400] khelper       S 00000002     0     6      2
[  226.317488]        c1473fac 00000086 c0139b64 00000002 00000046 df789444 00000286 df789444 
[  226.317706]        df789444 df789420 c012ae00 00000000 c012aed5 00000000 c146c070 c012e030 
[  226.317956]        df789460 df789460 df789420 fffffffc c012ae00 c012de34 c012ddc0 00000000 
[  226.318205] Call Trace:
[  226.318278]  [<c0139b64>] trace_hardirqs_on+0x104/0x170
[  226.318353]  [<c012ae00>] worker_thread+0x0/0x100
[  226.318422]  [<c012aed5>] worker_thread+0xd5/0x100
[  226.318491]  [<c012e030>] autoremove_wake_function+0x0/0x50
[  226.318566]  [<c012ae00>] worker_thread+0x0/0x100
[  226.318633]  [<c012de34>] kthread+0x74/0x80
[  226.318701]  [<c012ddc0>] kthread+0x0/0x80
[  226.318769]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.318843]  =======================
[  226.318885] kblockd/0     S 00000002     0    35      2
[  226.318973]        df751fac 00000086 c0139b64 00000002 00000046 c03c3ec0 00000286 df706e5c 
[  226.319191]        df706e5c df706e38 c012ae00 00000000 c012aed5 00000000 df748a90 c012e030 
[  226.319440]        df706e78 df706e78 df706e38 fffffffc c012ae00 c012de34 c012ddc0 00000000 
[  226.319690] Call Trace:
[  226.319764]  [<c0139b64>] trace_hardirqs_on+0x104/0x170
[  226.319840]  [<c012ae00>] worker_thread+0x0/0x100
[  226.319909]  [<c012aed5>] worker_thread+0xd5/0x100
[  226.319978]  [<c012e030>] autoremove_wake_function+0x0/0x50
[  226.320051]  [<c012ae00>] worker_thread+0x0/0x100
[  226.320120]  [<c012de34>] kthread+0x74/0x80
[  226.320187]  [<c012ddc0>] kthread+0x0/0x80
[  226.320255]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.320329]  =======================
[  226.320372] kacpid        S 00000002     0    38      2
[  226.320459]        df759fac 00000086 c0139b64 00000002 00000046 df706a34 00000286 df706a34 
[  226.320677]        df706a34 df706a10 c012ae00 00000000 c012aed5 00000000 df754ad0 c012e030 
[  226.320927]        df706a50 df706a50 df706a10 fffffffc c012ae00 c012de34 c012ddc0 00000000 
[  226.321177] Call Trace:
[  226.321251]  [<c0139b64>] trace_hardirqs_on+0x104/0x170
[  226.321326]  [<c012ae00>] worker_thread+0x0/0x100
[  226.321395]  [<c012aed5>] worker_thread+0xd5/0x100
[  226.321465]  [<c012e030>] autoremove_wake_function+0x0/0x50
[  226.321538]  [<c012ae00>] worker_thread+0x0/0x100
[  226.321606]  [<c012de34>] kthread+0x74/0x80
[  226.321673]  [<c012ddc0>] kthread+0x0/0x80
[  226.321741]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.321814]  =======================
[  226.321857] kacpi_notify  S 00000002     0    39      2
[  226.321945]        df75bfac 00000086 c0139b64 00000002 00000046 df70e99c 00000286 df70e99c 
[  226.322162]        df70e99c df70e978 c012ae00 00000000 c012aed5 00000000 df754070 c012e030 
[  226.322412]        df70e9b8 df70e9b8 df70e978 fffffffc c012ae00 c012de34 c012ddc0 00000000 
[  226.322662] Call Trace:
[  226.322735]  [<c0139b64>] trace_hardirqs_on+0x104/0x170
[  226.322810]  [<c012ae00>] worker_thread+0x0/0x100
[  226.322879]  [<c012aed5>] worker_thread+0xd5/0x100
[  226.322948]  [<c012e030>] autoremove_wake_function+0x0/0x50
[  226.323022]  [<c012ae00>] worker_thread+0x0/0x100
[  226.323090]  [<c012de34>] kthread+0x74/0x80
[  226.323157]  [<c012ddc0>] kthread+0x0/0x80
[  226.323226]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.324145]  =======================
[  226.324188] kseriod       S 00000002     0   159      2
[  226.324276]        c14bdf98 00000092 c0139b64 00000002 00000046 c03b8f80 00000286 c03b8f80 
[  226.324493]        00000000 00000000 00000000 00000000 c0269674 c02eb320 00000002 c02e87ff 
[  226.324742]        00000000 00000000 df720070 c012e030 c03b8f9c c03b8f9c 00000000 fffffffc 
[  226.324992] Call Trace:
[  226.325065]  [<c0139b64>] trace_hardirqs_on+0x104/0x170
[  226.325142]  [<c0269674>] serio_thread+0x204/0x330
[  226.325213]  [<c02eb320>] _spin_unlock_irq+0x20/0x30
[  226.325285]  [<c02e87ff>] schedule+0x1af/0x340
[  226.325355]  [<c012e030>] autoremove_wake_function+0x0/0x50
[  226.325430]  [<c0269470>] serio_thread+0x0/0x330
[  226.325500]  [<c012de34>] kthread+0x74/0x80
[  226.325567]  [<c012ddc0>] kthread+0x0/0x80
[  226.325635]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.325709]  =======================
[  226.325751] rt-test-0     S 00000046     0   184      2
[  226.325839]        c14e9fc8 00000096 c011cfe8 00000046 df71857c fffffffc df71857c fffffffc 
[  226.326056]        c0621f00 fffffffc c013e250 00000000 c013e2c8 c0621f00 c012de34 c012ddc0 
[  226.326306]        00000000 00000000 c0104c23 c1465efc 00000000 00000000 00000000 00000000 
[  226.326555] Call Trace:
[  226.326629]  [<c011cfe8>] allow_signal+0x28/0x80
[  226.326703]  [<c013e250>] test_func+0x0/0xb0
[  226.326773]  [<c013e2c8>] test_func+0x78/0xb0
[  226.326842]  [<c012de34>] kthread+0x74/0x80
[  226.326909]  [<c012ddc0>] kthread+0x0/0x80
[  226.326978]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.327051]  =======================
[  226.327094] rt-test-1     S 00000046     0   186      2
[  226.327182]        c14effc8 00000096 c011cfe8 00000046 c14edb3c fffffffc c14edb3c fffffffc 
[  226.327400]        c0621f90 fffffffc c013e250 00000000 c013e2c8 c0621f90 c012de34 c012ddc0 
[  226.327649]        00000000 00000000 c0104c23 c1465efc 00000000 00000000 00000000 00000000 
[  226.327899] Call Trace:
[  226.327972]  [<c011cfe8>] allow_signal+0x28/0x80
[  226.328046]  [<c013e250>] test_func+0x0/0xb0
[  226.328115]  [<c013e2c8>] test_func+0x78/0xb0
[  226.328184]  [<c012de34>] kthread+0x74/0x80
[  226.328252]  [<c012ddc0>] kthread+0x0/0x80
[  226.328319]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.328392]  =======================
[  226.328435] rt-test-2     S 00000046     0   188      2
[  226.328522]        c14f3fc8 00000096 c011cfe8 00000046 c14ed5dc fffffffc c14ed5dc fffffffc 
[  226.328740]        c0622020 fffffffc c013e250 00000000 c013e2c8 c0622020 c012de34 c012ddc0 
[  226.328990]        00000000 00000000 c0104c23 c1465efc 00000000 00000000 00000000 00000000 
[  226.329239] Call Trace:
[  226.329312]  [<c011cfe8>] allow_signal+0x28/0x80
[  226.329385]  [<c013e250>] test_func+0x0/0xb0
[  226.329453]  [<c013e2c8>] test_func+0x78/0xb0
[  226.329522]  [<c012de34>] kthread+0x74/0x80
[  226.329589]  [<c012ddc0>] kthread+0x0/0x80
[  226.329657]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.329730]  =======================
[  226.329772] rt-test-3     S 00000046     0   190      2
[  226.329860]        c14f7fc8 00000096 c011cfe8 00000046 c14ed07c fffffffc c14ed07c fffffffc 
[  226.330078]        c06220b0 fffffffc c013e250 00000000 c013e2c8 c06220b0 c012de34 c012ddc0 
[  226.330347]        00000000 00000000 c0104c23 c1465efc 00000000 00000000 00000000 00000000 
[  226.330597] Call Trace:
[  226.330670]  [<c011cfe8>] allow_signal+0x28/0x80
[  226.330744]  [<c013e250>] test_func+0x0/0xb0
[  226.330813]  [<c013e2c8>] test_func+0x78/0xb0
[  226.330882]  [<c012de34>] kthread+0x74/0x80
[  226.330949]  [<c012ddc0>] kthread+0x0/0x80
[  226.331017]  [<c0104c23>] kernel_thread_helper+0x7/0x14
[  226.331090]  =======================

And So on for every task.

Thanks,

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
