Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYLJMNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYLJMNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 07:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYLJMMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 07:12:55 -0500
Received: from brick.kernel.dk ([93.163.65.50]:19219 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbYLJMMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 07:12:54 -0500
Date: Wed, 10 Dec 2008 13:12:38 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [bug?] bio: add experimental support for inlining a number of bio_vecs inside the bio
Message-ID: <20081210121237.GQ23742@kernel.dk>
References: <20081210164659.9ebb8158.sfr@canb.auug.org.au> <20081210183059.4FD6.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081210204630.4FE3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210204630.4FE3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10 2008, KOSAKI Motohiro wrote:
> CC to Jens Axboe
> 
> > message
> > ==================================
> > Creating root device.
> > Unable to handle kernel NULL pointer dereference (address 00000000000000c8)
> > swapper[0]: Oops 8813272891392 [1]
> > Modules linked in: dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod lpfc mptspi mptscsih mptbase ehci_hcd ohci_hcd uhci_hcd usbcore
> > 
> > Pid: 0, CPU 0, comm:              swapper
> > psr : 0000101008026018 ifs : 800000000000038a ip  : [<a00000010032be00>]    Not tainted (2.6.28-rc7-next-20081210)
> > ip is at __blk_complete_request+0x20/0x2a0
> > unat: 0000000000000000 pfs : 0000000000000205 rsc : 0000000000000003
> > rnat: 000000000000000c bsps: e000000001143180 pr  : 656960155aa55695
> > ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
> > csd : 0000000000000000 ssd : 0000000000000000
> > b0  : a00000010032c0e0 b6  : a000000100364480 b7  : a000000100504600
> > f6  : 0fffcfffffffff0000000 f7  : 0ffe6e830000000000000
> > f8  : 1000ae830000000000000 f9  : 1003e0000000000004020
> > f10 : 1003e0000000000000060 f11 : 1003e00000000000000ab
> > r1  : a000000100ef6c30 r2  : 00000000000000c8 r3  : e0000040c2611fe0
> > r8  : 0000000000000000 r9  : 0000000000000801 r10 : 0000000000000a01
> > r11 : 0000000000000801 r12 : a000000100b2fb40 r13 : a000000100b20000
> > r14 : 0000000000000000 r15 : 0000000000000000 r16 : 0000000000000001
> > r17 : e0000040c2611ff0 r18 : 0000000000000200 r19 : e0000040c3100000
> > r20 : a040000000000000 r21 : 000000000000000e r22 : a000000100504600
> > r23 : e0000040c0722a90 r24 : a000000100b2fbd0 r25 : a000000100ba3908
> > r26 : 0000000000000400 r27 : 00000000000000ff r28 : 0000000000000000
> > r29 : a000000100b20d34 r30 : 000000000000000d r31 : 0000000000007fff
> > 
> > Call Trace:
> >  [<a000000100017940>] show_stack+0x80/0xa0
> >                                 sp=a000000100b2f710 bsp=a000000100b21358
> >  [<a000000100018240>] show_regs+0x880/0x8c0
> >                                 sp=a000000100b2f8e0 bsp=a000000100b21300
> >  [<a000000100040570>] die+0x1b0/0x2e0
> >                                 sp=a000000100b2f8e0 bsp=a000000100b212b8
> >  [<a000000100773dd0>] ia64_do_page_fault+0x810/0xb00
> >                                 sp=a000000100b2f8e0 bsp=a000000100b21258
> >  [<a00000010000c860>] ia64_native_leave_kernel+0x0/0x270
> >                                 sp=a000000100b2f970 bsp=a000000100b21258
> >  [<a00000010032be00>] __blk_complete_request+0x20/0x2a0
> >                                 sp=a000000100b2fb40 bsp=a000000100b21208
> >  [<a00000010032c0e0>] blk_complete_request+0x60/0x80
> >                                 sp=a000000100b2fb40 bsp=a000000100b211e0
> >  [<a000000100504620>] scsi_done+0x20/0x40
> >                                 sp=a000000100b2fb40 bsp=a000000100b211c0
> >  [<a000000201b12160>] mptscsih_io_done+0x7c0/0xf40 [mptscsih]
> >                                 sp=a000000100b2fb40 bsp=a000000100b210f8
> >  [<a000000201a480f0>] mpt_interrupt+0x1f0/0x1280 [mptbase]
> >                                 sp=a000000100b2fb40 bsp=a000000100b21098
> >  [<a0000001001211a0>] handle_IRQ_event+0x80/0x120
> >                                 sp=a000000100b2fbb0 bsp=a000000100b21060
> >  [<a000000100121570>] __do_IRQ+0x330/0x440
> >                                 sp=a000000100b2fbb0 bsp=a000000100b21000
> >  [<a000000100014990>] ia64_handle_irq+0x410/0x440
> >                                 sp=a000000100b2fbb0 bsp=a000000100b20f78
> >  [<a00000010000c860>] ia64_native_leave_kernel+0x0/0x270
> >                                 sp=a000000100b2fbb0 bsp=a000000100b20f78
> >  [<a0000001000186e0>] default_idle+0x1a0/0x1c0
> >                                 sp=a000000100b2fd80 bsp=a000000100b20f10
> >  [<a0000001000175a0>] cpu_idle+0x1e0/0x3c0
> >                                 sp=a000000100b2fe20 bsp=a000000100b20eb0
> >  [<a000000100733c50>] rest_init+0xd0/0x100
> >                                 sp=a000000100b2fe20 bsp=a000000100b20e98
> >  [<a000000100971440>] start_kernel+0x740/0x800
> >                                 sp=a000000100b2fe20 bsp=a000000100b20e20
> >  [<a000000100777e00>] __kprobes_text_end+0x760/0x780
> >                                 sp=a000000100b2fe30 bsp=a000000100b20d80
> > Kernel panic - not syncing: Aiee, killing interrupt handler!
> 
> bisect information is here.
> 
> 
> % git bisect log
> git bisect start
> # bad: [87602124ea74da54ae39e713a28d5593af9ad5ef] Add linux-next specific files for 20081210
> git bisect bad 87602124ea74da54ae39e713a28d5593af9ad5ef
> # good: [061e41fdb5047b1fb161e89664057835935ca1d2] Linux 2.6.28-rc7
> git bisect good 061e41fdb5047b1fb161e89664057835935ca1d2
> # good: [9be550f4dabca95e3b6d02a6865b58bfdf255902] Merge commit 'kvm/master'
> git bisect good 9be550f4dabca95e3b6d02a6865b58bfdf255902
> # good: [472ec6db8c6ca2d6088b7ebff6fa3210b9f9726c] Merge commit 'net/master'
> git bisect good 472ec6db8c6ca2d6088b7ebff6fa3210b9f9726c
> # good: [359ec37f233829f8765e41fb7dcb79f5b24a20db] Merge commit 'gfs2/master'
> git bisect good 359ec37f233829f8765e41fb7dcb79f5b24a20db
> # bad: [17ed6c92c143ff0b5d5eaac9fadd258cc4e8252b] Merge commit 'voltage/for-next'
> git bisect bad 17ed6c92c143ff0b5d5eaac9fadd258cc4e8252b
> # bad: [678ac94e1e49ba2094d43cf3a9ffa0fff78457d1] Merge commit 'slab/for-next'
> git bisect bad 678ac94e1e49ba2094d43cf3a9ffa0fff78457d1
> # bad: [da9849d8bc82d8764f3ada875764f64714d8b018] Merge commit 'firmware/master'
> git bisect bad da9849d8bc82d8764f3ada875764f64714d8b018
> # bad: [ecf323abe734650adb0790fa681490b288fc9073] block: use min_not_zero in blk_queue_stack_limits
> git bisect bad ecf323abe734650adb0790fa681490b288fc9073
> # good: [834ec249cbbefc4121964d5e843ac02ecc253d39] block: reorder struct bio to remove padding on 64bit
> git bisect good 834ec249cbbefc4121964d5e843ac02ecc253d39
> # good: [520e832e193f61001dc5d35d9536850713880630] bio: only mempool back the largest bio_vec slab cache
> git bisect good 520e832e193f61001dc5d35d9536850713880630
> # bad: [102e8207838eabe09a4275f97a03334fa8609aa0] aio: make the lookup_ioctx() lockless
> git bisect bad 102e8207838eabe09a4275f97a03334fa8609aa0
> # good: [dc23b3285aaaa0dbd013bcfacad26f752e23927e] bio: allow individual slabs in the bio_set
> git bisect good dc23b3285aaaa0dbd013bcfacad26f752e23927e
> # bad: [30e62ce1ce96ff01d4826b0e476941169c94041d] bio: add experimental support for inlining a number of bio_vecs inside the bio
> git bisect bad 30e62ce1ce96ff01d4826b0e476941169c94041d
> 
> 
> 
> ---------------------
> commit 30e62ce1ce96ff01d4826b0e476941169c94041d
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Dec 5 13:58:19 2008 +0100
> 
>     bio: add experimental support for inlining a number of bio_vecs inside the bio
> 
>     When we go and allocate a bio for IO, we actually do two allocations.
>     One for the bio itself, and one for the bi_io_vec that holds the
>     actual pages we are interested in.
> 
>     This feature inlines a definable amount of io vecs inside the bio
>     itself, so we eliminate the bio_vec array allocation for IO's up
>     to a certain size. It defaults to 4 vecs, which is typically 16k
>     of IO.
> 
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> ------------------------
> 
> 
> experimental??

Experimental in the sense that it's the first version, not the concept.
It's held up well for me, but just yesterday I received the first bug
report on a ppc platform and now you have this on ia64. Can you pin
point where in __blk_complete_request() it dies with the NULL pointer
deref? I'm assuming you don't have CONFIG_FAIL_IO_TIMEOUT set, otherwise
I don't see how it could fail. So that looks like req->q being NULL,
which doesn't have much relation to this.

Can you try with slab and pagealloc debugging options switched on? The
above looks like a side effect of some badness there.

-- 
Jens Axboe

