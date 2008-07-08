Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYGHQ6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYGHQ6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYGHQ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:57:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:55109 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbYGHQ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:57:29 -0400
Date: Tue, 8 Jul 2008 09:47:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu
Subject: [patch 7/17] use WARN() in kernel/lockdep.c
Message-ID: <20080708094726.4111959d@infradead.org>
In-Reply-To: <20080708093800.274504ba@infradead.org>
References: <20080708093800.274504ba@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Use WARN instead of printk+WARN_ON in kernel/lockdep.c

Use WARN() instead of a printk+WARN_ON() pair; this way the message
becomes part of the warning section for better reporting/collection.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/lockdep.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux.trees.git/kernel/lockdep.c
===================================================================
--- linux.trees.git.orig/kernel/lockdep.c
+++ linux.trees.git/kernel/lockdep.c
@@ -1643,11 +1643,10 @@ static void check_chain_key(struct task_
 		hlock = curr->held_locks + i;
 		if (chain_key != hlock->prev_chain_key) {
 			debug_locks_off();
-			printk("hm#1, depth: %u [%u], %016Lx != %016Lx\n",
+			WARN(1, "hm#1, depth: %u [%u], %016Lx != %016Lx\n",
 				curr->lockdep_depth, i,
 				(unsigned long long)chain_key,
 				(unsigned long long)hlock->prev_chain_key);
-			WARN_ON(1);
 			return;
 		}
 		id = hlock->class - lock_classes;
@@ -1662,11 +1661,10 @@ static void check_chain_key(struct task_
 	}
 	if (chain_key != curr->curr_chain_key) {
 		debug_locks_off();
-		printk("hm#2, depth: %u [%u], %016Lx != %016Lx\n",
+		WARN(1, "hm#2, depth: %u [%u], %016Lx != %016Lx\n",
 			curr->lockdep_depth, i,
 			(unsigned long long)chain_key,
 			(unsigned long long)curr->curr_chain_key);
-		WARN_ON(1);
 	}
 #endif
 }
