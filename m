Return-Path: <linux-kernel-owner+w=401wt.eu-S932210AbZLRQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbZLRQpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZLRQpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:45:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58505 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbZLRQpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:45:22 -0500
Date: Fri, 18 Dec 2009 17:45:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
       Richard Purdie <rpurdie@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: -tip: origin tree boot crash
Message-ID: <20091218164509.GA14574@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's -tip crashes during bootup (x86 allyesconfig, 64-bit), due to this 
commit from yesterday's upstream -git tree:

 commit a328e95b82c1b8483ae5ab2f809140664d7f6c92
 Author: Dave Hansen <dave@sr71.net>
 Date:   Thu Oct 1 15:43:32 2009 -0700

    leds: LED driver for Intel NAS SS4200 series (v5)

The crash serial log is attached below. I suspect this driver was not booted 
on hardware that does not have that LED interface?

Thanks,

	Ingo

[   75.143912] initcall regulator_led_init+0x0/0x12 returned 0 after 5448 usecs
[   75.151208] calling  nas_gpio_init+0x0/0x153 @ 1
[   75.155860] BUG: unable to handle kernel paging request at 00000000001de7d0
[   75.159841] IP: [<ffffffff81683c55>] strstr+0x20/0x5f
[   75.159841] PGD 0 
[   75.159841] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   75.159841] last sysfs file: 
[   75.159841] CPU 0 
[   75.159841] Pid: 1, comm: swapper Not tainted 2.6.33-rc1-tip-00188-g19a3ebc-dirty #535 A8N-E/System Product Name
[   75.159841] RIP: 0010:[<ffffffff81683c55>]  [<ffffffff81683c55>] strstr+0x20/0x5f
[   75.159841] RSP: 0000:ffff88003e085e10  EFLAGS: 00010202
[   75.159841] RAX: 00000000001de7d0 RBX: ffffffff8449e568 RCX: 00000000001de7d0
[   75.159841] RDX: 0000000000000020 RSI: ffffffff8449e579 RDI: 00000000001de7d0
[   75.159841] RBP: ffff88003e085e10 R08: ffffffff8553005a R09: 0000000000000005
[   75.159841] R10: 0000000000000020 R11: 0000000000000074 R12: 0000000000000000
[   75.159841] R13: ffffffff8449e5b8 R14: 0000000000000000 R15: 0000000000000000
[   75.159841] FS:  0000000000000000(0000) GS:ffff880006800000(0000) knlGS:0000000000000000
[   75.159841] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   75.159841] CR2: 00000000001de7d0 CR3: 0000000003cc4000 CR4: 00000000000006f0
[   75.159841] DR0: ffffffff850a732c DR1: 0000000000000000 DR2: 0000000000000000
[   75.159841] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[   75.159841] Process swapper (pid: 1, threadinfo ffff88003e084000, task ffff88003e088000)
[   75.159841] Stack:
[   75.159841]  ffff88003e085e40 ffffffff825f0dfb 0000000000000000 ffffffff8449e568
[   75.159841] <0> 0000000000000000 000000117fa3493a ffff88003e085e60 ffffffff825f0e6a
[   75.159841] <0> ffffffff843f9ec8 0000000000000000 ffff88003e085e90 ffffffff843f9edf
[   75.159841] Call Trace:
[   75.159841]  [<ffffffff825f0dfb>] dmi_matches+0x6f/0x8d
[   75.159841]  [<ffffffff825f0e6a>] dmi_check_system+0x1c/0x4a
[   75.159841]  [<ffffffff843f9ec8>] ? nas_gpio_init+0x0/0x153
[   75.159841]  [<ffffffff843f9edf>] nas_gpio_init+0x17/0x153
[   75.159841]  [<ffffffff843f9ec8>] ? nas_gpio_init+0x0/0x153
[   75.159841]  [<ffffffff8100207d>] do_one_initcall+0x72/0x1a6
[   75.159841]  [<ffffffff8438374f>] do_basic_setup+0x54/0x66
[   75.159841]  [<ffffffff8438380e>] kernel_init+0xad/0xf3
[   75.159841]  [<ffffffff82ba7788>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   75.159841]  [<ffffffff81039cc4>] kernel_thread_helper+0x4/0x10
[   75.159841]  [<ffffffff82ba8710>] ? restore_args+0x0/0x30
[   75.159841]  [<ffffffff84383761>] ? kernel_init+0x0/0xf3
[   75.159841]  [<ffffffff81039cc0>] ? kernel_thread_helper+0x0/0x10
[   75.159841] Code: c0 48 ff ca 48 85 d2 75 ee c9 c3 55 48 89 f2 48 89 e5 eb 03 48 ff c2 80 3a 00 75 f8 29 f2 48 89 f8 74 45 48 89 f9 eb 03 48 ff c1 <80> 39 00 75 f8 48 89 f8 4c 63 d2 eb 26 4d 89 d1 49 89 c0 48 89 
[   75.159841] RIP  [<ffffffff81683c55>] strstr+0x20/0x5f
[   75.159841]  RSP <ffff88003e085e10>
[   75.159841] CR2: 00000000001de7d0
[   75.413931] ---[ end trace f895c45d96add991 ]---
[   75.418559] Kernel panic - not syncing: Fatal exception
[   75.423796] Pid: 1, comm: swapper Tainted: G      D    2.6.33-rc1-tip-00188-g19a3ebc-dirty #535
[   75.432536] Call Trace:
[   75.434985]  [<ffffffff82ba5365>] panic+0x7a/0x150
[   75.439795]  [<ffffffff82ba8417>] ? _raw_spin_unlock_irqrestore+0x55/0x72
[   75.446601]  [<ffffffff82ba96c3>] oops_end+0xd8/0xe8
[   75.451612]  [<ffffffff8106af9f>] no_context+0x144/0x150
[   75.456944]  [<ffffffff8106b14b>] __bad_area_nosemaphore+0x1a0/0x1c3
[   75.463307]  [<ffffffff82bab49a>] ? do_page_fault+0x101/0x304
[   75.469106]  [<ffffffff8106b181>] bad_area_nosemaphore+0x13/0x15
[   75.475127]  [<ffffffff82bab532>] do_page_fault+0x199/0x304
[   75.480714]  [<ffffffff82ba89b5>] page_fault+0x25/0x30
[   75.485897]  [<ffffffff81683c55>] ? strstr+0x20/0x5f
[   75.490878]  [<ffffffff825f0dfb>] dmi_matches+0x6f/0x8d
[   75.496125]  [<ffffffff825f0e6a>] dmi_check_system+0x1c/0x4a
[   75.501821]  [<ffffffff843f9ec8>] ? nas_gpio_init+0x0/0x153
[   75.507404]  [<ffffffff843f9edf>] nas_gpio_init+0x17/0x153
[   75.512913]  [<ffffffff843f9ec8>] ? nas_gpio_init+0x0/0x153
[   75.518522]  [<ffffffff8100207d>] do_one_initcall+0x72/0x1a6
[   75.524193]  [<ffffffff8438374f>] do_basic_setup+0x54/0x66
[   75.529694]  [<ffffffff8438380e>] kernel_init+0xad/0xf3
[   75.534963]  [<ffffffff82ba7788>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   75.541428]  [<ffffffff81039cc4>] kernel_thread_helper+0x4/0x10
[   75.547358]  [<ffffffff82ba8710>] ? restore_args+0x0/0x30
[   75.552804]  [<ffffffff84383761>] ? kernel_init+0x0/0xf3
[   75.558131]  [<ffffffff81039cc0>] ? kernel_thread_helper+0x0/0x10
