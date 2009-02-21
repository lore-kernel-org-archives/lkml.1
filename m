Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZBURIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZBURIo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 12:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZBURIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 12:08:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49687 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbZBURIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 12:08:30 -0500
Date: Sat, 21 Feb 2009 18:08:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 fixes
Message-ID: <20090221170813.GA32308@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, mce: remove incorrect __cpuinit for mce_cpu_features()

Zachary Amsden (1):
      MAINTAINERS: paravirt-ops maintainers update


 MAINTAINERS                               |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_64.c       |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 06e0391..59fd2d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3334,8 +3334,8 @@ P:	Jeremy Fitzhardinge
 M:	jeremy@xensource.com
 P:	Chris Wright
 M:	chrisw@sous-sol.org
-P:	Zachary Amsden
-M:	zach@vmware.com
+P:	Alok Kataria
+M:	akataria@vmware.com
 P:	Rusty Russell
 M:	rusty@rustcorp.com.au
 L:	virtualization@lists.osdl.org
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 25cf624..fe79985 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -490,7 +490,7 @@ static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
 
 }
 
-static void __cpuinit mce_cpu_features(struct cpuinfo_x86 *c)
+static void mce_cpu_features(struct cpuinfo_x86 *c)
 {
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 8ae8c4f..f2ee0ae 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -121,7 +121,7 @@ static long threshold_restart_bank(void *_tr)
 }
 
 /* cpu init entry point, called from mce.c with preempt off */
-void __cpuinit mce_amd_feature_init(struct cpuinfo_x86 *c)
+void mce_amd_feature_init(struct cpuinfo_x86 *c)
 {
 	unsigned int bank, block;
 	unsigned int cpu = smp_processor_id();
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index 4b48f25..f44c366 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -30,7 +30,7 @@ asmlinkage void smp_thermal_interrupt(void)
 	irq_exit();
 }
 
-static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
+static void intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 	int tm2 = 0;
@@ -84,7 +84,7 @@ static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
 	return;
 }
 
-void __cpuinit mce_intel_feature_init(struct cpuinfo_x86 *c)
+void mce_intel_feature_init(struct cpuinfo_x86 *c)
 {
 	intel_init_thermal(c);
 }
