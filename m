Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYGXQcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYGXQcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYGXQbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:31:43 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34767 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYGXQbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:31:42 -0400
Date: Thu, 24 Jul 2008 20:34:59 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] do_wait_for_common: use signal_pending_state()
Message-ID: <20080724163459.GA3151@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change do_wait_for_common() to use signal_pending_state() instead of
open coding.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/sched.c~1_SPS_WAIT_FOR	2008-07-22 18:36:58.000000000 +0400
+++ 26-rc2/kernel/sched.c	2008-07-24 19:54:12.000000000 +0400
@@ -4735,10 +4735,7 @@ do_wait_for_common(struct completion *x,
 		wait.flags |= WQ_FLAG_EXCLUSIVE;
 		__add_wait_queue_tail(&x->wait, &wait);
 		do {
-			if ((state == TASK_INTERRUPTIBLE &&
-			     signal_pending(current)) ||
-			    (state == TASK_KILLABLE &&
-			     fatal_signal_pending(current))) {
+			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
 				break;
 			}

