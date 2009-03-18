Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZCRL6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZCRL6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZCRL6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:58:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:55535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbZCRL6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:58:01 -0400
Date: Wed, 18 Mar 2009 11:57:31 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237376327.5069.253.camel@laptop>
References: <1237376327.5069.253.camel@laptop>
Subject: [tip:core/locking] lockdep: add stack dumps to asserts
Message-ID: <tip-465499895e41ee15ebc75fe90dfe7b595e9b46d5@git.kernel.org>
Git-Commit-ID: 465499895e41ee15ebc75fe90dfe7b595e9b46d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 11:57:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  465499895e41ee15ebc75fe90dfe7b595e9b46d5
Gitweb:     http://git.kernel.org/tip/465499895e41ee15ebc75fe90dfe7b595e9b46d5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 18 Mar 2009 12:38:47 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 12:55:10 +0100

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
index 9a1e2bc..77ac37f 100644
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
@@ -2523,6 +2526,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		debug_locks_off();
 		printk("BUG: MAX_LOCKDEP_SUBCLASSES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 
@@ -2619,6 +2623,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		debug_locks_off();
 		printk("BUG: MAX_LOCK_DEPTH too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 
