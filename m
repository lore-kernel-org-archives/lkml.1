Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZLIJxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZLIJxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZLIJxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:53:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:45045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbZLIJxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:53:47 -0500
Date: Wed, 9 Dec 2009 09:53:21 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove sysctl.sched_features
Message-ID: <tip-6b314d0e11924c803bf8cd944e87fd58cdb5088c@git.kernel.org>
Git-Commit-ID: 6b314d0e11924c803bf8cd944e87fd58cdb5088c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b314d0e11924c803bf8cd944e87fd58cdb5088c
Gitweb:     http://git.kernel.org/tip/6b314d0e11924c803bf8cd944e87fd58cdb5088c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 2 Dec 2009 18:58:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:01 +0100

sched: Remove sysctl.sched_features

Since we've had a much saner debugfs interface to this, remove the
sysctl one.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
[ v2: build fix ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    1 -
 kernel/sysctl.c       |    8 --------
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9b24027..ca72ed4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1905,7 +1905,6 @@ extern unsigned int sysctl_sched_shares_ratelimit;
 extern unsigned int sysctl_sched_shares_thresh;
 extern unsigned int sysctl_sched_child_runs_first;
 #ifdef CONFIG_SCHED_DEBUG
-extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4dbf93a..e5cc535 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -316,14 +316,6 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_features",
-		.data		= &sysctl_sched_features,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_migration_cost",
 		.data		= &sysctl_sched_migration_cost,
 		.maxlen		= sizeof(unsigned int),
