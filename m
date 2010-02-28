Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032067Ab0B1Uxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 15:53:53 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:48224 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032048Ab0B1Uxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:53:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BZ6kaEYnuwIVEIu/uIt+OfMxzQ4R33DtRnYW8R0FOiIox2hEr0Jvk7ex5A2vro2RVG
         WlNIhYaiMiS9KoDF5rKG5dRkphg/Ma1/P0aZF7Cpfx6kvxxgR+WLMN1UM0aH6UGiGDHW
         eGOB7DJ4rZyw9rc/mfbvejnDz6bDNW6eX6Eog=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "2 . 6 . 33 . x" <stable@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] hw-breakpoint fix
Date: Sun, 28 Feb 2010 21:53:36 +0100
Message-Id: <1267390416-8756-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      hw-breakpoints: Remove stub unthrottle callback


 arch/x86/kernel/hw_breakpoint.c |    5 -----
 kernel/hw_breakpoint.c          |    1 -
 2 files changed, 0 insertions(+), 6 deletions(-)

---
commit 1e259e0a9982078896f3404240096cbea01daca4
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Sun Feb 28 20:51:15 2010 +0100

    hw-breakpoints: Remove stub unthrottle callback
    
    We support event unthrottling in breakpoint events. It means
    that if we have more than sysctl_perf_event_sample_rate/HZ,
    perf will throttle, ignoring subsequent events until the next
    tick.
    
    So if ptrace exceeds this max rate, it will omit events, which
    breaks the ptrace determinism that is supposed to report every
    triggered breakpoints. This is likely to happen if we set
    sysctl_perf_event_sample_rate to 1.
    
    This patch removes support for unthrottling in breakpoint
    events to break throttling and restore ptrace determinism.
    
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: 2.6.33.x <stable@kernel.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: K.Prasad <prasad@linux.vnet.ibm.com>
    Cc: Paul Mackerras <paulus@samba.org>

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index bb6006e..1e8cead 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -531,8 +531,3 @@ void hw_breakpoint_pmu_read(struct perf_event *bp)
 {
 	/* TODO */
 }
-
-void hw_breakpoint_pmu_unthrottle(struct perf_event *bp)
-{
-	/* TODO */
-}
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 967e661..4d99512 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -489,5 +489,4 @@ struct pmu perf_ops_bp = {
 	.enable		= arch_install_hw_breakpoint,
 	.disable	= arch_uninstall_hw_breakpoint,
 	.read		= hw_breakpoint_pmu_read,
-	.unthrottle	= hw_breakpoint_pmu_unthrottle
 };
