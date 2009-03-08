Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZCHALz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZCHALz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 19:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZCHALn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 19:11:43 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58655 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbZCHALn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 19:11:43 -0500
Date: Sat, 7 Mar 2009 16:11:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       niv@us.ibm.com, dvhltc@us.ibm.com
Subject: [PATCH] RCU documentation 1Q09 update
Message-ID: <20090308001138.GA15335@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the RCU documentation to call out the need for callers of
primitives like call_rcu() and synchronize_rcu() to prevent subsequent
RCU readers from hazard.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 checklist.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 6e25340..accfe2f 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -298,3 +298,15 @@ over a rather long period of time, but improvements are always welcome!
 
 	Note that, rcu_assign_pointer() and rcu_dereference() relate to
 	SRCU just as they do to other forms of RCU.
+
+15.	The whole point of call_rcu(), synchronize_rcu(), and friends
+	is to wait until all pre-existing readers have finished before
+	carrying out some otherwise-destructive operation.  It is
+	therefore critically important to -first- remove any path
+	that readers can follow that could be affected by the
+	destructive operation, and -only- -then- invoke call_rcu(),
+	synchronize_rcu(), or friends.
+
+	Because these primitives only wait for pre-existing readers,
+	it is the caller's responsibility to guarantee safety to
+	any subsequent readers.
