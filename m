Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYFDRIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYFDRIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYFDRIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:08:02 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47542 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbYFDRIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:08:00 -0400
Date: Wed, 4 Jun 2008 21:09:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] __down_common: use signal_pending_state()
Message-ID: <20080604170906.GA10276@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. __down_common() can use the new signal_pending_state() helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/semaphore.c~2_SEM_USE_HELPER	2008-05-18 15:44:19.000000000 +0400
+++ 26-rc2/kernel/semaphore.c	2008-06-04 20:45:21.000000000 +0400
@@ -211,9 +211,7 @@ static inline int __sched __down_common(
 	waiter.up = 0;
 
 	for (;;) {
-		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
-			goto interrupted;
-		if (state == TASK_KILLABLE && fatal_signal_pending(task))
+		if (signal_pending_state(state, task))
 			goto interrupted;
 		if (timeout <= 0)
 			goto timed_out;

