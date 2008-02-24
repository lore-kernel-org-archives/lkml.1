Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbYBXK5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbYBXK5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 05:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYBXK53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 05:57:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:41694 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYBXK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 05:57:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=eiAErX9TuTOJ7c6yIljc1xexMTsORBZjAcyL1fDtJx9p1Of1+jX2+0w/IF+y5Qa8wicA1v2qm5TebzLHOwVFK9F28NVJVCMIADzEn53Pc3mxwiQ1RhI80+i/6iU2GYvxIpWCnzrGzm0TH39Y1OJecnHchY31tQr4OxyIMNagkmY=
Date: Sun, 24 Feb 2008 11:57:22 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86: Coding Style fixes to arch/x86/power/cpu_32.c
Message-ID: <20080224115722.62989d5c@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.
Patch is against x86#testing


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/power/cpu_32.c |   41 +++++++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index 7f9c6da..7dc5d5c 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -27,17 +27,17 @@ static void __save_processor_state(struct saved_context *ctxt)
 	/*
 	 * descriptor tables
 	 */
- 	store_gdt(&ctxt->gdt);
- 	store_idt(&ctxt->idt);
- 	store_tr(ctxt->tr);
+	store_gdt(&ctxt->gdt);
+	store_idt(&ctxt->idt);
+	store_tr(ctxt->tr);
 
 	/*
 	 * segment registers
 	 */
- 	savesegment(es, ctxt->es);
- 	savesegment(fs, ctxt->fs);
- 	savesegment(gs, ctxt->gs);
- 	savesegment(ss, ctxt->ss);
+	savesegment(es, ctxt->es);
+	savesegment(fs, ctxt->fs);
+	savesegment(gs, ctxt->gs);
+	savesegment(ss, ctxt->ss);
 
 	/*
 	 * control registers
@@ -48,10 +48,12 @@ static void __save_processor_state(struct saved_context *ctxt)
 	ctxt->cr4 = read_cr4();
 }
 
+/* Needed by apm.c */
 void save_processor_state(void)
 {
 	__save_processor_state(&saved_context);
 }
+EXPORT_SYMBOL(save_processor_state);
 
 static void do_fpu_end(void)
 {
@@ -64,9 +66,14 @@ static void do_fpu_end(void)
 static void fix_processor_context(void)
 {
 	int cpu = smp_processor_id();
-	struct tss_struct * t = &per_cpu(init_tss, cpu);
+	struct tss_struct *t = &per_cpu(init_tss, cpu);
 
-	set_tss_desc(cpu,t);	/* This just modifies memory; should not be necessary. But... This is necessary, because 386 hardware has concept of busy TSS or some similar stupidity. */
+	set_tss_desc(cpu, t);	/*
+				 * This just modifies memory; should not be
+				 * necessary. But... This is necessary, because
+				 * 386 hardware has concept of busy TSS or some
+				 * similar stupidity.
+				 */
 
 	load_TR_desc();				/* This does ltr */
 	load_LDT(&current->active_mm->context);	/* This does lldt */
@@ -100,16 +107,16 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	 * now restore the descriptor tables to their proper values
 	 * ltr is done i fix_processor_context().
 	 */
- 	load_gdt(&ctxt->gdt);
- 	load_idt(&ctxt->idt);
+	load_gdt(&ctxt->gdt);
+	load_idt(&ctxt->idt);
 
 	/*
 	 * segment registers
 	 */
- 	loadsegment(es, ctxt->es);
- 	loadsegment(fs, ctxt->fs);
- 	loadsegment(gs, ctxt->gs);
- 	loadsegment(ss, ctxt->ss);
+	loadsegment(es, ctxt->es);
+	loadsegment(fs, ctxt->fs);
+	loadsegment(gs, ctxt->gs);
+	loadsegment(ss, ctxt->ss);
 
 	/*
 	 * sysenter MSRs
@@ -123,11 +130,9 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	mcheck_init(&boot_cpu_data);
 }
 
+/* Needed by apm.c */
 void restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
 }
-
-/* Needed by apm.c */
-EXPORT_SYMBOL(save_processor_state);
 EXPORT_SYMBOL(restore_processor_state);
-- 
1.5.4.2.316.gf7a7

