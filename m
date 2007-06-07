Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbXFGQGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbXFGQGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbXFGQFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:05:53 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32844 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbXFGQFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:05:51 -0400
Date: Thu, 7 Jun 2007 09:05:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, akpm@linuxfoundation.org, dipankar@in.ibm.com
Subject: [PATCH] Document the fact that RCU callbacks can run in parallel
Message-ID: <20070607160549.GA27243@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add an item to the RCU documentation checklist noting that RCU callbacks
can run in parallel.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 checklist.txt |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.21/Documentation/RCU/checklist.txt linux-2.6.21-RCUdoc/Documentation/RCU/checklist.txt
--- linux-2.6.21/Documentation/RCU/checklist.txt	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-RCUdoc/Documentation/RCU/checklist.txt	2007-06-07 08:58:52.000000000 -0700
@@ -222,7 +222,15 @@ over a rather long period of time, but i
 	deadlock as soon as the RCU callback happens to interrupt that
 	acquisition's critical section.
 
-13.	SRCU (srcu_read_lock(), srcu_read_unlock(), and synchronize_srcu())
+13.	RCU callbacks can be and are executed in parallel.  In many cases,
+	the callback code simply wrappers around kfree(), so that this
+	is not an issue (or, more accurately, to the extent that it is
+	an issue, the memory-allocator locking handles it).  However,
+	if the callbacks do manipulate a shared data structure, they
+	must use whatever locking or other synchronization is required
+	to safely access and/or modify that data structure.
+
+14.	SRCU (srcu_read_lock(), srcu_read_unlock(), and synchronize_srcu())
 	may only be invoked from process context.  Unlike other forms of
 	RCU, it -is- permissible to block in an SRCU read-side critical
 	section (demarked by srcu_read_lock() and srcu_read_unlock()),
