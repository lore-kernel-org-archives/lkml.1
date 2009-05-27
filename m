Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbZE0RoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbZE0RoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759569AbZE0Rnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:43:49 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:53854 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111AbZE0Rnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:43:47 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v16][PATCH 13/43] c/r: introduce method '->checkpoint()' in struct vm_operations_struct
Date: Wed, 27 May 2009 13:32:39 -0400
Message-Id: <1243445589-32388-14-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 include/linux/mm.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bff1f0d..05f0ed9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -14,6 +14,8 @@
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
 
+#include <linux/checkpoint_types.h>
+
 struct mempolicy;
 struct anon_vma;
 struct file_ra_state;
@@ -220,6 +222,9 @@ struct vm_operations_struct {
 	int (*migrate)(struct vm_area_struct *vma, const nodemask_t *from,
 		const nodemask_t *to, unsigned long flags);
 #endif
+#ifdef CONFIG_CHECKPOINT
+	int (*checkpoint)(struct ckpt_ctx *ctx, struct vm_area_struct *vma);
+#endif
 };
 
 struct mmu_gather;
-- 
1.6.0.4

