Return-Path: <linux-kernel-owner+w=401wt.eu-S935149AbZLPSiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935149AbZLPSiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935135AbZLPSiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:38:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:53435 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935112AbZLPSiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:38:01 -0500
Date: Wed, 16 Dec 2009 18:37:21 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170517.653578430@chello.nl>
References: <20091216170517.653578430@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Select_task_rq_fair() must honour SD_LOAD_BALANCE
Message-ID: <tip-e4f4288842ee12747e10c354d72be7d424c0b627@git.kernel.org>
Git-Commit-ID: e4f4288842ee12747e10c354d72be7d424c0b627
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4f4288842ee12747e10c354d72be7d424c0b627
Gitweb:     http://git.kernel.org/tip/e4f4288842ee12747e10c354d72be7d424c0b627
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 18:04:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:55 +0100

sched: Select_task_rq_fair() must honour SD_LOAD_BALANCE

We should skip !SD_LOAD_BALANCE domains.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.653578430@chello.nl>
CC: stable@kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5bedf6e..ec1d271 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1429,6 +1429,9 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	}
 
 	for_each_domain(cpu, tmp) {
+		if (!(tmp->flags & SD_LOAD_BALANCE))
+			continue;
+
 		/*
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.
