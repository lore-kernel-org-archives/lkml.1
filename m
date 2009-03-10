Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZCJFRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZCJFRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZCJFLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:53 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:28246 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbZCJFLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o4NVarCjOyifDTrIwW8e2H40+a9EqpdF90Fj65v25mTylHAyKPWdcBwxj/kF+1+WSo
         NJ3UJv9HnEHxZJ6HOIP6yUiGTrmgUqitzlax98nmaYXIAevIN3ppPRsi20KCHUl7KqhB
         1C/UTn9Ndw5QFC8+qYUqw6ewnl9WtG6mWUOjU=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org
Subject: [PATCH 16/25] [m32r] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:41 -0500
Message-Id: <1236661850-8237-17-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/m32r/kernel/setup.c |    3 +--
 arch/m32r/kernel/smp.c   |    9 +++------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/m32r/kernel/setup.c b/arch/m32r/kernel/setup.c
index 0392112..6e119ee 100644
--- a/arch/m32r/kernel/setup.c
+++ b/arch/m32r/kernel/setup.c
@@ -402,8 +402,7 @@ void __init cpu_init (void)
 	/* Set up and load the per-CPU TSS and LDT */
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
-	if (current->mm)
-		BUG();
+	BUG_ON(current->mm);
 
 	/* Force FPU initialization */
 	current_thread_info()->status = 0;
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index 929e5c9..17c96bb 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -338,8 +338,7 @@ void smp_flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 	cpu_clear(cpu_id, cpu_mask);
 
 #ifdef DEBUG_SMP
-	if (!mm)
-		BUG();
+	BUG_ON(!mm);
 #endif
 
 	if (*mmc != NO_CONTEXT) {
@@ -385,8 +384,7 @@ static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
 #ifdef DEBUG_SMP
 	unsigned long flags;
 	__save_flags(flags);
-	if (!(flags & 0x0040))	/* Interrupt Disable NONONO */
-		BUG();
+	BUG_ON(!(flags & 0x0040));	/* Interrupt Disable NONONO */
 #endif /* DEBUG_SMP */
 
 	/*
@@ -805,8 +803,7 @@ unsigned long send_IPI_mask_phys(cpumask_t physid_mask, int ipi_num,
 
 	if (mask & ~physids_coerce(phys_cpu_present_map))
 		BUG();
-	if (ipi_num >= NR_IPIS)
-		BUG();
+	BUG_ON(ipi_num >= NR_IPIS);
 
 	mask <<= IPI_SHIFT;
 	ipilock = &ipi_lock[ipi_num];
-- 
1.6.1.3

