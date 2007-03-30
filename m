Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbXC3NT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbXC3NT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXC3NT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:19:26 -0400
Received: from calisto.ae.poznan.pl ([150.254.37.3]:49573 "EHLO
	calisto.ae.poznan.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbXC3NTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:19:25 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Mar 2007 09:19:24 EDT
Message-ID: <460D0D3C.1010204@dns.toxicfilms.tv>
Date: Fri, 30 Mar 2007 15:14:36 +0200
From: Maciej Soltysiak <solt2@dns.toxicfilms.tv>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.20.3-cks1 ext3 oops
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was doing large FTP transfers to an ext3 partition on a 2.6.20.3-cks1 
machine and it spat on me.
Here it is, hope you guys can read important stuff from it:

BUG: at fs/buffer.c:1639 __block_write_full_page()
[<c01757b0>] __block_write_full_page+0x320/0x330
[<c01b9450>] ext3_get_block+0x0/0x100
[<c0175ab6>] block_write_full_page+0xf6/0x100
[<c01b9450>] ext3_get_block+0x0/0x100
[<c01bb15d>] ext3_journalled_writepage+0x14d/0x160
[<c013f33e>] generic_writepages+0x1ee/0x320
[<c01bb010>] ext3_journalled_writepage+0x0/0x160
[<c013f4b9>] do_writepages+0x49/0x50
[<c01704fa>] __writeback_single_inode+0x8a/0x370
[<c017052e>] __writeback_single_inode+0xbe/0x370
[<c030d642>] schedule_timeout+0x52/0xd0
[<c0170b41>] sync_sb_inodes+0x161/0x210
[<c0170f52>] writeback_inodes+0x72/0x90
[<c013f83c>] background_writeout+0x7c/0xa0
[<c013fcd0>] pdflush+0x0/0x180
[<c013fda5>] pdflush+0xd5/0x180
[<c013f7c0>] background_writeout+0x0/0xa0
[<c012b329>] kthread+0xa9/0xe0
[<c012b280>] kthread+0x0/0xe0
[<c0103a97>] kernel_thread_helper+0x7/0x10
=======================
c0175556

Modules linked in: binfmt_misc sit nfs lockd nfs_acl sunrpc ipt_ECN
iptable_mangle w83627ehf i2c_isa i2c_viapro i2c_core via_agp agpgart rtc

<0>Assertion failure in journal_start() at fs/jbd/transaction.c:273: 
"handle->h_transaction->t_journal == journal"

Modules linked in: binfmt_misc sit nfs lockd nfs_acl sunrpc ipt_ECN
iptable_mangle w83627ehf i2c_isa i2c_viapro i2c_core via_agp agpgart rtc

<1>Fixing recursive fault but reboot is needed!
swapper: page allocation failure. order:0, mode:0x20
[<c013e8f9>] __alloc_pages+0x2f9/0x310
[<c0153bcd>] cache_alloc_refill+0x27d/0x490
[<c0153e65>] __kmalloc+0x85/0x90
[<c0286645>] __alloc_skb+0x55/0x110
[<c024a625>] boomerang_rx+0x345/0x450
[<c024b246>] boomerang_interrupt+0x156/0x410
[<c0136dd5>] handle_IRQ_event+0x25/0x60
[<c0137de4>] handle_fasteoi_irq+0x44/0x90


I don't think that the -ck patch i am using skews it in any way, it 
seems to be ext3/swap/memory related.

I am not on the list, if you need anything from me, just use my email or cc.

Best regards,
Maciej Soltysiak

