Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbXEGIsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbXEGIsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 04:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbXEGIsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 04:48:54 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:62945 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754171AbXEGIsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 04:48:53 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: David Brownell <david-b@pacbell.net>, Andrew Victor <andrew@sanpeople.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 1/2] Use common cpu_is_xxx() macros on AT91 and AVR32
Date: Mon,  7 May 2007 10:48:03 +0200
Message-Id: <11785276841920-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.4.4.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Several drivers shared between AT91 and AVR32 chips use cpu_is_xxx()
to handle CPU-specific differences. Currently, such code needs to be
inside #ifdef CONFIG_ARCH_AT91 because the macros don't exist on AVR32.

By defining the same macros on both AT91 and AVR32, these #ifdefs can
be eliminated. Since the macros will evaluate to a constant value for
CPUs that aren't supported by the current architecture, any code that
is only needed on AT91 will be optimized away on AVR32 and vice versa.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 include/asm-arm/arch-at91/cpu.h     |    6 ++++++
 include/asm-avr32/arch-at32ap/cpu.h |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/asm-arm/arch-at91/cpu.h b/include/asm-arm/arch-at91/cpu.h
index d464ca5..7ef4eeb 100644
--- a/include/asm-arm/arch-at91/cpu.h
+++ b/include/asm-arm/arch-at91/cpu.h
@@ -68,4 +68,10 @@ static inline unsigned long at91_arch_identify(void)
 #define cpu_is_at91sam9263()	(0)
 #endif
 
+/*
+ * Since this is ARM, we will never run on any AVR32 CPU. But these
+ * definitions may reduce clutter in common drivers.
+ */
+#define cpu_is_at32ap7000()	(0)
+
 #endif
diff --git a/include/asm-avr32/arch-at32ap/cpu.h b/include/asm-avr32/arch-at32ap/cpu.h
new file mode 100644
index 0000000..2bdc5bd
--- /dev/null
+++ b/include/asm-avr32/arch-at32ap/cpu.h
@@ -0,0 +1,33 @@
+/*
+ * AVR32 and (fake) AT91 CPU identification
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_ARCH_CPU_H
+#define __ASM_ARCH_CPU_H
+
+/*
+ * Only AT32AP7000 is defined for now. We can identify the specific
+ * chip at runtime, but I'm not sure if it's really worth it.
+ */
+#ifdef CONFIG_CPU_AT32AP7000
+# define cpu_is_at32ap7000()	(1)
+#else
+# define cpu_is_at32ap7000()	(0)
+#endif
+
+/*
+ * Since this is AVR32, we will never run on any AT91 CPU. But these
+ * definitions may reduce clutter in common drivers.
+ */
+#define cpu_is_at91rm9200()	(0)
+#define cpu_is_at91sam9xe()	(0)
+#define cpu_is_at91sam9260()	(0)
+#define cpu_is_at91sam9261()	(0)
+#define cpu_is_at91sam9263()	(0)
+
+#endif /* __ASM_ARCH_CPU_H */
-- 
1.4.4.4

