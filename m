Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbZLDWt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbZLDWt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbZLDWt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:49:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60523 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbZLDWt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:49:57 -0500
Message-ID: <4B199287.7020307@gmail.com>
Date: Fri, 04 Dec 2009 23:51:51 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 31/31] Constify struct wd_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
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

Constify struct wd_ops with some exceptions.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/x86/kernel/cpu/perfctr-watchdog.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index fab786f..2324cbc 100644
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
 
+/* cannot be const */
 static struct wd_ops intel_arch_wd_ops;
 
 static int setup_intel_arch_watchdog(unsigned nmi_hz)
@@ -697,6 +698,7 @@ static int setup_intel_arch_watchdog(unsigned nmi_hz)
 	return 1;
 }
 
+/* cannot be const */
 static struct wd_ops intel_arch_wd_ops __read_mostly = {
 	.reserve	= single_msr_reserve,
 	.unreserve	= single_msr_unreserve,

