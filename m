Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbXJVSIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbXJVSIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbXJVSIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:08:13 -0400
Received: from mx1.suse.de ([195.135.220.2]:38958 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbXJVSIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:08:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: linux-kernel@vger.kernel.org
Subject: ata_exec_internal crash at boot in -git22
Date: Mon, 22 Oct 2007 20:08:08 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710222008.08095.ak@suse.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


One of the systems tested in autoboot crashes at boot with with -git22.
This is a AMD 2 socket Opteron NUMA system.

The tester was a little flakey and happened to hit the x86-merge-broke-
compilation window, so the last good data point I have is 2.6.23-rc9.

-Andi

megasas: 00.00.03.05 Mon Oct 02 11:21:32 PDT 2006
ACPI: PCI Interrupt 0000:03:05.0[A] -> GSI 17 (level, low) -> IRQ 17
ata1: SATA max UDMA/100 cmd 0xFFFFC20000006C80 ctl 0xFFFFC20000006C8A bmdma 0xFFFFC20000006C00 irq 17
ata2: SATA max UDMA/100 cmd 0xFFFFC20000006CC0 ctl 0xFFFFC20000006CCA bmdma 0xFFFFC20000006C08 irq 17
ata3: SATA max UDMA/100 cmd 0xFFFFC20000006E80 ctl 0xFFFFC20000006E8A bmdma 0xFFFFC20000006E00 irq 17
ata4: SATA max UDMA/100 cmd 0xFFFFC20000006EC0 ctl 0xFFFFC20000006ECA bmdma 0xFFFFC20000006E08 irq 17
scsi0 : sata_sil
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-7, max UDMA/133, 234441648 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 16
Unable to handle kernel paging request at 0000000000002277 RIP:
 [<ffffffff80259b03>] pfn_to_page+0x1f/0x32
PGD 0
Oops: 0000 [1] SMP
CPU 2
Modules linked in:
Pid: 915, comm: scsi_eh_0 Not tainted 2.6.19-git22 #24
RIP: 0010:[<ffffffff80259b03>]  [<ffffffff80259b03>] pfn_to_page+0x1f/0x32
RSP: 0000:ffff810004fbbbb8  EFLAGS: 00010216
RAX: 0000000000000040 RBX: 0000000000000000 RCX: 0000000000000020
RDX: 000000000000000f RSI: ffff810004fbbc40 RDI: 00000007f0000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: ffffffff80352a9b R12: 0000000000000003
R13: 0000000000000000 R14: ffff810004fbbc40 R15: ffff8100f7c2c708
FS:  0000000000000000(0000) GS:ffff8101000eabc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000002277 CR3: 0000000000201000 CR4: 00000000000006e0
Process scsi_eh_0 (pid: 915, threadinfo ffff810004fba000, task ffff8100f7a54870)
Stack:  ffffffff8043f1d1 0000000000000000 0000000000000000 0000000000000000
 0000000000000000 0000000000000000 ffff8100f7c2c508 ffff8100f7c2c708
 ffff8100f7c2c708 0000000000000000 ffff8100f7c2c508 0000000000000000
Call Trace:
 [<ffffffff8043f1d1>] ata_exec_internal+0x5a/0x96
 [<ffffffff8043fab3>] ata_set_mode+0x415/0x564
 [<ffffffff80445b2f>] ata_do_eh+0x11af/0x1493
 [<ffffffff804464a2>] ata_scsi_error+0x26f/0x509
 [<ffffffff80403a67>] scsi_error_handler+0x73/0x67b
 [<ffffffff80242f04>] kthread+0xd1/0x101
 [<ffffffff8020a318>] child_rip+0xa/0x12


Code: 48 2b ba 68 22 00 00 48 6b c7 38 48 03 82 58 22 00 00 c3 48
RIP  [<ffffffff80259b03>] pfn_to_page+0x1f/0x32
 RSP <ffff810004fbbbb8>
CR2: 0000000000002277

