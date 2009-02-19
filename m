Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZBSUve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZBSUve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZBSUvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:51:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:52306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZBSUvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:51:19 -0500
Subject: Re: [Announce] 2.6.29-rc4-rt2
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <1235069043.3841.15.camel@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <1235069043.3841.15.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 21:50:57 +0100
Message-Id: <1235076657.4612.652.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 19:44 +0100, Thomas Meyer wrote:

> [    0.003333] ------------[ cut here ]------------
> [    0.003333] WARNING: at mm/highmem.c:225 kmap_flush_unused+0x2b/0x4b()
> [    0.003333] Hardware name: MacBookPro1,1
> [    0.003333] Modules linked in:
> [    0.003333] Pid: 0, comm: swapper Not tainted 2.6.29-rc4-rt2-tip #54
> [    0.003333] Call Trace:
> [    0.003333]  [<c0451e70>] warn_slowpath+0x8a/0xd3
> [    0.003333]  [<c043ee71>] ? kmap+0x6c/0x77
> [    0.003333]  [<c04ad7f5>] ? get_page_from_freelist+0x389/0x42b
> [    0.003333]  [<c04adb8f>] ? __alloc_pages_internal+0xbf/0x3a6
> [    0.003333]  [<c04b9b92>] kmap_flush_unused+0x2b/0x4b
> [    0.003333]  [<c043b877>] change_page_attr_set_clr+0xe8/0x2ca
> [    0.003333]  [<c09aabd9>] ? rt_spin_lock+0x32/0x79
> [    0.003333]  [<c04bbeb3>] ? __pte_alloc_kernel+0x50/0x83
> [    0.003333]  [<c043bd16>] _set_memory_uc+0x27/0x3a
> [    0.003333]  [<c043ac3d>] ioremap_change_attr+0x24/0x47
> [    0.003333]  [<c043ae62>] __ioremap_caller+0x202/0x256
> [    0.003333]  [<c0cd0b79>] ? hpet_enable+0x2d/0x26c
> [    0.003333]  [<c043afe0>] ioremap_nocache+0x1c/0x2f
> [    0.003333]  [<c0cd0b79>] ? hpet_enable+0x2d/0x26c
> [    0.003333]  [<c0cd0b79>] hpet_enable+0x2d/0x26c
> [    0.003333]  [<c0cc34fb>] hpet_time_init+0x16/0x37
> [    0.003333]  [<c0cbd997>] start_kernel+0x289/0x345
> [    0.003333]  [<c0cbd093>] __init_begin+0x93/0xac
> [    0.003333] ---[ end trace a7919e7f17c0a725 ]---

Hmm, this appears unimplemented on -rt, shouldn't hurt much, but could
be fixed.

> [   13.169831] BUG: sleeping function called from invalid context at arch/x86/mm/highmem_32.c:8
> [   13.169957] in_atomic(): 0, irqs_disabled(): 1, pid: 1030, name: cryptsetup
> [   13.170075] Pid: 1030, comm: cryptsetup Tainted: G        W  2.6.29-rc4-rt2-tip #54
> [   13.170196] Call Trace:
> [   13.170284]  [<c0444cdd>] __might_sleep+0xda/0xf0
> [   13.170374]  [<c043ee55>] kmap+0x50/0x77
> [   13.170460]  [<c043db3b>] gup_pte_range+0x4b/0xe9
> [   13.170548]  [<c043dcb7>] get_user_pages_fast+0xde/0x17f
> [   13.170639]  [<c04f75f1>] dio_get_page+0x59/0x124
> [   13.170729]  [<c04f8258>] __blockdev_direct_IO+0x4ad/0xabe
> [   13.170819]  [<c04f5cdb>] ? blkdev_get_blocks+0x0/0x11c
> [   13.170837]  [<c04f730a>] blkdev_direct_IO+0x3f/0x55
> [   13.170837]  [<c04f5cdb>] ? blkdev_get_blocks+0x0/0x11c
> [   13.170837]  [<c04a977a>] generic_file_aio_read+0xfd/0x587
> [   13.170837]  [<c05ff445>] ? avc_has_perm+0x56/0x71
> [   13.170837]  [<c04d0fcf>] do_sync_read+0xc6/0x118
> [   13.170837]  [<c0467414>] ? autoremove_wake_function+0x0/0x54
> [   13.170837]  [<c06046d6>] ? selinux_file_permission+0x119/0x132
> [   13.170837]  [<c05fa4dc>] ? security_file_permission+0x1e/0x31
> [   13.170837]  [<c04d0f09>] ? do_sync_read+0x0/0x118
> [   13.170837]  [<c04d1b61>] vfs_read+0x99/0x14e
> [   13.170837]  [<c04d1cf7>] sys_read+0x50/0x87
> [   13.170837]  [<c0420086>] sysenter_do_call+0x12/0x21

Caused by CONFIG_HIGHPTE=y,

as long as TLB flushes are IPIs we really need to disable IRQs for
gup_fast() and thus will either need non-preemptible kmap or disabled
high-pte or disable the gup_fast() fast-path, which would be a shame.


