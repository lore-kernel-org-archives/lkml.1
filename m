Return-Path: <linux-kernel-owner+w=401wt.eu-S1761109AbXHJHha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761109AbXHJHha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbXHJHhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:37:21 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41426 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbXHJHhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:37:20 -0400
Message-ID: <46BC159A.9060900@linux.vnet.ibm.com>
Date: Fri, 10 Aug 2007 13:06:58 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Softlockup detected with 2.6.23-rc2-mm1
References: <46BC02B9.1000307@linux.vnet.ibm.com> <20070809232504.c28a3c93.akpm@linux-foundation.org>
In-Reply-To: <20070809232504.c28a3c93.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 10 Aug 2007 11:46:25 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>
>   
>> I get call trace, when the file system stress is run on the
>> 2.6.23-rc2-mm1 kernel on a Dual Core AMD Opteron
>> (processor 270)
>>
>> ============================================\BUG: spinlock bad magic on 
>> CPU#1, fsx-linux/19721
>>     
>
> Yes, sorry, mm-dirty-balancing-for-tasks.patch had a bug.  Those patches were
> removed from 2.6.23-rc2-mm2 - please test that instead.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
I get different call trace on AMD Opteron(tm) Processor 844 machine
, I am not sure where it is related to the same patch

=====================================================
BUG: soft lockup - CPU#3 stuck for 11s! [pdflush:272]
CPU 3:
Modules linked in:
Pid: 272, comm: pdflush Not tainted 2.6.23-rc2-mm1-autokern1 #1
RIP: 0010:[<ffffffff8021a9c3>]  [<ffffffff8021a9c3>] 
flush_tlb_others+0x69/0x95
RSP: 0000:ffff810001f15a90  EFLAGS: 00000202
RAX: 0000000000000003 RBX: ffff810001f15ac0 RCX: 0000000000000008
RDX: 00000000000008f3 RSI: 00000000000000f3 RDI: 0000000000000002
RBP: 0000000000000000 R08: ffff810082f05210 R09: ffffffff802e60c1
R10: ffff8100815e6e70 R11: 0000000000000000 R12: ffff8101ffc38080
R13: ffffffff80358b47 R14: ffff810001f15a40 R15: ffff810081d73208
FS:  0000000000000000(0000) GS:ffff810180724280(0000) knlGS:00000000f7f75b80
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000f7e20494 CR3: 00000000029f0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8021abd0>] flush_tlb_page+0x8f/0x97
 [<ffffffff8026daee>] page_mkclean+0x120/0x171
 [<ffffffff802e6227>] ext3_ordered_writepage+0x13f/0x16c
 [<ffffffff8025ed09>] clear_page_dirty_for_io+0x52/0xba
 [<ffffffff8025f002>] write_cache_pages+0x1b2/0x33a
 [<ffffffff8022a149>] update_curr+0xd9/0xf8
 [<ffffffff8025e9ca>] __writepage+0x0/0x2a
 [<ffffffff8025f1a9>] generic_writepages+0x1f/0x25
 [<ffffffff8025f1db>] do_writepages+0x2c/0x35
 [<ffffffff8029b453>] __writeback_single_inode+0x1c9/0x346
 [<ffffffff8023b809>] try_to_del_timer_sync+0x55/0x60
 [<ffffffff8023b826>] del_timer_sync+0x12/0x1f
 [<ffffffff8022a149>] update_curr+0xd9/0xf8
 [<ffffffff8022a446>] dequeue_entity+0x7d/0x92
 [<ffffffff8029ba20>] generic_sync_sb_inodes+0x216/0x372
 [<ffffffff8029bb99>] sync_sb_inodes+0x1d/0x1f
 [<ffffffff8029bdd9>] writeback_inodes+0x83/0xd6
 [<ffffffff8025e82b>] wb_kupdate+0xa0/0x113
 [<ffffffff8025f658>] pdflush+0x156/0x206
 [<ffffffff8025e78b>] wb_kupdate+0x0/0x113
 [<ffffffff8025f502>] pdflush+0x0/0x206
 [<ffffffff80245660>] kthread+0x44/0x6d
 [<ffffffff8020c5e8>] child_rip+0xa/0x12
 [<ffffffff8024561c>] kthread+0x0/0x6d
 [<ffffffff8020c5de>] child_rip+0x0/0x12

Thanks
Kamalesh Babulal.
