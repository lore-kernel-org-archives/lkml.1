Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbYHSTvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbYHSTvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbYHSTvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:51:46 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:48230 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYHSTvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=o1AW+cg2hIFu1MK74Tap8iFufXiB+CFXpFvaq9UsHY3trsJQmvf4XrLvJzhUODee2M
         qP4rRT4rA/OVNzD0k0coLsqCzCEpY5W1H3Il4ebD53riXk980ADdWVrNfuPMAbLo1UHK
         0wVYQRs2T8DwL0+DF1BValKA/5S+jUa1soP3M=
Message-ID: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com>
Date: Tue, 19 Aug 2008 21:51:44 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "the arch/x86 maintainers" <x86@kernel.org>
Subject: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With latest -git (1fca25427482387689fa27594c992a961d98768f), I got
this on reading from /dev/cpu/*/* while hot-unplugging cpu1.

------------[ cut here ]------------
WARNING: at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/arch/x86/kernel/ipi.c:123
send_IPI_mask_bitmask+0xc3/0xe0()
Pid: 3881, comm: cat Not tainted 2.6.27-rc3-00464-g1fca254 #12
 [<c013591f>] warn_on_slowpath+0x4f/0x80
 [<c010a300>] ? native_sched_clock+0x80/0x110
 [<c010a335>] ? native_sched_clock+0xb5/0x110
 [<c015ae5a>] ? __lock_acquire+0x27a/0xa00
 [<c015635b>] ? trace_hardirqs_off+0xb/0x10
 [<c010a335>] ? native_sched_clock+0xb5/0x110
 [<c01563bd>] ? put_lock_stats+0xd/0x30
 [<c0118a43>] send_IPI_mask_bitmask+0xc3/0xe0
 [<c01017c8>] send_IPI_mask+0x8/0x10
 [<c0118307>] native_send_call_func_single_ipi+0x27/0x30
 [<c0160a2b>] generic_exec_single+0x7b/0x80
 [<c0160adf>] smp_call_function_single+0x5f/0x110
 [<c037a440>] ? __rdmsr_safe_on_cpu+0x0/0x60
 [<c037a440>] ? __rdmsr_safe_on_cpu+0x0/0x60
 [<c037a597>] _rdmsr_on_cpu+0x27/0x60
 [<c037a5ea>] rdmsr_safe_on_cpu+0x1a/0x20
 [<c011733e>] msr_read+0x6e/0xa0
 [<c01a87b4>] vfs_read+0x94/0x130
 [<c01172d0>] ? msr_read+0x0/0xa0
 [<c01a8b5d>] sys_read+0x3d/0x70
 [<c01040db>] sysenter_do_call+0x12/0x3f
 =======================
---[ end trace fe4338948cb73be2 ]---
BUG: soft lockup - CPU#0 stuck for 61s! [cat:3881]
irq event stamp: 14632440
hardirqs last  enabled at (14632439): [<c015968b>] trace_hardirqs_on+0xb/0x10
hardirqs last disabled at (14632440): [<c015635b>] trace_hardirqs_off+0xb/0x10
softirqs last  enabled at (14632434): [<c013a4d1>] __do_softirq+0xe1/0x100
softirqs last disabled at (14632427): [<c013a595>] do_softirq+0xa5/0xb0
Pid: 3881, comm: cat Tainted: G        W (2.6.27-rc3-00464-g1fca254 #12)
EIP: 0060:[<c0160952>] EFLAGS: 00200202 CPU: 0
EIP is at csd_flag_wait+0x12/0x20
EAX: f5f31ef0 EBX: c215dc60 ECX: ffffb300 EDX: 000008fa
ESI: 00200292 EDI: c215dc68 EBP: f5f31ec0 ESP: f5f31ec0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: 087d0a5c CR3: 33c36000 CR4: 000006d0
DR0: c0ebd43c DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0160a15>] generic_exec_single+0x65/0x80
 [<c0160adf>] smp_call_function_single+0x5f/0x110
 [<c037a440>] ? __rdmsr_safe_on_cpu+0x0/0x60
 [<c037a440>] ? __rdmsr_safe_on_cpu+0x0/0x60
 [<c037a597>] _rdmsr_on_cpu+0x27/0x60
 [<c037a5ea>] rdmsr_safe_on_cpu+0x1a/0x20
 [<c011733e>] msr_read+0x6e/0xa0
 [<c01a87b4>] vfs_read+0x94/0x130
 [<c01172d0>] ? msr_read+0x0/0xa0
 [<c01a8b5d>] sys_read+0x3d/0x70
 [<c01040db>] sysenter_do_call+0x12/0x3f
 =======================

At least SSH is not usable after this, but I guess SysRq and such
would work (the "CPU stuck" message still showed up after the apparent
freeze).


Vegard

PS: This is probably not a regression.

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
