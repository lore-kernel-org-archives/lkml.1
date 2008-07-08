Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbYGHXQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbYGHXQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbYGHXOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:40 -0400
Received: from gw.goop.org ([64.81.55.164]:51204 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbYGHXOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:39 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 04 of 55] x86: clean up formatting of __switch_to
X-Mercurial-Node: 408aabebf5dc1a06edcbb4c12dd77657a2af2149
Message-Id: <408aabebf5dc1a06edcb.1215554786@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

process_64.c:__switch_to has some very old strange formatting, some of
it dating back to pre-git.  Fix it up.

No functional changes.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/process_64.c |   54 +++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -575,8 +575,8 @@
 struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
-	struct thread_struct *prev = &prev_p->thread,
-				 *next = &next_p->thread;
+	struct thread_struct *prev = &prev_p->thread;
+	struct thread_struct *next = &next_p->thread;
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
 	unsigned fsindex, gsindex;
@@ -624,35 +624,34 @@
 
 	/* 
 	 * Switch FS and GS.
+	 *
+	 * Segment register != 0 always requires a reload.  Also
+	 * reload when it has changed.  When prev process used 64bit
+	 * base always reload to avoid an information leak.
 	 */
-	{ 
-		/* segment register != 0 always requires a reload. 
-		   also reload when it has changed. 
-		   when prev process used 64bit base always reload
-		   to avoid an information leak. */
-		if (unlikely(fsindex | next->fsindex | prev->fs)) {
-			loadsegment(fs, next->fsindex);
-			/* check if the user used a selector != 0
-	                 * if yes clear 64bit base, since overloaded base
-                         * is always mapped to the Null selector
-                         */
-			if (fsindex)
+	if (unlikely(fsindex | next->fsindex | prev->fs)) {
+		loadsegment(fs, next->fsindex);
+		/* 
+		 * Check if the user used a selector != 0; if yes
+		 *  clear 64bit base, since overloaded base is always
+		 *  mapped to the Null selector
+		 */
+		if (fsindex)
 			prev->fs = 0;				
-		}
-		/* when next process has a 64bit base use it */
-		if (next->fs) 
-			wrmsrl(MSR_FS_BASE, next->fs); 
-		prev->fsindex = fsindex;
+	}
+	/* when next process has a 64bit base use it */
+	if (next->fs)
+		wrmsrl(MSR_FS_BASE, next->fs);
+	prev->fsindex = fsindex;
 
-		if (unlikely(gsindex | next->gsindex | prev->gs)) {
-			load_gs_index(next->gsindex);
-			if (gsindex)
+	if (unlikely(gsindex | next->gsindex | prev->gs)) {
+		load_gs_index(next->gsindex);
+		if (gsindex)
 			prev->gs = 0;				
-		}
-		if (next->gs)
-			wrmsrl(MSR_KERNEL_GS_BASE, next->gs); 
-		prev->gsindex = gsindex;
 	}
+	if (next->gs)
+		wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
+	prev->gsindex = gsindex;
 
 	/* Must be after DS reload */
 	unlazy_fpu(prev_p);
@@ -665,7 +664,8 @@
 	write_pda(pcurrent, next_p); 
 
 	write_pda(kernelstack,
-	(unsigned long)task_stack_page(next_p) + THREAD_SIZE - PDA_STACKOFFSET);
+		  (unsigned long)task_stack_page(next_p) +
+		  THREAD_SIZE - PDA_STACKOFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
 	/*
 	 * Build time only check to make sure the stack_canary is at


