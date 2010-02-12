Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab0BLWUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:20:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab0BLWUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:20:50 -0500
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com
Subject: [PATCH 1/4] nmi_watchdog: use a boolean config flag for compiling
Date: Fri, 12 Feb 2010 17:19:18 -0500
Message-Id: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Determines if an arch has setup arch specific perf_events and nmi_watchdog
code.  This should restrict compiles to only those arches ready.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/Kconfig  |    1 +
 init/Kconfig      |    5 +++++
 lib/Kconfig.debug |    3 +--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cbcbfde..4f9685f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -52,6 +52,7 @@ config X86
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select PERF_EVENTS
+	select PERF_EVENTS_NMI
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
diff --git a/init/Kconfig b/init/Kconfig
index ada4844..7331a16 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -946,6 +946,11 @@ config PERF_USE_VMALLOC
 	help
 	  See tools/perf/design.txt for details
 
+config PERF_EVENTS_NMI
+	bool
+	help
+	  Arch has support for nmi_watchdog
+
 menu "Kernel Performance Events And Counters"
 
 config PERF_EVENTS
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index acef882..01a4d85 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -172,8 +172,7 @@ config DETECT_SOFTLOCKUP
 
 config NMI_WATCHDOG
 	bool "Detect Hard Lockups with an NMI Watchdog"
-	depends on DEBUG_KERNEL && PERF_EVENTS
-	depends on X86
+	depends on DEBUG_KERNEL && PERF_EVENTS && PERF_EVENTS_NMI
 	default y
 	help
 	  Say Y here to enable the kernel to use the NMI as a watchdog
-- 
1.6.6.83.gc9a2

