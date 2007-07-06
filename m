Return-Path: <linux-kernel-owner+w=401wt.eu-S1763922AbXGFIRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763922AbXGFIRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 04:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763262AbXGFIRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 04:17:34 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:48107 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763170AbXGFIRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 04:17:33 -0400
Message-ID: <468DFA5D.2060809@openvz.org>
Date: Fri, 06 Jul 2007 12:16:29 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Sukadev Bhattiprolu <sukadev@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH 16/16] Remove already unneeded memners from struct pid
References: <468DF6F7.1010906@openvz.org>
In-Reply-To: <468DF6F7.1010906@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since we've switched from using these we may just remove them.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

 init_task.h |    3 ---
 pid.h       |    3 ---
 2 files changed, 6 deletions(-)

diff -upr linux-2.6.22-rc4-mm2.orig/include/linux/pid.h linux-2.6.22-rc4-mm2-2/include/linux/pid.h
--- linux-2.6.22-rc4-mm2.orig/include/linux/pid.h	2007-06-14 12:14:29.000000000 +0400
+++ linux-2.6.22-rc4-mm2-2/include/linux/pid.h	2007-07-04 19:00:38.000000000 +0400
@@ -40,9 +40,6 @@ enum pid_type
 struct pid
 {
 	atomic_t count;
-	/* Try to keep pid_chain in the same cacheline as nr for find_pid */
-	int nr;
-	struct hlist_node pid_chain;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
diff -upr linux-2.6.22-rc4-mm2.orig/include/linux/init_task.h linux-2.6.22-rc4-mm2-2/include/linux/init_task.h
--- linux-2.6.22-rc4-mm2.orig/include/linux/init_task.h	2007-06-14 12:14:29.000000000 +0400
+++ linux-2.6.22-rc4-mm2-2/include/linux/init_task.h	2007-07-04 19:00:38.000000000 +0400
@@ -91,9 +91,6 @@ extern struct group_info init_groups;
 
 #define INIT_STRUCT_PID {						\
 	.count 		= ATOMIC_INIT(1),				\
-	.nr		= 0, 						\
-	/* Don't put this struct pid in pid_hash */			\
-	.pid_chain	= { .next = NULL, .pprev = NULL },		\
 	.tasks		= {						\
 		{ .first = &init_task.pids[PIDTYPE_PID].node },		\
 		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\

