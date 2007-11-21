Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbXKUBQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbXKUBQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763607AbXKUBNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:13:54 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:59844 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760426AbXKUBNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:13:48 -0500
Message-Id: <20071121011252.076859770@goodmis.org>
References: <20071121010054.663842380@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 20:01:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v4 20/20] balance RT tasks no new wake up
Content-Disposition: inline; filename=rt-balance-on-new-task.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Run the RT balancing code on wake up to an RT task.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2007-11-20 19:53:10.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-20 19:53:18.000000000 -0500
@@ -1650,6 +1650,7 @@ void fastcall wake_up_new_task(struct ta
 		inc_nr_running(p, rq);
 	}
 	check_preempt_curr(rq, p);
+	wakeup_balance_rt(rq, p);
 	task_rq_unlock(rq, &flags);
 }
 

-- 
