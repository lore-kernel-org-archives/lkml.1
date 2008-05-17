Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbYEQPNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbYEQPNe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYEQPN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:13:26 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47492 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbYEQPN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:13:26 -0400
Date: Sat, 17 May 2008 19:14:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] signals: collect_signal: remove the unneeded sigismember() check
Message-ID: <20080517151424.GA9505@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

collect_signal() checks sigismember(&list->signal, sig), this is not needed.
This "sig" was just found by next_signal(), so it must be valid.

We have a (completely broken) call to ->notifier in between, but it must not
play with sigpending->signal bits or unlock ->siglock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~7_CS_NO_CHECK	2008-05-17 18:07:10.000000000 +0400
+++ 25/kernel/signal.c	2008-05-17 18:41:28.000000000 +0400
@@ -309,9 +309,6 @@ static int collect_signal(int sig, struc
 	struct sigqueue *q, *first = NULL;
 	int still_pending = 0;
 
-	if (unlikely(!sigismember(&list->signal, sig)))
-		return 0;
-
 	/*
 	 * Collect the siginfo appropriate to this signal.  Check if
 	 * there is another siginfo for the same signal.

