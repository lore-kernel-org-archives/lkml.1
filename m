Return-Path: <linux-kernel-owner+w=401wt.eu-S1763841AbZFLNCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763841AbZFLNCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762604AbZFLM7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:3252 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761319AbZFLM7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:19 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz655Nzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KL4MQK-03-HW2-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 08/23] x86/oprofile: move common macros to op_x86_model.h
Date: Fri, 12 Jun 2009 14:35:25 +0200
Message-ID: <1244810140-20595-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:06.0295 (UTC) FILETIME=[91894C70:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are duplicate macro implementations in model specific code. This
patch moves all common macros to op_x86_model.h.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c  |    8 --------
 arch/x86/oprofile/op_model_p4.c   |    2 --
 arch/x86/oprofile/op_model_ppro.c |    8 --------
 arch/x86/oprofile/op_x86_model.h  |    9 +++++++++
 4 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index b54c088..4b9254a 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -26,22 +26,14 @@
 #define NUM_COUNTERS 4
 #define NUM_CONTROLS 4
 
-#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
 #define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
 #define CTR_WRITE(l, msrs, c) do {wrmsr(msrs->counters[(c)].addr, -(unsigned int)(l), -1); } while (0)
 #define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
 
-#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
 #define CTRL_READ(l, h, msrs, c) do {rdmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
 #define CTRL_WRITE(l, h, msrs, c) do {wrmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
-#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
-#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
 #define CTRL_CLEAR_LO(x) (x &= (1<<21))
 #define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
-#define CTRL_SET_ENABLE(val) (val |= 1<<20)
-#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
-#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
-#define CTRL_SET_UM(val, m) (val |= (m << 8))
 #define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
 #define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
 #define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 819b131..420c15e 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -366,8 +366,6 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 #define CCCR_OVF_P(cccr) ((cccr) & (1U<<31))
 #define CCCR_CLEAR_OVF(cccr) ((cccr) &= (~(1U<<31)))
 
-#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
-#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
 #define CTR_READ(l, h, i) do {rdmsr(p4_counters[(i)].counter_address, (l), (h)); } while (0)
 #define CTR_WRITE(l, i) do {wrmsr(p4_counters[(i)].counter_address, -(u32)(l), -1); } while (0)
 #define CTR_OVERFLOW_P(ctr) (!((ctr) & 0x80000000))
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index ae58119..a922a1a 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -26,19 +26,11 @@
 static int num_counters = 2;
 static int counter_width = 32;
 
-#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
 #define CTR_OVERFLOWED(n) (!((n) & (1ULL<<(counter_width-1))))
 
-#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
 #define CTRL_READ(l, h, msrs, c) do {rdmsr((msrs->controls[(c)].addr), (l), (h)); } while (0)
 #define CTRL_WRITE(l, h, msrs, c) do {wrmsr((msrs->controls[(c)].addr), (l), (h)); } while (0)
-#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
-#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
 #define CTRL_CLEAR(x) (x &= (1<<21))
-#define CTRL_SET_ENABLE(val) (val |= 1<<20)
-#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
-#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
-#define CTRL_SET_UM(val, m) (val |= (m << 8))
 #define CTRL_SET_EVENT(val, e) (val |= e)
 
 static u64 *reset_value;
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index bd8157d..c80ec7d 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -11,6 +11,15 @@
 #ifndef OP_X86_MODEL_H
 #define OP_X86_MODEL_H
 
+#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
+#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
+#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
+#define CTRL_SET_ENABLE(val) (val |= 1<<20)
+#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
+#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
+#define CTRL_SET_UM(val, m) (val |= (m << 8))
+#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
+
 struct op_saved_msr {
 	unsigned int high;
 	unsigned int low;
-- 
1.6.3.1


