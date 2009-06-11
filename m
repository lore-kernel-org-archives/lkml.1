Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbZFKWnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbZFKWnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbZFKWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:43:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:37103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbZFKWnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:43:10 -0400
Message-ID: <4A31881C.6070602@kernel.org>
Date: Thu, 11 Jun 2009 15:41:32 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mpm@selenic.com, npiggin@suse.de
Subject: Re: [GIT PULL v3] Early boot SLAB for 2.6.31
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain> <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906110954030.29827@gentwo.org> <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com> <84144f020906110824g7b3981abmdbcf94ae2f9068de@mail.gmail.com> <4A3143E3.3090705@kernel.org> <Pine.LNX.4.64.0906112101020.21593@melkki.cs.Helsinki.FI> <20090611214342.GA12762@elte.hu> <20090611220307.GA16180@elte.hu>
In-Reply-To: <20090611220307.GA16180@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i also get this different warning, again:
> 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at mm/bootmem.c:537 alloc_arch_preferred_bootmem+0x2b/0x71()
> [    0.000000] Hardware name: System Product Name
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Tainted: G        W  2.6.30-tip-03087-g0bb2618-dirty #52506
> [    0.000000] Call Trace:
> [    0.000000]  [<81032588>] warn_slowpath_common+0x60/0x90
> [    0.000000]  [<810325c5>] warn_slowpath_null+0xd/0x10
> [    0.000000]  [<819d1bc0>] alloc_arch_preferred_bootmem+0x2b/0x71
> [    0.000000]  [<819d1c31>] ___alloc_bootmem_nopanic+0x2b/0x9a
> [    0.000000]  [<81050a0a>] ? lock_release+0xac/0xb2
> [    0.000000]  [<819d1d4c>] ___alloc_bootmem+0xe/0x2d
> [    0.000000]  [<819d1e9f>] __alloc_bootmem+0xa/0xc
> [    0.000000]  [<819d7c63>] alloc_bootmem_cpumask_var+0x21/0x26
> [    0.000000]  [<819d0cc8>] early_irq_init+0x15/0x10d
> [    0.000000]  [<819bb75a>] start_kernel+0x167/0x326
> [    0.000000]  [<819bb06b>] __init_begin+0x6b/0x70
> [    0.000000] ---[ end trace 4eaa2a86a8e2da23 ]---
> [    0.000000] NR_IRQS:2304 nr_irqs:424
> [    0.000000] CPU 0 irqstacks, hard=821e6000 soft=821e7000
> 

please check

[PATCH] irq: slab alloc for default irq_affinity

Ingo had

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at mm/bootmem.c:537 alloc_arch_preferred_bootmem+0x2b/0x71()
[    0.000000] Hardware name: System Product Name
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Tainted: G        W  2.6.30-tip-03087-g0bb2618-dirty #52506
[    0.000000] Call Trace:
[    0.000000]  [<81032588>] warn_slowpath_common+0x60/0x90
[    0.000000]  [<810325c5>] warn_slowpath_null+0xd/0x10
[    0.000000]  [<819d1bc0>] alloc_arch_preferred_bootmem+0x2b/0x71
[    0.000000]  [<819d1c31>] ___alloc_bootmem_nopanic+0x2b/0x9a
[    0.000000]  [<81050a0a>] ? lock_release+0xac/0xb2
[    0.000000]  [<819d1d4c>] ___alloc_bootmem+0xe/0x2d
[    0.000000]  [<819d1e9f>] __alloc_bootmem+0xa/0xc
[    0.000000]  [<819d7c63>] alloc_bootmem_cpumask_var+0x21/0x26
[    0.000000]  [<819d0cc8>] early_irq_init+0x15/0x10d
[    0.000000]  [<819bb75a>] start_kernel+0x167/0x326
[    0.000000]  [<819bb06b>] __init_begin+0x6b/0x70
[    0.000000] ---[ end trace 4eaa2a86a8e2da23 ]---
[    0.000000] NR_IRQS:2304 nr_irqs:424
[    0.000000] CPU 0 irqstacks, hard=821e6000 soft=821e7000

we need to update init_irq_default_affinity

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/handle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -45,7 +45,7 @@ void handle_bad_irq(unsigned int irq, st
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 static void __init init_irq_default_affinity(void)
 {
-	alloc_bootmem_cpumask_var(&irq_default_affinity);
+	alloc_cpumask_var(&irq_default_affinity, GFP_NOWAIT);
 	cpumask_setall(irq_default_affinity);
 }
 #else
