Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbYHAVTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbYHAVTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760616AbYHAVLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:11:19 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59340 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761060AbYHAVLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:11:14 -0400
Date: Fri, 1 Aug 2008 14:11:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, dipankar@in.ibm.com, bunk@kernel.org
Subject: [PATCH] remove list_for_each_rcu()
Message-ID: <20080801211105.GA14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

All of the in-tree uses of list_for_each_rcu() have been converted to
list_for_each_entry_rcu(), so list_for_each_rcu() can now be removed.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Documentation/RCU/checklist.txt |    2 +-
 Documentation/RCU/whatisRCU.txt |    2 --
 include/linux/rculist.h         |   14 --------------
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index cf5562c..6e25340 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -210,7 +210,7 @@ over a rather long period of time, but improvements are always welcome!
 		number of updates per grace period.
 
 9.	All RCU list-traversal primitives, which include
-	rcu_dereference(), list_for_each_rcu(), list_for_each_entry_rcu(),
+	rcu_dereference(), list_for_each_entry_rcu(),
 	list_for_each_continue_rcu(), and list_for_each_safe_rcu(),
 	must be either within an RCU read-side critical section or
 	must be protected by appropriate update-side locks.  RCU
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index e04d643..9617082 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -786,8 +786,6 @@ RCU pointer/list traversal:
 	list_for_each_entry_rcu
 	hlist_for_each_entry_rcu
 
-	list_for_each_rcu		(to be deprecated in favor of
-					 list_for_each_entry_rcu)
 	list_for_each_continue_rcu	(to be deprecated in favor of new
 					 list_for_each_entry_continue_rcu)
 
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index b0f39be..25dc894 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -170,20 +170,6 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	at->prev = last;
 }
 
-/**
- * list_for_each_rcu	-	iterate over an rcu-protected list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_rcu(pos, head) \
-	for (pos = rcu_dereference((head)->next); \
-		prefetch(pos->next), pos != (head); \
-		pos = rcu_dereference(pos->next))
-
 #define __list_for_each_rcu(pos, head) \
 	for (pos = rcu_dereference((head)->next); \
 		pos != (head); \
