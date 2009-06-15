Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZFOMn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZFOMn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZFOMns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:43:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50271 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZFOMnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:43:47 -0400
Date: Mon, 15 Jun 2009 14:52:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: MCE boot crash in qemu
Message-ID: <20090615125200.GD31969@one.firstfloor.org>
References: <19f34abd0906150459v2eb6fd1ak86586bc697c1e69f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0906150459v2eb6fd1ak86586bc697c1e69f@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 01:59:04PM +0200, Vegard Nossum wrote:
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

Probably qemu fakes that. You can check in /proc/cpuinfo after
it booted.

It should really clear the mca cpuid flag if it doesn't have any mca banks,
but ok.

Here's a untested patch (sorry not able to test any patches currently).
Does it fix the problem?

A workaround if you don't want to apply the patch is to boot with mce=off

-Andi

---

x86: mce: Handle banks == 0 case in K7 quirk

This happens on QEMU which reports MCA capability, but no banks.
Without this patch there is a buffer overrun and boot ops because the code
would try to initialize the 0 element of a zero length kmalloc()
buffer.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

--- linux-2.6.30-git8/arch/x86/kernel/cpu/mcheck/mce.c-o	2009-06-15 14:45:52.000000000 +0200
+++ linux-2.6.30-git8/arch/x86/kernel/cpu/mcheck/mce.c	2009-06-15 14:46:40.000000000 +0200
@@ -1245,7 +1245,7 @@
 		 * Various K7s with broken bank 0 around. Always disable
 		 * by default.
 		 */
-		 if (c->x86 == 6)
+		 if (c->x86 == 6 && banks > 0)
 			bank[0] = 0;
 	}
 


