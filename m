Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbZAGQJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbZAGQJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZAGQJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:09:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbZAGQJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:09:36 -0500
Subject: [PATCH -tip 3/4 V2] x86: smp.h move cpu_physical_id declartion to
	cpu.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 21:37:33 +0530
Message-Id: <1231344453.3770.6.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, moving NON-SMP stuff from smp.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu.h |    1 +
 arch/x86/include/asm/smp.h |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 4c16888..89edafb 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -15,6 +15,7 @@ extern void prefill_possible_map(void);
 
 static inline void prefill_possible_map(void) {}
 
+#define cpu_physical_id(cpu)			boot_cpu_physical_apicid
 #define safe_smp_processor_id()			0
 #define stack_smp_processor_id()		0
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 3a76b19..136f1c7 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -196,8 +196,6 @@ extern int safe_smp_processor_id(void);
 })
 #define safe_smp_processor_id()		smp_processor_id()
 
-#else /* !CONFIG_X86_32_SMP && !CONFIG_X86_64_SMP */
-#define cpu_physical_id(cpu)		boot_cpu_physical_apicid
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
-- 
1.5.6.6



