Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbZLJIol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbZLJIol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbZLJIoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:44:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:51749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087AbZLJIoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:44:37 -0500
Date: Thu, 10 Dec 2009 08:43:49 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix build warning in get_update_sysctl_factor()
Message-ID: <tip-4ca3ef71f54655af98b66e8ff308a47a2a580a53@git.kernel.org>
Git-Commit-ID: 4ca3ef71f54655af98b66e8ff308a47a2a580a53
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ca3ef71f54655af98b66e8ff308a47a2a580a53
Gitweb:     http://git.kernel.org/tip/4ca3ef71f54655af98b66e8ff308a47a2a580a53
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 10 Dec 2009 09:25:53 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 09:34:50 +0100

sched: Fix build warning in get_update_sysctl_factor()

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <new-submission>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0a60e8e..3de3dea 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7033,7 +7033,7 @@ cpumask_var_t nohz_cpu_mask;
  */
 static int get_update_sysctl_factor(void)
 {
-	unsigned int cpus = min(num_online_cpus(), 8);
+	unsigned int cpus = min_t(int, num_online_cpus(), 8);
 	unsigned int factor;
 
 	switch (sysctl_sched_tunable_scaling) {
