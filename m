Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZEXEk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZEXEk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 00:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbZEXEku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 00:40:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:27842 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbZEXEkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 00:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VcjfnFB6Cb6onWHafyVUDzmBgSFhqpUNGJlAWExBltKRz+MTAexu4FYkPoLQ5IF8Jk
         w32l99S4b9P8tivZ0n7NwETtg8xvZ/dF9Ezdb02IueTqEZmKknz4uK/5KIx76v90T8Lu
         llpziLQEp1QOq2F3SQLmOdEizCXcWFpVV4XxY=
MIME-Version: 1.0
Date: Sun, 24 May 2009 00:40:50 -0400
Message-ID: <a44ae5cd0905232140n159ce946xfb8c988c1e477185@mail.gmail.com>
Subject: 2.6.30-rc7 - (&dev->mode_config.mutex){+.+.+.}, at: 
	[<ffffffff804407af>] drm_mode_getresources+0x2f/0x54f - INFO: possible 
	circular locking dependency detected
From: Miles Lane <miles.lane@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   38.564164] [ INFO: possible circular locking dependency detected ]
[   38.564167] 2.6.30-rc7 #2
[   38.564170] -------------------------------------------------------
[   38.564173] Xorg/3110 is trying to acquire lock:
[   38.564176]  (&mm->mmap_sem){++++++}, at: [<ffffffff802a880c>]
might_fault+0x64/0xb8
[   38.564188]
[   38.564189] but task is already holding lock:
[   38.564192]  (&dev->mode_config.mutex){+.+.+.}, at:
[<ffffffff804407af>] drm_mode_getresources+0x2f/0x54f
[   38.564203]
[   38.564204] which lock already depends on the new lock.
[   38.564205]
[   38.564208]
[   38.564208] the existing dependency chain (in reverse order) is:
[   38.564212]
[   38.564212] -> #3 (&dev->mode_config.mutex){+.+.+.}:
[   38.564219]        [<ffffffff8025fabf>] __lock_acquire+0xa39/0xbc9
[   38.564226]        [<ffffffff8025fd43>] lock_acquire+0xf4/0x118
[   38.564231]        [<ffffffff8057e47a>] __mutex_lock_common+0x5a/0x40c
[   38.564239]        [<ffffffff8057e8cc>] mutex_lock_nested+0x32/0x37
[   38.564244]        [<ffffffff80459aee>] intelfb_pan_display+0x86/0xf7
[   38.564251]        [<ffffffff803cf371>] fb_pan_display+0xca/0x111
[   38.564257]        [<ffffffff803dc5d0>] bit_update_start+0x1b/0x44
[   38.564262]        [<ffffffff803d993f>] fbcon_switch+0x3fb/0x400
[   38.564262]        [<ffffffff80427c9a>] redraw_screen+0xc9/0x162
[   38.564262]        [<ffffffff803daf0c>] fbcon_prepare_logo+0x24f/0x2e1
[   38.564262]        [<ffffffff803db7de>] fbcon_init+0x36c/0x3fc
[   38.564262]        [<ffffffff80426017>] visual_init+0x9a/0xd9
[   38.564262]        [<ffffffff80427eb6>] bind_con_driver+0x183/0x2af
[   38.564262]        [<ffffffff80428019>] take_over_console+0x37/0x44
[   38.564262]        [<ffffffff803daff5>] fbcon_takeover+0x57/0x85
[   38.564262]        [<ffffffff803dbf06>] fbcon_event_notify+0x319/0x677
[   38.564262]        [<ffffffff80582763>] notifier_call_chain+0x63/0x97
[   38.564262]        [<ffffffff80253aba>]
__blocking_notifier_call_chain+0x4b/0x62
[   38.564262]        [<ffffffff80253ae0>] blocking_notifier_call_chain+0xf/0x11
[   38.564262]        [<ffffffff803cf06e>] fb_notifier_call_chain+0x16/0x18
[   38.564262]        [<ffffffff803d1329>] register_framebuffer+0x22a/0x23f
[   38.564262]        [<ffffffff8045a902>] intelfb_probe+0x4ef/0x573
[   38.564262]        [<ffffffff8044410e>] drm_helper_initial_config+0x173/0x184
[   38.564262]        [<ffffffff804499d4>] i915_driver_load+0x8c7/0x929
[   38.564262]        [<ffffffff8043c68c>] drm_get_dev+0x381/0x485
[   38.564262]        [<ffffffff80573b38>] i915_pci_probe+0x10/0x12
[   38.564262]        [<ffffffff803c1757>] local_pci_probe+0x12/0x16
[   38.564262]        [<ffffffff803c2456>] pci_device_probe+0x60/0x8f
[   38.564262]        [<ffffffff804694a2>] driver_probe_device+0x9d/0x122
[   38.564262]        [<ffffffff8046957f>] __driver_attach+0x58/0x7c
[   38.564262]        [<ffffffff80468b90>] bus_for_each_dev+0x54/0x89
[   38.564262]        [<ffffffff8046931b>] driver_attach+0x19/0x1b
[   38.564262]        [<ffffffff80469017>] bus_add_driver+0xae/0x1e7
[   38.564262]        [<ffffffff8046981f>] driver_register+0x98/0x105
[   38.564262]        [<ffffffff803c268c>] __pci_register_driver+0x63/0xd3
[   38.564262]        [<ffffffff80437ed8>] drm_init+0x68/0xce
[   38.564262]        [<ffffffff807cafa0>] i915_init+0x4b/0x4d
[   38.564262]        [<ffffffff8020906b>] do_one_initcall+0x65/0x153
[   38.564262]        [<ffffffff807a765b>] kernel_init+0x14e/0x1a4
[   38.564262]        [<ffffffff8020cd3a>] child_rip+0xa/0x20
[   38.564262]        [<ffffffffffffffff>] 0xffffffffffffffff
[   38.564262]
[   38.564262] -> #2 ((fb_notifier_list).rwsem){.+.+.+}:
[   38.564262]        [<ffffffff8025fabf>] __lock_acquire+0xa39/0xbc9
[   38.564262]        [<ffffffff8025fd43>] lock_acquire+0xf4/0x118
[   38.564262]        [<ffffffff8057ec02>] down_read+0x40/0x4f
[   38.564262]        [<ffffffff80253aa3>]
__blocking_notifier_call_chain+0x34/0x62
[   38.564262]        [<ffffffff80253ae0>] blocking_notifier_call_chain+0xf/0x11
[   38.564262]        [<ffffffff803cf06e>] fb_notifier_call_chain+0x16/0x18
[   38.564262]        [<ffffffff803d1329>] register_framebuffer+0x22a/0x23f
[   38.564262]        [<ffffffff8045a902>] intelfb_probe+0x4ef/0x573
[   38.564262]        [<ffffffff8044410e>] drm_helper_initial_config+0x173/0x184
[   38.564262]        [<ffffffff804499d4>] i915_driver_load+0x8c7/0x929
[   38.564262]        [<ffffffff8043c68c>] drm_get_dev+0x381/0x485
[   38.564262]        [<ffffffff80573b38>] i915_pci_probe+0x10/0x12
[   38.564262]        [<ffffffff803c1757>] local_pci_probe+0x12/0x16
[   38.564262]        [<ffffffff803c2456>] pci_device_probe+0x60/0x8f
[   38.564262]        [<ffffffff804694a2>] driver_probe_device+0x9d/0x122
[   38.564262]        [<ffffffff8046957f>] __driver_attach+0x58/0x7c
[   38.564262]        [<ffffffff80468b90>] bus_for_each_dev+0x54/0x89
[   38.564262]        [<ffffffff8046931b>] driver_attach+0x19/0x1b
[   38.564262]        [<ffffffff80469017>] bus_add_driver+0xae/0x1e7
[   38.564262]        [<ffffffff8046981f>] driver_register+0x98/0x105
[   38.564262]        [<ffffffff803c268c>] __pci_register_driver+0x63/0xd3
[   38.564262]        [<ffffffff80437ed8>] drm_init+0x68/0xce
[   38.564262]        [<ffffffff807cafa0>] i915_init+0x4b/0x4d
[   38.564262]        [<ffffffff8020906b>] do_one_initcall+0x65/0x153
[   38.564262]        [<ffffffff807a765b>] kernel_init+0x14e/0x1a4
[   38.564262]        [<ffffffff8020cd3a>] child_rip+0xa/0x20
[   38.564262]        [<ffffffffffffffff>] 0xffffffffffffffff
[   38.564262]
[   38.564262] -> #1 (&fb_info->lock){+.+.+.}:
[   38.564262]        [<ffffffff8025fabf>] __lock_acquire+0xa39/0xbc9
[   38.564262]        [<ffffffff8025fd43>] lock_acquire+0xf4/0x118
[   38.564262]        [<ffffffff8057e47a>] __mutex_lock_common+0x5a/0x40c
[   38.564262]        [<ffffffff8057e8cc>] mutex_lock_nested+0x32/0x37
[   38.564262]        [<ffffffff803cf624>] fb_mmap+0xa1/0x190
[   38.564262]        [<ffffffff802aff81>] mmap_region+0x2a7/0x483
[   38.564262]        [<ffffffff802b0454>] do_mmap_pgoff+0x2f7/0x35a
[   38.564262]        [<ffffffff8020fb53>] sys_mmap+0x97/0xd8
[   38.564262]        [<ffffffff8020bc2b>] system_call_fastpath+0x16/0x1b
[   38.564262]        [<ffffffffffffffff>] 0xffffffffffffffff
[   38.564262]
[   38.564262] -> #0 (&mm->mmap_sem){++++++}:
[   38.564262]        [<ffffffff8025f99c>] __lock_acquire+0x916/0xbc9
[   38.564262]        [<ffffffff8025fd43>] lock_acquire+0xf4/0x118
[   38.564262]        [<ffffffff802a8839>] might_fault+0x91/0xb8
[   38.564262]        [<ffffffff80440a09>] drm_mode_getresources+0x289/0x54f
[   38.564262]        [<ffffffff80438486>] drm_ioctl+0x21e/0x2ec
[   38.564262]        [<ffffffff802cfed2>] vfs_ioctl+0x6a/0x82
[   38.564262]        [<ffffffff802d034d>] do_vfs_ioctl+0x463/0x4a4
[   38.564262]        [<ffffffff802d03df>] sys_ioctl+0x51/0x74
[   38.564262]        [<ffffffff8020bc2b>] system_call_fastpath+0x16/0x1b
[   38.564262]        [<ffffffffffffffff>] 0xffffffffffffffff
[   38.564262]
[   38.564262] other info that might help us debug this:
[   38.564262]
[   38.564262] 1 lock held by Xorg/3110:
[   38.564262]  #0:  (&dev->mode_config.mutex){+.+.+.}, at:
[<ffffffff804407af>] drm_mode_getresources+0x2f/0x54f
[   38.564262]
[   38.564262] stack backtrace:
[   38.564262] Pid: 3110, comm: Xorg Not tainted 2.6.30-rc7 #2
[   38.564262] Call Trace:
[   38.564262]  [<ffffffff8025ed21>] print_circular_bug_tail+0x71/0x7c
[   38.564262]  [<ffffffff8025f99c>] __lock_acquire+0x916/0xbc9
[   38.564262]  [<ffffffff802a880c>] ? might_fault+0x64/0xb8
[   38.564262]  [<ffffffff8025fd43>] lock_acquire+0xf4/0x118
[   38.564262]  [<ffffffff802a880c>] ? might_fault+0x64/0xb8
[   38.564262]  [<ffffffff802a8839>] might_fault+0x91/0xb8
[   38.564262]  [<ffffffff802a880c>] ? might_fault+0x64/0xb8
[   38.564262]  [<ffffffff80440a09>] drm_mode_getresources+0x289/0x54f
[   38.564262]  [<ffffffff803753ac>] ? __rcu_read_lock+0x0/0x3a
[   38.564262]  [<ffffffff80440780>] ? drm_mode_getresources+0x0/0x54f
[   38.564262]  [<ffffffff80438486>] drm_ioctl+0x21e/0x2ec
[   38.564262]  [<ffffffff802cfed2>] vfs_ioctl+0x6a/0x82
[   38.564262]  [<ffffffff802d034d>] do_vfs_ioctl+0x463/0x4a4
[   38.564262]  [<ffffffff802d03df>] sys_ioctl+0x51/0x74
[   38.564262]  [<ffffffff8020bc2b>] system_call_fastpath+0x16/0x1b
