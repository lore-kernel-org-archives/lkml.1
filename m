Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZIOIjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZIOIjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZIOIjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:39:00 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:52789 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZIOIi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:38:59 -0400
Date: Tue, 15 Sep 2009 10:39:04 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH] MIPS: Make more use of unreachable()
Message-ID: <20090915083904.GA13796@linux-mips.org>
References: <4AAEBAC2.1050905@caviumnetworks.com> <1252965340-31735-3-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252965340-31735-3-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further uses of unreachable().

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/fw/arc/memory.c     |    5 +++--
 arch/mips/kernel/signal.c     |    5 +++--
 arch/mips/kernel/signal32.c   |    5 +++--
 arch/mips/kernel/signal_n32.c |    3 ++-
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/mips/fw/arc/memory.c b/arch/mips/fw/arc/memory.c
index 8b8eea2..d248f64 100644
--- a/arch/mips/fw/arc/memory.c
+++ b/arch/mips/fw/arc/memory.c
@@ -11,6 +11,7 @@
  * because on some machines like SGI IP27 the ARC memory configuration data
  * completly bogus and alternate easier to use mechanisms are available.
  */
+#include <linux/compiler.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -80,7 +81,7 @@ static inline int memtype_classify_arcs(union linux_memtypes type)
 	default:
 		BUG();
 	}
-	while(1);				/* Nuke warning.  */
+	unreachable();				/* Nuke warning.  */
 }
 
 static inline int memtype_classify_arc(union linux_memtypes type)
@@ -100,7 +101,7 @@ static inline int memtype_classify_arc(union linux_memtypes type)
 	default:
 		BUG();
 	}
-	while(1);				/* Nuke warning.  */
+	unreachable();				/* Nuke warning.  */
 }
 
 static int __init prom_memtype_classify(union linux_memtypes type)
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index 6254041..eefd278 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -8,6 +8,7 @@
  * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
  */
 #include <linux/cache.h>
+#include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/personality.h>
@@ -422,7 +423,7 @@ asmlinkage void sys_sigreturn(nabi_no_regargs struct pt_regs regs)
 		"j\tsyscall_exit"
 		:/* no outputs */
 		:"r" (&regs));
-	/* Unreached */
+	unreachable();
 
 badframe:
 	force_sig(SIGSEGV, current);
@@ -468,7 +469,7 @@ asmlinkage void sys_rt_sigreturn(nabi_no_regargs struct pt_regs regs)
 		"j\tsyscall_exit"
 		:/* no outputs */
 		:"r" (&regs));
-	/* Unreached */
+	unreachable();
 
 badframe:
 	force_sig(SIGSEGV, current);
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index 2e74075..d41e267 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -9,6 +9,7 @@
  */
 #include <linux/cache.h>
 #include <linux/compat.h>
+#include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
@@ -526,7 +527,7 @@ asmlinkage void sys32_sigreturn(nabi_no_regargs struct pt_regs regs)
 		"j\tsyscall_exit"
 		:/* no outputs */
 		:"r" (&regs));
-	/* Unreached */
+	unreachable();
 
 badframe:
 	force_sig(SIGSEGV, current);
@@ -583,7 +584,7 @@ asmlinkage void sys32_rt_sigreturn(nabi_no_regargs struct pt_regs regs)
 		"j\tsyscall_exit"
 		:/* no outputs */
 		:"r" (&regs));
-	/* Unreached */
+	unreachable();
 
 badframe:
 	force_sig(SIGSEGV, current);
diff --git a/arch/mips/kernel/signal_n32.c b/arch/mips/kernel/signal_n32.c
index bb277e8..24ebaa5 100644
--- a/arch/mips/kernel/signal_n32.c
+++ b/arch/mips/kernel/signal_n32.c
@@ -16,6 +16,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
 #include <linux/cache.h>
+#include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
@@ -167,7 +168,7 @@ asmlinkage void sysn32_rt_sigreturn(nabi_no_regargs struct pt_regs regs)
 		"j\tsyscall_exit"
 		:/* no outputs */
 		:"r" (&regs));
-	/* Unreached */
+	unreachable();
 
 badframe:
 	force_sig(SIGSEGV, current);
