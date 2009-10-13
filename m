Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbZJMP0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbZJMP0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbZJMP0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:26:23 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58953 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbZJMP0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:26:22 -0400
To: catalin.marinas@arm.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: atkernel/lockdep.c:3161check_flags+0xbe/0x180()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091007155142.GB6743@linux.vnet.ibm.com>
	<200910082134.EJD35962.HLFSQVFOOFMJOt@I-love.SAKURA.ne.jp>
	<1255005738.6715.6.camel@pc1117.cambridge.arm.com>
	<200910130317.n9D3HTOH055400@www262.sakura.ne.jp>
	<1255435201.9987.22.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1255435201.9987.22.camel@pc1117.cambridge.arm.com>
Message-Id: <200910140025.CAJ82820.MOtOFOLVFFSHJQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 14 Oct 2009 00:25:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> > [    0.000000] Linux version 2.6.32-rc4 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #2 SMP Tue Oct 13 11:10:53 JST 2009
> > (...snipped...)
> > [    0.000000] -------------------------------------------------------
> > [    0.000000] Good, all 218 testcases passed! |
> > [    0.000000] ---------------------------------
> > [    0.000000] ------------[ cut here ]------------
> > [    0.000000] WARNING: at kernel/lockdep.c:3161 check_flags+0xbe/0x180()
> > [    0.000000] Hardware name: VMware Virtual Platform
> > [    0.000000] Modules linked in:
> > [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32-rc4 #2
> > [    0.000000] Call Trace:
> > [    0.000000]  [<c10417dd>] ? printk+0x1d/0x30
> > [    0.000000]  [<c10703ae>] ? check_flags+0xbe/0x180
> > [    0.000000]  [<c1040d91>] warn_slowpath_common+0x81/0xa0
> > [    0.000000]  [<c10703ae>] ? check_flags+0xbe/0x180
> > [    0.000000]  [<c1040e0a>] warn_slowpath_null+0x1a/0x30
> > [    0.000000]  [<c10703ae>] check_flags+0xbe/0x180
> > [    0.000000]  [<c106e23e>] lockdep_trace_alloc+0x2e/0x60
> > [    0.000000]  [<c10cfded>] kmem_cache_alloc+0x2d/0x1d0
> > [    0.000000]  [<c106e00b>] ? trace_hardirqs_off+0xb/0x10
> > [    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
> > [    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
> > [    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
> > [    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
> > [    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
> > [    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
> > [    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
> > [    0.000000]  [<c10d3879>] create_object+0x29/0x220
> > [    0.000000]  [<c10cd8b8>] ? obj_offset+0x8/0x10
> > [    0.000000]  [<c10cdf8a>] ? poison_obj+0x2a/0x50
> > [    0.000000]  [<c1321613>] kmemleak_alloc+0x83/0xd0
> > [    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
> > [    0.000000]  [<c10cff45>] kmem_cache_alloc+0x185/0x1d0
> > [    0.000000]  [<c10ceeaf>] ? alloc_slabmgmt+0x5f/0x80
> > [    0.000000]  [<c10ceeaf>] alloc_slabmgmt+0x5f/0x80
> > [    0.000000]  [<c10cf2ee>] cache_grow+0xae/0x170
> > [    0.000000]  [<c10cf90b>] cache_alloc_refill+0x17b/0x210
> > [    0.000000]  [<c10cff6a>] kmem_cache_alloc+0x1aa/0x1d0
> > [    0.000000]  [<c10cd8c8>] ? obj_size+0x8/0x10
> > [    0.000000]  [<c10d3879>] ? create_object+0x29/0x220
> > [    0.000000]  [<c10d3879>] create_object+0x29/0x220
> 
> This is the "DEBUG_LOCKS_WARN_ON(current->softirqs_enabled)" warning.
> I'm not sure why this happens but from the trace it seems that kmemleak
> is being called recursively via alloc_slabmgmt() which is caused by
> kmem_cache_alloc() called from create_object() in kmemleak.c.
If what my guess shown below is correct,
(object_cache->slabp_cache->flags & SLAB_NOLEAKTRACE) == 0
is triggering recursive calls.

(1) Starting from create_object()
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/kmemleak.c#L507
(2) Calling kmem_cache_alloc() with (object_cache->flags & SLAB_NOLEAKTRACE) == SLAB_NOLEAKTRACE
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/kmemleak.c#L514
(3) Entering kmem_cache_alloc()
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3550
(4) Calling __cache_alloc() with (object_cache->flags & SLAB_NOLEAKTRACE) == SLAB_NOLEAKTRACE
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3552
(5) Entering __cache_alloc()
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3379
(6) Calling __do_cache_alloc() with (object_cache->flags & SLAB_NOLEAKTRACE) == SLAB_NOLEAKTRACE
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3393
(7) Entering __do_cache_alloc()
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3347
(8) Calling ____cache_alloc() with (object_cache->flags & SLAB_NOLEAKTRACE) == SLAB_NOLEAKTRACE
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3356
(9) Entering ____cache_alloc()
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3091
(10) Calling cache_alloc_refill() with (object_cache->flags & SLAB_NOLEAKTRACE) == SLAB_NOLEAKTRACE
    http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3105
(11) Entering cache_alloc_refill()
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L2924
(12) Calling cache_grow() with (object_cache->flags & SLAB_NOLEAKTRACE) == SLAB_NOLEAKTRACE
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3001
(13) Entering cache_grow()
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L2728
(14) Calling alloc_slabmgmt() with (object_cache->flags & SLAB_NOLEAKTRACE) == SLAB_NOLEAKTRACE
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L2778
(15) Entering alloc_slabmgmt()
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L2569
(16) Calling kmem_cache_alloc_node() with (object_cache->slabp_cache->flags & SLAB_NOLEAKTRACE) == 0 ?
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L2577
(17) Entering kmem_cache_alloc_node()
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/include/linux/slab.h#L250
(18) Calling kmem_cache_alloc() with (object_cache->slabp_cache->flags & SLAB_NOLEAKTRACE) == 0 ?
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/include/linux/slab.h#L253
(19) Entering kmem_cache_alloc()
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3550
(20) Calling __cache_alloc() with (object_cache->slabp_cache->flags & SLAB_NOLEAKTRACE) == 0 ?
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3552
(21) Entering __cache_alloc()
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3379
(22) Calling kmemleak_alloc_recursive() with (object_cache->slabp_cache->flags & SLAB_NOLEAKTRACE) == 0 ?
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/slab.c#L3396
(23) Entering kmemleak_alloc_recursive()
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/include/linux/kmemleak.h#L39
(24) Calling kmemleak_alloc() if (object_cache->slabp_cache->flags & SLAB_NOLEAKTRACE) == 0
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/include/linux/kmemleak.h#L44
(25) Entering kmemleak_alloc()
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/kmemleak.c#L853
(26) Calling create_object() again?
     http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/mm/kmemleak.c#L859
