Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbYCIVyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbYCIVyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYCIVyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:54:05 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34928 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYCIVyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:54:03 -0400
Date: Mon, 10 Mar 2008 00:53:38 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: document CLD_CONTINUED notification mechanics
Message-ID: <20080309215338.GA2296@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of small comments about how CLD_CONTINUED notification works.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~DOC_NOTIFY	2008-03-10 00:11:50.000000000 +0300
+++ 25/kernel/signal.c	2008-03-10 00:47:21.000000000 +0300
@@ -632,6 +632,10 @@ static int prepare_signal(int sig, struc
 			why |= SIGNAL_CLD_STOPPED;
 
 		if (why) {
+			/* The first thread which returns from finish_stop()
+			 * will take ->siglock and notice SIGNAL_CLD_MASK,
+			 * see get_signal_to_deliver().
+			 */
 			signal->flags = why | SIGNAL_STOP_CONTINUED;
 			signal->group_stop_count = 0;
 			signal->group_exit_code = 0;
@@ -1641,7 +1645,7 @@ int get_signal_to_deliver(siginfo_t *inf
 
 relock:
 	spin_lock_irq(&sighand->siglock);
-
+	/* see prepare_signal(SIGCONT) */
 	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
 		int why = (signal->flags & SIGNAL_STOP_CONTINUED)
 				? CLD_CONTINUED : CLD_STOPPED;

