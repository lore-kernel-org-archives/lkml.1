Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYDJJpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYDJJpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYDJJpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:45:46 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:50642 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYDJJpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:45:45 -0400
Message-ID: <47FDE045.4070509@linux.vnet.ibm.com>
Date: Thu, 10 Apr 2008 15:09:17 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] linux-next: Tree for April 9 warning on CC_STACKPROTECTOR,
 followed by kernel panic
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
In-Reply-To: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

The next-20080409 kernel warns while booting up on a x86_64 machine.
When compiled the kernel with CONFIG_CC_STACKPROTECTOR=y, the warning
is followed by the kernel panic.

Testing -fstack-protector-all feature
No -fstack-protector-stack-frame!
-fstack-protector-all test failed
------------[ cut here ]------------
WARNING: at kernel/panic.c:365 __stack_chk_test+0x4b/0x50()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-rc8-next-20080409-autotest #1

Call Trace:
 [<ffffffff80231f5e>] warn_on_slowpath+0x51/0x63
 [<ffffffff80232d93>] printk+0x4e/0x56
 [<ffffffff80382fcd>] extract_entropy+0x47/0x90
 [<ffffffff80230000>] dup_mm+0xca/0x3fd
 [<ffffffff80231eba>] __stack_chk_test_func+0x21/0x32
 [<ffffffff80231fbb>] __stack_chk_test+0x4b/0x50
 [<ffffffff808ba8f1>] kernel_init+0x189/0x2f9
 [<ffffffff804ee221>] _spin_unlock_irq+0x9/0xc
 [<ffffffff8020cb88>] child_rip+0xa/0x12
 [<ffffffff808ba768>] kernel_init+0x0/0x2f9
 [<ffffffff8020cb7e>] child_rip+0x0/0x12

---[ end trace d88d2f3a71e3b32c ]---
Freeing unused kernel memory: 368k freed
Write protecting the kernel read-only data: 4188k
BUG: unable to handle kernel NULL pointer dereference at 00000000000002e8
IP: [<ffffffff80286c11>] kmem_cache_alloc+0x19/0x6b
PGD 3e925067 PUD 3e924067 PMD 0 
Oops: 0000 [1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: init Not tainted 2.6.25-rc8-next-20080409-autotest #1
RIP: 0010:[<ffffffff80286c11>]  [<ffffffff80286c11>] kmem_cache_alloc+0x19/0x6b
RSP: 0000:ffff81003f9c9f08  EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffffffff80211f7e
RDX: 00007fff1f89e710 RSI: 00000000000000d0 RDI: 0000000000000000
RBP: 00007fff1f89e6f8 R08: 000000000065e300 R09: 000000000065e2e8
R10: 000000000066d800 R11: 0000000000000203 R12: 00000000000000d0
R13: 000000000047c290 R14: 000000000047c250 R15: 0000000000000000
FS:  000000000066d870(0063) GS:ffffffff8067a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000002e8 CR3: 000000003e921000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff81003f9c8000, task ffff81003f9c6000)
Stack:  ffff81003f9c6000 00007fff1f89e6f8 0000000000000002 ffffffff80211f7e
 ffff81003e920060 ffffffff8033419c ffff81003f9c6000 ffffffff8020d96a
 0000000000000000 ffffffff804ee379 0000000000000000 000000000047c250
Call Trace:
 [<ffffffff80211f7e>] ? init_fpu+0x88/0xc9
 [<ffffffff8033419c>] ? __up_read+0x13/0x8a
 [<ffffffff8020d96a>] ? math_state_restore+0x19/0x5a
 [<ffffffff804ee379>] ? error_exit+0x0/0x51


Code: 4b 18 31 c0 48 89 f7 fc f3 aa 5b 5d 41 5c 48 89 f0 c3 41 54 41 89 f4 55 53 48 8b 4c 24 18 9c 5b fa 65 8b 04 25 24 00 00 00 48 98 <48> 8b ac c7 e8 02 00 00 48 8b 55 00 48 85 d2 75 10 83 ca ff 49 
RIP  [<ffffffff80286c11>] kmem_cache_alloc+0x19/0x6b
 RSP <ffff81003f9c9f08>
CR2: 00000000000002e8
---[ end trace d88d2f3a71e3b32c ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: init Tainted: G      D  2.6.25-rc8-next-20080409-autotest #1

Call Trace:
 [<ffffffff8023225d>] panic+0x86/0x144
 [<ffffffff80251911>] kallsyms_lookup+0x49/0x80
 [<ffffffff80286c11>] kmem_cache_alloc+0x19/0x6b
 [<ffffffff80232d93>] printk+0x4e/0x56
 [<ffffffff80232d93>] printk+0x4e/0x56
 [<ffffffff802351c9>] do_exit+0x71/0x682
 [<ffffffff804ee731>] oops_begin+0x0/0x8c
 [<ffffffff804f058d>] do_page_fault+0x738/0x7f3
 [<ffffffff804ee379>] error_exit+0x0/0x51
 [<ffffffff80211f7e>] init_fpu+0x88/0xc9
 [<ffffffff80286c11>] kmem_cache_alloc+0x19/0x6b
 [<ffffffff80211f7e>] init_fpu+0x88/0xc9
 [<ffffffff8033419c>] __up_read+0x13/0x8a
 [<ffffffff8020d96a>] math_state_restore+0x19/0x5a
 [<ffffffff804ee379>] error_exit+0x0/0x51

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
