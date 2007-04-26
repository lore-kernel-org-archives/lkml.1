Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXDZJgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXDZJgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1160993AbXDZJge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:36:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36280 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030316AbXDZJgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:36:32 -0400
Date: Thu, 26 Apr 2007 15:06:20 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Morton Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.21-rc7-mm2 "irqpoll" seems to be broken
Message-ID: <20070426093620.GB2626@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am booting 2.6.21-rc7-mm2 on x86_64 box with "irqpoll" command line option
and it panics. I can reproduce this problem easily on this box. Please
let me know if serial console output is required.

2.6.21-rc7 works just fine. So problem seems to be in some -mm patch.

Unable to handle kernel NULL pointer dereference at 0000000000000009 RIP:
 [<ffffffff8025bc5e>] note_interrupt+0x5d/0x21b
PGD 1032c5067 PUD 1032c4067 PMD 0
Oops: 0000 [1] SMP
CPU 1
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.21-rc7-mm2 #1
RIP: 0010:[<ffffffff8025bc5e>]  [<ffffffff8025bc5e>] note_interrupt+0x5d/0x21b
RSP: 0018:ffff810100cbff08  EFLAGS: 00010002
RAX: 0000000000000000 RBX: ffffffff807e2d40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff807e2d40 RDI: 0000000000000004
RBP: ffffffff807e2d40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000010 R11: 00000000000000a0 R12: ffff810104192f40
R13: ffffffff807e2d84 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff810100854140(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000009 CR3: 00000001032c6000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffff810100cb8000, task ffff810100cb7500)
Stack:  0000000000000004 0000000400000000 0000000000000000 ffffffff807e2d40
 0000000000000004 ffff810104192f40 ffffffff807e2d84 0000000000000000
 0000000000000000 ffffffff8025c7c5 ffff810100cb9e98 ffff810100cb9e98
Call Trace:
 [<ffffffff8025c7c5>] handle_edge_irq+0xf9/0x127
 [<ffffffff8020c2f9>] do_IRQ+0xf1/0x160
 [<ffffffff8020a141>] ret_from_intr+0x0/0xa
 [<ffffffff80208fd9>] mwait_idle+0x42/0x45
 [<ffffffff80208f2f>] cpu_idle+0xbd/0xe0


Code: f6 40 09 10 75 09 45 85 ff 0f 85 3d 01 00 00 49 c7 c4 c0 2b
RIP  [<ffffffff8025bc5e>] note_interrupt+0x5d/0x21b
 RSP <ffff810100cbff08>
CR2: 0000000000000009
Kernel panic - not syncing: Aiee, killing interrupt handler!


