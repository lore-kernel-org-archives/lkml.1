Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbZF0OJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbZF0OJP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 10:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbZF0OI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 10:08:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZF0OIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 10:08:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/6] score: add missing #includes
Date: Sat, 27 Jun 2009 16:08:13 +0200
Message-Id: <9fb24cc50045ec8d13d0a6c3d4d454750b466d61.1246111364.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
In-Reply-To: <cover.1246111364.git.arnd@arndb.de>
References: <cover.1246111364.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+xE0nlDprixZWeg4JONapZ6DjL0NinMp2+tvX
 suZpX89A4wxwlHY9Cqd+3fF7g14gedaOmNZYEGtGFWwYmOfkM3
 WUQ8Rg4b0doKRqa9ebxbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Files that define a global function should #include the
header with its declaration to make sure that the prototypes
do not diverge.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/score/include/asm/ucontext.h |    1 +
 arch/score/kernel/module.c        |    1 +
 arch/score/kernel/process.c       |    3 +++
 arch/score/kernel/signal.c        |    4 +++-
 arch/score/kernel/sys_score.c     |    2 ++
 5 files changed, 10 insertions(+), 1 deletions(-)
 create mode 100644 arch/score/include/asm/ucontext.h

diff --git a/arch/score/include/asm/ucontext.h b/arch/score/include/asm/ucontext.h
new file mode 100644
index 0000000..9bc07b9
--- /dev/null
+++ b/arch/score/include/asm/ucontext.h
@@ -0,0 +1 @@
+#include <asm-generic/ucontext.h>
diff --git a/arch/score/kernel/module.c b/arch/score/kernel/module.c
index 4ffce7f..1a62557 100644
--- a/arch/score/kernel/module.c
+++ b/arch/score/kernel/module.c
@@ -23,6 +23,7 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/moduleloader.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 
diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
index d93966f..25d0803 100644
--- a/arch/score/kernel/process.c
+++ b/arch/score/kernel/process.c
@@ -24,6 +24,9 @@
  */
 
 #include <linux/module.h>
+#include <linux/reboot.h>
+#include <linux/elfcore.h>
+#include <linux/pm.h>
 
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
index 5c00408..252f6d9 100644
--- a/arch/score/kernel/signal.c
+++ b/arch/score/kernel/signal.c
@@ -27,7 +27,9 @@
 #include <linux/signal.h>
 #include <linux/unistd.h>
 #include <linux/uaccess.h>
-#include <asm-generic/ucontext.h>
+
+#include <asm/syscalls.h>
+#include <asm/ucontext.h>
 
 #include <asm/cacheflush.h>
 
diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
index 3318861..eb4d2d3 100644
--- a/arch/score/kernel/sys_score.c
+++ b/arch/score/kernel/sys_score.c
@@ -28,6 +28,8 @@
 #include <linux/mman.h>
 #include <linux/module.h>
 #include <linux/unistd.h>
+#include <linux/syscalls.h>
+#include <asm/syscalls.h>
 
 unsigned long shm_align_mask = PAGE_SIZE - 1;
 EXPORT_SYMBOL(shm_align_mask);
-- 
1.6.3.1

