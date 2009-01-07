Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbZAGQGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbZAGQGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZAGQGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:06:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49948 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZAGQGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:06:31 -0500
Subject: [PATCH -tip 1/4 V2] x86: smp.h move stack_processor_id declartion
	to cpu.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 21:34:25 +0530
Message-Id: <1231344265.3770.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, moving NON-SMP stuff from smp.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu.h   |    2 ++
 arch/x86/include/asm/smp.h   |    1 -
 arch/x86/kernel/cpu/common.c |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 29aa6d0..f958e7e 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -15,6 +15,8 @@ extern void prefill_possible_map(void);
 
 static inline void prefill_possible_map(void) {}
 
+#define stack_smp_processor_id()		0
+
 #endif /* CONFIG_SMP */
 
 struct x86_cpu {
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index a151651..cbbea22 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -199,7 +199,6 @@ extern int safe_smp_processor_id(void);
 #else /* !CONFIG_X86_32_SMP && !CONFIG_X86_64_SMP */
 #define cpu_physical_id(cpu)		boot_cpu_physical_apicid
 #define safe_smp_processor_id()		0
-#define stack_smp_processor_id() 	0
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 667e5d5..fb935af 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -22,6 +22,7 @@
 #include <asm/asm.h>
 #include <asm/numa.h>
 #include <asm/smp.h>
+#include <asm/cpu.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
-- 
1.5.6.6



