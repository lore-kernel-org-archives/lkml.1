Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbYKSC1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbYKSC1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 21:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYKSC10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 21:27:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:35051 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKSC10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 21:27:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=OdVb7CQhJf+QAGyKgOlagA9fyKv5SzwfhklrXlrMwyn8MWCn86gfQcPjsgaHH7g+nV
         QzynAy4zO09AzUoOH3+UfYk3x6tZaDKiqbzwzV+RRvVTQ6sfx3QimS8R96mIRPz07hir
         U9EmNVOjX8yxpI8qew8iWvh1epgtCltxckeA8=
Message-ID: <e38d12ff0811181827y3eefeee7pc4c5415738bd596c@mail.gmail.com>
Date: Tue, 18 Nov 2008 21:27:23 -0500
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: iwlagn causes kernel panic
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

panic log (printk times removed for clarity) :
BUG: unable to handle kernel NULL pointer at 0000000000000007
IP: [<ffffffff810a8d43>] __kmalloc+0x7a/0xc4
PGD 13d04a067 PUD 13b908067 PMD 0
Oops: 0000 [1] PRREMPT SMP
CPU 0
Modules linked in: nvidia(P) uvcvideo ohci1394 compat_ioctl32 ieee1394
btusb iwlagn sdhci_pci videodev sdhci iwlcore mmc_core v4l1_compat
r8169 pcspkr bluetooth rfkill
Pid: 2562, comm: udevd Tainted: P                  2.6.27-gentoo-r2 #10
RIP: 0010:[<ffffffff810a8d43>]  [<ffffffff810a8d43>] __kmalloc+0x7a/0xc4
RSP: 0018:ffff88010f82dc18 EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffffffff816b58f0 RCX: 0000000000000000
RDX: ffff8800280273a0 RSI: 0000000000000007 RDI: ffffffff816b58f0
RBP: ffff88010f82dc48 R08: ffff8800280275a0 R09: 785c6c6175747269
R10: 6632785c63766632 R11: 00007fff9c084660 R12: 000000000000282
R13: 00000000000000d0 R14: ffffffff810bf193 R15: 0000000000000040
FS: 00007f0f940516f0(0000) GS: ffffffff816b6380(0000) knIGS: 0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000007 CR3: 000000013d8cc000 CR4: 00000000000006a8
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevd (pid: 2562, threadinfo ffff88010f82c000, task ffff88013d043f00)
Stack: ffff88013cddf00e ffff88013cd9a4e0 ffff88010f82dd08 ffff88013f5e50d0
 ffff88013d984d98 ffff88010f82dde8 ffff88010f82dc78 ffffffff810bf193
 ffff88010f82dde8 fffffffffffffff4 ffff88013f5e50d0 ffff88013d984ce0
Call Trace:
 [<ffffffff810bf193>] d_alloc+0x4e/0x1a4
 [<ffffffff810b3eee>] do_lookup+0xba/0x1b9
 [<ffffffff810b6158>] __link+path_walk+0x958/0xdc9
 [<ffffffff814615a4>] ? _spin_unlock+0x10/0x29
 [<ffffffff81090d65>] ? do_wp_page+0x4bf/0x538
 [<ffffffff810b67af>] path_walk+0x61/0xc4
 [<ffffffff810b6a20>] do_path_lookup+0x16f/0x1c7
 [<ffffffff810b7477>] user_path_at+0x52/0x8c
 [<ffffffff81461199>] ? _spin_lock+0x16/0x2e
 [<ffffffff810af82e>] ? cp_new_stat+0xe2/0xef
 [<ffffffff810c3904>] ? mntput_no_expire+0x2a/0x13d
 [<ffffffff810afa89>] vfs_lstat_fd+0x1e/0x4b
 [<ffffffff810afad8>] sys_newlstat+0x22/0x3c
 [<ffffffff814618e9>] ? error_exit+0x0/0x51
 [<ffffffff8100c0db>] system_call_fastpath+0x16/0x1b

Code: 83 f8 10 76 61 4c 8b 75 08 9c 41 5c fa e8 1e b7 12 00 48 98 48
8b 94 c3 e8 00 00 00 48 8b 32 44 8b 7a 18 48 85 f6 74 0c 8b 42 14 <48>
8b 04 c6 48 89 02 eb 17 49 89 d0 44 89 ee 4c 89 f1 83 ca ff

I think that the cause of the panic is iwlagn because this only
happens when the HW RF kill switch is off.

--
Andrey Vul
