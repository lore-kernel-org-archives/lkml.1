Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbYCFUGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbYCFUGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761507AbYCFUFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:05:35 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25901 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784AbYCFUF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:05:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=sFLBS4IAfzCmf/0UdrfkbZtsmk9y4epn7xqbdgCTFvUMphVXGZ4qSbRU52NVkSCMn
	x4IuzYzgNLRQmKH+dwQYg==
Date: Thu, 6 Mar 2008 12:05:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 3/4] mempolicy: small header file cleanup
In-Reply-To: <alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0803061136160.18590@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com> <alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes forward definition of vm_area_struct in linux/mempolicy.h.  We
already get it from the linux/slab.h -> linux/gfp.h include.

Removes the unused mpol_set_vma_default() macro from linux/mempolicy.h.

Removes the extern definition of default_policy since it is only
referenced, as it should be, in mm/mempolicy.c.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/mempolicy.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -52,7 +52,6 @@ enum {
 #include <linux/spinlock.h>
 #include <linux/nodemask.h>
 
-struct vm_area_struct;
 struct mm_struct;
 
 #ifdef CONFIG_NUMA
@@ -129,10 +128,6 @@ static inline int mpol_equal(struct mempolicy *a, struct mempolicy *b)
 	return __mpol_equal(a, b);
 }
 
-/* Could later add inheritance of the process policy here. */
-
-#define mpol_set_vma_default(vma) ((vma)->vm_policy = NULL)
-
 /*
  * Tree of shared policies for a shared memory region.
  * Maintain the policies in a pseudo mm that contains vmas. The vmas
@@ -168,7 +163,6 @@ extern void mpol_rebind_task(struct task_struct *tsk,
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 extern void mpol_fix_fork_child_flag(struct task_struct *p);
 
-extern struct mempolicy default_policy;
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 		unsigned long addr, gfp_t gfp_flags, struct mempolicy **mpol);
 extern unsigned slab_node(struct mempolicy *policy);
@@ -193,8 +187,6 @@ static inline int mpol_equal(struct mempolicy *a, struct mempolicy *b)
 	return 1;
 }
 
-#define mpol_set_vma_default(vma) do {} while(0)
-
 static inline void mpol_free(struct mempolicy *p)
 {
 }
