Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbZATWXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbZATWXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZATWXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:23:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:23043 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZATWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:23:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L010jba5K2w2TqPmZ9hg6aABhW/6tPdYe7p3KSsXM21v/4spVrtC/AdTMPmNCut5Mx
         8tXOOl8l5C3n1b9AGahagCHCaLqJphSHsyOS7tHZ8sAlquqQbP76p5J+mOmrpPR/VlPp
         pfpPd7qaVCt4mQHUxHU8vkD8/mU2sQEdNu2Lw=
MIME-Version: 1.0
In-Reply-To: <720e76b80901201222m72ae2e98l972c81ef5886a12e@mail.gmail.com>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal>
	 <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal>
	 <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal>
	 <20090120073709.GC30821@kernel.dk>
	 <720e76b80901201222m72ae2e98l972c81ef5886a12e@mail.gmail.com>
Date: Tue, 20 Jan 2009 17:23:08 -0500
Message-ID: <720e76b80901201423p6b82aa77kdfbf3eddb8592bd5@mail.gmail.com>
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
From: Ben Gamari <bgamari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel build finally finished. Unfortunately, it crashes quickly
after booting with moderate disk IO, bringing down the entire machine.
For this reason, I haven't been able to complete a fio benchmark.
Jens, what do you think about this backtrace?

- Ben


BUG: unable to handle kernel paging request at 0000000008
IP: [<ffffffff811c4b2d>] cfq_remove_request+0xb0/0x1da
PGD b2902067 PUD b292e067 PMD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0t
CPU 0
Modules linked in: aes_x86_64 aes_generic i915 drm i2c_algo_bit rfcomm bridge s]
Pid: 3903, comm: evolution Not tainted 2.6.29-rc2ben #16
RIP: 0010:[<ffffffff811c4b2d>]  [<ffffffff811c4b2d>] cfq_remove_request+0xb0/0xa
RSP: 0018:ffff8800bb853758  EFLAGS: 00010006
RAX: 0000000000200200 RBX: ffff8800b28f3420 RCX: 0000000009deabeb
RDX: 0000000000100100 RSI: ffff8800b010afd0 RDI: ffff8800b010afd0
RBP: ffff8800bb853788 R08: ffff88011fc08250 R09: 000000000cf8b20b
R10: 0000000009e15923 R11: ffff8800b28f3420 R12: ffff8800b010afd0
R13: ffff8800b010afd0 R14: ffff88011d4e8000 R15: ffff88011fc08220
FS:  00007f4b1ef407e0(0000) GS:ffffffff817e7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000100108 CR3: 00000000b284b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process evolution (pid: 3903, threadinfo ffff8800bb852000, task ffff8800da0c2de)
Stack:
 ffffffff811ccc19 ffff88011fc08220 ffff8800b010afd0 ffff88011d572000
 ffff88011d4e8000 ffff88011d572000 ffff8800bb8537b8 ffffffff811c4ca8
 ffff88011fc08220 ffff88011d572000 ffff8800b010afd0 ffff88011fc08250
Call Trace:
 [<ffffffff811ccc19>] ? rb_insert_color+0xbd/0xe6
 [<ffffffff811c4ca8>] cfq_dispatch_insert+0x51/0x72
 [<ffffffff811c4d0d>] cfq_add_rq_rb+0x44/0xcf
 [<ffffffff811c5519>] cfq_insert_request+0x34d/0x3d1
 [<ffffffff811b6d81>] elv_insert+0x1a9/0x250
 [<ffffffff811b6ec3>] __elv_add_request+0x9b/0xa4
 [<ffffffff811b9769>] __make_request+0x3c4/0x446
 [<ffffffff811b7f53>] generic_make_request+0x2bf/0x309
 [<ffffffff811b8068>] submit_bio+0xcb/0xd4
 [<ffffffff810f170b>] submit_bh+0x115/0x138
 [<ffffffff810f31f7>] ll_rw_block+0xa5/0xf4
 [<ffffffff810f3886>] __block_prepare_write+0x277/0x306
 [<ffffffff8112c759>] ? ext3_get_block+0x0/0x101
 [<ffffffff810f3a7e>] block_write_begin+0x8b/0xdd
 [<ffffffff8112bd66>] ext3_write_begin+0xee/0x1c0
 [<ffffffff8112c759>] ? ext3_get_block+0x0/0x101
 [<ffffffff8109f3be>] generic_file_buffered_write+0x12e/0x2e4
 [<ffffffff8109f973>] __generic_file_aio_write_nolock+0x263/0x297
 [<ffffffff810e4470>] ? touch_atime+0xdf/0x101
 [<ffffffff8109feaa>] ? generic_file_aio_read+0x503/0x59c
 [<ffffffff810a01ed>] generic_file_aio_write+0x6c/0xc8
 [<ffffffff81128c72>] ext3_file_write+0x23/0xa5
 [<ffffffff810d2d77>] do_sync_write+0xec/0x132
 [<ffffffff8105da1c>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff8119c880>] ? selinux_file_permission+0x40/0xcb
 [<ffffffff8119c902>] ? selinux_file_permission+0xc2/0xcb
 [<ffffffff81194cc4>] ? security_file_permission+0x16/0x18
 [<ffffffff810d3693>] vfs_write+0xb0/0x10a
 [<ffffffff810d37bb>] sys_write+0x4c/0x74
 [<ffffffff810114aa>] system_call_fastpath+0x16/0x1b
Code: 48 85 c0 74 0c 4c 39 e0 48 8d b0 60 ff ff ff 75 02 31 f6 48 8b 7d d0 48 8
RIP  [<ffffffff811c4b2d>] cfq_remove_request+0xb0/0x1da
 RSP <ffff8800bb853758>
CR2: 0000000000100108
---[ end trace 6c5ef63f7957c4cf ]---




On Tue, Jan 20, 2009 at 3:22 PM, Ben Gamari <bgamari@gmail.com> wrote:
> On Tue, Jan 20, 2009 at 2:37 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Mon, Jan 19 2009, Mathieu Desnoyers wrote:
>>> * Jens Axboe (jens.axboe@oracle.com) wrote:
>>> Yes, ideally I should re-run those directly on the disk partitions.
>>
>> At least for comparison.
>>
>
> I just completed my own set of benchmarks using the fio job file
> Mathieu provided. This was on a 2.5 inch 7200 RPM SATA partition
> formatted as ext3. As you can see, I tested all of the available
> schedulers with both queuing enabled and disabled. I'll test the Jens'
> patch soon. Would a blktrace of the fio run help? Let me know if
> there's any other benchmarking or profiling that could be done.
> Thanks,
>
> - Ben
>
>
>                        mint            maxt
> ==========================================================
> queue_depth=31:
> anticipatory            35 msec         11036 msec
> cfq                     37 msec         3350 msec
> deadline                36 msec         18144 msec
> noop                    39 msec         41512 msec
>
> ==========================================================
> queue_depth=1:
> anticipatory            45 msec         9561 msec
> cfq                     28 msec         3974 msec
> deadline                47 msec         16802 msec
> noop                    35 msec         38173 msec
>
