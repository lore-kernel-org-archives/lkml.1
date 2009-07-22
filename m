Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbZGVM7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbZGVM7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 08:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZGVM7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 08:59:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:1717 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbZGVM7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F2gCLSwhMye1lKiGx3R2F8ReetxsSLASvqrk7tFWV7gXyg43jfD+lo5CG6cgAqYPtO
         BKYs85oCaRzDFdv9F1THVphO4UvXmbAaF1xw+qART72MG50hVcP0WKoHoRAPDvGrRyLk
         /M0T6NoCGoGHbnJFfjJWNmBL79rUfyvOzR47c=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: [tip:core/locking 2/3] lockdep:define preallocated "stack" for BFS as per cpu variable
Date: Wed, 22 Jul 2009 20:58:32 +0800
Message-Id: <1248267513-4934-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
References: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
 <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 1b1796a..1583439 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -847,7 +847,7 @@ struct circular_queue {
 	unsigned int  front, rear;
 };
 
-static struct circular_queue lock_cq;
+static DEFINE_PER_CPU(struct circular_queue, lock_cq);
 
 unsigned int max_bfs_queue_depth;
 
@@ -937,7 +937,7 @@ static int __bfs(struct lock_list *source_entry,
 {
 	struct lock_list *entry;
 	struct list_head *head;
-	struct circular_queue *cq = &lock_cq;
+	struct circular_queue *cq = &get_cpu_var(lock_cq);
 	int ret = 1;
 
 	if (match(source_entry, data)) {
@@ -993,6 +993,7 @@ static int __bfs(struct lock_list *source_entry,
 		}
 	}
 exit:
+	put_cpu_var(lock_cq);
 	return ret;
 }
 
-- 
1.6.0.GIT

