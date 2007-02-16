Return-Path: <linux-kernel-owner+w=401wt.eu-S1945993AbXBPQhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945993AbXBPQhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945996AbXBPQhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:37:19 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:59832 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945993AbXBPQhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:37:17 -0500
Subject: Re: 2.6.20-mm1
From: Steve Fox <drfickle@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 10:37:12 -0600
Message-Id: <1171643832.3039.6.camel@drfickle.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

bl6-13, an x86_64 box listed on test.kernel.org, tripped on this during
an LTP run, even with
unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch applied. 

I'm not sure why the LTP results aren't copied over to TKO, but here's
the details anyway.

If someone can give me an idea where to look, I can start a bi-sect if
it would help.

kernel BUG at mm/swap.c:469!
invalid opcode: 0000 [1] SMP 
last sysfs file: /devices/system/node/node0/cpumap
CPU 1 
Modules linked in: hidp rfcomm l2cap bluetooth sunrpc ipv6 video button battery asus_acpi ac lp parport_pc parport nvram pcspkr amd_rng rng_core i2c_amd756 i2c_core
Pid: 19380, comm: mlockall01 Not tainted 2.6.20-mm1-autokern1 #1
RIP: 0010:[<ffffffff8026e007>]  [<ffffffff8026e007>] __pagevec_lru_add_mlock+0x6f/0x108
RSP: 0018:ffff810022d0fdd8  EFLAGS: 00010002
RAX: 000000000011006c RBX: ffff81003ff41000 RCX: ffff81003ff40dc0
RDX: 0000000000000000 RSI: ffff810026df36b8 RDI: ffff81000000c480
RBP: ffff81000000bb00 R08: ffff8100212f0e40 R09: ffff81003ee13d84
R10: 0000000000000286 R11: 0000000000000246 R12: ffff81000502aae0
R13: 0000000000000000 R14: ffff81000501fd20 R15: 00000036d491a000
FS:  00002b212329b1e0(0000) GS:ffff81003ee13cc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002b2123283000 CR3: 0000000023fba000 CR4: 00000000000006e0
Process mlockall01 (pid: 19380, threadinfo ffff810022d0e000, task ffff81002ccdc080)
Stack:  ffff8100212f0e40 ffff81003ff7a1c0 000000003eb47020 00000036d490e000
 ffff810031d31870 ffffffff8027387a 0000000000000000 ffff810022d0fed8
 ffffffffffffffff 0000000000000000 ffff810026df36b8 ffff810022d0fee0
Call Trace:
 [<ffffffff8027387a>] unmap_vmas+0x43c/0x760
 [<ffffffff802774fc>] exit_mmap+0x78/0xed
 [<ffffffff80230ca3>] mmput+0x45/0xb8
 [<ffffffff80235ee7>] do_exit+0x23d/0x811
 [<ffffffff80236537>] sys_exit_group+0x0/0xe
 [<ffffffff80209b6e>] system_call+0x7e/0x83


Code: 0f 0b eb fe f0 0f ba 2b 05 f0 0f ba 33 14 f0 0f ba 2b 06 be 
RIP  [<ffffffff8026e007>] __pagevec_lru_add_mlock+0x6f/0x108
 RSP <ffff810022d0fdd8>
Fixing recursive fault but reboot is needed!
BUG: spinlock lockup on CPU#3, syslogd/19381, ffff81000000c480

Call Trace:
 [<ffffffff80330047>] _raw_spin_lock+0xcf/0xf6
 [<ffffffff8026e100>] __pagevec_lru_add_active+0x60/0xe3
 [<ffffffff8027312f>] do_wp_page+0x3d8/0x485
 [<ffffffff80274a5d>] __handle_mm_fault+0x96d/0x9e2
 [<ffffffff804d1876>] do_page_fault+0x42b/0x7b1
 [<ffffffff80246af3>] lock_hrtimer_base+0x1b/0x3c
 [<ffffffff804cf801>] _spin_unlock_irq+0x9/0xc
 [<ffffffff8023c175>] do_sigaction+0x16b/0x17f
 [<ffffffff80236c29>] do_setitimer+0x18e/0x336
 [<ffffffff804cfc2d>] error_exit+0x0/0x84

-- 0:conmux-control -- time-stamp -- Feb/16/07  4:13:11 --
-- 0:conmux-control -- time-stamp -- Feb/16/07  5:22:45 --
BUG: spinlock lockup on CPU#0, portmap/1699, ffff81000000c480

Call Trace:
 [<ffffffff80330047>] _raw_spin_lock+0xcf/0xf6
 [<ffffffff8026e1e4>] __pagevec_lru_add+0x61/0xe0
 [<ffffffff8026e3aa>] __lru_add_drain+0x24/0x7e
 [<ffffffff80277324>] unmap_region+0x41/0x12c
 [<ffffffff8027808d>] do_munmap+0x1f9/0x276
 [<ffffffff804cf1e0>] __down_write_nested+0x34/0x9e
 [<ffffffff8027814a>] sys_munmap+0x40/0x5a
 [<ffffffff80209b6e>] system_call+0x7e/0x83

-- 

Steve Fox
IBM Linux Technology Center

