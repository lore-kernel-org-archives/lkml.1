Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYHWNCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYHWNCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYHWNBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:01:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:16220 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYHWNA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rTFTlwljQCr7HwOn2dP2g1MvG6KUlXQvAd6WJM/BDZZIeO+90CDciMsG1sLcPbUUKY
         jEkSaESiQ47Pe0zC9PKJR18BuiKLzMgzc4SeDARYBf73zQ6/ZUOW09gpxUXw2bs8XLnL
         QqJo6w9RAfzZy348UgVnUEEAhE9nrj0TA8BNs=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: yhlu.kernel@gmail.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 5/8] x86: apic - unify hard_smp_processor_id
Date: Sat, 23 Aug 2008 17:01:22 +0400
Message-Id: <ad4298d4a7d4eb0bf4611765df4481ac129b5db6.1219491572.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.6.gc667
In-Reply-To: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
References: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
References: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move hard_smp_processor_id to apic_32.c.
There is no need to keep it in header - we are linked to
apic_xx.c code anyway.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    5 +++++
 include/asm-x86/smp.h     |   10 ----------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index ad295cf..c71a77c 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1569,6 +1569,11 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	cpu_set(cpu, cpu_present_map);
 }
 
+int hard_smp_processor_id(void)
+{
+	return read_apic_id();
+}
+
 /*
  * Power management
  */
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 29324c1..914a73d 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -185,17 +185,7 @@ static inline unsigned int read_apic_id(void)
 }
 #endif
 
-
-# if defined(APIC_DEFINITION) || defined(CONFIG_X86_64)
 extern int hard_smp_processor_id(void);
-# else
-#include <mach_apicdef.h>
-static inline int hard_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return read_apic_id();
-}
-# endif /* APIC_DEFINITION */
 
 #else /* CONFIG_X86_LOCAL_APIC */
 
-- 
1.6.0.6.gc667

