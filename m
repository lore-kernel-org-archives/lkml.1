Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbXJDHZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbXJDHZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 03:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXJDHY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 03:24:57 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:27916 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752297AbXJDHY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:24:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iSbnkcFXnhGupCO4v9VmFlISViBKLRMzjMuJf2yLNkhfrOflRDOWQCoCBJsIPGKLpZLDW92UEWbZqtlyMrJnfmfSYc0T9QNQ3cnjwsJScv9Y+9smghIB8Y+RgWE7YFB6O0jSpYKK3Qu/Ybm+W2pDrKVRwbj/x5OrTwP2iyzx5Uk=  ;
X-YMail-OSG: WWYm3vEVM1nMFOvQJZcs.EaPx0upLXW.dM3WDleInm2359Yc8fM0cTEgDwZBj_duLNdEKZ13zQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: gurudas pai <gurudas.pai@oracle.com>
Subject: Re: [BUG] kernel BUG at arch/i386/mm/highmem.c:15!  on 2.6.23-rc8/rc9
Date: Thu, 4 Oct 2007 00:53:19 +1000
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>
References: <47048A0C.4020608@oracle.com>
In-Reply-To: <47048A0C.4020608@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710040053.19570.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2007 16:37, gurudas pai wrote:
> Hi,
>
> While running Oracle database test on x86/6GB RAM machine panics with
> following messages.

Hi,

Hmm, seems like something in sys_remap_file_pages might have broken.
It's a bit hard to work out from the backtrace, though.

Is it possible you can strace to find the arguments for the remap_file_pages
that goes wrong?



>
>
> On 2.6.23-rc8:
>
> ------------[ cut here ]------------
> kernel BUG at arch/i386/mm/highmem.c:15!
>   invalid opcode: 0000 [#2]
>   [<c046dfaa>] SMP
>   do_filp_open+0x25/0x39
>   Modules linked in: netconsole autofs4 hidp nfs lockd nfs_acl rfcomm l2cap
>   bluetooth sunrpc ipv6 dm_mirror dm_mod video output sbs battery ac
> parport_pc
>   lp parport scb2_flash mtd chipreg sg floppy i2c_piix4 i2c_core tg3 e1000
>   button serio_raw ide_cd cdrom aic7xxx scsi_transport_spi sd_mod
> scsi_mod ext3
>   jbd ehci_hcd ohci_hcd uhci_hcd
>   CPU:    3
>   EIP:    0060:[<c041ed8d>]    Tainted: G      D VLI
>    [<c046e0f0>] EFLAGS: 00010206   (2.6.23-rc8 #1)
>   EIP is at kunmap+0x12/0x50
>   eax: efd94000   ebx: efd956fc   ecx: 00001000   edx: c3370680
>   filp_open+0x14/0x16
>   esi: 0069a000   edi: 0000ea00   ebp: 0000046c   esp: efd94d10
>   ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
>   Process oracle (pid: 8033, ti=efd94000 task=f2150880 task.ti=efd94000)
>    [<c0474050>] Stack: c0497708 00000001 00000000 00000001 efd94db4
> efd94db0 f047d680 0000000b
>          00000c20 00001c74 00000005 00000000 f015bbc0 ffffffff 00000005
>   f0c05dc0
>          f109b380 f0c056c0 f128ee40 f272a800 00000000 0000000c 00015000
>   00000008
>   Call Trace:
>   do_coredump+0x52a/0x60a
>    [<c0497708>] elf_core_dump+0xa5b/0xb1f
>    [<c04740d7>] do_coredump+0x5b1/0x60a
>    [<c0436600>] core_kernel_text+0x14/0x29
>    [<c041e12f>] fixup_exception+0xb/0x20
>    [<c0436600>]  [<c061d7c3>] do_page_fault+0x446/0x73b
>    [<c043666f>] search_exception_tables+0x14/0x25
>    [<c041e12f>] fixup_exception+0xb/0x20
>   core_kernel_text+0x14/0x29
>    [<c061d7c3>] do_page_fault+0x446/0x73b
>    [<c04229e3>] try_to_wake_up+0x2e2/0x2ec
>    [<c0422203>] task_rq_lock+0x31/0x58
>    [<c041e12f>]  [<c0430260>] __dequeue_signal+0xd7/0x11c
>    [<c0431e35>] get_signal_to_deliver+0x3f5/0x420
>    [<c0404563>] do_notify_resume+0x84/0x61e
>   fixup_exception+0xb/0x20
>    [<c061d37d>] do_page_fault+0x0/0x73b
>    [<c061db1d>] atomic_notifier_call_chain+0x17/0x1a
>    [<c061dab0>] do_page_fault+0x733/0x73b
>    [<c061d7c3>]  [<c044d685>] audit_syscall_exit+0x2aa/0x2c6
>    [<c045b9e4>] sys_remap_file_pages+0x320/0x32c
>    [<c061d37d>] do_page_fault+0x0/0x73b
>   do_page_fault+0x446/0x73b
>    [<c0404ea6>] work_notifysig+0x13/0x19
>    =======================
>   Code: 32 7a c0 8b 1d 9c 32 7a c0 89 0c 24 89 5c 24 04 e8 15 ff ff ff
> 5a 59 5b
>   c3 89 c2 89 e0 25 00 f0 ff ff f7 40 14 00 ff ff 0f 74 04 <0f> 0b eb fe
> 8b 02
>   c1 e8 1e 69 c0 80 12 00 00 05 80 ec 6c c0 2b
>   EIP: [<c041ed8d>] kunmap+0x12/0x50 SS:ESP 0068:efd94d10
>    [<c043666f>] search_exception_tables+0x14/0x25
>    [<c041e12f>] fixup_exception+0xb/0x20
>    [<c061d7c3>] do_page_fault+0x446/0x73b
>
>
>
>
> Tried same test on 2.6.23-rc9,
>
> BUG: scheduling while atomic: oracle/0xfffffffe/3797
>    [<c061a552>] <3>BUG: scheduling while atomic: oracle/0xfffffffe/3795
>    [<c061a552>] __sched_text_start+0x7a/0x6ee
>    [<c048a7c2>] __find_get_block_slow+0x110/0x11a
>    [<c04d7564>] __generic_unplug_device+0x14/0x1f
>    [<c04d8427>] generic_unplug_device+0x15/0x22
>    [<c043bae3>] getnstimeofday+0x30/0xbd
>    [<c061b116>] io_schedule+0x34/0x56
>    [<c048b1ba>] sync_buffer+0x0/0x33
>    [<c048b1ea>] sync_buffer+0x30/0x33
>    [<c061b222>] __wait_on_bit_lock+0x2a/0x52
>    [<c048b1ba>] sync_buffer+0x0/0x33
>    [<c061b2ad>] out_of_line_wait_on_bit_lock+0x63/0x6b
>    [<c0438106>] wake_bit_function+0x0/0x3c
>    [<c048b2fe>] __lock_buffer+0x29/0x2c
>    [<c048c232>] __bread+0x33/0x82
>    [<f888b1cf>] read_block_bitmap+0x2f/0x61 [ext3]
>    [<f888c0c9>] ext3_new_blocks+0x18c/0x5bc [ext3]
>    [<c05bc97f>] dev_hard_start_xmit+0x20a/0x26a
>    [<f888eff6>] ext3_get_blocks_handle+0x3b4/0x81a [ext3]
>    [<c046bc99>] cache_alloc_refill+0x158/0x44f
>    [<f888f761>] ext3_get_block+0xba/0xd0 [ext3]
>    [<c048b52d>] __block_prepare_write+0x199/0x44c
>    [<c04ddd30>] cfq_add_rq_rb+0x5c/0x6b
>    [<f8855f30>] journal_start+0xaf/0xdd [jbd]
>    [<c048b802>] block_prepare_write+0x22/0x30
>    [<f888f6a7>] ext3_get_block+0x0/0xd0 [ext3]
>    [<f8890a8b>] <3>BUG: scheduling while atomic: oracle/0xfffffffe/3799
>   ext3_prepare_write+0x96/0x151 [ext3]
>    [<c061a552>]  [<f888f6a7>] __sched_text_start+0x7a/0x6ee
>   ext3_get_block+0x0/0xd0 [ext3]
>    [<c048b385>]  [<c0453b22>] ll_rw_block+0x84/0x93
>   generic_file_buffered_write+0x256/0x5d5
>   [<c0477885>] __link_path_walk+0xade/0xbb2
>   [<c042bd97>]  [<c043821b>] current_fs_time+0x13/0x15
>   prepare_to_wait+0x24/0x3f
>    [<c0454332>]  [<f8855d91>] __generic_file_aio_write_nolock+0x491/0x4f0
>    [<c048ab04>] start_this_handle+0x22e/0x31e [jbd]
>   __find_get_block+0x141/0x14b
>    [<c0477a02>] link_path_walk+0xa9/0xb3
>    [<c048ab04>]  [<c04380d1>] __find_get_block+0x141/0x14b
>   autoremove_wake_function+0x0/0x35
>    [<c048ab3a>]  [<f8855f30>] __getblk+0x2c/0x288
>   journal_start+0xaf/0xdd [jbd]
>    [<c04543e6>] generic_file_aio_write+0x55/0xb3
>    [<c047d715>]  [<f8855b10>] d_rehash+0x1c/0x2b
>    [<f8893aa2>] do_get_write_access+0x435/0x462 [jbd]
>    [<f888cfdc>] ext3_create+0x41/0xdc [ext3]
>    [<c047616a>] ext3_file_write+0x24/0x8f [ext3]
>   vfs_create+0xca/0x134
>    [<c046f22d>]  [<c047886e>] open_namei+0x175/0x572
>   do_sync_write+0xc7/0x10a
>    [<c046dfee>] do_filp_open+0x25/0x39
>    [<c04380d1>] autoremove_wake_function+0x0/0x35
>    [<c046e134>]  [<f88556cf>] filp_open+0x14/0x16
>   journal_stop+0x1b6/0x1c2 [jbd]
>    [<c0474094>] do_coredump+0x52a/0x60a
>    [<c0495289>] dump_write+0x15/0x21
>    [<c0436600>]  [<c04973d0>] core_kernel_text+0xc/0x29
>   elf_core_dump+0x687/0xb1f
>    [<c041e12f>] fixup_exception+0xb/0x20
>    [<c0480638>]  [<c061d853>] inode_setattr+0x11e/0x128
>   do_page_fault+0x446/0x73b
>    [<c0436677>] search_exception_tables+0x14/0x25
>    [<c046e6d3>] do_truncate+0x6b/0x75
>    [<c041e12f>]  [<c047411b>] fixup_exception+0xb/0x20
>    [<c061d853>] do_coredump+0x5b1/0x60a
>   do_page_fault+0x446/0x73b
>    [<c04229e3>]  [<c0436600>] try_to_wake_up+0x2e2/0x2ec
>   core_kernel_text+0xc/0x29
>    [<c0422203>]  [<c041e12f>] task_rq_lock+0x31/0x58
>   fixup_exception+0xb/0x20
>    [<c0430260>] __dequeue_signal+0xd7/0x11c
>    [<c061d853>]  [<c0431e35>] do_page_fault+0x446/0x73b
>   get_signal_to_deliver+0x3f5/0x420
>    [<c0436677>] search_exception_tables+0x14/0x25
>    [<c041e12f>]  [<c0404563>] fixup_exception+0xb/0x20
>   do_notify_resume+0x84/0x61e
>    [<c061d853>] do_page_fault+0x446/0x73b
>    [<c04229e3>] try_to_wake_up+0x2e2/0x2ec
>    [<c061d40d>]  [<c0422203>] do_page_fault+0x0/0x73b
>   task_rq_lock+0x31/0x58
>    [<c061dbad>]  [<c0430260>] atomic_notifier_call_chain+0x17/0x1a
>   __dequeue_signal+0xd7/0x11c
>    [<c061db40>] do_page_fault+0x733/0x73b
>    [<c0431e35>] get_signal_to_deliver+0x3f5/0x420
>    [<c044d6c9>]  [<c0404563>] audit_syscall_exit+0x2aa/0x2c6
>   do_notify_resume+0x84/0x61e
>    [<c045ba28>] sys_remap_file_pages+0x320/0x32c
>    [<c061d40d>] do_page_fault+0x0/0x73b
>    [<c061dbad>]  [<c061d40d>] atomic_notifier_call_chain+0x17/0x1a
>   do_page_fault+0x0/0x73b
>    [<c0404ea6>]  [<c061db40>] work_notifysig+0x13/0x19
>   do_page_fault+0x733/0x73b
>    [<c044d6c9>]  =======================
>   audit_syscall_exit+0x2aa/0x2c6
>   BUG: scheduling while atomic: oracle/0xfffffffe/3799
>    [<c045ba28>]  [<c061a552>] sys_remap_file_pages+0x320/0x32c
>   __sched_text_start+0x7a/0x6ee
>    [<c048b385>] ll_rw_block+0x84/0x93
>    [<c061d40d>] do_page_fault+0x0/0x73b
>    [<c0477885>]  [<c0404ea6>] __link_path_walk+0xade/0xbb2
>   work_notifysig+0x13/0x19
>    [<c043821b>] prepare_to_wait+0x24/0x3f
>    =======================
>    [<f8855d91>] <3>BUG: scheduling while atomic: oracle/0xfffffffe/3795
>    [<c061a552>] start_this_handle+0x22e/0x31e [jbd]
>   __sched_text_start+0x7a/0x6ee
>    [<c0477a02>]  [<f886a898>] link_path_walk+0xa9/0xb3
>    [<c04380d1>] autoremove_wake_function+0x0/0x35
>   scsi_request_fn+0x2d3/0x31d [scsi_mod]
>    [<f8855f30>]  [<c04d756d>] __generic_unplug_device+0x1d/0x1f
>   journal_start+0xaf/0xdd [jbd]
>    [<c04d8427>]  [<c047d715>] generic_unplug_device+0x15/0x22
>    [<c043bae3>] getnstimeofday+0x30/0xbd
>   d_rehash+0x1c/0x2b
>    [<c061b116>] io_schedule+0x34/0x56
>    [<f8893aa2>]  [<c048b1ba>] sync_buffer+0x0/0x33
>    [<c048b1ea>] sync_buffer+0x30/0x33
>    [<c061b222>] ext3_create+0x41/0xdc [ext3]
>   __wait_on_bit_lock+0x2a/0x52
>    [<c048b1ba>] sync_buffer+0x0/0x33
>    [<c061b2ad>]  [<c047616a>] out_of_line_wait_on_bit_lock+0x63/0x6b
>   vfs_create+0xca/0x134
>    [<c0438106>]  [<c047886e>] wake_bit_function+0x0/0x3c
>   open_namei+0x175/0x572
>    [<c048b2fe>] __lock_buffer+0x29/0x2c
>    [<c046dfee>]  [<c048c232>] do_filp_open+0x25/0x39
>   __bread+0x33/0x82
>    [<f888b1cf>]  [<c046e134>] read_block_bitmap+0x2f/0x61 [ext3]
>   filp_open+0x14/0x16
>    [<c0474094>]  [<f888c0c9>] do_coredump+0x52a/0x60a
>   ext3_new_blocks+0x18c/0x5bc [ext3]
>   [<c05bc97f>] dev_hard_start_xmit+0x20a/0x26a
>    [<c0436600>] core_kernel_text+0xc/0x29
>    [<c041e12f>]  [<f888eff6>] fixup_exception+0xb/0x20
>    [<c061d853>] ext3_get_blocks_handle+0x3b4/0x81a [ext3]
>   do_page_fault+0x446/0x73b
>    [<c0436677>] search_exception_tables+0x14/0x25
>    [<c041e12f>] fixup_exception+0xb/0x20
>    [<c046bc99>]  [<c061d853>] do_page_fault+0x446/0x73b
>   cache_alloc_refill+0x158/0x44f
>    [<c04229e3>] try_to_wake_up+0x2e2/0x2ec
>    [<f888f761>]  [<c0422203>] task_rq_lock+0x31/0x58
>   ext3_get_block+0xba/0xd0 [ext3]
>    [<c0430260>] __dequeue_signal+0xd7/0x11c
>    [<c048b52d>] __block_prepare_write+0x199/0x44c
>    [<c0431e35>]  [<c04ddd30>] get_signal_to_deliver+0x3f5/0x420
>   cfq_add_rq_rb+0x5c/0x6b
>    [<f8855f30>]  [<c0404563>] journal_start+0xaf/0xdd [jbd]
>   do_notify_resume+0x84/0x61e
>    [<c048b802>] block_prepare_write+0x22/0x30
>    [<c061d40d>]  [<f888f6a7>] do_page_fault+0x0/0x73b
>    [<c061dbad>] atomic_notifier_call_chain+0x17/0x1a
>   ext3_get_block+0x0/0xd0 [ext3]
>    [<c061db40>]  [<f8890a8b>] do_page_fault+0x733/0x73b
>   ext3_prepare_write+0x96/0x151 [ext3]
>    [<c044d6c9>]  [<f888f6a7>] audit_syscall_exit+0x2aa/0x2c6
>    [<c045ba28>] sys_remap_file_pages+0x320/0x32c
>   ext3_get_block+0x0/0xd0 [ext3]
>    [<c061d40d>]  [<c0453b22>] do_page_fault+0x0/0x73b
>    [<c0404ea6>] generic_file_buffered_write+0x256/0x5d5
>   work_notifysig+0x13/0x19
>
