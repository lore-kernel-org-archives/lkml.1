Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZLAGnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZLAGnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZLAGnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:43:49 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42665 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbZLAGnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:43:45 -0500
Date: Tue, 1 Dec 2009 17:43:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: linux-next: manual merge of the percpu tree with the slab tree
Message-Id: <20091201174349.f72f36bd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the percpu tree got a conflict in mm/slab.c
between commit ce79ddc8e2376a9a93c7d42daf89bfcbb9187e62 ("SLAB: Fix
lockdep annotations for CPU hotplug") from the slab tree and commit
1871e52c76dd95895caeb772f845a1718dcbcd75 ("percpu: make percpu symbols
under kernel/ and mm/ unique") from the percpu tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/slab.c
index 6ad48a7,211b174..0000000
--- a/mm/slab.c
+++ b/mm/slab.c
@@@ -697,7 -665,27 +697,7 @@@ static inline void init_lock_keys(void
  static DEFINE_MUTEX(cache_chain_mutex);
  static struct list_head cache_chain;
  
- static DEFINE_PER_CPU(struct delayed_work, reap_work);
 -/*
 - * chicken and egg problem: delay the per-cpu array allocation
 - * until the general caches are up.
 - */
 -static enum {
 -	NONE,
 -	PARTIAL_AC,
 -	PARTIAL_L3,
 -	EARLY,
 -	FULL
 -} g_cpucache_up;
 -
 -/*
 - * used by boot code to determine if it can use slab based allocator
 - */
 -int slab_is_available(void)
 -{
 -	return g_cpucache_up >= EARLY;
 -}
 -
+ static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
  
  static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
  {
