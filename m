Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbXJLQpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbXJLQpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762328AbXJLQoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:44:38 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:60879 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760352AbXJLQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:44:37 -0400
Date: Fri, 12 Oct 2007 12:44:24 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix wait_for_completion_interruptible declaration mismatch
Message-ID: <20071012164424.GA7709@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Without the fastcall, I get a declaration mismatch between the
definition here and the declaration in completion.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/kernel/sched.c
===================================================================
--- linux-2.6.22.orig/kernel/sched.c	2007-10-12 12:23:57.000000000 -0400
+++ linux-2.6.22/kernel/sched.c	2007-10-12 12:36:39.000000000 -0400
@@ -3789,7 +3789,7 @@ wait_for_completion_timeout(struct compl
 }
 EXPORT_SYMBOL(wait_for_completion_timeout);
 
-int __sched wait_for_completion_interruptible(struct completion *x)
+int fastcall __sched wait_for_completion_interruptible(struct completion *x)
 {
 	return wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
 }
