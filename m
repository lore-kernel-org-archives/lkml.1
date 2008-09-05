Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYIEDLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYIEDLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYIEDJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:54468 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYIEDJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Wb1j9uzcamjsZlx6Mk/Dz4vkDrW+pc6UMmD/zE5oRaWTJ+42tLx0xycVvivUlCj/pk
         VpUGEZJw5pX+/p8DeEkjKGEDf56AbrgdTmHVzLGxp3a0wv+qV/Yf2YRnRne0iJnm12qs
         b+GBmXE7ZAz+M3RjmGsWscDI285Ouv29oN/Zs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 08/16] x86: cpu common merge default_init
Date: Thu,  4 Sep 2008 20:09:06 -0700
Message-Id: <1220584154-32497-8-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |    4 ++++
 arch/x86/kernel/cpu/common_64.c |   12 ++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 43d5287..2c4bfa2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -224,6 +224,9 @@ static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
 
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_64
+	display_cacheinfo(c);
+#else
 	/* Not much we can do here... */
 	/* Check if at least it has cpuid */
 	if (c->cpuid_level == -1) {
@@ -233,6 +236,7 @@ static void __cpuinit default_init(struct cpuinfo_x86 *c)
 		else if (c->x86 == 3)
 			strcpy(c->x86_model_id, "386");
 	}
+#endif
 }
 
 static struct cpu_dev __cpuinitdata default_cpu = {
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index d7b9965..2fda109 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -223,7 +223,19 @@ static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
 
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_64
 	display_cacheinfo(c);
+#else
+	/* Not much we can do here... */
+	/* Check if at least it has cpuid */
+	if (c->cpuid_level == -1) {
+		/* No cpuid. It must be an ancient CPU */
+		if (c->x86 == 4)
+			strcpy(c->x86_model_id, "486");
+		else if (c->x86 == 3)
+			strcpy(c->x86_model_id, "386");
+	}
+#endif
 }
 
 static struct cpu_dev __cpuinitdata default_cpu = {
-- 
1.5.4.5

