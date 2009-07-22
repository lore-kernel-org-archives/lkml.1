Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZGVM7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZGVM7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZGVM7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:59:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:4308 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZGVM72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PlVXKboafgvt72B6iKzZidUltHkKoS7NmgeckOCq3FgG8xx2Eos7SNSkF3Jl9LGDuI
         wybH8CTKeKNF1/WUEfkTHUQ6tFXUQTPv06T5DhIQ8w+kCaSblxDAWEJ10O3qQjv72h3s
         4tKOFdOXayrMxAR4Sw9U8f9vOf6hqtCKqTndY=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [tip:core/locking 3/3] lockdep:add likely/unlikely annotations to BFS core routine
Date: Wed, 22 Jul 2009 20:58:33 +0800
Message-Id: <1248267513-4934-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1248267513-4934-3-git-send-email-tom.leiming@gmail.com>
References: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
 <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
 <1248267513-4934-3-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1583439..2bf49ae 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -951,18 +951,18 @@ static int __bfs(struct lock_list *source_entry,
 	else
 		head = &source_entry->class->locks_before;
 
-	if (list_empty(head))
+	if (unlikely(list_empty(head)))
 		goto exit;
 
 	__cq_init(cq);
 	__cq_enqueue(cq, (unsigned long)source_entry);
 
-	while (!__cq_empty(cq)) {
+	while (likely(!__cq_empty(cq))) {
 		struct lock_list *lock;
 
 		__cq_dequeue(cq, (unsigned long *)&lock);
 
-		if (!lock->class) {
+		if (unlikely(!lock->class)) {
 			ret = -2;
 			goto exit;
 		}
@@ -982,12 +982,12 @@ static int __bfs(struct lock_list *source_entry,
 					goto exit;
 				}
 
-				if (__cq_enqueue(cq, (unsigned long)entry)) {
+				if (unlikely(__cq_enqueue(cq, (unsigned long)entry))) {
 					ret = -1;
 					goto exit;
 				}
 				cq_depth = __cq_get_elem_count(cq);
-				if (max_bfs_queue_depth < cq_depth)
+				if (unlikely(max_bfs_queue_depth < cq_depth))
 					max_bfs_queue_depth = cq_depth;
 			}
 		}
-- 
1.6.0.GIT

