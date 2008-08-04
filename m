Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYHDGQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYHDGQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYHDGQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:16:14 -0400
Received: from gw.goop.org ([64.81.55.164]:37607 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYHDGQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:16:13 -0400
Message-ID: <48969EA6.2080801@goop.org>
Date: Sun, 03 Aug 2008 23:16:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Markus Armbruster <armbru@redhat.com>
CC: Jaya Kumar <jayakumar.lkml@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark McLoughlin <markmc@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: 2.6.27-rc1 xen pvfb regression
References: <48969CA1.9010508@goop.org>
In-Reply-To: <48969CA1.9010508@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> When I boot 2.6.27-rc1

Hm, this only seems to happen with the current tip.git master applied.

    J

> with the Xen pvfb driver, I see this when X starts:
>
> ------------[ cut here ]------------
> WARNING: at /home/jeremy/hg/xen/paravirt/linux/fs/buffer.c:711 
> __set_page_dirty+0x7e/0x113()
> Modules linked in: xen_fbfront fb fb_sys_fops sysimgblt sysfillrect 
> xen_netfront xen_kbdfront syscopyarea xen_blkfront
> Pid: 1227, comm: Xorg Not tainted 2.6.27-rc1-tip-dirty #306
>
> Call Trace:
> [<ffffffff802345f6>] warn_on_slowpath+0x5d/0x84
> [<ffffffff80249c75>] ? enqueue_hrtimer+0xdf/0xed
> [<ffffffff803ce414>] ? _spin_unlock_irqrestore+0x1d/0x21
> [<ffffffff8024a42d>] ? hrtimer_start+0x118/0x13a
> [<ffffffff803ce3ee>] ? _spin_lock_irqsave+0x2a/0x33
> [<ffffffff8023d752>] ? lock_timer_base+0x2b/0x4f
> [<ffffffff803ce414>] ? _spin_unlock_irqrestore+0x1d/0x21
> [<ffffffff802af569>] __set_page_dirty+0x7e/0x113
> [<ffffffff802b1806>] __set_page_dirty_buffers+0x84/0x89
> [<ffffffff8026c732>] set_page_dirty+0x46/0xb2
> [<ffffffff8026d85d>] set_page_dirty_balance+0x17/0x4d
> [<ffffffff802746df>] __do_fault+0x494/0x4ae
> [<ffffffff8027644c>] handle_mm_fault+0x4a1/0x967
> [<ffffffff803ce414>] ? _spin_unlock_irqrestore+0x1d/0x21
> [<ffffffff80224ca6>] do_page_fault+0x5d0/0x9fa
> [<ffffffff80238516>] ? sys_setitimer+0x93/0xa3
> [<ffffffff803ce6da>] error_exit+0x0/0x70
>
> ---[ end trace 68d3ab49fcc5748b ]---
> ------------[ cut here ]------------
> kernel BUG at /home/jeremy/hg/xen/paravirt/linux/lib/radix-tree.c:473!
> invalid opcode: 0000 [1] SMP CPU 0 Modules linked in: xen_fbfront fb 
> fb_sys_fops sysimgblt sysfillrect xen_netfront xen_kbdfront 
> syscopyarea xen_blkfront
> Pid: 1227, comm: Xorg Tainted: G        W 2.6.27-rc1-tip-dirty #306
> RIP: e030:[<ffffffff80301aec>]  [<ffffffff80301aec>] 
> radix_tree_tag_set+0x17/0x9b
> RSP: e02b:ffff88000cef3cc0  EFLAGS: 00010002
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88000e555858
> RBP: ffff88000cef3cc8 R08: a000000000000000 R09: 0000000000000000
> R10: 00007fb12cb29c80 R11: ffff880001432050 R12: ffff88000e555850
> R13: 0000000000000001 R14: ffff8800013d82f8 R15: ffff88000e859040
> FS:  00007fb12e61a780(0000) GS:ffffffff80496000(0000) 
> knlGS:0000000000000000
> CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fb12cb2a000 CR3: 000000000e68e000 CR4: 0000000000002620
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process Xorg (pid: 1227, threadinfo ffff88000cef2000, task 
> ffff88000ceb3bd0)
> Stack:  ffff880001432050 ffff88000cef3cf8 ffffffff802af5ce 
> ffff88000cef3ce8
> ffff880001432050 ffff88000e555850 ffff880001432050 ffff88000cef3d18
> ffffffff802b1806 ffff880001432050 0000000000000001 ffff88000cef3d48
> Call Trace:
> [<ffffffff802af5ce>] __set_page_dirty+0xe3/0x113
> [<ffffffff802b1806>] __set_page_dirty_buffers+0x84/0x89
> [<ffffffff8026c732>] set_page_dirty+0x46/0xb2
> [<ffffffff8026d85d>] set_page_dirty_balance+0x17/0x4d
> [<ffffffff802746df>] __do_fault+0x494/0x4ae
> [<ffffffff8027644c>] handle_mm_fault+0x4a1/0x967
> [<ffffffff803ce414>] ? _spin_unlock_irqrestore+0x1d/0x21
> [<ffffffff80224ca6>] do_page_fault+0x5d0/0x9fa
> [<ffffffff80238516>] ? sys_setitimer+0x93/0xa3
> [<ffffffff803ce6da>] error_exit+0x0/0x70
>
>
> Code: ff eb 02 31 c0 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f c9 c3 55 
> 44 8b 0f 48 89 e5 44 89 c8 53 48 3b 34 c5 a0 7e 49 80 89 d3 76 04 <0f> 
> 0b eb fe 41 6b c1 06 4c 8b 57 08 44 8d 58 fa 49 83 e2 fe 89 RIP  
> [<ffffffff80301aec>] radix_tree_tag_set+0x17/0x9b
> RSP <ffff88000cef3cc0>
> ---[ end trace 68d3ab49fcc5748b ]---
>
>
> And the system is dead.  Haven't investigated at all.
>
>    J
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

