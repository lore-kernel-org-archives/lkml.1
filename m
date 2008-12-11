Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYLKAXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYLKAXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYLKAXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:23:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59374 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYLKAXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:23:34 -0500
Date: Wed, 10 Dec 2008 19:23:31 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] remove duplicate init_fs
In-Reply-To: <20081210234307.GI28946@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.1.10.0812101922280.29200@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812101832200.21545@gandalf.stny.rr.com> <20081210234307.GI28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: cleanups


Steven Rostedt (1):
      remove duplicate init_fs

----
 arch/alpha/kernel/init_task.c     |    1 -
 arch/arm/kernel/init_task.c       |    1 -
 arch/avr32/kernel/init_task.c     |    1 -
 arch/blackfin/kernel/init_task.c  |    1 -
 arch/cris/kernel/process.c        |    1 -
 arch/frv/kernel/init_task.c       |    1 -
 arch/h8300/kernel/init_task.c     |    1 -
 arch/ia64/kernel/init_task.c      |    1 -
 arch/m32r/kernel/init_task.c      |    1 -
 arch/m68k/kernel/process.c        |    1 -
 arch/m68knommu/kernel/init_task.c |    1 -
 arch/mips/kernel/init_task.c      |    1 -
 arch/mn10300/kernel/init_task.c   |    1 -
 arch/parisc/kernel/init_task.c    |    1 -
 arch/powerpc/kernel/init_task.c   |    1 -
 arch/s390/kernel/init_task.c      |    1 -
 arch/sh/kernel/init_task.c        |    1 -
 arch/sparc/kernel/init_task.c     |    1 -
 arch/sparc64/kernel/init_task.c   |    1 -
 arch/um/kernel/init_task.c        |    1 -
 arch/x86/kernel/init_task.c       |    1 -
 arch/xtensa/kernel/init_task.c    |    1 -
 include/linux/fs_struct.h         |    7 +------
 init/main.c                       |    6 ++++++
 24 files changed, 7 insertions(+), 28 deletions(-)
---------------------------
commit a0f599b0f8479b7e4d7a7fc22150154a4bc26227
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Dec 10 19:18:06 2008 -0500

    remove duplicate init_fs
    
    Impact: clean up
    
    This patch removes the funny INIT_FS macro and creates a single
    init_fs variable in init/main.c for all archs to use.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/alpha/kernel/init_task.c b/arch/alpha/kernel/init_task.c
index 1f76218..c2938e5 100644
--- a/arch/alpha/kernel/init_task.c
+++ b/arch/alpha/kernel/init_task.c
@@ -8,7 +8,6 @@
 #include <asm/uaccess.h>
 
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/arm/kernel/init_task.c b/arch/arm/kernel/init_task.c
index 0bbf806..e859af3 100644
--- a/arch/arm/kernel/init_task.c
+++ b/arch/arm/kernel/init_task.c
@@ -12,7 +12,6 @@
 
 #include <asm/pgtable.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/avr32/kernel/init_task.c b/arch/avr32/kernel/init_task.c
index 4405846..993d56e 100644
--- a/arch/avr32/kernel/init_task.c
+++ b/arch/avr32/kernel/init_task.c
@@ -13,7 +13,6 @@
 
 #include <asm/pgtable.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/blackfin/kernel/init_task.c b/arch/blackfin/kernel/init_task.c
index 6bdba7b..2c228c0 100644
--- a/arch/blackfin/kernel/init_task.c
+++ b/arch/blackfin/kernel/init_task.c
@@ -33,7 +33,6 @@
 #include <linux/mqueue.h>
 #include <linux/fs.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 
diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index 5933656..60816e8 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -37,7 +37,6 @@
  * setup.
  */
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/frv/kernel/init_task.c b/arch/frv/kernel/init_task.c
index e219881..29429a8 100644
--- a/arch/frv/kernel/init_task.c
+++ b/arch/frv/kernel/init_task.c
@@ -10,7 +10,6 @@
 #include <asm/pgtable.h>
 
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/h8300/kernel/init_task.c b/arch/h8300/kernel/init_task.c
index 93a4899..cb5dc55 100644
--- a/arch/h8300/kernel/init_task.c
+++ b/arch/h8300/kernel/init_task.c
@@ -12,7 +12,6 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/ia64/kernel/init_task.c b/arch/ia64/kernel/init_task.c
index 9d7e1c6..5b0e830 100644
--- a/arch/ia64/kernel/init_task.c
+++ b/arch/ia64/kernel/init_task.c
@@ -17,7 +17,6 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/m32r/kernel/init_task.c b/arch/m32r/kernel/init_task.c
index 0d658db..016885c 100644
--- a/arch/m32r/kernel/init_task.c
+++ b/arch/m32r/kernel/init_task.c
@@ -11,7 +11,6 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 3042c2b..632ce01 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -40,7 +40,6 @@
  * alignment requirements and potentially different initial
  * setup.
  */
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/m68knommu/kernel/init_task.c b/arch/m68knommu/kernel/init_task.c
index 344c01a..fe282de 100644
--- a/arch/m68knommu/kernel/init_task.c
+++ b/arch/m68knommu/kernel/init_task.c
@@ -12,7 +12,6 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/mips/kernel/init_task.c b/arch/mips/kernel/init_task.c
index d72487a..149cd91 100644
--- a/arch/mips/kernel/init_task.c
+++ b/arch/mips/kernel/init_task.c
@@ -9,7 +9,6 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/mn10300/kernel/init_task.c b/arch/mn10300/kernel/init_task.c
index af16f6e..5ac3566 100644
--- a/arch/mn10300/kernel/init_task.c
+++ b/arch/mn10300/kernel/init_task.c
@@ -18,7 +18,6 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/parisc/kernel/init_task.c b/arch/parisc/kernel/init_task.c
index f5941c0..1e25a45 100644
--- a/arch/parisc/kernel/init_task.c
+++ b/arch/parisc/kernel/init_task.c
@@ -34,7 +34,6 @@
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/powerpc/kernel/init_task.c b/arch/powerpc/kernel/init_task.c
index 4c85b8d..688b329 100644
--- a/arch/powerpc/kernel/init_task.c
+++ b/arch/powerpc/kernel/init_task.c
@@ -7,7 +7,6 @@
 #include <linux/mqueue.h>
 #include <asm/uaccess.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/s390/kernel/init_task.c b/arch/s390/kernel/init_task.c
index e807168..7db95c0 100644
--- a/arch/s390/kernel/init_task.c
+++ b/arch/s390/kernel/init_task.c
@@ -16,7 +16,6 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/sh/kernel/init_task.c b/arch/sh/kernel/init_task.c
index b151a25..80c35ff 100644
--- a/arch/sh/kernel/init_task.c
+++ b/arch/sh/kernel/init_task.c
@@ -7,7 +7,6 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct pt_regs fake_swapper_regs;
diff --git a/arch/sparc/kernel/init_task.c b/arch/sparc/kernel/init_task.c
index 8e64ebc..94fcae3 100644
--- a/arch/sparc/kernel/init_task.c
+++ b/arch/sparc/kernel/init_task.c
@@ -8,7 +8,6 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/sparc64/kernel/init_task.c b/arch/sparc64/kernel/init_task.c
index d2b3123..84fb09e 100644
--- a/arch/sparc64/kernel/init_task.c
+++ b/arch/sparc64/kernel/init_task.c
@@ -9,7 +9,6 @@
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/um/kernel/init_task.c b/arch/um/kernel/init_task.c
index 910eda8..806d381 100644
--- a/arch/um/kernel/init_task.c
+++ b/arch/um/kernel/init_task.c
@@ -10,7 +10,6 @@
 #include "linux/mqueue.h"
 #include "asm/uaccess.h"
 
-static struct fs_struct init_fs = INIT_FS;
 struct mm_struct init_mm = INIT_MM(init_mm);
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
index a4f93b4..42dcd6e 100644
--- a/arch/x86/kernel/init_task.c
+++ b/arch/x86/kernel/init_task.c
@@ -10,7 +10,6 @@
 #include <asm/pgtable.h>
 #include <asm/desc.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/arch/xtensa/kernel/init_task.c b/arch/xtensa/kernel/init_task.c
index 3df469d..e07f5c9 100644
--- a/arch/xtensa/kernel/init_task.c
+++ b/arch/xtensa/kernel/init_task.c
@@ -21,7 +21,6 @@
 
 #include <asm/uaccess.h>
 
-static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 9e5a06e..ab79e82 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -10,12 +10,7 @@ struct fs_struct {
 	struct path root, pwd;
 };
 
-#define INIT_FS {				\
-	.count		= ATOMIC_INIT(1),	\
-	.lock		= RW_LOCK_UNLOCKED,	\
-	.umask		= 0022, \
-}
-
+extern struct fs_struct init_fs;
 extern struct kmem_cache *fs_cachep;
 
 extern void exit_fs(struct task_struct *);
diff --git a/init/main.c b/init/main.c
index 7e117a2..0801e74 100644
--- a/init/main.c
+++ b/init/main.c
@@ -108,6 +108,12 @@ extern void tc_init(void);
 enum system_states system_state;
 EXPORT_SYMBOL(system_state);
 
+struct fs_struct init_fs = {
+	.count		= ATOMIC_INIT(1),
+	.lock		= __RW_LOCK_UNLOCKED(init_fs.lock),
+	.umask		= 0022,
+};
+
 /*
  * Boot command-line arguments
  */


