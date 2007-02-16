Return-Path: <linux-kernel-owner+w=401wt.eu-S1946280AbXBPWjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946280AbXBPWjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946283AbXBPWjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:39:00 -0500
Received: from mail.screens.ru ([213.234.233.54]:35142 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946280AbXBPWi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:38:59 -0500
Date: Sat, 17 Feb 2007 01:38:54 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] softlockup: trivial, s/99/MAX_RT_PRIO/
Message-ID: <20070216223854.GA219@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use hardcoded 99 value, use MAX_RT_PRIO.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/kernel/softlockup.c~	2006-10-22 18:24:03.000000000 +0400
+++ 6.20-rc6-mm3/kernel/softlockup.c	2007-02-17 01:35:57.000000000 +0300
@@ -82,7 +82,7 @@ void softlockup_tick(void)
  */
 static int watchdog(void * __bind_cpu)
 {
-	struct sched_param param = { .sched_priority = 99 };
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->flags |= PF_NOFREEZE;

