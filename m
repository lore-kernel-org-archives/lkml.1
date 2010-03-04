Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0CDDLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:11:50 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:48063 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab0CDDLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:11:40 -0500
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] time: Cleanup direct xtime usage in xen
Date: Wed,  3 Mar 2010 19:11:19 -0800
Message-Id: <1267672280-21386-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1267672280-21386-1-git-send-email-johnstul@us.ibm.com>
References: <1267672280-21386-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not critical, 2.6.35 material.

Cleanup xen's direct use of internal timekeeping values.

Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/x86/xen/time.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0d3f07c..6365df9 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -475,6 +475,7 @@ void xen_timer_resume(void)
 __init void xen_time_init(void)
 {
 	int cpu = smp_processor_id();
+	struct timespec tp;
 
 	clocksource_register(&xen_clocksource);
 
@@ -486,9 +487,8 @@ __init void xen_time_init(void)
 	}
 
 	/* Set initial system time with full resolution */
-	xen_read_wallclock(&xtime);
-	set_normalized_timespec(&wall_to_monotonic,
-				-xtime.tv_sec, -xtime.tv_nsec);
+	xen_read_wallclock(&tp);
+	do_settimeofday(&tp);
 
 	setup_force_cpu_cap(X86_FEATURE_TSC);
 
-- 
1.6.0.4

