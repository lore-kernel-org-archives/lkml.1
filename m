Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbYL0Gtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbYL0Gtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 01:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYL0Gtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 01:49:40 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36032 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYL0Gtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 01:49:39 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] linux/timex.h: cleanup for userspace
Date: Sat, 27 Dec 2008 01:49:38 -0500
Message-Id: <1230360578-6605-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all the kernel-specific defines and includes into the __KERNEL__
section so that they don't get leaked into userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/timex.h |   73 +++++++++++++++++++++++++------------------------
 1 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 9007313..4bbbab5 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -53,47 +53,11 @@
 #ifndef _LINUX_TIMEX_H
 #define _LINUX_TIMEX_H
 
-#include <linux/compiler.h>
 #include <linux/time.h>
 
-#include <asm/param.h>
-
 #define NTP_API		4	/* NTP API version */
 
 /*
- * SHIFT_KG and SHIFT_KF establish the damping of the PLL and are chosen
- * for a slightly underdamped convergence characteristic. SHIFT_KH
- * establishes the damping of the FLL and is chosen by wisdom and black
- * art.
- *
- * MAXTC establishes the maximum time constant of the PLL. With the
- * SHIFT_KG and SHIFT_KF values given and a time constant range from
- * zero to MAXTC, the PLL will converge in 15 minutes to 16 hours,
- * respectively.
- */
-#define SHIFT_PLL	4	/* PLL frequency factor (shift) */
-#define SHIFT_FLL	2	/* FLL frequency factor (shift) */
-#define MAXTC		10	/* maximum time constant (shift) */
-
-/*
- * SHIFT_USEC defines the scaling (shift) of the time_freq and
- * time_tolerance variables, which represent the current frequency
- * offset and maximum frequency tolerance.
- */
-#define SHIFT_USEC 16		/* frequency offset scale (shift) */
-#define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
-#define PPM_SCALE_INV_SHIFT 19
-#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
-		       PPM_SCALE + 1)
-
-#define MAXPHASE 500000000l	/* max phase error (ns) */
-#define MAXFREQ 500000		/* max frequency error (ns/s) */
-#define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
-#define MINSEC 256		/* min interval between updates (s) */
-#define MAXSEC 2048		/* max interval between updates (s) */
-#define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
-
-/*
  * syscall interface - used (mainly by NTP daemon)
  * to discipline kernel clock oscillator
  */
@@ -199,9 +163,46 @@ struct timex {
 #define TIME_BAD	TIME_ERROR /* bw compat */
 
 #ifdef __KERNEL__
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+#include <asm/param.h>
 #include <asm/timex.h>
 
 /*
+ * SHIFT_KG and SHIFT_KF establish the damping of the PLL and are chosen
+ * for a slightly underdamped convergence characteristic. SHIFT_KH
+ * establishes the damping of the FLL and is chosen by wisdom and black
+ * art.
+ *
+ * MAXTC establishes the maximum time constant of the PLL. With the
+ * SHIFT_KG and SHIFT_KF values given and a time constant range from
+ * zero to MAXTC, the PLL will converge in 15 minutes to 16 hours,
+ * respectively.
+ */
+#define SHIFT_PLL	4	/* PLL frequency factor (shift) */
+#define SHIFT_FLL	2	/* FLL frequency factor (shift) */
+#define MAXTC		10	/* maximum time constant (shift) */
+
+/*
+ * SHIFT_USEC defines the scaling (shift) of the time_freq and
+ * time_tolerance variables, which represent the current frequency
+ * offset and maximum frequency tolerance.
+ */
+#define SHIFT_USEC 16		/* frequency offset scale (shift) */
+#define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
+#define PPM_SCALE_INV_SHIFT 19
+#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
+		       PPM_SCALE + 1)
+
+#define MAXPHASE 500000000l	/* max phase error (ns) */
+#define MAXFREQ 500000		/* max frequency error (ns/s) */
+#define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
+#define MINSEC 256		/* min interval between updates (s) */
+#define MAXSEC 2048		/* max interval between updates (s) */
+#define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
+
+/*
  * kernel variables
  * Note: maximum error = NTP synch distance = dispersion + delay / 2;
  * estimated error = NTP dispersion.
-- 
1.6.0.6

