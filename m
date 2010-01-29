Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694Ab0A2EYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0A2EYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 23:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934Ab0A2EYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 23:24:45 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:34923 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab0A2EYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 23:24:44 -0500
From: John Stultz <johnstul@us.ibm.com>
To: Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>
Subject: [PATCH] time: Cleanup direct xtime usage in xen
Date: Thu, 28 Jan 2010 20:24:41 -0800
Message-Id: <1264739081-22030-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup xen's direct use of internal timekeeping values.

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

