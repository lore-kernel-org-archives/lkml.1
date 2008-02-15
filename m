Return-Path: <linux-kernel-owner+w=401wt.eu-S1765480AbYBOE7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765480AbYBOE7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 23:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761540AbYBOE7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 23:59:24 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:52690 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYBOE7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 23:59:14 -0500
Date: Thu, 14 Feb 2008 23:57:48 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] rcu_batches_completed prototype cleanup
Message-ID: <Pine.LNX.4.58.0802142335280.17968@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rcu_batches_completed and rcu_patches_completed_bh are both declared
in rcuclassic.h and rcupreempt.h. This patch removes the extra
prototypes for them from rcupdate.h.

rcu_batches_completed_bh is defined as a static inline in the rcupreempt.h
header file. Trying to export this as EXPORT_SYMBOL_GPL causes section
problems with the powerpc compiler. There's no need to export a static
inlined function.

Modules must be compiled with the same type of RCU implementation as the
kernel they are for.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/rcupdate.h |    2 --
 kernel/rcupreempt.c      |    2 --
 2 files changed, 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 37a642c..ae5ba4e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -238,8 +238,6 @@ extern void call_rcu_bh(struct rcu_head *head,
 /* Exported common interfaces */
 extern void synchronize_rcu(void);
 extern void rcu_barrier(void);
-extern long rcu_batches_completed(void);
-extern long rcu_batches_completed_bh(void);

 /* Internal to kernel */
 extern void rcu_init(void);
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 987cfb7..bdd0a1d 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -213,8 +213,6 @@ long rcu_batches_completed(void)
 }
 EXPORT_SYMBOL_GPL(rcu_batches_completed);

-EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
-
 void __rcu_read_lock(void)
 {
 	int idx;

