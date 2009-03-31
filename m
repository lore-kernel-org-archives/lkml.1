Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbZCaM6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbZCaM6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbZCaM6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:58:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:40928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757806AbZCaM6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:58:20 -0400
Date: Tue, 31 Mar 2009 12:57:50 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237376327.5069.253.camel@laptop>
References: <1237376327.5069.253.camel@laptop>
Subject: [tip:core/locking] lockdep: add stack dumps to asserts
Message-ID: <tip-eedeeabdeeadb016b8c783e3620d06b98d0cb4e1@git.kernel.org>
Git-Commit-ID: eedeeabdeeadb016b8c783e3620d06b98d0cb4e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 31 Mar 2009 12:57:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eedeeabdeeadb016b8c783e3620d06b98d0cb4e1
Gitweb:     http://git.kernel.org/tip/eedeeabdeeadb016b8c783e3620d06b98d0cb4e1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 18 Mar 2009 12:38:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 31 Mar 2009 14:53:01 +0200

lockdep: add stack dumps to asserts

Have a better idea about exactly which loc causes a lockdep
limit overflow. Often it's a bug or inefficiency in that
subsystem.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1237376327.5069.253.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 981cd48..a288ae1 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -792,6 +792,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 
 		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return NULL;
 	}
 	class = lock_classes + nr_lock_classes++;
@@ -855,6 +856,7 @@ static struct lock_list *alloc_list_entry(void)
 
 		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return NULL;
 	}
 	return list_entries + nr_list_entries++;
@@ -1681,6 +1683,7 @@ cache_hit:
 
 		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 	chain = lock_chains + nr_lock_chains++;
@@ -2540,6 +2543,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		debug_locks_off();
 		printk("BUG: MAX_LOCKDEP_SUBCLASSES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 
@@ -2636,6 +2640,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		debug_locks_off();
 		printk("BUG: MAX_LOCK_DEPTH too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 
