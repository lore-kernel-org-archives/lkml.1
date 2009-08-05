Return-Path: <linux-kernel-owner+w=401wt.eu-S934248AbZHELVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbZHELVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934234AbZHELVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:21:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41996 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934147AbZHELVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:21:22 -0400
Date: Wed, 5 Aug 2009 07:20:00 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090805112221.6552.34447.sendpatchset@localhost.localdomain>
In-Reply-To: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
Subject: [Patch 6/7] powerpc: implement crashkernel=auto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since in patch 2/7 we already implement the generic part, this will
add the rest part for powerpc.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
Index: linux-2.6/arch/powerpc/include/asm/kexec.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/kexec.h
+++ linux-2.6/arch/powerpc/include/asm/kexec.h
@@ -39,6 +39,29 @@ typedef void (*crash_shutdown_t)(void);
 
 #ifdef CONFIG_KEXEC
 
+#ifdef CONFIG_KEXEC_AUTO_RESERVE
+#ifndef KEXEC_AUTO_RESERVED_SIZE
+#define KEXEC_AUTO_RESERVED_SIZE 1ULL<<28 /* 256M */
+#endif
+#ifndef KEXEC_AUTO_THRESHOLD
+#define KEXEC_AUTO_THRESHOLD 1ULL<<32 /* 4G */
+#endif
+static inline
+unsigned long long arch_default_crash_size(unsigned long long total_size)
+{
+	if (total_size < KEXEC_AUTO_THRESHOLD)
+		return 0;
+	else
+		return KEXEC_AUTO_RESERVED_SIZE;
+}
+static inline
+unsigned long long arch_default_crash_base(void)
+{
+	/* On ppc, 0 means find the base address automatically. */
+	return 0;
+}
+#endif
+
 /*
  * This function is responsible for capturing register states if coming
  * via panic or invoking dump using sysrq-trigger.
