Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYLOSdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYLOSdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 13:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbYLOSdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 13:33:03 -0500
Received: from brick.kernel.dk ([93.163.65.50]:27765 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbYLOSdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 13:33:03 -0500
Date: Mon, 15 Dec 2008 19:32:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-20081215: kernel BUG at block/cfq-iosched.c:1243
Message-ID: <20081215183235.GG32491@kernel.dk>
References: <a4423d670812151029u5458f9b4iaa36316a5f210ff1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670812151029u5458f9b4iaa36316a5f210ff1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15 2008, Alexander Beregalov wrote:
> Hi
> 
> [   22.857720] scsi_scan_0 used greatest stack depth: 4864 bytes left
> [   22.859221] scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-ROM GCR-8240N 1.10 PQ
> : 0 ANSI: 5
> [   23.077531] ------------[ cut here ]------------
> [   23.080733] kernel BUG at block/cfq-iosched.c:1243!
> [   23.080733] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [   23.080733] last sysfs file:
> [   23.080733] CPU 3
> [   23.080733] Modules linked in:
> [   23.080733] Pid: 580, comm: scsi_scan_0 Tainted: G        W  2.6.28-rc8-next-
> 20081215 #98
> [   23.080733] RIP: 0010:[<ffffffff80371160>]  [<ffffffff80371160>] cic_free_fun
> c+0x18/0x88
> [   23.080733] RSP: 0018:ffff88007ce9fe40  EFLAGS: 00010246
> [   23.080733] RAX: ffff88007ceb6618 RBX: ffff88007cf1d680 RCX: 0000000000000001
> [   23.080733] RDX: 0000000000000001 RSI: ffff88007cf1d680 RDI: ffff88007cea6000
> [   23.080733] RBP: ffff88007ce9fe60 R08: 0000000000000246 R09: 0000000000000001
> [   23.080733] R10: ffff88007ce9fde0 R11: ffff88007f0489c0 R12: ffff88007cea6000
> [   23.080733] R13: ffff88007ce9ff00 R14: ffff88007cc49568 R15: ffff88007cc49568
> [   23.080733] FS:  0000000000000000(0000) GS:ffff88007f402a28(0000) knlGS:00000
> 00000000000
> [   23.080733] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [   23.080733] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> [   23.080733] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   23.080733] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   23.080733] Process scsi_scan_0 (pid: 580, threadinfo ffff88007ce9e000, task
> ffff88007cc49310)
> [   23.080733] Stack:
> [   23.080733]  ffff88007cf1d6f8 ffff88007cea6000 ffff88007ce9ff00 ffff88007cc49
> 568
> [   23.080733]  ffff88007ce9fe80 ffffffff803711f5 ffff88007cea6000 ffff88007cc49
> 310
> [   23.080733]  ffff88007ce9fea0 ffffffff8036c985 ffff88007ce9ff00 ffff88007cea6
> 000
> [   23.080733] Call Trace:
> [   23.080733]  [<ffffffff803711f5>] cfq_free_io_context+0x25/0x2f
> [   23.080733]  [<ffffffff8036c985>] put_io_context+0x53/0x72
> [   23.080733]  [<ffffffff8036ca61>] exit_io_context+0x8e/0x95
> [   23.080733]  [<ffffffff8023a679>] do_exit+0x858/0x88f
> [   23.080733]  [<ffffffff8020c901>] child_rip+0x11/0x20
> [   23.080733]  [<ffffffff8020c2c0>] ? restore_args+0x0/0x30
> [   23.080733]  [<ffffffff80249f30>] ? kthread+0x0/0x76
> [   23.080733]  [<ffffffff8020c8f0>] ? child_rip+0x0/0x20
> [   23.080733] Code: c6 75 92 60 80 48 89 cf 31 c0 e8 45 b3 00 00 c9 48 98 c3 55
>  48 89 e5 41 56 41 55 41 54 49 89 fc 53 48 89 f3 48 83 7e 08 00 75 04 <0f> 0b eb
>  fe 4c 8d 6f 08 4c 89 ef e8 77 40 17 00 48 8b 73 08 49
> [   23.080733] RIP  [<ffffffff80371160>] cic_free_func+0x18/0x88
> [   23.080733]  RSP <ffff88007ce9fe40>
> [   25.744530] ---[ end trace 4eaa2a86a8e2da22 ]---

Odd, is it reproducible? What is your .config?

-- 
Jens Axboe

