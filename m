Return-Path: <linux-kernel-owner+w=401wt.eu-S1946253AbXBPWba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946253AbXBPWba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946262AbXBPWba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:31:30 -0500
Received: from mail.screens.ru ([213.234.233.54]:39894 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946253AbXBPWba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:31:30 -0500
Date: Sat, 17 Feb 2007 01:31:29 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] freezer: task->exit_state should be treated as bolean
Message-ID: <20070216223129.GA192@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Except for BUG_ON() checks, we should not use EXIT_XXXX defines outside of
exit/wait paths.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/kernel/power/process.c~	2006-12-17 19:06:41.000000000 +0300
+++ 6.20-rc6-mm3/kernel/power/process.c	2007-02-17 01:27:54.000000000 +0300
@@ -25,10 +25,9 @@
 
 static inline int freezeable(struct task_struct * p)
 {
-	if ((p == current) || 
+	if ((p == current) ||
 	    (p->flags & PF_NOFREEZE) ||
-	    (p->exit_state == EXIT_ZOMBIE) ||
-	    (p->exit_state == EXIT_DEAD))
+	    (p->exit_state != 0))
 		return 0;
 	return 1;
 }

