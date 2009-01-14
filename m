Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbZANOzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbZANOzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbZANOzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:55:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38774 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbZANOzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:55:35 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Date: Wed, 14 Jan 2009 15:55:25 +0100
Message-Id: <1231944925-5402-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH RFC] Use kernel/Kconfig.preempt for ARM
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

before this patch ARM had it's own definition of CONFIG_PREEMPT.
Instead of that use the general definition provided in
kernel/Kconfig.preempt.

It adds some dependencies such that the available options don't change
(neither for ARM nor for other archs).  The only resulting changes are
that ARM gets CONFIG_PREEMPT_NONE and the help text.

Currently the only usage of CONFIG_PREEMPT_NONE is in
kernel/trace/trace.c and only affects the content of some proc files
where "M:unknown" is changed to "M:server" if it is defined.

The intention is that ARM gets the option CONFIG_PREEMPT_RT after it
will be added to kernel/Kconfig.preempt as it is done in the linux-rt
tree.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/Kconfig       |   13 +------------
 kernel/Kconfig.preempt |    2 ++
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d6ebe39..941824e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -838,18 +838,7 @@ config LOCAL_TIMERS
 	  accounting to be spread across the timer interval, preventing a
 	  "thundering herd" at every timer tick.
 
-config PREEMPT
-	bool "Preemptible Kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  This option reduces the latency of the kernel when reacting to
-	  real-time or interactive events by allowing a low priority process to
-	  be preempted even if it is in kernel mode executing a system call.
-	  This allows applications to run more reliably even when the system is
-	  under load.
-
-	  Say Y here if you are building a kernel for a desktop, embedded
-	  or real-time system.  Say N if you are unsure.
+source kernel/Kconfig.preempt
 
 config HZ
 	int
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index bf987b9..03f136b 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -18,6 +18,7 @@ config PREEMPT_NONE
 
 config PREEMPT_VOLUNTARY
 	bool "Voluntary Kernel Preemption (Desktop)"
+	depends on !ARM
 	help
 	  This option reduces the latency of the kernel by adding more
 	  "explicit preemption points" to the kernel code. These new
@@ -35,6 +36,7 @@ config PREEMPT_VOLUNTARY
 
 config PREEMPT
 	bool "Preemptible Kernel (Low-Latency Desktop)"
+	depends on !ARM || EXPERIMENTAL
 	help
 	  This option reduces the latency of the kernel by making
 	  all kernel code (that is not executing in a critical section)
-- 
1.5.6.5

