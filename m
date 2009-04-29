Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbZD2XOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbZD2XOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 19:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZD2XOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 19:14:38 -0400
Received: from exprod6ob114.obsmtp.com ([64.18.1.32]:59552 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752280AbZD2XOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 19:14:37 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] kernel/posix-cpu-timers.c: fix sparse warning
Date: Wed, 29 Apr 2009 19:14:32 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909016C1AFE@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] kernel/posix-cpu-timers.c: fix sparse warning
Thread-Index: AcnJIEEF1lJM76quRMuvJXKvitggmA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <subrata@linux.vnet.ibm.com>
X-OriginalArrivalTime: 29 Apr 2009 23:14:33.0220 (UTC) FILETIME=[4185E440:01C9C920]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse reports the following in kernel/posix-cpu-timers.c:

  warning: symbol 'firing' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>

---

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c9dcf98..88f24ab 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1420,17 +1420,17 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	 * timer call will interfere.
 	 */
 	list_for_each_entry_safe(timer, next, &firing, it.cpu.entry) {
-		int firing;
+		int cpu_firing;
 		spin_lock(&timer->it_lock);
 		list_del_init(&timer->it.cpu.entry);
-		firing = timer->it.cpu.firing;
+		cpu_firing = timer->it.cpu.firing;
 		timer->it.cpu.firing = 0;
 		/*
 		 * The firing flag is -1 if we collided with a reset
 		 * of the timer, which already reported this
 		 * almost-firing as an overrun.  So don't generate an event.
 		 */
-		if (likely(firing >= 0)) {
+		if (likely(cpu_firing >= 0)) {
 			cpu_timer_fire(timer);
 		}
 		spin_unlock(&timer->it_lock); 
