Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZGVPQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZGVPQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZGVPQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:16:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:41905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbZGVPQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:16:52 -0400
Date: Wed, 22 Jul 2009 15:15:35 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:timers/core] hrtimer: Remove cb_entry from struct hrtimer
Message-ID: <tip-fbd90375d7531927d312766b548376d909811b4d@git.kernel.org>
Git-Commit-ID: fbd90375d7531927d312766b548376d909811b4d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Jul 2009 15:15:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbd90375d7531927d312766b548376d909811b4d
Gitweb:     http://git.kernel.org/tip/fbd90375d7531927d312766b548376d909811b4d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 22 Jul 2009 13:40:14 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 22 Jul 2009 17:12:32 +0200

hrtimer: Remove cb_entry from struct hrtimer

It's unused, remove it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>


---
 include/linux/hrtimer.h |    2 --
 kernel/hrtimer.c        |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 54648e6..40e7d54 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -91,7 +91,6 @@ enum hrtimer_restart {
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
  * @state:	state information (See bit values above)
- * @cb_entry:	list head to enqueue an expired timer into the callback list
  * @start_site:	timer statistics field to store the site where the timer
  *		was started
  * @start_comm: timer statistics field to store the name of the process which
@@ -108,7 +107,6 @@ struct hrtimer {
 	enum hrtimer_restart		(*function)(struct hrtimer *);
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
-	struct list_head		cb_entry;
 #ifdef CONFIG_TIMER_STATS
 	int				start_pid;
 	void				*start_site;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 43d151f..052a0f5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1092,7 +1092,6 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 		clock_id = CLOCK_MONOTONIC;
 
 	timer->base = &cpu_base->clock_base[clock_id];
-	INIT_LIST_HEAD(&timer->cb_entry);
 	hrtimer_init_timer_hres(timer);
 
 #ifdef CONFIG_TIMER_STATS
