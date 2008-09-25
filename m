Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYIYKxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYIYKxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYIYKxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:53:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:23558 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYIYKxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DS7/uIJt9wWfq4jUEgdFRvP/sdMR353Vn7b/Pl2KGWhGSRxYkUFaQdOAoM43AJszuy
         r7EgNOYTx/txDFpORyQ4ZNvQ+RrTqM0vdo8wOD0oazYAaRwA/M4SiiwfAk4bZw/YMqY+
         xdZeiaN0OHxBj9YoAe/tEibLhgzrzFBh4KMi8=
Date: Thu, 25 Sep 2008 14:53:37 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: lockdep warning inside ide/bio
Message-ID: <20080925105337.GA9173@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this when running the tree based on commit
c0f4d6d4b14a75a341d972ff73fb9740e1ceb634. It's arm (tosa)
emulated in qemu.

------------[ cut here ]------------
WARNING: at /home/lumag/tosa-tree/kernel/lockdep.c:2195 trace_hardirqs_on_caller+0xf0/0x170()
Modules linked in:
[<c0029fe4>] (dump_stack+0x0/0x14) from [<c003fc40>] (warn_on_slowpath+0x4c/0x84)
[<c003fbf4>] (warn_on_slowpath+0x0/0x84) from [<c00629ac>] (trace_hardirqs_on_caller+0xf0/0x170)
 r6:c0062a40 r5:00000001 r4:c381b080
[<c00628bc>] (trace_hardirqs_on_caller+0x0/0x170) from [<c0062a40>] (trace_hardirqs_on+0x14/0x18)
 r6:00000092 r5:00000000 r4:c3412b30
[<c0062a2c>] (trace_hardirqs_on+0x0/0x18) from [<c03172b0>] (_spin_unlock_irq+0x30/0x60)
[<c0317280>] (_spin_unlock_irq+0x0/0x60) from [<c002c3f4>] (__flush_dcache_aliases+0xec/0xf8)
 r4:c3412b50
[<c002c308>] (__flush_dcache_aliases+0x0/0xf8) from [<c002c474>] (flush_dcache_page+0x74/0x9c)
[<c002c400>] (flush_dcache_page+0x0/0x9c) from [<c008f958>] (copy_to_high_bio_irq+0x64/0xb0)
 r5:c386d668 r4:c3a2b000
[<c008f8f4>] (copy_to_high_bio_irq+0x0/0xb0) from [<c008fe54>] (__bounce_end_io_read+0x34/0x48)
[<c008fe20>] (__bounce_end_io_read+0x0/0x48) from [<c008fe84>] (bounce_end_io_read_isa+0x1c/0x24)
 r6:c39b9658 r5:00000000 r4:c387f448
[<c008fe68>] (bounce_end_io_read_isa+0x0/0x24) from [<c00c7624>] (bio_endio+0x54/0x58)
[<c00c75d0>] (bio_endio+0x0/0x58) from [<c012cbf4>] (req_bio_endio+0xac/0xd0)
[<c012cb48>] (req_bio_endio+0x0/0xd0) from [<c012cdb8>] (__end_that_request_first+0x1a0/0x2f0)
 r5:00011400 r4:c387f448
[<c012cc18>] (__end_that_request_first+0x0/0x2f0) from [<c012d60c>] (__blk_end_request+0x28/0x54)
[<c012d5e4>] (__blk_end_request+0x0/0x54) from [<c01bd024>] (__ide_end_request+0x94/0xc4)
 r5:c39ca0c0 r4:c39ca0c0
[<c01bcf90>] (__ide_end_request+0x0/0xc4) from [<c01bd140>] (ide_end_request+0x68/0x88)
 r4:00011400
[<c01bd0d8>] (ide_end_request+0x0/0x88) from [<c01c2da4>] (task_end_request+0x5c/0x70)
 r7:00000000 r6:c39b9658 r5:00000050 r4:c39ca0c0
[<c01c2d48>] (task_end_request+0x0/0x70) from [<c01c33a4>] (task_in_intr+0xa4/0xd4)
 r5:00000000 r4:c39ca0c0
[<c01c3300>] (task_in_intr+0x0/0xd4) from [<c01bdda0>] (ide_intr+0x10c/0x184)
 r7:40000193 r6:c39ca0c0 r5:c3987938 r4:00000055
[<c01bdc94>] (ide_intr+0x0/0x184) from [<c00717c4>] (handle_IRQ_event+0x2c/0x70)
[<c0071798>] (handle_IRQ_event+0x0/0x70) from [<c0072db0>] (handle_edge_irq+0xf8/0x180)
 r7:c0421314 r6:c3a328a0 r5:00000055 r4:c04212e4
[<c0072cb8>] (handle_edge_irq+0x0/0x180) from [<c0032984>] (pxa_gpio_demux_handler+0x94/0xe0)
 r8:c381d958 r7:c04400b0 r6:f2e00000 r5:00000fe0 r4:00000015
[<c00328f0>] (pxa_gpio_demux_handler+0x0/0xe0) from [<c0025048>] (__exception_text_start+0x48/0x64)
[<c0025000>] (__exception_text_start+0x0/0x64) from [<c0025828>] (__irq_svc+0x48/0xf0)
Exception stack(0xc381d9b8 to 0xc381da00)
d9a0:                                                       00000001 c381b3d0 
d9c0: 00000001 20000113 c042da70 c381da9c c08690d4 c381daa4 00000002 00000004 
d9e0: c00756d0 c381da14 c381d9b0 c381da00 c00627e0 c03172bc 20000113 ffffffff 
 r6:00000400 r5:f2d00000 r4:ffffffff
[<c0317280>] (_spin_unlock_irq+0x0/0x60) from [<c012e5fc>] (generic_unplug_device+0x38/0x3c)
 r4:c3a30a80
[<c012e5c4>] (generic_unplug_device+0x0/0x3c) from [<c012c56c>] (blk_unplug+0x1c/0x20)
 r4:c381da9c
[<c012c550>] (blk_unplug+0x0/0x20) from [<c012c584>] (blk_backing_dev_unplug+0x14/0x18)
[<c012c570>] (blk_backing_dev_unplug+0x0/0x18) from [<c00c2290>] (block_sync_page+0x50/0x58)
[<c00c2240>] (block_sync_page+0x0/0x58) from [<c007571c>] (sync_page+0x4c/0x5c)
[<c00756d0>] (sync_page+0x0/0x5c) from [<c0315170>] (__wait_on_bit_lock+0x60/0x94)
[<c0315110>] (__wait_on_bit_lock+0x0/0x94) from [<c00756a8>] (__lock_page+0x68/0x78)
[<c0075640>] (__lock_page+0x0/0x78) from [<c0075904>] (find_lock_page+0x64/0x94)
 r6:000000a2 r5:c3412b20 r4:c07fa480
[<c00758a0>] (find_lock_page+0x0/0x94) from [<c00781e4>] (filemap_fault+0x1cc/0x39c)
 r6:c3412b20 r5:00000000 r4:00000000
[<c0078018>] (filemap_fault+0x0/0x39c) from [<c0084df4>] (__do_fault+0x54/0x428)
[<c0084da0>] (__do_fault+0x0/0x428) from [<c0085214>] (do_linear_fault+0x4c/0x54)
[<c00851c8>] (do_linear_fault+0x0/0x54) from [<c0086414>] (handle_mm_fault+0x118/0x310)
[<c00862fc>] (handle_mm_fault+0x0/0x310) from [<c002b840>] (__do_page_fault+0x78/0x108)
[<c002b7c8>] (__do_page_fault+0x0/0x108) from [<c002ba98>] (do_page_fault+0xa4/0x164)
[<c002b9f4>] (do_page_fault+0x0/0x164) from [<c002bbf4>] (do_translation_fault+0x18/0x80)
[<c002bbdc>] (do_translation_fault+0x0/0x80) from [<c00251bc>] (do_DataAbort+0x3c/0xa0)
 r5:c0412620 r4:ffffffff
[<c0025180>] (do_DataAbort+0x0/0xa0) from [<c00257cc>] (__dabt_svc+0x4c/0x60)
Exception stack(0xc381dd30 to 0xc381dd78)
dd20:                                     000b2e28 000001d0 00000000 00000000 
dd40: 000b2e28 000c38cc c3a2cc50 00000000 c39e9d08 00000000 c3a2cc88 c381dd8c 
dd60: 00000000 c381dd78 c00d1700 c0134788 20000013 ffffffff                   
 r8:c39e9d08 r7:00000000 r6:c3a2cc50 r5:c381dd64 r4:ffffffff
[<c00d16bc>] (padzero+0x0/0x5c) from [<c00d2bb8>] (load_elf_binary+0x974/0xce0)
[<c00d2244>] (load_elf_binary+0x0/0xce0) from [<c00a2420>] (search_binary_handler+0xf8/0x2ac)
[<c00a2328>] (search_binary_handler+0x0/0x2ac) from [<c00d158c>] (load_script+0x204/0x218)
[<c00d1388>] (load_script+0x0/0x218) from [<c00a2420>] (search_binary_handler+0xf8/0x2ac)
 r6:c3a2cc88 r5:c04256a4 r4:00000000
[<c00a2328>] (search_binary_handler+0x0/0x2ac) from [<c00a3654>] (do_execve+0x138/0x1d0)
[<c00a351c>] (do_execve+0x0/0x1d0) from [<c0029094>] (kernel_execve+0x40/0x88)
[<c0029054>] (kernel_execve+0x0/0x88) from [<c00253c0>] (run_init_process+0x20/0x2c)
 r7:00000000 r6:00000000 r5:00000000 r4:c043fd14
[<c00253a0>] (run_init_process+0x0/0x2c) from [<c0025470>] (init_post+0xa4/0x108)
[<c00253cc>] (init_post+0x0/0x108) from [<c0008a88>] (kernel_init+0x78/0x90)
 r4:c043fd18
[<c0008a10>] (kernel_init+0x0/0x90) from [<c0043520>] (do_exit+0x0/0x2dc)
 r4:00000000
---[ end trace 574432789d45c513 ]---

-- 
With best wishes
Dmitry

