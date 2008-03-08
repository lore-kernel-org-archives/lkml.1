Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYCHTmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYCHTmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 14:42:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbYCHTl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 14:41:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbYCHTl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 14:41:57 -0500
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] waitid si_code regression
X-Fcc: ~/Mail/linus
X-Zippy-Says: I decided to be JOHN TRAVOLTA instead!!
Message-Id: <20080308194122.4EEB226F991@magilla.localdomain>
Date: Sat,  8 Mar 2008 11:41:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In commit ee7c82da830ea860b1f9274f1f0cdf99f206e7c2, the magic (short)
cast when storing si_code was lost in wait_task_stopped.  This leaks
the in-kernel CLD_* values that do not match what userland expects.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---
 kernel/exit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index cd20bf0..53872bf 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1378,7 +1378,7 @@ unlock_sig:
 	if (!retval && infop)
 		retval = put_user(0, &infop->si_errno);
 	if (!retval && infop)
-		retval = put_user(why, &infop->si_code);
+		retval = put_user((short)why, &infop->si_code);
 	if (!retval && infop)
 		retval = put_user(exit_code, &infop->si_status);
 	if (!retval && infop)
