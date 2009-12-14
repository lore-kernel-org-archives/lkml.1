Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZLMX7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZLMX7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZLMX7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:59:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35183 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbZLMX6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:49 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [PATCH 1/1] Constify struct wd_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:38 +0100
Message-Id: <caf988a9c8087f157203fa3b7a6c172954ee1436.1260663005.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663005.git.re.emese@gmail.com>
References: <cover.1260663005.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/x86/kernel/cpu/perfctr-watchdog.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 898df97..89dad0b 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -30,11 +30,11 @@ struct nmi_watchdog_ctlblk {
 
 /* Interface defining a CPU specific perfctr watchdog */
 struct wd_ops {
-	int (*reserve)(void);
-	void (*unreserve)(void);
-	int (*setup)(unsigned nmi_hz);
-	void (*rearm)(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz);
-	void (*stop)(void);
+	int (* const reserve)(void);
+	void (* const unreserve)(void);
+	int (* const setup)(unsigned nmi_hz);
+	void (* const rearm)(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz);
+	void (* const stop)(void);
 	unsigned perfctr;
 	unsigned evntsel;
 	u64 checkbit;
@@ -645,6 +645,7 @@ static const struct wd_ops p4_wd_ops = {
 #define ARCH_PERFMON_NMI_EVENT_SEL	ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL
 #define ARCH_PERFMON_NMI_EVENT_UMASK	ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK
 
+/* cannot be const, see probe_nmi_watchdog */
 static struct wd_ops intel_arch_wd_ops;
 
 static int setup_intel_arch_watchdog(unsigned nmi_hz)
@@ -697,6 +698,7 @@ static int setup_intel_arch_watchdog(unsigned nmi_hz)
 	return 1;
 }
 
+/* cannot be const, see probe_nmi_watchdog */
 static struct wd_ops intel_arch_wd_ops __read_mostly = {
 	.reserve	= single_msr_reserve,
 	.unreserve	= single_msr_unreserve,
-- 
1.6.5.3

