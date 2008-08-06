Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbYHFPky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbYHFPky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759517AbYHFPjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:39:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbYHFPjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:39:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/24] CRED: Rename is_single_threaded() to
	is_wq_single_threaded() [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:26 +0100
Message-ID: <20080806153826.14351.77173.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename is_single_threaded() to is_wq_single_threaded() so that a new
is_single_threaded() can be created that refers to tasks rather than
waitqueues.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
---

 kernel/workqueue.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4a26a13..e4e2bd3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -83,21 +83,21 @@ static cpumask_t cpu_singlethread_map __read_mostly;
 static cpumask_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
-static inline int is_single_threaded(struct workqueue_struct *wq)
+static inline int is_wq_single_threaded(struct workqueue_struct *wq)
 {
 	return wq->singlethread;
 }
 
 static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
 {
-	return is_single_threaded(wq)
+	return is_wq_single_threaded(wq)
 		? &cpu_singlethread_map : &cpu_populated_map;
 }
 
 static
 struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
 {
-	if (unlikely(is_single_threaded(wq)))
+	if (unlikely(is_wq_single_threaded(wq)))
 		cpu = singlethread_cpu;
 	return per_cpu_ptr(wq->cpu_wq, cpu);
 }
@@ -767,7 +767,7 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	struct workqueue_struct *wq = cwq->wq;
-	const char *fmt = is_single_threaded(wq) ? "%s" : "%s/%d";
+	const char *fmt = is_wq_single_threaded(wq) ? "%s" : "%s/%d";
 	struct task_struct *p;
 
 	p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);

