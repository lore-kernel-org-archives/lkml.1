Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbYBYAMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbYBYAMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbYBYAJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:09:38 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33667 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbYBYAJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:09:33 -0500
Date: Mon, 25 Feb 2008 02:08:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/oom_kill.c: proper externs
Message-ID: <20080225000838.GM2088@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper extern declarations for three variables in 
include/linux/oom.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/oom.h |    4 ++++
 kernel/sysctl.c     |    4 +---
 2 files changed, 5 insertions(+), 3 deletions(-)

5ac59cd3de28fdad038576ebef6a2ac41c5d7c69 diff --git a/include/linux/oom.h b/include/linux/oom.h
index 3852436..f76bf07 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -23,6 +23,10 @@ enum oom_constraint {
 	CONSTRAINT_MEMORY_POLICY,
 };
 
+extern int sysctl_panic_on_oom;
+extern int sysctl_oom_kill_allocating_task;
+extern int sysctl_oom_dump_tasks;
+
 extern int try_set_zone_oom(struct zonelist *zonelist);
 extern void clear_zonelist_oom(struct zonelist *zonelist);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8b7e954..ffb687c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -45,6 +45,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
+#include <linux/oom.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -64,9 +65,6 @@ extern int C_A_D;
 extern int print_fatal_signals;
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern int sysctl_panic_on_oom;
-extern int sysctl_oom_kill_allocating_task;
-extern int sysctl_oom_dump_tasks;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;

