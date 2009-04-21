Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbZDUSpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbZDUSpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbZDUSnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:43:17 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50839 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758854AbZDUSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:43:14 -0400
Date: Wed, 22 Apr 2009 00:12:23 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: [BUG] rbtree bug with mmotm 2009-04-14-17-24
Message-ID: <20090421184223.GP19637@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

I did a quick check on lkml to see if someone reported this issue
already, I could not find any reports. I am beginning to see several
of these on my machine. I saw recent refactoring of rbtrees, I've
cc'ed Wolfram Strepp.


BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff803ba4c8>] rb_erase+0x11f/0x2a7
PGD 77d1c067 PUD 77c96067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
CPU 2 
Modules linked in: coretemp hwmon kvm_intel kvm usbhid rtc_cmos rtc_core rtc_lib usb_storage ata_piix libata mptsas mptscsih mptbase scsi_transport_sas uhci_hcd ohci_hcd ehci_hcd usbcore
Pid: 5379, comm: make Not tainted 2.6.30-rc1-mm1-dirty #163 IBM System x3250 -[436482A]-
RIP: 0010:[<ffffffff803ba4c8>]  [<ffffffff803ba4c8>] rb_erase+0x11f/0x2a7
RSP: 0018:ffff8800640f7838  EFLAGS: 00010006
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88007f1d3bf8
RDX: ffff88007f1d3bf8 RSI: ffff88007e0208c8 RDI: 0000000000000000
RBP: ffff8800640f7848 R08: 0000000000000000 R09: 0000000000000000
R10: ffff88007dcbb480 R11: ffff88006408e978 R12: ffff88007e0208c8
R13: ffff88007e020890 R14: ffff88007e0208c8 R15: 0000000000000010
FS:  00002ae490d5c6f0(0000) GS:ffffc20000400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 0000000077d8a000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process make (pid: 5379, threadinfo ffff8800640f6000, task ffff880077cc6630)
Stack:
 ffff88007e0403d0 ffff88007e0403d0 ffff8800640f7868 ffffffff803b21ea
 ffff88007e020890 ffff88007e0403a0 ffff8800640f78a8 ffffffff803b2237
 000000057e0208c8 ffff88007e0403a0 ffff88007e0403a0 ffff88007e020890
Call Trace:
 [<ffffffff803b21ea>] rb_erase_init+0x11/0x21
 [<ffffffff803b2237>] cfq_prio_tree_add+0x3d/0xab
 [<ffffffff803b24ba>] cfq_resort_rr_list+0x25/0x2a
 [<ffffffff803b2513>] __cfq_slice_expired+0x54/0x94
 [<ffffffff803b3522>] cfq_insert_request+0x295/0x2d0
 [<ffffffff803a8404>] elv_insert+0x10f/0x1cd
 [<ffffffff803a8558>] __elv_add_request+0x96/0x9e
 [<ffffffff803ab284>] __make_request+0x3c2/0x402
 [<ffffffff803a995c>] generic_make_request+0x293/0x32d
 [<ffffffff80262f0c>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8033b600>] ? ext3_get_block+0x0/0xe5
 [<ffffffff803aaeb9>] submit_bio+0xc7/0xd0
 [<ffffffff802ed865>] mpage_bio_submit+0x22/0x26
 [<ffffffff802ee567>] mpage_readpages+0xe2/0xf6
 [<ffffffff8033b600>] ? ext3_get_block+0x0/0xe5
 [<ffffffff8033aadf>] ext3_readpages+0x1a/0x1c
 [<ffffffff802982fc>] __do_page_cache_readahead+0x158/0x1fa
 [<ffffffff80298210>] ? __do_page_cache_readahead+0x6c/0x1fa
 [<ffffffff802983ba>] ra_submit+0x1c/0x20
 [<ffffffff802986c1>] ondemand_readahead+0x223/0x236
 [<ffffffff8029874c>] page_cache_async_readahead+0x78/0x84
 [<ffffffff80290e98>] generic_file_aio_read+0x295/0x5c8
 [<ffffffff802c752c>] do_sync_read+0xe2/0x126
 [<ffffffff80265a6f>] ? __lock_acquire+0x76c/0x7d7
 [<ffffffff8025691c>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff802eec6f>] ? dnotify_parent+0x6c/0x74
 [<ffffffff802c7d5c>] vfs_read+0xab/0x154
 [<ffffffff802c80b9>] sys_read+0x47/0x70
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Code: 89 01 48 85 d2 74 12 48 39 7a 10 75 06 48 89 4a 10 eb 0a 48 89 4a 08 eb 04 49 89 0c 24 41 ff c8 0f 85 88 01 00 00 e9 4b 01 00 00 <48> 8b 7b 10 48 39 cf 0f 85 a1 00 00 00 48 8b 7b 08 48 8b 07 a8 
RIP  [<ffffffff803ba4c8>] rb_erase+0x11f/0x2a7
 RSP <ffff8800640f7838>
CR2: 0000000000000010


-- 
	Balbir
