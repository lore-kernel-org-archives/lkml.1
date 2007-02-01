Return-Path: <linux-kernel-owner+w=401wt.eu-S1422887AbXBAOAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422887AbXBAOAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422896AbXBAOAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:00:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:12540 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422887AbXBAOAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:00:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,267,1167638400"; 
   d="scan'208"; a="175784953:sNHT27878662"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Kernel BUG at fs/aio.c:509
Date: Thu, 1 Feb 2007 17:00:37 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC7CC56B@mssmsx411>
In-Reply-To: <20070131231622.4ccdb2c1.akpm@osdl.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Kernel BUG at fs/aio.c:509
Thread-Index: AcdF0OP4LJAq7JuqTd6EdoIfibtPwQAMLy+Q
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Andrew Morton" <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-aio@kvack.org>
X-OriginalArrivalTime: 01 Feb 2007 14:00:39.0376 (UTC) FILETIME=[5AB43D00:01C74609]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> BUG: warning at mm/truncate.c:398/invalidate_inode_pages2_range()
>  That warning got removed from -rc7.

2.6.20-rc-7: After 57 minutes and after 25 minutes of aiostress running
I've got 2 system hangs without any message in log.
On the third time I opened the console and got kernel panic massage:

$ ------------[ cut here ]------------
kernel BUG at fs/aio.c:507!
invalid opcode: 0000 [1] SMP 
CPU 2 
Modules linked in: firmware_class
Pid: 0, comm: swapper Not tainted 2.6.20-rc7 #1
RIP: 0010:[<ffffffff802841a3>]  [<ffffffff802841a3>]
__aio_put_req+0x22/0x146
RSP: 0018:ffff810037e4fd70  EFLAGS: 00010086
RAX: 00000000ffffffff RBX: ffff810037142ec0 RCX: 0000000025934000
RDX: 0000000000000000 RSI: ffff810037142ec0 RDI: ffff810005f8be40
RBP: ffff810005f8be40 R08: 6db6db6db6db6db7 R09: ffff810001000000
R10: 0000000000000000 R11: ffffffff802531b0 R12: ffff810005f8bea8
R13: 0000000000004000 R14: 0000000000000000 R15: 0000000000000213
FS:  0000000000000000(0000) GS:ffff81000225dec0(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000003cdca945d0 CR3: 0000000039002000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffff810037e48000, task
ffff810037e47560)
Stack:  ffff810037142ec0 ffff810005f8be40 ffff810005f8bea8
ffffffff80284958
 0000000000000000 0000000000000000 ffff8100381f2c00 ffff8100381f2f24
 0000000000000246 0000000000000000 0000000000000000 ffffffff802912a1
Call Trace:
 <IRQ>  [<ffffffff80284958>] aio_complete+0x16b/0x1c7
 [<ffffffff802912a1>] dio_bio_end_aio+0x9e/0xbe
 [<ffffffff803051cd>] __end_that_request_first+0x10e/0x3f7
 [<ffffffff80306a8b>] blk_run_queue+0x41/0x72
 [<ffffffff803aff9d>] scsi_end_request+0x27/0xc9
 [<ffffffff803b0180>] scsi_io_completion+0xf0/0x2c5
 [<ffffffff803d0063>] ahd_done+0x52b/0x574
 [<ffffffff803d3d1a>] sd_rw_intr+0x182/0x1ad
 [<ffffffff8030725d>] blk_done_softirq+0x5c/0x6a
 [<ffffffff80234d28>] __do_softirq+0x55/0xc3
 [<ffffffff802199d2>] ack_apic_level+0x37/0x4b
 [<ffffffff8020a95c>] call_softirq+0x1c/0x28
 [<ffffffff8020c4bb>] do_softirq+0x2c/0x7d
 [<ffffffff8020c5bd>] do_IRQ+0xb1/0xd0
 [<ffffffff80208ba2>] mwait_idle+0x0/0x46
 [<ffffffff80209d51>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff803b0f9d>] scsi_request_fn+0x0/0x33e
 [<ffffffff80208be4>] mwait_idle+0x42/0x46
 [<ffffffff80208b3a>] cpu_idle+0x8c/0xaf
 [<ffffffff80217380>] start_secondary+0x462/0x471
 
 
Code: 0f 0b eb fe 74 07 31 c0 e9 12 01 00 00 4c 8d a6 e0 00 00 00 
RIP  [<ffffffff802841a3>] __aio_put_req+0x22/0x146
 RSP <ffff810037e4fd70>
 <0>Kernel panic - not syncing: Aiee, killing interrupt handler!

> Oh.  2.6.19.  Did you try 2.6.19.latest?
The latest 2.6.19.2 functions exactly as 2.6.19 does.
I should add that I see on user screen:

...kernel: invalid opcode: 0000 [1] SMP

Leonid
-----Original Message-----
From: Andrew Morton [mailto:akpm@osdl.org] 
Sent: Thursday, February 01, 2007 10:16 AM
To: Ananiev, Leonid I
Cc: linux-kernel@vger.kernel.org; linux-aio@kvack.org
Subject: Re: Kernel BUG at fs/aio.c:509

On Thu, 1 Feb 2007 09:13:51 +0300 "Ananiev, Leonid I"
<leonid.i.ananiev@intel.com> wrote:

> While repeatedly running 'aiostress -O -o 2' test I've got in
> /var/log/messages:
> 
> BUG: warning at mm/truncate.c:398/invalidate_inode_pages2_range()
> Call Trace:
>  [<ffffffff802573c3>] invalidate_inode_pages2_range+0x236/0x26b
>  [<ffffffff802af77b>] ext3_direct_IO+0x16c/0x19e
>  [<ffffffff802adc1d>] ext3_get_block+0x0/0xe2
>  [<ffffffff802518c0>] generic_file_direct_IO+0xb9/0xcf
>  [<ffffffff8025193d>] generic_file_direct_write+0x67/0x10e
>  [<ffffffff80252308>] __generic_file_aio_write_nolock+0x2d6/0x3fe
>  [<ffffffff802082c0>] __switch_to+0x26f/0x27e
>  [<ffffffff8047b8e9>] thread_return+0x0/0xd8
>  [<ffffffff80252497>] generic_file_aio_write+0x67/0xc7
>  [<ffffffff802ab2cc>] ext3_file_write+0x0/0x8f
>  [<ffffffff802ab2e2>] ext3_file_write+0x16/0x8f
>  [<ffffffff802ab2cc>] ext3_file_write+0x0/0x8f
>  [<ffffffff80283f61>] aio_rw_vect_retry+0x72/0x14f
>  [<ffffffff80284ad9>] aio_run_iocb+0xe6/0x187
>  [<ffffffff802853e2>] io_submit_one+0x296/0x2e3
>  [<ffffffff80285979>] sys_io_submit+0x9b/0x108
>  [<ffffffff80229b49>] default_wake_function+0x0/0xe
>  [<ffffffff8020983e>] system_call+0x7e/0x83

That warning got removed from -rc7.  It's harmless, in most cases.  We
think.

It's a bit of a worry that aio-on-ext3 is triggering it.  That's
unexpected.

> ----------- [cut here ] --------- [please bite here ] ---------
> Kernel BUG at fs/aio.c:509
> invalid opcode: 0000 [1] SMP 
> CPU 1 
> Modules linked in: firmware_class
> Pid: 11362, comm: aiostress Not tainted 2.6.19 #1

Oh.  2.6.19.  Did you try 2.6.19.latest?

> RIP: 0010:[<ffffffff802841ea>]  [<ffffffff802841ea>]
> __aio_put_req+0x27/0x162
> RSP: 0018:ffff81000c167e88  EFLAGS: 00010096
> RAX: 00000000ffffffff RBX: ffff8100184f8dc0 RCX: 000000001d44f000
> RDX: 000000000000000d RSI: ffff8100184f8dc0 RDI: ffff81001d44ee80
> RBP: ffff81001d44ee80 R08: 6db6db6db6db6db7 R09: ffff810001000000
> R10: 0000000000000000 R11: 0000000000000046 R12: ffff810037341c80
> R13: ffff81001d44ee80 R14: 0000000000606998 R15: 0000000000000000
> FS:  00002ab979b0ee90(0000) GS:ffff810037e896c0(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002aea207c3950 CR3: 000000001009c000 CR4: 00000000000006e0
> Process aiostress (pid: 11362, threadinfo ffff81000c166000, task
> ffff81003f49f5a0)
> Stack:  ffff8100184f8dc0 ffff81001d44ee80 ffff810037341c80
> ffffffff80284ff6
>  ffff8100184f8dc0 ffff8100184f8dc0 0000000000000000 ffffffff80285409
>  0000000000607fb0 ffff81001d44ee80 0000000000606998 0000000000000001
> Call Trace:
>  [<ffffffff80284ff6>] aio_put_req+0x21/0x59
> ffffffff80284ff1:       e8 cd f1 ff ff          callq
ffffffff802841c3
> <__aio_put_req>
>  [<ffffffff80285409>] io_submit_one+0x2bd/0x2e3
>  [<ffffffff80285979>] sys_io_submit+0x9b/0x108
>  [<ffffffff80229b49>] default_wake_function+0x0/0xe
>  [<ffffffff8020983e>] system_call+0x7e/0x83
> 
> 
> Code: 0f 0b 68 76 e6 4a 80 c2 fd 01 85 c0 74 07 31 c0 e9 21 01 00 
> RIP  [<ffffffff802841ea>] __aio_put_req+0x27/0x162
>  RSP <ffff81000c167e88>
> NMI Watchdog detected LOCKUP on CPU 1
> CPU 1 
> Modules linked in: firmware_class
> Pid: 11362, comm: aiostress Not tainted 2.6.19 #1
> RIP: 0010:[<ffffffff8047d3f5>]  [<ffffffff8047d3f5>]
> _spin_lock_irq+0x8/0x10
> RSP: 0018:ffff81000c167c10  EFLAGS: 00000086
> RAX: ffff81003e0f0001 RBX: ffff81001d44ee80 RCX: 00002ab979b0ef40
> RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffff81001d44eeb8
> RBP: ffff81001d44ee80 R08: 0000000000000286 R09: 0000000000000018
> R10: 0000000000000286 R11: 0000000000000046 R12: 0000000000000001
> R13: 000000000000000b R14: ffffffff804a5904 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff810037e896c0(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002aea207c3950 CR3: 000000001009c000 CR4: 00000000000006e0
> Process aiostress (pid: 11362, threadinfo ffff81000c166000, task
> ffff81003f49f5a0)
> Stack:  ffffffff80284050 0000000000000286 ffffffff802441cc
> 0000000000000018
> ffffffff8047cebe 0000000000000246 ffff81001d44ee80 0000000000000000
> ffffffff80285880 ffff81003e0f12c0 ffff81003e0f12c0 ffff81003f49f5a0
> Call Trace:
> [<ffffffff80284050>] aio_cancel_all+0x12/0x87
> 0x12:       e8 9d 93 1f 00          callq  ffffffff8047d3ed
> <_spin_lock_irq>
> [<ffffffff802441cc>] lock_hrtimer_base+0x26/0x4c
> [<ffffffff8047cebe>] __down_read+0x12/0x9a
> [<ffffffff80285880>] exit_aio+0x2e/0x8c
> [<ffffffff8022d904>] mmput+0x19/0x98
> [<ffffffff80232be9>] do_exit+0x1f7/0x825
> [<ffffffff80321799>] vgacon_set_cursor_size+0x36/0xd1
> [<ffffffff8020b228>] kernel_math_error+0x0/0x90
> [<ffffffff8020baf4>] do_invalid_op+0xad/0xb7
> [<ffffffff802841ea>] __aio_put_req+0x27/0x162
> [<ffffffff80252308>] __generic_file_aio_write_nolock+0x2d6/0x3fe
> [<ffffffff802082c0>] __switch_to+0x26f/0x27e
> [<ffffffff8047d5fd>] error_exit+0x0/0x84
> [<ffffffff802841ea>] __aio_put_req+0x27/0x162
> [<ffffffff80284ff6>] aio_put_req+0x21/0x59
> [<ffffffff80285409>] io_submit_one+0x2bd/0x2e3
> [<ffffffff80285979>] sys_io_submit+0x9b/0x108
> [<ffffffff80229b49>] default_wake_function+0x0/0xe
> [<ffffffff8020983e>] system_call+0x7e/0x83
> Code: 83 3f 00 7e f9 eb f2 c3 53 48 89 fb e8 06 7b db ff f0 ff 0b 
> <1>Fixing recursive fault but reboot is needed!
>
========================================================================
> =======================
> 
> It stable happens after 2-5 aiosterss runs on 2.6.20-rc6 as well as on
> 2.6.19 in 4 processor Xeon.
> 
> fs/aio.c:509 line is  BUG_ON(req->ki_users < 0);
> It may be an effect of return 1 from invalidate_inode_pages2_range()
one
> second earlier as you can see in log.
> To investigate a root cause of ret=0 in
invalidate_inode_pages2_range()
> I have added printk() calls.
> As a result I can say that
>          invalidate_inode_pages2_range() reports BUG: warning at
> mm/truncate.c:398  occurs becouse of
>          invalidate_complete_page2()    		returns 0; it
> returns 0 because of
>          try_to_release_page()                        returns 0; it
> returns 0 because of
>          ext3_releasepage()                            returns 0; it
> returns 0 because of
>          journal_try_to_free_buffers()             returns 0; it
returns
> 0 because of
>          try_to_free_buffers()                         returns 0; it
> returns 0 because of
>          drop_buffers()                                  returns 0; it
> returns 0 because of
>          buffer_busy(bh)                                returns 1; it
> returns 0 because of
>          buffer_head count is 1 (bh->b_count==1) as additional printk
> reports.
> 
> Leonid
> -
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
