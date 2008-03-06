Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbYCFAFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbYCFAFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYCFAFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:05:21 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42932 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758793AbYCFAFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:05:19 -0500
Date: Thu, 6 Mar 2008 03:04:49 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] send_group_sigqueue: don't take tasklist_lock
Message-ID: <20080306000449.GA6959@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(depends on signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch)

handle_stop_signal() was changed, now send_group_sigqueue() doesn't need
tasklist_lock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~5_SGS_NO_TASKLIST	2008-03-06 01:34:57.000000000 +0300
+++ 25/kernel/signal.c	2008-03-06 02:54:27.000000000 +0300
@@ -1336,7 +1336,6 @@ send_group_sigqueue(int sig, struct sigq
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
-	read_lock(&tasklist_lock);
 	/* Since it_lock is held, p->sighand cannot be NULL. */
 	spin_lock_irqsave(&p->sighand->siglock, flags);
 
@@ -1345,7 +1344,7 @@ send_group_sigqueue(int sig, struct sigq
 	__group_complete_signal(sig, p);
 
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	read_unlock(&tasklist_lock);
+
 	return ret;
 }
 

