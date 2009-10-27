Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZJ0OBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZJ0OBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbZJ0OBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:01:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:55761 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbZJ0OBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:01:38 -0400
Date: Tue, 27 Oct 2009 14:00:50 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12565906642768-git-send-email->
References: <12565906642768-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Fix TINY_RCU #elif condition
Message-ID: <tip-2c28e2451dba2260e9f88811b29a7787db7e7616@git.kernel.org>
Git-Commit-ID: 2c28e2451dba2260e9f88811b29a7787db7e7616
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c28e2451dba2260e9f88811b29a7787db7e7616
Gitweb:     http://git.kernel.org/tip/2c28e2451dba2260e9f88811b29a7787db7e7616
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 26 Oct 2009 13:57:44 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 27 Oct 2009 14:59:28 +0100

rcu: Fix TINY_RCU #elif condition

Some compilers are happy with "#elif CONFIG_RCU_TINY", while
others strongly prefer "#elif defined(CONFIG_RCU_TINY)".  Change
to the latter to make more compilers happy.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12565906642768-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcupdate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6dd71fa..2f1bc42 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -77,7 +77,7 @@ extern int rcu_scheduler_active;
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
-#elif CONFIG_TINY_RCU
+#elif defined(CONFIG_TINY_RCU)
 #include <linux/rcutiny.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
