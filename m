Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZBKVQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZBKVQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757915AbZBKVPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:15:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36187 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757880AbZBKVPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:15:04 -0500
Date: Wed, 11 Feb 2009 22:12:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/4] tracehook_notify_death: use task_detached() helper
Message-ID: <20090211211228.GA16867@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that task_detached() is exported, change tracehook_notify_death()
to use this helper, nobody else checks ->exit_signal == -1 by hand.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/include/linux/tracehook.h~5_NOTIFY_USE_HELPER	2008-10-10 00:13:53.000000000 +0200
+++ 6.29-rc3/include/linux/tracehook.h	2009-02-11 21:54:57.000000000 +0100
@@ -507,7 +507,7 @@ static inline int tracehook_notify_jctl(
 static inline int tracehook_notify_death(struct task_struct *task,
 					 void **death_cookie, int group_dead)
 {
-	if (task->exit_signal == -1)
+	if (task_detached(task))
 		return task->ptrace ? SIGCHLD : DEATH_REAP;
 
 	/*

