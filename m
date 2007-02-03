Return-Path: <linux-kernel-owner+w=401wt.eu-S1946221AbXBCCfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946221AbXBCCfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946232AbXBCCfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:35:13 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52560 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946221AbXBCCfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:35:11 -0500
Message-Id: <20070203023944.955656000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:18 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nathan Lynch <ntl@pobox.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: [patch 14/59] sched: tasks cannot run on cpus onlined after boot
Content-Disposition: inline; filename=sched-tasks-cannot-run-on-cpus-onlined-after-boot.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Nathan Lynch <ntl@pobox.com>

Commit 5c1e176781f43bc902a51e5832f789756bff911b ("sched: force /sbin/init
off isolated cpus") sets init's cpus_allowed to a subset of cpu_online_map
at boot time, which means that tasks won't be scheduled on cpus that are
added to the system later.

Make init's cpus_allowed a subset of cpu_possible_map instead.  This should
still preserve the behavior that Nick's change intended.

Thanks to Giuliano Pochini for reporting this and testing the fix:

http://ozlabs.org/pipermail/linuxppc-dev/2006-December/029397.html

Signed-off-by: Nathan Lynch <ntl@pobox.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19.2.orig/kernel/sched.c
+++ linux-2.6.19.2/kernel/sched.c
@@ -6765,7 +6765,7 @@ void __init sched_init_smp(void)
 
 	lock_cpu_hotplug();
 	arch_init_sched_domains(&cpu_online_map);
-	cpus_andnot(non_isolated_cpus, cpu_online_map, cpu_isolated_map);
+	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
 	unlock_cpu_hotplug();

--
