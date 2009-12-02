Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZLBKor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZLBKor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZLBKoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:44:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:44927 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbZLBKo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:44:27 -0500
Date: Wed, 2 Dec 2009 10:44:11 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       macro@linux-mips.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, macro@linux-mips.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091201233335.232177348@sbs-t61.sc.intel.com>
References: <20091201233335.232177348@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Remove unnecessary mdelay() from cpu_disable_common()
Message-ID: <tip-6d20792e85187b27ae3d1b76678a2dd7025e8bc2@git.kernel.org>
Git-Commit-ID: 6d20792e85187b27ae3d1b76678a2dd7025e8bc2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d20792e85187b27ae3d1b76678a2dd7025e8bc2
Gitweb:     http://git.kernel.org/tip/6d20792e85187b27ae3d1b76678a2dd7025e8bc2
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 1 Dec 2009 15:31:18 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 10:11:02 +0100

x86: Remove unnecessary mdelay() from cpu_disable_common()

fixup_irqs() already has a mdelay(). Remove the extra and
unnecessary mdelay() from cpu_disable_common().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: ebiederm@xmission.com
Cc: garyhade@us.ibm.com
LKML-Reference: <20091201233335.232177348@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 565ebc6..324f2a4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1250,16 +1250,7 @@ static void __ref remove_cpu_from_maps(int cpu)
 void cpu_disable_common(void)
 {
 	int cpu = smp_processor_id();
-	/*
-	 * HACK:
-	 * Allow any queued timer interrupts to get serviced
-	 * This is only a temporary solution until we cleanup
-	 * fixup_irqs as we do for IA64.
-	 */
-	local_irq_enable();
-	mdelay(1);
 
-	local_irq_disable();
 	remove_siblinginfo(cpu);
 
 	/* It's now safe to remove this processor from the online map */
