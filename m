Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYDGJBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYDGJBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 05:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYDGJBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 05:01:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbYDGJBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 05:01:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Plamen Petrov <plamen.petrov@fs.ru.acad.bg>
Subject: Re: linux 2.6.25-rc8-00166-g6fdf5e6 BUG
Date: Mon, 7 Apr 2008 11:01:32 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <47F9D21F.4080804@fs.ru.acad.bg>
In-Reply-To: <47F9D21F.4080804@fs.ru.acad.bg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071101.33284.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of April 2008, Plamen Petrov wrote:
> Hi!

Hi,

> This morning, while closing KMail from the KDE desktop to
> shutdown the machine, I got this:
> 
> [===snip===]
> 
> [145026.240307] general protection fault: 0000 [1] PREEMPT SMP
> [145026.240313] CPU 0
> [145026.240315] Modules linked in:
> [145026.240318] Pid: 32546, comm: kmail Not tainted 
> 2.6.25-rc8-00166-g6fdf5e6 #1
> [145026.240320] RIP: 0010:[<ffffffff80275274>]  [<ffffffff80275274>] 
> set_page_dirty+0x34/0x90
> [145026.240327] RSP: 0018:ffff810004ba9d98  EFLAGS: 00010206
> [145026.240328] RAX: 6b636f6c5f747369 RBX: ffff81000779cae0 RCX: 
> ffff8100010046e0
> [145026.240330] RDX: ffffffff802c08d0 RSI: 8000000033d60067 RDI: 
> ffffe20000b56d00
> [145026.240332] RBP: 000000000115c000 R08: 0000000000000006 R09: 
> 0000000000000001
> [145026.240334] R10: 0000000000000002 R11: 000000000000031b R12: 
> ffffe20000b56d00
> [145026.240335] R13: 0000000001200000 R14: 0000000033d60067 R15: 
> 0000000000000000
> [145026.240338] FS:  0000000000000000(0000) GS:ffffffff80993000(0000) 
> knlGS:0000000000000000
> [145026.240340] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [145026.240341] CR2: 00007f695e7aa3f0 CR3: 0000000000201000 CR4: 
> 00000000000006e0
> [145026.240343] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [145026.240345] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
> 0000000000000400
> [145026.240347] Process kmail (pid: 32546, threadinfo ffff810004ba8000, 
> task ffff81002137a000)
> [145026.240348] Stack:  0000000001155000 ffff81000779cae0 
> 000000000115c000 ffffffff8027e271
> [145026.240353]  0000000000000000 0000000001574fff 0000000000000000 
> ffff810004ba9ea8
> [145026.240357]  ffffffffffffffff 0000000000000000 ffff81003af86bd0 
> ffff810004ba9eb0
> [145026.240360] Call Trace:
> [145026.240364]  [<ffffffff8027e271>] ? unmap_vmas+0x611/0x800
> [145026.240367]  [<ffffffff8028252a>] ? exit_mmap+0x8a/0x130
> [145026.240370]  [<ffffffff80236957>] ? mmput+0x57/0xe0
> [145026.240373]  [<ffffffff8023cc8a>] ? do_exit+0x19a/0x7e0
> [145026.240377]  [<ffffffff807079fb>] ? lockdep_sys_exit_thunk+0x35/0x67
> [145026.240381]  [<ffffffff803f6281>] ? __up_read+0x21/0xb0
> [145026.240383]  [<ffffffff8023d303>] ? do_group_exit+0x33/0xa0
> [145026.240386]  [<ffffffff8020b56b>] ? system_call_after_swapgs+0x7b/0x80
> [145026.240387]
> [145026.240388]
> [145026.240389] Code: 48 8b 47 18 66 85 d2 78 70 a8 01 75 50 48 85 c0 74 
> 4b 48 8b 80 b8 00 00 00 48 c7 c2 d0 08 2c 80 48 8b 40 20 48 85 c0 48 0f 
> 44 c2 <ff> d0 85 c0 89 c5 74 21 65 48 8b 34 25 00 00 00 00 48 81 c6 d0
> [145026.240416] RIP  [<ffffffff80275274>] set_page_dirty+0x34/0x90
> [145026.240419]  RSP <ffff810004ba9d98>
> [145026.240423] ---[ end trace 6b50f2d712edcd7a ]---
> [145026.240424] Fixing recursive fault but reboot is needed!
> [145026.240426] BUG: scheduling while atomic: kmail/32546/0x00000003
> [145026.240428] INFO: lockdep is turned off.
> [145026.240430] Pid: 32546, comm: kmail Tainted: G      D 
> 2.6.25-rc8-00166-g6fdf5e6 #1
> [145026.240431]
> [145026.240432] Call Trace:
> [145026.240435]  [<ffffffff80705a26>] thread_return+0x34c/0x576
> [145026.240437]  [<ffffffff80239469>] release_console_sem+0x49/0x200
> [145026.240439]  [<ffffffff80239e5e>] printk+0x4e/0x60
> [145026.240441]  [<ffffffff8023d29e>] do_exit+0x7ae/0x7e0
> [145026.240444]  [<ffffffff8022e223>] __wake_up+0x43/0x70
> [145026.240446]  [<ffffffff8020c8e7>] oops_end+0x87/0x90
> [145026.240448]  [<ffffffff8070884d>] error_exit+0x0/0x9a
> [145026.240452]  [<ffffffff802c08d0>] __set_page_dirty_buffers+0x0/0xc0
> [145026.240454]  [<ffffffff80275274>] set_page_dirty+0x34/0x90
> [145026.240457]  [<ffffffff8027b6f8>] __dec_zone_state+0x18/0x80
> [145026.240459]  [<ffffffff8027e271>] unmap_vmas+0x611/0x800
> [145026.240461]  [<ffffffff8028252a>] exit_mmap+0x8a/0x130
> [145026.240463]  [<ffffffff80236957>] mmput+0x57/0xe0
> [145026.240466]  [<ffffffff8023cc8a>] do_exit+0x19a/0x7e0
> [145026.240468]  [<ffffffff807079fb>] lockdep_sys_exit_thunk+0x35/0x67
> [145026.240470]  [<ffffffff803f6281>] __up_read+0x21/0xb0
> [145026.240473]  [<ffffffff8023d303>] do_group_exit+0x33/0xa0
> [145026.240475]  [<ffffffff8020b56b>] system_call_after_swapgs+0x7b/0x80
> [145026.240476]
> 
> [===end-snip===]
> 
> Should I open a bugreport at bugzilla.kernel.org with this,
> or should I try latest git tree?

Trying the latest -git tree never hurts, but you can open a bug report anyway
(you can close it later if the bug is not reproducible any more) and please
mark it as a regression and make it block bug #9832.

Thanks,
Rafael
