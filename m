Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYEDPQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYEDPQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYEDPQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:16:31 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:41924 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038AbYEDPQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:16:29 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 24/56] microblaze_v2: time support
Date: Sun,  4 May 2008 13:41:13 +0200
Message-Id: <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/time.c  |   90 ++++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/delay.h |   33 +++++++++++++++
 include/asm-microblaze/timex.h |   20 +++++++++
 3 files changed, 143 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/time.c
 create mode 100644 include/asm-microblaze/delay.h
 create mode 100644 include/asm-microblaze/timex.h

diff --git a/arch/microblaze/kernel/time.c b/arch/microblaze/kernel/time.c
new file mode 100644
index 0000000..d5ebdff
--- /dev/null
+++ b/arch/microblaze/kernel/time.c
@@ -0,0 +1,90 @@
+/*
+ * arch/microblaze/kernel/time.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/jiffies.h>
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <asm/bug.h>
+#include <asm/setup.h>
+
+void time_init(void)
+{
+	system_timer_init();
+}
+
+int do_settimeofday(struct timespec *tv)
+{
+	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
+
+	write_seqlock_irq(&xtime_lock);
+
+	/* This is revolting. We need to set the xtime.tv_nsec
+	 * correctly. However, the value in this location is
+	 * is value at the last tick.
+	 * Discover what correction gettimeofday
+	 * would have done, and then undo it!
+	 */
+#if 0
+	tv->tv_nsec -= mach_gettimeoffset() * 1000;
+#endif
+
+	while (tv->tv_nsec < 0) {
+		tv->tv_nsec += NSEC_PER_SEC;
+		tv->tv_sec--;
+	}
+
+	xtime.tv_sec = tv->tv_sec;
+	xtime.tv_nsec = tv->tv_nsec;
+
+	time_adjust = 0;
+	time_status |= STA_UNSYNC;
+	time_maxerror = NTP_PHASE_LIMIT;
+	time_esterror = NTP_PHASE_LIMIT;
+
+	write_sequnlock_irq(&xtime_lock);
+	clock_was_set();
+	return 0;
+}
+EXPORT_SYMBOL(do_settimeofday);
+
+/*
+ * This version of gettimeofday has near microsecond resolution.
+ */
+void do_gettimeofday(struct timeval *tv)
+{
+	unsigned long seq;
+	unsigned long usec, sec;
+	/* unsigned long max_ntp_tick = tick_usec - tickadj; */
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		usec = do_gettimeoffset();
+		sec = xtime.tv_sec;
+		usec += (xtime.tv_nsec / 1000);
+	} while (read_seqretry(&xtime_lock, seq));
+
+	while (usec >= 1000000) {
+		usec -= 1000000;
+		sec++;
+	}
+
+	tv->tv_sec = sec;
+	tv->tv_usec = usec;
+}
+EXPORT_SYMBOL(do_gettimeofday);
+
+unsigned long long sched_clock(void)
+{
+	return (unsigned long long)jiffies * (1000000000 / HZ);
+}
diff --git a/include/asm-microblaze/delay.h b/include/asm-microblaze/delay.h
new file mode 100644
index 0000000..481359c
--- /dev/null
+++ b/include/asm-microblaze/delay.h
@@ -0,0 +1,33 @@
+/*
+ * include/asm-microblaze/delay.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_DELAY_H
+#define _ASM_MICROBLAZE_DELAY_H
+
+#include <asm/param.h>
+
+static inline void __delay(unsigned long loops)
+{
+	asm volatile ("# __delay		\n\t"		\
+			"1: addi	%0, %0, -1 \t\n"	\
+			"bneid	%0, 1b		\t\n"		\
+			"nop			\t\n"
+			: "=r" (loops)
+			: "0" (loops));
+}
+
+static inline void udelay(unsigned long usec)
+{
+	unsigned long long tmp = usec;
+	unsigned long loops = (tmp * 4295 * HZ * loops_per_jiffy) >> 32;
+	__delay(loops);
+}
+
+#endif /* _ASM_MICROBLAZE_DELAY_H */
diff --git a/include/asm-microblaze/timex.h b/include/asm-microblaze/timex.h
new file mode 100644
index 0000000..b3e77ef
--- /dev/null
+++ b/include/asm-microblaze/timex.h
@@ -0,0 +1,20 @@
+/*
+ * include/asm-microblaze/timex.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
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
1.5.4.GIT

