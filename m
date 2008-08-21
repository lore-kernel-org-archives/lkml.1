Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYHUV1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYHUV1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbYHUV1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:27:18 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:28733 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYHUV1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:27:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=jtbRyH8NsFzzIH3eGIXaLdJnlUthLD5OzOKl4VJ5+gjAVn23Io4B7h7t2p9rvMI66M
         jnuMGCVNxkYOPeOfwJrOTmn04CbjMVc2Ll5nt0hQ0ReVGPwLx76Ok/79gmFK9bGLQazs
         VVfL0SxY+ONF7FWON7zd5a0PS/Uzi4H1/2zPc=
Message-ID: <84144f020808211427j7e046f1dya07ecca18787dfbd@mail.gmail.com>
Date: Fri, 22 Aug 2008 00:27:09 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: suspend: unable to handle kernel paging request (was Re: no_console_suspend doesn't work?)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <19f34abd0808211121l25e6b187p93db789607c2af30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com>
	 <200808212010.06043.rjw@sisk.pl>
	 <19f34abd0808211121l25e6b187p93db789607c2af30@mail.gmail.com>
X-Google-Sender-Auth: f88de7f86661ff3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 9:21 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> I got a "proper" oops this time (brace yourself, it's long ;-)), and
> it does not have serial on the stack:
>
> BUG: unable to handle kernel paging request at 00100104
> IP: [<c038ad65>] __list_add+0x15/0x90
> *pdpt = 00000000325bb001 *pde = 0000000000000000
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 3597, comm: bash Not tainted (2.6.27-rc4-00003-ga798564-dirty #30)
> EIP: 0060:[<c038ad65>] EFLAGS: 00210082 CPU: 0
> EIP is at __list_add+0x15/0x90
> EAX: f7455764 EBX: 00100100 ECX: 00100100 EDX: f7455764
> ESI: f7455764 EDI: f7455764 EBP: f25e7c18 ESP: f25e7bf4
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process bash (pid: 3597, ti=f25e6000 task=f25aa700 task.ti=f25e6000)
> Stack: f68120bc f6c00400 c0687133 00000000 00000002 00000000 f7455734 f7455764
>       f7455764 f25e7c40 c018b954 0000001f 00000000 f6c00400 f6c00444 00000001
>       f68120bc f68120b0 00200002 f25e7cb4 c018d317 f68120bc 00000000 f25aac0c
> Call Trace:
>  [<c0687133>] ? _spin_lock+0x63/0x70

Corruption in the page allocator freelists.

>  [<c018b954>] ? rmqueue_bulk+0x54/0x80
>  [<c018d317>] ? get_page_from_freelist+0x5a7/0x720
>  [<c01600ea>] ? __lock_acquire+0x27a/0xa00
>  [<c018dd50>] ? __alloc_pages_internal+0xa0/0x450
>  [<c01acd4b>] ? alloc_pages_current+0x7b/0xc0
>  [<c01b37fb>] ? new_slab+0x1bb/0x2d0
>  [<c0687877>] ? _spin_unlock+0x27/0x50
>  [<c01b40ca>] ? __slab_alloc+0x32a/0x4e0
>  [<c010b335>] ? native_sched_clock+0xb5/0x110
>  [<c01b4424>] ? kmem_cache_alloc+0xb4/0xe0
>  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
>  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
>  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
>  [<c01897a1>] ? mempool_alloc+0x31/0xf0
>  [<c015e884>] ? trace_hardirqs_on_caller+0xd4/0x160
>  [<c015e91b>] ? trace_hardirqs_on+0xb/0x10
>  [<c0368c7e>] ? get_request+0xae/0x2c0
>  [<c036935c>] ? get_request_wait+0x1c/0xd0
>  [<c0687462>] ? _spin_lock_irq+0x72/0x80
>  [<c0369442>] ? blk_get_request+0x32/0x70
>  [<c0471c1c>] ? generic_ide_resume+0x5c/0xf0
>  [<c03f8bde>] ? device_resume+0x32e/0x380
>  [<c0168791>] ? hibernation_snapshot+0xa1/0x220
>  [<c013b55b>] ? printk+0x1b/0x20
>  [<c01689f0>] ? hibernate+0xe0/0x180
>  [<c01674a0>] ? state_store+0x0/0xd0
>  [<c016755f>] ? state_store+0xbf/0xd0
>  [<c01674a0>] ? state_store+0x0/0xd0
>  [<c0375ef4>] ? kobj_attr_store+0x24/0x30
>  [<c01fa432>] ? sysfs_write_file+0xa2/0x100
>  [<c01bbf06>] ? vfs_write+0x96/0x130
>  [<c01fa390>] ? sysfs_write_file+0x0/0x100
>  [<c01bc44d>] ? sys_write+0x3d/0x70
>  [<c0104f3b>] ? sysenter_do_call+0x12/0x3f
>  =======================
> Code: c0 e8 d0 f7 da ff 8b 13 eb 97 8d b6 00 00 00 00 8d bf 00 00 00
> 00 55 89 e5 83 ec 24 89 5d f4 89 cb 89 75 f8 89 d6 89 7d fc 89 c7 <8b>
> 41 04 39 d0 75 1d 8b 06 39 d8 75 41 89 7b 04 89 1f 8b 5d f4
> EIP: [<c038ad65>] __list_add+0x15/0x90 SS:ESP 0068:f25e7bf4
> ---[ end trace e3ed674f2f20c5d3 ]---
> note: bash[3597] exited with preempt_count 2
> Eeek! page_mapcount(page) went negative! (-1)
>  page pfn = 3e74f
>  page->flags = 210007c
>  page->count = 1
>  page->mapping = f6439028
>  vma->vm_ops = generic_file_vm_ops+0x0/0x20
>  vma->vm_ops->fault = filemap_fault+0x0/0x480
>  vma->vm_file->f_op->mmap = generic_file_mmap+0x0/0x50
> ------------[ cut here ]------------
> kernel BUG at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/mm/rmap.c:662!
> invalid opcode: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 3597, comm: bash Tainted: G      D   (2.6.27-rc4-00003-ga798564-dirty #30)
> EIP: 0060:[<c01a0f39>] EFLAGS: 00210286 CPU: 0
> EIP is at page_remove_rmap+0x109/0x120
> EAX: 0000003b EBX: f7aa5684 ECX: f25e6000 EDX: 00000005
> ESI: f25b94c8 EDI: 3e74f025 EBP: f25e7990 ESP: f25e7980
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process bash (pid: 3597, ti=f25e6000 task=f25aa700 task.ti=f25e6000)
> Stack: c077ed7c f6439028 00000000 00000025 f25e7a38 c0198721 3e74f025 00000000
>       f25e79c0 c015c5ea 00000025 00000000 325a3067 00000000 00000000 f25b94c8
>       f25e7a50 00000000 00000000 3e74f025 00000000 00007000 0097a000 00000000
> Call Trace:

No idea what happened here but it looks bad :-)

>  [<c0198721>] ? unmap_vmas+0x4b1/0x8b0
>  [<c015c5ea>] ? print_lock_contention_bug+0x1a/0xe0
>  [<c019d504>] ? exit_mmap+0x84/0x120
>  [<c0138538>] ? mmput+0x48/0xa0
>  [<c013c3d7>] ? exit_mm+0xe7/0x110
>  [<c013d7a4>] ? do_exit+0x184/0x890
>  [<c013b55b>] ? printk+0x1b/0x20
>  [<c013a50a>] ? print_oops_end_marker+0x2a/0x30
>  [<c01060f1>] ? oops_end+0xb1/0xc0
>  [<c01067c0>] ? die+0x50/0x70
>  [<c0122b4f>] ? do_page_fault+0x1ef/0xa20
>  [<c010b335>] ? native_sched_clock+0xb5/0x110
>  [<c01600ea>] ? __lock_acquire+0x27a/0xa00
>  [<c0122960>] ? do_page_fault+0x0/0xa20
>  [<c0687d3a>] ? error_code+0x72/0x78
>  [<c038ad65>] ? __list_add+0x15/0x90
>  [<c0687133>] ? _spin_lock+0x63/0x70
>  [<c018b954>] ? rmqueue_bulk+0x54/0x80
>  [<c018d317>] ? get_page_from_freelist+0x5a7/0x720
>  [<c01600ea>] ? __lock_acquire+0x27a/0xa00
>  [<c018dd50>] ? __alloc_pages_internal+0xa0/0x450
>  [<c01acd4b>] ? alloc_pages_current+0x7b/0xc0
>  [<c01b37fb>] ? new_slab+0x1bb/0x2d0
>  [<c0687877>] ? _spin_unlock+0x27/0x50
>  [<c01b40ca>] ? __slab_alloc+0x32a/0x4e0
>  [<c010b335>] ? native_sched_clock+0xb5/0x110
>  [<c01b4424>] ? kmem_cache_alloc+0xb4/0xe0
>  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
>  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
>  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
>  [<c01897a1>] ? mempool_alloc+0x31/0xf0
>  [<c015e884>] ? trace_hardirqs_on_caller+0xd4/0x160
>  [<c015e91b>] ? trace_hardirqs_on+0xb/0x10
>  [<c0368c7e>] ? get_request+0xae/0x2c0
>  [<c036935c>] ? get_request_wait+0x1c/0xd0
>  [<c0687462>] ? _spin_lock_irq+0x72/0x80
>  [<c0369442>] ? blk_get_request+0x32/0x70
>  [<c0471c1c>] ? generic_ide_resume+0x5c/0xf0
>  [<c03f8bde>] ? device_resume+0x32e/0x380
>  [<c0168791>] ? hibernation_snapshot+0xa1/0x220
>  [<c013b55b>] ? printk+0x1b/0x20
>  [<c01689f0>] ? hibernate+0xe0/0x180
>  [<c01674a0>] ? state_store+0x0/0xd0
>  [<c016755f>] ? state_store+0xbf/0xd0
>  [<c01674a0>] ? state_store+0x0/0xd0
>  [<c0375ef4>] ? kobj_attr_store+0x24/0x30
>  [<c01fa432>] ? sysfs_write_file+0xa2/0x100
>  [<c01bbf06>] ? vfs_write+0x96/0x130
>  [<c01fa390>] ? sysfs_write_file+0x0/0x100
>  [<c01bc44d>] ? sys_write+0x3d/0x70
>  [<c0104f3b>] ? sysenter_do_call+0x12/0x3f
>  =======================
> Code: c0 74 0d 8b 50 08 b8 ac ed 77 c0 e8 82 60 fc ff 8b 46 4c 85 c0
> 74 14 8b 40 10 85 c0 74 0d 8b 50 2c b8 d8 d1 77 c0 e8 67 60 fc ff <0f>
> 0b eb fe 8b 53 0c eb 95 8d b4 26 00 00 00 00 8d bc 27 00 00
> EIP: [<c01a0f39>] page_remove_rmap+0x109/0x120 SS:ESP 0068:f25e7980
> ---[ end trace e3ed674f2f20c5d3 ]---
> Fixing recursive fault but reboot is needed!
> =============================================================================
> BUG blkdev_ioc: Invalid object pointer 0xf5cdaca8
> -----------------------------------------------------------------------------

Ok, here we have the block layer passing a bad pointer to SLUB this
time. And it's also from the suspend code (although it's the resume
path this time). As we never see an oops from the block layer first,
it's possible that someone else corrupted everything and it just shows
up in the block layer. Maybe something worth investigating, though.

> INFO: Slab 0xf789e318 objects=14 used=14 fp=0x00000000 flags=0x2082083
> Pid: 3597, comm: bash Tainted: G      D   2.6.27-rc4-00003-ga798564-dirty #30
>  [<c01b2576>] slab_err+0x46/0x50
>  [<c01b2766>] ? check_slab+0xd6/0xf0
>  [<c0181aef>] ? call_rcu+0x6f/0x80
>  [<c015e91b>] ? trace_hardirqs_on+0xb/0x10
>  [<c01b3c78>] __slab_free+0x238/0x360
>  [<c01b4749>] kmem_cache_free+0xa9/0x120
>  [<c036b773>] ? put_io_context+0x53/0x70
>  [<c036b773>] ? put_io_context+0x53/0x70
>  [<c036b773>] put_io_context+0x53/0x70
>  [<c036b82e>] exit_io_context+0x6e/0x80
>  [<c013de6e>] do_exit+0x84e/0x890
>  [<c037b794>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c013b55b>] ? printk+0x1b/0x20
>  [<c013a50a>] ? print_oops_end_marker+0x2a/0x30
>  [<c01060f1>] oops_end+0xb1/0xc0
>  [<c01067c0>] die+0x50/0x70
>  [<c0106871>] do_trap+0x91/0xc0
>  [<c0106940>] ? do_invalid_op+0x0/0xa0
>  [<c01069c8>] do_invalid_op+0x88/0xa0
>  [<c01a0f39>] ? page_remove_rmap+0x109/0x120
>  [<c013b2d1>] ? vprintk+0x151/0x3c0
>  [<c013b45b>] ? vprintk+0x2db/0x3c0
>  [<c015c5ea>] ? print_lock_contention_bug+0x1a/0xe0
>  [<c015c5ea>] ? print_lock_contention_bug+0x1a/0xe0
>  [<c0687d3a>] error_code+0x72/0x78
>  [<c013007b>] ? sched_rt_period_timer+0x21b/0x270
>  [<c01a0f39>] ? page_remove_rmap+0x109/0x120
>  [<c0198721>] unmap_vmas+0x4b1/0x8b0
>  [<c015c5ea>] ? print_lock_contention_bug+0x1a/0xe0
>  [<c019d504>] exit_mmap+0x84/0x120
>  [<c0138538>] mmput+0x48/0xa0
>  [<c013c3d7>] exit_mm+0xe7/0x110
>  [<c013d7a4>] do_exit+0x184/0x890
>  [<c013b55b>] ? printk+0x1b/0x20
>  [<c013a50a>] ? print_oops_end_marker+0x2a/0x30
>  [<c01060f1>] oops_end+0xb1/0xc0
>  [<c01067c0>] die+0x50/0x70
>  [<c0122b4f>] do_page_fault+0x1ef/0xa20
>  [<c010b335>] ? native_sched_clock+0xb5/0x110
>  [<c01600ea>] ? __lock_acquire+0x27a/0xa00
>  [<c0122960>] ? do_page_fault+0x0/0xa20
>  [<c0687d3a>] error_code+0x72/0x78
>  [<c038ad65>] ? __list_add+0x15/0x90
>  [<c0687133>] ? _spin_lock+0x63/0x70
>  [<c018b954>] rmqueue_bulk+0x54/0x80
>  [<c018d317>] get_page_from_freelist+0x5a7/0x720
>  [<c01600ea>] ? __lock_acquire+0x27a/0xa00
>  [<c018dd50>] __alloc_pages_internal+0xa0/0x450
>  [<c01acd4b>] alloc_pages_current+0x7b/0xc0
>  [<c01b37fb>] new_slab+0x1bb/0x2d0
>  [<c0687877>] ? _spin_unlock+0x27/0x50
>  [<c01b40ca>] __slab_alloc+0x32a/0x4e0
>  [<c010b335>] ? native_sched_clock+0xb5/0x110
>  [<c01b4424>] kmem_cache_alloc+0xb4/0xe0
>  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
>  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
>  [<c018969e>] mempool_alloc_slab+0xe/0x10
>  [<c01897a1>] mempool_alloc+0x31/0xf0
>  [<c015e884>] ? trace_hardirqs_on_caller+0xd4/0x160
>  [<c015e91b>] ? trace_hardirqs_on+0xb/0x10
>  [<c0368c7e>] get_request+0xae/0x2c0
>  [<c036935c>] get_request_wait+0x1c/0xd0
>  [<c0687462>] ? _spin_lock_irq+0x72/0x80
>  [<c0369442>] blk_get_request+0x32/0x70
>  [<c0471c1c>] generic_ide_resume+0x5c/0xf0
>  [<c03f8bde>] device_resume+0x32e/0x380
>  [<c0168791>] hibernation_snapshot+0xa1/0x220
>  [<c013b55b>] ? printk+0x1b/0x20
>  [<c01689f0>] hibernate+0xe0/0x180
>  [<c01674a0>] ? state_store+0x0/0xd0
>  [<c016755f>] state_store+0xbf/0xd0
>  [<c01674a0>] ? state_store+0x0/0xd0
>  [<c0375ef4>] kobj_attr_store+0x24/0x30
>  [<c01fa432>] sysfs_write_file+0xa2/0x100
>  [<c01bbf06>] vfs_write+0x96/0x130
>  [<c01fa390>] ? sysfs_write_file+0x0/0x100
>  [<c01bc44d>] sys_write+0x3d/0x70
>  [<c0104f3b>] sysenter_do_call+0x12/0x3f
>  =======================
> FIX blkdev_ioc: Object at 0xf5cdaca8 not freed
> BUG: scheduling while atomic: bash/3597/0x00000006
> INFO: lockdep is turned off.
> Pid: 3597, comm: bash Tainted: G      D   2.6.27-rc4-00003-ga798564-dirty #30
>  [<c0135467>] __schedule_bug+0x77/0x80
>  [<c0684ce2>] schedule+0x852/0x8f0
>  [<c010509e>] ? restore_nocheck_notrace+0x0/0xe
>  [<c01b4779>] ? kmem_cache_free+0xd9/0x120
>  [<c036b773>] ? put_io_context+0x53/0x70
>  [<c036b773>] ? put_io_context+0x53/0x70
>  [<c013de81>] do_exit+0x861/0x890
>  [<c037b794>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c013b55b>] ? printk+0x1b/0x20
>  [<c013a50a>] ? print_oops_end_marker+0x2a/0x30
>  [<c01060f1>] oops_end+0xb1/0xc0
>  [<c01067c0>] die+0x50/0x70
>  [<c0106871>] do_trap+0x91/0xc0
>  [<c0106940>] ? do_invalid_op+0x0/0xa0
>  [<c01069c8>] do_invalid_op+0x88/0xa0
>  [<c01a0f39>] ? page_remove_rmap+0x109/0x120
>  [<c013b2d1>] ? vprintk+0x151/0x3c0
>  [<c013b45b>] ? vprintk+0x2db/0x3c0
>  [<c015c5ea>] ? print_lock_contention_bug+0x1a/0xe0
>  [<c015c5ea>] ? print_lock_contention_bug+0x1a/0xe0
>  [<c0687d3a>] error_code+0x72/0x78
>  [<c013007b>] ? sched_rt_period_timer+0x21b/0x270
>  [<c01a0f39>] ? page_remove_rmap+0x109/0x120
>  [<c0198721>] unmap_vmas+0x4b1/0x8b0
>  [<c015c5ea>] ? print_lock_contention_bug+0x1a/0xe0
>  [<c019d504>] exit_mmap+0x84/0x120
>  [<c0138538>] mmput+0x48/0xa0
>  [<c013c3d7>] exit_mm+0xe7/0x110
>  [<c013d7a4>] do_exit+0x184/0x890
>  [<c013b55b>] ? printk+0x1b/0x20
>  [<c013a50a>] ? print_oops_end_marker+0x2a/0x30
>  [<c01060f1>] oops_end+0xb1/0xc0
>  [<c01067c0>] die+0x50/0x70
>  [<c0122b4f>] do_page_fault+0x1ef/0xa20
>  [<c010b335>] ? native_sched_clock+0xb5/0x110
>  [<c01600ea>] ? __lock_acquire+0x27a/0xa00
>  [<c0122960>] ? do_page_fault+0x0/0xa20
>  [<c0687d3a>] error_code+0x72/0x78
>  [<c038ad65>] ? __list_add+0x15/0x90
>  [<c0687133>] ? _spin_lock+0x63/0x70
>  [<c018b954>] rmqueue_bulk+0x54/0x80
>  [<c018d317>] get_page_from_freelist+0x5a7/0x720
>  [<c01600ea>] ? __lock_acquire+0x27a/0xa00
>  [<c018dd50>] __alloc_pages_internal+0xa0/0x450
>  [<c01acd4b>] alloc_pages_current+0x7b/0xc0
>  [<c01b37fb>] new_slab+0x1bb/0x2d0
>  [<c0687877>] ? _spin_unlock+0x27/0x50
>  [<c01b40ca>] __slab_alloc+0x32a/0x4e0
>  [<c010b335>] ? native_sched_clock+0xb5/0x110
>  [<c01b4424>] kmem_cache_alloc+0xb4/0xe0
>  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
>  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
>  [<c018969e>] mempool_alloc_slab+0xe/0x10
>  [<c01897a1>] mempool_alloc+0x31/0xf0
>  [<c015e884>] ? trace_hardirqs_on_caller+0xd4/0x160
>  [<c015e91b>] ? trace_hardirqs_on+0xb/0x10
>  [<c0368c7e>] get_request+0xae/0x2c0
>  [<c036935c>] get_request_wait+0x1c/0xd0
>  [<c0687462>] ? _spin_lock_irq+0x72/0x80
>  [<c0369442>] blk_get_request+0x32/0x70
>  [<c0471c1c>] generic_ide_resume+0x5c/0xf0
>  [<c03f8bde>] device_resume+0x32e/0x380
>  [<c0168791>] hibernation_snapshot+0xa1/0x220
>  [<c013b55b>] ? printk+0x1b/0x20
>  [<c01689f0>] hibernate+0xe0/0x180
>  [<c01674a0>] ? state_store+0x0/0xd0
>  [<c016755f>] state_store+0xbf/0xd0
>  [<c01674a0>] ? state_store+0x0/0xd0
>  [<c0375ef4>] kobj_attr_store+0x24/0x30
>  [<c01fa432>] sysfs_write_file+0xa2/0x100
>
> I can look up addresses in the vmlinux for accurate line numbers if needed.
>
>
> Vegard
>
> --
> "The animistic metaphor of the bug that maliciously sneaked in while
> the programmer was not looking is intellectually dishonest as it
> disguises that the error is the programmer's own creation."
>        -- E. W. Dijkstra, EWD1036
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
