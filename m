Return-Path: <linux-kernel-owner+w=401wt.eu-S1762599AbYESTU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762599AbYESTU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761953AbYESTUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:20:44 -0400
Received: from smtp.innovsys.com ([66.115.232.196]:29066 "EHLO
	mail.innovsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761888AbYESTUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:20:42 -0400
X-Greylist: delayed 917 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2008 15:20:42 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Oops with PREEMPT-RT on 2.6.25.4
Date: Mon, 19 May 2008 14:05:45 -0500
Message-ID: <DCEAAC0833DD314AB0B58112AD99B93B0469010C@ismail.innsys.innovsys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Oops with PREEMPT-RT on 2.6.25.4
Thread-Index: Aci541cyDQcJYcvDRqyJCe0vKMaV6Q==
From: "Rune Torgersen" <runet@innovsys.com>
To: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <linux-ide@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 
I get the following oops when trying to boot a arch/powerpc kernel with
preempt-rt installed (v2.6.25.4-rt1)
The board is using a Freescale 8280 as the main CPU and a Silicon Image
SII3124 SATA controller. The oops seems to happen on fileaccess right
after init starts.

I need ideas what to look for.

Freeing unused kernel memory: 128k init
INIT: version 2.85 booting
Activating all swap files/partitions... [  OK  ]
Mounting proc file system...    [  OK  ]
path=/bin:/usr/bin:/sbin:/usr/sbin
Oops: Exception in kernel mode, sig: 5 [#1]
PREEMPT Innovative Systems ApMax
Modules linked in:
NIP: c0249618 LR: c02495ec CTR: 00000000
REGS: ef29d550 TRAP: 0700   Not tainted  (2.6.25.4-rt1)
MSR: 00021032 <ME,IR,DR>  CR: 24044482  XER: 00000000
TASK = ef26d070[50] 'ldconfig' THREAD: ef29c000
GPR00: 00000001 ef29d600 ef26d070 00000000 11111111 00000000 ef29d64c
0000008c
GPR08: ef29d628 00000000 ef29d630 ef29c000 00000000 100b5eec 00000000
100b0000
GPR16: c00c3304 ef29dc48 0000000c 00000000 00000014 00000000 00000001
ef3818c0
GPR24: ef8a4000 00000011 00000000 c01bc3c4 ef29d698 ef381904 00009032
c0354700
NIP [c0249618] rt_spin_lock_slowlock+0x9c/0x200
LR [c02495ec] rt_spin_lock_slowlock+0x70/0x200
Call Trace:
[ef29d600] [c02495ec] rt_spin_lock_slowlock+0x70/0x200 (unreliable)
[ef29d670] [c00277d0] lock_timer_base+0x2c/0x64
[ef29d690] [c00285e8] del_timer+0x2c/0x78
[ef29d6b0] [c019d108] scsi_delete_timer+0x1c/0x3c
[ef29d6d0] [c01992d0] scsi_done+0x18/0x4c
[ef29d6f0] [c01b19dc] ata_scsi_qc_complete+0x364/0x380
[ef29d720] [c01a8708] __ata_qc_complete+0xd8/0xec
[ef29d740] [c01b011c] ata_qc_complete_multiple+0xc4/0xec
[ef29d760] [c01bcaf4] sil24_interrupt+0x46c/0x52c
[ef29d7a0] [c0048954] handle_IRQ_event+0x64/0x100
[ef29d7d0] [c0048b30] __do_IRQ+0x140/0x1bc
[ef29d7f0] [c00166c4] apmax_int_irq_demux+0x8c/0xb0
[ef29d810] [c0006448] do_IRQ+0x68/0xa8
[ef29d820] [c0010388] ret_from_except+0x0/0x14
--- Exception: 501 at __spin_unlock_irqrestore+0x28/0x4c
    LR = __spin_unlock_irqrestore+0x20/0x4c
[ef29d8f0] [c0249600] rt_spin_lock_slowlock+0x84/0x200
[ef29d960] [c00277d0] lock_timer_base+0x2c/0x64
[ef29d980] [c002790c] __mod_timer+0x34/0xdc
[ef29d9b0] [c0154650] blk_plug_device+0x58/0x68
[ef29d9c0] [c0154db0] __make_request+0x2dc/0x34c
[ef29da00] [c0153aa4] generic_make_request+0x20c/0x238
[ef29da40] [c01550a8] submit_bio+0x124/0x138
[ef29da80] [c009a490] submit_bh+0x13c/0x174
[ef29daa0] [c009df9c] __bread+0xa4/0x100
[ef29dab0] [c00c2478] ext3_get_branch+0x78/0xfc
[ef29dae0] [c00c27dc] ext3_get_blocks_handle+0x94/0x9cc
[ef29dba0] [c00c3398] ext3_get_block+0x94/0xdc
[ef29dbd0] [c00a458c] do_mpage_readpage+0x1a4/0x63c
[ef29dc40] [c00a4b58] mpage_readpages+0xc4/0x11c
[ef29dd20] [c00c269c] ext3_readpages+0x24/0x34
[ef29dd30] [c00572e4] __do_page_cache_readahead+0x1a0/0x258
[ef29dd70] [c00512bc] filemap_fault+0x198/0x41c
[ef29ddb0] [c005d934] __do_fault+0x6c/0x804
[ef29de10] [c0012420] do_page_fault+0x338/0x4b4
[ef29df40] [c0010120] handle_page_fault+0xc/0x80
