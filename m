Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZHBNDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZHBNDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZHBNDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:03:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:56467 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZHBND3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:03:29 -0400
Date: Sun, 2 Aug 2009 13:02:51 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
In-Reply-To: <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
Subject: [tip:core/locking] lockdep: Update memory usage introduced by BFS
Message-ID: <tip-4dd861d6467007681991d8ec079d928db2018cbb@git.kernel.org>
Git-Commit-ID: 4dd861d6467007681991d8ec079d928db2018cbb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:02:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4dd861d6467007681991d8ec079d928db2018cbb
Gitweb:     http://git.kernel.org/tip/4dd861d6467007681991d8ec079d928db2018cbb
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Peter Zijlstra <a.p.zijlstra@chello.nl>
CommitDate: Fri, 24 Jul 2009 10:51:52 +0200

lockdep: Update memory usage introduced by BFS

Also account the BFS memory usage.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
[ fix build for !PROVE_LOCKING ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index b896f23..6358cf7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3429,7 +3429,11 @@ void __init lockdep_info(void)
 		sizeof(struct list_head) * CLASSHASH_SIZE +
 		sizeof(struct lock_list) * MAX_LOCKDEP_ENTRIES +
 		sizeof(struct lock_chain) * MAX_LOCKDEP_CHAINS +
-		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024);
+		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024
+#ifdef CONFIG_PROVE_LOCKING
+		+ sizeof(struct circular_queue) + sizeof(bfs_accessed)
+#endif
+		);
 
 	printk(" per task-struct memory footprint: %lu bytes\n",
 		sizeof(struct held_lock) * MAX_LOCK_DEPTH);
