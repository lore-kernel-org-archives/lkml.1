Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbXHEO6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbXHEO6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 10:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbXHEO6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 10:58:30 -0400
Received: from mail.screens.ru ([213.234.233.54]:36655 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXHEO63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 10:58:29 -0400
Date: Sun, 5 Aug 2007 19:00:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wait_task_zombie: remove unneeded child->signal check
Message-ID: <20070805150041.GA2016@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A zombie must have a valid ->signal, we are going to release it and
__exit_signal() starts with BUG_ON(!sig).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/exit.c~1_SIGCK	2007-08-05 18:43:00.000000000 +0400
+++ t/kernel/exit.c	2007-08-05 18:46:00.000000000 +0400
@@ -1210,7 +1210,7 @@ static int wait_task_zombie(struct task_
 		return 0;
 	}
 
-	if (likely(p->real_parent == p->parent) && likely(p->signal)) {
+	if (likely(p->real_parent == p->parent)) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 

