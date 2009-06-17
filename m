Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZFQQhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZFQQhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbZFQQhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:37:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:51967 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbZFQQhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:37:19 -0400
Date: Wed, 17 Jun 2009 16:36:44 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, efault@gmx.de, mzxreary@0pointer.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, peterz@infradead.org, mzxreary@0pointer.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245228482.27326.1.camel@marge.simson.net>
References: <1245228482.27326.1.camel@marge.simson.net>
Subject: [tip:sched/core] sched: Add SCHED_RESET_ON_FORK functionality for nice < 0 tasks
Message-ID: <tip-6c697bdf08a09ce461e305a22362973036e95db3@git.kernel.org>
Git-Commit-ID: 6c697bdf08a09ce461e305a22362973036e95db3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 16:36:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c697bdf08a09ce461e305a22362973036e95db3
Gitweb:     http://git.kernel.org/tip/6c697bdf08a09ce461e305a22362973036e95db3
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 17 Jun 2009 10:48:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Jun 2009 18:34:18 +0200

sched: Add SCHED_RESET_ON_FORK functionality for nice < 0 tasks

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Lennart Poettering <mzxreary@0pointer.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1245228482.27326.1.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 50e4e3d..34f9424 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2627,6 +2627,11 @@ void sched_fork(struct task_struct *p, int clone_flags)
 		if (p->normal_prio < DEFAULT_PRIO)
 			p->prio = DEFAULT_PRIO;
 
+		if (PRIO_TO_NICE(p->static_prio) < 0) {
+			p->static_prio = NICE_TO_PRIO(0);
+			set_load_weight(p);
+		}
+
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
 		 * fulfilled its duty:
