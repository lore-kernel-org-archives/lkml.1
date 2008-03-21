Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbYCUXLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbYCUXLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932168AbYCUWw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:52:26 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41326 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbYCUWwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:24 -0400
Message-Id: <20080321224425.641454874@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ed Tomlinson <edt@aei.ca>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 49/76] x86: move out tick_nohz_stop_sched_tick() call from the loop
Content-Disposition: inline; filename=x86-move-out-tick_nohz_stop_sched_tick-call-from-the-loop.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

[upstream commit: 3d97775a]

Move out tick_nohz_stop_sched_tick() call from the loop in cpu_idle
same as 32-bit version.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ed Tomlinson <edt@aei.ca>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/process_64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -212,14 +212,13 @@ void cpu_idle (void)
 	current_thread_info()->status |= TS_POLLING;
 	/* endless idle loop with no priority at all */
 	while (1) {
+		tick_nohz_stop_sched_tick();
 		while (!need_resched()) {
 			void (*idle)(void);
 
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
-			tick_nohz_stop_sched_tick();
-
 			rmb();
 			idle = pm_idle;
 			if (!idle)

-- 
