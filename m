Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbZFNRGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbZFNRGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 13:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZFNRFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 13:05:48 -0400
Received: from vm1.die-welt.net ([84.246.122.34]:51225 "EHLO chi.die-welt.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752454AbZFNRFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 13:05:47 -0400
From: Evgeni Golov <sargentd@die-welt.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeni Golov <sargentd@die-welt.net>
Subject: [PATCH 2/2] use the TASK_COMM_LEN macro instead of sizeof(tsk->comm)
Date: Sun, 14 Jun 2009 18:57:48 +0200
Message-Id: <1244998668-27078-2-git-send-email-sargentd@die-welt.net>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244998668-27078-1-git-send-email-sargentd@die-welt.net>
References: <1244998668-27078-1-git-send-email-sargentd@die-welt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(tsk->comm) == TASK_COMM_LEN, always, so why not use it?

Signed-off-by: Evgeni Golov <sargentd@die-welt.net>
---
 fs/exec.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6f1eeb8..14fd909 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -911,9 +911,9 @@ static void flush_old_files(struct files_struct * files)
 
 char *get_task_comm(char *buf, struct task_struct *tsk)
 {
-	/* buf must be at least sizeof(tsk->comm) in size */
+	/* buf must be at least sizeof(tsk->comm) (=TASK_COMM_LEN) in size */
 	task_lock(tsk);
-	strlcpy(buf, tsk->comm, sizeof(tsk->comm));
+	strlcpy(buf, tsk->comm, TASK_COMM_LEN);
 	task_unlock(tsk);
 	return buf;
 }
@@ -921,7 +921,7 @@ char *get_task_comm(char *buf, struct task_struct *tsk)
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
+	strlcpy(tsk->comm, buf, TASK_COMM_LEN);
 	task_unlock(tsk);
 	perf_counter_comm(tsk);
 }
@@ -930,7 +930,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 {
 	char * name;
 	int i, ch, retval;
-	char tcomm[sizeof(current->comm)];
+	char tcomm[TASK_COMM_LEN];
 
 	/*
 	 * Make sure we have a private signal table and that
-- 
1.6.3.1

