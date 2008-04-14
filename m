Return-Path: <linux-kernel-owner+w=401wt.eu-S1765625AbYDNSQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765625AbYDNSQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765018AbYDNSOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:14:45 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56882 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765012AbYDNSOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:14:44 -0400
Date: Mon, 14 Apr 2008 21:13:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make struct mempolicy.c:default_policy static
Message-ID: <20080414181338.GG6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct default_policy static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 22 Feb 2008

4a69fc08292ebe8b7d202436a71926950a980c21 diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 59c4865..fd20b03 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -149,7 +149,6 @@ extern void mpol_rebind_task(struct task_struct *tsk,
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 extern void mpol_fix_fork_child_flag(struct task_struct *p);
 
-extern struct mempolicy default_policy;
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 		unsigned long addr, gfp_t gfp_flags, struct mempolicy **mpol);
 extern unsigned slab_node(struct mempolicy *policy);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6c7ba1a..f3118a8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -105,7 +105,7 @@ static struct kmem_cache *sn_cache;
    policied. */
 enum zone_type policy_zone = 0;
 
-struct mempolicy default_policy = {
+static struct mempolicy default_policy = {
 	.refcnt = ATOMIC_INIT(1), /* never free it */
 	.policy = MPOL_DEFAULT,
 };

