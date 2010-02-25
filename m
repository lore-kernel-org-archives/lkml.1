Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab0BYVWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:22:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:63524 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933801Ab0BYVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:22:27 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 01/28] Move kernel/kgdb.c to kernel/debug/debug_core.c
Date: Thu, 25 Feb 2010 15:21:06 -0600
Message-Id: <1267132893-23624-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Feb 2010 21:21:40.0414 (UTC) FILETIME=[855E35E0:01CAB660]
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

