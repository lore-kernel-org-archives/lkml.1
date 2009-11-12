Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbZKLIWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbZKLIWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZKLIWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:22:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:58543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZKLIWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:22:40 -0500
Date: Thu, 12 Nov 2009 08:22:06 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yong.y.wang@linux.intel.com, seto.hidetoshi@jp.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yong.y.wang@linux.intel.com, seto.hidetoshi@jp.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AFBB0B8.2070501@jp.fujitsu.com>
References: <4AFBB0B8.2070501@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/mce] x86, mce: Fix __init annotations
Message-ID: <tip-cffd377e5879ea58522224a785a083f201afd80e@git.kernel.org>
Git-Commit-ID: cffd377e5879ea58522224a785a083f201afd80e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cffd377e5879ea58522224a785a083f201afd80e
Gitweb:     http://git.kernel.org/tip/cffd377e5879ea58522224a785a083f201afd80e
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Thu, 12 Nov 2009 15:52:40 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Nov 2009 09:17:11 +0100

x86, mce: Fix __init annotations

The intel_init_thermal() is called from resume path, so it
cannot be marked as __init.

OTOH mce_banks_init() is only called from
__mcheck_cpu_cap_init() which is marked as __cpuinit, so it can
be also marked as __cpuinit.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Yong Wang <yong.y.wang@linux.intel.com>
LKML-Reference: <4AFBB0B8.2070501@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c         |    4 ++--
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0d41020..5f277ca 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1201,7 +1201,7 @@ int mce_notify_irq(void)
 }
 EXPORT_SYMBOL_GPL(mce_notify_irq);
 
-static int mce_banks_init(void)
+static int __cpuinit __mcheck_cpu_mce_banks_init(void)
 {
 	int i;
 
@@ -1242,7 +1242,7 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 	WARN_ON(banks != 0 && b != banks);
 	banks = b;
 	if (!mce_banks) {
-		int err = mce_banks_init();
+		int err = __mcheck_cpu_mce_banks_init();
 
 		if (err)
 			return err;
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 8a73d5c..4fef985 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -268,7 +268,7 @@ void __init mcheck_intel_therm_init(void)
 		lvtthmr_init = apic_read(APIC_LVTTHMR);
 }
 
-void __init intel_init_thermal(struct cpuinfo_x86 *c)
+void intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	unsigned int cpu = smp_processor_id();
 	int tm2 = 0;
