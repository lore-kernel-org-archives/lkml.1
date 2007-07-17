Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbXGQLQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbXGQLQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXGQLQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:16:38 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:31237 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbXGQLQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:16:37 -0400
Date: Tue, 17 Jul 2007 15:16:29 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] SLAB_PANIC more (proc, posix-timers, shmem)
Message-ID: <20070717111629.GB25083@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These aren't modular, so SLAB_PANIC is OK.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/inode.c       |    4 +---
 kernel/posix-timers.c |    3 ++-
 mm/shmem.c            |    4 +---
 3 files changed, 4 insertions(+), 7 deletions(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -118,10 +118,8 @@ int __init proc_init_inodecache(void)
 	proc_inode_cachep = kmem_cache_create("proc_inode_cache",
 					     sizeof(struct proc_inode),
 					     0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD),
+						SLAB_MEM_SPREAD|SLAB_PANIC),
 					     init_once, NULL);
-	if (proc_inode_cachep == NULL)
-		return -ENOMEM;
 	return 0;
 }
 
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -241,7 +241,8 @@ static __init int init_posix_timers(void)
 	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
-					sizeof (struct k_itimer), 0, 0, NULL, NULL);
+					sizeof (struct k_itimer), 0, SLAB_PANIC,
+					NULL, NULL);
 	idr_init(&posix_timers_id);
 	return 0;
 }
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2361,9 +2361,7 @@ static int init_inodecache(void)
 {
 	shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
 				sizeof(struct shmem_inode_info),
-				0, 0, init_once, NULL);
-	if (shmem_inode_cachep == NULL)
-		return -ENOMEM;
+				0, SLAB_PANIC, init_once, NULL);
 	return 0;
 }
 

