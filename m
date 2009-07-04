Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZGDKJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZGDKJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbZGDKIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:08:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:47455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbZGDKIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:08:41 -0400
Date: Sat, 4 Jul 2009 10:08:04 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090703164225.GA21447@elte.hu>
References: <20090703164225.GA21447@elte.hu>
Subject: [tip:x86/cleanups] x86: Clean up mtrr/state.c
Message-ID: <tip-09b22c85d59dd935fdfa71655a443785e3f99c18@git.kernel.org>
Git-Commit-ID: 09b22c85d59dd935fdfa71655a443785e3f99c18
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 10:08:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09b22c85d59dd935fdfa71655a443785e3f99c18
Gitweb:     http://git.kernel.org/tip/09b22c85d59dd935fdfa71655a443785e3f99c18
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 4 Jul 2009 07:54:53 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jul 2009 11:19:53 +0200

x86: Clean up mtrr/state.c

Fix:

  WARNING: Use #include <linux/io.h> instead of <asm/io.h>
  WARNING: line over 80 characters X 4

arch/x86/kernel/cpu/mtrr/state.o:

   text	   data	    bss	    dec	    hex	filename
    864	      0	      0	    864	    360	state.o.before
    864	      0	      0	    864	    360	state.o.after

md5:
   c5c4364b9aeac74d70111e1e49667a2c  state.o.before.asm
   c5c4364b9aeac74d70111e1e49667a2c  state.o.after.asm

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090703164225.GA21447@elte.hu>
[ More cleanups ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/state.c |   68 ++++++++++++++++++++++---------------
 1 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
index 1f5fb15..dfc80b4 100644
--- a/arch/x86/kernel/cpu/mtrr/state.c
+++ b/arch/x86/kernel/cpu/mtrr/state.c
@@ -1,24 +1,25 @@
-#include <linux/mm.h>
 #include <linux/init.h>
-#include <asm/io.h>
-#include <asm/mtrr.h>
-#include <asm/msr.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+
 #include <asm/processor-cyrix.h>
 #include <asm/processor-flags.h>
-#include "mtrr.h"
+#include <asm/mtrr.h>
+#include <asm/msr.h>
 
+#include "mtrr.h"
 
-/*  Put the processor into a state where MTRRs can be safely set  */
+/* Put the processor into a state where MTRRs can be safely set */
 void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 {
 	unsigned int cr0;
 
-	/*  Disable interrupts locally  */
+	/* Disable interrupts locally */
 	local_irq_save(ctxt->flags);
 
 	if (use_intel() || is_cpu(CYRIX)) {
 
-		/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
+		/* Save value of CR4 and clear Page Global Enable (bit 7) */
 		if (cpu_has_pge) {
 			ctxt->cr4val = read_cr4();
 			write_cr4(ctxt->cr4val & ~X86_CR4_PGE);
@@ -33,50 +34,61 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 		write_cr0(cr0);
 		wbinvd();
 
-		if (use_intel())
-			/*  Save MTRR state */
+		if (use_intel()) {
+			/* Save MTRR state */
 			rdmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
-		else
-			/* Cyrix ARRs - everything else were excluded at the top */
+		} else {
+			/*
+			 * Cyrix ARRs -
+			 * everything else were excluded at the top
+			 */
 			ctxt->ccr3 = getCx86(CX86_CCR3);
+		}
 	}
 }
 
 void set_mtrr_cache_disable(struct set_mtrr_context *ctxt)
 {
-	if (use_intel())
-		/*  Disable MTRRs, and set the default type to uncached  */
+	if (use_intel()) {
+		/* Disable MTRRs, and set the default type to uncached */
 		mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo & 0xf300UL,
 		      ctxt->deftype_hi);
-	else if (is_cpu(CYRIX))
-		/* Cyrix ARRs - everything else were excluded at the top */
-		setCx86(CX86_CCR3, (ctxt->ccr3 & 0x0f) | 0x10);
+	} else {
+		if (is_cpu(CYRIX)) {
+			/* Cyrix ARRs - everything else were excluded at the top */
+			setCx86(CX86_CCR3, (ctxt->ccr3 & 0x0f) | 0x10);
+		}
+	}
 }
 
-/*  Restore the processor after a set_mtrr_prepare  */
+/* Restore the processor after a set_mtrr_prepare */
 void set_mtrr_done(struct set_mtrr_context *ctxt)
 {
 	if (use_intel() || is_cpu(CYRIX)) {
 
-		/*  Flush caches and TLBs  */
+		/* Flush caches and TLBs */
 		wbinvd();
 
-		/*  Restore MTRRdefType  */
-		if (use_intel())
+		/* Restore MTRRdefType */
+		if (use_intel()) {
 			/* Intel (P6) standard MTRRs */
-			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
-		else
-			/* Cyrix ARRs - everything else was excluded at the top */
+			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo,
+				   ctxt->deftype_hi);
+		} else {
+			/*
+			 * Cyrix ARRs -
+			 * everything else was excluded at the top
+			 */
 			setCx86(CX86_CCR3, ctxt->ccr3);
+		}
 
-		/*  Enable caches  */
+		/* Enable caches */
 		write_cr0(read_cr0() & 0xbfffffff);
 
-		/*  Restore value of CR4  */
+		/* Restore value of CR4 */
 		if (cpu_has_pge)
 			write_cr4(ctxt->cr4val);
 	}
-	/*  Re-enable interrupts locally (if enabled previously)  */
+	/* Re-enable interrupts locally (if enabled previously) */
 	local_irq_restore(ctxt->flags);
 }
-
