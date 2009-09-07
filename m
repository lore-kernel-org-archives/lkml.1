Return-Path: <linux-kernel-owner+w=401wt.eu-S1751901AbZIGUht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbZIGUht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 16:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbZIGUht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 16:37:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:50460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZIGUhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 16:37:48 -0400
Date: Mon, 7 Sep 2009 20:37:14 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Remove short cut from select_task_rq_fair()
Message-ID: <tip-cdd2ab3de4301728b20efd6225681d3ff591a938@git.kernel.org>
Git-Commit-ID: cdd2ab3de4301728b20efd6225681d3ff591a938
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 07 Sep 2009 20:37:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cdd2ab3de4301728b20efd6225681d3ff591a938
Gitweb:     http://git.kernel.org/tip/cdd2ab3de4301728b20efd6225681d3ff591a938
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 7 Sep 2009 18:12:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Sep 2009 20:39:05 +0200

sched: Remove short cut from select_task_rq_fair()

select_task_rq_fair() incorrectly skips the wake_affine()
logic, remove this.

When prev_cpu == this_cpu, the code jumps straight to the
wake_idle() logic, this doesn't give the wake_affine() logic
the chance to pin the task to this cpu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 2ff850f..d7fda41 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1305,8 +1305,6 @@ static int select_task_rq_fair(struct task_struct *p, int sync)
 	this_rq		= cpu_rq(this_cpu);
 	new_cpu		= prev_cpu;
 
-	if (prev_cpu == this_cpu)
-		goto out;
 	/*
 	 * 'this_sd' is the first domain that both
 	 * this_cpu and prev_cpu are present in:
