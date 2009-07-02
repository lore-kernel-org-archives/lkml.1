Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbZGBSbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbZGBSbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZGBSbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:31:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49523 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZGBSbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:31:24 -0400
Date: Thu, 2 Jul 2009 20:28:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] wait_consider_task: kill "parent" argument
Message-ID: <20090702182841.GA30981@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill the unused "parent" argument in wait_consider_task(), it was never
used.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- WAIT/kernel/exit.c~5_WCT_KILL_PARENT	2009-07-02 19:56:33.000000000 +0200
+++ WAIT/kernel/exit.c	2009-07-02 20:19:55.000000000 +0200
@@ -1471,8 +1471,8 @@ static int wait_task_continued(struct wa
  * then ->notask_error is 0 if @p is an eligible child,
  * or another error from security_task_wait(), or still -ECHILD.
  */
-static int wait_consider_task(struct wait_opts *wo, struct task_struct *parent,
-				int ptrace, struct task_struct *p)
+static int wait_consider_task(struct wait_opts *wo, int ptrace,
+				struct task_struct *p)
 {
 	int ret = eligible_child(wo, p);
 	if (!ret)
@@ -1536,7 +1536,7 @@ static int do_wait_thread(struct wait_op
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->children, sibling) {
-		int ret = wait_consider_task(wo, tsk, 0, p);
+		int ret = wait_consider_task(wo, 0, p);
 		if (ret)
 			return ret;
 	}
@@ -1549,7 +1549,7 @@ static int ptrace_do_wait(struct wait_op
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
-		int ret = wait_consider_task(wo, tsk, 1, p);
+		int ret = wait_consider_task(wo, 1, p);
 		if (ret)
 			return ret;
 	}

