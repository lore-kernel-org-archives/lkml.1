Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0BNJNl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:13:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:33572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab0BNJNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:13:38 -0500
Date: Sun, 14 Feb 2010 09:12:42 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
References: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Use a boolean config flag for compiling
Message-ID: <tip-c3128fb6ad39b0edda6675d20585a64846cf89ea@git.kernel.org>
Git-Commit-ID: c3128fb6ad39b0edda6675d20585a64846cf89ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Feb 2010 09:12:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3128fb6ad39b0edda6675d20585a64846cf89ea
Gitweb:     http://git.kernel.org/tip/c3128fb6ad39b0edda6675d20585a64846cf89ea
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Fri, 12 Feb 2010 17:19:18 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Feb 2010 09:19:43 +0100

nmi_watchdog: Use a boolean config flag for compiling

Determines if an arch has setup arch specific perf_events and
nmi_watchdog code.  This should restrict compiles to only those
arches ready.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: peterz@infradead.org
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
LKML-Reference: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
