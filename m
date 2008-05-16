Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYEPK5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYEPK5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 06:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYEPK5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 06:57:35 -0400
Received: from sacred.ru ([62.205.161.221]:57743 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYEPK5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 06:57:34 -0400
Message-ID: <482D6803.60205@openvz.org>
Date: Fri, 16 May 2008 14:54:59 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Bsdacct: stir up comments around acct_process.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 16 May 2008 14:57:20 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the one describing what this function is and add one
more - about locking absence around pid namespaces loop.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/kernel/acct.c b/kernel/acct.c
index 0feba97..d7b670c 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -657,7 +657,8 @@ static void acct_process_in_ns(struct pid_namespace *ns)
 }
 
 /**
- * acct_process - now just a wrapper around do_acct_process
+ * acct_process - now just a wrapper around acct_process_in_ns,
+ * which int turn is a wrapper around do_acct_process.
  *
  * handles process accounting for an exiting task
  */
@@ -665,6 +666,11 @@ void acct_process(void)
 {
 	struct pid_namespace *ns;
 
+	/*
+	 * This loop is safe lockless, since current it still
+	 * alive and holds its namespace, which in turn holds
+	 * its parent.
+	 */
 	for (ns = task_active_pid_ns(current); ns != NULL; ns = ns->parent)
 		acct_process_in_ns(ns);
 }
