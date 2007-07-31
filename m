Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbXGaX0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbXGaX0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbXGaXZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:25:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46228 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754086AbXGaXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:25:13 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 3/7] Simple Performance Counters: i386 support
Date: Tue, 31 Jul 2007 16:25:08 -0700
Message-Id: <11859243121503-git-send-email-clameter@sgi.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: simple-perf-counters
References: simple-perf-counters
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export a cycles_to_ns function

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 arch/i386/kernel/tsc.c   |    2 +-
 include/asm-i386/timex.h |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/tsc.c b/arch/i386/kernel/tsc.c
index debd7db..c150ac0 100644
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -118,7 +118,7 @@ unsigned long long native_sched_clock(void)
 	rdtscll(this_offset);
 
 	/* return the value in ns */
-	return cycles_2_ns(this_offset);
+	return cycles_to_ns(this_offset);
 }
 
 /* We need to define a real function for sched_clock, to override the
diff --git a/include/asm-i386/timex.h b/include/asm-i386/timex.h
index 3666044..37b0338 100644
--- a/include/asm-i386/timex.h
+++ b/include/asm-i386/timex.h
@@ -19,4 +19,12 @@
 extern int read_current_timer(unsigned long *timer_value);
 #define ARCH_HAS_READ_CURRENT_TIMER	1
 
+extern long cyc2ns_scale;
+#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
+
+static inline unsigned long long cycles_to_ns(unsigned long long cyc)
+{
+	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+}
+
 #endif
-- 
1.5.2.4

