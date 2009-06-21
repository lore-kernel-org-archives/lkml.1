Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZFURdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZFURdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 13:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZFURdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 13:33:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52613 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZFURda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 13:33:30 -0400
Date: Sun, 21 Jun 2009 13:33:31 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.30 fb/mmap lockdep report.
Message-ID: <20090621173330.GA26093@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.30-6.fc12.i686.PAE #1
-------------------------------------------------------
plymouthd/36 is trying to acquire lock:
 (&fb_info->lock){+.+.+.}, at: [<c0601229>] fb_mmap+0x94/0x17d

but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<c040de41>] sys_mmap2+0x72/0xb9

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&mm->mmap_sem){++++++}:
       [<c046c634>] __lock_acquire+0x996/0xb08
       [<c046c85d>] lock_acquire+0xb7/0xeb
       [<c04c79ae>] might_fault+0x73/0xa4
       [<c05d6dc8>] copy_to_user+0x41/0x12b
       [<c04f57d1>] filldir+0x90/0xdc
       [<c0535cb4>] sysfs_readdir+0x11a/0x161
       [<c04f5989>] vfs_readdir+0x7b/0xb8
       [<c04f5b09>] sys_getdents+0x74/0xc9
       [<c0409feb>] sysenter_do_call+0x12/0x38
       [<ffffffff>] 0xffffffff

-> #2 (sysfs_mutex){+.+.+.}:
       [<c046c634>] __lock_acquire+0x996/0xb08
       [<c046c85d>] lock_acquire+0xb7/0xeb
       [<c07f3faf>] __mutex_lock_common+0x43/0x32b
       [<c07f438a>] mutex_lock_nested+0x41/0x5a
       [<c053607e>] sysfs_addrm_start+0x34/0xb2
       [<c05368f6>] create_dir+0x50/0x93
       [<c0536976>] sysfs_create_dir+0x3d/0x5e
       [<c05d023c>] kobject_add_internal+0xfa/0x1d1
       [<c05d0414>] kobject_add_varg+0x41/0x5e
       [<c05d04d1>] kobject_add+0x51/0x68
       [<c068624b>] device_add+0xec/0x4aa
       [<c0686630>] device_register+0x27/0x3c
       [<c06866f1>] device_create_vargs+0xac/0xe5
       [<c0686758>] device_create+0x2e/0x41
       [<c0669a4b>] register_con_driver+0xbb/0x126
       [<c066adc9>] take_over_console+0x2f/0x61
       [<c060dae8>] fbcon_takeover+0x6f/0xb3
       [<c060e10f>] fbcon_event_notify+0x296/0x60e
       [<c07f7fba>] notifier_call_chain+0x5d/0x95
       [<c045eef5>] __blocking_notifier_call_chain+0x52/0x78
       [<c045ef3c>] blocking_notifier_call_chain+0x21/0x37
       [<c0600b1d>] fb_notifier_call_chain+0x25/0x38
       [<c0602cd6>] register_framebuffer+0x1f6/0x218
       [<c0a62cc7>] vesafb_probe+0x5bc/0x638
       [<c068a05c>] platform_drv_probe+0x20/0x33
       [<c0688ea1>] driver_probe_device+0xca/0x1d9
       [<c0689071>] __device_attach+0x3d/0x53
       [<c0687fdc>] bus_for_each_drv+0x55/0x90
       [<c0689127>] device_attach+0x5a/0x7f
       [<c0687df8>] bus_attach_device+0x34/0x70
       [<c068649b>] device_add+0x33c/0x4aa
       [<c068abe0>] platform_device_add+0xfa/0x169
       [<c0a62f23>] vesafb_init+0x1e0/0x214
       [<c040309e>] do_one_initcall+0x75/0x193
       [<c0a384ff>] kernel_init+0x189/0x1eb
       [<c040abcf>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #1 ((fb_notifier_list).rwsem){.+.+.+}:
       [<c046c634>] __lock_acquire+0x996/0xb08
       [<c046c85d>] lock_acquire+0xb7/0xeb
       [<c07f46c5>] down_read+0x45/0x93
       [<c045eee3>] __blocking_notifier_call_chain+0x40/0x78
       [<c045ef3c>] blocking_notifier_call_chain+0x21/0x37
       [<c0600b1d>] fb_notifier_call_chain+0x25/0x38
       [<c0602cd6>] register_framebuffer+0x1f6/0x218
       [<c0a62cc7>] vesafb_probe+0x5bc/0x638
       [<c068a05c>] platform_drv_probe+0x20/0x33
       [<c0688ea1>] driver_probe_device+0xca/0x1d9
       [<c0689071>] __device_attach+0x3d/0x53
       [<c0687fdc>] bus_for_each_drv+0x55/0x90
       [<c0689127>] device_attach+0x5a/0x7f
       [<c0687df8>] bus_attach_device+0x34/0x70
       [<c068649b>] device_add+0x33c/0x4aa
       [<c068abe0>] platform_device_add+0xfa/0x169
       [<c0a62f23>] vesafb_init+0x1e0/0x214
       [<c040309e>] do_one_initcall+0x75/0x193
       [<c0a384ff>] kernel_init+0x189/0x1eb
       [<c040abcf>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (&fb_info->lock){+.+.+.}:
       [<c046c53b>] __lock_acquire+0x89d/0xb08
       [<c046c85d>] lock_acquire+0xb7/0xeb
       [<c07f3faf>] __mutex_lock_common+0x43/0x32b
       [<c07f438a>] mutex_lock_nested+0x41/0x5a
       [<c0601229>] fb_mmap+0x94/0x17d
       [<c04cf7f8>] mmap_region+0x272/0x404
       [<c04cfbfd>] do_mmap_pgoff+0x273/0x2d6
       [<c040de55>] sys_mmap2+0x86/0xb9
       [<c0409feb>] sysenter_do_call+0x12/0x38
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by plymouthd/36:
 #0:  (&mm->mmap_sem){++++++}, at: [<c040de41>] sys_mmap2+0x72/0xb9

stack backtrace:
Pid: 36, comm: plymouthd Not tainted 2.6.30-6.fc12.i686.PAE #1
Call Trace:
 [<c07f2af5>] ? printk+0x22/0x35
 [<c046b986>] print_circular_bug_tail+0x68/0x84
 [<c046c53b>] __lock_acquire+0x89d/0xb08
 [<c046c85d>] lock_acquire+0xb7/0xeb
 [<c0601229>] ? fb_mmap+0x94/0x17d
 [<c0601229>] ? fb_mmap+0x94/0x17d
 [<c07f3faf>] __mutex_lock_common+0x43/0x32b
 [<c0601229>] ? fb_mmap+0x94/0x17d
 [<c0601229>] ? fb_mmap+0x94/0x17d
 [<c046afe6>] ? mark_held_locks+0x4e/0x78
 [<c07f438a>] mutex_lock_nested+0x41/0x5a
 [<c0601229>] ? fb_mmap+0x94/0x17d
 [<c0601229>] fb_mmap+0x94/0x17d
 [<c04cf7f8>] mmap_region+0x272/0x404
 [<c04cfbfd>] do_mmap_pgoff+0x273/0x2d6
 [<c040de55>] sys_mmap2+0x86/0xb9
 [<c0409feb>] sysenter_do_call+0x12/0x38

