Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbZEZXTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbZEZXTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759358AbZEZXSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53161 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043AbZEZXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:31 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/17] x86: MCE: Move mce_disabled option into common 64bit/64bit code
Date: Wed, 27 May 2009 01:18:05 +0200
Message-Id: <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
 <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

It's the same function, so let's share it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9bbdd11..68c3329 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -909,16 +909,6 @@ static struct miscdevice mce_log_device = {
 };
 
 /*
- * Old style boot options parsing. Only for compatibility.
- */
-static int __init mcheck_disable(char *str)
-{
-	mce_disabled = 1;
-	return 1;
-}
-__setup("nomce", mcheck_disable);
-
-/*
  * mce=off disables machine check
  * mce=TOLERANCELEVEL (number, see above)
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
@@ -1346,19 +1336,22 @@ void __init restart_mce(void)
 		set_in_cr4(X86_CR4_MCE);
 }
 
-static int __init mcheck_disable(char *str)
-{
-	mce_disabled = 1;
-	return 1;
-}
-
 static int __init mcheck_enable(char *str)
 {
 	mce_disabled = -1;
 	return 1;
 }
 
-__setup("nomce", mcheck_disable);
 __setup("mce", mcheck_enable);
 
-#endif /* CONFIG_X86_32 */
+#endif /* CONFIG_X86_OLD_MCE */
+
+/*
+ * Old style boot options parsing. Only for compatibility.
+ */
+static int __init mcheck_disable(char *str)
+{
+	mce_disabled = 1;
+	return 1;
+}
+__setup("nomce", mcheck_disable);
-- 
1.6.0.2

