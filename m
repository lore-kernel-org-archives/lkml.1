Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbXKGXtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbXKGXtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXKGXt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:49:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48073 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbXKGXt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:49:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Grant Wilson <grant.wilson@zen.co.uk>
Subject: Re: 2.6.24-rc1-gb4f5550 oops
Date: Thu, 8 Nov 2007 01:06:21 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20071105061158.3174d24d@worthy.swandive.local>
In-Reply-To: <20071105061158.3174d24d@worthy.swandive.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711080106.21580.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 5 of November 2007, Grant Wilson wrote:
> Hi,
> I got this oops on 2.6.24-rc1-641-gb4f5550:

(1) Is this reproducible?
(2) Did it happen previously on your system?


> [18073.371126] Unable to handle kernel NULL pointer dereference at 0000000000000120 RIP: 
> [18073.371134]  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> [18073.371144] PGD 81f9067 PUD 81c8067 PMD 0 
> [18073.371151] Oops: 0000 [1] PREEMPT SMP 
> [18073.371157] CPU 2 
> [18073.371161] Modules linked in: vfat fat
> [18073.371168] Pid: 4639, comm: kwin Not tainted 2.6.24-rc1 #1
> [18073.371171] RIP: 0010:[<ffffffff8023572e>]  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> [18073.371177] RSP: 0018:ffff810008531a78  EFLAGS: 00010006
> [18073.371179] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [18073.371183] RDX: ffff810004441bf0 RSI: ffff81000801e860 RDI: ffff81000444ab80
> [18073.371186] RBP: ffff810008531aa8 R08: 000000d0d47a4a90 R09: 0000000000000000
> [18073.371188] R10: ffff810004441bf0 R11: 0000000000000001 R12: ffff810006520400
> [18073.371190] R13: ffff81000801e860 R14: ffff81000a63a000 R15: ffff81000443d8e0
> [18073.371193] FS:  00002b7d646a86f0(0000) GS:ffff810004c11780(0000) knlGS:0000000000000000
> [18073.371196] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [18073.371199] CR2: 0000000000000120 CR3: 0000000008495000 CR4: 00000000000006e0
> [18073.371202] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [18073.371211] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [18073.371214] Process kwin (pid: 4639, threadinfo ffff810008530000, task ffff81000840a860)
> [18073.371216] Stack:  ffff81000444ab80 0000000000000001 ffff81000801e860 ffff81000444ab80
> [18073.371231]  0000000000000002 ffff81000443d8e0 ffff810008531b38 ffffffff8023061e
> [18073.371238]  0000000000000000 ffff810004441b80 0000000000000002 0000000100000000
> [18073.371245] Call Trace:
> [18073.371250]  [<ffffffff8023061e>] try_to_wake_up+0x2fe/0x3a0
> [18073.371253]  [<ffffffff802306cd>] default_wake_function+0xd/0x10
> [18073.371257]  [<ffffffff8022daca>] __wake_up_common+0x5a/0x90
> [18073.371260]  [<ffffffff8023095a>] __wake_up_sync+0x4a/0x70
> [18073.371264]  [<ffffffff80602c3f>] unix_write_space+0x8f/0xa0
> [18073.371269]  [<ffffffff80593359>] sock_wfree+0x49/0x50
> [18073.371272]  [<ffffffff805951d9>] __kfree_skb+0x69/0xe0
> [18073.371275]  [<ffffffff80595267>] kfree_skb+0x17/0x30
> [18073.371278]  [<ffffffff80601347>] unix_stream_recvmsg+0x267/0x610
> [18073.371283]  [<ffffffff8058e0b7>] sock_aio_read+0x107/0x110
> [18073.371287]  [<ffffffff802929a1>] do_sync_read+0xf1/0x130
> [18073.371291]  [<ffffffff8058e230>] sock_ioctl+0x0/0x260
> [18073.371295]  [<ffffffff80251830>] autoremove_wake_function+0x0/0x40
> [18073.371299]  [<ffffffff80600522>] unix_ioctl+0xb2/0xf0
> [18073.371302]  [<ffffffff8058e301>] sock_ioctl+0xd1/0x260
> [18073.371305]  [<ffffffff802a00c1>] do_ioctl+0x31/0x90
> [18073.371308]  [<ffffffff802932f6>] vfs_read+0x156/0x160
> [18073.371311]  [<ffffffff80293700>] sys_read+0x50/0x90
> [18073.371315]  [<ffffffff8020bd7e>] system_call+0x7e/0x83
> [18073.371317] 
> [18073.371319] 
> [18073.371319] Code: 48 8b 90 20 01 00 00 48 39 93 20 01 00 00 75 e2 48 81 3b 00 
> [18073.371346] RIP  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> [18073.371351]  RSP <ffff810008531a78>
> [18073.371354] CR2: 0000000000000120
> [18073.371358] note: kwin[4639] exited with preempt_count 3
