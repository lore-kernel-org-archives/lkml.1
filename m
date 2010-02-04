Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab0BDQji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:39:38 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39239 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363Ab0BDQjg (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:39:36 -0500
X-Greylist: delayed 2322 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 11:39:36 EST
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.33-rc6 - BUG at drivers/cpufreq/cpufreq.c:88
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1265299202_5577P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Feb 2010 11:00:02 -0500
Message-ID: <6843.1265299202@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1265299202_5577P
Content-Type: text/plain; charset=us-ascii

Hit this one again while setting up to bisect another issue.  I've verified
that the fix *is* someplace in 2.6.33-rc6-mmotm0201 (as that one lives at least
all the way to single-user mode), so I'm basically asking that somebody find
the commit that fixes it and make sure it gets into 2.6.33-final.  I'd offer
the commit number for the fix, but I'm hoping somebody recognizes it and pushes
it so I don't have bisect to find the fixing commit.

Thomas?  Did you have a fix for this that hasn't been pulled by Linus yet?

Refresher:  The bad commit was:

commit 46aeb7430f79cb4d03e17fedd6399884ab3aa697
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Dec 14 11:44:11 2009 +0100

    [CPUFREQ] Fix race in cpufreq_update_policy()


[    4.950955] kernel BUG at drivers/cpufreq/cpufreq.c:88!
[    4.951072] invalid opcode: 0000 [#1] PREEMPT SMP 
[    4.951452] last sysfs file: 
[    4.951560] CPU 1 
[    4.951754] Pid: 1, comm: swapper Not tainted 2.6.32-08667-g46aeb74 #15 0X564R/Latitude E6500                  
[    4.951825] RIP: 0010:[<ffffffff813942f4>]  [<ffffffff813942f4>] lock_policy_rwsem_write+0x43/0xad
[    4.951825] RSP: 0000:ffff88011f87fd40  EFLAGS: 00010202
[    4.951825] RAX: 00000000000104b0 RBX: 0000000000000001 RCX: 000000000000003e
[    4.951825] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81ae1f88
[    4.951825] RBP: ffff88011f87fd60 R08: 0000000000000000 R09: ffffffff81b04810
[    4.951825] R10: ffffffff8103b7fa R11: ffffffff8184f00d R12: 00000000ffffffff
[    4.951825] R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000000
[    4.951825] FS:  0000000000000000(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
[    4.951825] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.951825] CR2: 00000034478a8440 CR3: 0000000001a1c000 CR4: 00000000000406e0
[    4.951825] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.951825] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    4.951825] Process swapper (pid: 1, threadinfo ffff88011f87e000, task ffff88011f87c040)
[    4.951825] Stack:
[    4.951825]  ffff88011f87c040 0000000000000000 0000000000000000 00000000ffffffea
[    4.951825] <0> ffff88011f87feb0 ffffffff8139558c ffff88011f87fd90 ffffffff810641a8
[    4.951825] <0> 0000000000000000 0000000000000000 ffff88011f87fe50 ffffffff81527c4c
[    4.951825] Call Trace:
[    4.951825]  [<ffffffff8139558c>] cpufreq_update_policy+0x20/0xfc
[    4.951825]  [<ffffffff810641a8>] ? debug_mutex_free_waiter+0x2e/0x6a
[    4.951825]  [<ffffffff81527c4c>] ? __mutex_lock_common+0x58b/0x5aa
[    4.951825]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.951825]  [<ffffffff815291b0>] ? _raw_spin_unlock_irqrestore+0x72/0x80
[    4.951825]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.951825]  [<ffffffff81527478>] ? __mutex_unlock_slowpath+0x136/0x17b
[    4.951825]  [<ffffffff81066494>] ? trace_hardirqs_on_caller+0x118/0x13c
[    4.951825]  [<ffffffff810664c5>] ? trace_hardirqs_on+0xd/0xf
[    4.951825]  [<ffffffff815274ac>] ? __mutex_unlock_slowpath+0x16a/0x17b
[    4.951825]  [<ffffffff815274c6>] ? mutex_unlock+0x9/0xb
[    4.951825]  [<ffffffff8103b80c>] ? cpu_maps_update_done+0x10/0x12
[    4.951825]  [<ffffffff815113c7>] ? register_cpu_notifier+0x28/0x32
[    4.951825]  [<ffffffff81b48568>] cpufreq_stats_init+0x85/0xad
[    4.951825]  [<ffffffff81b484e3>] ? cpufreq_stats_init+0x0/0xad
[    4.951825]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
[    4.951825]  [<ffffffff81b21667>] kernel_init+0x15f/0x1b5
[    4.951825]  [<ffffffff810031d4>] kernel_thread_helper+0x4/0x10
[    4.951825]  [<ffffffff81529ac0>] ? restore_args+0x0/0x30
[    4.951825]  [<ffffffff81b21508>] ? kernel_init+0x0/0x1b5
[    4.951825]  [<ffffffff810031d0>] ? kernel_thread_helper+0x0/0x10
[    4.951825] Code: 88 1f ae 81 53 31 db 48 83 ec 08 48 8b 14 d5 60 46 b0 81 44 8b 24 10 41 83 fc ff 0f 94 c3 31 d2 89 de e8 f4 42 d0 ff 85 db 74 04 <0f> 0b eb fe 4d 63 e4 48 c7 c3 c0 04 01 00 48 89 df 4a 03 3c e5 
[    4.951825] RIP  [<ffffffff813942f4>] lock_policy_rwsem_write+0x43/0xad
[    4.951825]  RSP <ffff88011f87fd40>
[    4.971105] ---[ end trace 656ae57b6f9afe82 ]---
[    4.971228] Kernel panic - not syncing: Attempted to kill init!
[    4.971358] Pid: 1, comm: swapper Tainted: G      D    2.6.32-08667-g46aeb74 #15
[    4.971515] Call Trace:
[    4.971646]  [<ffffffff81526031>] panic+0x7f/0x13a
[    4.971763]  [<ffffffff81066392>] ? trace_hardirqs_on_caller+0x16/0x13c
[    4.971878]  [<ffffffff8103db1a>] do_exit+0xd7/0x8d6
[    4.971991]  [<ffffffff8103a328>] ? spin_unlock_irqrestore+0x9/0xb
[    4.972111]  [<ffffffff8103af22>] ? kmsg_dump+0x136/0x150
[    4.972224]  [<ffffffff8152a904>] oops_end+0x89/0x8e
[    4.972351]  [<ffffffff81005dd1>] die+0x55/0x5e
[    4.972463]  [<ffffffff8152a324>] do_trap+0x11c/0x12b
[    4.972578]  [<ffffffff81003ac9>] do_invalid_op+0x8f/0x98
[    4.972691]  [<ffffffff813942f4>] ? lock_policy_rwsem_write+0x43/0xad
[    4.972804]  [<ffffffff8152899f>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    4.972924]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.973048]  [<ffffffff81529af0>] ? irq_return+0x0/0x2
[    4.973168]  [<ffffffff81003055>] invalid_op+0x15/0x20
[    4.973300]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.973421]  [<ffffffff813942f4>] ? lock_policy_rwsem_write+0x43/0xad
[    4.973536]  [<ffffffff8139558c>] cpufreq_update_policy+0x20/0xfc
[    4.973650]  [<ffffffff810641a8>] ? debug_mutex_free_waiter+0x2e/0x6a
[    4.973775]  [<ffffffff81527c4c>] ? __mutex_lock_common+0x58b/0x5aa
[    4.973887]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.974001]  [<ffffffff815291b0>] ? _raw_spin_unlock_irqrestore+0x72/0x80
[    4.974125]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.974239]  [<ffffffff81527478>] ? __mutex_unlock_slowpath+0x136/0x17b
[    4.974376]  [<ffffffff81066494>] ? trace_hardirqs_on_caller+0x118/0x13c
[    4.974490]  [<ffffffff810664c5>] ? trace_hardirqs_on+0xd/0xf
[    4.974609]  [<ffffffff815274ac>] ? __mutex_unlock_slowpath+0x16a/0x17b
[    4.974732]  [<ffffffff815274c6>] ? mutex_unlock+0x9/0xb
[    4.974844]  [<ffffffff8103b80c>] ? cpu_maps_update_done+0x10/0x12
[    4.974963]  [<ffffffff815113c7>] ? register_cpu_notifier+0x28/0x32
[    4.975087]  [<ffffffff81b48568>] cpufreq_stats_init+0x85/0xad
[    4.975210]  [<ffffffff81b484e3>] ? cpufreq_stats_init+0x0/0xad
[    4.975334]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
[    4.975453]  [<ffffffff81b21667>] kernel_init+0x15f/0x1b5
[    4.975566]  [<ffffffff810031d4>] kernel_thread_helper+0x4/0x10
[    4.975678]  [<ffffffff81529ac0>] ? restore_args+0x0/0x30
[    4.975794]  [<ffffffff81b21508>] ? kernel_init+0x0/0x1b5
[    4.975905]  [<ffffffff810031d0>] ? kernel_thread_helper+0x0/0x10



--==_Exmh_1265299202_5577P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLau8CcC3lWbTT17ARAlJNAKDrYxGkQxKIrf+NWsSV97L/CsCsqACePgpJ
P9PSKIZMShijxEDnAfIK5Y8=
=8JFk
-----END PGP SIGNATURE-----

--==_Exmh_1265299202_5577P--
