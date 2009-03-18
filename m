Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbZCRVpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbZCRVpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZCRVmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:42:23 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756454AbZCRVmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:42:22 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 25/57] microblaze_v7: delay.h, timex.h
Date: Wed, 18 Mar 2009 21:30:52 +0100
Message-Id: <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/delay.h |   72 +++++++++++++++++++++++++++++++++++
 arch/microblaze/include/asm/timex.h |   18 +++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/delay.h
 create mode 100644 arch/microblaze/include/asm/timex.h

diff --git a/arch/microblaze/include/asm/delay.h b/arch/microblaze/include/asm/delay.h
new file mode 100644
index 0000000..05b7d39
--- /dev/null
+++ b/arch/microblaze/include/asm/delay.h
@@ -0,0 +1,72 @@
+/*
+ * include/asm-microblaze/delay.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2008 Michal Simek
+ * Copyright (C) 2007 John Williams
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_DELAY_H
+#define _ASM_MICROBLAZE_DELAY_H
+
+extern inline void __delay(unsigned long loops)
+{
+	asm volatile ("# __delay		\n\t"		\
+			"1: addi	%0, %0, -1\t\n"		\
+			"bneid	%0, 1b		\t\n"		\
+			"nop			\t\n"
+			: "=r" (loops)
+			: "0" (loops));
+}
+
+/*
+ * Note that 19 * 226 == 4294 ==~ 2^32 / 10^6, so
+ * loops = (4294 * usecs * loops_per_jiffy * HZ) / 2^32.
+ *
+ * The mul instruction gives us loops = (a * b) / 2^32.
+ * We choose a = usecs * 19 * HZ and b = loops_per_jiffy * 226
+ * because this lets us support a wide range of HZ and
+ * loops_per_jiffy values without either a or b overflowing 2^32.
+ * Thus we need usecs * HZ <= (2^32 - 1) / 19 = 226050910 and
+ * loops_per_jiffy <= (2^32 - 1) / 226 = 19004280
+ * (which corresponds to ~3800 bogomips at HZ = 100).
+ * -- paulus
+ */
+#define __MAX_UDELAY	(226050910UL/HZ)	/* maximum udelay argument */
+#define __MAX_NDELAY	(4294967295UL/HZ)	/* maximum ndelay argument */
+
+extern unsigned long loops_per_jiffy;
+
+extern inline void __udelay(unsigned int x)
+{
+
+	unsigned long long tmp =
+		(unsigned long long)x * (unsigned long long)loops_per_jiffy \
+			* 226LL;
+	unsigned loops = tmp >> 32;
+
+/*
+	__asm__("mulxuu %0,%1,%2" : "=r" (loops) :
+		"r" (x), "r" (loops_per_jiffy * 226));
+*/
+	__delay(loops);
+}
+
+extern void __bad_udelay(void);		/* deliberately undefined */
+extern void __bad_ndelay(void);		/* deliberately undefined */
+
+#define udelay(n) (__builtin_constant_p(n) ? \
+	((n) > __MAX_UDELAY ? __bad_udelay() : __udelay((n) * (19 * HZ))) : \
+	__udelay((n) * (19 * HZ)))
+
+#define ndelay(n) (__builtin_constant_p(n) ? \
+	((n) > __MAX_NDELAY ? __bad_ndelay() : __udelay((n) * HZ)) : \
+	__udelay((n) * HZ))
+
+#define muldiv(a, b, c)		(((a)*(b))/(c))
+
+#endif /* _ASM_MICROBLAZE_DELAY_H */
diff --git a/arch/microblaze/include/asm/timex.h b/arch/microblaze/include/asm/timex.h
new file mode 100644
index 0000000..678525d
--- /dev/null
+++ b/arch/microblaze/include/asm/timex.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_TIMEX_H
+#define _ASM_MICROBLAZE_TIMEX_H
+
+#define CLOCK_TICK_RATE 1000 /* Timer input freq. */
+
+typedef unsigned long cycles_t;
+
+#define get_cycles()	(0)
+
+#endif /* _ASM_TIMEX_H */
-- 
1.5.5.1

