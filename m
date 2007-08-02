Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbXHBWhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbXHBWhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXHBWhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:37:05 -0400
Received: from mail.screens.ru ([213.234.233.54]:55936 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830AbXHBWhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:37:03 -0400
Date: Fri, 3 Aug 2007 02:37:20 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] do_sigaction: remove now unneeded recalc_sigpending()
Message-ID: <20070802223720.GA623@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent changes, do_sigaction()->recalc_sigpending_and_wake() can
never clear TIF_SIGPENDING. Instead, it can set this flag and wake up the
thread without any reason. Harmless, but unneeded and wastes CPU.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/signal.c~	2007-08-03 02:26:30.000000000 +0400
+++ t/kernel/signal.c	2007-08-03 02:28:50.000000000 +0400
@@ -2342,7 +2342,6 @@ int do_sigaction(int sig, struct k_sigac
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
 			do {
 				rm_from_queue_full(&mask, &t->pending);
-				recalc_sigpending_and_wake(t);
 				t = next_thread(t);
 			} while (t != current);
 		}

