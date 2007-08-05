Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbXHEPdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbXHEPdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbXHEPdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:33:39 -0400
Received: from mail.screens.ru ([213.234.233.54]:40132 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbXHEPdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:33:38 -0400
Date: Sun, 5 Aug 2007 19:36:03 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] zap_other_threads: don't optimize thread_group_empty() case
Message-ID: <20070805153603.GA2782@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays thread_group_empty() and next_thread() are simple list operations,
this optimization doesn't make sense: we are doing exactly same check one
line below.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/signal.c~4_ZOT	2007-08-03 21:11:59.000000000 +0400
+++ t/kernel/signal.c	2007-08-05 19:28:13.000000000 +0400
@@ -987,9 +987,6 @@ void zap_other_threads(struct task_struc
 	p->signal->flags = SIGNAL_GROUP_EXIT;
 	p->signal->group_stop_count = 0;
 
-	if (thread_group_empty(p))
-		return;
-
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
 		/*
 		 * Don't bother with already dead threads

