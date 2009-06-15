Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZFOMBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZFOMBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZFOMBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:01:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44337 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZFOMBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:01:43 -0400
Subject: Re: MCE boot crash in qemu
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0906150459v2eb6fd1ak86586bc697c1e69f@mail.gmail.com>
References: <19f34abd0906150459v2eb6fd1ak86586bc697c1e69f@mail.gmail.com>
Date: Mon, 15 Jun 2009 15:01:44 +0300
Message-Id: <1245067304.23207.30.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 13:59 +0200, Vegard Nossum wrote:
> Hi,
> 
> I get an MCE-related crash like this in latest linus tree:
> 
> [    0.115341] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.116396] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.120570] mce: CPU supports 0 MCE banks
> [    0.124870] BUG: unable to handle kernel NULL pointer dereference at 00000000
> 00000010
> [    0.128001] IP: [<ffffffff813b98ad>] mcheck_init+0x278/0x320
> [    0.128001] PGD 0
> [    0.128001] Thread overran stack, or stack corrupted
> [    0.128001] Oops: 0002 [#1] PREEMPT SMP
> [    0.128001] last sysfs file:
> [    0.128001] CPU 0
> [    0.128001] Modules linked in:
> [    0.128001] Pid: 0, comm: swapper Not tainted 2.6.30 #426
> [    0.128001] RIP: 0010:[<ffffffff813b98ad>]  [<ffffffff813b98ad>] mcheck_init+
> 0x278/0x320
> [    0.128001] RSP: 0018:ffffffff81595e38  EFLAGS: 00000246
> [    0.128001] RAX: 0000000000000010 RBX: ffffffff8158f900 RCX: 0000000000000000
> [    0.128001] RDX: 0000000000000000 RSI: 00000000000000ff RDI: 0000000000000010
> [    0.128001] RBP: ffffffff81595e68 R08: 0000000000000001 R09: 0000000000000000
> [    0.128001] R10: 0000000000000010 R11: 0000000000000000 R12: 0000000000000000
> [    0.128001] R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
> [    0.128001] FS:  0000000000000000(0000) GS:ffff880002288000(0000) knlGS:00000
> 00000000000
> [    0.128001] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [    0.128001] CR2: 0000000000000010 CR3: 0000000001001000 CR4: 00000000000006b0
> [    0.128001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.128001] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> [    0.128001] Process swapper (pid: 0, threadinfo ffffffff81594000, task ffffff
> ff8152a4a0)
> [    0.128001] Stack:
> [    0.128001]  0000000081595e68 5aa50ed3b4ddbe6e ffffffff8158f900 ffffffff8158f
> 914
> [    0.128001]  ffffffff8158f948 0000000000000000 ffffffff81595eb8 ffffffff813b8
> 69c
> [    0.128001]  5aa50ed3b4ddbe6e 00000001078bfbfd 0000062300000800 5aa50ed3b4ddb
> e6e
> [    0.128001] Call Trace:
> [    0.128001]  [<ffffffff813b869c>] identify_cpu+0x331/0x392
> [    0.128001]  [<ffffffff815a1445>] identify_boot_cpu+0x23/0x6e
> [    0.128001]  [<ffffffff815a14ac>] check_bugs+0x1c/0x60
> [    0.128001]  [<ffffffff8159c075>] start_kernel+0x403/0x46e
> [    0.128001]  [<ffffffff8159b2ac>] x86_64_start_reservations+0xac/0xd5
> [    0.128001]  [<ffffffff8159b3ea>] x86_64_start_kernel+0x115/0x14b
> [    0.128001]  [<ffffffff8159b140>] ? early_idt_handler+0x0/0x71
> [    0.128001] Code: c7 48 89 05 9e 71 40 00 74 2a 48 63 15 91 71 40 00 be ff 00
>  00 00 48 c1 e2 03 e8 bf a1 e2 ff e9 3f fe ff ff 48 8b 05 7b 71 40 00 <48> c7 00
>  00 00 00 00 eb 84 c7 05 40 71 40 00 01 00 00 00 e9 2b
> [    0.128001] RIP  [<ffffffff813b98ad>] mcheck_init+0x278/0x320
> [    0.128001]  RSP <ffffffff81595e38>
> [    0.128001] CR2: 0000000000000010
> [    0.129306] ---[ end trace a7919e7f17c0a725 ]---
> 
> It's this:
> 
>                 /*
>                  * Various K7s with broken bank 0 around. Always disable
>                  * by default.
>                  */
>                  if (c->x86 == 6)
>                         bank[0] = 0;
> 
> in mce_cpu_quirks() in arch/x86/kernel/cpu/mcheck/mce.c around line
> 1217. Strange that it thinks this is AMD cpu, though?
> 
> Attached full boot log.

I saw something like this too with qemu/x86_64.

			Pekka

