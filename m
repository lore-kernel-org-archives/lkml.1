Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbXEDOwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbXEDOwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXEDOwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:52:38 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:53505 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755368AbXEDOwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:52:37 -0400
Date: Fri, 4 May 2007 16:52:36 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20.6 kernel BUG at mm/slab.c:2877
Message-ID: <20070504145236.GA23954@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-BotBait: val@frankvm.com, kuil@frankvm.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.20.6, FYI,

This suddenly cropped up after starting to use the i915 and drm module
but maybe it is unrelated to that:

kernel BUG at mm/slab.c:2877!
invalid opcode: 0000 [#1]
SMP 
Modules linked in: i915 drm
CPU:    0
EIP:    0060:[<c016640b>]    Not tainted VLI
EFLAGS: 00010083   (2.6.20.6-x153 #1)
EIP is at cache_free_debugcheck+0x1db/0x1f0
eax: 0047f480   ebx: ffff6820   ecx: 00130c00   edx: 0047f480
esi: f7a3bbc0   edi: cffe2bc0   ebp: c1ecde3c   esp: c1ecde14
ds: 007b   es: 007b   ss: 0068
Process kswapd0 (pid: 216, ti=c1ecc000 task=c1ec9510 task.ti=c1ecc000)
Stack: c1ec9510 00000000 00000002 00000246 170fc2a5 cffe2000 c01b56e3 f7a3cdf4 
       f7a3bbc0 cffe2bc4 c1ecde54 c0166ef5 00000246 cffe2c74 cffe2c74 c1ecde94 
       c1ecde5c c01b56e3 c1ecde68 c017c1d3 cffe2c7c c1ecde80 c017c570 00000060 
Call Trace:
 [<c01044a9>] show_trace_log_lvl+0x19/0x30
 [<c010456b>] show_stack_log_lvl+0x8b/0xb0
 [<c0104795>] show_registers+0x1b5/0x2d0
 [<c0104a0f>] die+0x10f/0x240
 [<c0104bb2>] do_trap+0x72/0xb0
 [<c0104ec3>] do_invalid_op+0xa3/0xb0
 [<c050a25c>] error_code+0x7c/0x90
 [<c0166ef5>] kmem_cache_free+0x55/0xa0
 [<c01b56e3>] ext3_destroy_inode+0x13/0x20
 [<c017c1d3>] destroy_inode+0x23/0x40
 [<c017c570>] dispose_list+0x70/0xf0
 [<c017c83c>] prune_icache+0xdc/0x200
 [<c017c975>] shrink_icache_memory+0x15/0x40
 [<c0152229>] shrink_slab+0x129/0x1d0
 [<c01536a9>] balance_pgdat+0x229/0x370
 [<c01538ab>] kswapd+0xbb/0x110
 [<c013543a>] kthread+0x8a/0xc0
 [<c0104317>] kernel_thread_helper+0x7/0x10
 =======================
Code: 8e 98 00 00 00 e9 a5 fe ff ff 89 f0 e8 cf e2 ff ff b9 05 00 00 00 01 f8 89 f2 ff 96 bc 00 00 00 8b 8e 98 00 00 00 e9 cb fe ff
EIP: [<c016640b>] cache_free_debugcheck+0x1db/0x1f0 SS:ESP 0068:c1ecde14


-- 
Frank
