Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZAGMpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZAGMpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbZAGMo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:44:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:48428 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZAGMo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:44:58 -0500
Subject: [PATCH -tip 4/7] x86: smp.h move stack_processor_id declartion to
	cpu.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 18:12:50 +0530
Message-Id: <1231332170.18558.13.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, moving NON-SMP stuff from smp.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu.h |    2 ++
 arch/x86/include/asm/smp.h |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

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
-- 
1.5.6.6



