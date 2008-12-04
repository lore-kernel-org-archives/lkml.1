Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYLDF2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYLDF2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYLDF1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:27:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63792 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYLDF1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:27:37 -0500
Message-Id: <20081204052734.913191217@goodmis.org>
References: <20081204052638.425740534@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 04 Dec 2008 00:26:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] fix the do_each_pid_task macro
Content-Disposition: inline; filename=0001-fix-the-do_each_pid_task-macro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix

This patch adds parenthesis around 'pid' in the do_each_pid_task
macro to allow callers to pass in more complex parameters.

e.g.  do_each_pid_task(*pid, type, task)

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/pid.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index d7e98ff..bb206c5 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -147,9 +147,9 @@ pid_t pid_vnr(struct pid *pid);
 #define do_each_pid_task(pid, type, task)				\
 	do {								\
 		struct hlist_node *pos___;				\
-		if (pid != NULL)					\
+		if ((pid) != NULL)					\
 			hlist_for_each_entry_rcu((task), pos___,	\
-				&pid->tasks[type], pids[type].node) {
+				&(pid)->tasks[type], pids[type].node) {
 
 			/*
 			 * Both old and new leaders may be attached to
-- 
1.5.6.5

-- 
