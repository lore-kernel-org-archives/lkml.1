Return-Path: <linux-kernel-owner+w=401wt.eu-S965974AbXG3CQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965974AbXG3CQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765730AbXG3CQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:16:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936083AbXG3CQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:16:38 -0400
Date: Sun, 29 Jul 2007 22:16:35 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200707300216.l6U2GZWP024428@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] tiny sched_getaffinity cleanup
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unless I'm missing something quite tricky here's another tiny cleanup.  The
generated code is not affected (gcc is smart enough) but for people looking
over the code it is just irritating to have the extra conditional.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

--- kernel/sched.c	2007-07-26 14:54:53.000000000 -0700
+++ kernel/sched.c-new	2007-07-29 19:12:16.000000000 -0700
@@ -4464,10 +4464,8 @@ long sched_getaffinity(pid_t pid, cpumas
 out_unlock:
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&sched_hotcpu_mutex);
-	if (retval)
-		return retval;
 
-	return 0;
+	return retval;
 }
 
 /**
