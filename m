Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbXGaXZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbXGaXZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbXGaXZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:25:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46226 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753777AbXGaXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:25:13 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 2/7] Simple Performance Counters: x86_64 support
Date: Tue, 31 Jul 2007 16:25:07 -0700
Message-Id: <11859243121617-git-send-email-clameter@sgi.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: simple-perf-counters
References: simple-perf-counters
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export cycles_to_ns (after renaming the cycles_2_ns to cycles_to_ns to be
conforming to other arches).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 arch/x86_64/kernel/tsc.c   |    4 ++--
 include/asm-x86_64/timex.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86_64/kernel/tsc.c b/arch/x86_64/kernel/tsc.c
index 2a59bde..59f69af 100644
--- a/arch/x86_64/kernel/tsc.c
+++ b/arch/x86_64/kernel/tsc.c
@@ -23,7 +23,7 @@ void set_cyc2ns_scale(unsigned long khz)
 	cyc2ns_scale = (NSEC_PER_MSEC << NS_SCALE) / khz;
 }
 
-static unsigned long long cycles_2_ns(unsigned long long cyc)
+unsigned long long cycles_to_ns(unsigned long long cyc)
 {
 	return (cyc * cyc2ns_scale) >> NS_SCALE;
 }
@@ -39,7 +39,7 @@ unsigned long long sched_clock(void)
 	 */
 
 	rdtscll(a);
-	return cycles_2_ns(a);
+	return cycles_to_ns(a);
 }
 
 static int tsc_unstable;
diff --git a/include/asm-x86_64/timex.h b/include/asm-x86_64/timex.h
index 6ed21f4..d5e126c 100644
--- a/include/asm-x86_64/timex.h
+++ b/include/asm-x86_64/timex.h
@@ -28,4 +28,5 @@ extern int read_current_timer(unsigned long *timer_value);
 
 extern void mark_tsc_unstable(char *msg);
 extern void set_cyc2ns_scale(unsigned long khz);
+unsigned long long cycles_to_ns(unsigned long long cyc);
 #endif
-- 
1.5.2.4

