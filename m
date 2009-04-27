Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbZD0JvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbZD0JvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZD0Js3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:29 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754618AbZD0Js2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:28 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 23/30] microblaze_mmu_v1: Enable fork syscall for MMU and add fork as vfork for noMMU
Date: Mon, 27 Apr 2009 10:32:12 +0200
Message-Id: <1240821139-7247-24-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-23-git-send-email-monstr@monstr.eu>
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
 <1240821139-7247-17-git-send-email-monstr@monstr.eu>
 <1240821139-7247-18-git-send-email-monstr@monstr.eu>
 <1240821139-7247-19-git-send-email-monstr@monstr.eu>
 <1240821139-7247-20-git-send-email-monstr@monstr.eu>
 <1240821139-7247-21-git-send-email-monstr@monstr.eu>
 <1240821139-7247-22-git-send-email-monstr@monstr.eu>
 <1240821139-7247-23-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/entry-nommu.S   |    3 ++-
 arch/microblaze/kernel/syscall_table.S |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
index f24b126..89f978a 100644
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
@@ -551,6 +551,7 @@ no_work_pending:
 	rtid	r14, 0
 	nop
 
+sys_fork_wrapper:
 sys_vfork_wrapper:
 	brid	sys_vfork
 	addk	r5, r1, r0
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
index 3bb42ec..0b1bcaf 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -2,7 +2,7 @@ ENTRY(sys_call_table)
 	.long sys_restart_syscall	/* 0 - old "setup()" system call,
 					 * used for restarting */
 	.long sys_exit
-	.long sys_ni_syscall		/* was fork */
+	.long sys_fork_wrapper
 	.long sys_read
 	.long sys_write
 	.long sys_open			/* 5 */
-- 
1.5.5.1

