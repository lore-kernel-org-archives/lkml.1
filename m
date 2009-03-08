Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZCHPzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZCHPzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 11:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZCHPy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 11:54:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:33798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZCHPy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 11:54:56 -0400
Date: Sun, 8 Mar 2009 15:54:24 GMT
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090308001138.GA15335@linux.vnet.ibm.com>
References: <20090308001138.GA15335@linux.vnet.ibm.com>
Subject: [tip:core/rcu] rcu: documentation 1Q09 update
Message-ID: <tip-26fe8c643f7ca90e3d9ee2bf3c5d3d83cca650ec@git.kernel.org>
Git-Commit-ID: 26fe8c643f7ca90e3d9ee2bf3c5d3d83cca650ec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 15:54:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26fe8c643f7ca90e3d9ee2bf3c5d3d83cca650ec
Gitweb:     http://git.kernel.org/tip/26fe8c643f7ca90e3d9ee2bf3c5d3d83cca650ec
Author:     "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 7 Mar 2009 16:11:38 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Mar 2009 16:53:04 +0100

rcu: documentation 1Q09 update

Update the RCU documentation to call out the need for callers of
primitives like call_rcu() and synchronize_rcu() to prevent subsequent
RCU readers from hazard.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org
Cc: dipankar@in.ibm.com
Cc: niv@us.ibm.com
Cc: dvhltc@us.ibm.com
LKML-Reference: <20090308001138.GA15335@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/RCU/checklist.txt |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

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
