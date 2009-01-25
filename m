Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbZAYNOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbZAYNOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 08:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbZAYNNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 08:13:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35937 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbZAYNNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 08:13:49 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] Use kernel/Kconfig.preempt for ARM
Date: Sun, 25 Jan 2009 14:13:47 +0100
Message-Id: <1232889227-20887-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232889227-20887-3-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090125123023.GA12248@pengutronix.de>
 <1232889227-20887-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1232889227-20887-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1232889227-20887-3-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
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
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/Kconfig       |   13 +------------
 kernel/Kconfig.preempt |    2 ++
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9722f8b..85722ba 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -789,18 +789,7 @@ config LOCAL_TIMERS
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
index 3953130..22b1b18 100644
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
 
 config PREEMPT_DESKTOP
 	bool "Preemptible Kernel (Low-Latency Desktop)"
+	depends on !ARM || EXPERIMENTAL
 	help
 	  This option reduces the latency of the kernel by making
 	  all kernel code (that is not executing in a critical section)
-- 
1.5.6.5

