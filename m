Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbZKRUZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbZKRUZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932273AbZKRUZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:25:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:41275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278AbZKRUZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:25:11 -0500
Date: Wed, 18 Nov 2009 20:24:46 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer: Fix /proc/timer_list regression
Message-ID: <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org>
Git-Commit-ID: 887a29f59b93cf54e21814869a4ab6e80b6fa623
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  887a29f59b93cf54e21814869a4ab6e80b6fa623
Gitweb:     http://git.kernel.org/tip/887a29f59b93cf54e21814869a4ab6e80b6fa623
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Thu, 3 Sep 2009 16:32:53 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 18 Nov 2009 21:20:37 +0100

hrtimer: Fix /proc/timer_list regression

commit 507e1231 (timer stats: Optimize by adding quick check to avoid
function calls) introduced a regression in /proc/timer_list.

/proc/timer_list shows now
 #0: <c27d46b0>, tick_sched_timer, S:01, <(null)>, /-1
instead of
 #0: <c27d46b0>, tick_sched_timer, S:01, hrtimer_start, swapper/0

Revert the hrtimer quick check for now. The optimization needs more
thought, but this is neither 2.6.32-rc7 nor stable material.

[ tglx: Removed unrelated changes from the original patch and massaged
  	the changelog ]

Signed-off-by: Feng Tang <feng.tang@intel.com>
LKML-Reference: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: stable@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index ff037f0..0a656d6 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -457,8 +457,6 @@ extern void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer,
 
 static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
-	if (likely(!timer_stats_active))
-		return;
 	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
 }
 
