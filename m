Return-Path: <linux-kernel-owner+w=401wt.eu-S1750864AbZJEECI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750864AbZJEECI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 00:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZJEECH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 00:02:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53076 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZJEECG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 00:02:06 -0400
X-Greylist: delayed 2764 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 00:02:05 EDT
Message-Id: <200910050315.n953FCD9030264@www262.sakura.ne.jp>
Subject: [2.6.32-rc3 kmemleak] WARNING: at kernel/lockdep.c:3161 check_flags+0xbe/0x180()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: catalin.marinas@arm.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Oct 2009 12:15:12 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 04102009 #2694786, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I got this error.

[    0.000000] Linux version 2.6.32-rc3 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #1 SMP Mon Oct 5 11:24:05 JST 2009
(...snipped...)
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at kernel/lockdep.c:3161 check_flags+0xbe/0x180()
[    0.000000] Hardware name: VMware Virtual Platform
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32-rc3 #1
[    0.000000] Call Trace:
[    0.000000]  [<c104182d>] ? printk+0x1d/0x30
[    0.000000]  [<c107069e>] ? check_flags+0xbe/0x180
[    0.000000]  [<c1040de1>] warn_slowpath_common+0x81/0xa0
[    0.000000]  [<c107069e>] ? check_flags+0xbe/0x180
[    0.000000]  [<c1040e5a>] warn_slowpath_null+0x1a/0x30
[    0.000000]  [<c107069e>] check_flags+0xbe/0x180
[    0.000000]  [<c106e52e>] lockdep_trace_alloc+0x2e/0x60
[    0.000000]  [<c10cfedd>] kmem_cache_alloc+0x2d/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c106e22b>] ? trace_hardirqs_on+0xb/0x10
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cf9c4>] ? cache_alloc_refill+0x144/0x210
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cef9f>] alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10cf3de>] cache_grow+0xae/0x170
[    0.000000]  [<c10cf9fb>] cache_alloc_refill+0x17b/0x210
[    0.000000]  [<c10d005a>] kmem_cache_alloc+0x1aa/0x1d0
[    0.000000]  [<c10cd9b8>] ? obj_size+0x8/0x10
[    0.000000]  [<c10d3969>] ? create_object+0x29/0x220
[    0.000000]  [<c10d3969>] create_object+0x29/0x220
[    0.000000]  [<c10cd9a8>] ? obj_offset+0x8/0x10
[    0.000000]  [<c10ce07a>] ? poison_obj+0x2a/0x50
[    0.000000]  [<c1321693>] kmemleak_alloc+0x83/0xd0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  [<c10d0035>] kmem_cache_alloc+0x185/0x1d0
[    0.000000]  [<c106e1b7>] ? trace_hardirqs_on_caller+0xf7/0x160
[    0.000000]  [<c10cef9f>] ? alloc_slabmgmt+0x5f/0x80
[    0.000000]  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>  <IRQ>(...snipped...)

Adding kmemleak=off to kernel command line solves this error.
Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.32-rc3

By the way,
> static void early_alloc(struct early_log *log)
> {
>         struct kmemleak_object *object;
>         unsigned long flags;
>         int i;
> 
>         if (!atomic_read(&kmemleak_enabled) || !log->ptr || IS_ERR(log->ptr))
>                 return;
> 
>         /*
>          * RCU locking needed to ensure object is not freed via put_object().
>          */
>         rcu_read_lock();
>         object = create_object((unsigned long)log->ptr, log->size,
>                                log->min_count, GFP_KERNEL);
I think we can't use GFP_KERNEL inside rcu_read_lock()...
>         spin_lock_irqsave(&object->lock, flags);
>         for (i = 0; i < log->trace_len; i++)
>                 object->trace[i] = log->trace[i];
>         object->trace_len = log->trace_len;
>         spin_unlock_irqrestore(&object->lock, flags);
>         rcu_read_unlock();
> }

[PATCH 2.6.32-rc3] kmemleak: Use GFP_ATOMIC for early_alloc().

We can't use GFP_KERNEL inside rcu_read_lock().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32-rc3.orig/mm/kmemleak.c
+++ linux-2.6.32-rc3/mm/kmemleak.c
@@ -833,7 +833,7 @@ static void early_alloc(struct early_log
 	 */
 	rcu_read_lock();
 	object = create_object((unsigned long)log->ptr, log->size,
-			       log->min_count, GFP_KERNEL);
+			       log->min_count, GFP_ATOMIC);
 	spin_lock_irqsave(&object->lock, flags);
 	for (i = 0; i < log->trace_len; i++)
 		object->trace[i] = log->trace[i];

Regards.
