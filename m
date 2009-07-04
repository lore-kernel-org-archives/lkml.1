Return-Path: <linux-kernel-owner+w=401wt.eu-S1759638AbZGDCc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbZGDCc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759583AbZGDCch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:32:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:47373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759568AbZGDCcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:32:35 -0400
Subject: [PATCH 8/9 -tip] x86: mtrr/state.c fix trivial style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1246674256.2642.12.camel@ht.satnam>
References: <20090703095432.GC21141@elte.hu>
	 <20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	 <20090703102234.GA32128@elte.hu>
	 <20090703114431.37abd528@lxorguk.ukuu.org.uk>
	 <20090703131727.GA3207@elte.hu>
	 <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	 <20090703144754.GA13246@elte.hu>
	 <20090703160230.093e422c@lxorguk.ukuu.org.uk>
	 <20090703155809.GA20121@elte.hu>
	 <20090703172651.619162fd@lxorguk.ukuu.org.uk>
	 <20090703164225.GA21447@elte.hu>  <1246673939.2642.5.camel@ht.satnam>
	 <1246674000.2642.6.camel@ht.satnam>  <1246674044.2642.7.camel@ht.satnam>
	 <1246674092.2642.8.camel@ht.satnam>  <1246674128.2642.9.camel@ht.satnam>
	 <1246674180.2642.10.camel@ht.satnam>  <1246674220.2642.11.camel@ht.satnam>
	 <1246674256.2642.12.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 07:54:53 +0530
Message-Id: <1246674293.2642.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix :

  WARNING: Use #include <linux/io.h> instead of <asm/io.h>
  WARNING: line over 80 characters X 4

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/state.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
index 1f5fb15..dcd00f5 100644
--- a/arch/x86/kernel/cpu/mtrr/state.c
+++ b/arch/x86/kernel/cpu/mtrr/state.c
@@ -1,13 +1,12 @@
 #include <linux/mm.h>
 #include <linux/init.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
 #include <asm/processor-cyrix.h>
 #include <asm/processor-flags.h>
 #include "mtrr.h"
 
-
 /*  Put the processor into a state where MTRRs can be safely set  */
 void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 {
@@ -35,9 +34,13 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 
 		if (use_intel())
 			/*  Save MTRR state */
-			rdmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
+			rdmsr(MSR_MTRRdefType, ctxt->deftype_lo,
+			      ctxt->deftype_hi);
 		else
-			/* Cyrix ARRs - everything else were excluded at the top */
+			/*
+			 * Cyrix ARRs -
+			 * everything else were excluded at the top
+			 */
 			ctxt->ccr3 = getCx86(CX86_CCR3);
 	}
 }
@@ -64,9 +67,13 @@ void set_mtrr_done(struct set_mtrr_context *ctxt)
 		/*  Restore MTRRdefType  */
 		if (use_intel())
 			/* Intel (P6) standard MTRRs */
-			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
+			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo,
+				   ctxt->deftype_hi);
 		else
-			/* Cyrix ARRs - everything else was excluded at the top */
+			/*
+			 * Cyrix ARRs -
+			 * everything else was excluded at the top
+			 */
 			setCx86(CX86_CCR3, ctxt->ccr3);
 
 		/*  Enable caches  */
@@ -79,4 +86,3 @@ void set_mtrr_done(struct set_mtrr_context *ctxt)
 	/*  Re-enable interrupts locally (if enabled previously)  */
 	local_irq_restore(ctxt->flags);
 }
-
-- 
1.6.0.6



