Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0BGKum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 05:50:42 -0500
Received: from borg.medozas.de ([188.40.89.202]:59313 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab0BGKui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 05:50:38 -0500
Date: Sun, 7 Feb 2010 11:50:36 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kswapd continuously active
In-Reply-To: <alpine.LSU.2.01.1002051423020.23211@obet.zrqbmnf.qr>
Message-ID: <alpine.LSU.2.01.1002071148150.26546@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1001230037350.20442@obet.zrqbmnf.qr> <20100125130627.GO13771@kernel.dk> <alpine.LSU.2.01.1001251416340.8189@obet.zrqbmnf.qr> <alpine.LSU.2.01.1002051329090.7843@obet.zrqbmnf.qr> <20100205130002.GI1025@kernel.dk>
 <alpine.LSU.2.01.1002051408280.23211@obet.zrqbmnf.qr> <20100205131220.GK1025@kernel.dk> <alpine.LSU.2.01.1002051423020.23211@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2010-02-05 14:24, Jan Engelhardt wrote:
>>> The ext4 filesystem is already mounted with barrier=0. If there
>>> is any block-level barriers I also can turn off, what would be
>>> the command?
>>
>>barrier=0 is enough. I do wonder why your writeback rate is that slow,
>>then. The disk has write back caching enabled?
>
>Yes, that seems to be the case at least. In fact the box is all fluffy 
>when nobody runs sync(1), which is what makes it so strange.
>
>sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
>support DPO or FUA

Here is an alternate trace that just happened.

INFO: task flush-8:0:343 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-8:0     D 0000000000555930  6664   343      2 0x18000000000
Call Trace:
 [00000000005555f4] start_this_handle+0x324/0x4b0
 [0000000000555930] jbd2_journal_start+0x94/0xc0
 [000000000052ddb8] ext4_da_writepages+0x1e0/0x460
 [000000000049bf30] do_writepages+0x28/0x48
 [00000000004e6d58] writeback_single_inode+0xf0/0x330
 [00000000004e7b24] writeback_inodes_wb+0x4c8/0x5d8
 [00000000004e7da4] wb_writeback+0x170/0x1ec
 [00000000004e8074] wb_do_writeback+0x188/0x1a4
 [00000000004e80b8] bdi_writeback_task+0x28/0xa0
 [00000000004a76c8] bdi_start_fn+0x64/0xc4
 [0000000000475f84] kthread+0x58/0x6c
 [000000000042ade0] kernel_thread+0x30/0x48
 [0000000000475ee0] kthreadd+0xb8/0x104
