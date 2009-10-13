Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbZJMDTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbZJMDTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZJMDTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:19:37 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51449 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZJMDTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:19:36 -0400
Message-Id: <200910130317.n9D3HTOH055400@www262.sakura.ne.jp>
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: at kernel/lockdep.c:3161check_flags+0xbe/0x180()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: catalin.marinas@arm.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Oct 2009 12:17:29 +0900
References: <200910050315.n953FCD9030264@www262.sakura.ne.jp> <20091007155142.GB6743@linux.vnet.ibm.com> <200910082134.EJD35962.HLFSQVFOOFMJOt@I-love.SAKURA.ne.jp> <1255005738.6715.6.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1255005738.6715.6.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 13102009 #2740863, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> On Thu, 2009-10-08 at 21:34 +0900, Tetsuo Handa wrote:
> > If the stack dump is correct, this error indicates circular function calls.
> > We need to find the location which triggers circular memory allocation.
> > Maybe just checking for NULL is not sufficient.
> 
> The circular function call is expected, nothing to do with the NULL
> checking. You get callbacks from the slab allocator into kmemleak which
> also allocates memory (but this latter call isn't traced - similar
> behaviour in kmemtrace).
So, something is preventing kmemleak from being traced, isn't it?
I tried 2.6.32-rc4 , but the error is not yet fixed. How can I help you?

[    0.000000] Linux version 2.6.32-rc4 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #2 SMP Tue Oct 13 11:10:53 JST 2009
(...snipped...)
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at kernel/lockdep.c:3161 check_flags+0xbe/0x180()
[    0.000000] Hardware name: VMware Virtual Platform
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32-rc4 #2
[    0.000000] Call Trace:
[    0.000000]  [<c10417dd>] ? printk+0x1d/0x30
[    0.000000]  [<c10703ae>] ? check_flags+0xbe/0x180
[    0.000000]  [<c1040d91>] warn_slowpath_common+0x81/0xa0
[    0.000000]  [<c10703ae>] ? check_flags+0xbe/0x180
[    0.000000]  [<c1040e0a>] warn_slowpath_null+0x1a/0x30
[    0.000000]  [<c10703ae>] check_flags+0xbe/0x180
[    0.000000]  [<c106e23e>] lockdep_trace_alloc+0x2e/0x60
[    0.000000]  [<c10cfded>] kmem_cache_alloc+0x2d/0x1d0
[    0.000000]  [<c106e00b>] ? trace_hardirqs_off+0xb/0x10
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cf8d4>] ? cache_alloc_refill+0x144/0x210
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3879>] create_object+0x29/0x220
[    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ> (...snipped...)
