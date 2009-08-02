Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbZHBNxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbZHBNxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZHBNxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:53:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:50232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZHBNxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:53:31 -0400
Date: Sun, 2 Aug 2009 13:52:48 GMT
From: tip-bot for Ming Lei <tom.leiming@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, tom.leiming@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, tom.leiming@gmail.com, mingo@elte.hu
In-Reply-To: <1249220616-7190-1-git-send-email-tom.leiming@gmail.com>
References: <1249220616-7190-1-git-send-email-tom.leiming@gmail.com>
Subject: [tip:core/locking] lockdep: Fix memory usage info of BFS
Message-ID: <tip-90629209a020859b67423a6326f3765f220c7f5c@git.kernel.org>
Git-Commit-ID: 90629209a020859b67423a6326f3765f220c7f5c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:53:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90629209a020859b67423a6326f3765f220c7f5c
Gitweb:     http://git.kernel.org/tip/90629209a020859b67423a6326f3765f220c7f5c
Author:     Ming Lei <tom.leiming@gmail.com>
AuthorDate: Sun, 2 Aug 2009 21:43:36 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 15:45:28 +0200

lockdep: Fix memory usage info of BFS

The unit is KB, so sizeof(struct circular_queue) should be
divided by 1024.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org
Cc: davem@davemloft.net
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: a.p.zijlstra@chello.nl
LKML-Reference: <1249220616-7190-1-git-send-email-tom.leiming@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2b443b5..0843584 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3603,10 +3603,11 @@ void __init lockdep_info(void)
 		sizeof(struct list_head) * CLASSHASH_SIZE +
 		sizeof(struct lock_list) * MAX_LOCKDEP_ENTRIES +
 		sizeof(struct lock_chain) * MAX_LOCKDEP_CHAINS +
-		sizeof(struct list_head) * CHAINHASH_SIZE) / 1024
+		sizeof(struct list_head) * CHAINHASH_SIZE
 #ifdef CONFIG_PROVE_LOCKING
 		+ sizeof(struct circular_queue)
 #endif
+		) / 1024
 		);
 
 	printk(" per task-struct memory footprint: %lu bytes\n",
