Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbXKTPhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbXKTPhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbXKTPhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:37:09 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:53210 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055AbXKTPhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:37:08 -0500
Date: Tue, 20 Nov 2007 18:37:20 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm] do_wait: remove one "else if" branch
Message-ID: <20071120153720.GA5319@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Minor cleanup. We can remove one "else if" branch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~3_EXIT_DEAD	2007-11-20 17:54:07.000000000 +0300
+++ PT/kernel/exit.c	2007-11-20 18:23:16.000000000 +0300
@@ -1561,8 +1561,6 @@ repeat:
 					goto repeat;
 				if (retval != 0) /* He released the lock.  */
 					goto end;
-			} else if (p->exit_state == EXIT_DEAD) {
-				continue;
 			} else if (p->exit_state == EXIT_ZOMBIE) {
 				/*
 				 * Eligible but we cannot release it yet:
@@ -1577,7 +1575,7 @@ repeat:
 				/* He released the lock.  */
 				if (retval != 0)
 					goto end;
-			} else {
+			} else if (p->exit_state != EXIT_DEAD) {
 check_continued:
 				/*
 				 * It's running now, so it might later

