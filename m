Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbYJ2UqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbYJ2UqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYJ2UqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:46:10 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:35021 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYJ2UqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:46:08 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.28-rc2-mm1: possible circular locking
Date: Wed, 29 Oct 2008 21:46:03 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
References: <20081028233836.8b1ff9ae.akpm@linux-foundation.org>
In-Reply-To: <20081028233836.8b1ff9ae.akpm@linux-foundation.org>
MIME-Version: 1.0
Message-Id: <200810292146.03967.m.kozlowski@tuxland.pl>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LuMCJV/DLS7OhqJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_LuMCJV/DLS7OhqJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

	Happens on every startup when psi starts as well.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.28-rc2-mm1 #1
-------------------------------------------------------
psi/4733 is trying to acquire lock:
 (events){--..}, at: [<c012a330>] flush_work+0x2d/0xcb

but task is already holding lock:
 (&mm->mmap_sem){----}, at: [<c0158588>] sys_mlock+0x2c/0xb6

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&mm->mmap_sem){----}:
       [<c013ac05>] validate_chain+0xacb/0xfe0
       [<c013b388>] __lock_acquire+0x26e/0x98d
       [<c013bb03>] lock_acquire+0x5c/0x74
       [<c015728a>] might_fault+0x74/0x90
       [<c01e5cf8>] copy_to_user+0x28/0x40
       [<c01768aa>] filldir64+0xaa/0xcd
       [<c01a46d9>] sysfs_readdir+0x118/0x1dd
       [<c01769fb>] vfs_readdir+0x70/0x85
       [<c0176a70>] sys_getdents64+0x60/0xa8
       [<c0102f91>] sysenter_do_call+0x12/0x35
       [<ffffffff>] 0xffffffff

-> #3 (sysfs_mutex){--..}:
       [<c013ac05>] validate_chain+0xacb/0xfe0
       [<c013b388>] __lock_acquire+0x26e/0x98d
       [<c013bb03>] lock_acquire+0x5c/0x74
       [<c02bc360>] mutex_lock_nested+0x8d/0x297
       [<c01a495a>] sysfs_addrm_start+0x26/0x9e
       [<c01a4e25>] create_dir+0x3a/0x83
       [<c01a4e99>] sysfs_create_dir+0x2b/0x43
       [<c01e09a0>] kobject_add_internal+0xb4/0x186
       [<c01e0b2f>] kobject_add_varg+0x41/0x4d
       [<c01e0dbc>] kobject_add+0x2f/0x57
       [<c023d074>] device_add+0xa4/0x58f
       [<c0276a53>] netdev_register_kobject+0x65/0x6a
       [<c026bed0>] register_netdevice+0x209/0x2fb
       [<c026bff4>] register_netdev+0x32/0x3f
       [<c03c4344>] loopback_net_init+0x33/0x6f
       [<c02690ff>] register_pernet_operations+0x13/0x15
       [<c026916a>] register_pernet_device+0x1f/0x4c
       [<c03c430f>] loopback_init+0xd/0xf
       [<c0101027>] _stext+0x27/0x147
       [<c03ac7af>] kernel_init+0x7d/0xd6
       [<c0103cc3>] kernel_thread_helper+0x7/0x14
       [<ffffffff>] 0xffffffff

-> #2 (rtnl_mutex){--..}:
       [<c013ac05>] validate_chain+0xacb/0xfe0
       [<c013b388>] __lock_acquire+0x26e/0x98d
       [<c013bb03>] lock_acquire+0x5c/0x74
       [<c02bc360>] mutex_lock_nested+0x8d/0x297
       [<c02746d3>] rtnl_lock+0xf/0x11
       [<c0275ab3>] linkwatch_event+0x8/0x27
       [<c0129d40>] run_workqueue+0x15c/0x1e3
       [<c012a70e>] worker_thread+0x71/0xa4
       [<c012cc62>] kthread+0x37/0x59
       [<c0103cc3>] kernel_thread_helper+0x7/0x14
       [<ffffffff>] 0xffffffff

-> #1 ((linkwatch_work).work){--..}:
       [<c013ac05>] validate_chain+0xacb/0xfe0
       [<c013b388>] __lock_acquire+0x26e/0x98d
       [<c013bb03>] lock_acquire+0x5c/0x74
       [<c0129d3b>] run_workqueue+0x157/0x1e3
       [<c012a70e>] worker_thread+0x71/0xa4
       [<c012cc62>] kthread+0x37/0x59
       [<c0103cc3>] kernel_thread_helper+0x7/0x14
       [<ffffffff>] 0xffffffff

-> #0 (events){--..}:
       [<c013a6e4>] validate_chain+0x5aa/0xfe0
       [<c013b388>] __lock_acquire+0x26e/0x98d
       [<c013bb03>] lock_acquire+0x5c/0x74
       [<c012a35c>] flush_work+0x59/0xcb
       [<c012a7a6>] schedule_on_each_cpu+0x65/0x7f
       [<c014fb7e>] lru_add_drain_all+0xd/0xf
       [<c0157fb2>] __mlock_vma_pages_range+0x44/0x206
       [<c01582d1>] mlock_fixup+0x15d/0x1c9
       [<c0158479>] do_mlock+0x96/0xc8
       [<c015860e>] sys_mlock+0xb2/0xb6
       [<c0102f91>] sysenter_do_call+0x12/0x35
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by psi/4733:
 #0:  (&mm->mmap_sem){----}, at: [<c0158588>] sys_mlock+0x2c/0xb6

stack backtrace:
Pid: 4733, comm: psi Not tainted 2.6.28-rc2-mm1 #1
Call Trace:
 [<c013a0fd>] print_circular_bug_tail+0x78/0xb5
 [<c0137a31>] ? print_circular_bug_entry+0x43/0x4b
 [<c013a6e4>] validate_chain+0x5aa/0xfe0
 [<c0118465>] ? hrtick_update+0x23/0x25
 [<c013b388>] __lock_acquire+0x26e/0x98d
 [<c0118ac0>] ? default_wake_function+0xb/0xd
 [<c013bb03>] lock_acquire+0x5c/0x74
 [<c012a330>] ? flush_work+0x2d/0xcb
 [<c012a35c>] flush_work+0x59/0xcb
 [<c012a330>] ? flush_work+0x2d/0xcb
 [<c0139ae6>] ? trace_hardirqs_on+0xb/0xd
 [<c012a531>] ? __queue_work+0x26/0x2b
 [<c012a58c>] ? queue_work_on+0x37/0x47
 [<c014fda7>] ? lru_add_drain_per_cpu+0x0/0xa
 [<c014fda7>] ? lru_add_drain_per_cpu+0x0/0xa
 [<c012a7a6>] schedule_on_each_cpu+0x65/0x7f
 [<c014fb7e>] lru_add_drain_all+0xd/0xf
 [<c0157fb2>] __mlock_vma_pages_range+0x44/0x206
 [<c0159438>] ? vma_adjust+0x17e/0x384
 [<c015971f>] ? split_vma+0xe1/0xf7
 [<c01582d1>] mlock_fixup+0x15d/0x1c9
 [<c0158479>] do_mlock+0x96/0xc8
 [<c02bcb2a>] ? down_write+0x42/0x68
 [<c015860e>] sys_mlock+0xb2/0xb6
 [<c0102f91>] sysenter_do_call+0x12/0x35

--Boundary-00=_LuMCJV/DLS7OhqJ
Content-Type: application/x-gzip;
  name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config.gz"

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

--Boundary-00=_LuMCJV/DLS7OhqJ--
