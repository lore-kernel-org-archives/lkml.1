Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab0BIRLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:11:12 -0500
Received: from 2605ds1-ynoe.0.fullrate.dk ([90.184.12.24]:59202 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab0BIRLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:11:10 -0500
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2010 12:11:09 EST
Message-ID: <4B71951A.8050701@krogh.cc>
Date: Tue, 09 Feb 2010 18:02:18 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Oops in kswapd (2.6.31.5)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list.

One of my servers "hung" itself today, when it got up I had this message
in the logs:

Feb  9 09:40:52 ko kernel: [1341076.770228] Pid: 347, comm: kswapd3 Not
tainted 2.6.31.5 #3 Sun Fire X4600 M2
Feb  9 09:40:52 ko kernel: [1341076.770228] RIP:
0010:[<ffffffff8109fcb2>]  [<ffffffff8109fcb2>] find_get_pages+0x52/0xc0
Feb  9 09:40:52 ko kernel: [1341076.770228] RSP: 0018:ffff8800debafc00
EFLAGS: 00000286
Feb  9 09:40:52 ko kernel: [1341076.770228] RAX: ffff8800109fb6c8 RBX:
0000000000000000 RCX: 0000000000000000
Feb  9 09:40:52 ko kernel: [1341076.770228] RDX: 0000000000000040 RSI:
ffff8800debafc80 RDI: ffffea00016e8550
Feb  9 09:40:52 ko kernel: [1341076.770228] RBP: ffffffff8100c76e R08:
ffff8800debafbc0 R09: 0000000000000002
Feb  9 09:40:52 ko kernel: [1341076.770228] R10: 0000000000000040 R11:
0000000000000040 R12: 0000000000000007
Feb  9 09:40:52 ko kernel: [1341076.770228] R13: ffff8800debafcb8 R14:
ffff880000028740 R15: ffffea0001b814d8
Feb  9 09:40:52 ko kernel: [1341076.770228] FS:  00000000450fa950(0000)
GS:ffffc90000c00000(0000) knlGS:00000000f73cb8c0
Feb  9 09:40:52 ko kernel: [1341076.770228] CS:  0010 DS: 0018 ES: 0018
CR0: 000000008005003b
Feb  9 09:40:52 ko kernel: [1341076.770228] CR2: 00007fb194a20f10 CR3:
0000000001001000 CR4: 00000000000006e0
Feb  9 09:40:52 ko kernel: [1341076.770228] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb  9 09:40:52 ko kernel: [1341076.770228] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb  9 09:40:52 ko kernel: [1341076.770228] Call Trace:
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff810a7ec7>] ?
pagevec_lookup+0x17/0x20
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff810a8206>] ?
invalidate_mapping_pages+0x56/0x140
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff810e9819>] ?
shrink_icache_memory+0x299/0x2c0
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff810aa8a4>] ?
shrink_slab+0x124/0x180
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff810ab569>] ?
kswapd+0x3d9/0x600
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff810a8a00>] ?
isolate_pages_global+0x0/0x260
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff8105ac60>] ?
autoremove_wake_function+0x0/0x30
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff810ab190>] ?
kswapd+0x0/0x600
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff8105aaf6>] ?
kthread+0xa6/0xb0
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff8100cc9a>] ?
child_rip+0xa/0x20
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff8105aa50>] ?
kthread+0x0/0xb0
Feb  9 09:40:52 ko kernel: [1341076.770228]  [<ffffffff8100cc90>] ?
child_rip+0x0/0x20

I searched the "git log" of 2.6.31.5 up til 2.6.31.latest and didnt find
anything mentioned that looked like that, but please point me to the fix
if it has been posted on the list.

-- 
Jesper
