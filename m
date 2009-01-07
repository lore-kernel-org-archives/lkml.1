Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbZAGPOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbZAGPOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZAGPOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:14:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53965 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZAGPOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:14:34 -0500
Subject: [PATCH -tip 5/7] x86: smp.h move safe_smp_processor_id declartion
	to cpu.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, James.Bottomley@hansenpartnership.com,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 17:27:01 +0530
Message-Id: <1231329421.17961.34.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, moving NON-SMP stuff from smp.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu.h    |    1 +
 arch/x86/include/asm/smp.h    |    1 -
 arch/x86/mach-voyager/setup.c |    1 +
 3 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index f958e7e..4c16888 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -15,6 +15,7 @@ extern void prefill_possible_map(void);
 
 static inline void prefill_possible_map(void) {}
 
+#define safe_smp_processor_id()			0
 #define stack_smp_processor_id()		0
 
 #endif /* CONFIG_SMP */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index cbbea22..3a76b19 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -198,7 +198,6 @@ extern int safe_smp_processor_id(void);
 
 #else /* !CONFIG_X86_32_SMP && !CONFIG_X86_64_SMP */
 #define cpu_physical_id(cpu)		boot_cpu_physical_apicid
-#define safe_smp_processor_id()		0
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index a580b95..0ade625 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -9,6 +9,7 @@
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/setup.h>
+#include <asm/cpu.h>
 
 void __init pre_intr_init_hook(void)
 {
-- 
1.5.6.6



