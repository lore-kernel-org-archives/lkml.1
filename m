Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYI3So7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYI3So7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYI3Soi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:44:38 -0400
Received: from www.tglx.de ([62.245.132.106]:48983 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbYI3Sog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:44:36 -0400
Message-Id: <20080930121338.108907656@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 30 Sep 2008 18:44:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>
Subject: [patch 3/3] timer_list: add base address to clock base
References: <20080930121310.879471299@linutronix.de>
Content-Disposition: inline;
	filename=timerlist-add-base-address-to-clock-base.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The base address of a (per cpu) clock base is a useful debug info.
Add it and bump the version number of timer_lists.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timer_list.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/kernel/time/timer_list.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timer_list.c
+++ linux-2.6-tip/kernel/time/timer_list.c
@@ -110,6 +110,7 @@ next_one:
 static void
 print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
 {
+	SEQ_printf(m, "  .base:       %p\n", base);
 	SEQ_printf(m, "  .index:      %d\n",
 			base->index);
 	SEQ_printf(m, "  .resolution: %Lu nsecs\n",
@@ -249,7 +250,7 @@ static int timer_list_show(struct seq_fi
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.3\n");
+	SEQ_printf(m, "Timer List Version: v0.4\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 


