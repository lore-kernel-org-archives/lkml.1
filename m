Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZEXO1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZEXO1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 10:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZEXO1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 10:27:16 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:39010 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbZEXO1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 10:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vGr7M0IXTZTRpA2zK+aNeDMjGaDNIcPHrGJHycXtpeK+WCxHmrkQEusOxiDT83Hd1v
         tPcyVDi6csG1X6HmkMqtx2e4FGH3Xz6wY1wUrRcvIWCyqUkvBFvsgvzJXXHfkaF3/lmE
         2cdnrJLlIsaDjOeMOTF5Jy7q+0FR7qpRq1XnM=
From: tom.leiming@gmail.com
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] kernel:lockdep:fix statistics for nr_cyclic_check_recursions/checks
Date: Sun, 24 May 2009 22:27:10 +0800
Message-Id: <1243175230-4703-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>


Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8bbeef9..1905357 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1062,7 +1062,7 @@ check_noncircular(struct lock_class *source, unsigned int depth)
 	if (lockdep_dependency_visit(source, depth))
 		return 1;
 
-	debug_atomic_inc(&nr_cyclic_check_recursions);
+	debug_atomic_inc(&nr_cyclic_check_checks);
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
 	if (depth >= RECURSION_LIMIT)
@@ -1073,7 +1073,7 @@ check_noncircular(struct lock_class *source, unsigned int depth)
 	list_for_each_entry(entry, &source->locks_after, entry) {
 		if (entry->class == hlock_class(check_target))
 			return print_circular_bug_header(entry, depth+1);
-		debug_atomic_inc(&nr_cyclic_checks);
+		debug_atomic_inc(&nr_cyclic_recursions);
 		if (!check_noncircular(entry->class, depth+1))
 			return print_circular_bug_entry(entry, depth+1);
 	}
-- 
1.6.0.GIT

