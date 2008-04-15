Return-Path: <linux-kernel-owner+w=401wt.eu-S1764441AbYDODy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764441AbYDODy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762022AbYDODyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:54:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760713AbYDODyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:54:20 -0400
Subject: [PATCH] increment nr_tasks in io_context when CLONE_IO is set
From: Nikanth Karthikesan <knikanth@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 03:50:25 +0000
Message-Id: <1208231425.27984.9.camel@zero100.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increment the nr_tasks associated with the io_context when CLONE_IO flag
is set.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

--
diff --git a/kernel/fork.c b/kernel/fork.c
index dd249c3..01e843b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -812,6 +812,7 @@ static int copy_io(unsigned long clone_f
 		tsk->io_context = ioc_task_link(ioc);
 		if (unlikely(!tsk->io_context))
 			return -ENOMEM;
+		atomic_inc(&tsk->io_context->nr_tasks);
 	} else if (ioprio_valid(ioc->ioprio)) {
 		tsk->io_context = alloc_io_context(GFP_KERNEL, -1);
 		if (unlikely(!tsk->io_context))


