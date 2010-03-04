Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0CDD7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:59:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46701 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab0CDD5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:57:48 -0500
From: John Stultz <johnstul@us.ibm.com>
To: "	lkml" <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Paul Mundt <lethal@linux-sh.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/14] sh: Convert sh to use read/update_persistent_clock
Date: Wed,  3 Mar 2010 19:57:23 -0800
Message-Id: <1267675049-12337-9-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1267675049-12337-8-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-2-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-5-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-8-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the sh architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers would be appreciated.

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/sh/kernel/time.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/sh/kernel/time.c b/arch/sh/kernel/time.c
index 953fa16..8a0072d 100644
--- a/arch/sh/kernel/time.c
+++ b/arch/sh/kernel/time.c
@@ -39,12 +39,12 @@ static int null_rtc_set_time(const time_t secs)
 void (*rtc_sh_get_time)(struct timespec *) = null_rtc_get_time;
 int (*rtc_sh_set_time)(const time_t) = null_rtc_set_time;
 
-#ifdef CONFIG_GENERIC_CMOS_UPDATE
 void read_persistent_clock(struct timespec *ts)
 {
 	rtc_sh_get_time(ts);
 }
 
+#ifdef CONFIG_GENERIC_CMOS_UPDATE
 int update_persistent_clock(struct timespec now)
 {
 	return rtc_sh_set_time(now.tv_sec);
@@ -113,9 +113,5 @@ void __init time_init(void)
 	hwblk_init();
 	clk_init();
 
-	rtc_sh_get_time(&xtime);
-	set_normalized_timespec(&wall_to_monotonic,
-				-xtime.tv_sec, -xtime.tv_nsec);
-
 	late_time_init = sh_late_time_init;
 }
-- 
1.6.0.4

