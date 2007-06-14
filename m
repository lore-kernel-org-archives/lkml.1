Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbXFNPmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbXFNPmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXFNPmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:42:44 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:54664 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbXFNPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lZNthfiY5tyctPdSDETqevSBjt02O5MvJQyalob7aMrO/RuhRiOUNYHyOSLLhlfoe8lkUQirdQ0rjnekQLmpo54iszzxFdEHUat47rgOHcW1vEVBZYtgkB+3RnbZ4xapJ5Mu93axRqGq0OTogAnBkwS/Sz/av+M5tjlpoblk+S0=
Message-ID: <745af2c30706140842w5eabdf1bjdcc5fd7c2a92b77e@mail.gmail.com>
Date: Thu, 14 Jun 2007 16:42:40 +0100
From: "Tom Robinson" <thomas.robinson@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: kernel BUG at mm/swap_state.c:78! (v2.6.21 under vmware)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Experienced this strange crash this morning and was wondering if
anyone could tell me what it might be.  The system in question was
running under vmware but with a physical hard disk.  Originally I
thought it might be a memory problem so I ran memtest86+ and checked
the swap with mkswap -c but neither reported any problems.

The kernel is a clean compile of version 2.6.21 with no modules loaded.

/proc/version shows:
Linux version 2.6.21 (root@acid) (gcc version 4.1.2 20061115
(prerelease) (Debian 4.1.1-21)) #2 SMP Wed Jun 13 10:36:40 BST 2007

Outputs from other /proc/xxx as given in the bug reporting guidelines
are at the bottom of the email.

Full text of the logfile is below.  It also includes all the messages
spat out by the kernel when I rebooted it afterwards, incase that will
help diagnose the problem.

Cheers,

Tom

Jun 14 06:26:51 acid kernel: ------------[ cut here ]------------
Jun 14 06:26:51 acid kernel: kernel BUG at mm/swap_state.c:78!
Jun 14 06:26:51 acid kernel: invalid opcode: 0000 [#2]
Jun 14 06:26:51 acid kernel: SMP
Jun 14 06:26:51 acid kernel: Modules linked in:
Jun 14 06:26:51 acid kernel: CPU:    0
Jun 14 06:26:51 acid kernel: EIP:    0060:[<c0148123>]    Not tainted VLI
Jun 14 06:26:51 acid kernel: EFLAGS: 00010202   (2.6.21 #2)
Jun 14 06:26:51 acid kernel: EIP is at __add_to_swap_cache+0x1e/0x8e
Jun 14 06:26:51 acid kernel: eax: 40000849   ebx: c1181400   ecx:
00010220   edx: 00000002
Jun 14 06:26:51 acid kernel: esi: 00000002   edi: 00000002   ebp:
c0517700   esp: d1a83e10
Jun 14 06:26:51 acid kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Jun 14 06:26:51 acid kernel: Process kswapd0 (pid: 157, ti=d1a82000
task=c12fba50 task.ti=d1a82000)
Jun 14 06:26:51 acid kernel: Stack: c1181400 00000002 00000020
c0148497 c1181400 c9381208 00000001 c013e107
Jun 14 06:26:51 acid kernel:        d1a83f14 c0568b30 d1a83f7c
00000020 00000000 00000000 00000020 00000004
Jun 14 06:26:51 acid kernel:        00000001 00000000 00000020
00000004 00000001 c119c800 c10daaa0 c10d1740
Jun 14 06:26:51 acid kernel: Call Trace:
Jun 14 06:26:51 acid kernel:  [<c0148497>] add_to_swap+0x2d/0x66
Jun 14 06:26:51 acid kernel:  [<c013e107>] shrink_inactive_list+0x1e9/0x742
Jun 14 06:26:51 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:26:51 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:26:51 acid kernel:  [<c013ebcb>] kswapd+0x2a4/0x3cf
Jun 14 06:26:51 acid kernel:  [<c01296ed>] autoremove_wake_function+0x0/0x35
Jun 14 06:26:51 acid kernel:  [<c013e927>] kswapd+0x0/0x3cf
Jun 14 06:26:51 acid kernel:  [<c0129624>] kthread+0xb0/0xd8
Jun 14 06:26:51 acid kernel:  [<c0129574>] kthread+0x0/0xd8
Jun 14 06:26:51 acid kernel:  [<c0103cab>] kernel_thread_helper+0x7/0x10
Jun 14 06:26:51 acid kernel:  =======================
Jun 14 06:26:51 acid kernel: Code: ff 05 18 a0 61 c0 89 15 14 a0 61 c0
c3 57 89 d7 56 53 89 c3 8b 00 25 00 80 00 00 66 85 c0 74 04 0f 0b eb
fe 8b 03 f6 c4 08 74 04 <0f> 0b eb fe 89 c8 e8 06 f3 0b 00 85 c0 89 c6
75 59 b8 b0 9d 51
Jun 14 06:26:51 acid kernel: EIP: [<c0148123>]
__add_to_swap_cache+0x1e/0x8e SS:ESP 0068:d1a83e10
Jun 14 06:26:58 acid kernel: Bad page state in process 'find'
Jun 14 06:26:58 acid kernel: page:c11ae9c0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:26:59 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:26:59 acid kernel: Backtrace:
Jun 14 06:26:59 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:26:59 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:26:59 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:26:59 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:26:59 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:26:59 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:26:59 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:26:59 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:26:59 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:26:59 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:26:59 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:26:59 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:26:59 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:26:59 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:26:59 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:26:59 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:26:59 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:26:59 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:26:59 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:26:59 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:26:59 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:26:59 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:26:59 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:26:59 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:26:59 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:26:59 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:26:59 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:26:59 acid kernel:  =======================
Jun 14 06:26:59 acid kernel: Bad page state in process 'find'
Jun 14 06:26:59 acid kernel: page:c1083000 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:26:59 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:26:59 acid kernel: Backtrace:
Jun 14 06:26:59 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:26:59 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:26:59 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:26:59 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:26:59 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:26:59 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:26:59 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:26:59 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:26:59 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:26:59 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:26:59 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:26:59 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:26:59 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:26:59 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:26:59 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:26:59 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:26:59 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:26:59 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:26:59 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:26:59 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:26:59 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:26:59 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:26:59 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:26:59 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:26:59 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:26:59 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:26:59 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:26:59 acid kernel:  =======================
Jun 14 06:26:59 acid kernel: Bad page state in process 'find'
Jun 14 06:26:59 acid kernel: page:c1181160 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:26:59 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:26:59 acid kernel: Backtrace:
Jun 14 06:26:59 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:26:59 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:26:59 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:26:59 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:00 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:00 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:00 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:00 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:00 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:00 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:27:00 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:00 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:00 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:00 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:00 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:00 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:00 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:00 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:00 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:00 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:00 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:00 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:00 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:00 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:00 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:00 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:00 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:00 acid kernel:  =======================
Jun 14 06:27:00 acid kernel: Bad page state in process 'find'
Jun 14 06:27:00 acid kernel: page:c121a020 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:00 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:00 acid kernel: Backtrace:
Jun 14 06:27:00 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:00 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:00 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:00 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:00 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:00 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:00 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:00 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:00 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:00 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:27:00 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:00 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:00 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:00 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:00 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:00 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:00 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:00 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:00 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:00 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:00 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:00 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:00 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:00 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:00 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:00 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:00 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:00 acid kernel:  =======================
Jun 14 06:27:00 acid kernel: Bad page state in process 'find'
Jun 14 06:27:00 acid kernel: page:c1044f40 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:01 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:01 acid kernel: Backtrace:
Jun 14 06:27:01 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:01 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:01 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:01 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:01 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:01 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:01 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:01 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:01 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:01 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:27:01 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:01 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:01 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:01 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:01 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:01 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:01 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:01 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:01 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:01 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:01 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:01 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:01 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:01 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:01 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:01 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:01 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:01 acid kernel:  =======================
Jun 14 06:27:01 acid kernel: Bad page state in process 'find'
Jun 14 06:27:01 acid kernel: page:c1034a40 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:02 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:02 acid kernel: Backtrace:
Jun 14 06:27:02 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:02 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:02 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:02 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:02 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:02 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:02 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:02 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:02 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:02 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:27:02 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:02 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:02 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:02 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:02 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:02 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:02 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:02 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:02 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:02 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:02 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:02 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:02 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:02 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:02 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:02 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:02 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:02 acid kernel:  =======================
Jun 14 06:27:02 acid kernel: Bad page state in process 'find'
Jun 14 06:27:02 acid kernel: page:c1100080 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:02 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:02 acid kernel: Backtrace:
Jun 14 06:27:03 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:03 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:03 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:03 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:03 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:03 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:03 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:03 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:03 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:03 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:27:03 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:03 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:03 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:03 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:03 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:03 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:03 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:03 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:03 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:03 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:03 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:03 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:03 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:03 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:03 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:03 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:03 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:03 acid kernel:  =======================
Jun 14 06:27:03 acid kernel: Bad page state in process 'find'
Jun 14 06:27:03 acid kernel: page:c102a080 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:03 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:03 acid kernel: Backtrace:
Jun 14 06:27:03 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:03 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:03 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:03 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:03 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:03 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:03 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:03 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:03 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:03 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:27:03 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:03 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:03 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:03 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:03 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:03 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:03 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:03 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:03 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:03 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:03 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:03 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:03 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:03 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:03 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:03 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:03 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:03 acid kernel:  =======================
Jun 14 06:27:03 acid kernel: Bad page state in process 'find'
Jun 14 06:27:03 acid kernel: page:c11257e0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:03 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:03 acid kernel: Backtrace:
Jun 14 06:27:03 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:03 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:03 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:03 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:03 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:03 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:03 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:03 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:03 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:03 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:27:03 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:03 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:03 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:03 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:03 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:03 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:03 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:03 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:03 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:03 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:03 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:03 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:03 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:03 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:03 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:03 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:03 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:03 acid kernel:  =======================
Jun 14 06:27:03 acid kernel: Bad page state in process 'find'
Jun 14 06:27:03 acid kernel: page:c11383a0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:03 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:05 acid kernel: Backtrace:
Jun 14 06:27:05 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:05 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:05 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:05 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:05 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:05 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:05 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:05 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:05 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:05 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:27:05 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:05 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:05 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:05 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:05 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:05 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:05 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:05 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:05 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:05 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:05 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:05 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:05 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:05 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:05 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:05 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:05 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:05 acid kernel:  =======================
Jun 14 06:27:05 acid kernel: Bad page state in process 'find'
Jun 14 06:27:05 acid kernel: page:c1040780 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:05 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:05 acid kernel: Backtrace:
Jun 14 06:27:05 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:05 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:05 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:05 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:05 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:05 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:05 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:05 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:05 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:05 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:27:05 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:05 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:05 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:05 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:05 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:05 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:05 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:05 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:05 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:05 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:05 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:05 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:05 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:05 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:05 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:05 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:05 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:05 acid kernel:  =======================
Jun 14 06:27:05 acid kernel: Bad page state in process 'find'
Jun 14 06:27:05 acid kernel: page:c122db80 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:06 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:07 acid kernel: Backtrace:
Jun 14 06:27:08 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:08 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:08 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:08 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:08 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:08 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:08 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:08 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:08 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:08 acid kernel:  [<c02b8bfb>] ide_map_sg+0x26/0x71
Jun 14 06:27:08 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:08 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:08 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:08 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:08 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:08 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:08 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:08 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:08 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:08 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:08 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:08 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:08 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:08 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:08 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:08 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:08 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:08 acid kernel:  =======================
Jun 14 06:27:08 acid kernel: Bad page state in process 'find'
Jun 14 06:27:08 acid kernel: page:c1220180 flags:0x40000040
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:08 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:12 acid kernel: Backtrace:
Jun 14 06:27:12 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:12 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:12 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:12 acid kernel:  [<c00 mapcount:0 count:0
Jun 14 06:27:12 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:12 acid kernel: Backtrace:
Jun 14 06:27:12 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:12 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:12 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:12 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:12 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:12 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:12 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:12 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:12 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:12 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:12 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:12 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:27:12 acid kernel:  [<c01296ed>] autoremove_wake_function+0x0/0x35
Jun 14 06:27:12 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:12 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:12 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:12 acid kernel:  =======================
Jun 14 06:27:12 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:12 acid kernel: page:c10f8a80 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:13 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:13 acid kernel: Backtrace:
Jun 14 06:27:13 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:13 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:13 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:13 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:13 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:13 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:13 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:13 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:13 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:13 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:13 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:13 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:27:13 acid kernel:  [<c01296ed>] autoremove_wake_function+0x0/0x35
Jun 14 06:27:13 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:13 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:13 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:13 acid kernel:  =======================
Jun 14 06:27:13 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:13 acid kernel: page:c1088880 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:13 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:15 acid kernel: Backtrace:
Jun 14 06:27:15 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:15 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:15 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:15 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:15 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:15 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:15 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:15 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:15 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:15 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:15 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:15 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:27:15 acid kernel:  [<c01296ed>] autoremove_wake_function+0x0/0x35
Jun 14 06:27:15 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:15 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:15 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:15 acid kernel:  =======================
Jun 14 06:27:15 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:15 acid kernel: page:c115b0e0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:15 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:15 acid kernel: Backtrace:
Jun 14 06:27:17 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:17 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:17 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:17 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:17 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:17 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:18 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:18 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:18 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:18 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:18 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:18 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:27:18 acid kernel:  [<c01296ed>] autoremove_wake_function+0x0/0x35
Jun 14 06:27:18 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:18 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:18 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:18 acid kernel:  =======================
Jun 14 06:27:18 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:18 acid kernel: page:c114c9a0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:21 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:21 acid kernel: Backtrace:
Jun 14 06:27:22 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:22 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:22 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:22 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:22 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:22 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:22 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:22 acid kernel:  [<c013f099>]
try_to_free_pages+ndle_edge_irq+0xda/0xfa
Jun 14 06:27:22 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:27:22 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:22 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:22 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:22 acid kernel:  =======================
Jun 14 06:27:22 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:23 acid kernel: page:c116f700 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:25 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:25 acid kernel: Backtrace:
Jun 14 06:27:28 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:28 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:28 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:28 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:28 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:28 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:28 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:28 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:28 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:28 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:28 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:28 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:28 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:27:28 acid kernel:  [<c013627f>] handle_edge_irq+0xda/0xfa
Jun 14 06:27:28 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:27:28 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:28 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:28 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:28 acid kernel:  =======================
Jun 14 06:27:28 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:28 acid kernel: page:c10d0700 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:28 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:28 acid kernel: Backtrace:
Jun 14 06:27:28 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:28 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:28 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:28 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:28 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:28 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:28 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:28 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:29 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:29 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:29 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:29 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:29 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:27:29 acid kernel:  [<c013627f>] handle_edge_irq+0xda/0xfa
Jun 14 06:27:29 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:27:29 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:29 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:29 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:29 acid kernel:  =======================
Jun 14 06:27:29 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:29 acid kernel: page:c1095b60 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:29 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:30 acid kernel: Backtrace:
Jun 14 06:27:31 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:31 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:31 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:31 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:31 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:31 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:31 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:31 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:31 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:31 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:31 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:31 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:31 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:27:31 acid kernel:  [<c013627f>] handle_edge_irq+0xda/0xfa
Jun 14 06:27:31 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:27:31 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:31 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:31 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:31 acid kernel:  =======================
Jun 14 06:27:31 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:33 acid kernel: page:c112bae0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:33 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:33 acid kernel: Backtrace:
Jun 14 06:27:33 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:33 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:33 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:33 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:33 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:33 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:33 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:33 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:33 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:33 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:33 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:33 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:33 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:27:33 acid kernel:  [<c013627f>] handle_edge_irq+0xda/0xfa
Jun 14 06:27:33 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:27:33 acid kernel:  [<c03f9bac>] acktrace:
Jun 14 06:27:33 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:33 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:33 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:33 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:33 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:33 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:33 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:33 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:33 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:33 acid kernel:  [<c013b14c>] __alloc_pages+0xe0/0x28d
Jun 14 06:27:33 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:33 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:33 acid kernel:  [<c0118073>] mm_init+0x7b/0x9d
Jun 14 06:27:33 acid kernel:  [<c01189ce>] copy_process+0x7f6/0xfb3
Jun 14 06:27:33 acid kernel:  [<c01193c8>] do_fork+0x9e/0x17e
Jun 14 06:27:33 acid kernel:  [<c0209ee8>] copy_to_user+0x2d/0x41
Jun 14 06:27:33 acid kernel:  [<c0101589>] sys_clone+0x36/0x3b
Jun 14 06:27:33 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:33 acid kernel:  =======================
Jun 14 06:27:33 acid kernel: Bad page state in process 'syslogd'
Jun 14 06:27:33 acid kernel: page:c10e9fe0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:35 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:35 acid kernel: Backtrace:
Jun 14 06:27:35 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:35 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:35 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:35 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:35 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:35 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:35 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:35 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:35 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:35 acid kernel:  [<c013b14c>] __alloc_pages+0xe0/0x28d
Jun 14 06:27:35 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:35 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:35 acid kernel:  [<c0118073>] mm_init+0x7b/0x9d
Jun 14 06:27:35 acid kernel:  [<c01189ce>] copy_process+0x7f6/0xfb3
Jun 14 06:27:35 acid kernel:  [<c01193c8>] do_fork+0x9e/0x17e
Jun 14 06:27:35 acid kernel:  [<c0209ee8>] copy_to_user+0x2d/0x41
Jun 14 06:27:35 acid kernel:  [<c0101589>] sys_clone+0x36/0x3b
Jun 14 06:27:35 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:35 acid kernel:  =======================
Jun 14 06:27:35 acid kernel: Bad page state in process 'syslogd'
Jun 14 06:27:35 acid kernel: page:c10a3040 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:35 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:35 acid kernel: Backtrace:
Jun 14 06:27:35 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:35 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:35 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:35 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:35 acid kernel:  [<c013defb>] remove_mapping+0x8e/0xb1
Jun 14 06:27:35 acid kernel:  [<c013e479>] shrink_inactive_list+0x55b/0x742
Jun 14 06:27:35 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:35 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:35 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:35 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:35 acid kernel:  [<c013b14c>] __alloc_pages+0xe0/0x28d
Jun 14 06:27:35 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:35 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:35 acid kernel:  [<c0118073>] mm_init+0x7b/0x9d
Jun 14 06:27:35 acid kernel:  [<c01189ce>] copy_process+0x7f6/0xfb3
Jun 14 06:27:35 acid kernel:  [<c01193c8>] do_fork+0x9e/0x17e
Jun 14 06:27:35 acid kernel:  [<c0209ee8>] copy_to_user+0x2d/0x41
Jun 14 06:27:35 acid kernel:  [<c0101589>] sys_clone+0x36/0x3b
Jun 14 06:27:35 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:35 acid kernel:  =======================
Jun 14 06:27:35 acid kernel: Bad page state in process 'syslogd'
Jun 14 06:27:35 acid kernel: page:c10bc2a0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:35 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:35 acid kernel: Backtrace:
Jun 14 06:27:36 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:36 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:36 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:36 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:36 acid kernel:  [<c013defb>] remove_mapping+0x8e/0xb1
Jun 14 06:27:36 acid kernel:  [<c013e479>] shrink_inactive_list+0x55b/0x742
Jun 14 06:27:36 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:36 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:36 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:36 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:36 acid kernel:  [<c013b14c>] __alloc_pages+0xe0/0x28d
Jun 14 06:27:36 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:36 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:36 acid kernel:  [<c0118073>] mm_init+0x7b/0x9d
Jun 14 06:27:36 acid kernel:  [<c01189ce>] copy_process+0x7f6/0xfb3
Jun 14 06:27:36 acid kernel:  [<c01193c8>] do_fork+0x9e/0x17e
Jun 14 06:27:36 acid kernel:  [<c0209ee8>] copy_to_user+0x2d/0x41
Jun 14 06:27:36 acid kernel:  [<c0101589>] sys_clone+0x36/0x3b
Jun 14 06:27:36 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:36 acid kernel:  =======================
Jun 14 06:27:36 acid kernel: Bad page state in process 'syslogd'
Jun 14 06:27:36 acid kernel: page:c110c5e0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:36 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:36 acid kernel: Backtrace:
Jun 14 06:27:36 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:36 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:36 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:36 acid kernel:  [<c013d248>] __px3b3/0x7cd
Jun 14 06:27:36 acid kernel:  [<c039adc6>] tcp_close+0x51d/0x53c
Jun 14 06:27:36 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:27:36 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:36 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:36 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:36 acid kernel:  =======================
Jun 14 06:27:36 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:36 acid kernel: page:c10bca60 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:36 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:36 acid kernel: Backtrace:
Jun 14 06:27:36 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:36 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:36 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:37 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:37 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:37 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:37 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:37 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:37 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:37 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:37 acid kernel:  [<c039adc6>] tcp_close+0x51d/0x53c
Jun 14 06:27:37 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:27:37 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:37 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:37 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:37 acid kernel:  =======================
Jun 14 06:27:37 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:37 acid kernel: page:c10bca40 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:40 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:41 acid kernel: Backtrace:
Jun 14 06:27:41 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:41 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:41 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:41 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:41 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:41 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:41 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:41 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:41 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:41 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:41 acid kernel:  [<c039adc6>] tcp_close+0x51d/0x53c
Jun 14 06:27:41 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:27:41 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:41 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:41 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:41 acid kernel:  =======================
Jun 14 06:27:41 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:41 acid kernel: page:c108c000 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:42 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:42 acid kernel: Backtrace:
Jun 14 06:27:42 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:42 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:42 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:42 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:42 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:42 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:42 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:42 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:42 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:42 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:42 acid kernel:  [<c039adc6>] tcp_close+0x51d/0x53c
Jun 14 06:27:42 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:27:42 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:42 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:42 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:42 acid kernel:  =======================
Jun 14 06:27:42 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:42 acid kernel: page:c108c020 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:42 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:42 acid kernel: Backtrace:
Jun 14 06:27:42 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:42 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:42 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:42 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:42 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:42 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:42 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:42 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:42 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:42 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:42 acid kernel:  [<c039adc6>] tcp_close+0x51d/0x53c
Jun 14 06:27:42 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:27:42 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:42 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:42 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:42 acid kernel:  =======================
Jun 14 06:27:42 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:42 acid kernel: page:c10a0a20 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:42 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:42 acid kernel: Backtrace:
Jun 14 06:27:42 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:42 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:42 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:42 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:42 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:42 acid kernel:  [<c013ddf5>] shrink_active_list+0xd248>]
__pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:42 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:42 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:42 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:42 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:42 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:42 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:42 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:42 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:27:42 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:42 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:42 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:42 acid kernel:  =======================
Jun 14 06:27:42 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:42 acid kernel: page:c10bb9c0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:42 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:42 acid kernel: Backtrace:
Jun 14 06:27:45 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:45 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:45 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:45 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:45 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:45 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:45 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:45 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:45 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:45 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:45 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:45 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:27:45 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:45 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:45 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:45 acid kernel:  =======================
Jun 14 06:27:45 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:45 acid kernel: page:c1211e60 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:45 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:48 acid kernel: Backtrace:
Jun 14 06:27:48 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:48 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:48 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:48 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:48 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:48 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:48 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:48 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:48 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:48 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:48 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:48 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:27:48 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:48 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:48 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:48 acid kernel:  =======================
Jun 14 06:27:48 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:48 acid kernel: page:c118da00 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:48 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:48 acid kernel: Backtrace:
Jun 14 06:27:48 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:48 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:48 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:48 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:48 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:48 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:48 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:48 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:48 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:48 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:48 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:48 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:27:48 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:48 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:48 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:48 acid kernel:  =======================
Jun 14 06:27:48 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:48 acid kernel: page:c107d000 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:48 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:48 acid kernel: Backtrace:
Jun 14 06:27:52 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:52 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:52 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:52 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:52 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:52 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:52 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:52 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:52 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:52 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:52 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:52 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:27:52 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:52 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:52 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:52 acid kernel:  =======================
Jun 14 06:27:52 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:52 acid kernel: page:c10f03e0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:52 acid kernel: Try<4> [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:52 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:52 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:52 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:52 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:52 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:52 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:52 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:52 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:52 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:52 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:52 acid kernel:  =======================
Jun 14 06:27:52 acid kernel: Bad page state in process 'find'
Jun 14 06:27:53 acid kernel: page:c10fc920 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:53 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:54 acid kernel: Backtrace:
Jun 14 06:27:54 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:54 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:54 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:54 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:55 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:55 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:55 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:55 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:55 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:55 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:55 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:55 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:55 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:55 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:55 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:55 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:55 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:55 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:55 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:55 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:55 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:55 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:55 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:55 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:55 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:55 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:55 acid kernel:  =======================
Jun 14 06:27:55 acid kernel: Bad page state in process 'find'
Jun 14 06:27:55 acid kernel: page:c1193340 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:55 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:55 acid kernel: Backtrace:
Jun 14 06:27:55 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:55 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:55 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:55 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:55 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:55 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:55 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:55 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:55 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:55 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:55 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:55 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:55 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:55 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:55 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:55 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:55 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:55 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:55 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:55 acid kernel:  [<c0158ef3>] link_path_walk+0x44/0xb3
Jun 14 06:27:55 acid kernel:  [<c01591e7>] do_path_lookup+0x16e/0x189
Jun 14 06:27:55 acid kernel:  [<c015820d>] getname+0x59/0x8f
Jun 14 06:27:55 acid kernel:  [<c01599a1>] __user_walk_fd+0x2f/0x45
Jun 14 06:27:55 acid kernel:  [<c01540b0>] vfs_lstat_fd+0x16/0x3d
Jun 14 06:27:55 acid kernel:  [<c015411c>] sys_lstat64+0xf/0x23
Jun 14 06:27:55 acid kernel:  [<c01030d0>] syscall_call+0x7/0xb
Jun 14 06:27:55 acid kernel:  =======================
Jun 14 06:27:55 acid kernel: Bad page state in process 'find'
Jun 14 06:27:55 acid kernel: page:c103ef20 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:55 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:55 acid kernel: Backtrace:
Jun 14 06:27:55 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:55 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:55 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:55 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:55 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:55 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:55 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:55 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:55 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:55 acid kernel:  [<c014eda0>] cache_alloc_refill+0x289/0x487
Jun 14 06:27:55 acid kernel:  [<c014eb0d>] kmem_cache_alloc+0x3d/0x47
Jun 14 06:27:55 acid kernel:  [<c01c0edf>] ext2_alloc_inode+0xf/0x39
Jun 14 06:27:55 acid kernel:  [<c0160ace>] alloc_inode+0x11/0x10c
Jun 14 06:27:55 acid kernel:  [<c0160c06>] iget_locked+0x3d/0x111
Jun 14 06:27:55 acid kernel:  [<c01c0e33>] ext2_lookup+0x31/0x66
Jun 14 06:27:55 acid kernel:  [<c01573e0>] do_lookup+0xa3/0x140
Jun 14 06:27:55 acid kernel:  [<c0158a9b>] __link_path_walk+0x709/0xb1d
Jun 14 06:27:55 acid kernel:  [<c0162a03>] mntput_no_expire+0x11/0x56
Jun 14 06:27:55 acid kernel:  [<c0158f58>] link_path_walk+0xa9/0xb3
Jun 14 06:27:55 acid kernel:  [<c0158ef3>] li7cd
Jun 14 06:27:55 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:55 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:27:55 acid kernel:  [<c03f6927>] __sched_text_start+0x147/0x787
Jun 14 06:27:55 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:27:55 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:55 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:55 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:55 acid kernel:  =======================
Jun 14 06:27:55 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:55 acid kernel: page:c107d900 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:27:55 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:27:55 acid kernel: Backtrace:
Jun 14 06:27:55 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:27:55 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:27:55 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:27:55 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:27:55 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:27:55 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:27:55 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:27:55 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:27:55 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:27:55 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:27:55 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:27:55 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:27:55 acid kernel:  [<c03f6927>] __sched_text_start+0x147/0x787
Jun 14 06:27:55 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:27:55 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:27:55 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:27:55 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:27:55 acid kernel:  =======================
Jun 14 06:27:55 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:27:56 acid kernel: page:c10e6aa0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:01 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:28:01 acid kernel: Backtrace:
Jun 14 06:28:01 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:28:01 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:28:01 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:28:01 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:01 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:28:01 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:01 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:01 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:01 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:01 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:28:01 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:28:01 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:28:01 acid kernel:  [<c03f6927>] __sched_text_start+0x147/0x787
Jun 14 06:28:01 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:28:01 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:01 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:01 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:28:01 acid kernel:  =======================
Jun 14 06:28:01 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:28:01 acid kernel: page:c10d5ea0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:02 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:28:02 acid kernel: Backtrace:
Jun 14 06:28:02 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:28:02 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:28:02 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:28:02 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:02 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:28:02 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:02 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:02 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:02 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:02 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:28:02 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:28:02 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:28:02 acid kernel:  [<c03f6927>] __sched_text_start+0x147/0x787
Jun 14 06:28:02 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:28:02 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:02 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:02 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:28:02 acid kernel:  =======================
Jun 14 06:28:02 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:28:02 acid kernel: page:c1224be0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:03 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:28:03 acid kernel: Backtrace:
Jun 14 06:28:03 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:28:03 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:28:03 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:28:03 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:03 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:28:03 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:03 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:03 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:03 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:03 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:28:03 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:28:03 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:28:03 acid kernel:  [<c03f6927>] __sched_text_start+0x147/0x787
Jun 14 06:28:03 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:28:04 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:04 acid kernel:  [<c03f9999>] do_page_fault+08>]
__pagevec_free+0x14/0x1a
Jun 14 06:28:04 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:04 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:28:04 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:04 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:04 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:04 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:04 acid kernel:  [<c0140cff>] do_wp_page+0x1bb/0x36c
Jun 14 06:28:04 acid kernel:  [<c010200f>] copy_thread+0x2f/0x1bf
Jun 14 06:28:04 acid kernel:  [<c0142128>] __handle_mm_fault+0x77c/0x7cd
Jun 14 06:28:04 acid kernel:  [<c03f6eb8>] __sched_text_start+0x6d8/0x787
Jun 14 06:28:04 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:04 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:04 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:28:04 acid kernel:  =======================
Jun 14 06:28:04 acid kernel: Bad page state in process 'syslogd'
Jun 14 06:28:04 acid kernel: page:c11612c0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:04 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:28:04 acid kernel: Backtrace:
Jun 14 06:28:04 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:28:04 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:28:04 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:28:04 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:04 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:28:04 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:04 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:04 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:04 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:04 acid kernel:  [<c0140cff>] do_wp_page+0x1bb/0x36c
Jun 14 06:28:04 acid kernel:  [<c010200f>] copy_thread+0x2f/0x1bf
Jun 14 06:28:04 acid kernel:  [<c0142128>] __handle_mm_fault+0x77c/0x7cd
Jun 14 06:28:04 acid kernel:  [<c03f6eb8>] __sched_text_start+0x6d8/0x787
Jun 14 06:28:04 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:04 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:04 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:28:04 acid kernel:  =======================
Jun 14 06:28:04 acid kernel: Bad page state in process 'syslogd'
Jun 14 06:28:04 acid kernel: page:c1078d60 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:04 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:28:04 acid kernel: Backtrace:
Jun 14 06:28:04 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:28:04 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:28:04 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:28:04 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:04 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:28:04 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:04 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:04 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:04 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:04 acid kernel:  [<c0140cff>] do_wp_page+0x1bb/0x36c
Jun 14 06:28:04 acid kernel:  [<c010200f>] copy_thread+0x2f/0x1bf
Jun 14 06:28:04 acid kernel:  [<c0142128>] __handle_mm_fault+0x77c/0x7cd
Jun 14 06:28:04 acid kernel:  [<c03f6eb8>] __sched_text_start+0x6d8/0x787
Jun 14 06:28:04 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:04 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:04 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:28:04 acid kernel:  =======================
Jun 14 06:28:04 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:28:04 acid kernel: page:c112b1a0 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:04 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:28:04 acid kernel: Backtrace:
Jun 14 06:28:04 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:28:04 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:28:04 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:28:04 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:04 acid kernel:  [<c013defb>] remove_mapping+0x8e/0xb1
Jun 14 06:28:04 acid kernel:  [<c013e479>] shrink_inactive_list+0x55b/0x742
Jun 14 06:28:04 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:04 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:04 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:04 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:04 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:28:04 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:28:04 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:04 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:04 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:28:04 acid kernel:  =======================
Jun 14 06:28:04 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:28:04 acid kernel: page:c10f8b20 flags:0x40000048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:05 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:28:07 acid kernel: Backtrace:
Jun 14 06:28:07 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:28:07 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:28:07 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:28:07 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:07 acid kernel:  [<c013defb>] remove_mapping+0x8e/0xb1
Jun 14 06:28:07 acid kernel:  [<c013e479>] shrink_inactive_list+0x55b/0x742
Jun 14 06:28:07 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:07 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:07 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:07 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:07 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:28:07 acid kernel:  [<c0144c0d>] do_brk+0x14d/0x1e1
Jun 14 06:28:07 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:07 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:07 acid kernel:  [<c03f8634>]nd_mergeable_anon_vma+0x5e/0xb0
Jun 14 06:28:07 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:28:07 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:28:07 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:28:07 acid kernel:  [<c013f212>] vma_prio_tree_insert+0x17/0x2a
Jun 14 06:28:07 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:28:07 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:07 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:07 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:28:07 acid kernel:  =======================
Jun 14 06:28:07 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:28:07 acid kernel: page:c1151560 flags:0x40010048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:07 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:28:07 acid kernel: Backtrace:
Jun 14 06:28:08 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:28:08 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:28:08 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:28:08 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:08 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:28:08 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:08 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:08 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:08 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:08 acid kernel:  [<c0144ee8>] find_mergeable_anon_vma+0x5e/0xb0
Jun 14 06:28:08 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:28:08 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:28:08 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:28:08 acid kernel:  [<c013f212>] vma_prio_tree_insert+0x17/0x2a
Jun 14 06:28:08 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:28:08 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:08 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:08 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:28:08 acid kernel:  =======================
Jun 14 06:28:08 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:28:11 acid kernel: page:c10dbc20 flags:0x40010048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:11 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:28:11 acid kernel: Backtrace:
Jun 14 06:28:12 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:28:12 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:28:12 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:28:12 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:12 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:28:12 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:12 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:12 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:12 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:12 acid kernel:  [<c0144ee8>] find_mergeable_anon_vma+0x5e/0xb0
Jun 14 06:28:12 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:28:12 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:28:12 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:28:12 acid kernel:  [<c013f212>] vma_prio_tree_insert+0x17/0x2a
Jun 14 06:28:12 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:28:12 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:12 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:12 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:28:12 acid kernel:  =======================
Jun 14 06:28:12 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:28:12 acid kernel: page:c1176f00 flags:0x40010048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:12 acid kernel: Trying to fix it up, but a reboot is needed
Jun 14 06:28:15 acid kernel: Backtrace:
Jun 14 06:28:15 acid kernel:  [<c013a70d>] bad_page+0x5e/0x89
Jun 14 06:28:15 acid kernel:  [<c013ac77>] free_hot_cold_page+0x55/0x112
Jun 14 06:28:15 acid kernel:  [<c013ad48>] __pagevec_free+0x14/0x1a
Jun 14 06:28:15 acid kernel:  [<c013d248>] __pagevec_release_nonlru+0x44/0x4f
Jun 14 06:28:15 acid kernel:  [<c013e3f4>] shrink_inactive_list+0x4d6/0x742
Jun 14 06:28:15 acid kernel:  [<c013ddf5>] shrink_active_list+0x3ac/0x3b4
Jun 14 06:28:15 acid kernel:  [<c013e72d>] shrink_zone+0xcd/0xf2
Jun 14 06:28:15 acid kernel:  [<c013f099>] try_to_free_pages+0x11c/0x1f3
Jun 14 06:28:15 acid kernel:  [<c013b1f7>] __alloc_pages+0x18b/0x28d
Jun 14 06:28:15 acid kernel:  [<c0144ee8>] find_mergeable_anon_vma+0x5e/0xb0
Jun 14 06:28:15 acid kernel:  [<c0141d5f>] __handle_mm_fault+0x3b3/0x7cd
Jun 14 06:28:15 acid kernel:  [<c012cd63>] clocksource_get_next+0x39/0x3f
Jun 14 06:28:15 acid kernel:  [<c012152b>] do_timer+0x500/0x6e2
Jun 14 06:28:15 acid kernel:  [<c013f212>] vma_prio_tree_insert+0x17/0x2a
Jun 14 06:28:15 acid kernel:  [<c0120dcd>] run_timer_softirq+0x36/0x15b
Jun 14 06:28:15 acid kernel:  [<c03f9bac>] do_page_fault+0x213/0x525
Jun 14 06:28:15 acid kernel:  [<c03f9999>] do_page_fault+0x0/0x525
Jun 14 06:28:15 acid kernel:  [<c03f8634>] error_code+0x7c/0x84
Jun 14 06:28:15 acid kernel:  =======================
Jun 14 06:28:15 acid kernel: Bad page state in process 'get_listings.pl'
Jun 14 06:28:18 acid kernel: page:c104eae0 flags:0x40010048
mapping:00000000 mapcount:0 count:0
Jun 14 06:28:18 acid

/proc/cpuinfo gives:
 processor       : 0
 vendor_id       : GenuineIntel
 cpu family      : 6
 model           : 8
 model name      : Pentium III (Coppermine)
 stepping        : 8
 cpu MHz         : 803.783
 cache size      : 256 KB
 fdiv_bug        : no
 hlt_bug         : no
 f00f_bug        : no
 coma_bug        : no
 fpu             : yes
 fpu_exception   : yes
 cpuid level     : 2
 wp              : yes
 flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
pge mca cmov pat pse36 mmx fxsr sse up
 bogomips        : 1627.28
 clflush size    : 32

 /proc/ioports:
 0000-001f : dma1
 0020-0021 : pic1
 0040-0043 : timer0
 0050-0053 : timer1
 0060-006f : keyboard
 0070-0077 : rtc
 0080-008f : dma page reg
 00a0-00a1 : pic2
 00c0-00df : dma2
 00f0-00ff : fpu
 0170-0177 : 0000:00:07.1
   0170-0177 : ide1
 01f0-01f7 : 0000:00:07.1
   01f0-01f7 : ide0
 02f8-02ff : serial
 0376-0376 : 0000:00:07.1
   0376-0376 : ide1
 03c0-03df : vga+
 03f2-03f5 : floppy
 03f6-03f6 : 0000:00:07.1
   03f6-03f6 : ide0
 03f7-03f7 : floppy DIR
 03f8-03ff : serial
 0cf8-0cff : PCI conf1
 1000-103f : 0000:00:07.3
   1000-1003 : ACPI PM1a_EVT_BLK
   1004-1005 : ACPI PM1a_CNT_BLK
   1008-100b : ACPI PM_TMR
   100c-100f : ACPI GPE0_BLK
   1010-1015 : ACPI CPU throttle
 1040-104f : 0000:00:07.3
 1050-105f : 0000:00:07.1
   1050-1057 : ide0
   1058-105f : ide1
 1060-107f : 0000:00:07.2
   1060-107f : uhci_hcd
 1080-10ff : 0000:00:11.0
   1080-109f : pcnet32_probe_pci
 1400-143f : 0000:00:12.0
 1440-145f : 0000:00:10.0
 1460-146f : 0000:00:0f.0

 /proc/iomem:
 00000000-0009f7ff : System RAM
 0009f800-0009ffff : reserved
 000a0000-000bffff : Video RAM area
 000c0000-000c7fff : Video ROM
 000c8000-000c8fff : Adapter ROM
 000f0000-000fffff : System ROM
 00100000-11aeffff : System RAM
   00100000-003fb5bd : Kernel code
   003fb5be-00572f0f : Kernel data
 11af0000-11afbfff : ACPI Tables
 11afc000-11afffff : ACPI Non-volatile Storage
 11b00000-11bfffff : System RAM
 20000000-2000ffff : 0000:00:11.0
 20010000-20017fff : 0000:00:0f.0
 20018000-2001bfff : 0000:00:10.0
 e8000000-e87fffff : 0000:00:0f.0
 e8800000-e880001f : 0000:00:10.0
 ec000000-efffffff : 0000:00:00.0
 f0000000-f7ffffff : 0000:00:0f.0
 fec00000-fec0ffff : reserved
 fee00000-fee00fff : reserved
 fffe0000-ffffffff : reserved

lspci -vvv gives:
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX
Host bridge (rev 01)
        Subsystem: VMware Inc virtualHW v3
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at ec000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [a0] AGP version 1.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW- AGP3- Rate=x1,x2
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-
FW- Rate=<none>

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP
bridge (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B+

00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 08)
        Subsystem: VMware Inc virtualHW v3
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev
01) (prog-if 8a [Master SecP PriP])
        Subsystem: VMware Inc virtualHW v3
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at 1050 [size=16]

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB
(prog-if 00 [UHCI])
        Subsystem: VMware Inc virtualHW v3
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin D routed to IRQ 17
        Region 4: I/O ports at 1060 [size=32]

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 08)
        Subsystem: VMware Inc virtualHW v3
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin ? routed to IRQ 9

00:0f.0 VGA compatible controller: VMware Inc [VMware SVGA II] PCI
Display Adapter (prog-if 00 [VGA])
        Subsystem: VMware Inc [VMware SVGA II] PCI Display Adapter
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Region 0: I/O ports at 1460 [size=16]
        Region 1: Memory at f0000000 (32-bit, non-prefetchable) [size=128M]
        Region 2: Memory at e8000000 (32-bit, non-prefetchable) [size=8M]
        [virtual] Expansion ROM at 20010000 [disabled] [size=32K]

00:10.0 SCSI storage controller: BusLogic BT-946C (BA80C30)
[MultiMaster 10] (rev 01)
        Subsystem: BusLogic BT-946C (BA80C30) [MultiMaster 10]
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at 1440 [size=32]
        Region 1: Memory at e8800000 (32-bit, non-prefetchable) [size=32]
        [virtual] Expansion ROM at 20018000 [disabled] [size=16K]

00:11.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970
[PCnet32 LANCE] (rev 10)
        Subsystem: Advanced Micro Devices [AMD] PCnet - Fast 79C971
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (1500ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 1080 [size=128]
        [virtual] Expansion ROM at 20000000 [disabled] [size=64K]

00:12.0 Multimedia audio controller: Ensoniq ES1371 [AudioPCI-97] (rev 02)
        Subsystem: Ensoniq Creative Sound Blaster AudioPCI64V, AudioPCI128
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=?? >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 9
        Region 0: I/O ports at 1400 [size=64]

-- 
Tom Robinson
tom.robinson@dunelm.org.uk
