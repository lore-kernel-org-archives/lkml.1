Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbYEKWBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbYEKWBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 18:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbYEKWAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 18:00:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34457 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbYEKWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 18:00:40 -0400
References: <git-1210542959-a5b32acc9d50dd3c819c2dc5d43bd416f24aa8fd@dyn-67.arm.linux.org.uk>
Message-ID: <git-1210542959-a11b6c9b49632402270784b9d516213aad96da7e@dyn-67.arm.linux.org.uk>
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: LKML <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
       LAK <linux-arm-kernel@lists.arm.linux.org.uk>
Date: Sun, 11 May 2008 22:56:00 +0100
Content-type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Subject: Re: Remove last reminants of dyntick support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk@dyn-67.arm.linux.org.uk>

Neither S390 nor SH have the configuration option for NO_IDLE_HZ
in their Kconfig files, yet their defconfig files lists them.
Remove those references.

Finally, remove the last reminants of dyntick support from the
generic kernel.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/s390/defconfig               |    2 --
 arch/sh/configs/landisk_defconfig |    1 -
 arch/sh/configs/lboxre2_defconfig |    1 -
 arch/sh/configs/se7705_defconfig  |    1 -
 arch/sh/configs/se7712_defconfig  |    1 -
 arch/sh/configs/se7750_defconfig  |    1 -
 kernel/hrtimer.c                  |    2 +-
 kernel/sysctl.c                   |   12 ------------
 kernel/timer.c                    |   10 +---------
 9 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index a72f208..f72aada 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -205,8 +205,6 @@ CONFIG_HZ_100=y
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=100
 # CONFIG_SCHED_HRTICK is not set
-CONFIG_NO_IDLE_HZ=y
-CONFIG_NO_IDLE_HZ_INIT=y
 CONFIG_S390_HYPFS_FS=y
 CONFIG_KEXEC=y
 # CONFIG_ZFCPDUMP is not set
diff --git a/arch/sh/configs/landisk_defconfig b/arch/sh/configs/landisk_defconfig
index f52db12..38f934a 100644
--- a/arch/sh/configs/landisk_defconfig
+++ b/arch/sh/configs/landisk_defconfig
@@ -226,7 +226,6 @@ CONFIG_CPU_HAS_PTEA=y
 #
 CONFIG_SH_TMU=y
 CONFIG_SH_TIMER_IRQ=16
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_SH_PCLK_FREQ=33333333
 
 #
diff --git a/arch/sh/configs/lboxre2_defconfig b/arch/sh/configs/lboxre2_defconfig
index 9fa66d9..b68b6cd 100644
--- a/arch/sh/configs/lboxre2_defconfig
+++ b/arch/sh/configs/lboxre2_defconfig
@@ -231,7 +231,6 @@ CONFIG_CPU_HAS_PTEA=y
 #
 CONFIG_SH_TMU=y
 CONFIG_SH_TIMER_IRQ=16
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_SH_PCLK_FREQ=40000000
 
 #
diff --git a/arch/sh/configs/se7705_defconfig b/arch/sh/configs/se7705_defconfig
index 84717d8..490dcbc 100644
--- a/arch/sh/configs/se7705_defconfig
+++ b/arch/sh/configs/se7705_defconfig
@@ -239,7 +239,6 @@ CONFIG_CPU_HAS_SR_RB=y
 #
 CONFIG_SH_TMU=y
 CONFIG_SH_TIMER_IRQ=16
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_SH_PCLK_FREQ=33333333
 
 #
diff --git a/arch/sh/configs/se7712_defconfig b/arch/sh/configs/se7712_defconfig
index 240a1ce..2dd83af 100644
--- a/arch/sh/configs/se7712_defconfig
+++ b/arch/sh/configs/se7712_defconfig
@@ -236,7 +236,6 @@ CONFIG_CPU_HAS_SR_RB=y
 #
 CONFIG_SH_TMU=y
 CONFIG_SH_TIMER_IRQ=16
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_SH_PCLK_FREQ=66666666
 
 #
diff --git a/arch/sh/configs/se7750_defconfig b/arch/sh/configs/se7750_defconfig
index c60b6fd..167786f 100644
--- a/arch/sh/configs/se7750_defconfig
+++ b/arch/sh/configs/se7750_defconfig
@@ -235,7 +235,6 @@ CONFIG_CPU_HAS_PTEA=y
 #
 CONFIG_SH_TMU=y
 CONFIG_SH_TIMER_IRQ=16
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_SH_PCLK_FREQ=33333333
 
 #
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index dea4c91..dd0b7e4 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -971,7 +971,7 @@ ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_remaining);
 
-#if defined(CONFIG_NO_IDLE_HZ) || defined(CONFIG_NO_HZ)
+#ifdef CONFIG_NO_HZ
 /**
  * hrtimer_get_next_event - get the time until next expiry event
  *
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d7ffdc5..76426d9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -131,8 +131,6 @@ extern int sysctl_userprocess_debug;
 extern int spin_retry;
 #endif
 
-extern int sysctl_hz_timer;
-
 #ifdef CONFIG_BSD_PROCESS_ACCT
 extern int acct_parm[];
 #endif
@@ -562,16 +560,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_NO_IDLE_HZ
-	{
-		.ctl_name       = KERN_HZ_TIMER,
-		.procname       = "hz_timer",
-		.data           = &sysctl_hz_timer,
-		.maxlen         = sizeof(int),
-		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
-	},
-#endif
 	{
 		.ctl_name	= KERN_S390_USER_DEBUG_LOGGING,
 		.procname	= "userprocess_debug",
diff --git a/kernel/timer.c b/kernel/timer.c
index f3d35d4..e6a4f5e 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -678,7 +678,7 @@ static inline void __run_timers(struct tvec_base *base)
 	spin_unlock_irq(&base->lock);
 }
 
-#if defined(CONFIG_NO_IDLE_HZ) || defined(CONFIG_NO_HZ)
+#ifdef CONFIG_NO_HZ
 /*
  * Find out when the next timer event is due to happen. This
  * is used on S/390 to stop all activity when a cpus is idle.
@@ -813,14 +813,6 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 
 	return cmp_next_hrtimer_event(now, expires);
 }
-
-#ifdef CONFIG_NO_IDLE_HZ
-unsigned long next_timer_interrupt(void)
-{
-	return get_next_timer_interrupt(jiffies);
-}
-#endif
-
 #endif
 
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
