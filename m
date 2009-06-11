Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbZFKM6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbZFKM6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZFKM6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:58:33 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:32999 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZFKM6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=QZq5oMD7KoxDnB6N6qfcHePrRi7qAOsuJuazkdkv8UryHHPjvUP4PZPHgsXvycODab
         Y8pB3WG4GpKUwMQ/jXPaDebT8R43DOUrqGYzm34tD15zm6LYgBoiDz7+90mb+Jt42yBy
         SSRlmoajuHykbKG1lPWa7SEpcINlIMUM71fTk=
MIME-Version: 1.0
Date: Thu, 11 Jun 2009 16:58:32 +0400
Message-ID: <a4423d670906110558m522868cdg368ae79bcb4167a9@mail.gmail.com>
Subject: next-20090611: BUG: MAX_STACK_TRACE_ENTRIES too low (scsi, dma)
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-next <linux-next@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

BUG: MAX_STACK_TRACE_ENTRIES too low!
turning off the locking correctness validator.
Pid: 321, comm: kswapd0 Not tainted 2.6.30-next-20090611-07944-gc1b019d #2
Call Trace:
 <IRQ>  [<ffffffff8107efa2>] save_trace+0xc2/0xe0
 [<ffffffff810814e0>] mark_lock+0x150/0x440
 [<ffffffff812edf00>] ? add_dma_entry+0x50/0xa0
 [<ffffffff81082a44>] __lock_acquire+0x3f4/0x1250
 [<ffffffff810681c8>] ? __kernel_text_address+0x78/0xa0
 [<ffffffff81011041>] ? print_context_stack+0xa1/0x110
 [<ffffffff812edf00>] ? add_dma_entry+0x50/0xa0
 [<ffffffff81083940>] lock_acquire+0xa0/0xe0
 [<ffffffff812edf00>] ? add_dma_entry+0x50/0xa0
 [<ffffffff814e374d>] _spin_lock_irqsave+0x5d/0xb0
 [<ffffffff812edf00>] ? add_dma_entry+0x50/0xa0
 [<ffffffff8107e1f0>] ? trace_hardirqs_off+0x20/0x40
 [<ffffffff812edf00>] add_dma_entry+0x50/0xa0
 [<ffffffff812ef570>] debug_dma_map_sg+0x1a0/0x220
 [<ffffffff8139230a>] scsi_dma_map+0xea/0x140
 [<ffffffff81388000>] ? scsi_done+0x0/0x40
 [<ffffffff8139b3fa>] megasas_make_sgl64+0x2a/0x90
 [<ffffffff8139b652>] megasas_queue_command+0x1f2/0x540
 [<ffffffff814e3779>] ? _spin_lock_irqsave+0x89/0xb0
 [<ffffffff81388330>] scsi_dispatch_cmd+0x190/0x2f0
 [<ffffffff8138ff55>] scsi_request_fn+0x435/0x580
 [<ffffffff812c087e>] ? blk_run_queue+0x2e/0x70
 [<ffffffff812c06a6>] __blk_run_queue+0xa6/0x190
 [<ffffffff812c0889>] blk_run_queue+0x39/0x70
 [<ffffffff8138ef9d>] scsi_run_queue+0xed/0x3d0
 [<ffffffff813903ac>] scsi_next_command+0x4c/0x80
 [<ffffffff81391292>] scsi_io_completion+0x362/0x530
 [<ffffffff81387f80>] scsi_finish_command+0xd0/0x150
 [<ffffffff81391625>] scsi_softirq_done+0x185/0x1b0
 [<ffffffff812c6015>] blk_done_softirq+0x95/0xc0
 [<ffffffff81054c1c>] __do_softirq+0x9c/0x150
 [<ffffffff814e3dcf>] ? _spin_unlock+0x3f/0x80
 [<ffffffff8100cb3c>] call_softirq+0x1c/0x30
 [<ffffffff8100f22d>] do_softirq+0x8d/0xe0
 [<ffffffff810548c5>] irq_exit+0xc5/0xe0
 [<ffffffff8100e6a3>] do_IRQ+0x83/0x110
 [<ffffffff810c69fe>] ? page_referenced_one+0x8e/0x130
 [<ffffffff8100c353>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff81083cff>] ? lock_release+0x8f/0x250
 [<ffffffff810383ad>] ? flush_tlb_page+0x6d/0x100
 [<ffffffff814e3dbd>] ? _spin_unlock+0x2d/0x80
 [<ffffffff810c69fe>] ? page_referenced_one+0x8e/0x130
 [<ffffffff810c6e59>] ? page_referenced_file+0xa9/0x100
 [<ffffffff814e41ca>] ? _spin_unlock_irq+0x3a/0x90
 [<ffffffff810c7d52>] ? page_referenced+0x82/0x180
 [<ffffffff810b002e>] ? shrink_active_list+0x13e/0x480
 [<ffffffff810b14ee>] ? shrink_zone+0x8de/0xaa0
 [<ffffffff810b0f7f>] ? shrink_zone+0x36f/0xaa0
 [<ffffffff810afae6>] ? shrink_slab+0x186/0x1e0
 [<ffffffff810b1df9>] ? kswapd+0x749/0x790
 [<ffffffff810aec50>] ? isolate_pages_global+0x0/0x290
 [<ffffffff8106b4f0>] ? autoremove_wake_function+0x0/0x60
 [<ffffffff814e4275>] ? _spin_unlock_irqrestore+0x55/0xb0
 [<ffffffff8100c400>] ? restore_args+0x0/0x30
 [<ffffffff810b16b0>] ? kswapd+0x0/0x790
 [<ffffffff8106b009>] ? kthread+0x69/0xc0
 [<ffffffff8100ca3a>] ? child_rip+0xa/0x20
 [<ffffffff8100c400>] ? restore_args+0x0/0x30
 [<ffffffff8106afa0>] ? kthread+0x0/0xc0
 [<ffffffff8100ca30>] ? child_rip+0x0/0x20
