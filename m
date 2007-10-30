Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbXJ3XvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbXJ3XvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbXJ3Xum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:50:42 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35813 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758111AbXJ3Xul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:50:41 -0400
Date: Wed, 31 Oct 2007 00:50:39 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper show_interrupts() prototype
Message-ID: <20071030235039.GU7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for show_interrupts() in 
include/linux/interrupt.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/h8300/kernel/irq.c   |    1 +
 fs/proc/proc_misc.c       |    2 +-
 include/linux/interrupt.h |    2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

3884100dff673abe8667f2e53586ecd705e7af24 
diff --git a/arch/h8300/kernel/irq.c b/arch/h8300/kernel/irq.c
index 8dec4dd..5a1b4cf 100644
--- a/arch/h8300/kernel/irq.c
+++ b/arch/h8300/kernel/irq.c
@@ -14,6 +14,7 @@
 #include <linux/random.h>
 #include <linux/bootmem.h>
 #include <linux/irq.h>
+#include <linux/interrupt.h>
 
 #include <asm/system.h>
 #include <asm/traps.h>
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index e0d064e..6357ac2 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -46,6 +46,7 @@
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
+#include <linux/interrupt.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
@@ -598,7 +599,6 @@ static void int_seq_stop(struct seq_file *f, void *v)
 }
 
 
-extern int show_interrupts(struct seq_file *f, void *v); /* In arch code */
 static struct seq_operations int_seq_ops = {
 	.start = int_seq_start,
 	.next  = int_seq_next,
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2306920..e194afc 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -443,4 +443,6 @@ static inline void init_irq_proc(void)
 }
 #endif
 
+int show_interrupts(struct seq_file *p, void *v);
+
 #endif

