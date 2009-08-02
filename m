Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZHBNEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZHBNEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZHBNEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:04:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:56493 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbZHBNEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:04:01 -0400
Date: Sun, 2 Aug 2009 13:03:28 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, tom.leiming@gmail.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:core/locking] lockdep: Fix BFS build
Message-ID: <tip-bbfa26229a8143889e95e0df4a9d69067ee836cd@git.kernel.org>
Git-Commit-ID: bbfa26229a8143889e95e0df4a9d69067ee836cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:03:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbfa26229a8143889e95e0df4a9d69067ee836cd
Gitweb:     http://git.kernel.org/tip/bbfa26229a8143889e95e0df4a9d69067ee836cd
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 2 Aug 2009 14:44:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 14:51:06 +0200

lockdep: Fix BFS build

Fix:

  kernel/built-in.o: In function `lockdep_stats_show':
  lockdep_proc.c:(.text+0x48202): undefined reference to `max_bfs_queue_depth'

As max_bfs_queue_depth is only available under
CONFIG_PROVE_LOCKING=y.

Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep_proc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 9a1bf34..fba81f1 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -411,8 +411,10 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			max_lockdep_depth);
 	seq_printf(m, " max recursion depth:           %11u\n",
 			max_recursion_depth);
+#ifdef CONFIG_PROVE_LOCKING
 	seq_printf(m, " max bfs queue depth:           %11u\n",
 			max_bfs_queue_depth);
+#endif
 	lockdep_stats_debug_show(m);
 	seq_printf(m, " debug_locks:                   %11u\n",
 			debug_locks);
