Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbYE0Q5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbYE0Q5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbYE0Q52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:57:28 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37100 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642AbYE0Q51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:57:27 -0400
Date: Tue, 27 May 2008 20:58:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] signals: change collect_signal() to return void
Message-ID: <20080527165857.GA1410@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent changes collect_signal() always returns true. Change it to
return void and update the single caller.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/signal.c~4_CS_VOID	2008-05-27 19:06:55.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-05-27 20:54:49.000000000 +0400
@@ -338,7 +338,7 @@ unblock_all_signals(void)
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
-static int collect_signal(int sig, struct sigpending *list, siginfo_t *info)
+static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
 	struct sigqueue *q, *first = NULL;
 
@@ -372,7 +372,6 @@ still_pending:
 		info->si_pid = 0;
 		info->si_uid = 0;
 	}
-	return 1;
 }
 
 static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
@@ -390,8 +389,7 @@ static int __dequeue_signal(struct sigpe
 			}
 		}
 
-		if (!collect_signal(sig, pending, info))
-			sig = 0;
+		collect_signal(sig, pending, info);
 	}
 
 	return sig;

