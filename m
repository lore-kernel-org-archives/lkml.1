Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZKURqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZKURqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 12:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbZKURqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 12:46:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:46942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552AbZKURqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 12:46:15 -0500
Subject: [PATCH] mm: includecheck fix slqb
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 21 Nov 2009 23:14:43 +0530
Message-Id: <1258825483.5364.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warnings:

  include/linux/slqb_def.h: linux/kobject.h is included more than once.
  mm/slqb.c: linux/seq_file.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/slqb_def.h |    1 -
 mm/slqb.c                |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/slqb_def.h b/include/linux/slqb_def.h
index 1243dda..1cb68cc 100644
--- a/include/linux/slqb_def.h
+++ b/include/linux/slqb_def.h
@@ -13,7 +13,6 @@
 #include <linux/rcu_types.h>
 #include <linux/mm_types.h>
 #include <linux/kernel.h>
-#include <linux/kobject.h>
 
 #define SLAB_NUMA		0x00000001UL    /* shortcut */
 
diff --git a/mm/slqb.c b/mm/slqb.c
index e4bb53f..e84a588 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -3302,7 +3302,6 @@ static void gather_stats(struct kmem_cache *s, struct stats_gather *stats)
  */
 #ifdef CONFIG_SLABINFO
 #include <linux/proc_fs.h>
-#include <linux/seq_file.h>
 ssize_t slabinfo_write(struct file *file, const char __user * buffer,
 		       size_t count, loff_t *ppos)
 {
-- 
1.6.0.6



