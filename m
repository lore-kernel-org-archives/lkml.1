Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZLJAzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZLJAzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZLJAzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:55:00 -0500
Received: from www.tglx.de ([62.245.132.106]:54095 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759211AbZLJAyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:54:24 -0500
Message-Id: <20091210004703.308396881@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 10 Dec 2009 00:53:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Vegard Nossum <vegardno@ifi.uio.no>
Subject: [patch 8/9] Documentation: Fix invalid rcu assumptions
References: <20091210001308.247025548@linutronix.de>
Content-Disposition: inline; filename=documentation-fix-rcu-assumptions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) spinlock held is not equivalent to rcu_read_lock()

2) remove the stale signal code snippet

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Cc: James Morris <jmorris@namei.org>
---
 Documentation/credentials.txt |    3 ---
 Documentation/kmemcheck.txt   |    3 +--
 2 files changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6-tip/Documentation/credentials.txt
===================================================================
--- linux-2.6-tip.orig/Documentation/credentials.txt
+++ linux-2.6-tip/Documentation/credentials.txt
@@ -408,9 +408,6 @@ This should be used inside the RCU read 
 		...
 	}
 
-A function need not get RCU read lock to use __task_cred() if it is holding a
-spinlock at the time as this implicitly holds the RCU read lock.
-
 Should it be necessary to hold another task's credentials for a long period of
 time, and possibly to sleep whilst doing so, then the caller should get a
 reference on them using:
Index: linux-2.6-tip/Documentation/kmemcheck.txt
===================================================================
--- linux-2.6-tip.orig/Documentation/kmemcheck.txt
+++ linux-2.6-tip/Documentation/kmemcheck.txt
@@ -429,8 +429,7 @@ Let's take a look at it:
 193         /*
 194          * We won't get problems with the target's UID changing under us
 195          * because changing it requires RCU be used, and if t != current, the
-196          * caller must be holding the RCU readlock (by way of a spinlock) and
-197          * we use RCU protection here
+196          * caller must be holding the RCU readlocke
 198          */
 199         user = get_uid(__task_cred(t)->user);
 200         atomic_inc(&user->sigpending);


