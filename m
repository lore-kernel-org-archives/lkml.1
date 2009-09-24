Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbZIXOfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbZIXOfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZIXOfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:35:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZIXOfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:35:33 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] posix-cpu-timers: initialize new_itimer->it.cpu.firing
Date: Thu, 24 Sep 2009 16:35:03 +0200
Message-Id: <1253802903-979-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1253802903-979-1-git-send-email-sgruszka@redhat.com>
References: <1253802903-979-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case when posix_cpu_timer_create() is called from sys_timer_create()
it.cpu.firing field of struct k_itimer is uninitialized.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 5c9dc22..e73a386 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -398,6 +398,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
 	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
 	new_timer->it.cpu.incr.sched = 0;
 	new_timer->it.cpu.expires.sched = 0;
+	new_timer->it.cpu.firing = 0;
 
 	read_lock(&tasklist_lock);
 	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
-- 
1.6.2.5

