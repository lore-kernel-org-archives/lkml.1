Return-Path: <linux-kernel-owner+w=401wt.eu-S966144AbXDCBrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966144AbXDCBrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 21:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966145AbXDCBrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 21:47:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52837 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966144AbXDCBri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 21:47:38 -0400
Date: Mon, 2 Apr 2007 18:46:08 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: agl@us.ibm.com, dwg@au1.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: hugetlb: Unable to handle kernel NULL pointer dereference
Message-ID: <20070403014608.GA29601@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.6.21-rc5-gefab03d9-dirty (x86_64)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam, David,

Just got the following Oops and recursive fault running `make func`
(apparently the `shared` test in particular) with kernel HEAD at
efab03d998da03f67836ffc664b04e0400f85448 on my x86_64. Will pull latest
Linus and reboot, but haven't seen it posted yet. This occurs both with
my branch and master from libhugetlbfs.

[351419.028499] Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
[351419.047110]  [<ffffffff8016a72d>] _write_lock_irqsave+0x1d/0x90
[351419.047121] PGD 0 
[351419.047124] Oops: 0002 [1] PREEMPT SMP 
[351419.047127] CPU 0 
[351419.047129] Modules linked in: tun
[351419.047135] Pid: 29122, comm: shared Not tainted 2.6.21-rc5-gefab03d9-dirty #25
[351419.047138] RIP: 0010:[<ffffffff8016a72d>]  [<ffffffff8016a72d>] _write_lock_irqsave+0x1d/0x90
[351419.047144] RSP: 0018:ffff81000a5d3c58  EFLAGS: 00010017
[351419.047148] RAX: ffff81000a5d3fd8 RBX: 0000000000000018 RCX: ffff81003fe71028
[351419.047151] RDX: 0000000000000217 RSI: ffff81000a5d3cd0 RDI: 0000000000000001
[351419.047155] RBP: ffff81000a5d3c68 R08: 0000000000000005 R09: 00000000fffffffc
[351419.047158] R10: 0000000000000001 R11: 0000000000000246 R12: ffff81003fe71000
[351419.047162] R13: ffff810037052080 R14: 0000000055c00000 R15: ffff81000a5d3cb8
[351419.047166] FS:  00002aea683c6030(0000) GS:ffffffff80728000(0000) knlGS:00000000556f16c0
[351419.047169] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[351419.047172] CR2: 0000000000000018 CR3: 0000000000101000 CR4: 00000000000006e0
[351419.047177] Process shared (pid: 29122, threadinfo ffff81000a5d2000, task ffff81001130c740)
[351419.047179] Stack:  ffff81000a5d3c78 0000000000000018 ffff81000a5d3c78 ffffffff8016a7a9
[351419.047187]  ffff81000a5d3c98 ffffffff8014c404 ffff81003fe71000 ffff81000a5d3c90
[351419.047193]  ffff81000a5d3d08 ffffffff801c2864 ffff810037052100 ffff8100087238c8
[351419.047198] Call Trace:
[351419.047204]  [<ffffffff8016a7a9>] _write_lock_irq+0x9/0x10
[351419.047210]  [<ffffffff8014c404>] remove_from_page_cache+0x24/0x40
[351419.047216]  [<ffffffff801c2864>] __unmap_hugepage_range+0x174/0x1b0
[351419.047220]  [<ffffffff801c28e7>] unmap_hugepage_range+0x47/0x70
[351419.047225]  [<ffffffff801077fb>] unmap_vmas+0x11b/0x7f0
[351419.047230]  [<ffffffff8013d587>] exit_mmap+0x87/0x130
[351419.047234]  [<ffffffff8013fc27>] mmput+0x37/0xb0
[351419.047238]  [<ffffffff80145245>] exit_mm+0xe5/0xf0
[351419.047242]  [<ffffffff80116328>] do_exit+0x238/0x8c0
[351419.047246]  [<ffffffff8016ac54>] _spin_unlock+0x14/0x40
[351419.047250]  [<ffffffff8014df39>] do_group_exit+0x89/0x90
[351419.047255]  [<ffffffff80151ec2>] sys_exit_group+0x12/0x20
[351419.047262]  [<ffffffff801669e4>] cstar_do_call+0x1b/0x65
[351419.047264] 
[351419.047265] 
[351419.047266] Code: f0 81 2b 00 00 00 01 0f 94 c0 84 c0 75 4e f0 81 03 00 00 00 
[351419.047275] RIP  [<ffffffff8016a72d>] _write_lock_irqsave+0x1d/0x90
[351419.047280]  RSP <ffff81000a5d3c58>
[351419.047282] CR2: 0000000000000018
[351419.047287] Fixing recursive fault but reboot is needed!
[351419.047290] BUG: scheduling while atomic: shared/0x00000003/29122
[351419.047292] 
[351419.047293] Call Trace:
[351419.047298]  [<ffffffff80167a0d>] __sched_text_start+0x5d/0x807
[351419.047304]  [<ffffffff8018d66d>] default_wake_function+0xd/0x10
[351419.047310]  [<ffffffff801a1461>] autoremove_wake_function+0x11/0x40
[351419.047315]  [<ffffffff8018b214>] __wake_up_common+0x44/0x80
[351419.047319]  [<ffffffff80116221>] do_exit+0x131/0x8c0
[351419.047323]  [<ffffffff8016d656>] do_page_fault+0x7f6/0x8f0
[351419.047328]  [<ffffffff8012fbc8>] wake_up_bit+0x28/0x40
[351419.047332]  [<ffffffff80144883>] invalidate_inode_buffers+0x13/0xd0
[351419.047336]  [<ffffffff8016aac6>] _spin_lock+0x16/0x80
[351419.047339]  [<ffffffff8016aac6>] _spin_lock+0x16/0x80
[351419.047343]  [<ffffffff8010d1b2>] dput+0x22/0x160
[351419.047347]  [<ffffffff8016b23d>] error_exit+0x0/0x84
[351419.047351]  [<ffffffff8016a72d>] _write_lock_irqsave+0x1d/0x90
[351419.047355]  [<ffffffff8016a7a9>] _write_lock_irq+0x9/0x10
[351419.047359]  [<ffffffff8014c404>] remove_from_page_cache+0x24/0x40
[351419.047363]  [<ffffffff801c2864>] __unmap_hugepage_range+0x174/0x1b0
[351419.047368]  [<ffffffff801c28e7>] unmap_hugepage_range+0x47/0x70
[351419.047371]  [<ffffffff801077fb>] unmap_vmas+0x11b/0x7f0
[351419.047376]  [<ffffffff8013d587>] exit_mmap+0x87/0x130
[351419.047379]  [<ffffffff8013fc27>] mmput+0x37/0xb0
[351419.047383]  [<ffffffff80145245>] exit_mm+0xe5/0xf0
[351419.047387]  [<ffffffff80116328>] do_exit+0x238/0x8c0
[351419.047390]  [<ffffffff8016ac54>] _spin_unlock+0x14/0x40
[351419.047394]  [<ffffffff8014df39>] do_group_exit+0x89/0x90
[351419.047398]  [<ffffffff80151ec2>] sys_exit_group+0x12/0x20
[351419.047402]  [<ffffffff801669e4>] cstar_do_call+0x1b/0x65
[351419.047404] 

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
