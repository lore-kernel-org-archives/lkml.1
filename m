Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbXHJGRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbXHJGRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 02:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXHJGQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 02:16:53 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:41797 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbXHJGQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 02:16:43 -0400
Message-ID: <46BC02B9.1000307@linux.vnet.ibm.com>
Date: Fri, 10 Aug 2007 11:46:25 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: Softlockup detected with 2.6.23-rc2-mm1 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get call trace, when the file system stress is run on the
2.6.23-rc2-mm1 kernel on a Dual Core AMD Opteron
(processor 270)

============================================\BUG: spinlock bad magic on 
CPU#1, fsx-linux/19721

 lock: ffff8100028cef48, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0



Call Trace:

 [<ffffffff803359a6>] _raw_spin_lock+0x22/0xf6

 [<ffffffff804e4c13>] _spin_lock_irqsave+0x9/0xe

 [<ffffffff803303fe>] prop_norm_single+0x40/0x9a

 [<ffffffff8026ac1f>] set_page_dirty+0x8d/0xc9

 [<ffffffff8026bc09>] set_page_dirty_balance+0x9/0x39

 [<ffffffff80271f14>] __do_fault+0x37a/0x395

 [<ffffffff802738d7>] handle_mm_fault+0x342/0x6c3

 [<ffffffff804e6ac6>] do_page_fault+0x3e5/0x7ab

 [<ffffffff802117d3>] arch_get_unmapped_area+0x184/0x1f9

 [<ffffffff804e4c13>] _spin_lock_irqsave+0x9/0xe

 [<ffffffff803318cc>] __up_write+0x21/0x10d

 [<ffffffff804e500d>] error_exit+0x0/0x84



BUG: spinlock lockup on CPU#1, fsx-linux/19721, ffff8100028cef48



Call Trace:

 [<ffffffff80335a53>] _raw_spin_lock+0xcf/0xf6

 [<ffffffff804e4c13>] _spin_lock_irqsave+0x9/0xe

 [<ffffffff803303fe>] prop_norm_single+0x40/0x9a

 [<ffffffff8026ac1f>] set_page_dirty+0x8d/0xc9

 [<ffffffff8026bc09>] set_page_dirty_balance+0x9/0x39

 [<ffffffff80271f14>] __do_fault+0x37a/0x395

 [<ffffffff802738d7>] handle_mm_fault+0x342/0x6c3

 [<ffffffff804e6ac6>] do_page_fault+0x3e5/0x7ab

 [<ffffffff802117d3>] arch_get_unmapped_area+0x184/0x1f9

 [<ffffffff804e4c13>] _spin_lock_irqsave+0x9/0xe

 [<ffffffff803318cc>] __up_write+0x21/0x10d

 [<ffffffff804e500d>] error_exit+0x0/0x84



BUG: soft lockup - CPU#2 stuck for 11s! [events/2:17]

CPU 2:

Modules linked in: ipv6 hidp rfcomm l2cap bluetooth sunrpc battery ac lp 
parport_pc parport nvram amd_rng rng_core i2c_amd756 i2c_core button

Pid: 17, comm: events/2 Not tainted 2.6.23-rc2-mm1-autokern1 #1

RIP: 0010:[<ffffffff8021a4a4>]  [<ffffffff8021a4a4>] 
__smp_call_function+0x63/0x84

RSP: 0018:ffff810001727e00  EFLAGS: 00000297

RAX: 00000000000008fc RBX: 0000000000000003 RCX: 0000000000000000

RDX: 00000000000008fc RSI: ffff810001727de0 RDI: 00000000000000fc

RBP: 0000000000000246 R08: 0000000000000003 R09: 0000000000000005

R10: 0000000000000010 R11: 0000000000000246 R12: 0000000000000400

R13: 0000000000000400 R14: 0000000000000000 R15: ffff81000102d980

FS:  00002b8de51be6f0(0000) GS:ffff8100016123c0(0000) knlGS:0000000000000000

CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b

CR2: 00000036d4b938a0 CR3: 000000001659f000 CR4: 00000000000006e0

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400



Call Trace:

 [<ffffffff80214c8d>] mcheck_check_cpu+0x0/0x30

 [<ffffffff8021a4f7>] smp_call_function+0x32/0x49

 [<ffffffff80214c8d>] mcheck_check_cpu+0x0/0x30

 [<ffffffff8023aca7>] on_each_cpu+0x10/0x22

 [<ffffffff80214532>] mcheck_timer+0x0/0x7c

 [<ffffffff8021454f>] mcheck_timer+0x1d/0x7c

 [<ffffffff804e4be1>] _spin_unlock_irq+0x9/0xc

 [<ffffffff80244c93>] run_workqueue+0x8d/0x11a

 [<ffffffff802454e2>] worker_thread+0x0/0xe4

 [<ffffffff802455bc>] worker_thread+0xda/0xe4

 [<ffffffff8024846b>] autoremove_wake_function+0x0/0x2e

 [<ffffffff80248360>] kthread+0x47/0x73

 [<ffffffff8020ca78>] child_rip+0xa/0x12

 [<ffffffff80248319>] kthread+0x0/0x73

 [<ffffffff8020ca6e>] child_rip+0x0/0x12



BUG: soft lockup - CPU#2 stuck for 11s! [events/2:17]

CPU 2:

Modules linked in: ipv6 hidp rfcomm l2cap bluetooth sunrpc battery ac lp 
parport_pc parport nvram amd_rng rng_core i2c_amd756 i2c_core button

Pid: 17, comm: events/2 Not tainted 2.6.23-rc2-mm1-autokern1 #1

RIP: 0010:[<ffffffff8021a4a4>]  [<ffffffff8021a4a4>] 
__smp_call_function+0x63/0x84

RSP: 0018:ffff810001727e00  EFLAGS: 00000297

RAX: 00000000000008fc RBX: 0000000000000003 RCX: 0000000000000000

RDX: 00000000000008fc RSI: ffff810001727de0 RDI: 00000000000000fc

RBP: 0000000000000246 R08: 0000000000000003 R09: 0000000000000005

R10: 0000000000000010 R11: 0000000000000246 R12: 0000000000000400

R13: 0000000000000400 R14: 0000000000000000 R15: ffff81000102d980

FS:  00002b8de51be6f0(0000) GS:ffff8100016123c0(0000) knlGS:0000000000000000

CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b

CR2: 00000036d4b938a0 CR3: 000000001659f000 CR4: 00000000000006e0

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400



Call Trace:

 [<ffffffff80214c8d>] mcheck_check_cpu+0x0/0x30

 [<ffffffff8021a4f7>] smp_call_function+0x32/0x49

 [<ffffffff80214c8d>] mcheck_check_cpu+0x0/0x30

 [<ffffffff8023aca7>] on_each_cpu+0x10/0x22

 [<ffffffff80214532>] mcheck_timer+0x0/0x7c

 [<ffffffff8021454f>] mcheck_timer+0x1d/0x7c

 [<ffffffff804e4be1>] _spin_unlock_irq+0x9/0xc

 [<ffffffff80244c93>] run_workqueue+0x8d/0x11a

 [<ffffffff802454e2>] worker_thread+0x0/0xe4

 [<ffffffff802455bc>] worker_thread+0xda/0xe4

 [<ffffffff8024846b>] autoremove_wake_function+0x0/0x2e

 [<ffffffff80248360>] kthread+0x47/0x73

 [<ffffffff8020ca78>] child_rip+0xa/0x12

 [<ffffffff80248319>] kthread+0x0/0x73

 [<ffffffff8020ca6e>] child_rip+0x0/0x12



BUG: soft lockup - CPU#2 stuck for 11s! [events/2:17]

CPU 2:

Modules linked in: ipv6 hidp rfcomm l2cap bluetooth sunrpc battery ac lp 
parport_pc parport nvram amd_rng rng_core i2c_amd756 i2c_core button

Pid: 17, comm: events/2 Not tainted 2.6.23-rc2-mm1-autokern1 #1

RIP: 0010:[<ffffffff8021a4a4>]  [<ffffffff8021a4a4>] 
__smp_call_function+0x63/0x84

RSP: 0018:ffff810001727e00  EFLAGS: 00000297

RAX: 00000000000008fc RBX: 0000000000000003 RCX: 0000000000000000

RDX: 00000000000008fc RSI: ffff810001727de0 RDI: 00000000000000fc

RBP: 0000000000000246 R08: 0000000000000003 R09: 0000000000000005

R10: 0000000000000010 R11: 0000000000000246 R12: 0000000000000400

R13: 0000000000000400 R14: 0000000000000000 R15: ffff81000102d980

FS:  00002b8de51be6f0(0000) GS:ffff8100016123c0(0000) knlGS:0000000000000000

CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b

CR2: 00000036d4b938a0 CR3: 0000000000201000 CR4: 00000000000006e0

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400



Call Trace:

 [<ffffffff80214c8d>] mcheck_check_cpu+0x0/0x30

 [<ffffffff8021a4f7>] smp_call_function+0x32/0x49

 [<ffffffff80214c8d>] mcheck_check_cpu+0x0/0x30

 [<ffffffff8023aca7>] on_each_cpu+0x10/0x22

 [<ffffffff80214532>] mcheck_timer+0x0/0x7c

 [<ffffffff8021454f>] mcheck_timer+0x1d/0x7c

 [<ffffffff804e4be1>] _spin_unlock_irq+0x9/0xc

 [<ffffffff80244c93>] run_workqueue+0x8d/0x11a

 [<ffffffff802454e2>] worker_thread+0x0/0xe4

 [<ffffffff802455bc>] worker_thread+0xda/0xe4

 [<ffffffff8024846b>] autoremove_wake_function+0x0/0x2e

 [<ffffffff80248360>] kthread+0x47/0x73

 [<ffffffff8020ca78>] child_rip+0xa/0x12

 [<ffffffff80248319>] kthread+0x0/0x73

 [<ffffffff8020ca6e>] child_rip+0x0/0x12



BUG: soft lockup - CPU#2 stuck for 11s! [events/2:17]

CPU 2:

Modules linked in: ipv6 hidp rfcomm l2cap bluetooth sunrpc battery ac lp 
parport_pc parport nvram amd_rng rng_core i2c_amd756 i2c_core button

Pid: 17, comm: events/2 Not tainted 2.6.23-rc2-mm1-autokern1 #1

RIP: 0010:[<ffffffff8021a4a6>]  [<ffffffff8021a4a6>] 
__smp_call_function+0x65/0x84

RSP: 0018:ffff810001727e00  EFLAGS: 00000297

RAX: 00000000000008fc RBX: 0000000000000003 RCX: 0000000000000000

RDX: 00000000000008fc RSI: ffff810001727de0 RDI: 00000000000000fc

RBP: 0000000000000246 R08: 0000000000000003 R09: 0000000000000005

R10: 0000000000000010 R11: 0000000000000246 R12: 0000000000000400

R13: 0000000000000400 R14: 0000000000000000 R15: ffff81000102d980

FS:  00002b8de51be6f0(0000) GS:ffff8100016123c0(0000) knlGS:0000000000000000

CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b

CR2: 00000036d4b938a0 CR3: 0000000000201000 CR4: 00000000000006e0

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400



Call Trace:

 [<ffffffff80214c8d>] mcheck_check_cpu+0x0/0x30

 [<ffffffff8021a4f7>] smp_call_function+0x32/0x49

 [<ffffffff80214c8d>] mcheck_check_cpu+0x0/0x30

 [<ffffffff8023aca7>] on_each_cpu+0x10/0x22

 [<ffffffff80214532>] mcheck_timer+0x0/0x7c

 [<ffffffff8021454f>] mcheck_timer+0x1d/0x7c

 [<ffffffff804e4be1>] _spin_unlock_irq+0x9/0xc

 [<ffffffff80244c93>] run_workqueue+0x8d/0x11a

 [<ffffffff802454e2>] worker_thread+0x0/0xe4

 [<ffffffff802455bc>] worker_thread+0xda/0xe4

 [<ffffffff8024846b>] autoremove_wake_function+0x0/0x2e

 [<ffffffff80248360>] kthread+0x47/0x73

 [<ffffffff8020ca78>] child_rip+0xa/0x12

 [<ffffffff80248319>] kthread+0x0/0x73

 [<ffffffff8020ca6e>] child_rip+0x0/0x12



BUG: soft lockup - CPU#2 stuck for 11s! [events/2:17]

CPU 2:

Modules linked in: ipv6 hidp rfcomm l2cap bluetooth sunrpc battery ac lp 
parport_pc parport nvram amd_rng rng_core i2c_amd756 i2c_core button

Pid: 17, comm: events/2 Not tainted 2.6.23-rc2-mm1-autokern1 #1

RIP: 0010:[<ffffffff8021a4a4>]  [<ffffffff8021a4a4>] 
__smp_call_function+0x63/0x84

RSP: 0018:ffff810001727e00  EFLAGS: 00000297

RAX: 00000000000008fc RBX: 0000000000000003 RCX: 0000000000000000

RDX: 00000000000008fc RSI: ffff810001727de0 RDI: 00000000000000fc

RBP: 0000000000000246 R08: 0000000000000003 R09: 0000000000000005

R10: 0000000000000010 R11: 0000000000000246 R12: 0000000000000400

R13: 0000000000000400 R14: 0000000000000000 R15: ffff81000102d980

FS:  00002b8de51be6f0(0000) GS:ffff8100016123c0(0000) knlGS:0000000000000000

CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b

CR2: 00000036d4b938a0 CR3: 0000000000201000 CR4: 00000000000006e0

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400



Call Trace:

 [<ffffffff80214c8d>] mcheck_check_cpu+0x0/0x30

 [<ffffffff8021a4f7>] smp_call_function+0x32/0x49

 [<ffffffff80214c8d>] mcheck_check_cpu+0x0/0x30

 [<ffffffff8023aca7>] on_each_cpu+0x10/0x22

 [<ffffffff80214532>] mcheck_timer+0x0/0x7c

 [<ffffffff8021454f>] mcheck_timer+0x1d/0x7c

 [<ffffffff804e4be1>] _spin_unlock_irq+0x9/0xc

 [<ffffffff80244c93>] run_workqueue+0x8d/0x11a

 [<ffffffff802454e2>] worker_thread+0x0/0xe4

 [<ffffffff802455bc>] worker_thread+0xda/0xe4

 [<ffffffff8024846b>] autoremove_wake_function+0x0/0x2e

 [<ffffffff80248360>] kthread+0x47/0x73

 [<ffffffff8020ca78>] child_rip+0xa/0x12

 [<ffffffff80248319>] kthread+0x0/0x73

 [<ffffffff8020ca6e>] child_rip+0x0/0x12


Thanks,
Kamalesh Babulal.
