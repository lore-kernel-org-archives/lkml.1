Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbYCCES1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbYCCES1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYCCESS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:18:18 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:58834 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYCCESS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:18:18 -0500
Date: Mon, 3 Mar 2008 07:17:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] reparent_thread: use same_thread_group()
Message-ID: <20080303041753.GA18917@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial, use same_thread_group() in reparent_thread().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/exit.c~6_EN_SG	2008-03-03 06:24:56.000000000 +0300
+++ 25/kernel/exit.c	2008-03-03 06:46:00.000000000 +0300
@@ -653,7 +653,7 @@ reparent_thread(struct task_struct *p, s
 	/* If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
 	 */
-	if (p->real_parent->group_leader == father->group_leader)
+	if (same_thread_group(p->real_parent, father))
 		return;
 
 	/* We don't want people slaying init.  */

