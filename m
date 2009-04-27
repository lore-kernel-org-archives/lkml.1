Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZD0JuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZD0JuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZD0JsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:24 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754152AbZD0JsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:23 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 16/30] microblaze_mmu_v1: MMU asm offset update
Date: Mon, 27 Apr 2009 10:32:05 +0200
Message-Id: <1240821139-7247-17-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-16-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
 <1240821139-7247-6-git-send-email-monstr@monstr.eu>
 <1240821139-7247-7-git-send-email-monstr@monstr.eu>
 <1240821139-7247-8-git-send-email-monstr@monstr.eu>
 <1240821139-7247-9-git-send-email-monstr@monstr.eu>
 <1240821139-7247-10-git-send-email-monstr@monstr.eu>
 <1240821139-7247-11-git-send-email-monstr@monstr.eu>
 <1240821139-7247-12-git-send-email-monstr@monstr.eu>
 <1240821139-7247-13-git-send-email-monstr@monstr.eu>
 <1240821139-7247-14-git-send-email-monstr@monstr.eu>
 <1240821139-7247-15-git-send-email-monstr@monstr.eu>
 <1240821139-7247-16-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/asm-offsets.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/kernel/asm-offsets.c b/arch/microblaze/kernel/asm-offsets.c
index aabd9e9..362de6c 100644
--- a/arch/microblaze/kernel/asm-offsets.c
+++ b/arch/microblaze/kernel/asm-offsets.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (C) 2007-2009 Michal Simek <monstr@monstr.eu>
  * Copyright (C) 2007-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
@@ -68,6 +69,21 @@ int main(int argc, char *argv[])
 
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
-- 
1.5.5.1

