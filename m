Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935650Ab0CMBSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:18:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:46237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934987Ab0CMAUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:43 -0500
Date: Sat, 13 Mar 2010 00:20:03 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, johnstul@us.ibm.com, tglx@linutronix.de,
       ysato@users.sourceforge.jp
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       ysato@users.sourceforge.jp
In-Reply-To: <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] h8300: Convert h8300 to use read/update_persistent_clock
Message-ID: <tip-12833c1e373ad2b12667ca159d335fae29968473@git.kernel.org>
Git-Commit-ID: 12833c1e373ad2b12667ca159d335fae29968473
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 00:20:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12833c1e373ad2b12667ca159d335fae29968473
Gitweb:     http://git.kernel.org/tip/12833c1e373ad2b12667ca159d335fae29968473
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Wed, 3 Mar 2010 19:57:20 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 13 Mar 2010 01:14:10 +0100

h8300: Convert h8300 to use read/update_persistent_clock

This patch converts the h8300 architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/h8300/kernel/time.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 7f2d6cf..165005a 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -41,7 +41,7 @@ void h8300_timer_tick(void)
 	update_process_times(user_mode(get_irq_regs()));
 }
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned int year, mon, day, hour, min, sec;
 
@@ -56,8 +56,12 @@ void __init time_init(void)
 #endif
 	if ((year += 1900) < 1970)
 		year += 100;
-	xtime.tv_sec = mktime(year, mon, day, hour, min, sec);
-	xtime.tv_nsec = 0;
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_nsec = 0;
+}
+
+void __init time_init(void)
+{
 
 	h8300_timer_setup();
 }
