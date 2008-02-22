Return-Path: <linux-kernel-owner+w=401wt.eu-S935828AbYBVWNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935828AbYBVWNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759053AbYBVWKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:10:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689AbYBVWKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ePPwxORJGUlfA2zwTpdljqWwJSYhhCww3B768fD1Y3s7r3hv5xBMY4ZfuU4ODEuhmdAjuCCTixeLY8L1OnbMpvRAJcnny7DbbbMOYWe68tszVbJBo4v37asDiAI36NVW6NgFm7X3y3OK6liMqu1ah9Vhlj6e8T5vi+/5ynqA98Q=
Date: Fri, 22 Feb 2008 23:10:16 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/20] x86: Coding Style fixes to
 arch/x86/kernel/cpu/mtrr/state.c
Message-ID: <20080222231016.25ee76b8@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/state.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
index 9f8ba92..7f7e275 100644
--- a/arch/x86/kernel/cpu/mtrr/state.c
+++ b/arch/x86/kernel/cpu/mtrr/state.c
@@ -19,13 +19,15 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 	if (use_intel() || is_cpu(CYRIX)) {
 
 		/*  Save value of CR4 and clear Page Global Enable (bit 7)  */
-		if ( cpu_has_pge ) {
+		if (cpu_has_pge) {
 			ctxt->cr4val = read_cr4();
 			write_cr4(ctxt->cr4val & ~X86_CR4_PGE);
 		}
 
-		/*  Disable and flush caches. Note that wbinvd flushes the TLBs as
-		    a side-effect  */
+		/*
+		 * Disable and flush caches. Note that wbinvd flushes the TLBs
+		 * as a side-effect
+		 */
 		cr0 = read_cr0() | X86_CR0_CD;
 		wbinvd();
 		write_cr0(cr0);
@@ -42,7 +44,7 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 
 void set_mtrr_cache_disable(struct set_mtrr_context *ctxt)
 {
-	if (use_intel()) 
+	if (use_intel())
 		/*  Disable MTRRs, and set the default type to uncached  */
 		mtrr_wrmsr(MTRRdefType_MSR, ctxt->deftype_lo & 0xf300UL,
 		      ctxt->deftype_hi);
@@ -66,12 +68,12 @@ void set_mtrr_done(struct set_mtrr_context *ctxt)
 		else
 			/* Cyrix ARRs - everything else was excluded at the top */
 			setCx86(CX86_CCR3, ctxt->ccr3);
-		
+
 		/*  Enable caches  */
 		write_cr0(read_cr0() & 0xbfffffff);
 
 		/*  Restore value of CR4  */
-		if ( cpu_has_pge )
+		if (cpu_has_pge)
 			write_cr4(ctxt->cr4val);
 	}
 	/*  Re-enable interrupts locally (if enabled previously)  */
-- 
1.5.4.GIT

