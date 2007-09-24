Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbXIXUWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbXIXUWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbXIXUWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:22:39 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:32786 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbXIXUWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:22:39 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Sep 2007 13:22:37 -0700
Subject: [patch 1/4] new timerfd API v2 - introduce a new hrtimer_forward_now() function
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.3854.1190665357.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think that advancing the timer against the timer's current "now" can
be a pretty common usage, so, w/out exposing hrtimer's internals, we add
a new hrtimer_forward_now() function.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 include/linux/hrtimer.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.mod/include/linux/hrtimer.h
===================================================================
--- linux-2.6.mod.orig/include/linux/hrtimer.h	2007-09-24 12:27:20.000000000 -0700
+++ linux-2.6.mod/include/linux/hrtimer.h	2007-09-24 12:29:39.000000000 -0700
@@ -298,6 +298,13 @@
 extern unsigned long
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
 
+/* Forward a hrtimer so it expires after the hrtimer's current now */
+static inline unsigned long hrtimer_forward_now(struct hrtimer *timer,
+						ktime_t interval)
+{
+	return hrtimer_forward(timer, timer->base->get_time(), interval);
+}
+
 /* Precise sleep: */
 extern long hrtimer_nanosleep(struct timespec *rqtp,
 			      struct timespec __user *rmtp,

