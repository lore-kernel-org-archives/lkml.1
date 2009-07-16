Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZGPKS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZGPKS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZGPKS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:18:27 -0400
Received: from www.tglx.de ([62.245.132.106]:54097 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbZGPKS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:18:26 -0400
Date: Thu, 16 Jul 2009 12:18:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.00.0907151111130.2777@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0907161216540.2777@localhost.localdomain>
References: <alpine.LFD.2.00.0907141755210.2777@localhost.localdomain> <20090715082040.GA5038@osiris.boeblingen.de.ibm.com> <alpine.LFD.2.00.0907151111130.2777@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

The patch was in the last pull request already, but I did not push it
out :(

Thanks,

	tglx

------------------>
Heiko Carstens (1):
      timer stats: fix quick check optimization


 include/linux/hrtimer.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 54648e6..4759917 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -448,7 +448,7 @@ extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 
 static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
 {
-	if (likely(!timer->start_pid))
+	if (likely(!timer->start_site))
 		return;
 	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
 				 timer->function, timer->start_comm, 0);
