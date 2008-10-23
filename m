Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYJWRnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYJWRnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYJWRnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:43:46 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20701 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYJWRnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:43:45 -0400
Message-ID: <4900B7CC.5060005@oracle.com>
Date: Thu, 23 Oct 2008 10:43:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: next-20081023 x86_64 boot hang: int3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2 out of 2 x86_64 SMP boots stop with:

calling  tcp_congestion_default+0x0/0x12 @ 1
initcall tcp_congestion_default+0x0/0x12 returned 0 after 2 usecs
Freeing unused kernel memory: 448k freed
Write protecting the kernel read-only data: 4816k
int3: 0000 [#1] SMP
last sysfs file:
CPU 2
Modules linked in:
Pid: 0, comm: events/0 Not tainted 2.6.27-next-20081023 #1
RIP: 0010:[<ffffffff8078ba2b>]  [<ffffffff8078ba2b>] nmi_cpu_busy+0x1/0x15
RSP: 0018:ffff88017faa7f80  EFLAGS: 00000086
RAX: 00000000ffffffff RBX: ffff88027f60e000 RCX: ffff88017fa98000
RDX: ffffffff807eb480 RSI: 0000000000000000 RDI: ffffffff807b9e5c
RBP: ffff88017faa7f98 R08: 0000000000000000 R09: ffff88002802c768
R10: 0000000000000000 R11: ffff88027e023e90 R12: 0000000000000002
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88017fa32280(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/0 (pid: 0, threadinfo ffff88017fa8c000, task ffff88017fa98000)
Stack:
 ffffffff80257afe ffffffff8076d938 0000000000000000 ffff88017faa7fa8
 ffffffff8021f1b0 ffff88017fa8de50 ffffffff8020cabb ffff88017fa8de50 <EOI>
 ffff88017fa8ded8 ffff88027e023e90 0000000000000000 ffff88002802c768
Call Trace:
 <IRQ> <0> [<ffffffff80257afe>] ? generic_smp_call_function_interrupt+0x35/0xd7
 [<ffffffff8021f1b0>] smp_call_function_interrupt+0x1f/0x2f
 [<ffffffff8020cabb>] call_function_interrupt+0x6b/0x70
 <EOI> <0> [<ffffffff80212659>] ? default_idle+0x2b/0x40
 [<ffffffff8021287d>] ? c1e_idle+0xe5/0xec
 [<ffffffff8057072f>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8020ad1d>] ? cpu_idle+0x48/0x66
 [<ffffffff80568784>] ? start_secondary+0x177/0x17c
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
RIP  [<ffffffff8078ba2b>] nmi_cpu_busy+0x1/0x15
 RSP <ffff88017faa7f80>
Kernel panic - not syncing: Fatal exception in interrupt


Full boot log is at
http://oss.oracle.com/~rdunlap/kerneltest/logs/netcon-5175.log
and .config is at http://oss.oracle.com/~rdunlap/kerneltest/logs/kconfig-5175

---
~Randy
