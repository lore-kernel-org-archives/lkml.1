Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbYGPPWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbYGPPWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760142AbYGPPUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:20:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:60716 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760100AbYGPPU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:20:28 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/9vAdvYUj9JPe4HZ60Um7bRpB+p7wm20SSJcmmXV
	B9TMdlD2UKvD0w
Date: Wed, 16 Jul 2008 17:20:25 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: adobriyan@gmail.com, akpm@linux-foundation.org
Subject: /proc/*/pagemap oopses
Message-ID: <20080716152025.GA23096@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26 (x86_64)
X-Uptime: 17:08:20 up  9:24,  1 user,  load average: 0.04, 0.16, 0.43
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

with current -git a "cat /proc/4260/pagemap"
gives me the following oops:


[   80.334016] general protection fault: fffc [#1] PREEMPT DEBUG_PAGEALLOC
[   80.334402] Modules linked in:
[   80.334654] 
[   80.334765] Pid: 4744, comm: cat Not tainted (2.6.26-02962-g4515889 #5)
[   80.334902] EIP: 0060:[<cb613f4b>] EFLAGS: 00010206 CPU: 0
[   80.335093] EIP is at 0xcb613f4b
[   80.335213] EAX: 96c26000 EBX: c013b06a ECX: 00400000 EDX: 00000000
[   80.335347] ESI: cb613f44 EDI: fffffff2 EBP: c016d99c ESP: cb613f04
[   80.335481]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   80.335672] Process cat (pid: 4744, ti=cb613000 task=cb59df40 task.ti=cb613000)
[   80.335810] Stack: ffffffb0 bfffffff c0000000 00000000 cbb67000 00400000 00000001 00000000 
[   80.336019]        fffffff2 cb613f74 c01abab0 0828a000 0828a400 cb408380 cb400fe0 cb4a6c80 
[   80.336019]        c013b06a cb613f60 c01ab441 00000000 c01ab3af cb4a6c80 cb613f60 0828a000 
[   80.336019] Call Trace:
[   80.336019]  [<c01abab0>] ? pagemap_read+0x16a/0x1e3
[   80.336019]  [<c013b06a>] ? put_lock_stats+0xd/0x21
[   80.336019]  [<c01ab441>] ? pagemap_pte_range+0x0/0xdc
[   80.336019]  [<c01ab3af>] ? pagemap_pte_hole+0x0/0x37
[   80.336019]  [<c01ab946>] ? pagemap_read+0x0/0x1e3
[   80.336019]  [<c017af1f>] ? vfs_read+0x8a/0x106
[   80.336019]  [<c017b21f>] ? sys_read+0x3b/0x60
[   80.336019]  [<c01038b1>] ? sysenter_past_esp+0x6a/0xa5
[   80.336019]  =======================
[   80.336019] Code: 00 00 00 00 f2 ff ff ff 74 3f 61 cb b0 ba 1a c0 00
a0 28 08 00 a4 28 08 80 83 40 cb e0 0f 40 cb 80 6c 4a cb 6a b0 13 c0 60
3f 61 <cb> 41 b4 1a c0 00 00 00 00 af b3 1a c0 80 6c 4a cb 60 3f 61 cb 
[   80.336019] EIP: [<cb613f4b>] 0xcb613f4b SS:ESP 0068:cb613f04
[   80.455182] ---[ end trace e2b2d610b672cbbc ]---


doing this again gives a slightly different oops

[  156.814961] BUG: unable to handle kernel NULL pointer dereference at 00000002
[  156.815288] IP: [<00000002>]
[  156.815482] *pde = 00000000 
[  156.815704] Oops: 0000 [#2] PREEMPT DEBUG_PAGEALLOC
[  156.816079] Modules linked in:
[  156.816255] 
[  156.816368] Pid: 4765, comm: cat Tainted: G      D (2.6.26-02962-g4515889 #5)
[  156.816608] EIP: 0060:[<00000002>] EFLAGS: 00010202 CPU: 0
[  156.816739] EIP is at 0x2
[  156.816854] EAX: cbb67000 EBX: 00000002 ECX: 00400000 EDX: 00000000
[  156.816989] ESI: cb61ef44 EDI: fffffff2 EBP: cb61ef28 ESP: cb61ef00
[  156.817183]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  156.817314] Process cat (pid: 4765, ti=cb61e000 task=cb626f20 task.ti=cb61e000)
[  156.817455] Stack: c016d99c cb61ef44 bfffffff c0000000 00000000 cbb67000 00400000 00000001 
[  156.818028]        00000000 fffffff2 cb61ef74 c01abab0 09740000 09740400 cb4083b8 cb400fe0 
[  156.818028]        cb4a6c80 00000002 00000000 c01ab441 00000001 c01ab3af cb4a6c80 cb61ef60 
[  156.818028] Call Trace:
[  156.818028]  [<c016d99c>] ? walk_page_range+0x70/0x180
[  156.818028]  [<c01abab0>] ? pagemap_read+0x16a/0x1e3
[  156.818028]  [<c01ab441>] ? pagemap_pte_range+0x0/0xdc
[  156.818028]  [<c01ab3af>] ? pagemap_pte_hole+0x0/0x37
[  156.818028]  [<c01ab946>] ? pagemap_read+0x0/0x1e3
[  156.818028]  [<c017af1f>] ? vfs_read+0x8a/0x106
[  156.818028]  [<c017b21f>] ? sys_read+0x3b/0x60
[  156.818028]  [<c01038b1>] ? sysenter_past_esp+0x6a/0xa5
[  156.818028]  =======================
[  156.818028] Code:  Bad EIP value.
[  156.818028] EIP: [<00000002>] 0x2 SS:ESP 0068:cb61ef00
[  156.823465] ---[ end trace e2b2d610b672cbbc ]---

Greetings, Eric
