Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYHQDzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYHQDzP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 23:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYHQDzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 23:55:03 -0400
Received: from smtp.vip.sina.com ([202.108.3.172]:63774 "EHLO
	smtp-6-97.vip.sina.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752323AbYHQDzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 23:55:01 -0400
X-Greylist: delayed 821 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Aug 2008 23:55:00 EDT
Message-ID: <48A79CEF.3000202@vip.sina.com>
Date: Sun, 17 Aug 2008 11:37:19 +0800
From: zhang wenjie <zwjsq@vip.sina.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
CC: linux-kernel mail-list <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 14 Aug 2008, Ian Campbell wrote:
> > Jeremy first noticed this
> > http://marc.info/?l=linux-kernel&m=121783008503477&w=2 <http://marc.info/?l=linux-kernel&m=121783008503477&w=2>

    I have counted the same problem when i mmap the /dev/fb0 and memset 
it to 0( the fb driver use deferred_io and when i do not use deferred_io 
it works well) .This bug also showed int linux2.6.26 and linux2.6.25. 
does this bug solved?

function fb_deferred_io_fault called<3>function fb_deferred_io_mkwrite called<3>function fb_deferred_io_fault called<3>function fb_deferred_io_mkwrite called<3>function fb_deferred_io_fault called<3>function fb_deferred_io_mkwrite called<2>kernel BUG at lib/radix-tree.c:474!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c3ef8000
[00000000] *pgd=0bd25031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#2]
Modules linked in: etrackfb_new sony_prs_505
CPU: 0    Tainted: G      D W  (2.6.26-rc9-00056-g99b0915-dirty #1)
PC is at __bug+0x20/0x2c
LR is at log_wait+0x0/0x8
pc : [<c002118c>]    lr : [<c024f1f8>]    psr: 20000093
sp : c3ed7d9c  ip : c3ed7ce0  fp : c3ed7da8
r10: 00000002  r9 : 00000000  r8 : 40137000
r7 : 00000000  r6 : c3811294  r5 : 00000000  r4 : 00000000
r3 : 00000000  r2 : c024f214  r1 : 0001233d  r0 : 00000027
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: c000717f  Table: 0bef8000  DAC: 00000015
Process framebuff.ko (pid: 215, stack limit = 0xc3ed6260)
Stack: (0xc3ed7d9c to 0xc3ed8000)
7d80:                                                                c3ed7dd8 
7da0: c3ed7dac c01069d4 c002117c c3ed7db8 00000000 c0310b40 c3811290 00000000 
7dc0: 40137000 c3d2c900 00000000 c3ed7df4 c3ed7ddc c00a639c c010692c c0310b40 
7de0: 00000001 c3d1339c c3ed7e04 c3ed7df8 c00a65f8 c00a6248 c3ed7e1c c3ed7e08 
7e00: c00660d8 c00a6554 c0310b40 00000001 c3ed7e34 c3ed7e20 c0066ba4 c006609c 
7e20: 0bd5a0ff c0310b40 c3ed7e7c c3ed7e38 c006d684 c0066b9c c3ef9000 00000001 
7e40: 00000001 00000001 00000002 40137000 c0310b40 c3ef8000 00000000 c3d20f00 
7e60: c3d1339c 40137000 00000800 00001000 c3ed7ecc c3ed7e80 c006eb64 c006d318 
7e80: 00000002 00000001 00000000 c02ffe60 c3d2c900 c3ed7eb4 000004dc c3ef9000 
7ea0: c004c368 ffffffff c3d1339c c3d20f00 c3d2c938 c3d2c900 c3ed7fb0 40137000 
7ec0: c3ed7f04 c3ed7ed0 c0022dc0 c006e8b8 c02ffe60 c3ef8000 00000817 ffffffff 
7ee0: c024e630 00000817 c3ed7fb0 40137000 00000000 4012f000 c3ed7fac c3ed7f08 
7f00: c001d1dc c0022ce8 00000000 000000fb c3d2c900 c3d30680 00000224 c3ef9000 
7f20: 00076000 ffffffff 00000200 c3d136e4 c3ed7f4c c3ed7f40 c004f998 c0107a20 
7f40: c3ed7f84 c3ed7f50 c0022e50 c004f998 00075300 c3ed7f70 00000000 ffffffff 
7f60: 00001000 000086c0 00000001 00008520 00000000 4012f000 c3ed7f9c c3ed7f88 
7f80: c0022f98 c0022ce8 ffffffff ffffffff 000086b4 000086c0 00000001 00008520 
7fa0: 00000000 c3ed7fb0 c001d9c0 c001d1b0 40135000 00000000 000732f8 40137000 
7fc0: beb2bed4 000086b4 000086c0 00000001 00008520 00000000 4012f000 beb2bea8 
7fe0: 40089810 beb2bd6c 00008674 40089838 20000010 ffffffff ffffffff ffffffff 
Backtrace: 
[<c002116c>] (__bug+0x0/0x2c) from [<c01069d4>] (radix_tree_tag_set+0xb8/0xfc)
[<c010691c>] (radix_tree_tag_set+0x0/0xfc) from [<c00a639c>] (__set_page_dirty+0x164/0x198)
[<c00a6238>] (__set_page_dirty+0x0/0x198) from [<c00a65f8>] (__set_page_dirty_buffers+0xb4/0xc4)
 r6:c3d1339c r5:00000001 r4:c0310b40
[<c00a6544>] (__set_page_dirty_buffers+0x0/0xc4) from [<c00660d8>] (set_page_dirty+0x4c/0xd0)
[<c006608c>] (set_page_dirty+0x0/0xd0) from [<c0066ba4>] (set_page_dirty_balance+0x18/0x5c)
 r5:00000001 r4:c0310b40
[<c0066b8c>] (set_page_dirty_balance+0x0/0x5c) from [<c006d684>] (__do_fault+0x37c/0x3a4)
 r5:c0310b40 r4:0bd5a0ff
[<c006d308>] (__do_fault+0x0/0x3a4) from [<c006eb64>] (handle_mm_fault+0x2bc/0x5f0)
[<c006e8a8>] (handle_mm_fault+0x0/0x5f0) from [<c0022dc0>] (do_page_fault+0xe8/0x224)
[<c0022cd8>] (do_page_fault+0x0/0x224) from [<c001d1dc>] (do_DataAbort+0x3c/0xa0)
[<c001d1a0>] (do_DataAbort+0x0/0xa0) from [<c001d9c0>] (ret_from_exception+0x0/0x10)
Exception stack(0xc3ed7fb0 to 0xc3ed7ff8)
7fa0:                                     40135000 00000000 000732f8 40137000 
7fc0: beb2bed4 000086b4 000086c0 00000001 00008520 00000000 4012f000 beb2bea8 
7fe0: 40089810 beb2bd6c 00008674 40089838 20000010 ffffffff                   
 r8:00008520 r7:00000001 r6:000086c0 r5:000086b4 r4:ffffffff
Code: e1a01000 e59f000c eb006243 e3a03000 (e5833000) 
---[ end trace 4cc49dda9c86eac6 ]---
Segmentation fault



