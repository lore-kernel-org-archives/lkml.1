Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYIHBAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYIHBAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYIHA7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:59:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:6916 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbYIHA7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JNx/lcPBeeYfefD/8ehpBLuRxZkI6ciyKkP88OWGLzWJEBnGm+MjsLKgz1YB6kI/Hr
         hnc1LKdFe5V/j8YmmU2Q2OGzlyGvXH7k+7epSlvWaCYxNAnjaLM/YmJl0c1eUEdojahQ
         HdBLlobGt+8sUQ3B2yWpLK2ep7IdbcCfV2fxM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/9] x86: merge header in amd/64.c
Date: Sun,  7 Sep 2008 17:58:53 -0700
Message-Id: <1220835538-18280-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220835538-18280-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Singed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/amd.c    |    8 ++++++++
 arch/x86/kernel/cpu/amd_64.c |   13 ++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index a3a9e3c..3c8090d 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1,11 +1,19 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/mm.h>
+
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/apic.h>
 
+#ifdef CONFIG_X86_64
+# include <asm/numa_64.h>
+# include <asm/mmconfig.h>
+# include <asm/cacheflush.h>
+#endif
+
 #include <mach_apic.h>
+
 #include "cpu.h"
 
 /*
diff --git a/arch/x86/kernel/cpu/amd_64.c b/arch/x86/kernel/cpu/amd_64.c
index 20c3f12..1d83601 100644
--- a/arch/x86/kernel/cpu/amd_64.c
+++ b/arch/x86/kernel/cpu/amd_64.c
@@ -1,9 +1,16 @@
 #include <linux/init.h>
+#include <linux/bitops.h>
 #include <linux/mm.h>
 
-#include <asm/numa_64.h>
-#include <asm/mmconfig.h>
-#include <asm/cacheflush.h>
+#include <asm/io.h>
+#include <asm/processor.h>
+#include <asm/apic.h>
+
+#ifdef CONFIG_X86_64
+# include <asm/numa_64.h>
+# include <asm/mmconfig.h>
+# include <asm/cacheflush.h>
+#endif
 
 #include <mach_apic.h>
 
-- 
1.5.4.5

