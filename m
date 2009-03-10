Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZCJFNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZCJFNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZCJFLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:35665 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbZCJFLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qA2MuKZTY1DJFaN8Vx2cLh7gfBYrbRxy2hLqCLFMqKDli+a7JWKNkamgTwsJSYZqG4
         3gJkRLjm6K47TMSrmTyfWP3iZ5hiDUz0VCthSMoJ91RKMY6uIHZ866ThFIjltBCFUcac
         jfnqME3sA6nG7uzVE7NCgB4tZTHz4KUSeEruU=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH 07/25] [x86] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:32 -0500
Message-Id: <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/x86/kernel/cpu/common.c        |    6 ++----
 arch/x86/kernel/quirks.c            |    3 +--
 arch/x86/mach-voyager/voyager_smp.c |    6 ++----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 83492b1..86206c6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1051,8 +1051,7 @@ void __cpuinit cpu_init(void)
 
 	atomic_inc(&init_mm.mm_count);
 	me->active_mm = &init_mm;
-	if (me->mm)
-		BUG();
+	BUG_ON(me->mm);
 	enter_lazy_tlb(&init_mm, me);
 
 	load_sp0(t, &current->thread);
@@ -1121,8 +1120,7 @@ void __cpuinit cpu_init(void)
 	 */
 	atomic_inc(&init_mm.mm_count);
 	curr->active_mm = &init_mm;
-	if (curr->mm)
-		BUG();
+	BUG_ON(curr->mm);
 	enter_lazy_tlb(&init_mm, curr);
 
 	load_sp0(t, thread);
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 309949e..6a5a297 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -74,8 +74,7 @@ static void ich_force_hpet_resume(void)
 	if (!force_hpet_address)
 		return;
 
-	if (rcba_base == NULL)
-		BUG();
+	BUG_ON(rcba_base == NULL);
 
 	/* read the Function Disable register, dword mode only */
 	val = readl(rcba_base + 0x3404);
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index b9cc84a..1a35fe1 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -825,14 +825,12 @@ voyager_flush_tlb_others(unsigned long cpumask, struct mm_struct *mm,
 {
 	int stuck = 50000;
 
-	if (!cpumask)
-		BUG();
+	BUG_ON(!cpumask);
 	if ((cpumask & cpus_addr(cpu_online_map)[0]) != cpumask)
 		BUG();
 	if (cpumask & (1 << smp_processor_id()))
 		BUG();
-	if (!mm)
-		BUG();
+	BUG_ON(!mm);
 
 	spin_lock(&tlbstate_lock);
 
-- 
1.6.1.3

