Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbZEZXUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbZEZXUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759043AbZEZXSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53165 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbZEZXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:32 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/17] x86: MCE: Remove unused stop/restart_mce on 32bit
Date: Wed, 27 May 2009 01:18:08 +0200
Message-Id: <c8c4b619d810eba16e62044a38284761ef69c8f2.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <e2d81decded3202e410a569f8c224986f2e83668.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
 <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
 <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
 <b7b15c0ea92409e6641de1e90da9c63664066eba.1243377662.git.ak@linux.intel.com>
 <e2d81decded3202e410a569f8c224986f2e83668.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The calls for those got removed some time ago, so just remove
the functions too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b9463b3..62b863a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1300,20 +1300,6 @@ void mcheck_init(struct cpuinfo_x86 *c)
 	printk(KERN_INFO "mce: CPU supports %d MCE banks\n", nr_mce_banks);
 }
 
-static unsigned long old_cr4 __initdata;
-
-void __init stop_mce(void)
-{
-	old_cr4 = read_cr4();
-	clear_in_cr4(X86_CR4_MCE);
-}
-
-void __init restart_mce(void)
-{
-	if (old_cr4 & X86_CR4_MCE)
-		set_in_cr4(X86_CR4_MCE);
-}
-
 static int __init mcheck_enable(char *str)
 {
 	mce_disabled = -1;
-- 
1.6.0.2

