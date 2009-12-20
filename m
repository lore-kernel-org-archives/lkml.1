Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbZLTQhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbZLTQhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 11:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZLTQhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 11:37:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:47778 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbZLTQhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 11:37:08 -0500
Subject: [PATCH] sched: Fix hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20091220145715.GZ4489@kernel.dk>
References: <4B2DF699.3090107@in.ibm.com> <1261315887.4314.8.camel@laptop>
	 <20091220145151.GY4489@kernel.dk> <1261320896.4314.10.camel@laptop>
	 <20091220145715.GZ4489@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 17:36:27 +0100
Message-ID: <1261326987.4314.24.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hot-unplug kstopmachine usage does a wakeup after deactivating the
cpu, hence we cannot use cpu_active() here but must rely on the good
olde online.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 720df10..0ac4fa5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2348,7 +2348,7 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 	 *   not worry about this generic constraint ]
 	 */
 	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
-		     !cpu_active(cpu)))
+		     !cpu_online(cpu)))
 		cpu = select_fallback_rq(task_cpu(p), p);
 
 	return cpu;


