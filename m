Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYA1EeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYA1EeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYA1Edg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:33:36 -0500
Received: from warlock.qualcomm.com ([129.46.50.49]:41107 "EHLO
	warlock.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYA1Ed3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:33:29 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 23:33:28 EST
From: maxk@qualcomm.com
To: linux-kernel@vger.kernel.org
Cc: Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] [CPUISOL] Add config options for CPU isolation
Date: Sun, 27 Jan 2008 20:09:38 -0800
Message-Id: <1201493382-29804-2-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyansky <maxk@qualcomm.com>

This simply adds a couple of new kconfig options for
configuring CPU isolation features.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 arch/x86/Kconfig       |    1 +
 kernel/Kconfig.cpuisol |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 kernel/Kconfig.cpuisol

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80b7ba4..b8f986e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -495,6 +495,7 @@ config SCHED_MC
 	  increased overhead in some places. If unsure say N here.
 
 source "kernel/Kconfig.preempt"
+source "kernel/Kconfig.cpuisol"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
diff --git a/kernel/Kconfig.cpuisol b/kernel/Kconfig.cpuisol
new file mode 100644
index 0000000..6e099a4
--- /dev/null
+++ b/kernel/Kconfig.cpuisol
@@ -0,0 +1,24 @@
+config CPUISOL
+	depends on SMP
+	bool "CPU isolation"
+	help
+	  This option enables support for CPU isolation.
+	  If enabled the kernel will try to avoid kernel activity on the isolated CPUs.
+	  By default user-space threads are not scheduled on the isolated CPUs unless 
+	  they explicitly request it (via sched_ and pthread_ affinity calls). Isolated
+	  CPUs are not subject to the scheduler load-balancing algorithms.
+	  
+	  CPUs can be marked as isolated using 'cpuisol=' command line option or by 
+	  writing '1' into /sys/devices/system/cpu/cpuN/isolated.
+	  
+	  This feature is useful for hard realtime and high performance applications.
+	  If unsure say 'N'.
+
+config CPUISOL_WORKQUEUE
+	bool "Do not schedule workqueues on isolated CPUs (EXPERIMENTAL)"
+	depends on CPUISOL && EXPERIMENTAL
+	help
+	  In this option is enabled kernel will not schedule workqueues on the 
+	  isolated CPUs.
+	  Please note that at this point this feature is experimental. It brakes 
+	  certain things like OProfile that heavily rely on per cpu workqueues.
-- 
1.5.3.7

