Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZHBTlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZHBTlc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZHBTlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:41:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbZHBTla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:41:30 -0400
Date: Sun, 2 Aug 2009 19:40:56 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:core/rcu] rcu: Add diagnostic check for a possible CPU-hotplug race
Message-ID: <tip-7256cf0e83bf018be8a81806593aaef7f2437f0b@git.kernel.org>
Git-Commit-ID: 7256cf0e83bf018be8a81806593aaef7f2437f0b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 19:40:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7256cf0e83bf018be8a81806593aaef7f2437f0b
Gitweb:     http://git.kernel.org/tip/7256cf0e83bf018be8a81806593aaef7f2437f0b
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 2 Aug 2009 10:21:10 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 21:31:28 +0200

rcu: Add diagnostic check for a possible CPU-hotplug race

Complain if the RCU softirq code ever runs on a CPU that has
not yet been announced to RCU as being online.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3313244..b9b1928 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1132,6 +1132,8 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 
+	WARN_ON_ONCE(rdp->beenonline == 0);
+
 	/*
 	 * If an RCU GP has gone long enough, go check for dyntick
 	 * idle CPUs and, if needed, send resched IPIs.
