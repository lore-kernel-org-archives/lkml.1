Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbZGVKOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbZGVKOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZGVKOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:14:42 -0400
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:57001 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbZGVKKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:10:50 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Oren Laadan <orenl@librato.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v17][PATCH 37/60] c/r: introduce method '->checkpoint()' in struct vm_operations_struct
Date: Wed, 22 Jul 2009 05:59:59 -0400
Message-Id: <1248256822-23416-38-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248256822-23416-1-git-send-email-orenl@librato.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog[v17]
  - Forward-declare 'ckpt_ctx et-al, don't use checkpoint_types.h

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 include/linux/mm.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ba3a7cb..0e46e95 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -19,6 +19,7 @@ struct file_ra_state;
 struct user_struct;
 struct writeback_control;
 struct rlimit;
+struct ckpt_ctx;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -220,6 +221,9 @@ struct vm_operations_struct {
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

