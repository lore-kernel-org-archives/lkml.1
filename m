Return-Path: <linux-kernel-owner+w=401wt.eu-S1945900AbXBPO7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945900AbXBPO7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945903AbXBPO7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:59:44 -0500
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:55925 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422640AbXBPO7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:59:43 -0500
Date: Fri, 16 Feb 2007 09:59:40 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: 2.6.20-mm1 [kernel BUG at mm/swap.c:442]
In-Reply-To: <20070215135157.18085ae3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702160938300.2581@d.namei>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702150926560.25081@d.namei> <20070215135157.18085ae3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Andrew Morton wrote:

> That's
> 
>                 VM_BUG_ON(PageMlocked(page));
> 
> Setting CONFIG_DEBUG_VM=n will shut it up.
> 

Then, I get this reliably as ntpd starts up:

[   92.725346] ------------[ cut here ]------------
[   92.741162] kernel BUG at mm/swap.c:469!
[   92.755867] invalid opcode: 0000 [#1]
[   92.769975] PREEMPT SMP 
[   92.783289] last sysfs file: /devices/pnp0/00:00/id
[   92.798654] Modules linked in: sg pcspkr e1000
[   92.813994] CPU:    2
[   92.813995] EIP:    0060:[<c014e548>]    Not tainted VLI
[   92.813997] EFLAGS: 00010002   (2.6.20-mm1 #4)
[   92.856416] EIP is at __pagevec_lru_add_mlock+0x5e/0xcf
[   92.871671] eax: 8011006c   ebx: c1c057f8   ecx: c1fe063c   edx: 00000001
[   92.888445] esi: c03d3500   edi: c1c5e7c0   ebp: f6037f14   esp: f6037f04
[   92.905436] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[   92.905443] Process ntpd (pid: 1582, ti=f6036000 task=c1fe00f0 task.ti=f6036000)
[   92.905446] Stack: 00000000 00000002 f606acb8 00000007 f6037f20 c014e7ff c1c5cf30 f6037f40 
[   92.905456]        c015a03f b7ce9000 f606acb8 f6037f40 c1c5cf20 f606acb8 f7ef2f00 f6037f70 
[   92.905466]        c0155acb b7cf0000 f6037f5c 00000000 f7316420 c1fd2180 00000000 c1c5cf20 
[   92.905475] Call Trace:
[   92.905478]  [<c010389a>] show_trace_log_lvl+0x1a/0x2f
[   92.905485]  [<c010394a>] show_stack_log_lvl+0x9b/0xaa
[   92.905492]  [<c0103b3f>] show_registers+0x1e6/0x325
[   92.905497]  [<c0103d9b>] die+0x11d/0x21c
[   92.905500]  [<c0103f13>] do_trap+0x79/0x91
[   92.905504]  [<c01047d9>] do_invalid_op+0x97/0xa1
[   92.905509]  [<c02f223c>] error_code+0x7c/0x84
[   92.905514]  [<c014e7ff>] lru_add_drain+0x57/0x8d
[   92.905519]  [<c015a03f>] free_pages_and_swap_cache+0x12/0x85
[   92.905526]  [<c0155acb>] unmap_region+0xfd/0x129
[   92.905530]  [<c0156404>] do_munmap+0x153/0x1b4
[   92.905534]  [<c015648a>] sys_munmap+0x25/0x34
[   92.905538]  [<c01028fc>] syscall_call+0x7/0xb
[   92.905542]  =======================
[   92.905544] Code: 74 1a 85 d2 74 0b 8d 82 80 05 00 00 e8 6a 3a 1a 00 8d 86 80 05 00 00 e8 7c 36 1a 00 8b 03 a9 00 00 10 00 74
 3f 8b 03 a8 20 74 04 <0f> 0b eb fe f0 0f ba 2b 05 f0 0f ba 33 14 f0 0f ba 2b 06 ba 03 

-- 
James Morris
<jmorris@namei.org>
