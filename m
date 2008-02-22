Return-Path: <linux-kernel-owner+w=401wt.eu-S936422AbYBVWRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936422AbYBVWRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935246AbYBVWKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:10:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934723AbYBVWKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:10:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=xM20C90lUzxObFfFGcWxcOYiXWryjCn061ByC2NcNvD9qo4gmaNDZfNNsj7l5NHbz6NBS0nRhEJzJtCWwHPsbX6YjByAbo8K6M/+EXm7yM/PmHPVdDHvMuqH2DOc9d0Qmf3Pai8ZMAdE9RtnZEFqa8lo46R6B29AQZgmcnBUs1g=
Date: Fri, 22 Feb 2008 23:10:49 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/20] x86: Coding Style fixes to
 arch/x86/kernel/cpu/mcheck/non-fatal.c
Message-ID: <20080222231049.2d56bba5@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error and warning free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/non-fatal.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/non-fatal.c b/arch/x86/kernel/cpu/mcheck/non-fatal.c
index bf39409..00ccb6c 100644
--- a/arch/x86/kernel/cpu/mcheck/non-fatal.c
+++ b/arch/x86/kernel/cpu/mcheck/non-fatal.c
@@ -16,7 +16,7 @@
 #include <linux/smp.h>
 #include <linux/module.h>
 
-#include <asm/processor.h> 
+#include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/msr.h>
 
@@ -26,23 +26,26 @@ static int firstbank;
 
 #define MCE_RATE	15*HZ	/* timer rate is 15s */
 
-static void mce_checkregs (void *info)
+static void mce_checkregs(void *info)
 {
 	u32 low, high;
 	int i;
 
-	for (i=firstbank; i<nr_mce_banks; i++) {
-		rdmsr (MSR_IA32_MC0_STATUS+i*4, low, high);
+	for (i = firstbank; i < nr_mce_banks; i++) {
+		rdmsr(MSR_IA32_MC0_STATUS+i*4, low, high);
 
 		if (high & (1<<31)) {
 			printk(KERN_INFO "MCE: The hardware reports a non "
 				"fatal, correctable incident occurred on "
 				"CPU %d.\n",
 				smp_processor_id());
-			printk (KERN_INFO "Bank %d: %08x%08x\n", i, high, low);
+			printk(KERN_INFO "Bank %d: %08x%08x\n", i, high, low);
 
-			/* Scrub the error so we don't pick it up in MCE_RATE seconds time. */
-			wrmsr (MSR_IA32_MC0_STATUS+i*4, 0UL, 0UL);
+			/*
+			 * Scrub the error so we don't pick it up in MCE_RATE
+			 * seconds time.
+			 */
+			wrmsr(MSR_IA32_MC0_STATUS+i*4, 0UL, 0UL);
 
 			/* Serialize */
 			wmb();
@@ -55,10 +58,10 @@ static void mce_work_fn(struct work_struct *work);
 static DECLARE_DELAYED_WORK(mce_work, mce_work_fn);
 
 static void mce_work_fn(struct work_struct *work)
-{ 
+{
 	on_each_cpu(mce_checkregs, NULL, 1, 1);
 	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
-} 
+}
 
 static int __init init_nonfatal_mce_checker(void)
 {
-- 
1.5.4.GIT

