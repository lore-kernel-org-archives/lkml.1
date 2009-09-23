Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZIXA37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZIXA37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZIXA3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:29:53 -0400
Received: from smtp231.iad.emailsrvr.com ([207.97.245.231]:39156 "EHLO
	smtp231.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZIXA3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:29:21 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Oren Laadan <orenl@librato.com>, Oren Laadan <orenl@cs.columbia.edu>
Subject: [PATCH v18 36/80] c/r: introduce method '->checkpoint()' in struct vm_operations_struct
Date: Wed, 23 Sep 2009 19:51:16 -0400
Message-Id: <1253749920-18673-37-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253749920-18673-1-git-send-email-orenl@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
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
index 9a72cc7..d5ace89 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -19,6 +19,7 @@ struct file_ra_state;
 struct user_struct;
 struct writeback_control;
 struct rlimit;
+struct ckpt_ctx;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -218,6 +219,9 @@ struct vm_operations_struct {
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

