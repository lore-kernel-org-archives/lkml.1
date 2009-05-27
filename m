Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbZE0H3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbZE0H3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762270AbZE0H0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:15 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46913 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762259AbZE0H0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:26:13 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 14/29] microblaze_mmu_v2: MMU asm offset update
Date: Wed, 27 May 2009 08:47:39 +0200
Message-Id: <1243406874-3917-15-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-14-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
 <1243406874-3917-13-git-send-email-monstr@monstr.eu>
 <1243406874-3917-14-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/asm-offsets.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/kernel/asm-offsets.c b/arch/microblaze/kernel/asm-offsets.c
index aabd9e9..7bc7b68 100644
--- a/arch/microblaze/kernel/asm-offsets.c
+++ b/arch/microblaze/kernel/asm-offsets.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (C) 2007-2009 Michal Simek <monstr@monstr.eu>
  * Copyright (C) 2007-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
@@ -68,16 +69,26 @@ int main(int argc, char *argv[])
 
 	/* struct task_struct */
 	DEFINE(TS_THREAD_INFO, offsetof(struct task_struct, stack));
+#ifdef CONFIG_MMU
+	DEFINE(TASK_STATE, offsetof(struct task_struct, state));
+	DEFINE(TASK_FLAGS, offsetof(struct task_struct, flags));
+	DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
+	DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
+	DEFINE(TASK_MM, offsetof(struct task_struct, mm));
+	DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
+	DEFINE(TASK_PID, offsetof(struct task_struct, pid));
+	DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
+	DEFINE(THREAD_KSP, offsetof(struct thread_struct, ksp));
+	BLANK();
+
+	DEFINE(PGDIR, offsetof(struct thread_struct, pgdir));
+	BLANK();
+#endif
 
 	/* struct thread_info */
 	DEFINE(TI_TASK, offsetof(struct thread_info, task));
-	DEFINE(TI_EXEC_DOMAIN, offsetof(struct thread_info, exec_domain));
 	DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));
-	DEFINE(TI_STATUS, offsetof(struct thread_info, status));
-	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
-	DEFINE(TI_PRE_COUNT, offsetof(struct thread_info, preempt_count));
 	DEFINE(TI_ADDR_LIMIT, offsetof(struct thread_info, addr_limit));
-	DEFINE(TI_RESTART_BLOCK, offsetof(struct thread_info, restart_block));
 	DEFINE(TI_CPU_CONTEXT, offsetof(struct thread_info, cpu_context));
 	BLANK();
 
-- 
1.5.5.1

