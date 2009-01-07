Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbZAGQLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbZAGQLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZAGQLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:11:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:38629 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbZAGQLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:11:04 -0500
Subject: [PATCH -tip 4/4 V2] x86: smp.h move boot_cpu_id declartion to cpu.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 21:38:59 +0530
Message-Id: <1231344539.3770.8.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, moving NON-SMP stuff from smp.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu.h   |    7 +++++++
 arch/x86/include/asm/smp.h   |    6 ------
 arch/x86/kernel/io_apic.c    |    1 +
 drivers/pci/intr_remapping.c |    1 +
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 89edafb..f03b23e 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -31,4 +31,11 @@ extern void arch_unregister_cpu(int);
 #endif
 
 DECLARE_PER_CPU(int, cpu_state);
+
+#ifdef CONFIG_X86_HAS_BOOT_CPU_ID
+extern unsigned char boot_cpu_id;
+#else
+#define boot_cpu_id				0
+#endif
+
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 136f1c7..1963e27 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -238,11 +238,5 @@ static inline int hard_smp_processor_id(void)
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
-#ifdef CONFIG_X86_HAS_BOOT_CPU_ID
-extern unsigned char boot_cpu_id;
-#else
-#define boot_cpu_id	0
-#endif
-
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 1c4a130..109c91d 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -46,6 +46,7 @@
 #include <asm/idle.h>
 #include <asm/io.h>
 #include <asm/smp.h>
+#include <asm/cpu.h>
 #include <asm/desc.h>
 #include <asm/proto.h>
 #include <asm/acpi.h>
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index f78371b..5a57753 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -6,6 +6,7 @@
 #include <linux/irq.h>
 #include <asm/io_apic.h>
 #include <asm/smp.h>
+#include <asm/cpu.h>
 #include <linux/intel-iommu.h>
 #include "intr_remapping.h"
 
-- 
1.5.6.6



