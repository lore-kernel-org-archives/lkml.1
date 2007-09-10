Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbXIJNCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbXIJNCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbXIJNB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:01:58 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:43648
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758236AbXIJNB5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:01:57 -0400
Message-Id: <46E55C95.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Sep 2007 14:02:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: constify wd_ops
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. as they're, with a single exception, never written to.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/kernel/cpu/perfctr-watchdog.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc5/arch/i386/kernel/cpu/perfctr-watchdog.c	2007-09-07 16:44:45.000000000 +0200
+++ 2.6.23-rc5-x86-const-wd_ops/arch/i386/kernel/cpu/perfctr-watchdog.c	2007-09-10 12:28:13.000000000 +0200
@@ -34,7 +34,7 @@ struct wd_ops {
 	u64 checkbit;
 };
 
-static struct wd_ops *wd_ops;
+static const struct wd_ops *wd_ops;
 
 /* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
  * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
@@ -317,7 +317,7 @@ static void single_msr_rearm(struct nmi_
 	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
 }
 
-static struct wd_ops k7_wd_ops = {
+static const struct wd_ops k7_wd_ops = {
 	.reserve = single_msr_reserve,
 	.unreserve = single_msr_unreserve,
 	.setup = setup_k7_watchdog,
@@ -380,7 +380,7 @@ static void p6_rearm(struct nmi_watchdog
 	write_watchdog_counter32(wd->perfctr_msr, NULL,nmi_hz);
 }
 
-static struct wd_ops p6_wd_ops = {
+static const struct wd_ops p6_wd_ops = {
 	.reserve = single_msr_reserve,
 	.unreserve = single_msr_unreserve,
 	.setup = setup_p6_watchdog,
@@ -532,7 +532,7 @@ static void p4_rearm(struct nmi_watchdog
 	write_watchdog_counter(wd->perfctr_msr, NULL, nmi_hz);
 }
 
-static struct wd_ops p4_wd_ops = {
+static const struct wd_ops p4_wd_ops = {
 	.reserve = p4_reserve,
 	.unreserve = p4_unreserve,
 	.setup = setup_p4_watchdog,
@@ -550,6 +550,8 @@ static struct wd_ops p4_wd_ops = {
 #define ARCH_PERFMON_NMI_EVENT_SEL	ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL
 #define ARCH_PERFMON_NMI_EVENT_UMASK	ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK
 
+static struct wd_ops intel_arch_wd_ops;
+
 static int setup_intel_arch_watchdog(unsigned nmi_hz)
 {
 	unsigned int ebx;
@@ -591,11 +593,11 @@ static int setup_intel_arch_watchdog(uns
 	wd->perfctr_msr = perfctr_msr;
 	wd->evntsel_msr = evntsel_msr;
 	wd->cccr_msr = 0;  //unused
-	wd_ops->checkbit = 1ULL << (eax.split.bit_width - 1);
+	intel_arch_wd_ops.checkbit = 1ULL << (eax.split.bit_width - 1);
 	return 1;
 }
 
-static struct wd_ops intel_arch_wd_ops = {
+static struct wd_ops intel_arch_wd_ops __read_mostly = {
 	.reserve = single_msr_reserve,
 	.unreserve = single_msr_unreserve,
 	.setup = setup_intel_arch_watchdog,



