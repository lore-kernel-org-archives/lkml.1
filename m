Return-Path: <linux-kernel-owner+w=401wt.eu-S1763602AbYB0AEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763602AbYB0AEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYB0AEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:04:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:56066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYB0AEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:04:31 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24.2(-rt2?) sched_fair issue
Date: Wed, 27 Feb 2008 01:04:04 +0100
User-Agent: KMail/1.9.9
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
       linux-rt-users@vger.kernel.org
References: <47C4972A.9040704@ct.jp.nec.com>
In-Reply-To: <47C4972A.9040704@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802270104.05461.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1+qCzeFzDmDHmYBfyNiQ0Cydm5aIP7gwFrxooL
 zn8yytQUHJeL5W7m1W1Nf3luDXoLtnZDnasGhdcWzWVSU5Rh85
 jfA4LKVJfu/ChLQ+d1p/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. Februar 2008 schrieb Hiroshi Shimamoto:
> Hi Ingo,
>
> I got the following message and the kernel crashed when testing
> 2.6.24.2-rt2.
>
> Unable to handle kernel NULL pointer dereference at 0000000000000128 RIP:
>  [<ffffffff80229805>] pick_next_task_fair+0x2d/0x42
> PGD 211db1067 PUD 211c1d067 PMD 0
> Oops: 0000 [1] PREEMPT SMP
> CPU 2
> Modules linked in:
> Pid: 898, comm: stress Not tainted 2.6.24.2-rt2 #1
> RIP: 0010:[<ffffffff80229805>]  [<ffffffff80229805>]
> pick_next_task_fair+0x2d/0x42 RSP: 0018:ffff8101ac423948  EFLAGS:
> 00010046
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff81022e562300
> RDX: ffff8101ac4239b0 RSI: ffff81022e562300 RDI: ffff8100050196e0
> RBP: ffff8101ac423958 R08: ffff810005015680 R09: ffff810005015800
> R10: 0000000000000000 R11: 0000000000000001 R12: ffff810005011680
> R13: 0000000000000001 R14: ffff810005019680 R15: 00000001002f7a43
> FS:  00002ada5c132b00(0000) GS:ffff81022fc057c0(0000)
> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000128 CR3: 0000000211dfc000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process stress (pid: 898, threadinfo ffff8101ac422000, task
> ffff81022e562300) Stack:  ffffffff802292e4 ffff810005015ac0
> ffff8101ac4239e8 ffffffff804d9685 ffff8101ac4239b0 ffffffff8022f2bd
> 00000002ac423998 ffff81022e562300 ffff8101ac4239a8 ffff81022e562640
> 00000000000000ff ffffffff804db527 Call Trace:
>  [<ffffffff802292e4>] put_prev_task_rt+0xd/0x18
>  [<ffffffff804d9685>] __schedule+0x414/0x771
>  [<ffffffff8022f2bd>] add_preempt_count+0x18/0xb2
>  [<ffffffff804db527>] __spin_unlock+0x14/0x2e
>  [<ffffffff804d9cdc>] schedule+0xdf/0xff
>  [<ffffffff804da557>] rt_spin_lock_slowlock+0xf9/0x19e
>  [<ffffffff804daed8>] __rt_spin_lock+0x6b/0x70
>  [<ffffffff804daee6>] rt_spin_lock+0x9/0xb
>  [<ffffffff8027b57f>] page_lock_anon_vma+0x2b/0x3b
>  [<ffffffff8027c38c>] page_referenced+0x49/0xf5
>  [<ffffffff8026f40b>] shrink_active_list+0x222/0x563
>  [<ffffffff8022f2bd>] add_preempt_count+0x18/0xb2
>  [<ffffffff802705d5>] shrink_zone+0xcc/0x10f
>  [<ffffffff80271139>] try_to_free_pages+0x183/0x27a
>  [<ffffffff8026b0da>] __alloc_pages+0x1fb/0x344
>  [<ffffffff8027c5ca>] anon_vma_prepare+0x29/0xf9
>  [<ffffffff80274fc8>] handle_mm_fault+0x251/0x700
>  [<ffffffff8020c7e6>] retint_kernel+0x26/0x30
>  [<ffffffff8021f522>] do_page_fault+0x315/0x6bf
>  [<ffffffff804db527>] __spin_unlock+0x14/0x2e
>  [<ffffffff8022f1af>] finish_task_switch+0x2b/0x90
>  [<ffffffff804db7c9>] error_exit+0x0/0x51
> Code: 48 8b bb 28 01 00 00 48 85 ff 75 dd 48 8d 43 b8 41 58 5b 5d
>
> I've gotten a kernel dump at this time.
> The backtrace says;
> (gdb) bt
> #0  pick_next_task_fair (rq=<value optimized out>) at
> kernel/sched_fair.c:680 #1  0xffffffff804d9685 in __schedule () at
> kernel/sched.c:3783
> #2  0xffffffff804d9cdc in schedule () at kernel/sched.c:3914
> #3  0xffffffff804da557 in rt_spin_lock_slowlock (lock=0xffff81022e8ca618)
> at kernel/rtmutex.c:735 #4  0xffffffff804daed8 in __rt_spin_lock
> (lock=0xffff81022e8ca618) at kernel/rtmutex.c:646 #5  0xffffffff804daee6
> in rt_spin_lock (lock=0xffff8100050196e0) at kernel/rtmutex.c:799 #6 
> 0xffffffff8027b57f in page_lock_anon_vma (page=<value optimized out>) at
> mm/rmap.c:172 #7  0xffffffff8027c38c in page_referenced
> (page=0xffff8100050196e0, is_locked=777396992) at mm/rmap.c:309 (snip)
>
> and here is the kernel/sched_fair.c:680
> static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
> {
>         return grp->my_q;
> }
>
> It seems that grp is NULL, so I think pick_next_entity() returns NULL.
> I think pick_next_entity() could return NULL when first_fair(cfs_rq) is
> false.
>
> static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
> {
>         struct sched_entity *se = NULL;
>
>         if (first_fair(cfs_rq)) {
>                 se = __pick_next_entity(cfs_rq);
>                 set_next_entity(cfs_rq, se);
>         }
>
>         return se;
> }
>
> static struct task_struct *pick_next_task_fair(struct rq *rq)
> {
>         struct cfs_rq *cfs_rq = &rq->cfs;
>         struct sched_entity *se;
>
>         if (unlikely(!cfs_rq->nr_running))
>                 return NULL;
>
>         do {
>                 se = pick_next_entity(cfs_rq);
>                 cfs_rq = group_cfs_rq(se);
>         } while (cfs_rq);
>
>         return task_of(se);
> }
>
> I'm not sure the actual scenario to cause this panic.
> I also don't know how to reproduce it, I was running some benchmarks at
> the week end and found it the Monday morning.
> I've encountered it on 2.6.24.2-rt2, but 2.6.24.2 and 2.6.25-rc3 also
> have the same code pick_next_task_fair().
> However latest sched-devel git tree has a modified code.
>
> I'm not so familiar the CFS, is this investigation correct?

For what is worth, I seem to suffer from the very same problem here in a 
different setting: trying to run a SUSE kernel-head i586 build of 2.6.24.1,
which oopses reliable during initrd.

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000040
printing eip: c011f96c *pde = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file: /block/sde/sde1/dev
Modules linked in: sata_sil24 libata 3w_9xxx sd_mod scsi_mod

Pid: 538, comm: udev Not tainted (2.6.24.1-35.1-default #1)
EIP: 0060:[<c011f96c>] EFLAGS: 00010046 CPU: 0
EIP is at pick_next_task_fair+0x15/0x23
EAX: 00000000 EBX: f75d11f0 ECX: c202cdd0 EDX: 00000000
ESI: 00000000 EDI: 00000001 EBP: f7481f08 ESP: f7481f08
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process udev (pid: 538, ti=f7480000 task=f75d11f0 task.ti=f7480000)
Stack: f7481f2c c02eaeea c202a1cc 00000000 c202cd80 f75d1358 f7481f44 00000001 
       00000001 f7481f9c c02eb95e 00000001 00000000 00000000 c013af1e f7ffc944 
       00000000 00000000 73e8b1d5 00000005 c013aeba c202a1cc 00000001 c02eb953 
Call Trace:
 [<c02eaeea>] __sched_text_start+0x11a/0x379
 [<c02eb95e>] do_nanosleep+0x3c/0x67
 =======================
Code: 39 c8 73 0c 5e 89 f8 5b 5e 5f 5d e9 9b f6 ff ff 5b 5b 5e 5f 5d c3 55 83 c0 34 31 d2 83 78 08 00 89 e5 74 11 e8 
15 fe ff ff 89 c2 <8b> 40 40 85 c0 75 f2 83 ea 30 5d 89 d0 c3 55 89 e5 53 89 d3 83 
EIP: [<c011f96c>] pick_next_task_fair+0x15/0x23 SS:ESP 0068:f7481f08
---[ end trace 18a67066b954c85e ]---

This system is in production, thus pretty strong constrainted for experimenting
(more or less possible for a few hours at sunday), but I'm building 2.6.24.3 ATM, 
since it contains two patches, which could fit the bill. Sunday is away for 
a while, though.

Any more insight is very welcomed.

Pete
