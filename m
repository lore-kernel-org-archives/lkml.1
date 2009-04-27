Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbZD0TxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbZD0TxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZD0TxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:53:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58310 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbZD0TxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:53:07 -0400
Date: Mon, 27 Apr 2009 21:48:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] copy_process: remove the unneeded
	clear_tsk_thread_flag(TIF_SIGPENDING)
Message-ID: <20090427194845.GA6245@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The forked child can have TIF_SIGPENDING if it was copied from parent's
ti->flags. But this is harmless and actually almost never happens, because
copy_process() can't succeed if signal_pending() == T.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/fork.c~FORK_SIGPENDING	2009-04-13 17:05:52.000000000 +0200
+++ PTRACE/kernel/fork.c	2009-04-27 21:38:57.000000000 +0200
@@ -1027,7 +1027,6 @@ static struct task_struct *copy_process(
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
-	clear_tsk_thread_flag(p, TIF_SIGPENDING);
 	init_sigpending(&p->pending);
 
 	p->utime = cputime_zero;

