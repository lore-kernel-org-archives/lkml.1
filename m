Return-Path: <linux-kernel-owner+w=401wt.eu-S935127AbZLPShQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbZLPShQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932220AbZLPShN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:37:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:53394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbZLPShK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:37:10 -0500
Date: Wed, 16 Dec 2009 18:36:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170517.423469527@chello.nl>
References: <20091216170517.423469527@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Mark boot-cpu active before smp_init()
Message-ID: <tip-933b0618d8b2a59c7a0742e43836544e02f1e9bd@git.kernel.org>
Git-Commit-ID: 933b0618d8b2a59c7a0742e43836544e02f1e9bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  933b0618d8b2a59c7a0742e43836544e02f1e9bd
Gitweb:     http://git.kernel.org/tip/933b0618d8b2a59c7a0742e43836544e02f1e9bd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 18:04:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:53 +0100

sched: Mark boot-cpu active before smp_init()

A UP machine has 1 active cpu, not having the boot-cpu in the
active map when starting the scheduler confuses things.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.423469527@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/main.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/init/main.c b/init/main.c
index c3db4a9..dac44a9 100644
--- a/init/main.c
+++ b/init/main.c
@@ -369,12 +369,6 @@ static void __init smp_init(void)
 {
 	unsigned int cpu;
 
-	/*
-	 * Set up the current CPU as possible to migrate to.
-	 * The other ones will be done by cpu_up/cpu_down()
-	 */
-	set_cpu_active(smp_processor_id(), true);
-
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
@@ -486,6 +480,7 @@ static void __init boot_cpu_init(void)
 	int cpu = smp_processor_id();
 	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
 	set_cpu_online(cpu, true);
+	set_cpu_active(cpu, true);
 	set_cpu_present(cpu, true);
 	set_cpu_possible(cpu, true);
 }
