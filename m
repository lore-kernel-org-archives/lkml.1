Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab0BLWg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:36:26 -0500
Received: from mail.windriver.com ([147.11.1.11]:44076 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab0BLWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:36:25 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 01/28] Move kernel/kgdb.c to kernel/debug/debug_core.c
Date: Fri, 12 Feb 2010 16:35:16 -0600
Message-Id: <1266014143-29444-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:36:03.0708 (UTC) FILETIME=[C25413C0:01CAAC33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move kgdb.c in preparation for to separate the gdbstub from the debug
core and exception handling.n

CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/Makefile                       |    2 +-
 kernel/debug/Makefile                 |    5 +++++
 kernel/{kgdb.c => debug/debug_core.c} |    0
 3 files changed, 6 insertions(+), 1 deletions(-)
 create mode 100644 kernel/debug/Makefile
 rename kernel/{kgdb.c => debug/debug_core.c} (100%)

diff --git a/kernel/Makefile b/kernel/Makefile
index 864ff75..a18b039 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -74,7 +74,7 @@ obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_GCOV_KERNEL) += gcov/
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
-obj-$(CONFIG_KGDB) += kgdb.o
+obj-$(CONFIG_KGDB) += debug/
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
diff --git a/kernel/debug/Makefile b/kernel/debug/Makefile
new file mode 100644
index 0000000..5287fc8
--- /dev/null
+++ b/kernel/debug/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the linux kernel debugger
+#
+
+obj-$(CONFIG_KGDB) += debug_core.o
\ No newline at end of file
diff --git a/kernel/kgdb.c b/kernel/debug/debug_core.c
similarity index 100%
rename from kernel/kgdb.c
rename to kernel/debug/debug_core.c
-- 
1.6.4.rc1

