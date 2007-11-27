Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbXK0Mng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbXK0Mng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 07:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXK0Mn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 07:43:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55483 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbXK0Mn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 07:43:28 -0500
Date: Tue, 27 Nov 2007 13:44:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
Subject: [patch] timer_list should use signed numbers for relative times
Message-ID: <20071127124405.GA3943@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Relative times are signed by nature, and timers can (briefly) have
expires in past. Print them as negative numbers.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 12c5f4c..7f6eaa9 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -65,7 +65,7 @@ #ifdef CONFIG_TIMER_STATS
 	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
 #endif
 	SEQ_printf(m, "\n");
-	SEQ_printf(m, " # expires at %Lu nsecs [in %Lu nsecs]\n",
+	SEQ_printf(m, " # expires at %Lu nsecs [in %Ld nsecs]\n",
 		(unsigned long long)ktime_to_ns(timer->expires),
 		(unsigned long long)(ktime_to_ns(timer->expires) - now));
 }

 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
