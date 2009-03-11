Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbZCKETS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbZCKETS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 00:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZCKETD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 00:19:03 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62009 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZCKETA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 00:19:00 -0400
Message-Id: <200903110418.n2B4IU4q072339@www262.sakura.ne.jp>
Subject: KMEMCHECK: linux-next: kernel BUG at arch/x86/mm/kmemcheck/kmemcheck.c:297!
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: vegardno@ifi.uio.no, penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Mar 2009 13:18:30 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 11032009 #1705075, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I encountered this.

[    0.004000] ------------[ cut here ]------------
[    0.004000] kernel BUG at arch/x86/mm/kmemcheck/kmemcheck.c:297!
[    0.004000] invalid opcode: 0000 [#1] SMP 
[    0.004000] last sysfs file: 
[    0.004000] Modules linked in:
[    0.004000] 
[    0.004000] Pid: 0, comm: swapper Not tainted (2.6.29-rc7-next-20090310 #1) VMware Virtual Platform
[    0.004000] EIP: 0060:[<c0122e01>] EFLAGS: 00010202 CPU: 0
[    0.004000] EIP is at kmemcheck_hide_pages+0x51/0x80
[    0.004000] EAX: c06d6f70 EBX: f7000000 ECX: 370001e3 EDX: c06d6f70
[    0.004000] ESI: c17bd000 EDI: 00000000 EBP: c0531ea0 ESP: c0531e8c
[    0.004000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.004000] Process swapper (pid: 0, ti=c0531000 task=c04f3b60 task.ti=c0531000)
[    0.004000] Stack:
[    0.004000]  00000001 00000002 00000000 00000024 c17bd024 c0531ec0 c019c390 00000000
[    0.004000]  00000001 c17bd000 c17bd000 00000100 c052ee10 c0531ee8 c0198055 ffffffff
[    0.004000]  21668823 00000001 ffffffff 000000d0 00000010 c052ee10 c052ee10 c0531f08
[    0.004000] Call Trace:
[    0.004000]  [<c019c390>] ? kmemcheck_alloc_shadow+0x70/0x90
[    0.004000]  [<c0198055>] ? allocate_slab+0xc5/0x130
[    0.004000]  [<c0198112>] ? new_slab+0x22/0x130
[    0.004000]  [<c01987c4>] ? __slab_alloc+0x104/0x1e0
[    0.004000]  [<c0199ce3>] ? __kmalloc+0x113/0x160
[    0.004000]  [<c02672b0>] ? kvasprintf+0x30/0x60
[    0.004000]  [<c02672b0>] ? kvasprintf+0x30/0x60
[    0.004000]  [<c02672b0>] ? kvasprintf+0x30/0x60
[    0.004000]  [<c02672f1>] ? kasprintf+0x11/0x20
[    0.004000]  [<c054ba30>] ? kmem_cache_init+0xc0/0x140
[    0.004000]  [<c03ce3d2>] ? __start_notes+0x0/0xe
[    0.004000]  [<c0535932>] ? start_kernel+0x182/0x280
[    0.004000]  [<c05352b0>] ? unknown_bootoption+0x0/0x150
[    0.004000]  [<c0535080>] ? __init_begin+0x80/0xc0
[    0.004000] Code: c0 89 c2 74 37 83 7d f0 01 75 20 8b 00 83 e0 fe 0d 00 08 00 00 89 02 0f 01 3b 47 83 c6 24 3b 7d ec 72 cb 83 c4 08 5b 5e 5f 5d c3 <0f> 0b 8d b6 00 00 00 00 8d bc 27 00 00 00 00 eb fe 0f 0b 8d b6 
[    0.004000] EIP: [<c0122e01>] kmemcheck_hide_pages+0x51/0x80 SS:ESP 0068:c0531e8c
[    0.004000] ---[ end trace 4eaa2a86a8e2da22 ]---

Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.29-rc7-next-20090310
Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.29-rc7-next-20090310.txt

Regards.
