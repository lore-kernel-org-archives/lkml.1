Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZCFT7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZCFT7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZCFT7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:59:13 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:37114 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZCFT7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:59:13 -0500
Date: Fri, 6 Mar 2009 13:59:11 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <haveblue@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Cedric Le Goater <clg@fr.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 1/3] cr: move CR_BAD_VM_FLAGS to header file
Message-ID: <20090306195911.GA9512@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ this set is on top of Dave's c/r tree ]

We'll be using it from files other than ckpt_mem.c soon.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 checkpoint/ckpt_mem.c      |    3 ---
 include/linux/checkpoint.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/checkpoint/ckpt_mem.c b/checkpoint/ckpt_mem.c
index 4925ff2..b2531f7 100644
--- a/checkpoint/ckpt_mem.c
+++ b/checkpoint/ckpt_mem.c
@@ -448,9 +448,6 @@ static int cr_write_vma(struct cr_ctx *ctx, struct vm_area_struct *vma)
 	hh->vm_flags = vma->vm_flags;
 	hh->vm_pgoff = vma->vm_pgoff;
 
-#define CR_BAD_VM_FLAGS  \
-	(VM_SHARED | VM_MAYSHARE | VM_IO | VM_HUGETLB | VM_NONLINEAR)
-
 	if (vma->vm_flags & CR_BAD_VM_FLAGS) {
 		pr_warning("c/r: unsupported VMA %#lx\n", vma->vm_flags);
 		cr_hbuf_put(ctx, sizeof(*hh));
diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index e77393f..6c31c1b 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -18,6 +18,9 @@
 
 #define CR_VERSION  2
 
+#define CR_BAD_VM_FLAGS  \
+	(VM_SHARED | VM_MAYSHARE | VM_IO | VM_HUGETLB | VM_NONLINEAR)
+
 struct cr_ctx {
 	int crid;		/* unique checkpoint id */
 
-- 
1.5.4.3

