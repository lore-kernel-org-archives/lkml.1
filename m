Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbZEZX5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbZEZX5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756238AbZEZXyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38601 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbZEZXyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:44 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/31] x86: MCE: Remove mce_init unused argument
Date: Wed, 27 May 2009 01:54:11 +0200
Message-Id: <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Impact: Cleanup

Remove unused mce_init argument.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 925b222..2e3ceed 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -649,7 +649,7 @@ static int mce_cap_init(void)
 	return 0;
 }
 
-static void mce_init(void *dummy)
+static void mce_init(void)
 {
 	mce_banks_t all_banks;
 	u64 cap;
@@ -782,7 +782,7 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 
 	machine_check_vector = do_machine_check;
 
-	mce_init(NULL);
+	mce_init();
 	mce_cpu_features(c);
 	mce_init_timer();
 }
@@ -1025,7 +1025,7 @@ static int mce_shutdown(struct sys_device *dev)
  */
 static int mce_resume(struct sys_device *dev)
 {
-	mce_init(NULL);
+	mce_init();
 	mce_cpu_features(&current_cpu_data);
 
 	return 0;
@@ -1035,7 +1035,7 @@ static void mce_cpu_restart(void *data)
 {
 	del_timer_sync(&__get_cpu_var(mce_timer));
 	if (mce_available(&current_cpu_data))
-		mce_init(NULL);
+		mce_init();
 	mce_init_timer();
 }
 
-- 
1.6.0.2

