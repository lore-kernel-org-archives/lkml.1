Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab0CJKKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:10:03 -0500
Received: from www.tglx.de ([62.245.132.106]:38371 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0CJKJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:09:59 -0500
Date: Wed, 10 Mar 2010 11:09:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 2.6.34
Message-ID: <alpine.LFD.2.00.1003101108450.22855@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
John Stultz (1):
      timekeeping: Prevent oops when GENERIC_TIME=n


 kernel/time/clocksource.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 1f663d2..1f5dde6 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -592,6 +592,10 @@ static inline void clocksource_select(void) { }
  */
 static int __init clocksource_done_booting(void)
 {
+	mutex_lock(&clocksource_mutex);
+	curr_clocksource = clocksource_default_clock();
+	mutex_unlock(&clocksource_mutex);
+
 	finished_booting = 1;
 
 	/*
