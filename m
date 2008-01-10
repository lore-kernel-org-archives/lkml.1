Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYAJDoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYAJDoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 22:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYAJDoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 22:44:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:26310 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbYAJDoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 22:44:07 -0500
Message-ID: <47859486.30609@ct.jp.nec.com>
Date: Wed, 09 Jan 2008 19:44:06 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, chrisw@sous-sol.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: move out tick_nohz_stop_sched_tick() call from the
 loop
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

tick_nohz_stop_sched_tick() and tick_nohz_restart_sched_tick()
pair in cpu_idle() is different from 32-bit version.

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] x86_64: move out tick_nohz_stop_sched_tick() call from the loop

Move out tick_nohz_stop_sched_tick() call from the loop in cpu_idle
same as 32-bit version.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/process_64.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 93ce4f3..6870208 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -170,14 +170,13 @@ void cpu_idle(void)
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
1.5.3.6


