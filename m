Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZD3GZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZD3GZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbZD3GZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:25:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:54251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZD3GZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:25:29 -0400
Date: Thu, 30 Apr 2009 06:24:44 GMT
From: tip-bot for H Hartley Sweeten <hartleys@visionengravers.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       hartleys@visionengravers.com, tglx@linutronix.de,
       subrata@linux.vnet.ibm.com, hsweeten@visionengravers.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hartleys@visionengravers.com,
       hsweeten@visionengravers.com, subrata@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909016C1AFE@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE1909016C1AFE@mi8nycmail19.Mi8.com>
Subject: [tip:core/urgent] kernel/posix-cpu-timers.c: fix sparse warning
Message-ID: <tip-6e85c5ba73c07b990798087e9b858c065db2b234@git.kernel.org>
Git-Commit-ID: 6e85c5ba73c07b990798087e9b858c065db2b234
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 06:24:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e85c5ba73c07b990798087e9b858c065db2b234
Gitweb:     http://git.kernel.org/tip/6e85c5ba73c07b990798087e9b858c065db2b234
Author:     H Hartley Sweeten <hartleys@visionengravers.com>
AuthorDate: Wed, 29 Apr 2009 19:14:32 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Apr 2009 08:08:31 +0200

kernel/posix-cpu-timers.c: fix sparse warning

Sparse reports the following in kernel/posix-cpu-timers.c:

  warning: symbol 'firing' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>
LKML-Reference: <BD79186B4FD85F4B8E60E381CAEE1909016C1AFE@mi8nycmail19.Mi8.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/posix-cpu-timers.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c9dcf98..bece7c0 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1420,19 +1420,19 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	 * timer call will interfere.
 	 */
 	list_for_each_entry_safe(timer, next, &firing, it.cpu.entry) {
-		int firing;
+		int cpu_firing;
+
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
+		if (likely(cpu_firing >= 0))
 			cpu_timer_fire(timer);
-		}
 		spin_unlock(&timer->it_lock);
 	}
 }
