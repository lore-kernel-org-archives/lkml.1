Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZBZC3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZBZC3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZBZC3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:29:10 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50431 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZBZC3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:29:08 -0500
Message-Id: <200902260229.n1Q2T2lY006773@www262.sakura.ne.jp>
Subject: linux-next-20090225: ide-cd triggers BUG at arch/x86/mm/ioremap.c:80!
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 26 Feb 2009 11:29:02 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 26022009 #1665251, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-rc6 is OK.

Removing IDE CDROM drive solves this problem.

Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.29-rc6-next-20090225.txt

[    0.000000] Linux version 2.6.29-rc6-next-20090225 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #1 SMP Thu Feb 26 09:48:39 JST 2009
(...snipped...)
[    2.448739] Uniform Multi-Platform E-IDE driver
[    2.452036] piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
[    2.455202] piix 0000:00:07.1: IDE port disabled
[    2.458046] piix 0000:00:07.1: not 100% native mode: will probe irqs later
[    2.460836]     ide0: BM-DMA at 0x10e8-0x10ef
[    3.200762] hda: VMware Virtual IDE CDROM Drive, ATAPI CD/DVD-ROM drive
[    3.542671] hda: UDMA/33 mode selected
[    3.544877] ide0 at 0x170-0x177,0x376 on irq 15
[    3.550967] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    3.554908] ide-gd driver 1.18
[    3.557199] ide-cd driver 5.00
[    3.564266] ide-cd: hda: ATAPI 1X CD-ROM drive, 32kB Cache
[    3.567031] Uniform CD-ROM driver Revision: 3.20
[    3.569938] ------------[ cut here ]------------
[    3.571751] kernel BUG at arch/x86/mm/ioremap.c:80!
[    3.572605] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[    3.572605] last sysfs file: 
[    3.572605] Modules linked in:
[    3.572605] 
[    3.572605] Pid: 1, comm: swapper Not tainted (2.6.29-rc6-next-20090225 #1) VMware Virtual Platform
[    3.572605] EIP: 0060:[<c011e402>] EFLAGS: 00010213 CPU: 0
[    3.572605] EIP is at __phys_addr+0x52/0x70
[    3.572605] EAX: 00000000 EBX: 00000000 ECX: 00000018 EDX: 00000000
[    3.572605] ESI: f69f4060 EDI: 00000000 EBP: f700f930 ESP: f700f930
[    3.572605]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    3.572605] Process swapper (pid: 1, ti=f700f000 task=f7030000 task.ti=f700f000)
[    3.572605] Stack:
[    3.572605]  f700f944 c027dd73 f69f4060 f700f960 f700f9a0 f700f954 c02e7c82 f6570840
[    3.572605]  f700f960 f700f9ac c02f5a71 f6b7e5b0 00000000 00000000 00000000 00000000
[    3.572605]  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    3.572605] Call Trace:
[    3.572605]  [<c027dd73>] ? sg_init_one+0x23/0x90
[    3.572605]  [<c02e7c82>] ? ide_map_sg+0x42/0x70
[    3.572605]  [<c02f5a71>] ? ide_cd_do_request+0x101/0x150
[    3.572605]  [<c02e7e48>] ? start_request+0xa8/0x160
[    3.572605]  [<c015d85b>] ? trace_hardirqs_on+0xb/0x10
[    3.572605]  [<c02e809b>] ? do_ide_request+0x16b/0x250
[    3.572605]  [<c02646f5>] ? blk_remove_plug+0x75/0xf0
[    3.572605]  [<c02658c0>] ? blk_start_queueing+0x20/0x30
[    3.572605]  [<c026340e>] ? elv_insert+0x17e/0x1b0
[    3.572605]  [<c02645a8>] ? blk_plug_device+0x88/0x120
[    3.572605]  [<c02634c2>] ? __elv_add_request+0x82/0xc0
[    3.572605]  [<c0269c20>] ? blk_execute_rq_nowait+0x60/0xb0
[    3.572605]  [<c0269d06>] ? blk_execute_rq+0x96/0xd0
[    3.572605]  [<c0269b90>] ? blk_end_sync_rq+0x0/0x30
[    3.572605]  [<c02656ec>] ? get_request_wait+0x2c/0x160
[    3.572605]  [<c0160359>] ? __lock_acquired+0x109/0x1c0
[    3.572605]  [<c0265844>] ? blk_get_request+0x24/0x80
[    3.572605]  [<c02f5276>] ? ide_cd_queue_pc+0xb6/0x140
[    3.572605]  [<c01a9764>] ? trace+0x14/0x90
[    3.572605]  [<c01a935a>] ? check_object+0xaa/0x1c0
[    3.572605]  [<c01a8f84>] ? init_object+0x14/0x90
[    3.572605]  [<c01a99a4>] ? alloc_debug_processing+0xf4/0x120
[    3.572605]  [<c02f5b84>] ? cdrom_check_status+0x84/0x90
[    3.572605]  [<c015d85b>] ? trace_hardirqs_on+0xb/0x10
[    3.572605]  [<c02f5d31>] ? ide_cd_read_toc+0x41/0x420
[    3.572605]  [<c02f1fc1>] ? ide_add_proc_entries+0x31/0x60
[    3.572605]  [<c02f6921>] ? ide_cdrom_setup+0x101/0x130
[    3.572605]  [<c027aa0c>] ? sprintf+0x1c/0x20
[    3.572605]  [<c02f6d7e>] ? ide_cd_probe+0xee/0x140
[    3.572605]  [<c01fb106>] ? sysfs_addrm_finish+0x16/0xa0
[    3.572605]  [<c01fbb40>] ? sysfs_do_create_link+0xc0/0x150
[    3.572605]  [<c015a424>] ? lock_release_holdtime+0x74/0xc0
[    3.572605]  [<c01fbbe7>] ? sysfs_create_link+0x17/0x20
[    3.572605]  [<c02e6cc4>] ? generic_ide_probe+0x24/0x30
[    3.572605]  [<c02c483c>] ? really_probe+0x8c/0x110
[    3.572605]  [<c02c493c>] ? driver_probe_device+0x1c/0x30
[    3.572605]  [<c01515df>] ? down+0x2f/0x50
[    3.572605]  [<c02c4a84>] ? __driver_attach+0x74/0x80
[    3.572605]  [<c02c37b5>] ? bus_for_each_dev+0x55/0x70
[    3.572605]  [<c02c4aae>] ? driver_attach+0x1e/0x30
[    3.572605]  [<c02c4a10>] ? __driver_attach+0x0/0x80
[    3.572605]  [<c02c3f36>] ? bus_add_driver+0xb6/0x1a0
[    3.572605]  [<c02e6d00>] ? generic_ide_shutdown+0x0/0x30
[    3.572605]  [<c02e6d00>] ? generic_ide_shutdown+0x0/0x30
[    3.572605]  [<c02c4f50>] ? driver_register+0x70/0xd0
[    3.572605]  [<c0137efd>] ? printk+0x1d/0x30
[    3.572605]  [<c058fef0>] ? ide_cdrom_init+0x0/0x20
[    3.572605]  [<c058ff0c>] ? ide_cdrom_init+0x1c/0x20
[    3.572605]  [<c0101042>] ? do_one_initcall+0x32/0x1d0
[    3.572605]  [<c011f54f>] ? __change_page_attr_set_clr+0x2f/0x70
[    3.572605]  [<c015ca8c>] ? validate_chain+0x3fc/0x540
[    3.572605]  [<c015ca8c>] ? validate_chain+0x3fc/0x540
[    3.572605]  [<c015e95c>] ? __lock_acquire+0x29c/0x8b0
[    3.572605]  [<c01a9008>] ? check_bytes+0x8/0x20
[    3.572605]  [<c01a9099>] ? check_bytes_and_report+0x29/0xc0
[    3.572605]  [<c0198574>] ? page_address+0x14/0xe0
[    3.572605]  [<c01a9196>] ? check_pad_bytes+0x66/0x80
[    3.572605]  [<c0198574>] ? page_address+0x14/0xe0
[    3.572605]  [<c01a9764>] ? trace+0x14/0x90
[    3.572605]  [<c01a935a>] ? check_object+0xaa/0x1c0
[    3.572605]  [<c015ca8c>] ? validate_chain+0x3fc/0x540
[    3.572605]  [<c015e95c>] ? __lock_acquire+0x29c/0x8b0
[    3.572605]  [<c015a424>] ? lock_release_holdtime+0x74/0xc0
[    3.572605]  [<c01f355c>] ? proc_register+0x9c/0x140
[    3.572605]  [<c015fb47>] ? __lock_release+0x47/0x70
[    3.572605]  [<c03eace2>] ? _spin_unlock+0x22/0x30
[    3.572605]  [<c01f355c>] ? proc_register+0x9c/0x140
[    3.572605]  [<c01f38e9>] ? create_proc_entry+0x69/0xa0
[    3.572605]  [<c0173234>] ? register_irq_proc+0x14/0xd0
[    3.572605]  [<c056ea6a>] ? do_initcalls+0x2a/0x40
[    3.572605]  [<c056ead0>] ? kernel_init+0x0/0xa0
[    3.572605]  [<c056ea9c>] ? do_basic_setup+0x1c/0x20
[    3.572605]  [<c056eb25>] ? kernel_init+0x55/0xa0
[    3.572605]  [<c0103d33>] ? kernel_thread_helper+0x7/0x10
[    3.572605] Code: 05 00 00 80 00 39 c2 72 ea a1 c4 d4 52 c0 2d 00 30 60 00 25 00 00 c0 ff 2d 00 20 00 00 39 c2 73 d2 0f 0b 8d b6 00 00 00 00 eb fe <0f> 0b 8d b6 00 00 00 00 8d bf 00 00 00 00 eb fe 8d b4 26 00 00 
[    3.572605] EIP: [<c011e402>] __phys_addr+0x52/0x70 SS:ESP 0068:f700f930
[    3.824801] ---[ end trace d537ae8ff1cd7947 ]---
