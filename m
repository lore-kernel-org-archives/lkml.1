Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965643Ab0BZRkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:40:20 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:47284
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965509Ab0BZRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:05 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7R-01-R6J-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 13/15] perf, x86: make IBS macros available in perf_event.h
Date: Fri, 26 Feb 2010 18:30:05 +0100
Message-ID: <1267205407-6523-14-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0523 (UTC) FILETIME=[21A0E930:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves code from oprofile to perf_event.h to make it also
available for usage by perf.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h |   10 ++++++++++
 arch/x86/oprofile/op_model_amd.c  |   11 -----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 1380367..4745f65 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -105,6 +105,16 @@ union cpuid10_edx {
  */
 #define X86_PMC_IDX_FIXED_BTS				(X86_PMC_IDX_FIXED + 16)
 
+/* IbsFetchCtl bits/masks */
+#define IBS_FETCH_RAND_EN		(1ULL<<57)
+#define IBS_FETCH_VAL			(1ULL<<49)
+#define IBS_FETCH_ENABLE		(1ULL<<48)
+#define IBS_FETCH_CNT_MASK		0xFFFF0000ULL
+
+/* IbsOpCtl bits */
+#define IBS_OP_CNT_CTL			(1ULL<<19)
+#define IBS_OP_VAL			(1ULL<<18)
+#define IBS_OP_ENABLE			(1ULL<<17)
 
 #ifdef CONFIG_PERF_EVENTS
 extern void init_hw_perf_events(void);
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 6a58256..c671749 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -46,17 +46,6 @@
 
 static unsigned long reset_value[NUM_VIRT_COUNTERS];
 
-/* IbsFetchCtl bits/masks */
-#define IBS_FETCH_RAND_EN		(1ULL<<57)
-#define IBS_FETCH_VAL			(1ULL<<49)
-#define IBS_FETCH_ENABLE		(1ULL<<48)
-#define IBS_FETCH_CNT_MASK		0xFFFF0000ULL
-
-/* IbsOpCtl bits */
-#define IBS_OP_CNT_CTL			(1ULL<<19)
-#define IBS_OP_VAL			(1ULL<<18)
-#define IBS_OP_ENABLE			(1ULL<<17)
-
 #define IBS_FETCH_SIZE			6
 #define IBS_OP_SIZE			12
 
-- 
1.6.6


