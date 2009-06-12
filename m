Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZFLNCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZFLNCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762689AbZFLM71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:27 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:59954 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762548AbZFLM7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:22 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz655Nzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KL4MQM-03-HW5-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 12/23] x86/oprofile: fix and cleanup CTRL_SET_* macros
Date: Fri, 12 Jun 2009 14:35:29 +0200
Message-ID: <1244810140-20595-13-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:06.0998 (UTC) FILETIME=[91F49160:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes missing braces around macro parameters. Macro
definitions from intel_arch_perfmon.h are used where possible.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_ppro.c |    1 -
 arch/x86/oprofile/op_x86_model.h  |   18 ++++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 6c5d288..61ee8f6 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -18,7 +18,6 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
-#include <asm/intel_arch_perfmon.h>
 
 #include "op_x86_model.h"
 #include "op_counter.h"
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index c80ec7d..a207b1c 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -11,14 +11,16 @@
 #ifndef OP_X86_MODEL_H
 #define OP_X86_MODEL_H
 
-#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
-#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
-#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
-#define CTRL_SET_ENABLE(val) (val |= 1<<20)
-#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
-#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
-#define CTRL_SET_UM(val, m) (val |= (m << 8))
-#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
+#include <asm/intel_arch_perfmon.h>
+
+#define CTR_IS_RESERVED(msrs, c)	((msrs)->counters[(c)].addr ? 1 : 0)
+#define CTRL_IS_RESERVED(msrs, c)	((msrs)->controls[(c)].addr ? 1 : 0)
+#define CTRL_SET_ACTIVE(val)		((val) |= ARCH_PERFMON_EVENTSEL0_ENABLE)
+#define CTRL_SET_ENABLE(val)		((val) |= ARCH_PERFMON_EVENTSEL_INT)
+#define CTRL_SET_INACTIVE(val)		((val) &= ~ARCH_PERFMON_EVENTSEL0_ENABLE)
+#define CTRL_SET_KERN(val, k)		((val) |= ((k) ? ARCH_PERFMON_EVENTSEL_OS : 0))
+#define CTRL_SET_USR(val, u)		((val) |= ((u) ? ARCH_PERFMON_EVENTSEL_USR : 0))
+#define CTRL_SET_UM(val, m)		((val) |= ((m) << 8))
 
 struct op_saved_msr {
 	unsigned int high;
-- 
1.6.3.1


