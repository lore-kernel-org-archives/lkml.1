Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbXIRWSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbXIRWSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbXIRWS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:18:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39894 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbXIRWSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:18:25 -0400
Subject: 2.6.23-rc6-mm1 panic (memory controller issue ?)
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, balbir@in.ibm.com,
       clameter@sgi.com
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 15:21:16 -0700
Message-Id: <1190154076.31220.19.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

I get following panic from SLUB, while doing simple fsx tests.
I haven't used any container/memory controller stuff except 
that I configured them in :(

Looks like slub doesn't like one of the flags passed in ?

Known issue ? Ideas ?

Thanks,
Badari

CONFIG_CONTAINERS=y
CONFIG_CONTAINER_DEBUG=y
CONFIG_CONTAINER_NS=y
CONFIG_CONTAINER_CPUACCT=y
CONFIG_CONTAINER_MEM_CONT=y
CONFIG_ACPI_CONTAINER=m


elm3b29 login: ------------[ cut here ]------------
kernel BUG at mm/slub.c:1093!
invalid opcode: 0000 [1] SMP
last sysfs file: /power/state
CPU 3
Modules linked in:
Pid: 3885, comm: fsx-linux Not tainted 2.6.23-rc6-mm1 #2
RIP: 0010:[<ffffffff8029a458>]  [<ffffffff8029a458>] new_slab
+0x238/0x260
RSP: 0018:ffff81010140faf8  EFLAGS: 00010202
RAX: 0000000000000305 RBX: 0000000000000000 RCX: 00000000ffffffff
RDX: 00000000ffffffff RSI: 00000000001280d2 RDI: ffffffff806f3240
RBP: ffff81010140fb28 R08: 0000000000000040 R09: 0000000000000000
R10: 00000000000160c9 R11: 0000000000000002 R12: ffff8101c00146c0
R13: ffffffff806f3240 R14: ffffffff806f3240 R15: 00000000ffffffff
FS:  00007f7668f546d0(0000) GS:ffff8101c0729400(0000)
knlGS:0000000055749930
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f7668f6c000 CR3: 00000001821c1000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsx-linux (pid: 3885, threadinfo ffff81010140e000, task
ffff81010158aca0)
last branch before last exception/interrupt
 from  [<ffffffff8029a23c>] new_slab+0x1c/0x260
 to  [<ffffffff8029a458>] new_slab+0x238/0x260
Stack:  ffff8101c0729290 0000000000000000 ffff8101c00146c0
ffff8101df8618c0
 ffffffff806f3240 00000000ffffffff ffff81010140fb78 ffffffff8029a620
 001200d200000000 ffffffff8029eb10 001280d200000002 0000000000000000
Call Trace:
 [<ffffffff8029a620>] __slab_alloc+0x1a0/0x450
 [<ffffffff8029eb10>] mem_container_charge+0x90/0x2a0
 [<ffffffff8029ad0b>] kmem_cache_alloc+0x7b/0xa0
 [<ffffffff8029eb10>] mem_container_charge+0x90/0x2a0
 [<ffffffff80277c3e>] __alloc_pages+0x6e/0x360
 [<ffffffff8029ed4b>] mem_container_cache_charge+0x2b/0x40
 [<ffffffff8027176e>] add_to_page_cache+0x3e/0x120
 [<ffffffff80271869>] add_to_page_cache_lru+0x19/0x40
 [<ffffffff80271f2c>] find_or_create_page+0x5c/0xa0
 [<ffffffff803295c2>] ext3_truncate+0x342/0x990
 [<ffffffff8029eac2>] mem_container_charge+0x42/0x2a0
 [<ffffffff8027143d>] unlock_page+0x2d/0x40
 [<ffffffff80280e7f>] __do_fault+0x10f/0x3f0
 [<ffffffff8027f295>] __dec_zone_page_state+0x25/0x30
 [<ffffffff8028a146>] page_remove_rmap+0x46/0x140
 [<ffffffff80284b80>] vmtruncate+0xb0/0x110
 [<ffffffff802b81c0>] inode_setattr+0x30/0x180
 [<ffffffff8032ac9c>] ext3_setattr+0x12c/0x240
 [<ffffffff802b8690>] notify_change+0x380/0x3e0
 [<ffffffff802a0343>] do_truncate+0x63/0x90
 [<ffffffff802a1dc1>] generic_file_llseek+0x61/0xc0
 [<ffffffff802a0446>] sys_ftruncate+0xd6/0x120
 [<ffffffff8020c34e>] system_call+0x7e/0x83


Code: 0f 0b eb fe 66 66 66 90 41 8b 4d 14 ba 00 10 00 00 be 5a 00
RIP  [<ffffffff8029a458>] new_slab+0x238/0x260
 RSP <ffff81010140faf8>


