Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZLCNXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZLCNXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbZLCNXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:23:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:32865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996AbZLCNXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:23:13 -0500
Date: Thu, 3 Dec 2009 13:22:42 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
In-Reply-To: <12597846162906-git-send-email->
References: <12597846162906-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Make RCU's CPU-stall detector be default
Message-ID: <tip-8bfb2f8e655b9d0c45fde679fcd5fd97e34513db@git.kernel.org>
Git-Commit-ID: 8bfb2f8e655b9d0c45fde679fcd5fd97e34513db
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bfb2f8e655b9d0c45fde679fcd5fd97e34513db
Gitweb:     http://git.kernel.org/tip/8bfb2f8e655b9d0c45fde679fcd5fd97e34513db
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 2 Dec 2009 12:10:16 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Dec 2009 11:35:27 +0100

rcu: Make RCU's CPU-stall detector be default

The RCU_CPU_STALL_DETECTOR costs almost nothing and has located
some bugs that might otherwise have been difficult to track
down.  Make it be default for the TREE RCU implementations.

The vmlinux size impact is limited (on 64-bit x86 defconfig):

   text	   data	    bss	    dec	    hex	filename
   8440248	1260076	 995588	10695912	 a334e8	vmlinux.before
   8440774	1260060	 995588	10696422	 a336e6	vmlinux.after

+526 bytes - acceptable default cost.

For RAM starved systems, TINY_RCU does not support CPU-stall detection
and is much smaller, but then again it is a uniprocessor...

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12597846162906-git-send-email->
[ v2: added image size calculations to the changelog ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8911558..50e0e78 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -749,7 +749,7 @@ config RCU_TORTURE_TEST_RUNNABLE
 config RCU_CPU_STALL_DETECTOR
 	bool "Check for stalled CPUs delaying RCU grace periods"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
-	default n
+	default y
 	help
 	  This option causes RCU to printk information on which
 	  CPUs are delaying the current grace period, but only when
