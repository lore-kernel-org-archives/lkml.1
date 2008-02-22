Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbYBVVLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbYBVVLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbYBVVJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:09:38 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41952 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486AbYBVVJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:09:33 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="773386"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pj@sgi.com,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH sched-devel 6/7] cpuisol: Minor updates to the Kconfig options
Date: Fri, 22 Feb 2008 13:09:17 -0800
Message-Id: <1203714558-20904-6-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203714558-20904-5-git-send-email-maxk@qualcomm.com>
References: <1203714558-20904-1-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-2-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-3-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-4-git-send-email-maxk@qualcomm.com>
 <1203714558-20904-5-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a couple of typos, long lines and referred to the documentation file.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 kernel/Kconfig.cpuisol |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/kernel/Kconfig.cpuisol b/kernel/Kconfig.cpuisol
index 81f1972..e681b02 100644
--- a/kernel/Kconfig.cpuisol
+++ b/kernel/Kconfig.cpuisol
@@ -2,23 +2,26 @@ config CPUISOL
 	depends on SMP
 	bool "CPU isolation"
 	help
-	  This option enables support for CPU isolation.
-	  If enabled the kernel will try to avoid kernel activity on the isolated CPUs.
-	  By default user-space threads are not scheduled on the isolated CPUs unless 
-	  they explicitly request it (via sched_ and pthread_ affinity calls). Isolated
-	  CPUs are not subject to the scheduler load-balancing algorithms.
-	  
-	  CPUs can be marked as isolated using 'isolcpus=' command line option or by 
-	  writing '1' into /sys/devices/system/cpu/cpuN/isolated.
-	  
-	  This feature is useful for hard realtime and high performance applications.
+	  This option enables support for CPU isolation. If enabled the
+	  kernel will try to avoid kernel activity on the isolated CPUs.
+	  By default user-space threads are not scheduled on the isolated
+	  CPUs unless they explicitly request it via sched_setaffinity()
+	  and pthread_setaffinity_np() calls. Isolated CPUs are not
+	  subject to the scheduler load-balancing algorithms.
+
+	  This feature is useful for hard realtime and high performance
+	  applications.
+	  See Documentation/cpu-isolation.txt for more details.
+
 	  If unsure say 'N'.
 
 config CPUISOL_WORKQUEUE
 	bool "Do not schedule workqueues on the isolated CPUs (EXPERIMENTAL)"
 	depends on CPUISOL && EXPERIMENTAL
 	help
-	  In this option is enabled kernel will not schedule workqueues on the 
-	  isolated CPUs.
-	  Please note that at this point this feature is experimental. It brakes 
-	  certain things like OProfile that heavily rely on per cpu workqueues.
+	  If this option is enabled kernel will not schedule workqueues on
+	  the isolated CPUs.  Please note that at this point this feature
+	  is experimental. It breaks certain things like OProfile that
+	  heavily rely on per cpu workqueues.
+
+	  Say 'Y' to enable workqueue isolation.  If unsure say 'N'.
-- 
1.5.4.1

