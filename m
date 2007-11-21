Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbXKUROp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbXKUROp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 12:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXKUROg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 12:14:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbXKUROf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 12:14:35 -0500
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH] Add the word 'Warning' in check_nmi_watchdog() output
Date: Wed, 21 Nov 2007 12:14:20 -0500
Message-Id: <1195665260-14641-1-git-send-email-dzickus@redhat.com>
X-Mailer: git-send-email 1.5.3.5.562.g2544e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Our automated test suite looks for keywords like error, fail, warning in the
boot log.  In the case when the nmi watchdog is determined to be stuck in
check_nmi_watchdog(), none of those keywords are displayed.

This patch adds a keyword, 'Warning, so it makes it easier to notice when the nmi
watchdog isn't working correctly.

No technical changes have been made.  Compiler tested.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/nmi_32.c |    2 +-
 arch/x86/kernel/nmi_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 600fd40..47448ac 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -105,7 +105,7 @@ static int __init check_nmi_watchdog(void)
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
 		if (nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
-			printk("CPU#%d: NMI appears to be stuck (%d->%d)!\n",
+			printk("CPU#%d: Warning NMI appears to be stuck (%d->%d)!\n",
 				cpu,
 				prev_nmi_count[cpu],
 				nmi_count(cpu));
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index a576fd7..a460d4a 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -109,7 +109,7 @@ int __init check_nmi_watchdog (void)
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
 		if (cpu_pda(cpu)->__nmi_count - counts[cpu] <= 5) {
-			printk("CPU#%d: NMI appears to be stuck (%d->%d)!\n",
+			printk("CPU#%d: Warning NMI appears to be stuck (%d->%d)!\n",
 			       cpu,
 			       counts[cpu],
 			       cpu_pda(cpu)->__nmi_count);
-- 
1.5.3.5.562.g2544e

