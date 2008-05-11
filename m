Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYEKR6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYEKR6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYEKR6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:58:01 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49352 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbYEKR6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:58:00 -0400
Date: Sun, 11 May 2008 10:54:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: viro <viro@zeniv.linux.org.uk>
Subject: BUG: 2.6.26-rc1-git8: NULL reference in drop_buffers
Message-Id: <20080511105429.a5e40721.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64, during testing using "stress" package:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff802ad273>] drop_buffers+0x2f/0xfb
PGD 1ee8ad067 PUD 26f19a067 PMD 0
Oops: 0000 [1] SMP
CPU 3
Modules linked in: parport_pc lp parport tg3 cciss ehci_hcd ohci_hcd uhci_hcd
Pid: 16860, comm: stress Not tainted 2.6.26-rc1-git8 #1
RIP: 0010:[<ffffffff802ad273>]  [<ffffffff802ad273>] drop_buffers+0x2f/0xfb
RSP: 0000:ffff81026bc03a08  EFLAGS: 00010203
RAX: 0000000000000000 RBX: ffffe20008bae680 RCX: ffff81027f490f00
RDX: 0000000000000000 RSI: ffff81026bc03a58 RDI: ffffe20008bae680
RBP: ffff81026bc03a38 R08: ffff81026bc03b78 R09: ffff810001103780
R10: ffff81026bc03a08 R11: ffff81026bc03c88 R12: ffffe20008bae680
R13: ffff81027c412850 R14: ffff81026bc03d58 R15: ffff81026bc03a58
FS:  00007fa9e7e416f0(0000) GS:ffff81027f806980(0000) knlGS:00000000f7f856c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000027f973000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process stress (pid: 16860, threadinfo ffff81026bc02000, task ffff81027e424c50)
Stack:  ffffe20008bafa68 ffffe20008bae680 ffff81027f490f00 ffff81026bc03a58
 ffff81026bc03d58 ffff81026bc03c88 ffff81026bc03a78 ffffffff802ad39f
 ffff81027f490f00 ffffe20008b14060 0000000000000000 ffff81027f490f00
Call Trace:
 [<ffffffff802ad39f>] try_to_free_buffers+0x60/0xa2
 [<ffffffff80267f98>] try_to_release_page+0x3b/0x41
 [<ffffffff802719bc>] shrink_page_list+0x457/0x562
 [<ffffffff80271bed>] shrink_inactive_list+0x126/0x361
 [<ffffffff80271f0d>] shrink_zone+0xe5/0x10a
 [<ffffffff8027227d>] try_to_free_pages+0x1ef/0x326
 [<ffffffff80270f4b>] ? isolate_pages_global+0x0/0x34
 [<ffffffff8026d843>] __alloc_pages_internal+0x25a/0x3ad
 [<ffffffff8026d9ac>] __alloc_pages+0xb/0xd
 [<ffffffff80277759>] handle_mm_fault+0x238/0x6d0
 [<ffffffff8053d9c4>] do_page_fault+0x438/0x7de
 [<ffffffff8053b999>] error_exit+0x0/0x51


Code: 41 57 49 89 f7 41 56 41 55 41 54 49 89 fc 53 48 83 ec 08 48 8b 07 25 00 08 00 00 48 85 c0 75 04 0f 0b eb fe 4c 8b 6f 10 4c 89 ea <48> 8b 02 25 00 08 00 00 48 85 c0 74 10 49 8b 44 24 18 48 85 c0
RIP  [<ffffffff802ad273>] drop_buffers+0x2f/0xfb
 RSP <ffff81026bc03a08>
CR2: 0000000000000000
Kernel panic - not syncing: Fatal exception

---
~Randy
