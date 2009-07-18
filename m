Return-Path: <linux-kernel-owner+w=401wt.eu-S1753039AbZGROZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbZGROZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZGROZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:25:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:54094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZGROZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:25:10 -0400
Date: Sat, 18 Jul 2009 14:24:27 GMT
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
Message-ID: <tip-292264ece1ffdc9dacc1af486e28ee91cc66fb2d@git.kernel.org>
Git-Commit-ID: 292264ece1ffdc9dacc1af486e28ee91cc66fb2d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:24:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  292264ece1ffdc9dacc1af486e28ee91cc66fb2d
Gitweb:     http://git.kernel.org/tip/292264ece1ffdc9dacc1af486e28ee91cc66fb2d
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 16:02:56 +0200

lockdep: Update memory usage introduced by BFS

Also account the BFS memory usage.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index b896f23..930335d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3429,7 +3429,8 @@ void __init lockdep_info(void)
 		sizeof(struct list_head) * CLASSHASH_SIZE +
 		sizeof(struct lock_list) * MAX_LOCKDEP_ENTRIES +
 		sizeof(struct lock_chain) * MAX_LOCKDEP_CHAINS +
-		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024);
+		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024 +
+		sizeof(struct circular_queue) + sizeof(bfs_accessed));
 
 	printk(" per task-struct memory footprint: %lu bytes\n",
 		sizeof(struct held_lock) * MAX_LOCK_DEPTH);
