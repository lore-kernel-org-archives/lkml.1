Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYDJSHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYDJSHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbYDJSHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:07:40 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:37927 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbYDJSHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:07:39 -0400
Message-ID: <47FE5765.2030401@linux.vnet.ibm.com>
Date: Thu, 10 Apr 2008 23:37:33 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] linux-next:  April 10 -  kernel oops at kmem_cache_alloc ()
 regression from April 9 kernel
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
In-Reply-To: <20080410181404.b76939a6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

When booting the x86_64 boxes with the next-20080409 and 20080410 kernels
the kernel bug is hit. The same bug was reported for the April 9  kernel
at http://lkml.org/lkml/2008/4/10/63 (this kernel was compiled with 
CONFIG_CC_STACKPROTECTOR is not set)


BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff802869b1>] kmem_cache_alloc+0x41/0x130
PGD 32dc2e067 PUD 32dd6a067 PMD 0 
Oops: 0000 [1] SMP 
last sysfs file: /sys/kernel/uevent_seqnum
CPU 0 
Modules linked in: sg
Pid: 1, comm: init Not tainted 2.6.25-rc8-next-20080410-autotest #1
RIP: 0010:[<ffffffff802869b1>]  [<ffffffff802869b1>] kmem_cache_alloc+0x41/0x130
RSP: 0000:ffff810bfe4abef8  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff81090e4aa050 RCX: 0000000000405017
RDX: 00007ffffb4c05b8 RSI: 00000000000000d0 RDI: 0000000000000000
RBP: 0000000000000292 R08: 0000000000586f00 R09: 0000000000586f20
R10: 0000000000586f08 R11: 0000000000000246 R12: 00000000000000d0
R13: 0000000000000000 R14: 0000000000405150 R15: 0000000000000000
FS:  000000000058b850(0063) GS:ffffffff8067f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000090d0e6000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff810bfe4aa000, task ffff81090e4aa050)
Stack:  0000000000000000 ffff81090e4aa050 ffff81090e4aa050 0000000000000001
 0000000000405110 ffffffff80212f96 0000000000000292 ffff81090e4aa050
 00007ffffb4c05a8 ffffffff8020cb79 0000000000000000 ffffffff804da339
Call Trace:
 [<ffffffff80212f96>] init_fpu+0x96/0xf0
 [<ffffffff8020cb79>] math_state_restore+0x19/0x60
 [<ffffffff804da339>] error_exit+0x0/0x51


Code: 48 89 6c 24 10 49 89 fd 9c 5d fa 65 48 8b 04 25 00 00 00 00 f7 40 14 00 00 00 12 0f 85 b6 00 00 00 65 8b 04 25 24 00 00 00 89 c0 <49> 8b 54 c5 00 8b 02 85 c0 0f 84 cb 00 00 00 8b 02 c7 42 0c 01 
RIP  [<ffffffff802869b1>] kmem_cache_alloc+0x41/0x130
 RSP <ffff810bfe4abef8>
CR2: 0000000000000000
---[ end trace d1dc597e06b986c0 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: init Tainted: G      D  2.6.25-rc8-next-20080410-autotest #1

Call Trace:
 [<ffffffff80232016>] panic+0x86/0x170
 [<ffffffff802332ce>] printk+0x4e/0x60
 [<ffffffff802332ce>] printk+0x4e/0x60
 [<ffffffff80234f30>] do_exit+0x770/0x780
 [<ffffffff8020c737>] oops_end+0x87/0x90
 [<ffffffff8021ef55>] do_page_fault+0x405/0x890
 [<ffffffff804da339>] error_exit+0x0/0x51
 [<ffffffff802869b1>] kmem_cache_alloc+0x41/0x130
 [<ffffffff80212f96>] init_fpu+0x96/0xf0
 [<ffffffff8020cb79>] math_state_restore+0x19/0x60
 [<ffffffff804da339>] error_exit+0x0/0x51
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
