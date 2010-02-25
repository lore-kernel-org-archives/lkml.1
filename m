Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab0BYKQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:16:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:41079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab0BYKP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:15:59 -0500
Date: Thu, 25 Feb 2010 10:14:48 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, error27@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, error27@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1266887105-1528-20-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-20-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Fix rcutorture mod_timer argument to delay one jiffy
Message-ID: <tip-6155fec92e85f07d99e9746234496215443ffb0d@git.kernel.org>
Git-Commit-ID: 6155fec92e85f07d99e9746234496215443ffb0d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:14:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6155fec92e85f07d99e9746234496215443ffb0d
Gitweb:     http://git.kernel.org/tip/6155fec92e85f07d99e9746234496215443ffb0d
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:05:04 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:35:00 +0100

rcu: Fix rcutorture mod_timer argument to delay one jiffy

The current "mod_timer(&t, 1)" potentially makes the timer fire
immediately, change this to wait one jiffy.

Signed-off-by: Dan Carpenter <error27@gmail.com>
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
LKML-Reference: <1266887105-1528-20-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 5f43f30..258cdf0 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -853,7 +853,7 @@ rcu_torture_reader(void *arg)
 	do {
 		if (irqreader && cur_ops->irq_capable) {
 			if (!timer_pending(&t))
-				mod_timer(&t, 1);
+				mod_timer(&t, jiffies + 1);
 		}
 		idx = cur_ops->readlock();
 		completed = cur_ops->completed();
