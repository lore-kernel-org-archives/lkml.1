Return-Path: <linux-kernel-owner+w=401wt.eu-S1762802AbZE0H3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762802AbZE0H3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762241AbZE0H0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:08 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46910 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762235AbZE0H0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:26:06 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 21/29] microblaze_mmu_v2: Enable fork syscall for MMU and add fork as vfork for noMMU
Date: Wed, 27 May 2009 08:47:46 +0200
Message-Id: <1243406874-3917-22-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-21-git-send-email-monstr@monstr.eu>
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
 <1243406874-3917-15-git-send-email-monstr@monstr.eu>
 <1243406874-3917-16-git-send-email-monstr@monstr.eu>
 <1243406874-3917-17-git-send-email-monstr@monstr.eu>
 <1243406874-3917-18-git-send-email-monstr@monstr.eu>
 <1243406874-3917-19-git-send-email-monstr@monstr.eu>
 <1243406874-3917-20-git-send-email-monstr@monstr.eu>
 <1243406874-3917-21-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/entry-nommu.S   |    2 +-
 arch/microblaze/kernel/syscall_table.S |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
index f24b126..1fce6b8 100644
--- a/arch/microblaze/kernel/entry-nommu.S
+++ b/arch/microblaze/kernel/entry-nommu.S
@@ -10,7 +10,7 @@
 
 #include <linux/linkage.h>
 #include <asm/thread_info.h>
-#include <asm/errno.h>
+#include <linux/errno.h>
 #include <asm/entry.h>
 #include <asm/asm-offsets.h>
 #include <asm/registers.h>
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
index 3bb42ec..376d178 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -2,7 +2,11 @@ ENTRY(sys_call_table)
 	.long sys_restart_syscall	/* 0 - old "setup()" system call,
 					 * used for restarting */
 	.long sys_exit
-	.long sys_ni_syscall		/* was fork */
+#ifdef CONFIG_MMU
+	.long sys_fork_wrapper
+#else
+	.long sys_ni_syscall
+#endif
 	.long sys_read
 	.long sys_write
 	.long sys_open			/* 5 */
-- 
1.5.5.1

