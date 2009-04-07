Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbZDGPNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbZDGPNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758548AbZDGPH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48854 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbZDGPHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:55 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: [PATCH] [11/28] x86: MCE: Remove mce_init unused argument
Message-Id: <20090407150752.A2B261D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>

Impact: Cleanup

Remove unused mce_init argument.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:13.000000000 +0200
@@ -556,7 +556,7 @@
 	return 0;
 }
 
-static void mce_init(void *dummy)
+static void mce_init(void)
 {
 	u64 cap;
 	int i;
@@ -640,7 +640,7 @@
 	}
 	mce_cpu_quirks(c);
 
-	mce_init(NULL);
+	mce_init();
 	mce_cpu_features(c);
 	mce_init_timer();
 }
@@ -873,7 +873,7 @@
    CPU hotplug. */
 static int mce_resume(struct sys_device *dev)
 {
-	mce_init(NULL);
+	mce_init();
 	mce_cpu_features(&current_cpu_data);
 	return 0;
 }
@@ -882,7 +882,7 @@
 {
 	del_timer_sync(&__get_cpu_var(mce_timer));
 	if (mce_available(&current_cpu_data))
-		mce_init(NULL);
+		mce_init();
 	mce_init_timer();
 }
 
