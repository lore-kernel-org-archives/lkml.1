Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab0BGLb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 06:31:27 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44352 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933686Ab0BGLbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GrkeKZSviZb7ZTWQw/u3Y/xlLqoZdmrrBYpC2KVaplelVj9P+0JUtgh0/bl5GpemLz
         BAizctSISrXWepwtvUhY0p4im1seIZ+lHs4eF3824nKlXPdrRQt6TCIsrfPWrUQvvoGT
         kY3dywrW+J0Ttc7taQhR5+6gy/jc07oFXEEhw=
From: highguy@gmail.com
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       andrea@suse.de, tglx@linutronix.de, akpm@linux-foundation.org,
       peterz@infradead.org, Stijn Devriendt <HIGHGuY@gmail.com>
Subject: [PATCH 4/6] Fix HW breakpoint handlers
Date: Sun,  7 Feb 2010 12:30:57 +0100
Message-Id: <1265542259-5596-5-git-send-email-HIGHGuY@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265542259-5596-4-git-send-email-HIGHGuY@gmail.com>
References: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-2-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-3-git-send-email-HIGHGuY@gmail.com>
 <1265542259-5596-4-git-send-email-HIGHGuY@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stijn Devriendt <HIGHGuY@gmail.com>

---
 arch/x86/include/asm/hw_breakpoint.h |    2 +-
 arch/x86/kernel/hw_breakpoint.c      |    2 +-
 kernel/hw_breakpoint.c               |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0675a7c..d060a5c 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -54,7 +54,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 
 int arch_install_hw_breakpoint(struct perf_event *bp);
 void arch_uninstall_hw_breakpoint(struct perf_event *bp);
-void hw_breakpoint_pmu_read(struct perf_event *bp);
+void hw_breakpoint_pmu_update(struct perf_event *bp);
 void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
 
 extern void
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 05d5fec..55469e0 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -543,7 +543,7 @@ int __kprobes hw_breakpoint_exceptions_notify(
 	return hw_breakpoint_handler(data);
 }
 
-void hw_breakpoint_pmu_read(struct perf_event *bp)
+void hw_breakpoint_pmu_update(struct perf_event *bp)
 {
 	/* TODO */
 }
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index dbcbf6a..16b3a9b 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -448,6 +448,6 @@ core_initcall(init_hw_breakpoint);
 struct pmu perf_ops_bp = {
 	.enable		= arch_install_hw_breakpoint,
 	.disable	= arch_uninstall_hw_breakpoint,
-	.read		= hw_breakpoint_pmu_read,
+	.update		= hw_breakpoint_pmu_update,
 	.unthrottle	= hw_breakpoint_pmu_unthrottle
 };
-- 
1.6.6

