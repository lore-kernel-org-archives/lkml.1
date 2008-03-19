Return-Path: <linux-kernel-owner+w=401wt.eu-S941742AbYCSW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941742AbYCSW4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765908AbYCSVYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:24:08 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33591 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209AbYCSVYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:24:06 -0400
Date: Wed, 19 Mar 2008 21:20:40 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals-document-cld_continued-notification-mechanics-more
Message-ID: <20080319182040.GA6387@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

comments update for signals-document-cld_continued-notification-mechanics.patch

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~DOC_1_NOTIFY	2008-03-18 17:25:19.000000000 +0300
+++ 25/kernel/signal.c	2008-03-19 20:53:45.000000000 +0300
@@ -1670,7 +1670,11 @@ relock:
 	try_to_freeze();
 
 	spin_lock_irq(&sighand->siglock);
-	/* see prepare_signal(SIGCONT) */
+	/*
+	 * Every stopped thread goes here after wakeup. Check to see if
+	 * we should notify the parent, prepare_signal(SIGCONT) encodes
+	 * the CLD_ si_code into SIGNAL_CLD_MASK bits.
+	 */
 	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
 		int why = (signal->flags & SIGNAL_STOP_CONTINUED)
 				? CLD_CONTINUED : CLD_STOPPED;

