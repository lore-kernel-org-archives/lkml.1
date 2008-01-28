Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbYA1MZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbYA1MZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760820AbYA1MZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:25:12 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55257 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760797AbYA1MZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:25:10 -0500
Date: Mon, 28 Jan 2008 04:25:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, dipankar@in.ibm.com
Subject: [PATCH] Add list_for_each_rcu to features-removal list
Message-ID: <20080128122500.GA32723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The list_for_each_entry_rcu() primitive should be used instead of
list_for_each_rcu(), as the former is easier to use and provides
better type safety.  This patch therefore adds list_for_each_rcu()
to the Documentation/feature-removal-schedule.txt file (for mid-2008)
and marks its comment header deprecated.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 include/linux/list.h                       |    5 ++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.24/Documentation/feature-removal-schedule.txt linux-2.6.24-dep-lfeRCU/Documentation/feature-removal-schedule.txt
--- linux-2.6.24/Documentation/feature-removal-schedule.txt	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24-dep-lfeRCU/Documentation/feature-removal-schedule.txt	2008-01-28 04:00:49.000000000 -0800
@@ -333,3 +333,13 @@ Why:	This driver has been marked obsolet
 Who:	Stephen Hemminger <shemminger@linux-foundation.org>
 
 ---------------------------
+
+What:	list_for_each_rcu() primitive
+When:	July 2008
+Files:	include/linux/list.h
+Why:	The list_for_each_entry_rcu() primitive should be used instead,
+	as it is less error-prone and provides better type safety.
+Who:	Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+---------------------------
+
diff -urpNa -X dontdiff linux-2.6.24/include/linux/list.h linux-2.6.24-dep-lfeRCU/include/linux/list.h
--- linux-2.6.24/include/linux/list.h	2008-01-24 14:58:37.000000000 -0800
+++ linux-2.6.24-dep-lfeRCU/include/linux/list.h	2008-01-28 04:06:52.000000000 -0800
@@ -622,13 +622,16 @@ static inline void list_splice_init_rcu(
 	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
 
 /**
- * list_for_each_rcu	-	iterate over an rcu-protected list
+ * list_for_each_rcu - iterate over an rcu-protected list: DEPRECATED
  * @pos:	the &struct list_head to use as a loop cursor.
  * @head:	the head for your list.
  *
  * This list-traversal primitive may safely run concurrently with
  * the _rcu list-mutation primitives such as list_add_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
+ *
+ * DEPRECATED: please use list_for_each_entry_rcu() instead: it is
+ * easier to use and also provides better type safety.
  */
 #define list_for_each_rcu(pos, head) \
 	for (pos = (head)->next; \
